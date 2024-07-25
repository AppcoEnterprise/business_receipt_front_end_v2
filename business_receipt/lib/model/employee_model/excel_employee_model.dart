// To parse this JSON data, do
//
//     final excelEmployeeModel = excelEmployeeModelFromJson(jsonString);

import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/money_type_and_value_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<ExcelEmployeeModel> excelEmployeeModelListFromJson({required dynamic str}) =>
    List<ExcelEmployeeModel>.from(json.decode(json.encode(str)).map((x) => ExcelEmployeeModel.fromJson(x)));
ExcelEmployeeModel excelEmployeeModelFromJson({required dynamic str}) => ExcelEmployeeModel.fromJson(json.decode(json.encode(str)));

String excelEmployeeModelListToJson(List<ExcelEmployeeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String excelEmployeeModelConstListToJson(List<ExcelEmployeeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toConstJson())));

class ExcelEmployeeModel {
  String? id;
  String? excelConfigId;
  TextEditingController remark;
  String excelName;
  int countData;
  List<MoneyTypeAndValueModel> profitList;
  List<ExcelDataList> dataList;
  List<ActiveLogModel> activeLogModelList;

  ExcelEmployeeModel({
    this.id,
    required this.activeLogModelList,
    required this.excelConfigId,
    required this.remark,
    required this.excelName,
    required this.dataList,
    required this.countData,
    required this.profitList,
  });

  factory ExcelEmployeeModel.fromJson(Map<String, dynamic> jsonQuery) {
    return ExcelEmployeeModel(
        activeLogModelList: (jsonQuery["active_log_list"] == null)? [] : List<ActiveLogModel>.from(jsonQuery["active_log_list"].map((x) => ActiveLogModel.fromJson(x))),
        id: jsonQuery["_id"],
        excelConfigId: jsonQuery["excel_config_id"],
        remark: TextEditingController(text: jsonQuery["remark"]),
        excelName: jsonQuery["excel_name"],
        dataList: List<ExcelDataList>.from(jsonQuery["data_list"].map((x) => ExcelDataList.fromJson(x))),
        profitList: List<MoneyTypeAndValueModel>.from(jsonQuery["profit_list"].map((x) => MoneyTypeAndValueModel.fromJson(x))),
        countData: jsonQuery["count_data"],
      );}

  Map<String, dynamic> toJson() => {
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),
        "excel_config_id": excelConfigId,
        "remark": remark.text,
        "excel_name": excelName,
        "count_data": countData,
        "data_list": List<dynamic>.from(dataList.map((x) => x.toJson())),
        "profit_list": List<dynamic>.from(profitList.map((x) => x.toJson())),
      };
  Map<String, dynamic> toConstJson() => {
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),
        "excel_config_id": excelConfigId,
        "remark": remark.text,
        "excel_name": excelName,
        "count_data": countData,
        "data_list": List<dynamic>.from(dataList.map((x) => x.toConstJson())),
        "profit_list": List<dynamic>.from(profitList.map((x) => x.toJson())),
      };
}

class ExcelDataList {
  String? id;
  double amount;
  String moneyType;
  double profit;
  DateTime date;
  String status;
  String txnID;
  String printTypeName;
  String name;
  bool isHover;

  List<ActiveLogModel> activeLogModelList;
  TextEditingController remark;

  ExcelDataList({
    this.id,
    required this.activeLogModelList,
    this.isHover = false,
    required this.amount,
    required this.moneyType,
    required this.profit,
    required this.date,
    required this.status,
    required this.txnID,
    required this.printTypeName,
    required this.name,
    required this.remark,
  });

  factory ExcelDataList.fromJson(Map<String, dynamic> json) => ExcelDataList(
        id: json["_id"],
        amount: json["amount"],
        moneyType: json["money_type"],
        profit: json["profit"],
        date: DateTime.parse(json["date"]),
        status: json["status"],
        txnID: json["txnID"],
        printTypeName: json["print_type_name"],
        name: json["name"],
        remark: TextEditingController(text: json["remark"]),
        activeLogModelList: List<ActiveLogModel>.from(json["active_log_list"].map((x) => ActiveLogModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "amount": amount,
        "money_type": moneyType,
        "profit": profit,
        "date": date.toIso8601String(),
        "status": status,
        "txnID": txnID,
        "print_type_name": printTypeName,
        "name": name,
      };

  Map<String, dynamic> toConstJson() => {
        "amount": amount,
        "money_type": moneyType,
        "profit": profit,
        "date": date.toIso8601String(),
        "status": status,
        "txnID": txnID,
        "print_type_name": printTypeName,
        "name": name,
      };
}
