// To parse this JSON data, do
//
//     final rateModel = rateModelFromJson(jsonString);

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<RateModel> rateModelListFromJson({required dynamic str}) => List<RateModel>.from(json.decode(json.encode(str)).map((x) => RateModel.fromJson(x)));
List<dynamic> rateModelListToJson({required List<RateModel> data}) => List<dynamic>.from(data.map((x) => x.toJson()));
List<dynamic> rateModelListNoCostValueToJson({required List<RateModel> data}) => List<dynamic>.from(data.map((x) => x.noCostValueToJson()));

RateModel rateModelFromJson({required dynamic str}) => RateModel.fromJson(json.decode(json.encode(str)));
Map<String, dynamic> rateModelToJson({required RateModel data}) => data.toJson();
Map<String, dynamic> rateModelNoCostValueToJson({required RateModel data}) => data.noCostValueToJson();

// [
//     {
//         "rate_type": [
//             "USD",
//             "KHR"
//         ],
//         "buy":  {"_id": "6416322141d5bd0013931dff", "date": "2023-03-19T04:50:25.709Z", "value": 400.06, "discount_list": []},
//         "sell": {"_id": "6416322141d5bd0013931dff", "date": "2023-03-19T04:50:25.709Z", "value": 4000.6, "discount_list": []}
//     },
//     {
//         "rate_type": [
//             "USD",
//             "THB"
//         ],
//         "buy": null,
//         "sell":  {"_id": "6416322141d5bd0013931dff", "date": "2023-03-19T04:50:25.709Z", "value": 4000.6, "discount_list": []},
//         "is_buy_analysis": true,
//         "profit": 0.5
//     },
//     {
//         "rate_type": [
//             "THB",
//             "KHR"
//         ],
//         "buy": null,
//         "sell": null
//     }
// ]
class RateModel {
  RateModel({
    required this.place,
    required this.configPlace,
    required this.rateValueBaseOn,
    required this.rateType,
    required this.buy,
    required this.sell,
    required this.isBuyAnalysis,
    required this.profit,
    required this.display,
    required this.priority,
    required this.limit,
  });
  bool display;
  int place;
  int? configPlace;
  int priority;
  List<List<String>> rateValueBaseOn;
  List<String> rateType;
  BuyOrSellRateModel? buy;
  BuyOrSellRateModel? sell;
  bool? isBuyAnalysis; //const value
  double? profit; //const value
  List<TextEditingController> limit;

  factory RateModel.fromJson(Map<String, dynamic> json) => RateModel(
        display: json["display"],
        priority: json["priority"],
        place: json["place"],
        configPlace: json["config_place"],
        rateValueBaseOn: List<List<String>>.from(json["rate_value_base_on"].map((x) => List<String>.from(x.map((x) => x)))),
        rateType: List<String>.from(json["rate_type"].map((x) => x)),
        buy: (json["buy"] == null) ? null : BuyOrSellRateModel.fromJson(json["buy"]),
        sell: (json["sell"] == null) ? null : BuyOrSellRateModel.fromJson(json["sell"]),
        isBuyAnalysis: json["is_buy_analysis"],
        profit: (json["profit"] == null) ? null : double.parse(json["profit"]),
        limit: List<TextEditingController>.from(json["limit"].map((x) => TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: x.toString(), isRound: true, isAllowZeroAtLast: false)))),
      );

  Map<String, dynamic> toJson() {
    return {
      "rate_type": List<dynamic>.from(rateType.map((x) => x)),
      "buy": buy!.toJson(),
      "sell": sell!.toJson(),
      "is_buy_analysis": isBuyAnalysis,
      "profit": profit,
      "display": display,
      "priority": priority,
      "limit": List<dynamic>.from(limit.map((x) => textEditingControllerToDouble(controller: x))),
    };
  }

  Map<String, dynamic> noCostValueToJson() => {
        "rate_type": List<dynamic>.from(rateType.map((x) => x)),
        "buy": buy!.noCostValueToJson(),
        "sell": sell!.noCostValueToJson(),
        "limit": List<dynamic>.from(limit.map((x) => textEditingControllerToDouble(controller: x))),
        // "is_buy_analysis": isBuyAnalysis,
        // "profit": profit,
      };

  Map<String, dynamic> rateInformationToJson() => {
        "priority": priority,
        "rate_type": List<dynamic>.from(rateType.map((x) => x)),
        "display": display,
        "config_place": configPlace,
        "place": place,
        "rate_value_base_on": List<dynamic>.from(rateValueBaseOn.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "limit": List<dynamic>.from(limit.map((x) => textEditingControllerToDouble(controller: x))),
      };
}

class BuyOrSellRateModel {
  BuyOrSellRateModel({
    this.id,
    this.date,
    required this.value,
    required this.discountOptionList,
    this.profit,
    this.isSelectedPrint = false,
  });

  bool isSelectedPrint;
  String? id; //const value
  DateTime? date; //const value
  TextEditingController value; //double
  double? profit; //const value
  List<TextEditingController> discountOptionList;

  factory BuyOrSellRateModel.fromJson(Map<String, dynamic> json) => BuyOrSellRateModel(
        id: json["_id"],
        date: DateTime.parse(json["date"]),
        profit: (json["profit"] == null) ? null : double.parse(json["profit"]),
        value: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["value"].toString(), isRound: false)),
        discountOptionList: List<TextEditingController>.from(json["discount_option_list"].map((x) => TextEditingController(
              text: formatAndLimitNumberTextGlobal(valueStr: x.toString(), isRound: false, isAllowZeroAtLast: false),
            ))),
      );

  Map<String, dynamic> toJson() {
    return {
        "_id": id,
        "date": date!.toIso8601String(),
        "value": textEditingControllerToDouble(controller: value),
        "discount_option_list": List<dynamic>.from(discountOptionList.map((x) => textEditingControllerToDouble(controller: x))),
        "profit": profit,
      };}
  Map<String, dynamic> noCostValueToJson() => {
        // "_id": id,
        // "date": date.toIso8601String(),
        // "profit": profit,
        "value": textEditingControllerToDouble(controller: value),
        "discount_option_list": List<dynamic>.from(discountOptionList.map((x) => textEditingControllerToDouble(controller: x))),
      };
}

RateModel cloneRateModel({required int rateModelIndex}) {
  // return rateModelFromJson(str: rateModelListAdminGlobal[rateModelIndex].toJson());
  final List<String> rateType = rateModelListAdminGlobal[rateModelIndex].rateType;
  BuyOrSellRateModel? buy;
  final bool isBuyNotNull = (rateModelListAdminGlobal[rateModelIndex].buy != null);
  if (isBuyNotNull) {
    final String? id = rateModelListAdminGlobal[rateModelIndex].buy!.id;
    final DateTime? date = rateModelListAdminGlobal[rateModelIndex].buy!.date;
    List<TextEditingController> discountOptionList = [];
    for (int discountOptionIndex = 0; discountOptionIndex < rateModelListAdminGlobal[rateModelIndex].buy!.discountOptionList.length; discountOptionIndex++) {
      final String discountOptionStr = rateModelListAdminGlobal[rateModelIndex].buy!.discountOptionList[discountOptionIndex].text;
      discountOptionList.add(TextEditingController(text: discountOptionStr));
    }
    final TextEditingController value = TextEditingController(text: rateModelListAdminGlobal[rateModelIndex].buy!.value.text);
    buy = BuyOrSellRateModel(date: date, id: id, value: value, discountOptionList: discountOptionList);
  }

  BuyOrSellRateModel? sell;
  final bool isSellNotNull = (rateModelListAdminGlobal[rateModelIndex].sell != null);
  if (isSellNotNull) {
    final String? id = rateModelListAdminGlobal[rateModelIndex].sell!.id;
    final DateTime? date = rateModelListAdminGlobal[rateModelIndex].sell!.date;
    List<TextEditingController> discountOptionList = [];
    for (int discountOptionIndex = 0; discountOptionIndex < rateModelListAdminGlobal[rateModelIndex].sell!.discountOptionList.length; discountOptionIndex++) {
      final TextEditingController discountOption = TextEditingController(text: rateModelListAdminGlobal[rateModelIndex].sell!.discountOptionList[discountOptionIndex].text);
      discountOptionList.add(discountOption);
    }
    final TextEditingController value = TextEditingController(text: rateModelListAdminGlobal[rateModelIndex].sell!.value.text);
    sell = BuyOrSellRateModel(date: date, id: id, value: value, discountOptionList: discountOptionList);
  }
  final bool? isBuyAnalysis = rateModelListAdminGlobal[rateModelIndex].isBuyAnalysis;
  final double? profit = rateModelListAdminGlobal[rateModelIndex].profit;
  final int place = rateModelListAdminGlobal[rateModelIndex].place;
  final int? configPlace = rateModelListAdminGlobal[rateModelIndex].configPlace;
  final bool display = rateModelListAdminGlobal[rateModelIndex].display;
  final int priority = rateModelListAdminGlobal[rateModelIndex].priority;
  List<List<String>> rateValueBaseOn = [[], []];
  if (rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.isNotEmpty && rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.isNotEmpty) {
    rateValueBaseOn = [
      [rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.first, rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.last],
      [rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.first, rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.last],
    ];
  }
  List<TextEditingController> limit = [];
  if (rateModelListAdminGlobal[rateModelIndex].limit.isEmpty) {
    limit = [TextEditingController(), TextEditingController()];
  } else {
    for (int limitIndex = 0; limitIndex < rateModelListAdminGlobal[rateModelIndex].limit.length; limitIndex++) {
      limit.add(TextEditingController(text: rateModelListAdminGlobal[rateModelIndex].limit[limitIndex].text));
    }
  }

  return RateModel(
    limit: limit,
    rateType: rateType,
    buy: buy,
    sell: sell,
    isBuyAnalysis: isBuyAnalysis,
    profit: profit,
    configPlace: configPlace,
    rateValueBaseOn: rateValueBaseOn,
    place: place,
    display: display,
    priority: priority,
  );
}

class RateForCalculateModel {
  RateForCalculateModel({
    this.rateId,
    this.isSelectedOtherRate = false,
    this.isBuyRate,
    required this.rateType,
    this.value,
    this.profit,
    required this.percentage,
    required this.discountValue,
    required this.usedModelList,
  });

  bool isSelectedOtherRate;
  String? rateId;
  bool? isBuyRate;
  List<String> rateType;
  double? value;
  double? profit;
  TextEditingController percentage;
  TextEditingController discountValue;
  List<LeftListAnalysisExchangeModel> usedModelList;

  factory RateForCalculateModel.fromJson(Map<String, dynamic> json) => RateForCalculateModel(
        rateId: json["rate_id"],
        isBuyRate: json["is_buy"],
        rateType: List<String>.from(json["rate_type"].map((x) => x)),
        value: json["value"],
        profit: json["profit"],
        percentage: TextEditingController(
          text: formatAndLimitNumberTextGlobal(
            valueStr: (json["percentage"] ?? "").toString(),
            isRound: false,
            isAllowZeroAtLast: false,
          ),
        ),
        discountValue: TextEditingController(
          text: formatAndLimitNumberTextGlobal(
            valueStr: json["discount_value"].toString(),
            isRound: false,
            isAllowZeroAtLast: false,
          ),
        ),
        usedModelList: List<LeftListAnalysisExchangeModel>.from(json["used_list"].map((x) => LeftListAnalysisExchangeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "profit": profit,
        "rate_id": rateId,
        "is_buy": isBuyRate,
        "rate_type": List<dynamic>.from(rateType.map((x) => x)),
        "value": value,
        "percentage": percentage.text.isEmpty ? null : textEditingControllerToDouble(controller: percentage),
        "discount_value": textEditingControllerToDouble(controller: discountValue),
        "used_list": List<dynamic>.from(usedModelList.map((x) => x.toJson())),
      };
}

RateForCalculateModel cloneRateForCalculate({required RateForCalculateModel rateForCalculate}) {
  // return RateForCalculateModel.fromJson(rateForCalculate.toJson());
  final String? rateId = rateForCalculate.rateId;
  final bool? isBuyRate = rateForCalculate.isBuyRate;
  final List<String> rateType = rateForCalculate.rateType;
  final double? value = rateForCalculate.value;
  final TextEditingController discountValue = TextEditingController(text: rateForCalculate.discountValue.text);
  final TextEditingController percentageValue = TextEditingController(text: rateForCalculate.percentage.text);
  return RateForCalculateModel(
    rateId: rateId,
    isBuyRate: isBuyRate,
    rateType: rateType,
    value: value,
    discountValue: discountValue,
    usedModelList: rateForCalculate.usedModelList,
    percentage: percentageValue,
  );
}

class AnalysisExchangeModel {
  List<String> rateType;
  bool? isBuy;
  double? profit;
  double? firstRateValue;
  double? lastRateValue;
  double? totalGetMoney;
  double? averageRateValue;
  double? totalGiveMoney;
  List<LeftListAnalysisExchangeModel> leftList;

  AnalysisExchangeModel({
    required this.rateType,
    this.isBuy,
    this.profit,
    this.firstRateValue,
    this.lastRateValue,
    this.totalGetMoney,
    this.averageRateValue,
    this.totalGiveMoney,
    required this.leftList,
  });

  factory AnalysisExchangeModel.fromJson(Map<String, dynamic> json) => AnalysisExchangeModel(
        rateType: List<String>.from(json["rate_type"].map((x) => x)),
        isBuy: json["is_buy"],
        profit: json["profit"],
        firstRateValue: json["first_rate_value"],
        lastRateValue: json["last_rate_value"],
        totalGetMoney: json["total_get_money"],
        averageRateValue: json["average_rate_value"]?.toDouble(),
        totalGiveMoney: json["total_give_money"],
        leftList: List<LeftListAnalysisExchangeModel>.from(json["left_list"].map((x) => LeftListAnalysisExchangeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rate_type": List<dynamic>.from(rateType.map((x) => x)),
        "is_buy": isBuy,
        "profit": profit,
        "first_rate_value": firstRateValue,
        "last_rate_value": lastRateValue,
        "total_get_money": totalGetMoney,
        "average_rate_value": averageRateValue,
        "total_give_money": totalGiveMoney,
        "left_list": List<dynamic>.from(leftList.map((x) => x.toJson())),
      };
}

class LeftListAnalysisExchangeModel {
  double getMoney;
  double giveMoney;
  double rateValue;

  LeftListAnalysisExchangeModel({
    required this.getMoney,
    required this.giveMoney,
    required this.rateValue,
  });

  factory LeftListAnalysisExchangeModel.fromJson(Map<String, dynamic> json) => LeftListAnalysisExchangeModel(
        getMoney: json["get_money"],
        giveMoney: json["give_money"],
        rateValue: json["rate_value"],
      );

  Map<String, dynamic> toJson() => {
        "get_money": getMoney,
        "give_money": giveMoney,
        "rate_value": rateValue,
      };
}
