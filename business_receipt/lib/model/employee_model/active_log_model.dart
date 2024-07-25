// To parse this JSON data, do
//
//     final activeLogModel = activeLogModelFromJson(jsonString);

import 'dart:convert';

import 'package:business_receipt/env/value_env/active_log.dart';
import 'package:business_receipt/env/value_env/color_env.dart';

List<ActiveLogModel> activeLogModelListFromJson({required dynamic str}) =>
    List<ActiveLogModel>.from(json.decode(json.encode(str)).map((x) => ActiveLogModel.fromJson(x)));

String activeLogModelListToJson(List<ActiveLogModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ActiveLogModel {
  String? idTemp;
  ActiveLogTypeEnum activeType;
  DateTime? startDate;
  DateTime? endDate;
  List<Location> locationList;

  ActiveLogModel({
    this.idTemp,
    required this.activeType,
    this.startDate,
    this.endDate,
    required this.locationList,
  });

  factory ActiveLogModel.fromJson(Map<String, dynamic> json) => ActiveLogModel(
        activeType: getActiveLogStringToEnum(activeLogTypeString: json["active_type"]),
        startDate: DateTime.parse(json["start_date"]),
        endDate: (json["end_date"] == null) ? null : DateTime.parse(json["end_date"]),
        locationList: List<Location>.from(json["location"].map((x) => Location.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "active_type": getActiveLogEnumToString(activeLogTypeEnum: activeType),
        "start_date": startDate!.toIso8601String(),
        "end_date": (endDate == null) ? null : endDate!.toIso8601String(),
        "location": List<dynamic>.from(locationList.map((x) => x.toJson())),
      };
}

class Location {
  ColorEnum? color;
  String title;
  String subtitle;

  Location({
    this.color,
    required this.title,
    required this.subtitle,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        color: (json["color"] == null) ? null : getColorStringToEnum(colorString: json["color"]),
        title: json["title"],
        subtitle: json["subtitle"],
      );

  Map<String, dynamic> toJson() => {
        "color": (color == null) ? null : getColorEnumToString(colorEnum: color!),
        "title": title,
        "subtitle": subtitle,
      };
}
