// To parse this JSON data, do
//
//     final giveCardToMatModel = giveCardToMatModelFromJson(jsonString);

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/employee_model/card/sell_card_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<GiveCardToMatModel> giveCardToMatModelListFromJson({required dynamic str}) => List<GiveCardToMatModel>.from(json.decode(json.encode(str)).map((x) => GiveCardToMatModel.fromJson(x)));
GiveCardToMatModel giveCardToMatModelFromJson({required dynamic str}) => GiveCardToMatModel.fromJson(json.decode(json.encode(str)));

String giveCardToMatModelToJson(List<GiveCardToMatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GiveCardToMatModel {
  TextEditingController remark;
  String? id;
  DateTime? date;
  String? cardCompanyNameId;
  String? cardCompanyName;
  String? categoryId;
  double? category;
  TextEditingController qty;
  String? employeeId;
  String? employeeName;
  List<MainPriceQty> mainPriceQtyList;
  bool isDelete;
  String? overwriteOnId;
  bool isGetFromMat;
List<ActiveLogModel> activeLogModelList;
  // String? language;

  GiveCardToMatModel({
required this.activeLogModelList,
  required  this.remark,
    this.id,
    this.date,
    this.cardCompanyNameId,
    this.cardCompanyName,
    this.categoryId,
    this.category,
    required this.qty,
    this.employeeId,
    this.employeeName,
    required this.mainPriceQtyList,
    this.isDelete = false,
    this.overwriteOnId,
    this.isGetFromMat = false,
    //  this.language,
  });

  factory GiveCardToMatModel.fromJson(Map<String, dynamic> json) => GiveCardToMatModel(
activeLogModelList: List<ActiveLogModel>.from(json["active_log_list"].map((x) => ActiveLogModel.fromJson(x))),  

        isGetFromMat: (double.parse(json["qty"].toString()) > 0),//-100 > 0 => false
        isDelete: (json["is_delete"] == null) ? false : json["is_delete"],
        overwriteOnId: (json["overwrite_on_id"] == null) ? null : json["overwrite_on_id"],
        remark: TextEditingController(text: json["remark"]),
        id: json["_id"],
        date: DateTime.parse(json["date"]),
        cardCompanyNameId: json["card_company_name_id"],
        cardCompanyName: json["card_company_name"],
        categoryId: json["category_id"],
        category: json["category"],
        qty: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: (double.parse(json["qty"].toString())).abs().toString(), isRound: true, isAllowZeroAtLast: false)),
        employeeId: json["employee_id"],
        employeeName: json["employee_name"],
        mainPriceQtyList: List<MainPriceQty>.from(json["main_price_qty_list"].map((x) => MainPriceQty.fromJson(x))),
      // language: json["language"],
      );

  Map<String, dynamic> toJson() => {
"active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),

        "remark": remark.text,
        "_id": id,
        "date": date!.toIso8601String(),
        "card_company_name_id": cardCompanyNameId,
        "card_company_name": cardCompanyName,
        "category_id": categoryId,
        "category": category,
        "qty": (-1 * textEditingControllerToDouble(controller: qty)!),
        "employee_id": employeeId,
        "employee_name": employeeName,
        "main_price_qty_list": List<dynamic>.from(mainPriceQtyList.map((x) => x.toJson())),
        // "language": language,
      };

  Map<String, dynamic> constValueToJson() => {
"active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),

        "remark": remark.text,
        // "date": date!.toIso8601String(),
        "card_company_name_id": cardCompanyNameId,
        "card_company_name": cardCompanyName,
        "category_id": categoryId,
        "category": category,
        "qty": (-1 * textEditingControllerToDouble(controller: qty)!),
        "main_price_qty_list": List<dynamic>.from(mainPriceQtyList.map((x) => x.toJson())),
        "employee_name": employeeName,
        "employee_id": employeeId,
        // "language": language,
      };
}
