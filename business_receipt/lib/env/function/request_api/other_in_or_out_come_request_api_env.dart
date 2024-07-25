
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
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/history_model.dart';
import 'package:business_receipt/model/employee_model/other_in_or_out_come_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> updateOtherInOrOutComeAdminGlobal(
    {required Function callBack, required BuildContext context, required OtherInOrOutComeModel otherInOrOutComeModelTemp, required bool isIncome}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: isIncome ? updatingOtherIncomeStrGlobal : updatingOtherOutcomeStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;

  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_other_in_or_out_come_employee',
      data: {
        "admin_id": profileModelAdminGlobal!.id,
        'employee_id': profileModelEmployeeGlobal!.id,
        "other_in_or_out_come": otherInOrOutComeModelTemp.constValueToJson(isIncome: isIncome),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context)   ;
    historyListGlobal.insert(0, historyModelFromJson(str: response.data["total_per_invoice_last"]));
    amountAndProfitModelGlobal = amountAndProfitModelFromJson(str: response.data["amount_and_profit"]);
    profileModelEmployeeGlobal = profileModelEmployeeFromJson(str: response.data["profile_employee"]);
    otherInOrOutComeModelListEmployeeGlobal.insert(0, otherInOrOutComeModelFromJson(str: response.data["total_per_invoice_last"]["other_in_or_out_come"]));
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getOtherInOrOutComeListEmployeeGlobal({
  required String employeeId,
  required Function callBack,
  required BuildContext context,
  required int skip,
  required DateTime targetDate,
  required List<OtherInOrOutComeModel> otherInOrOutComeModelListEmployee,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_other_in_or_out_come_list_employee',
      queryParameters: {
        'admin_id': profileModelAdminGlobal!.id,
        'employee_id': employeeId,
        "skip": skip,
        "target_date": targetDate.toIso8601String(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final List<OtherInOrOutComeModel> otherInOrOutComeModelTemp = otherInOrOutComeModelListFromJson(str: response.data["other_in_or_out_come_list"]);
    if (otherInOrOutComeModelListEmployee.isNotEmpty && otherInOrOutComeModelTemp.isNotEmpty) {
      final DateTime dateLast = otherInOrOutComeModelListEmployee.last.date!;
      final DateTime dateFirstTemp = otherInOrOutComeModelTemp.first.date!;
      bool isOtherInOrOutComeModelListEmployeeDateAfter = dateFirstTemp.isAfter(dateLast) || (dateFirstTemp.compareTo(dateLast) == 0);
      if (isOtherInOrOutComeModelListEmployeeDateAfter) {
        closeDialogGlobal(context: context);
        return;
      }
    }

    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context)   ;
    otherInOrOutComeModelListEmployee.addAll(otherInOrOutComeModelTemp);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}
