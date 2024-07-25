// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'package:business_receipt/env/value_env/invoice_type.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/employee_model/card/card_main_stock_model.dart';
import 'package:business_receipt/model/employee_model/card/sell_card_model.dart';
import 'package:business_receipt/model/employee_model/excel_employee_model.dart';
import 'package:business_receipt/model/employee_model/exchange_money_model.dart';
import 'package:business_receipt/model/employee_model/give_card_to_mat_model.dart';
import 'package:business_receipt/model/employee_model/give_money_to_mat_model.dart';
import 'package:business_receipt/model/employee_model/other_in_or_out_come_model.dart';
import 'dart:convert';

import 'package:business_receipt/model/employee_model/transfer_order_model.dart';

List<HistoryModel> historyModelListFromJson({required dynamic str}) {
  // print(json.decode(json.encode(str)));
  return List<HistoryModel>.from(json.decode(json.encode(str)).map((x) => HistoryModel.fromJson(x)));
}

HistoryModel historyModelFromJson({required dynamic str}) => HistoryModel.fromJson(json.decode(json.encode(str)));

String historyModelToJson(List<HistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryModel {
  String invoiceId;
  String invoiceType;
  List<MoneyList> moneyList;
  List<CardList> cardList;
  ExchangeMoneyModel? exchangeMoneyModel;
  TransferOrder? transferMoneyModel;
  InformationAndCardMainStockModel? informationAndCardMainStockModel;
  SellCardModel? sellCardModel;
  MoneyCustomerModel? borrowingOrLending;
  GiveMoneyToMatModel? giveMoneyToMatModel;
  GiveCardToMatModel? giveCardToMatModel;
  OtherInOrOutComeModel? otherInOrOutComeModel;
  ExcelDataList? excelData;

  HistoryModel({
    required this.invoiceId,
    required this.invoiceType,
    required this.moneyList,
    required this.cardList,
    required this.exchangeMoneyModel,
    required this.transferMoneyModel,
    required this.informationAndCardMainStockModel,
    required this.sellCardModel,
    required this.borrowingOrLending,
    required this.giveMoneyToMatModel,
    required this.giveCardToMatModel,
    required this.otherInOrOutComeModel,
    required this.excelData,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> jsonQuery) {
    return HistoryModel(
      invoiceId: jsonQuery["invoice_id"],
      invoiceType: jsonQuery["invoice_type"],
      moneyList: List<MoneyList>.from(jsonQuery["money_list"].map((x) => MoneyList.fromJson(x))),
      cardList: List<CardList>.from(jsonQuery["card_list"].map((x) => CardList.fromJson(x))),
      exchangeMoneyModel:
          (jsonQuery[exchangeQueryGlobal] == null) ? null : ExchangeMoneyModel.fromJson(json.decode(json.encode(jsonQuery[exchangeQueryGlobal]))),
      transferMoneyModel: (jsonQuery[transferQueryGlobal] == null) ? null : TransferOrder.fromJson(json.decode(json.encode(jsonQuery[transferQueryGlobal]))),
      informationAndCardMainStockModel: (jsonQuery[cardMainStockQueryGlobal] == null)
          ? null
          : InformationAndCardMainStockModel.fromJson(json.decode(json.encode(jsonQuery[cardMainStockQueryGlobal]))),
      sellCardModel: (jsonQuery[sellCardQueryGlobal] == null) ? null : SellCardModel.fromJson(json.decode(json.encode(jsonQuery[sellCardQueryGlobal]))),
      borrowingOrLending:
          (jsonQuery[borrowOrLendQueryGlobal] == null) ? null : MoneyCustomerModel.fromJson(json.decode(json.encode(jsonQuery[borrowOrLendQueryGlobal]))),
      giveMoneyToMatModel:
          (jsonQuery[giveMoneyToMatQueryGlobal] == null) ? null : GiveMoneyToMatModel.fromJson(json.decode(json.encode(jsonQuery[giveMoneyToMatQueryGlobal]))),
      giveCardToMatModel:
          (jsonQuery[giveCardToMatQueryGlobal] == null) ? null : GiveCardToMatModel.fromJson(json.decode(json.encode(jsonQuery[giveCardToMatQueryGlobal]))),
      otherInOrOutComeModel: (jsonQuery[otherInOrOutComeQueryGlobal] == null)
          ? null
          : OtherInOrOutComeModel.fromJson(json.decode(json.encode(jsonQuery[otherInOrOutComeQueryGlobal]))),
      excelData: (jsonQuery[excelQueryGlobal] == null) ? null : ExcelDataList.fromJson(json.decode(json.encode(jsonQuery[excelQueryGlobal]))),
    );
  }
  Map<String, dynamic> toJson() => {
        "invoice_id": invoiceId,
        "invoice_type": invoiceType,
        "money_list": List<dynamic>.from(moneyList.map((x) => x.toJson())),
        "card_list": List<dynamic>.from(cardList.map((x) => x.toJson())),
      };
}

class CardList {
  String cardCompanyNameId;
  String cardCompanyName;
  List<CategoryList> categoryList;

  CardList({
    required this.cardCompanyNameId,
    required this.cardCompanyName,
    required this.categoryList,
  });

  factory CardList.fromJson(Map<String, dynamic> json) => CardList(
        cardCompanyName: json["card_company_name"],
        cardCompanyNameId: json["card_company_name_id"],
        categoryList: List<CategoryList>.from(json["category_list"].map((x) => CategoryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "card_company_name_id": cardCompanyNameId,
        "category_list": List<dynamic>.from(categoryList.map((x) => x.toJson())),
      };
}

class CategoryList {
  String categoryId;
  double category;
  int stock;

  CategoryList({
    required this.categoryId,
    required this.category,
    required this.stock,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        categoryId: json["category_id"],
        category: json["category"],
        stock: json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "stock": stock,
      };
}

class MoneyList {
  double amount;
  String moneyType;

  MoneyList({
    required this.amount,
    required this.moneyType,
  });

  factory MoneyList.fromJson(Map<String, dynamic> json) => MoneyList(
        amount: json["amount"],
        moneyType: json["money_type"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "money_type": moneyType,
      };
}
