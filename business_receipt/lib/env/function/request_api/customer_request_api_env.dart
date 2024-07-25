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
import 'package:business_receipt/model/admin_model/customer_information_category.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/admin_model/transfer_model.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/history_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// Future<void> getCustomerWithoutBorrowOrLendingGlobal({required Function callBack, required BuildContext context}) async {
//   await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
//   loadingDialogGlobal(context: context, loadingTitle: findingCardStrGlobal);
//   final Response response =
//       await dioGlobal.get('${endPointGlobal}get_customer_without_borrow_or_lending_list', queryParameters: {'admin_id': profileModelAdminGlobal!.id}); //TODO: change this path api
//   print("response.data[customer_list] => ${response.data["customer_list"]}");
//   customerModelListGlobal = customerModelListFromJson(str: response.data["customer_list"]);
//   closeDialogGlobal(context: context);
//   callBack();
// }

Future<void> updateCustomerInformationAdminGlobal(
    {required Function callBack, required BuildContext context, required CustomerModel customerModelTemp, required bool isLend}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCustomerInformationStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final bool isCreateCustomer = (customerModelTemp.id == null);
    final Map<String, dynamic> jsonStr = isCreateCustomer ? customerModelTemp.constValueToJson(isLend: isLend) : customerModelTemp.toJson(isLend: isLend);
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_information_customer_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "customer": jsonStr, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context) ;
    customerModelListGlobal = customerModelListFromJson(str: response.data["customer_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

    // if (isCreateCustomer) {
    //   customerModelListGlobal.add(customerModel);
    // } else {
    //   final int customerIndex = getIndexByCustomerId(customerId: customerModelTemp.id!);
    //   customerModelListGlobal[customerIndex] = customerModel;
    // }
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> deleteCustomerGlobal({required Function callBack, required BuildContext context, required String customerId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingCustomerStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}delete_customer_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "customer_id": customerId, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context) ;
    transferModelListGlobal = transferFromJson(str: response.data["transfer_list"]);
    customerModelListGlobal = customerModelListFromJson(str: response.data["customer_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> restoreCustomerGlobal({required Function callBack, required BuildContext context, required String customerId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingCustomerStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}restore_customer_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "customer_id": customerId, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context) ;
    transferModelListGlobal = transferFromJson(str: response.data["transfer_list"]);
    customerModelListGlobal = customerModelListFromJson(str: response.data["customer_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getCustomerDetailGlobal(
    {required Function callBack, required BuildContext context, required CustomerModel customerModelTemp, required int skip}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingCustomerLoanStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_customer_by_id_admin',
      queryParameters: {
        'admin_id': profileModelAdminGlobal!.id,
        "customer_id": customerModelTemp.id,
        "skip": skip,
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );
    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context) ;
    final isCustomerNotNull = (response.data["customer"] != null);
    if (isCustomerNotNull) {
      final CustomerModel customerModelTempQuery = customerModelFromJson(str: response.data["customer"]);
      if (customerModelTemp.moneyList.isNotEmpty && customerModelTempQuery.moneyList.isNotEmpty) {
        final DateTime dateLast = customerModelTemp.moneyList.last.date!;
        final DateTime dateFirstTemp = customerModelTempQuery.moneyList.first.date!;
        bool isCustomerModelDateAfter = dateFirstTemp.isAfter(dateLast) || (dateFirstTemp.compareTo(dateLast) == 0);
        if (isCustomerModelDateAfter) {
          closeDialogGlobal(context: context);
          return;
        }
      }
      customerModelTemp.date = customerModelTempQuery.date;
      customerModelTemp.id = customerModelTempQuery.id;
      customerModelTemp.informationList = customerModelTempQuery.informationList;
      customerModelTemp.moneyList.addAll(customerModelTempQuery.moneyList);
      customerModelTemp.name = customerModelTempQuery.name;
      customerModelTemp.remark = customerModelTempQuery.remark;
      customerModelTemp.totalList = customerModelTempQuery.totalList;
      customerModelTemp.partnerList = customerModelTempQuery.partnerList;
    }
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> updateCustomerMoneyEmployeeGlobal({
  required Function callBack,
  required BuildContext context,
  required MoneyCustomerModel moneyCustomerModel,
  required String customerId,
  required bool isLend,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCustomerLoanStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_customer_borrow_or_lend_employee',
      data: {
        'admin_id': profileModelAdminGlobal!.id,
        'employee_id': profileModelEmployeeGlobal!.id,
        "customer_id": customerId,
        "money_customer": moneyCustomerModel.constValueToJson(isLend: isLend),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context) ;
    customerModelListGlobal = customerModelListFromJson(str: response.data["customer_list"]);
    historyListGlobal.insert(0, historyModelFromJson(str: response.data["total_per_invoice_last"]));
    amountAndProfitModelGlobal = amountAndProfitModelFromJson(str: response.data["amount_and_profit"]);
    profileModelEmployeeGlobal = profileModelEmployeeFromJson(str: response.data["profile_employee"]);
    borrowOrLendModelListEmployeeGlobal.insert(
        0, MoneyCustomerModel.fromJson(json.decode(json.encode(response.data["total_per_invoice_last"]["borrow_or_lend"]))));
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getBorrowOrLendListEmployeeGlobal({
  required String employeeId,
  required Function callBack,
  required BuildContext context,
  required int skip,
  required DateTime targetDate,
  required List<MoneyCustomerModel> borrowOrLendModelListEmployee,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_borrow_or_lend_list_employee',
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

    final List<MoneyCustomerModel> moneyCustomerModelTempList =
        List<MoneyCustomerModel>.from(json.decode(json.encode(response.data["borrow_or_lend_list"])).map((x) => MoneyCustomerModel.fromJson(x)));
    if (borrowOrLendModelListEmployee.isNotEmpty && moneyCustomerModelTempList.isNotEmpty) {
      final DateTime dateLast = borrowOrLendModelListEmployee.last.date!;
      final DateTime dateFirstTemp = moneyCustomerModelTempList.first.date!;
      bool isMoneyCustomerModelDateAfter = dateFirstTemp.isAfter(dateLast) || (dateFirstTemp.compareTo(dateLast) == 0);
      if (isMoneyCustomerModelDateAfter) {
        closeDialogGlobal(context: context);
        return;
      }
    }
    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context) ;
    borrowOrLendModelListEmployee.addAll(moneyCustomerModelTempList);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getBorrowOrLendListADayEmployeeGlobal({
  required Function callBack,
  required BuildContext context,
  required List<MoneyCustomerModelMoneyType> borrowOrLendModelListADay,
  required DateTime targetDate,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_borrow_or_lend_a_day_employee',
      queryParameters: {'admin_id': profileModelAdminGlobal!.id, "target_date": targetDate.toIso8601String(), "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );
    if (response.statusCode != 200) {
      closeDialogGlobal(context: context);
      return;
    }
    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context) ;
    borrowOrLendModelListADay.addAll(moneyCustomerModelMoneyTypeFromJson(str: response.data["borrow_or_lend_list"]));

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> updateCustomerInformationCategoryAdminGlobal(
    {required Function callBack, required BuildContext context, required List<CustomerInformationCategory> customerCategoryListTemp}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCustomerInformationStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_customer_information_category_list_admin',
      data: {
        'admin_id': profileModelAdminGlobal!.id,
        "customer_information_category_list": customerInformationCategoryListToJson(customerCategoryListTemp),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context) ;
    customerCategoryListGlobal = customerInformationCategoryListFromJson(str: response.data["customer_information_category_list_last"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}
