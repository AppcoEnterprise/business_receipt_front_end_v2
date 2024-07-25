class UpAndDownChart {
  String moneyType;
  List<UpAndDownElement> upAndDownList;

  UpAndDownChart({
    required this.moneyType,
    required this.upAndDownList,
  });

  factory UpAndDownChart.fromJson(Map<String, dynamic> json) => UpAndDownChart(
        moneyType: json["money_type"],
        upAndDownList: List<UpAndDownElement>.from(json["up_and_down_list"].map((x) => UpAndDownElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "money_type": moneyType,
        "up_and_down_list": List<dynamic>.from(upAndDownList.map((x) => x.toJson())),
      };
}

class UpAndDownElement {
  DateTime startDate;
  DateTime endDate;
  double value;

  UpAndDownElement({
    required this.startDate,
    required this.endDate,
    required this.value,
  });

  factory UpAndDownElement.fromJson(Map<String, dynamic> json) => UpAndDownElement(
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "value_list": value,
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
