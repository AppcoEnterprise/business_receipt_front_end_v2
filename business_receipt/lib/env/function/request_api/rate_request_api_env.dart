import 'dart:convert';
import 'package:business_receipt/env/function/delay_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/error_from_api.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dio_config_request_api_env.dart';

// Future<void> getLastRateGlobal({required Function callBack, required BuildContext context}) async {
//   await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
//   loadingDialogGlobal(context: context, loadingTitle: findingLastRateStrGlobal);
//   final Response response = await dioGlobal.get('${endPointGlobal}get_last_rate_admin', queryParameters: {'admin_id': profileModelAdminGlobal!.id});
//   rateModelListAdminGlobal = rateModelListFromJson(str: response.data["rate_list"]);
//   closeDialogGlobal(context: context);
//   callBack();
// }

// Future<void> updateBuyRateGlobal({required Function callBack, required BuildContext context, required RateModel rateModel}) async {
//   await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
//   loadingDialogGlobal(context: context, loadingTitle: updatingBuyRateStrGlobal);
//   final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
//   if (hasInternetAccess) {
//     final Response response = await dioGlobal.post(
//       '${endPointGlobal}update_buy_rate_admin',
//       data: {'admin_id': profileModelAdminGlobal!.id, "rate": rateModelNoCostValueToJson(data: rateModel), "up_to_date": upToDateGlobal!.toIso8601String()},
//       options: Options(headers: {
//         "Content-Type": "application/json",
//         "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
//       }),
//     );

//     print("buy: ${json.encode(response.data)}");
//
// final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context)   ;
//     rateModelListAdminGlobal = rateModelListFromJson(str: response.data["rate_list"]);
//     upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

//     closeDialogGlobal(context: context);
//     callBack();
//   }
// }

// Future<void> updateSellRateGlobal({required Function callBack, required BuildContext context, required RateModel rateModel}) async {
//   await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
//   loadingDialogGlobal(context: context, loadingTitle: updatingSellRateStrGlobal);
//   final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
//   if (hasInternetAccess) {
//     final Response response = await dioGlobal.post(
//       '${endPointGlobal}update_sell_rate_admin',
//       data: {
//         'admin_id': profileModelAdminGlobal!.id,
//         "rate": rateModelNoCostValueToJson(data: rateModel),
//         "up_to_date": upToDateGlobal!.toIso8601String(),
//       },
//       options: Options(headers: {
//         "Content-Type": "application/json",
//         "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
//       }),
//     );

//     print("sell: ${json.encode(response.data)}");
//
// final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context)   ;
//     rateModelListAdminGlobal = rateModelListFromJson(str: response.data["rate_list"]);
//     upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

//     closeDialogGlobal(context: context);
//     callBack();
//   }
// }

// Future<void> updateBuyRateDiscountOptionGlobal({required Function callBack, required BuildContext context, required RateModel rateModel}) async {
//   await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
//   loadingDialogGlobal(context: context, loadingTitle: updatingBuyDiscountRateStrGlobal);
//   final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
//   if (hasInternetAccess) {
//     final Response response = await dioGlobal.post(
//       '${endPointGlobal}update_buy_discount_option_list_admin',
//       data: {
//         'admin_id': profileModelAdminGlobal!.id,
//         "rate": rateModelToJson(data: rateModel),
//         "up_to_date": upToDateGlobal!.toIso8601String(),
//       },
//       options: Options(headers: {
//         "Content-Type": "application/json",
//         "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
//       }),
//     );

//     print("discount buy: ${json.encode(response.data)}");
//
// final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context)   ;
//     rateModelListAdminGlobal = rateModelListFromJson(str: response.data["rate_list"]);
//     upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

//     closeDialogGlobal(context: context);
//     callBack();
//   }
// }

// Future<void> updateSellRateDiscountOptionGlobal({required Function callBack, required BuildContext context, required RateModel rateModel}) async {
//   await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
//   loadingDialogGlobal(context: context, loadingTitle: updatingSellDiscountRateStrGlobal);
//   final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
//   print("rateModelToJson(data: rateModel) => ${json.encode(rateModelToJson(data: rateModel))}");
//   if (hasInternetAccess) {
//     final Response response = await dioGlobal.post(
//       '${endPointGlobal}update_sell_discount_option_list_admin',
//       data: {
//         'admin_id': profileModelAdminGlobal!.id,
//         "rate": rateModelToJson(data: rateModel),
//         "up_to_date": upToDateGlobal!.toIso8601String(),
//       },
//       options: Options(headers: {
//         "Content-Type": "application/json",
//         "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
//       }),
//     );

//     print("discount sell: ${json.encode(response.data)}");
//
// final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context)   ;
//     rateModelListAdminGlobal = rateModelListFromJson(str: response.data["rate_list"]);
//     upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

//     closeDialogGlobal(context: context);
//     callBack();
//   }
// }

Future<void> updateRateAdminGlobal({
  required Function callBack,
  required BuildContext context,
  required RateModel rateModel,
  required bool isChangeBuyRate,
  required bool isChangeSellRate,
  // required bool isChangeDiscountBuyRate,
  // required bool isChangeDiscountSellRate,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingSellDiscountRateStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_rate_admin',
      data: {
        'admin_id': profileModelAdminGlobal!.id,
        "rate": (isChangeBuyRate || isChangeSellRate) ? rateModelNoCostValueToJson(data: rateModel) : null,
        "rate_discount": rateModelNoCostValueToJson(data: rateModel),
        "rate_information": rateModel.rateInformationToJson(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
        "is_change_buy_rate": isChangeBuyRate,
        "is_change_sell_rate": isChangeSellRate,
      },
      options: Options(headers: {"Content-Type": "application/json", "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}"}),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    rateModelListAdminGlobal = rateModelListFromJson(str: response.data["rate_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getAnalysisExchangeByRateTypeAdmin({
  required Function callBack,
  required BuildContext context,
  required int skip,
  required List<String> rateType,
  required AnalysisExchangeModel analysisExchangeModel,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: analysisExchangeRateStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_analysis_exchange_by_rate_type_admin',
      queryParameters: {
        'admin_id': profileModelAdminGlobal!.id,
        'employee_id': (profileModelEmployeeGlobal == null) ? null : profileModelEmployeeGlobal!.id,
        "rate_type": List<dynamic>.from(rateType.map((x) => x)),
        "skip": skip,
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );
    bool isValidQuery = true;
    if (response.data["analysis_exchange"] != null) {
      AnalysisExchangeModel analysisExchangeModelFromDB = AnalysisExchangeModel.fromJson(json.decode(json.encode(response.data["analysis_exchange"])));
      if (analysisExchangeModel.leftList.isNotEmpty && analysisExchangeModelFromDB.leftList.isNotEmpty) {
        final double valueLast = analysisExchangeModel.leftList.last.rateValue;
        final double valueFirstTemp = analysisExchangeModelFromDB.leftList.first.rateValue;
        bool isLeftListAfter = (analysisExchangeModelFromDB.isBuy! ? (valueFirstTemp > valueLast) : (valueLast > valueFirstTemp)) || (valueFirstTemp == valueLast);
        if (isLeftListAfter) {
          closeDialogGlobal(context: context);
          return;
        }
      }

      isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
      analysisExchangeModel.firstRateValue = analysisExchangeModelFromDB.firstRateValue;
      analysisExchangeModel.lastRateValue = analysisExchangeModelFromDB.lastRateValue;
      analysisExchangeModel.isBuy = analysisExchangeModelFromDB.isBuy;
      analysisExchangeModel.leftList.addAll(analysisExchangeModelFromDB.leftList);
      analysisExchangeModel.profit = analysisExchangeModelFromDB.profit;
      analysisExchangeModel.rateType = analysisExchangeModelFromDB.rateType;

      analysisExchangeModel.averageRateValue = analysisExchangeModelFromDB.averageRateValue;
      analysisExchangeModel.totalGetMoney = analysisExchangeModelFromDB.totalGetMoney;
      analysisExchangeModel.totalGiveMoney = analysisExchangeModelFromDB.totalGiveMoney;
    }
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}
