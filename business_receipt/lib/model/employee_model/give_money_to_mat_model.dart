// To parse this JSON data, do
//
//     final giveMoneyToMatModel = giveMoneyToMatModelFromJson(jsonString);

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<GiveMoneyToMatModel> giveMoneyToMatModelListFromJson({required dynamic str}) =>
    List<GiveMoneyToMatModel>.from(json.decode(json.encode(str)).map((x) => GiveMoneyToMatModel.fromJson(x)));
GiveMoneyToMatModel giveMoneyToMatModelFromJson({required dynamic str}) => GiveMoneyToMatModel.fromJson(json.decode(json.encode(str)));

String giveMoneyToMatModelToJson(List<GiveMoneyToMatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GiveMoneyToMatModel {
  TextEditingController remark;
  String? id;
  DateTime? date;
  String? moneyType;
  TextEditingController value;
  String? employeeId;
  String? employeeName;
  bool isDelete;
  String? overwriteOnId;
  bool isGetFromMat;
  List<ActiveLogModel> activeLogModelList;

  GiveMoneyToMatModel({
    required this.activeLogModelList,
    required this.remark,
    this.id,
    this.date,
    this.moneyType,
    required this.value,
    this.employeeId,
    this.employeeName,
    this.isDelete = false,
    this.isGetFromMat = false,
    this.overwriteOnId,
  });

  factory GiveMoneyToMatModel.fromJson(Map<String, dynamic> json) => GiveMoneyToMatModel(
        activeLogModelList: List<ActiveLogModel>.from(json["active_log_list"].map((x) => ActiveLogModel.fromJson(x))),
        remark: TextEditingController(text: json["remark"]),
        isDelete: (json["is_delete"] == null) ? false : json["is_delete"],
        overwriteOnId: (json["overwrite_on_id"] == null) ? null : json["overwrite_on_id"],
        id: json["_id"],
        date: DateTime.parse(json["date"]),
        moneyType: json["money_type"],
        isGetFromMat: (double.parse(json["value"].toString()) > 0), //-100 > 0 => false
        value: TextEditingController(
            text: formatAndLimitNumberTextGlobal(valueStr: (double.parse(json["value"].toString())).abs().toString(), isRound: true, isAllowZeroAtLast: false)),
        employeeId: json["employee_id"],
        employeeName: json["employee_name"],
      );

  Map<String, dynamic> toJson() => {
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),
        "remark": remark.text,
        "_id": id,
        "date": date!.toIso8601String(),
        "money_type": moneyType,
        "value": (-1 * textEditingControllerToDouble(controller: value)!),
        "employee_id": employeeId,
        "employee_name": employeeName,
      };
  Map<String, dynamic> constValueToJson() => {
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),

        "remark": remark.text,
        // "date": date.toIso8601String(),
        "money_type": moneyType,
        "value": (-1 * textEditingControllerToDouble(controller: value)!),
        "employee_id": employeeId,
        "employee_name": employeeName,
      };
}
