// To parse this JSON data, do
//
//     final otherInOrOutComeModel = otherInOrOutComeModelFromJson(jsonString);

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<OtherInOrOutComeModel> otherInOrOutComeModelListFromJson({required dynamic str}) => List<OtherInOrOutComeModel>.from(json.decode(json.encode(str)).map((x) => OtherInOrOutComeModel.fromJson(x)));
OtherInOrOutComeModel otherInOrOutComeModelFromJson({required dynamic str}) => OtherInOrOutComeModel.fromJson(json.decode(json.encode(str)));

String otherInOrOutComeModelToJson({required List<OtherInOrOutComeModel> data, required bool isIncome}) => json.encode(List<dynamic>.from(data.map((x) => x.toJson(isIncome: isIncome))));

class OtherInOrOutComeModel {
  TextEditingController remark;
  String? id;
  DateTime? date;
  String? moneyType;
  // TextEditingController detail;
  TextEditingController value;
  bool isDelete;
  String? overwriteOnId;
List<ActiveLogModel> activeLogModelList;


  OtherInOrOutComeModel({
required this.activeLogModelList,

    this.id,
    this.date,
    this.moneyType,
    // required this.detail,
    required this.value,
    this.isDelete = false,
    this.overwriteOnId,
    required this.remark,
  });

  factory OtherInOrOutComeModel.fromJson(Map<String, dynamic> json) => OtherInOrOutComeModel(
        // remark: json["remark"],
        isDelete: (json["is_delete"] == null) ? false : json["is_delete"],
        overwriteOnId: (json["overwrite_on_id"] == null) ? null : json["overwrite_on_id"],
        id: json["_id"],
        date: DateTime.parse(json["date"]),
        moneyType: json["money_type"],
        remark: TextEditingController(text: json["remark"]),
activeLogModelList: List<ActiveLogModel>.from(json["active_log_list"].map((x) => ActiveLogModel.fromJson(x))),  

        value: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["value"].toString(), isRound: true, isAllowZeroAtLast: false)),
      );

  Map<String, dynamic> toJson({required bool isIncome}) => {
        "_id": id,
        "date": date!.toIso8601String(),
        "money_type": moneyType,
        "remark": remark.text,
"active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),

        "value": ((isIncome ? 1 : -1) * textEditingControllerToDouble(controller: value)!),
      };
  Map<String, dynamic> constValueToJson({required bool isIncome}) => {
        // "date": date.toIso8601String(),
        "money_type": moneyType,
        "remark": remark.text,
"active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),

        "value": ((isIncome ? 1 : -1) * textEditingControllerToDouble(controller: value)!),
      };
}
