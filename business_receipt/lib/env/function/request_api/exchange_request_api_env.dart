import 'dart:convert';

import 'package:business_receipt/env/function/error_from_api.dart';
import 'package:business_receipt/env/function/delay_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/request_api/dio_config_request_api_env.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/exchange_money_model.dart';
import 'package:business_receipt/model/employee_model/history_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:business_receipt/model/employee_model/salary_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// Future<void> initExchangeGlobal({required Function callBack, required BuildContext context}) async {
//   await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
//   loadingDialogGlobal(context: context, loadingTitle: findingCurrencyStrGlobal);
//   final Response response = await dioGlobal.get('${endPointGlobal}init_exchange', queryParameters: {'admin_id': profileModelAdminGlobal!.id});
//   currencyModelListAdminGlobal = currencyModelListFromJson(str: response.data["money_list"]);
//   rateModelListAdminGlobal = rateModelListFromJson(str: response.data["rate_list"]);
//   closeDialogGlobal(context: context);
//   callBack();
// }

Future<void> updateExchangeGlobal({
  required Function callBack,
  required BuildContext context,
  required ExchangeMoneyModel exchangeTemp,
  bool isDelete = false,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updateExchangeInvoiceStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_exchange_employee',
      data: {
        "admin_id": profileModelAdminGlobal!.id,
        'employee_id': profileModelEmployeeGlobal!.id,
        "exchange": isDelete ? exchangeTemp.toJson() : exchangeTemp.noConstToJson(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );
    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);

    historyListGlobal.insert(0, historyModelFromJson(str: response.data["total_per_invoice_last"]));
    amountAndProfitModelGlobal = amountAndProfitModelFromJson(str: response.data["amount_and_profit"]);
    profileModelEmployeeGlobal = profileModelEmployeeFromJson(str: response.data["profile_employee"]);
    salaryListEmployeeGlobal = salaryMergeByMonthModelFromJson(str: response.data["salary_list"]);
    exchangeModelListEmployeeGlobal.insert(0, exchangeMoneyModelFromJson(str: response.data["total_per_invoice_last"]["exchange"]));
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> setExchangeAnalysisGlobal({required Function callBack, required BuildContext context, required ExchangeMoneyModel exchangeTemp}) async {
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
    loadingDialogGlobal(context: context, loadingTitle: analysisExchangeRateStrGlobal);
    final Response response = await dioGlobal.post(
      '${endPointGlobal}set_exchange_analysis',
      data: {
        'admin_id': profileModelAdminGlobal!.id,
        'employee_id': profileModelEmployeeGlobal!.id,
        'exchange': exchangeTemp.noConstToJson(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    ExchangeMoneyModel exchangeAnalysis = exchangeMoneyModelFromJson(str: response.data["exchange"]);
    for (int exchangeIndex = 0; exchangeIndex < exchangeAnalysis.exchangeList.length; exchangeIndex++) {
      exchangeTemp.exchangeList[exchangeIndex].rate!.profit = exchangeAnalysis.exchangeList[exchangeIndex].rate!.profit;
    }
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getExchangeListEmployeeGlobal({
  required Function callBack,
  required BuildContext context,
  required int skip,
  required DateTime targetDate,
  required String employeeId,
  required List<ExchangeMoneyModel> exchangeModelListEmployee,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_exchange_list_employee',
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

    final List<ExchangeMoneyModel> exchangeModelListEmployeeTemp = exchangeMoneyModelListFromJson(str: response.data["exchange_list"]);
    if (exchangeModelListEmployee.isNotEmpty && exchangeModelListEmployeeTemp.isNotEmpty) {
      final DateTime dateLast = exchangeModelListEmployee.last.date!;
      final DateTime dateFirstTemp = exchangeModelListEmployeeTemp.first.date!;
      bool isExchangeModelListEmployeeDateAfter = dateFirstTemp.isAfter(dateLast) || (dateFirstTemp.compareTo(dateLast) == 0);
      if (isExchangeModelListEmployeeDateAfter) {
        closeDialogGlobal(context: context);
        return;
      }
    }

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    exchangeModelListEmployee.addAll(exchangeModelListEmployeeTemp);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}
