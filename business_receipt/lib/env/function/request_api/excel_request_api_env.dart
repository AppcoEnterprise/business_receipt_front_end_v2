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
import 'package:business_receipt/model/admin_model/excel_admin_model.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/excel_employee_model.dart';
import 'package:business_receipt/model/employee_model/history_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:business_receipt/model/employee_model/salary_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> updateExcelAdminGlobal({required Function callBack, required BuildContext context, required ExcelAdminModel excelAdminModelTemp}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCustomerInformationStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final bool isCreateCustomer = (excelAdminModelTemp.id == null);
    final Map<String, dynamic> jsonStr = isCreateCustomer ? excelAdminModelTemp.constValueToJson() : excelAdminModelTemp.toJson();
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_excel_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "excel_admin": jsonStr, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    excelAdminModelListGlobal = excelAdminModelFromJson(str: response.data["excel_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> deleteExcelAdminGlobal({required Function callBack, required BuildContext context, required String excelAdminId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingCustomerStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}delete_excel_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "excel_admin_id": excelAdminId, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    excelAdminModelListGlobal = excelAdminModelFromJson(str: response.data["excel_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> restoreExcelAdminGlobal({required Function callBack, required BuildContext context, required String excelAdminId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingCustomerStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}restore_excel_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "excel_admin_id": excelAdminId, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    excelAdminModelListGlobal = excelAdminModelFromJson(str: response.data["excel_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> updateExcelEmployeeGlobal({required Function callBack, required BuildContext context, required ExcelEmployeeModel excelEmployee}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCustomerInformationStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_excel_employee',
      data: {
        "admin_id": profileModelAdminGlobal!.id,
        'employee_id': profileModelEmployeeGlobal!.id,
        "excel_employee": excelEmployee.toConstJson(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    excelHistoryListEmployeeGlobal =
        List<ExcelDataList>.from(json.decode(json.encode(response.data["excel_history_list"])).map((x) => ExcelDataList.fromJson(x)));
    excelListEmployeeGlobal = excelEmployeeModelListFromJson(str: response.data["excel_list"]);
    amountAndProfitModelGlobal = amountAndProfitModelFromJson(str: response.data["amount_and_profit"]);
    profileModelEmployeeGlobal = profileModelEmployeeFromJson(str: response.data["profile_employee"]);
    salaryListEmployeeGlobal = salaryMergeByMonthModelFromJson(str: response.data["salary_list"]);
    historyListGlobal = historyModelListFromJson(str: response.data["history_list"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> deleteExcelEmployeeGlobal({required Function callBack, required BuildContext context, required String excelConfigId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCustomerInformationStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}delete_excel_employee',
      data: {
        "admin_id": profileModelAdminGlobal!.id,
        'employee_id': profileModelEmployeeGlobal!.id,
        "excel_config_id": excelConfigId,
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    excelHistoryListEmployeeGlobal =
        List<ExcelDataList>.from(json.decode(json.encode(response.data["excel_history_list"])).map((x) => ExcelDataList.fromJson(x)));
    excelListEmployeeGlobal = excelEmployeeModelListFromJson(str: response.data["excel_list"]);
    amountAndProfitModelGlobal = amountAndProfitModelFromJson(str: response.data["amount_and_profit"]);
    profileModelEmployeeGlobal = profileModelEmployeeFromJson(str: response.data["profile_employee"]);
    salaryListEmployeeGlobal = salaryMergeByMonthModelFromJson(str: response.data["salary_list"]);
    historyListGlobal = historyModelListFromJson(str: response.data["history_list"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getExcelListEmployeeGlobal({required Function callBack, required BuildContext context, required int skip, required String excelConfigId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_excel_list_employee',
      queryParameters: {
        'admin_id': profileModelAdminGlobal!.id,
        'employee_id': profileModelEmployeeGlobal!.id,
        "excel_config_id": excelConfigId,
        "skip": skip,
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );
    bool isValidQuery = true;
    if (response.data["excel"] != null) {
      final ExcelEmployeeModel excelMoneyModel = excelEmployeeModelFromJson(str: response.data["excel"]);
      final int excelIndex = excelListEmployeeGlobal.indexWhere((element) => (element.id == excelMoneyModel.id)); //never equal -1
      if (excelListEmployeeGlobal[excelIndex].dataList.isNotEmpty && excelMoneyModel.dataList.isNotEmpty) {
        final DateTime dateLast = excelListEmployeeGlobal[excelIndex].dataList.last.date;
        final DateTime dateFirstTemp = excelMoneyModel.dataList.first.date;
        bool isExcelMoneyModelDateAfter = dateFirstTemp.isAfter(dateLast) || (dateFirstTemp.compareTo(dateLast) == 0);
        if (isExcelMoneyModelDateAfter) {
          closeDialogGlobal(context: context);
          return;
        }
      }

      isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);

      excelListEmployeeGlobal[excelIndex].dataList.addAll(excelMoneyModel.dataList);
    }
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getExcelHistoryListEmployeeGlobal({
  required String employeeId,
  required Function callBack,
  required BuildContext context,
  required int skip,
  required DateTime targetDate,
  required List<ExcelDataList> excelListEmployee,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_excel_history_list_employee',
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

    final List<ExcelDataList> excelHistoryListEmployeeTemp =
        List<ExcelDataList>.from(json.decode(json.encode(response.data["excel_history_employee_list"])).map((x) => ExcelDataList.fromJson(x)));
    if (excelListEmployee.isNotEmpty && excelHistoryListEmployeeTemp.isNotEmpty) {
      final DateTime dateLast = excelListEmployee.last.date;
      final DateTime dateFirstTemp = excelHistoryListEmployeeTemp.first.date;
      bool isExcelHistoryListEmployeeDateAfter = dateFirstTemp.isAfter(dateLast) || (dateFirstTemp.compareTo(dateLast) == 0);
      if (isExcelHistoryListEmployeeDateAfter) {
        closeDialogGlobal(context: context);
        return;
      }
    }

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    // excelHistoryListEmployeeGlobal.addAll(excelHistoryListEmployeeTemp);
    excelListEmployee.addAll(excelHistoryListEmployeeTemp);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> updateExcelCategoryAdminGlobal({
  required Function callBack,
  required BuildContext context,
  required List<TextEditingController> excelCategoryListTemp,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCustomerInformationStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_excel_category_list_admin',
      data: {
        'admin_id': profileModelAdminGlobal!.id,
        "excel_category_list": List<dynamic>.from(excelCategoryListTemp.map((x) => x.text)),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    excelCategoryListGlobal =
        List<TextEditingController>.from(json.decode(json.encode(response.data["excel_category_list"])).map((x) => TextEditingController(text: x.toString())));
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}
