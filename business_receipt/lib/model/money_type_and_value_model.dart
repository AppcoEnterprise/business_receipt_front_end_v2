import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:flutter/material.dart';

class MoneyTypeAndValueModel {
  double value;
  String? sellPriceId;
  String moneyType;
  MoneyTypeAndValueModel({required this.value, required this.moneyType, this.sellPriceId});
  factory MoneyTypeAndValueModel.fromJson(Map<String, dynamic> json) => MoneyTypeAndValueModel(
        value: json["value"],
        moneyType: json["money_type"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "money_type": moneyType,
      };
}

class MoneyTypeAndValueForInputModel {
  TextEditingController amount;
  String moneyType;
  MoneyTypeAndValueForInputModel({required this.amount, required this.moneyType});
  factory MoneyTypeAndValueForInputModel.fromJson(Map<String, dynamic> json) => MoneyTypeAndValueForInputModel(
        amount: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["amount"].toString(), isRound: false,
      isAllowZeroAtLast: false)),
        moneyType: json["money_type"],
      );

  Map<String, dynamic> toJson() => {
        "amount": textEditingControllerToDouble(controller: amount),
        "money_type": moneyType,
      };
}