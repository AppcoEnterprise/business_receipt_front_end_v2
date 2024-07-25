
import 'package:business_receipt/env/function/delay_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/refresh_page_env.dart';
import 'package:business_receipt/env/function/request_api/dio_config_request_api_env.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> getUpToDateAdminGlobal({required BuildContext context, required Function setStateFromOutside, required bool mounted}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  // loadingDialogGlobal(context: context, loadingTitle: updateGiveMoneyToMatStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_up_to_date_and_online_admin',
      queryParameters: {'admin_id': profileModelAdminGlobal!.id, "employee_id": (profileModelEmployeeGlobal == null) ? null : profileModelEmployeeGlobal!.id},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );
    final DateTime upToDate = DateTime.parse(response.data["up_to_date"]);
    if (upToDate.compareTo(upToDateGlobal!) == 0) {
      if (!response.data["is_online"]) {
        final bool isAdmin = profileModelEmployeeGlobal == null;
        connectSocketIO(context: context, setStateFromOutside: setStateFromOutside, mounted: mounted);
        if (isAdmin) {
          logInAsAdminSocketIO();
        } else {
          logInAsEmployeeSocketIO();
        }
      }
    } else {
      refreshPageGlobal();
    }
  }
}
