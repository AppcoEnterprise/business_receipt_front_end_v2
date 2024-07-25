// To parse this JSON data, do
//
//     final excelEmployeeModel = excelEmployeeModelFromJson(jsonString);

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<ExcelAdminModel> excelAdminModelFromJson({required dynamic str}) =>
    List<ExcelAdminModel>.from(json.decode(json.encode(str)).map((x) => ExcelAdminModel.fromJson(x)));

class ExcelAdminModel {
  String axis;
  TextEditingController dateFormat;
  TextEditingController excelName;
  TableColumnAndRow date;
  TableColumnAndRow txnID;
  TableColumnAndRow printTypeName;
  TableColumnAndRow moneyType;
  TableColumnAndRow amount;
  TableColumnAndRow dROrCR;
  TableColumnAndRow profit;
  List<TableColumnAndRow> nameList;
  TableColumnAndRow status;
  TextEditingController remark;
  String? id; //const value
  DateTime? deletedDate;

  ExcelAdminModel({
    this.id,
    required this.axis,
    required this.dateFormat,
    required this.excelName,
    required this.date,
    required this.txnID,
    required this.printTypeName,
    required this.moneyType,
    required this.amount,
    required this.dROrCR,
    required this.profit,
    required this.nameList,
    required this.status,
    required this.remark,
    this.deletedDate,
  });

  factory ExcelAdminModel.fromJson(Map<String, dynamic> json) => ExcelAdminModel(
        axis: json["axis"],
        dateFormat: TextEditingController(text: json["date_format"]),
        excelName: TextEditingController(text: json["excel_name"]),
        date: TableColumnAndRow.fromJson(json["date"]),
        txnID: TableColumnAndRow.fromJson(json["txnID"]),
        printTypeName: TableColumnAndRow.fromJson(json["print_type_name"]),
        moneyType: TableColumnAndRow.fromJson(json["money_type"]),
        amount: TableColumnAndRow.fromJson(json["amount"]),
        profit: TableColumnAndRow.fromJson(json["profit"]),
        nameList: List<TableColumnAndRow>.from(json["name_list"].map((x) => TableColumnAndRow.fromJson(x))),
        status: TableColumnAndRow.fromJson(json["status"]),
        remark: TextEditingController(text: json["remark"]),
        id: json["_id"],
        deletedDate: (json["deleted_date"] == null) ? null : DateTime.parse(json["deleted_date"]),
        dROrCR: TableColumnAndRow.fromJson(json["dr_or_cr"]),
      );

  Map<String, dynamic> toJson() => {
        "axis": axis,
        "date_format": dateFormat.text,
        "excel_name": excelName.text,
        "date": date.toJson(isShowDROrCR: false),
        "txnID": txnID.toJson(isShowDROrCR: false),
        "print_type_name": printTypeName.toJson(isShowDROrCR: false),
        "money_type": moneyType.toJson(isShowDROrCR: false),
        "amount": amount.toJson(isShowDROrCR: false),
        "profit": profit.toJson(isShowDROrCR: false),
        "name_list": List<dynamic>.from(nameList.map((x) => x.toJson(isShowDROrCR: false))),
        "status": status.toJson(isShowDROrCR: false),
        "remark": remark.text,
        "dr_or_cr": dROrCR.toJson(isShowDROrCR: true),
        "_id": id,
        "deleted_date": (deletedDate == null) ? null : deletedDate!.toIso8601String(),
      };
  Map<String, dynamic> constValueToJson() => {
        "axis": axis,
        "date_format": dateFormat.text,
        "excel_name": excelName.text,
        "date": date.toJson(isShowDROrCR: false),
        "txnID": txnID.toJson(isShowDROrCR: false),
        "print_type_name": printTypeName.toJson(isShowDROrCR: false),
        "money_type": moneyType.toJson(isShowDROrCR: false),
        "amount": amount.toJson(isShowDROrCR: false),
        "profit": profit.toJson(isShowDROrCR: false),
        "name_list": List<dynamic>.from(nameList.map((x) => x.toJson(isShowDROrCR: false))),
        "status": status.toJson(isShowDROrCR: false),
        "remark": remark.text,
        "dr_or_cr": dROrCR.toJson(isShowDROrCR: true),
        // "_id": id,
        "deleted_date": (deletedDate == null) ? null : deletedDate!.toIso8601String(),
      };
}

class TableColumnAndRow {
  TextEditingController column;
  TextEditingController row;
  List<TextEditingController> dRKeywordList;
  List<TextEditingController> cRKeywordList;

  TableColumnAndRow({required this.column, required this.row, required this.dRKeywordList, required this.cRKeywordList});

  factory TableColumnAndRow.fromJson(Map<String, dynamic> json) => TableColumnAndRow(
        column: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["column"].toString(), isRound: false)),
        row: TextEditingController(text: json["row"]),
        dRKeywordList:
            (json["dr_keyword_list"] == null) ? [] : List<TextEditingController>.from(json["dr_keyword_list"].map((x) => TextEditingController(text: x))),
        cRKeywordList:
            (json["cr_keyword_list"] == null) ? [] : List<TextEditingController>.from(json["cr_keyword_list"].map((x) => TextEditingController(text: x))),
      );

  Map<String, dynamic> toJson({required bool isShowDROrCR}) {
    return isShowDROrCR
        ? {
            "column": textEditingControllerToDouble(controller: column),
            "row": row.text,
            "dr_keyword_list": List<dynamic>.from(dRKeywordList.map((x) => x.text)),
            "cr_keyword_list": List<dynamic>.from(cRKeywordList.map((x) => x.text)),
          }
        : {
            "column": textEditingControllerToDouble(controller: column),
            "row": row.text,
          };
  }
}

ExcelAdminModel cloneExcelAdmin({required int excelIndex}) {
  TableColumnAndRow getNewColumnAndRow({required TableColumnAndRow tableColumnAndRow}) {
    return TableColumnAndRow(
      column: TextEditingController(text: tableColumnAndRow.column.text),
      row: TextEditingController(text: tableColumnAndRow.row.text),
      dRKeywordList: tableColumnAndRow.dRKeywordList.map((e) => TextEditingController(text: e.text)).toList(),
      cRKeywordList: tableColumnAndRow.cRKeywordList.map((e) => TextEditingController(text: e.text)).toList(),
    );
  }

  final String? id = excelAdminModelListGlobal[excelIndex].id;
  final DateTime? deletedDate = excelAdminModelListGlobal[excelIndex].deletedDate;
  final String axis = excelAdminModelListGlobal[excelIndex].axis;
  final TableColumnAndRow amount = getNewColumnAndRow(tableColumnAndRow: excelAdminModelListGlobal[excelIndex].amount);
  final TextEditingController excelName = TextEditingController(text: excelAdminModelListGlobal[excelIndex].excelName.text);
  final TextEditingController dateFormat = TextEditingController(text: excelAdminModelListGlobal[excelIndex].dateFormat.text);
  final TextEditingController remark = TextEditingController(text: excelAdminModelListGlobal[excelIndex].remark.text);
  final TableColumnAndRow status = getNewColumnAndRow(tableColumnAndRow: excelAdminModelListGlobal[excelIndex].status);
  final TableColumnAndRow txnId = getNewColumnAndRow(tableColumnAndRow: excelAdminModelListGlobal[excelIndex].txnID);
  final TableColumnAndRow printTypeName = getNewColumnAndRow(tableColumnAndRow: excelAdminModelListGlobal[excelIndex].printTypeName);
  final TableColumnAndRow isDR = getNewColumnAndRow(tableColumnAndRow: excelAdminModelListGlobal[excelIndex].dROrCR);

  final TableColumnAndRow moneyType = getNewColumnAndRow(tableColumnAndRow: excelAdminModelListGlobal[excelIndex].moneyType);
  final TableColumnAndRow profit = getNewColumnAndRow(tableColumnAndRow: excelAdminModelListGlobal[excelIndex].profit);
  final TableColumnAndRow date = getNewColumnAndRow(tableColumnAndRow: excelAdminModelListGlobal[excelIndex].date);
  List<TableColumnAndRow> nameList = [];
  for (int nameIndex = 0; nameIndex < excelAdminModelListGlobal[excelIndex].nameList.length; nameIndex++) {
    final TextEditingController column = TextEditingController(text: excelAdminModelListGlobal[excelIndex].nameList[nameIndex].column.text);
    final TextEditingController row = TextEditingController(text: excelAdminModelListGlobal[excelIndex].nameList[nameIndex].row.text);
    final List<TextEditingController> dRKeywordList =
        excelAdminModelListGlobal[excelIndex].nameList[nameIndex].dRKeywordList.map((e) => TextEditingController(text: e.text)).toList();
    final List<TextEditingController> cRKeywordList =
        excelAdminModelListGlobal[excelIndex].nameList[nameIndex].cRKeywordList.map((e) => TextEditingController(text: e.text)).toList();
    nameList.add(TableColumnAndRow(column: column, row: row, dRKeywordList: dRKeywordList, cRKeywordList: cRKeywordList));
  }
  return ExcelAdminModel(
    id: id,
    deletedDate: deletedDate,
    axis: axis,
    amount: amount,
    excelName: excelName,
    dateFormat: dateFormat,
    remark: remark,
    status: status,
    txnID: txnId,
    printTypeName: printTypeName,
    moneyType: moneyType,
    nameList: nameList,
    profit: profit,
    date: date,
    dROrCR: isDR,
  );
}
