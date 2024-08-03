import 'dart:ui';

import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

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
  List<ProfitAndRateElement> exchangeProfitList;
  List<ProfitAndRateElement> sellCardProfitList;
  List<ProfitAndRateElement> transferProfitList;
  List<ProfitAndRateElement> excelProfitList;

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
        exchangeProfitList: List<ProfitAndRateElement>.from(json["exchange_profit_list"].map((x) => ProfitAndRateElement.fromJson(x))),
        sellCardProfitList: List<ProfitAndRateElement>.from(json["sell_card_profit_list"].map((x) => ProfitAndRateElement.fromJson(x))),
        transferProfitList: List<ProfitAndRateElement>.from(json["transfer_profit_list"].map((x) => ProfitAndRateElement.fromJson(x))),
        excelProfitList: List<ProfitAndRateElement>.from(json["excel_profit_list"].map((x) => ProfitAndRateElement.fromJson(x))),
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

class ProfitAndRateElement {
  String moneyType;
  double profit;
  bool isBuyRate;
  double averageRate;

  ProfitAndRateElement({
    required this.moneyType,
    required this.profit,
    required this.isBuyRate,
    required this.averageRate,
  });

  factory ProfitAndRateElement.fromJson(Map<String, dynamic> json) => ProfitAndRateElement(
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
        totalCount: json["total_count"] ?? 0,
        excelCount: json["excel_count"] ?? 0,
        transferCount: json["transfer_count"] ?? 0,
        sellCardCount: json["sell_card_count"] ?? 0,
        exchangeCount: json["exchange_count"] ?? 0,
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

class UpAndDownWallElement {
  DateTime startDate;
  DateTime endDate;
  double value;

  UpAndDownWallElement({
    required this.startDate,
    required this.endDate,
    required this.value,
  });
}

class LineChartModel {
  Color color;
  List<FlSpot> spots;
  LineChartModel({required this.color, required this.spots});

  LineChartBarData lineChartBarData() => LineChartBarData(
        curveSmoothness: 0,
        isCurved: true,
        color: color,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: spots,
      );
}

class ChartYAxis {
  String title;
  int value;
  ChartYAxis({required this.title, required this.value});
}
