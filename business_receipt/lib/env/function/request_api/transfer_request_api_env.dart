import 'dart:convert';

import 'package:business_receipt/env/function/error_from_api.dart';
import 'package:business_receipt/env/function/customer.dart';
import 'package:business_receipt/env/function/delay_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/request_api/dio_config_request_api_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/admin_model/transfer_model.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/history_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:business_receipt/model/employee_model/salary_model.dart';
import 'package:business_receipt/model/employee_model/transfer_order_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> updateTransferGlobal({required Function callBack, required BuildContext context, required TransferModel transferTemp}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingTransferStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final bool isCreateCustomer = (transferTemp.id == null);
    final Map<String, dynamic> jsonStr = isCreateCustomer ? transferTemp.constValueToJson() : transferTemp.toJson();
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_transfer_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "transfer": jsonStr, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    transferModelListGlobal = transferFromJson(str: response.data["transfer_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> deleteTransferGlobal({required Function callBack, required BuildContext context, required String transferId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingTransferStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}delete_transfer_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "transfer_id": transferId, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    transferModelListGlobal = transferFromJson(str: response.data["transfer_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> restoreTransferGlobal({required Function callBack, required BuildContext context, required String transferId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingTransferStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}restore_transfer_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "transfer_id": transferId, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    transferModelListGlobal = transferFromJson(str: response.data["transfer_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> updateTransferEmployeeGlobal({
  required Function callBack,
  required BuildContext context,
  required TransferOrder transferOrderTemp,
  required bool isForceUpdate,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updateGiveMoneyToMatStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_transfer_employee',
      data: {
        "admin_id": profileModelAdminGlobal!.id,
        'employee_id': profileModelEmployeeGlobal!.id,
        "employee_name": profileModelEmployeeGlobal!.name.text,
        "transfer": transferOrderTemp.noConstToJson(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
        "is_force_update": isForceUpdate,
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    List<MatchTransferList> transferOrderMatchList = [];
    final isMatchTransfer = response.data["is_existed"];
    if (isMatchTransfer) {
      transferOrderMatchList.addAll(matchTransferListFromJson(str: response.data["match_transfer_list"]));
    } else {
      historyListGlobal.insert(0, historyModelFromJson(str: response.data["total_per_invoice_last"]));
      amountAndProfitModelGlobal = amountAndProfitModelFromJson(str: response.data["amount_and_profit"]);
      profileModelEmployeeGlobal = profileModelEmployeeFromJson(str: response.data["profile_employee"]);
      transferModelListEmployeeGlobal.insert(0, transferMoneyModelFromJson(str: response.data["total_per_invoice_last"]["transfer"]));
      customerModelListGlobal = customerModelListFromJson(str: response.data["customer_list"]);
      createCustomerWithoutTransferListOnly();
      salaryListEmployeeGlobal = salaryMergeByMonthModelFromJson(str: response.data["salary_list"]);
    }
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack(isMatchTransfer: isMatchTransfer, transferOrderMatchList: transferOrderMatchList);
  }
}

Future<void> getTransferListEmployeeGlobal({
  required String employeeId,
  required Function callBack,
  required BuildContext context,
  required int skip,
  required DateTime targetDate,
  required List<TransferOrder> transferModelListEmployee,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_transfer_list_employee',
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

    final List<TransferOrder> transferOrderTemp = transferOrderFromJson(str: response.data["transfer_list"]);
    if (transferModelListEmployee.isNotEmpty && transferOrderTemp.isNotEmpty) {
      final DateTime dateLast = transferModelListEmployee.last.date!;
      final DateTime dateFirstTemp = transferOrderTemp.first.date!;
      bool isTransferOrderDateAfter = dateFirstTemp.isAfter(dateLast) || (dateFirstTemp.compareTo(dateLast) == 0);
      if (isTransferOrderDateAfter) {
        closeDialogGlobal(context: context);
        return;
      }
    }

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    transferModelListEmployee.addAll(transferOrderTemp);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}
