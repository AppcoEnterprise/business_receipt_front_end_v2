// To parse this JSON data, do
//
//     final cashModel = cashModelFromJson(jsonString);

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

CashModel cashModelFromJson({required dynamic str}) => CashModel.fromJson(json.decode(json.encode(str)));

class CashModel {
  String? mergeBy;
  List<CashList> cashList;

  CashModel({
    this.mergeBy,
    required this.cashList,
  });

  factory CashModel.fromJson(Map<String, dynamic> json) => CashModel(
        mergeBy: json["merge_by"],
        cashList: List<CashList>.from(json["cash_list"].map((x) => CashList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "merge_by": mergeBy,
        "cash_list": List<dynamic>.from(cashList.map((x) => x.toJson())),
      };
}

class CashList {
  String moneyType;
  bool isBuyRate;
  TextEditingController averageRate;
  List<TextEditingController> moneyList;

  CashList({
    required this.moneyType,
    required this.isBuyRate,
    required this.averageRate,
    required this.moneyList,
  });

  factory CashList.fromJson(Map<String, dynamic> json) => CashList(
        moneyType: json["money_type"],
        isBuyRate: json["is_buy_rate"],
        averageRate: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["average_rate"].toString(), isRound: true, isAllowZeroAtLast: false)),
        moneyList: List<TextEditingController>.from(
          json["money_list"].map((x) => TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: x.toString(), isRound: true, isAllowZeroAtLast: false))),
        ),
      );

  Map<String, dynamic> toJson() => {
        "money_type": moneyType,
        "is_buy_rate": isBuyRate,
        "average_rate": textEditingControllerToDouble(controller: averageRate),
        "money_list": List<dynamic>.from(moneyList.map((x) => textEditingControllerToDouble(controller: x))),
      };
}

CashModel cloneCashModel({required CashModel cashModel}) {
  final String? mergeBy = cashModel.mergeBy;
  List<CashList> cashList = [];
  for (int cashIndex = 0; cashIndex < cashModel.cashList.length; cashIndex++) {
    final TextEditingController averageRate = TextEditingController(text: cashModel.cashList[cashIndex].averageRate.text);
    final bool isBuyRate = cashModel.cashList[cashIndex].isBuyRate;
    final String moneyType = cashModel.cashList[cashIndex].moneyType;
    List<TextEditingController> moneyList = [];
    for (int moneyIndex = 0; moneyIndex < cashModel.cashList[cashIndex].moneyList.length; moneyIndex++) {
      moneyList.add(TextEditingController(text: cashModel.cashList[cashIndex].moneyList[moneyIndex].text));
    }
    cashList.add(CashList(averageRate: averageRate, isBuyRate: isBuyRate, moneyList: moneyList, moneyType: moneyType));
  }
  return CashModel(mergeBy: mergeBy, cashList: cashList);
}
