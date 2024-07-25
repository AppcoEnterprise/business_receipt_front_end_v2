import 'dart:convert';

import 'package:business_receipt/env/function/error_from_api.dart';
import 'package:business_receipt/env/function/delay_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/request_api/dio_config_request_api_env.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/card/card_main_stock_model.dart';
import 'package:business_receipt/model/employee_model/card/sell_card_model.dart';
import 'package:business_receipt/model/employee_model/cash_model.dart';
import 'package:business_receipt/model/employee_model/excel_employee_model.dart';
import 'package:business_receipt/model/employee_model/exchange_money_model.dart';
import 'package:business_receipt/model/employee_model/give_card_to_mat_model.dart';
import 'package:business_receipt/model/employee_model/give_money_to_mat_model.dart';
import 'package:business_receipt/model/employee_model/history_model.dart';
import 'package:business_receipt/model/employee_model/other_in_or_out_come_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:business_receipt/model/employee_model/salary_model.dart';
import 'package:business_receipt/model/employee_model/transfer_order_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> getHistoryByDateEmployeeGlobal({
  required Function callBack,
  required bool isNeedHistory,
  required BuildContext context,
  // // required int skip,
  required List<HistoryModel> historyList,
  required CashModel cashModel,
  required String employeeId,
  required DateTime targetDate,
  required List<AmountAndProfitModel> amountAndProfitModel,
  required List<CardModel> cardModelList,
  required List<SalaryHistory> salaryList,
  DisplayBusinessOptionProfileEmployeeModel? displayBusinessOptionModel,
  // // required DateTime firstDate,

  required List<ExchangeMoneyModel> exchangeModelListEmployee,
  required List<TransferOrder> transferModelListEmployee,
  required List<SellCardModel> sellCardModelListEmployee,
  required List<InformationAndCardMainStockModel> mainCardModelListEmployee,
  required List<MoneyCustomerModel> borrowOrLendModelListEmployee,
  required List<GiveMoneyToMatModel> giveMoneyToMatModelListEmployee,
  required List<GiveCardToMatModel> giveCardToMatModelListEmployee,
  required List<OtherInOrOutComeModel> otherInOrOutComeModelListEmployee,
  required List<ExcelDataList> excelListEmployee,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingHistoryListStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_history_by_date_employee',
      queryParameters: {
        'admin_id': profileModelAdminGlobal!.id,
        'employee_id': employeeId,
        "target_date": targetDate.toIso8601String(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
        "is_need_history": isNeedHistory,
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );
    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    if (response.data["is_existed"]) {
      print("response.data => ${json.encode(response.data)}");
      historyList.addAll(historyModelListFromJson(str: response.data["history_list"]));
      final CashModel cashModelTemp = cashModelFromJson(str: response.data["cash"]);
      cashModel.mergeBy = cashModelTemp.mergeBy;
      cashModel.cashList.addAll(cashModelTemp.cashList);
      amountAndProfitModel.addAll(amountAndProfitModelFromJson(str: response.data["amount_and_profit"]));
      cardModelList.addAll(cardModelListFromJson(str: response.data["card_list"]));
      salaryList.addAll(List<SalaryHistory>.from(response.data["salary_list"].map((x) => SalaryHistory.fromJson(x))));
      final DisplayBusinessOptionProfileEmployeeModel displayBusinessOptionTemp =
          DisplayBusinessOptionProfileEmployeeModel.fromJson(response.data["display_business_option"]);
      if (displayBusinessOptionModel != null) {
        displayBusinessOptionModel.exchangeSetting = ExchangeSetting(
          exchangeCount: displayBusinessOptionTemp.exchangeSetting.exchangeCount,
          exchangeOption: displayBusinessOptionTemp.exchangeSetting.exchangeOption,
        );
        displayBusinessOptionModel.transferSetting = TransferSetting(
          transferCount: displayBusinessOptionTemp.transferSetting.transferCount,
          transferOption: displayBusinessOptionTemp.transferSetting.transferOption,
        );
        displayBusinessOptionModel.sellCardSetting = SellCardSetting(
          sellCardCount: displayBusinessOptionTemp.sellCardSetting.sellCardCount,
          sellCardOption: displayBusinessOptionTemp.sellCardSetting.sellCardOption,
        );
        displayBusinessOptionModel.outsiderBorrowOrLendingSetting = OutsiderBorrowOrLendingSetting(
          outsiderBorrowOrLendingCount: displayBusinessOptionTemp.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingCount,
          outsiderBorrowOrLendingOption: displayBusinessOptionTemp.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingOption,
        );
        displayBusinessOptionModel.giveMoneyToMatSetting = GiveMoneyToMatSetting(
          giveMoneyToMatCount: displayBusinessOptionTemp.giveMoneyToMatSetting.giveMoneyToMatCount,
          giveMoneyToMatOption: displayBusinessOptionTemp.giveMoneyToMatSetting.giveMoneyToMatOption,
        );
        displayBusinessOptionModel.giveCardToMatSetting = GiveCardToMatSetting(
          giveCardToMatCount: displayBusinessOptionTemp.giveCardToMatSetting.giveCardToMatCount,
          giveCardToMatOption: displayBusinessOptionTemp.giveCardToMatSetting.giveCardToMatOption,
        );
        displayBusinessOptionModel.rateSetting = RateSetting(
          rateOption: displayBusinessOptionTemp.rateSetting.rateOption,
        );
        displayBusinessOptionModel.addCardStockSetting = AddCardStockSetting(
          addCardStockCount: displayBusinessOptionTemp.addCardStockSetting.addCardStockCount,
          addCardStockOption: displayBusinessOptionTemp.addCardStockSetting.addCardStockOption,
        );
        displayBusinessOptionModel.otherInOrOutComeSetting = OtherInOrOutComeSetting(
          otherInOrOutComeCount: displayBusinessOptionTemp.otherInOrOutComeSetting.otherInOrOutComeCount,
          otherInOrOutComeOption: displayBusinessOptionTemp.otherInOrOutComeSetting.otherInOrOutComeOption,
        );
        displayBusinessOptionModel.printOtherNoteSetting = PrintOtherNoteSetting(
          printOtherNoteOption: displayBusinessOptionTemp.printOtherNoteSetting.printOtherNoteOption,
        );
        displayBusinessOptionModel.importFromExcelSetting = ImportFromExcelSetting(
          excelCount: displayBusinessOptionTemp.importFromExcelSetting.excelCount,
          importFromExcelOption: displayBusinessOptionTemp.importFromExcelSetting.importFromExcelOption,
        );
        displayBusinessOptionModel.missionSetting = MissionSetting(
          missionOption: displayBusinessOptionTemp.missionSetting.missionOption,
        );
        // displayBusinessOptionModel.exchangeOption = displayBusinessOptionTemp.exchangeOption;
        // displayBusinessOptionModel.sellCardOption = displayBusinessOptionTemp.sellCardOption;
        // displayBusinessOptionModel.outsiderBorrowOrLendingOption = displayBusinessOptionTemp.outsiderBorrowOrLendingOption;
        // displayBusinessOptionModel.giveMoneyToMatOption = displayBusinessOptionTemp.giveMoneyToMatOption;
        // displayBusinessOptionModel.giveCardToMatOption = displayBusinessOptionTemp.giveCardToMatOption;
        // displayBusinessOptionModel.rateOption = displayBusinessOptionTemp.rateOption;
        // displayBusinessOptionModel.addCardStockOption = displayBusinessOptionTemp.addCardStockOption;
        // displayBusinessOptionModel.otherInOrOutComeOption = displayBusinessOptionTemp.otherInOrOutComeOption;
        // displayBusinessOptionModel.printOtherNoteOption = displayBusinessOptionTemp.printOtherNoteOption;
        // displayBusinessOptionModel.importFromExcelOption = displayBusinessOptionTemp.importFromExcelOption;
        // displayBusinessOptionModel.missionOption = displayBusinessOptionTemp.missionOption;
        // displayBusinessOptionModel.exchangeCount = displayBusinessOptionTemp.exchangeCount;
        // displayBusinessOptionModel.transferCount = displayBusinessOptionTemp.transferCount;
        // displayBusinessOptionModel.sellCardCount = displayBusinessOptionTemp.sellCardCount;
        // displayBusinessOptionModel.outsiderBorrowOrLendingCount = displayBusinessOptionTemp.outsiderBorrowOrLendingCount;
        // displayBusinessOptionModel.giveMoneyToMatCount = displayBusinessOptionTemp.giveMoneyToMatCount;
        // displayBusinessOptionModel.giveCardToMatCount = displayBusinessOptionTemp.giveCardToMatCount;
        // displayBusinessOptionModel.addCardStockCount = displayBusinessOptionTemp.addCardStockCount;
        // displayBusinessOptionModel.otherInOrOutComeCount = displayBusinessOptionTemp.otherInOrOutComeCount;
        // displayBusinessOptionModel.excelCount = displayBusinessOptionTemp.excelCount;
      }
      exchangeModelListEmployee.addAll((response.data["exchange_list"] == null) ? [] : exchangeMoneyModelListFromJson(str: response.data["exchange_list"]));

      transferModelListEmployee
          .addAll((response.data["transfer_employee_list"] == null) ? [] : transferOrderFromJson(str: response.data["transfer_employee_list"]));

      sellCardModelListEmployee.addAll((response.data["sell_card_list"] == null) ? [] : sellCardModelListFromJson(str: response.data["sell_card_list"]));

      mainCardModelListEmployee.addAll(
          (response.data["add_card_stock_list"] == null) ? [] : informationAndCardMainStockModelListFromJson(str: response.data["add_card_stock_list"]));

      borrowOrLendModelListEmployee.addAll((response.data["borrow_or_lend_list"] == null)
          ? []
          : List<MoneyCustomerModel>.from(json.decode(json.encode(response.data["borrow_or_lend_list"])).map((x) => MoneyCustomerModel.fromJson(x))));

      giveMoneyToMatModelListEmployee
          .addAll((response.data["give_money_to_mat_list"] == null) ? [] : giveMoneyToMatModelListFromJson(str: response.data["give_money_to_mat_list"]));

      giveCardToMatModelListEmployee
          .addAll((response.data["give_card_to_mat_list"] == null) ? [] : giveCardToMatModelListFromJson(str: response.data["give_card_to_mat_list"]));

      otherInOrOutComeModelListEmployee.addAll(
          (response.data["other_in_or_out_come_list"] == null) ? [] : otherInOrOutComeModelListFromJson(str: response.data["other_in_or_out_come_list"]));

      excelListEmployee.addAll((response.data["excel_history_employee_list"] == null)
          ? []
          : List<ExcelDataList>.from(json.decode(json.encode(response.data["excel_history_employee_list"])).map((x) => ExcelDataList.fromJson(x))));

      if (isValidQuery) {
        closeDialogGlobal(context: context);
      }

      callBack(firstDateNew: (response.data["first_date"] == null) ? null : DateTime.parse(response.data["first_date"]), isExisted: true);
    } else {
      if (isValidQuery) {
        closeDialogGlobal(context: context);
      }
      callBack(firstDateNew: (response.data["first_date"] == null) ? null : DateTime.parse(response.data["first_date"]), isExisted: false);
    }
  }
}

Future<void> getHistoryTodayEmployeeGlobal({
  required Function callBack,
  required BuildContext context,
  required int skip,
  required List<HistoryModel> historyList,
  // required CashModel cashModel,
  required String employeeId,
  required DateTime targetDate,
  // required List<AmountAndProfitModel> amountAndProfitModel,
  // required List<CardModel> cardModelList,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingHistoryListStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_history_today_employee',
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

    bool isHistoryDateAfter = false;
    final List<HistoryModel> historyModelTempList = historyModelListFromJson(str: response.data["history_list"]);
    if (historyList.isNotEmpty && historyModelTempList.isNotEmpty) {
      DateTime? dateLast;
      if (historyList.last.exchangeMoneyModel != null) {
        dateLast = historyList.last.exchangeMoneyModel!.date;
      } else if (historyList.last.transferMoneyModel != null) {
        dateLast = historyList.last.transferMoneyModel!.date;
      } else if (historyList.last.informationAndCardMainStockModel != null) {
        dateLast = historyList.last.informationAndCardMainStockModel!.mainPrice.date;
      } else if (historyList.last.sellCardModel != null) {
        dateLast = historyList.last.sellCardModel!.date;
      } else if (historyList.last.borrowingOrLending != null) {
        dateLast = historyList.last.borrowingOrLending!.date;
      } else if (historyList.last.giveMoneyToMatModel != null) {
        dateLast = historyList.last.giveMoneyToMatModel!.date;
      } else if (historyList.last.giveCardToMatModel != null) {
        dateLast = historyList.last.giveCardToMatModel!.date;
      } else if (historyList.last.otherInOrOutComeModel != null) {
        dateLast = historyList.last.otherInOrOutComeModel!.date;
      } else if (historyList.last.excelData != null) {
        dateLast = historyList.last.excelData!.date;
      }
      DateTime? dateFirstTemp;
      if (historyModelTempList.first.exchangeMoneyModel != null) {
        dateFirstTemp = historyModelTempList.first.exchangeMoneyModel!.date;
      } else if (historyModelTempList.first.transferMoneyModel != null) {
        dateFirstTemp = historyModelTempList.first.transferMoneyModel!.date;
      } else if (historyModelTempList.first.informationAndCardMainStockModel != null) {
        dateFirstTemp = historyModelTempList.first.informationAndCardMainStockModel!.mainPrice.date;
      } else if (historyModelTempList.first.sellCardModel != null) {
        dateFirstTemp = historyModelTempList.first.sellCardModel!.date;
      } else if (historyModelTempList.first.borrowingOrLending != null) {
        dateFirstTemp = historyModelTempList.first.borrowingOrLending!.date;
      } else if (historyModelTempList.first.giveMoneyToMatModel != null) {
        dateFirstTemp = historyModelTempList.first.giveMoneyToMatModel!.date;
      } else if (historyModelTempList.first.giveCardToMatModel != null) {
        dateFirstTemp = historyModelTempList.first.giveCardToMatModel!.date;
      } else if (historyModelTempList.first.otherInOrOutComeModel != null) {
        dateFirstTemp = historyModelTempList.first.otherInOrOutComeModel!.date;
      } else if (historyModelTempList.first.excelData != null) {
        dateFirstTemp = historyModelTempList.first.excelData!.date;
      }
      isHistoryDateAfter = dateFirstTemp!.isAfter(dateLast!) || (dateFirstTemp.compareTo(dateLast) == 0);
      // print("response.statusCode => ${response.statusCode}");
      if (isHistoryDateAfter) {
        closeDialogGlobal(context: context);
        return;
      }
    }

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    historyList.addAll(historyModelListFromJson(str: response.data["history_list"]));
    // final CashModel cashModelTemp = cashModelFromJson(str: response.data["cash"]);
    // amountAndProfitModel.addAll(amountAndProfitModelFromJson(str: response.data["amount_and_profit"]));
    // cardModelList.addAll(cardModelListFromJson(str: response.data["card_list"]));
    // cashModel.mergeBy = cashModelTemp.mergeBy;
    // cashModel.cashList.addAll(cashModelTemp.cashList);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    // callBack(firstDateNew: (response.data["first_date"] == null) ? null : DateTime.parse(response.data["first_date"]));
    callBack();
  }
}

Future<void> deleteInvoiceEmployee({
  required Function callBack,
  required BuildContext context,
  required String invoiceId,
  required String invoiceType,
  required DateTime date,
  String? cardCompanyNameId,
  String? categoryId,
  String? customerId,
  required String remark,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updateGiveMoneyToMatStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response responseCheckIsRefresh = await dioGlobal.get(
      '${endPointGlobal}check_is_deleting_and_setting_setting_employee',
      queryParameters: {
        'admin_id': profileModelAdminGlobal!.id,
        'employee_id': profileModelEmployeeGlobal!.id,
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: responseCheckIsRefresh, context: context);
    if (isValidQuery) {
      deleteHistorySocketIO();
      final Response response = await dioGlobal.post(
        '${endPointGlobal}delete_invoice_employee',
        data: {
          "admin_id": profileModelAdminGlobal!.id,
          'employee_id': profileModelEmployeeGlobal!.id,
          "invoice_id": invoiceId,
          "invoice_type": invoiceType,
          "invoice_date": date.toIso8601String(),
          "card_company_name_id": cardCompanyNameId,
          "category_id": categoryId,
          "customer_id": customerId,
          "remark": remark,
          "up_to_date": upToDateGlobal!.toIso8601String(),
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
        }),
      );
      stopDeleteHistorySocketIO();

      final bool isSubValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
      // await initHistoryModel(response: response);
      // historyListGlobal.insert(0, historyModelFromJson(str: response.data["total_per_invoice_last"]));
      // amountAndProfitModelGlobal = amountAndProfitModelFromJson(str: response.data["amount_and_profit"]);
      // giveMoneyToMatModelListEmployeeGlobal.insert(0, giveMoneyToMatModelFromJson(str: response.data["total_per_invoice_last"]["give_money_to_mat"]));
      // closeDialogGlobal(context: context);
      // closeDialogGlobal(context: context);
      if (isSubValidQuery) {
        await delayMillisecond(millisecond: delayMillisecondsDeleteInvoiceGlobal);
        loadingDialogGlobal(context: context, loadingTitle: findingHistoryListStrGlobal);
      }
      callBack();
    }
  }
}
