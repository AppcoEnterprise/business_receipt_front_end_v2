import 'dart:convert';

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
import 'package:business_receipt/model/employee_model/salary_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> updateSalaryEmployeeGlobal({required BuildContext context, required String remark, required Function signOutFunction}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: closingSellingStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_salary_employee',
      data: {
        'admin_id': profileModelAdminGlobal!.id,
        'employee_id': profileModelEmployeeGlobal!.id,
        "remark": remark,
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {"Content-Type": "application/json", "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}"}),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    if (response.data["is_closed_selling"]) {
      profileModelAdminGlobal = null;
      profileModelEmployeeGlobal = null;
      signOutFunction();
    } else {
      //TODO: show error
    }
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
  }
}

Future<void> getSalaryListEmployeeGlobal({
  required Function callBack,
  required BuildContext context,
  required int skip,
  required List<SubSalaryModel> salaryListEmployee,
  required String employeeId,
  required DateTime targetDate,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_salary_employee',
      queryParameters: {
        'admin_id': profileModelAdminGlobal!.id,
        'employee_id': employeeId,
        "skip": skip,
        "target_date": targetDate.toIso8601String(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {"Content-Type": "application/json", "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}"}),
    );
    print(json.encode(response.data));
    final List<SubSalaryModel> salaryModelTemp = salaryModelFromJson(str: response.data["salary_list"]);
    if (salaryListEmployee.isNotEmpty && salaryModelTemp.isNotEmpty) {
      final DateTime dateLast = salaryListEmployee.last.date!;
      final DateTime dateFirstTemp = salaryModelTemp.first.date!;
      bool isSalaryModelDateAfter = dateFirstTemp.isAfter(dateLast) || (dateFirstTemp.compareTo(dateLast) == 0);
      if (isSalaryModelDateAfter) {
        closeDialogGlobal(context: context);
        return;
      }
    }

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    salaryListEmployee.addAll(salaryModelTemp);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}
