// To parse this JSON data, do
//
//     final currencyModel = currencyModelFromJson(jsonString);

import 'dart:convert';

List<CurrencyModel> currencyModelListFromJson({required dynamic str}) => List<CurrencyModel>.from(json.decode(json.encode(str)).map((x) => CurrencyModel.fromJson(x)));

List<dynamic> currencyModelListToJson({required List<CurrencyModel> data}) => List<dynamic>.from(data.map((x) => x.toJson()));

class CurrencyModel {
  CurrencyModel({
    required this.valueList,
    required this.moneyType,
    this.defaultRate,
    this.name,
    this.symbol,
    this.decimalPlace,
    this.moneyTypeLanguagePrint,
    this.deletedDate,
  });

  String moneyType;
  String? symbol;
  String? name;
  int? decimalPlace;
  String? moneyTypeLanguagePrint;
  DateTime? deletedDate;
  double? defaultRate;
  List<int> valueList;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        decimalPlace: json["decimal_place"],
        moneyType: json["money_type"],
        symbol: json["symbol"],
        defaultRate: json["price_rate"],
        name: json["name"],
        valueList:  (json["value_list"] == null) ? [] : List<int>.from(json["value_list"].map((x) => x)),
        moneyTypeLanguagePrint: json["money_type_language_print"],
        deletedDate: (json["deleted_date"] == null) ? null : DateTime.parse(json["deleted_date"]),
      );

  Map<String, dynamic> toJson() => {
        "decimal_place": decimalPlace,
        "money_type": moneyType,
        "deleted_date": (deletedDate == null) ? null : deletedDate!.toIso8601String(),
      };
}
