// To parse this JSON data, do
//
//     final cardModel = cardModelFromJson(jsonString);

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<CardModel> cardModelListFromJson({required dynamic str}) => List<CardModel>.from(json.decode(json.encode(str)).map((x) => CardModel.fromJson(x)));
List<dynamic> cardModelListToJson({required List<CardModel> data}) => List<dynamic>.from(data.map((x) => x.toJson()));
List<dynamic> cardModelListNoCostValueToJson({required List<CardModel> data}) => List<dynamic>.from(data.map((x) => x.noCostValueToJson()));

CardModel cardModelFromJson({required dynamic str}) => CardModel.fromJson(json.decode(json.encode(str)));
Map<String, dynamic> cardModelToJson({required CardModel data}) => data.toJson();
Map<String, dynamic> cardModelCostValueToJson({required CardModel data}) => data.noCostValueToJson();

class CardModel {
  CardModel({
    this.id,
    required this.cardCompanyName,
    // required this.language,
    required this.categoryList,
    this.deletedDate,
  });
  String? id; //const value
  TextEditingController cardCompanyName; //String
  // String language;
  List<CardCategoryListCardModel> categoryList;
  DateTime? deletedDate;

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json["_id"],
      cardCompanyName: TextEditingController(text: json["card_company_name"]),
      // language: json["language"],
      categoryList: List<CardCategoryListCardModel>.from(json["category_list"].map((x) => CardCategoryListCardModel.fromJson(x))),
      deletedDate: (json["deleted_date"] == null) ? null : DateTime.parse(json["deleted_date"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "card_company_name": cardCompanyName.text,
        // "language": language,
        "category_list": List<dynamic>.from(categoryList.map((x) => x.toJson())),
        "deleted_date": (deletedDate == null) ? null : deletedDate!.toIso8601String(),
      };

  Map<String, dynamic> noCostValueToJson() => {
        // "_id": id,
        "card_company_name": cardCompanyName.text,
        // "language": language,
        "category_list": List<dynamic>.from(categoryList.map((x) => x.noCostValueToJson())),
        "deleted_date": (deletedDate == null) ? null : deletedDate!.toIso8601String(),
      };
}

class CardCategoryListCardModel {
  CardCategoryListCardModel({
    this.id,
    // required this.mainPriceSeparateByPercentageList,
    required this.category,
    required this.qty,
    required this.mainPriceList,
    required this.sellPriceList,
    this.selectedSellPriceIndex = 0, //this is not index of List<CardSellPriceListCardModel>. but it is index of List<MoneyTypeAndValueModel>
    this.selectedSellDiscountPriceIndex = 0, //this is not index of List<CardSellPriceListCardModel>. but it is index of List<MoneyTypeAndValueModel>
    this.isShowTextField = false,
    this.discountPriceAndMoneyTypeController,
    this.deletedDate,
    required this.limitList,
    required this.totalStock,
    required this.count,
    required this.ordered,
    this.skipCardMainStockList = queryLimitNumberGlobal,
    this.outOfDataQueryCardMainStockList = false,
    this.isSelectedPrint = false,
  });

  int skipCardMainStockList;
  bool outOfDataQueryCardMainStockList;

  DateTime? deletedDate;
  String? id; //const value
  int totalStock;
  int count;
  int ordered;
  bool isSelectedPrint; //for frontend
  TextEditingController category; //double
  // List<CardMainPriceListCardModel> mainPriceSeparateByPercentageList;
  List<CardMainPriceListCardModel> mainPriceList;
  List<CardSellPriceListCardModel> sellPriceList;
  TextEditingController qty; //for frontend
  int selectedSellPriceIndex; //for frontend
  int selectedSellDiscountPriceIndex; //for frontend
  bool isShowTextField; //for frontend
  TextEditingController? discountPriceAndMoneyTypeController; //for frontend
  List<LimitModel> limitList;

  factory CardCategoryListCardModel.fromJson(Map<String, dynamic> json) => CardCategoryListCardModel(
        id: json["_id"],
        totalStock: json["total_stock"] ?? 0,
        count: json["count"] ?? 0,
        ordered: json["ordered"] ?? 0,
        qty: TextEditingController(),
        // mainPriceSeparateByPercentageList: [],
        category: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["category"].toString(), isRound: false, isAllowZeroAtLast: false)),
        mainPriceList: List<CardMainPriceListCardModel>.from(json["main_price_list"].map((x) => CardMainPriceListCardModel.fromJson(x))),
        sellPriceList: List<CardSellPriceListCardModel>.from(json["sell_price_list"].map((x) => CardSellPriceListCardModel.fromJson(x))),
        deletedDate: (json["deleted_date"] == null) ? null : DateTime.parse(json["deleted_date"]),
        limitList: (json["limit_list"] == null) ? [] : List<LimitModel>.from(json["limit_list"].map((x) => LimitModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category": textEditingControllerToDouble(controller: category),
        "main_price_list": List<dynamic>.from(mainPriceList.map((x) => x.toJson())),
        "sell_price_list": List<dynamic>.from(sellPriceList.map((x) => x.toJson())),
        "deleted_date": (deletedDate == null) ? null : deletedDate!.toIso8601String(),
        "limit_list": List<dynamic>.from(limitList.map((x) => x.toJson())),
      };

  Map<String, dynamic> noCostValueToJson() => {
        // "_id": id,
        "category": textEditingControllerToDouble(controller: category),
        "main_price_list": List<dynamic>.from(mainPriceList.map((x) => x.noCostValueToJson())),
        "sell_price_list": List<dynamic>.from(sellPriceList.map((x) => x.toJson())),
        "deleted_date": (deletedDate == null) ? null : deletedDate!.toIso8601String(),
        "limit_list": List<dynamic>.from(limitList.map((x) => x.toJson())),
      };
}

class CardMainPriceListCardModel {
  CardMainPriceListCardModel({
    required this.remark,
    this.dateOld,
    this.isDelete = false,
    this.isAddToStock = true,
    this.id,
    this.employeeName,
    this.employeeId,
    this.moneyType,
    this.maxStock = 0,
    required this.price,
    required this.stock,
    required this.rateList,
    this.date,
    this.overwriteOnId,
    required this.activeLogModelList,
  });
  List<ActiveLogModel> activeLogModelList;
  String? employeeName;
  String? employeeId;
  bool isDelete;
  TextEditingController remark;
  String? id; //const value
  bool isAddToStock;
  String? moneyType;
  int maxStock;
  TextEditingController price; //double
  TextEditingController stock; //int
  List<RateForCalculateModel> rateList;
  DateTime? date;
  DateTime? dateOld;
  String? overwriteOnId;

  factory CardMainPriceListCardModel.fromJson(Map<String, dynamic> json_) {
    return CardMainPriceListCardModel(
      remark: TextEditingController(text: json_["remark"]),
      overwriteOnId: (json_["overwrite_on_id"] == null) ? null : json_["overwrite_on_id"],
      isDelete: (json_["is_delete"] == null) ? false : json_["is_delete"],
      id: json_["_id"],
      isAddToStock: json_["is_add_to_stock"],
      moneyType: json_["money_type"],
      employeeName: json_["employee_name"],
      employeeId: json_["employee_id"],
      maxStock: json_["max_stock"],
      price: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json_["price"].toString(), isRound: false, isAllowZeroAtLast: false)),
      stock: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json_["stock"].toString(), isRound: false, isAllowZeroAtLast: false)),
      rateList: List<RateForCalculateModel>.from(json_["rate_list"].map((x) => RateForCalculateModel.fromJson(x))),
      date: DateTime.parse(json_["date"]),
      activeLogModelList: (json_["active_log_list"] == null) ? [] : List<ActiveLogModel>.from(json_["active_log_list"].map((x) => ActiveLogModel.fromJson(x))),
      dateOld: (json_["date_old"] == null) ? null : DateTime.parse(json_["date_old"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "remark": remark.text,
        "is_add_to_stock": false,
        "_id": id,
        "is_delete": isDelete,
        "date": date!.toIso8601String(),
        "money_type": moneyType,
        "max_stock": maxStock,
        "price": textEditingControllerToDouble(controller: price),
        "stock": textEditingControllerToInt(controller: stock),
        "rate_list": List<dynamic>.from(rateList.map((x) => x.toJson())),
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),
      };

  Map<String, dynamic> noCostValueToJson() => {
        "is_add_to_stock": true,
        "remark": remark.text,
        // "_id": id,
        "is_delete": isDelete,
        // "date": date.toIso8601String(),
        "money_type": moneyType,
        "max_stock": maxStock,
        "price": textEditingControllerToDouble(controller: price),
        "stock": textEditingControllerToInt(controller: stock),
        "rate_list": List<dynamic>.from(rateList.map((x) => x.toJson())),
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),
      };
}

class CardSellPriceListCardModel {
  CardSellPriceListCardModel({
    required this.moneyType,
    required this.price,
    required this.startValue,
    required this.endValue,
    this.isSelectedPrint = true,
    this.id,
  });
  String? id; //const value
  String? moneyType;
  bool isSelectedPrint;
  TextEditingController price; //double
  TextEditingController startValue; //int
  TextEditingController endValue; //int

  factory CardSellPriceListCardModel.fromJson(Map<String, dynamic> json) => CardSellPriceListCardModel(
        id: json["_id"],
        moneyType: json["money_type"],
        price: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["price"].toString(), isRound: false, isAllowZeroAtLast: false)),
        startValue:
            TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["start_value"].toString(), isRound: false, isAllowZeroAtLast: false)),
        endValue: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["end_value"].toString(), isRound: false, isAllowZeroAtLast: false)),
      );

  Map<String, dynamic> toJson() => (id == null || id == "")
      ? {
          "money_type": moneyType,
          "price": textEditingControllerToDouble(controller: price),
          "start_value": textEditingControllerToInt(controller: startValue),
          "end_value": textEditingControllerToInt(controller: endValue),
        }
      : {
          "_id": id,
          "money_type": moneyType,
          "price": textEditingControllerToDouble(controller: price),
          "start_value": textEditingControllerToInt(controller: startValue),
          "end_value": textEditingControllerToInt(controller: endValue),
        };

  // Map<String, dynamic> noCostValueToJson() => {
  //       // "_id": id,
  //       "money_type": moneyType,
  //       "price": textEditingControllerToDouble(controller: price),
  //       "start_value": textEditingControllerToInt(controller: startValue),
  //       "end_value": textEditingControllerToInt(controller: endValue),
  //     };
}

class LimitModel {
  LimitModel({
    required this.moneyType,
    required this.limit,
  });
  String? moneyType;
  List<TextEditingController> limit;

  factory LimitModel.fromJson(Map<String, dynamic> json) => LimitModel(
        moneyType: json["money_type"],
        limit: List<TextEditingController>.from(json["limit"]
            .map((x) => TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: x.toString(), isRound: true, isAllowZeroAtLast: false)))),
      );

  Map<String, dynamic> toJson() => {
        "money_type": moneyType,
        "limit": List<dynamic>.from(limit.map((x) => textEditingControllerToDouble(controller: x))),
      };
}

CardModel cloneCardModel({required int cardIndex, required List<CardModel> cardModelList}) {
// return cardModelFromJson(str: cardListAdminGlobal[cardIndex].toJson());
  final String? id = cardModelList[cardIndex].id;
  final String cardCompanyName = cardModelList[cardIndex].cardCompanyName.text;
  final DateTime? deletedDate = cardModelList[cardIndex].deletedDate;

  // final String language = cardModelListAdminGlobal[cardIndex].language;
  List<CardCategoryListCardModel> categoryList = [];
  for (int categoryIndex = 0; categoryIndex < cardModelList[cardIndex].categoryList.length; categoryIndex++) {
    final String? id = cardModelList[cardIndex].categoryList[categoryIndex].id;
    final String category = cardModelList[cardIndex].categoryList[categoryIndex].category.text;
    final DateTime? deletedDate = cardModelList[cardIndex].categoryList[categoryIndex].deletedDate;
    final int totalStock = cardModelList[cardIndex].categoryList[categoryIndex].totalStock;
    final int count = cardModelList[cardIndex].categoryList[categoryIndex].count;
    final int ordered = cardModelList[cardIndex].categoryList[categoryIndex].ordered;
    List<CardMainPriceListCardModel> mainPriceList = [];
    for (int mainPriceIndex = 0; mainPriceIndex < cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList.length; mainPriceIndex++) {
      final DateTime? date = cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].date;
      final bool isDelete = cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].isDelete;
      final String? id = cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].id;
      final String? employeeId = cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].employeeId;
      final String? employeeName = cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].employeeName;
      final String? moneyType = cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].moneyType;
      final String price = cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].price.text;
      final String stock = cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].stock.text;
      final String remark = cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].remark.text;
      final int maxStock = cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].maxStock;
      final bool isAddToStock = cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].isAddToStock;
      final List<RateForCalculateModel> rateList = [];
      for (int rateIndex = 0; rateIndex < cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList.length; rateIndex++) {
        RateForCalculateModel rate =
            cloneRateForCalculate(rateForCalculate: cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList[rateIndex]);
        rateList.add(rate);
      }

      final CardMainPriceListCardModel cardMainPriceListModel = CardMainPriceListCardModel(
        activeLogModelList: cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].activeLogModelList,
        isAddToStock: isAddToStock,
        date: date,
        isDelete: isDelete,
        moneyType: moneyType,
        price: TextEditingController(text: price),
        stock: TextEditingController(text: stock),
        rateList: rateList,
        id: id,
        maxStock: maxStock,
        remark: TextEditingController(text: remark),
        employeeId: employeeId,
        employeeName: employeeName,
      );
      mainPriceList.add(cardMainPriceListModel);
    }

    List<CardSellPriceListCardModel> sellPriceList = [];
    for (int sellPriceIndex = 0; sellPriceIndex < cardModelList[cardIndex].categoryList[categoryIndex].sellPriceList.length; sellPriceIndex++) {
      final String? id = cardModelList[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].id;
      final String? moneyType = cardModelList[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType;
      final String price = cardModelList[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].price.text;
      final String startValue = cardModelList[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].startValue.text;
      final String endValue = cardModelList[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].endValue.text;
      final CardSellPriceListCardModel cardSellPriceListModel = CardSellPriceListCardModel(
        id: id,
        moneyType: moneyType,
        price: TextEditingController(text: price),
        startValue: TextEditingController(text: startValue),
        endValue: TextEditingController(text: endValue),
      );
      sellPriceList.add(cardSellPriceListModel);
    }

    List<LimitModel> limitList = [];
    for (int limitIndex = 0; limitIndex < cardModelList[cardIndex].categoryList[categoryIndex].limitList.length; limitIndex++) {
      final String? moneyType = cardModelList[cardIndex].categoryList[categoryIndex].limitList[limitIndex].moneyType;
      List<TextEditingController> limit = [];
      if (cardModelList[cardIndex].categoryList[categoryIndex].limitList[limitIndex].limit.isEmpty) {
        limit = [TextEditingController(), TextEditingController()];
      } else {
        for (int limitSubIndex = 0; limitSubIndex < cardModelList[cardIndex].categoryList[categoryIndex].limitList[limitIndex].limit.length; limitSubIndex++) {
          limit.add(TextEditingController(text: cardModelList[cardIndex].categoryList[categoryIndex].limitList[limitIndex].limit[limitSubIndex].text));
        }
      }
      final LimitModel limitModel = LimitModel(moneyType: moneyType, limit: limit);
      limitList.add(limitModel);
    }

    categoryList.add(CardCategoryListCardModel(
      ordered: ordered,
      totalStock: totalStock,
      count: count,
      deletedDate: deletedDate,
      category: TextEditingController(text: category),
      mainPriceList: mainPriceList,
      sellPriceList: sellPriceList,
      id: id,
      qty: TextEditingController(),
      limitList: limitList,
      // mainPriceSeparateByPercentageList: [],
    ));
  }
  return CardModel(cardCompanyName: TextEditingController(text: cardCompanyName), categoryList: categoryList, id: id, deletedDate: deletedDate);
}
