// To parse this JSON data, do
//
//     final sellCardModel = sellCardModelFromJson(jsonString);

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<SellCardModel> sellCardModelListFromJson({required dynamic str}) =>
    List<SellCardModel>.from(json.decode(json.encode(str)).map((x) => SellCardModel.fromJson(x)));
SellCardModel sellCardModelFromJson({required dynamic str}) => SellCardModel.fromJson(json.decode(json.encode(str)));

List<dynamic> sellCardModelListToJson({required List<SellCardModel> data}) => List<dynamic>.from(data.map((x) => x.toJson()));
List<dynamic> sellCardModelListNoCostValueToJson({required List<SellCardModel> data}) => List<dynamic>.from(data.map((x) => x.noCostValueToJson()));

class SellCardModel {
  SellCardModel({
    this.id,
    required this.remark,
    this.dateOld,
    this.date,
    this.mergeCalculate,
    required this.moneyTypeList,
    this.isDelete = false,
    this.overwriteOnId,
    required this.activeLogModelList,
  });

  TextEditingController remark;
  bool isDelete;
  String? overwriteOnId;
  String? id;
  DateTime? date;
  DateTime? dateOld;
  CalculateSellCardModel? mergeCalculate;
  List<MoneyTypeListSellCardModel> moneyTypeList;
  List<ActiveLogModel> activeLogModelList;

  factory SellCardModel.fromJson(Map<String, dynamic> json) => SellCardModel(
        remark: TextEditingController(text: json["remark"]),
        id: json["_id"],
        isDelete: (json["is_delete"] == null) ? false : json["is_delete"],
        overwriteOnId: (json["overwrite_on_id"] == null) ? null : json["overwrite_on_id"],
        date: DateTime.parse(json["date"]),
        dateOld: (json["date_old"] == null) ? null : DateTime.parse(json["date_old"]),
        mergeCalculate: (json["merge_calculate"] == null) ? null : CalculateSellCardModel.fromJson(json["merge_calculate"]),
        moneyTypeList: List<MoneyTypeListSellCardModel>.from(json["money_type_list"].map((x) => MoneyTypeListSellCardModel.fromJson(x))),
        activeLogModelList:  List<ActiveLogModel>.from(json["active_log_list"].map((x) => ActiveLogModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "is_delete": isDelete,
        "overwrite_on_id": overwriteOnId,
        "_id": id,
        "remark": remark.text,
        "date": (date == null) ? null : date!.toIso8601String(),
        "date_old": (dateOld == null) ? null : dateOld!.toIso8601String(),
        "merge_calculate": (mergeCalculate == null) ? null : mergeCalculate!.toJson(),
        "money_type_list": List<dynamic>.from(moneyTypeList.map((x) => x.toJson())),
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),
      };

  Map<String, dynamic> noCostValueToJson() => {
        "remark": remark.text,
        "merge_calculate": (mergeCalculate == null) ? null : mergeCalculate!.toJson(),
        "money_type_list": List<dynamic>.from(moneyTypeList.map((x) => x.toJson())),
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),
      };
}

class CalculateSellCardModel {
  CalculateSellCardModel({
    this.convertMoney,
    required this.moneyType,
    required this.totalMoney,
    this.totalProfit,
    required this.customerMoneyList,
    this.isActive = false,
    this.isDone = false,
  });

  String moneyType;
  double totalMoney;
  double? convertMoney;
  double? totalProfit;
  List<CustomerMoneyListSellCardModel> customerMoneyList;
  bool isActive;
  bool isDone;

  factory CalculateSellCardModel.fromJson(Map<String, dynamic> json) => CalculateSellCardModel(
        convertMoney: (json["convert_money"] == null) ? null : (-1 * double.parse(json["convert_money"].toString())),
        moneyType: json["money_type"],
        totalMoney: json["total_money"],
        totalProfit: (json["total_profit"] == null) ? null : json["total_profit"],
        customerMoneyList: List<CustomerMoneyListSellCardModel>.from(json["customer_money_list"].map((x) => CustomerMoneyListSellCardModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "convert_money": (convertMoney == null) ? null : (-1 * convertMoney!),
        "money_type": moneyType,
        "total_money": totalMoney,
        "total_profit": totalProfit,
        "customer_money_list": List<dynamic>.from(customerMoneyList.map((x) => x.toJson())),
      };
}

class CustomerMoneyListSellCardModel {
  CustomerMoneyListSellCardModel({
    this.getMoney,
    required this.moneyType,
    required this.getMoneyController,
    this.giveMoney,
    this.rate,
  });

  String? getMoney;
  TextEditingController getMoneyController;
  double? giveMoney;
  String? moneyType;
  RateForCalculateModel? rate;

  factory CustomerMoneyListSellCardModel.fromJson(Map<String, dynamic> json) => CustomerMoneyListSellCardModel(
        getMoney: json["get_money"].toString(),
        moneyType: json["money_type"],
        giveMoney: (json["give_money"] == null) ? null : (double.parse(json["give_money"].toString())),
        rate: (json["rate"] == null) ? null : RateForCalculateModel.fromJson(json["rate"]),
        getMoneyController: TextEditingController(text: json["get_money"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "get_money": (getMoney == null)
            ? null
            : (getMoney!.isEmpty)
                ? null
                : double.parse(formatAndLimitNumberTextGlobal(
                    valueStr: getMoney, isRound: false, isAddComma: false, isAllowZeroAtLast: false)), //TODO: remove this condition
        "give_money": (giveMoney == null) ? null : (giveMoney!),
        "money_type": moneyType,
        "rate": (rate == null) ? null : rate!.toJson(),
      };
}

class MoneyTypeListSellCardModel {
  MoneyTypeListSellCardModel({
    required this.calculate,
    this.rate,
    required this.cardList,
  });

  CalculateSellCardModel calculate;
  RateForCalculateModel? rate;
  List<CardListSellCardModel> cardList;

  factory MoneyTypeListSellCardModel.fromJson(Map<String, dynamic> json) => MoneyTypeListSellCardModel(
        calculate: CalculateSellCardModel.fromJson(json["calculate"]),
        rate: (json["rate"] == null) ? null : RateForCalculateModel.fromJson(json["rate"]),
        cardList: List<CardListSellCardModel>.from(json["card_list"].map((x) => CardListSellCardModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "calculate": calculate.toJson(),
        "rate": (rate == null) ? null : rate!.toJson(),
        "card_list": List<dynamic>.from(cardList.map((x) => x.toJson())),
      };
}

class CardListSellCardModel {
  CardListSellCardModel({
    required this.qty,
    required this.cardCompanyNameId,
    required this.cardCompanyName,
    // required this.language,
    required this.categoryId,
    required this.category,
    required this.profit,
    required this.sellPrice,
    this.isValidProfitRate = false,
    required this.mainPriceQtyList,
  });

  int qty;
  String cardCompanyNameId;
  String cardCompanyName;
  // String language;
  String categoryId;
  double category;
  double profit;
  bool isValidProfitRate; //for frontend
  SellPriceSellCardModel sellPrice;
  List<MainPriceQty> mainPriceQtyList;

  factory CardListSellCardModel.fromJson(Map<String, dynamic> json) => CardListSellCardModel(
        qty: (-1 * int.parse(json["qty"].toString())),
        cardCompanyNameId: json["card_company_name_id"],
        cardCompanyName: json["card_company_name"],
        // language: json["language"],
        categoryId: json["category_id"],
        category: json["category"],
        profit: json["profit"],
        sellPrice: SellPriceSellCardModel.fromJson(json["sell_price"]),
        mainPriceQtyList: List<MainPriceQty>.from(json["main_price_qty_list"].map((x) => MainPriceQty.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "qty": (-1 * qty),
        "card_company_name_id": cardCompanyNameId,
        "card_company_name": cardCompanyName,
        // "language": language,
        "category_id": categoryId,
        "category": category,
        "profit": profit,
        "sell_price": sellPrice.toJson(),
        "main_price_qty_list": List<dynamic>.from(mainPriceQtyList.map((x) => x.toJson())),
      };
}

class MainPriceQty {
  RateForCalculateModel? rate;
  int qty;
  CardMainPriceListCardModel mainPrice;

  MainPriceQty({
    required this.qty,
    required this.mainPrice,
    required this.rate,
  });

  factory MainPriceQty.fromJson(Map<String, dynamic> json) => MainPriceQty(
        qty: (-1 * int.parse(json["qty"].toString())),
        mainPrice: CardMainPriceListCardModel.fromJson(json["main_price"]),
        rate: (json["rate"] == null) ? null : RateForCalculateModel.fromJson(json["rate"]),
      );

  Map<String, dynamic> toJson() => {
        "qty": (-1 * qty),
        "main_price": mainPrice.toJson(),
        "rate": (rate == null) ? null : rate!.toJson(),
      };
}

class SellPriceSellCardModel {
  SellPriceSellCardModel({
    required this.moneyType,
    required this.value,
    required this.discountValue,
  });

  String moneyType;
  double value;
  String discountValue;

  factory SellPriceSellCardModel.fromJson(Map<String, dynamic> json) => SellPriceSellCardModel(
        moneyType: json["money_type"],
        value: json["value"],
        discountValue: json["discount_value"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "money_type": moneyType,
        "value": value,
        "discount_value": double.parse(formatAndLimitNumberTextGlobal(isAddComma: false, valueStr: discountValue, isRound: false, isAllowZeroAtLast: false)),
      };
}
