import 'dart:convert';

import 'package:business_receipt/env/function/error_from_api.dart';
import 'package:business_receipt/env/function/delay_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/request_api/dio_config_request_api_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/chart_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> getChartAdminGlobal({
  required Function callBack,
  required BuildContext context,
  required String chartDateTypeStr,
  // required ChartModel chartModel,
  required DateTime selectedDate,
  required String chartType,
  required String? moneyType,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_chart_admin',
      queryParameters: {
        'admin_id': profileModelAdminGlobal!.id,
        'chart_date_type': chartDateTypeStr,
        'chart_type': chartType,
        'money_type': moneyType,
        "selected_date": selectedDate,
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );
    print(json.encode(response.data));
    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    UpAndDownProfitChart? chartProfitModelTemp = (response.data["profit_target_date_list"] == null) ? null : upAndDownChartFromJson(str: response.data);
    List<UpAndDownCountElement>? chartCountModelListTemp = (response.data["count_target_date_list"] == null) ? null : upAndDownCountElementFromJson(str: response.data["count_target_date_list"]);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack(chartProfitModelTemp: chartProfitModelTemp, chartType: chartType, chartCountModelListTemp: chartCountModelListTemp);
  }
}
