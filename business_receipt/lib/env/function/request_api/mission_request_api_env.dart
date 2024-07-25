
import 'package:business_receipt/env/function/error_from_api.dart';
import 'package:business_receipt/env/function/delay_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/request_api/dio_config_request_api_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/mission_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> updateMissionAdminGlobal({required Function callBack, required BuildContext context, required MissionModel missionModelTemp}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCustomerInformationStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_mission_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "mission": missionModelTemp.toJson(), "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context)   ;
    missionModelGlobal = missionModelFromJson(str: response.data["mission"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getMissionEmployeeGlobal({required Function callBack, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_mission_employee',
      queryParameters: {
        'admin_id': profileModelAdminGlobal!.id,
        'employee_id': profileModelEmployeeGlobal!.id,
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {"Content-Type": "application/json", "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}"}),
    );

    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context)   ;
    missionModelGlobal = missionModelFromJson(str: response.data["mission"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}
