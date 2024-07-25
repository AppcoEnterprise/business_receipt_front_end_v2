
import 'package:business_receipt/env/function/error_from_api.dart';
import 'package:business_receipt/env/function/delay_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/request_api/dio_config_request_api_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/currency_model.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/override_lib/currency_lib/currency.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> updateCurrencyGlobal({required Function callBack, required BuildContext context, required CurrencyModel currencyModelTemp}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCurrencyStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_currency_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "money": currencyModelTemp.toJson(), "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );
    // print("response.data => ${json.encode(response.data["money_list"])}");
    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context) ;
    currencyModelListAdminGlobal = currencyModelListFromJson(str: response.data["money_list"]);
    rateModelListAdminGlobal = rateModelListFromJson(str: response.data["rate_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getCurrenciesOptionAdminGlobal({required Function callBack, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingCurrenciesOptionStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_currencies_option',
      // queryParameters: {'admin_id': profileModelAdminGlobal!.id},
      options: Options(headers: {"Content-Type": "application/json", "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}"}),
    );
    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context) ;
    currenciesOptionGlobal.addAll(currenciesOptionModelListFromJson(str: response.data["currencies_option"]));
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> deleteCurrencyGlobal({required Function callBack, required BuildContext context, required String moneyType}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCurrencyStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}delete_currency_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "money_type": moneyType, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );
    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context) ;

    currencyModelListAdminGlobal = currencyModelListFromJson(str: response.data["money_list"]);
    rateModelListAdminGlobal = rateModelListFromJson(str: response.data["rate_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> restoreCurrencyGlobal({required Function callBack, required BuildContext context, required String moneyType}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCurrencyStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}restore_currency_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "money_type": moneyType, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );
    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context) ;

    currencyModelListAdminGlobal = currencyModelListFromJson(str: response.data["money_list"]);
    rateModelListAdminGlobal = rateModelListFromJson(str: response.data["rate_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}
