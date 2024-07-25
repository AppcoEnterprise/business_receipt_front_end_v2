// To parse this JSON data, do
//
//     final amountAndProfitModel = amountAndProfitModelFromJson(jsonString);

import 'dart:convert';

List<AmountAndProfitModel> amountAndProfitModelFromJson({required dynamic str}) =>
    List<AmountAndProfitModel>.from(json.decode(json.encode(str)).map((x) => AmountAndProfitModel.fromJson(x)));

List<dynamic> amountAndProfitModelToJson(List<AmountAndProfitModel> data) => List<dynamic>.from(data.map((x) => x.toJson()));

class AmountAndProfitModel {
  String moneyType;
  double amount;
  double amountInUsed;
  double profit;
  AmountInUsedAndProfitModel? exchange;
  AmountInUsedAndProfitModel? sellCard;
  AmountInUsedAndProfitModel? transfer;
  AmountInUsedAndProfitModel? excel;

  AmountAndProfitModel({
    required this.moneyType,
    required this.amount,
    required this.amountInUsed,
    required this.profit,
    this.exchange,
    this.sellCard,
    this.transfer,
    this.excel,
  });

  factory AmountAndProfitModel.fromJson(Map<String, dynamic> json) => AmountAndProfitModel(
        moneyType: json["money_type"],
        amount: json["amount"] ?? 0, //TODO: remove ?? 0 just temporary use
        amountInUsed: json["amount_in_used"] ?? 0, //TODO: remove ?? 0 just temporary use
        profit: json["profit"] ?? 0, //TODO: remove ?? 0 just temporary use
        exchange: json["exchange"] == null ? null : AmountInUsedAndProfitModel.fromJson(json["exchange"]),
        sellCard: json["sell_card"] == null ? null : AmountInUsedAndProfitModel.fromJson(json["sell_card"]),
        transfer: json["transfer"] == null ? null : AmountInUsedAndProfitModel.fromJson(json["transfer"]),
        excel: json["excel"] == null ? null : AmountInUsedAndProfitModel.fromJson(json["excel"]),
      );

  Map<String, dynamic> toJson() => {
        "money_type": moneyType,
        "amount": amount,
        "amount_in_used": amountInUsed,
        "profit": profit,
        "exchange": exchange == null ? null : exchange!.toJson(),
        "sell_card": sellCard == null ? null : sellCard!.toJson(),
        "transfer": transfer == null ? null : transfer!.toJson(),
        "excel": excel == null ? null : excel!.toJson(),
      };
}

class AmountInUsedAndProfitModel {
  double amountInUsed;
  double profit;

  AmountInUsedAndProfitModel({
    required this.amountInUsed,
    required this.profit,
  });

  factory AmountInUsedAndProfitModel.fromJson(Map<String, dynamic> json) => AmountInUsedAndProfitModel(
        amountInUsed: json["amount_in_used"] ?? 0, //TODO: remove ?? 0 just temporary use
        profit: json["profit"] ?? 0, //TODO: remove ?? 0 just temporary use
      );

  Map<String, dynamic> toJson() => {
        "amount_in_used": amountInUsed,
        "profit": profit,
      };
}
