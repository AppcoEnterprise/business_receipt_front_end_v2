// To parse this JSON data, do
//
//     final missionModel = missionModelFromJson(jsonString);

import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

MissionModel missionModelFromJson({required dynamic str}) => MissionModel.fromJson(json.decode(json.encode(str)));

class MissionModel {
  List<CloseSellingDate> closeSellingDate;
  int totalService;

  MissionModel({
    required this.closeSellingDate,
    required this.totalService,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) => MissionModel(
      closeSellingDate: List<CloseSellingDate>.from(json["close_selling_date"].map((x) => CloseSellingDate.fromJson(x))), totalService: json["total_service"]);

  Map<String, dynamic> toJson() => {
        "close_selling_date": List<dynamic>.from(closeSellingDate.map((x) => x.toJson())),
      };
}

class CloseSellingDate {
  DateTime targetDate;
  TextEditingController count;

  CloseSellingDate({
    required this.targetDate,
    required this.count,
  });

  factory CloseSellingDate.fromJson(Map<String, dynamic> json) => CloseSellingDate(
        targetDate: DateTime.parse(json["target_date"]),
        // count: TextEditingController(text: json["count"]),
        count: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["count"].toString(), isRound: true, isAllowZeroAtLast: false)),
      );

  Map<String, dynamic> toJson() => {
        "target_date": targetDate.toIso8601String(),
        "count": textEditingControllerToInt(controller: count),
      };
}

MissionModel cloneMissionAdmin() {
  List<CloseSellingDate> closeSellingList = [];
  for (int closeSellingIndex = 0; closeSellingIndex < missionModelGlobal.closeSellingDate.length; closeSellingIndex++) {
    final TextEditingController count = TextEditingController(text: missionModelGlobal.closeSellingDate[closeSellingIndex].count.text);
    final DateTime date = missionModelGlobal.closeSellingDate[closeSellingIndex].targetDate;
    final DateTime targetDate = defaultDate(hour: date.hour, minute: date.minute, second: date.second);
    closeSellingList.add(CloseSellingDate(count: count, targetDate: targetDate));
  }
  final int totalService = missionModelGlobal.totalService;
  return MissionModel(closeSellingDate: closeSellingList, totalService: totalService);
}
