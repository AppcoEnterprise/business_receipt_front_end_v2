import 'dart:convert';

import 'package:business_receipt/env/function/error_from_api.dart';
import 'package:business_receipt/env/function/delay_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_or_admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/card/card_combine_model.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/admin_model/currency_model.dart';
import 'package:business_receipt/model/admin_model/customer_information_category.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/admin_model/excel_admin_model.dart';
import 'package:business_receipt/model/admin_model/mission_model.dart';
import 'package:business_receipt/model/admin_model/print_model.dart';
import 'package:business_receipt/model/admin_model/profile_model.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/admin_model/transfer_model.dart';
import 'package:business_receipt/model/admin_or_employee_list_asking_for_change.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dio_config_request_api_env.dart';

Future<void> logInAsAdminGlobal({required String adminName, required String password, required Function callBack, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingEmployeeInformationStrGlobal);

  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    Response response = await dioGlobal.post('${endPointGlobal}log_in_or_sign_up_admin', data: {'admin_name': adminName, 'password': password});
    profileModelAdminGlobal = (response.data["profile_admin"] == null) ? null : profileModelAdminFromJson(str: response.data["profile_admin"]);
    final isLogInSuccess = (profileModelAdminGlobal != null);
    if (isLogInSuccess) {
      setAdminTokenToLocalStorage(nameStr: adminName, passwordStr: password, token: response.data["access_token"]);
      deletingHistoryGlobal = response.data["is_deleting_history"];
      currencyModelListAdminGlobal = currencyModelListFromJson(str: response.data["money_list"]);
      cardModelListGlobal = cardModelListFromJson(str: response.data["card_list_merge"]);
      cardCombineModelListGlobal = cardCombineModelFromJson(str: response.data["card_combine_list"]);
      rateModelListAdminGlobal = rateModelListFromJson(str: response.data["rate_list"]);
      customerModelListGlobal = customerModelListFromJson(str: response.data["customer_list"]);
      profileEmployeeModelListAdminGlobal = profileModelListEmployeeFromJson(str: response.data["employee_profile_list"]);
      transferModelListGlobal = transferFromJson(str: response.data["transfer_list"]);
      printModelGlobal = printModelFromJson(str: response.data["print"]);
      amountAndProfitModelGlobal = amountAndProfitModelFromJson(str: response.data["amount_and_profit_merge"]);
      firstDateGlobal = (response.data["first_date"] == null) ? null : DateTime.parse(response.data["first_date"]);
      excelAdminModelListGlobal = excelAdminModelFromJson(str: response.data["excel_list"]);
      missionModelGlobal = missionModelFromJson(str: response.data["mission"]);
      customerCategoryListGlobal = customerInformationCategoryListFromJson(str: response.data["customer_information_category_list_last"]);
      upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
      askingForChangeFromAdminGlobal = adminOrEmployeeListAskingForChangeFromJson(str: response.data["admin_asking_for_change"]);
      askingForChangeFromEmployeeListGlobal = adminOrEmployeeListAskingForChangeFromJsonList(str: response.data["employee_list_asking_for_change"]);
      excelCategoryListGlobal = List<TextEditingController>.from(
          json.decode(json.encode(response.data["excel_category_list"])).map((x) => TextEditingController(text: x.toString())));
      logInAsAdminSocketIO();
      closeDialogGlobal(context: context);
      callBack(isExistingAdmin: true);
    } else {
      LocalStorageHelper.clearAll();
      closeDialogGlobal(context: context);
      callBack(isExistingAdmin: false);
    }
  }
}

Future<void> registerAdminGlobal({required ProfileAdminModel profileAdminModel, required Function callBack, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingEmployeeInformationStrGlobal);

  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    Map<String, dynamic> _json =
        (profileAdminModel.id == null) ? profileModelAdminNoCostValueToJson(data: profileAdminModel) : profileModelAdminToJson(data: profileAdminModel);
    Response response = await dioGlobal.post('${endPointGlobal}register_admin', data: {'profile': _json});
    profileModelAdminGlobal = (response.data["profile_admin"] == null) ? null : profileModelAdminFromJson(str: response.data["profile_admin"]);
    final isRegisterSuccess = (profileModelAdminGlobal != null);
    if (isRegisterSuccess) {
      setAdminTokenToLocalStorage(nameStr: profileAdminModel.name.text, passwordStr: profileAdminModel.password.text, token: response.data["access_token"]);
      deletingHistoryGlobal = response.data["is_deleting_history"];
      currencyModelListAdminGlobal = currencyModelListFromJson(str: response.data["money_list"]);
      cardModelListGlobal = cardModelListFromJson(str: response.data["card_list_merge"]);
      cardCombineModelListGlobal = cardCombineModelFromJson(str: response.data["card_combine_list"]);
      rateModelListAdminGlobal = rateModelListFromJson(str: response.data["rate_list"]);
      customerModelListGlobal = customerModelListFromJson(str: response.data["customer_list"]);
      profileEmployeeModelListAdminGlobal = profileModelListEmployeeFromJson(str: response.data["employee_profile_list"]);
      transferModelListGlobal = transferFromJson(str: response.data["transfer_list"]);
      printModelGlobal = printModelFromJson(str: response.data["print"]);

      missionModelGlobal = missionModelFromJson(str: response.data["mission"]);
      amountAndProfitModelGlobal = amountAndProfitModelFromJson(str: response.data["amount_and_profit_merge"]);
      excelAdminModelListGlobal = excelAdminModelFromJson(str: response.data["excel_list"]);
      askingForChangeFromAdminGlobal = adminOrEmployeeListAskingForChangeFromJson(str: response.data["admin_asking_for_change"]);
      askingForChangeFromEmployeeListGlobal = adminOrEmployeeListAskingForChangeFromJsonList(str: response.data["employee_list_asking_for_change"]);
      customerCategoryListGlobal = customerInformationCategoryListFromJson(str: response.data["customer_information_category_list_last"]);

      upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
      firstDateGlobal = (response.data["first_date"] == null) ? null : DateTime.parse(response.data["first_date"]);
      excelCategoryListGlobal = List<TextEditingController>.from(
          json.decode(json.encode(response.data["excel_category_list"])).map((x) => TextEditingController(text: x.toString())));
      logInAsAdminSocketIO();
      closeDialogGlobal(context: context);
      callBack();
    } else {
      void okFunction() {
        closeDialogGlobal(context: context);
        closeDialogGlobal(context: context);
      }

      okDialogGlobal(context: context, okFunction: okFunction, titleStr: signInAsAdminStrGlobal, subtitleStr: usernameIsAlreadyExistedStrGlobal);
    }
  }
}

Future<void> logInAsEmployeeGlobal({required String name, required String password, required Function callBack, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingEmployeeInformationStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    Response response = await dioGlobal.post('${endPointGlobal}log_in_employee', data: {'employee_name': name, 'password': password});
    
    profileModelEmployeeGlobal = (response.data["profile_employee"] == null) ? null : profileModelEmployeeFromJson(str: response.data["profile_employee"]);
    profileModelAdminGlobal = (response.data["profile_admin"] == null) ? null : profileModelAdminFromJson(str: response.data["profile_admin"]);
    final isLogInSuccess = (profileModelAdminGlobal != null && profileModelEmployeeGlobal != null);
    if (isLogInSuccess) {
      print(json.encode(response.data));
      
      setEmployeeNamePasswordAndTokenToLocalStorage(nameStr: name, passwordStr: password, token: response.data["access_token"]);
      await initHistoryModel(response: response);
      logInAsEmployeeSocketIO();
      closeDialogGlobal(context: context);
      callBack();
    } else {
      closeDialogGlobal(context: context);
      void okFunction() {
        closeDialogGlobal(context: context);
      }

      okDialogGlobal(context: context, okFunction: okFunction, titleStr: signInAsEmployeeStrGlobal, subtitleStr: incorrectUsernameOrPasswordStrGlobal);
    }
  }
}

Future<void> updateDeleteToTrueAdminGlobal({required Function callBack, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingCardCategoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_delete_to_true_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> updateDeleteToTrueEmployeeGlobal({required Function callBack, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingCardCategoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_delete_to_true_employee',
      data: {'admin_id': profileModelAdminGlobal!.id, 'employee_id': profileModelEmployeeGlobal!.id, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}
