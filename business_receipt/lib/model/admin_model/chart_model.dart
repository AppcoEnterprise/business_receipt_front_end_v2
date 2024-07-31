import 'package:meta/meta.dart';
import 'dart:convert';

UpAndDownProfitChart upAndDownChartFromJson({required dynamic str}) => UpAndDownProfitChart.fromJson(json.decode(json.encode(str)));

// List<dynamic> upAndDownElementToJson(UpAndDownElement data) => json.encode(data.toJson());

class UpAndDownProfitChart {
  String? moneyType;
  List<UpAndDownProfitElement> upAndDownProfitList;
  // List<UpAndDownCountElement> upAndDownCountList;
  UpAndDownProfitChart({
    required this.moneyType,
    required this.upAndDownProfitList,
    // required this.upAndDownCountList,
  });

  factory UpAndDownProfitChart.fromJson(Map<String, dynamic> json) => UpAndDownProfitChart(
        moneyType: json["money_type"],
        upAndDownProfitList: (json["profit_target_date_list"] == null) ? [] : List<UpAndDownProfitElement>.from(json["profit_target_date_list"].map((x) => UpAndDownProfitElement.fromJson(x))),
        // upAndDownCountList: (json["count_target_date_list"] == null) ? [] : List<UpAndDownCountElement>.from(json["count_target_date_list"].map((x) => UpAndDownCountElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "money_type": moneyType,
        "profit_target_date_list": List<dynamic>.from(upAndDownProfitList.map((x) => x.toJson())),
        // "count_target_date_list": List<dynamic>.from(upAndDownCountList.map((x) => x.toJson())),
      };
}

class UpAndDownProfitElement {
  DateTime startDate;
  DateTime endDate;
  double profitMerge;
  List<ProfitElement> exchangeProfitList;
  List<ProfitElement> sellCardProfitList;
  List<ProfitElement> transferProfitList;
  List<ProfitElement> excelProfitList;

  UpAndDownProfitElement({
    required this.startDate,
    required this.endDate,
    required this.profitMerge,
    required this.exchangeProfitList,
    required this.sellCardProfitList,
    required this.transferProfitList,
    required this.excelProfitList,
  });

  factory UpAndDownProfitElement.fromJson(Map<String, dynamic> json) => UpAndDownProfitElement(
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        exchangeProfitList: List<ProfitElement>.from(json["exchange_profit_list"].map((x) => ProfitElement.fromJson(x))),
        sellCardProfitList: List<ProfitElement>.from(json["sell_card_profit_list"].map((x) => ProfitElement.fromJson(x))),
        transferProfitList: List<ProfitElement>.from(json["transfer_profit_list"].map((x) => ProfitElement.fromJson(x))),
        excelProfitList: List<ProfitElement>.from(json["excel_profit_list"].map((x) => ProfitElement.fromJson(x))),
        profitMerge: json["profit_merge"],
      );

  Map<String, dynamic> toJson() => {
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "exchange_profit_list": List<dynamic>.from(exchangeProfitList.map((x) => x.toJson())),
        "sell_card_profit_list": List<dynamic>.from(sellCardProfitList.map((x) => x.toJson())),
        "transfer_profit_list": List<dynamic>.from(transferProfitList.map((x) => x.toJson())),
        "excel_profit_list": List<dynamic>.from(excelProfitList.map((x) => x.toJson())),
        "profit_merge": profitMerge,
      };
}

class ProfitElement {
  String moneyType;
  double profit;
  bool isBuyRate;
  double averageRate;

  ProfitElement({
    required this.moneyType,
    required this.profit,
    required this.isBuyRate,
    required this.averageRate,
  });

  factory ProfitElement.fromJson(Map<String, dynamic> json) => ProfitElement(
        moneyType: json["money_type"],
        profit: json["profit"]?.toDouble(),
        isBuyRate: json["is_buy_rate"],
        averageRate: json["average_rate"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "money_type": moneyType,
        "profit": profit,
        "is_buy_rate": isBuyRate,
        "average_rate": averageRate,
      };
}

class ChartXAxis {
  String title;
  String subtitle;
  double value;
  ChartXAxis({
    required this.title,
    required this.subtitle,
    // required this.profit,
    required this.value,
    // required this.moneyType,
  });
}

List<UpAndDownCountElement> upAndDownCountElementFromJson({required dynamic str}) => List<UpAndDownCountElement>.from(json.decode(json.encode(str)).map((x) => UpAndDownCountElement.fromJson(x)));

String upAndDownCountElementToJson(List<UpAndDownCountElement> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UpAndDownCountElement {
    DateTime startDate;
    DateTime endDate;
    int totalCount;
    int excelCount;
    int transferCount;
    int sellCardCount;
    int exchangeCount;

    UpAndDownCountElement({
        required this.startDate,
        required this.endDate,
        required this.totalCount,
        required this.excelCount,
        required this.transferCount,
        required this.sellCardCount,
        required this.exchangeCount,
    });

    factory UpAndDownCountElement.fromJson(Map<String, dynamic> json) => UpAndDownCountElement(
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        totalCount: json["total_count"]?? 0,
        excelCount: json["excel_count"]?? 0,
        transferCount: json["transfer_count"]?? 0,
        sellCardCount: json["sell_card_count"]?? 0,
        exchangeCount: json["exchange_count"]?? 0,
    );

    Map<String, dynamic> toJson() => {
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "total_count": totalCount,
        "excel_count": excelCount,
        "transfer_count": transferCount,
        "sell_card_count": sellCardCount,
        "exchange_count": exchangeCount,
    };
}
