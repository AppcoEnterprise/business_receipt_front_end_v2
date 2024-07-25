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
import 'package:business_receipt/model/admin_model/card/card_combine_model.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/card/card_main_stock_model.dart';
import 'package:business_receipt/model/employee_model/card/sell_card_model.dart';
import 'package:business_receipt/model/employee_model/exchange_money_model.dart';
import 'package:business_receipt/model/employee_model/history_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:business_receipt/model/employee_model/salary_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// Future<void> initCardAdminOrEmployeeGlobal({required Function callBack, required BuildContext context, required bool isAdminQuery}) async {
//   await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
//   loadingDialogGlobal(context: context, loadingTitle: findingCardStrGlobal);

//   final Response response = await dioGlobal.get(
//     '${endPointGlobal}init_card',
//     queryParameters: {'admin_id': profileModelAdminGlobal!.id, 'employee_id': isAdminQuery ? null : profileModelEmployeeGlobal!.id},
//   );
//   currencyModelListAdminGlobal = currencyModelListFromJson(str: response.data["money_list"]);
//   cardModelListAdminGlobal = cardModelListFromJson(str: response.data["card_list"]);
//   rateModelListAdminGlobal = rateModelListFromJson(str: response.data["rate_list"]);
//   closeDialogGlobal(context: context);
//   callBack();
// }

Future<void> updateCardGlobal({required Function callBack, required BuildContext context, required CardModel cardTemp}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCardCategoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Map<String, dynamic> jsonStr = (cardTemp.id == null) ? cardModelCostValueToJson(data: cardTemp) : cardModelToJson(data: cardTemp);
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_card_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "card": jsonStr, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    cardModelListGlobal = cardModelListFromJson(str: response.data["card_list"]);
    cardCombineModelListGlobal = cardCombineModelFromJson(str: response.data["card_combine_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> deleteCardGlobal({required Function callBack, required BuildContext context, required String cardId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingCardCategoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}delete_card_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "card_id": cardId, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    cardModelListGlobal = cardModelListFromJson(str: response.data["card_list"]);
    cardCombineModelListGlobal = cardCombineModelFromJson(str: response.data["card_combine_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> restoreCardGlobal({required Function callBack, required BuildContext context, required String cardId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingCardCategoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}restore_card_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "card_id": cardId, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    cardModelListGlobal = cardModelListFromJson(str: response.data["card_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> deleteCardCategoryGlobal({required Function callBack, required BuildContext context, required String cardId, required String categoryId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingCardCategoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}delete_card_category_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "card_id": cardId, "category_id": categoryId, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    cardModelListGlobal = cardModelListFromJson(str: response.data["card_list"]);
    cardCombineModelListGlobal = cardCombineModelFromJson(str: response.data["card_combine_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> restoreCardCategoryGlobal({required Function callBack, required BuildContext context, required String cardId, required String categoryId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingCardCategoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}restore_card_category_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "card_id": cardId, "category_id": categoryId, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    cardModelListGlobal = cardModelListFromJson(str: response.data["card_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

// const admin_id = req.body.admin_id;
// const employee_id = req.body.employee_id;
// const card_company_name_id = req.body.card_company_name_id;
// const category_id = req.body.category_id;
// const main_card = req.body.main_card;
Future<void> updateMainCardGlobal({
  required Function callBack,
  required BuildContext context,
  required String cardCompanyNameId,
  required String cardCompanyName,
  // required String language,
  required String categoryId,
  required double category,
  required CardMainPriceListCardModel mainCard,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCardStockStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_card_main_admin',
      data: {
        'admin_id': profileModelAdminGlobal!.id,
        "employee_id": profileModelEmployeeGlobal!.id,
        "card_company_name_id": cardCompanyNameId,
        "card_company_name": cardCompanyName,
        "category_id": categoryId,
        "category": category,
        // "language": language,
        "main_card": mainCard.noCostValueToJson(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    historyListGlobal.insert(0, historyModelFromJson(str: response.data["total_per_invoice_last"]));
    cardModelListGlobal = cardModelListFromJson(str: response.data["card_list"]);
    amountAndProfitModelGlobal = amountAndProfitModelFromJson(str: response.data["amount_and_profit"]);
    profileModelEmployeeGlobal = profileModelEmployeeFromJson(str: response.data["profile_employee"]);
    mainCardModelListEmployeeGlobal.insert(0, informationAndCardMainStockModelFromJson(str: response.data["total_per_invoice_last"]["card_main_stock"]));

    // upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

    //TODO: add insert_card_stock
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> updateSellCardGlobal({required Function callBack, required BuildContext context, required SellCardModel sellCardModelTemp}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingSellCardInvoiceStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_card_employee',
      data: {
        "admin_id": profileModelAdminGlobal!.id,
        "employee_id": profileModelEmployeeGlobal!.id,
        "card": sellCardModelTemp.noCostValueToJson(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    // final bool isExchangeLastNotNull = (response.data["exchange_last"] != null);
    // if (isExchangeLastNotNull) {
    //   exchangeModelListEmployeeGlobal.insert(0, exchangeMoneyModelFromJson(str: response.data["exchange_last"]));
    // }
    historyListGlobal.insert(0, historyModelFromJson(str: response.data["total_per_invoice_last"]));
    cardModelListGlobal = cardModelListFromJson(str: response.data["card_list"]);
    amountAndProfitModelGlobal = amountAndProfitModelFromJson(str: response.data["amount_and_profit"]);
    profileModelEmployeeGlobal = profileModelEmployeeFromJson(str: response.data["profile_employee"]);
    salaryListEmployeeGlobal = salaryMergeByMonthModelFromJson(str: response.data["salary_list"]);
    sellCardModelListEmployeeGlobal.insert(0, sellCardModelFromJson(str: response.data["total_per_invoice_last"]["sell_card"]));
    // if (!isSimpleCalculate) {
    // print("not isSimpleCalculate");
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    // }
    callBack();
  }
}

Future<void> setExchangeAnalysisCardGlobal({
  required Function callBack,
  required BuildContext context,
  required SellCardModel sellCardModelTemp,
  required ExchangeMoneyModel exchangeAnalysisCard,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: analysisExchangeRateStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}set_exchange_analysis_card',
      data: {
        'admin_id': profileModelAdminGlobal!.id,
        'employee_id': profileModelEmployeeGlobal!.id,
        'card': sellCardModelTemp.noCostValueToJson(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    exchangeAnalysisCard.exchangeList = exchangeMoneyModelFromJson(str: response.data["exchange"]).exchangeList;
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getSellCardListEmployeeGlobal({
  required String employeeId,
  required Function callBack,
  required BuildContext context,
  required int skip,
  required DateTime targetDate,
  required List<SellCardModel> sellCardModelListEmployee,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_sell_card_list_employee',
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
    final List<SellCardModel> sellCardModelTempList = sellCardModelListFromJson(str: response.data["sell_card_list"]);
    if (sellCardModelListEmployee.isNotEmpty && sellCardModelTempList.isNotEmpty) {
      final DateTime dateLast = sellCardModelListEmployee.last.date!;
      final DateTime dateFirstTemp = sellCardModelTempList.first.date!;
      bool isSellCardDateAfter = dateFirstTemp.isAfter(dateLast) || (dateFirstTemp.compareTo(dateLast) == 0);
      if (isSellCardDateAfter) {
        closeDialogGlobal(context: context);
        return;
      }
    }

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    sellCardModelListEmployee.addAll(sellCardModelTempList);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getAddCardStockListEmployeeGlobal({
  required String employeeId,
  required Function callBack,
  required BuildContext context,
  required int skip,
  required DateTime targetDate,
  required List<InformationAndCardMainStockModel> mainCardModelListEmployee,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_add_card_stock_list_employee',
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

    final List<InformationAndCardMainStockModel> informationAndCardMainStockModelTemp =
        informationAndCardMainStockModelListFromJson(str: response.data["add_card_stock_list"]);
    if (mainCardModelListEmployee.isNotEmpty && informationAndCardMainStockModelTemp.isNotEmpty) {
      final DateTime dateLast = mainCardModelListEmployee.last.mainPrice.date!;
      final DateTime dateFirstTemp = informationAndCardMainStockModelTemp.first.mainPrice.date!;
      bool isInformationAndCardMainStockDateAfter = dateFirstTemp.isAfter(dateLast) || (dateFirstTemp.compareTo(dateLast) == 0);
      if (isInformationAndCardMainStockDateAfter) {
        closeDialogGlobal(context: context);
        return;
      }
    }

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    mainCardModelListEmployee.addAll(informationAndCardMainStockModelTemp);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getMainCardListAdminGlobal({
  required Function callBack,
  required BuildContext context,
  required String cardCompanyNameId,
  required String categoryId,
  required int skip,
  required List<CardMainPriceListCardModel> cardMainPriceListCardModelList,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_main_card_list_admin',
      queryParameters: {
        'admin_id': profileModelAdminGlobal!.id,
        "skip": skip,
        "card_company_name_id": cardCompanyNameId,
        "category_id": categoryId,
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );
    final List<CardMainPriceListCardModel> cardMainPriceListCardModelListTemp =
        // informationAndCardMainStockModelListFromJson(str: response.data["add_card_stock_list"]);
        List<CardMainPriceListCardModel>.from(json.decode(json.encode(response.data["main_card_list"])).map((x) => CardMainPriceListCardModel.fromJson(x)));
    if (cardMainPriceListCardModelList.isNotEmpty && cardMainPriceListCardModelListTemp.isNotEmpty) {
      final DateTime dateLast = cardMainPriceListCardModelList.last.date!;
      final DateTime dateFirstTemp = cardMainPriceListCardModelListTemp.first.date!;

      bool isInformationAndCardMainStockDateAfter = dateFirstTemp.isBefore(dateLast) || (dateFirstTemp.compareTo(dateLast) == 0);
      if (isInformationAndCardMainStockDateAfter) {
        closeDialogGlobal(context: context);
        return;
      }
    }

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    cardMainPriceListCardModelList.addAll(cardMainPriceListCardModelListTemp);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> getMainCardListEmployeeGlobal({
  required Function callBack,
  required BuildContext context,
  required String cardCompanyNameId,
  required String categoryId,
  required DateTime targetDate,
  required int skip,
  required List<CardMainPriceListCardModel> cardMainPriceListCardModelList,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_main_card_list_employee',
      queryParameters: {
        'admin_id': profileModelAdminGlobal!.id,
        "employee_id": profileModelEmployeeGlobal!.id,
        "skip": skip,
        "card_company_name_id": cardCompanyNameId,
        "category_id": categoryId,
        "target_date": targetDate.toIso8601String(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );
    final List<CardMainPriceListCardModel> cardMainPriceListCardModelListTemp =
        List<CardMainPriceListCardModel>.from(json.decode(json.encode(response.data["main_card_list"])).map((x) => CardMainPriceListCardModel.fromJson(x)));
    if (cardMainPriceListCardModelList.isNotEmpty && cardMainPriceListCardModelListTemp.isNotEmpty) {
      final DateTime dateLast = cardMainPriceListCardModelList.last.date!;
      final DateTime dateFirstTemp = cardMainPriceListCardModelListTemp.first.date!;

      bool isInformationAndCardMainStockDateAfter = dateFirstTemp.isBefore(dateLast) || (dateFirstTemp.compareTo(dateLast) == 0);
      if (isInformationAndCardMainStockDateAfter) {
        closeDialogGlobal(context: context);
        return;
      }
    }

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    cardMainPriceListCardModelList.addAll(cardMainPriceListCardModelListTemp);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> updateCardCombineAdminGlobal({
  required Function callBack,
  required BuildContext context,
  required List<CardCombineModel> cardCombineModelList,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingCustomerInformationStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_card_combine_list_admin',
      data: {
        'admin_id': profileModelAdminGlobal!.id,
        "card_combine_list": cardCombineModelToJson(cardCombineModelList),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    cardCombineModelListGlobal = cardCombineModelFromJson(str: response.data["card_combine_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}
