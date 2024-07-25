// To parse this JSON data, do
//
//     final customerModel = customerModelFromJson(jsonString);

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/money_type_and_value_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<CustomerModel> customerModelListFromJson({required dynamic str}) =>
    List<CustomerModel>.from(json.decode(json.encode(str)).map((x) => CustomerModel.fromJson(x)));

CustomerModel customerModelFromJson({required dynamic str}) => CustomerModel.fromJson(json.decode(json.encode(str)));

String customerModelToJson({required List<CustomerModel> data, required bool isLend}) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson(isLend: isLend))));

class CustomerModel {
  DateTime? date;
  String? id; //const value
  int invoiceCount; //const value
  TextEditingController name;
  List<InformationCustomerModel> informationList;
  TextEditingController remark;
  List<MoneyCustomerModel> moneyList;
  List<MoneyTypeAndValueForInputModel> totalList; //no detail
  List<CustomerModel> partnerList;
  DateTime? deletedDate;

  CustomerModel({
    this.id,
    this.date,
    required this.name,
    required this.informationList,
    required this.remark,
    required this.moneyList,
    required this.totalList,
    required this.partnerList,
    required this.invoiceCount,
    this.deletedDate,
    
    
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      date: (json["date"] == null) ? null : DateTime.parse(json["date"]),
      name: TextEditingController(text: json["name"]),
      informationList: List<InformationCustomerModel>.from(json["information_list"].map((x) => InformationCustomerModel.fromJson(x))),
      partnerList: (json["partner_list"] == null) ? [] : List<CustomerModel>.from(json["partner_list"].map((x) => CustomerModel.fromJson(x))),
      remark: TextEditingController(text: json["remark"]),
      moneyList: (json["money_list"] == null) ? [] : List<MoneyCustomerModel>.from(json["money_list"].map((x) => MoneyCustomerModel.fromJson(x))),
      totalList: (json["total_list"] == null)
          ? []
          : List<MoneyTypeAndValueForInputModel>.from(json["total_list"].map((x) => MoneyTypeAndValueForInputModel.fromJson(x))),
      id: json["_id"],
      deletedDate: (json["deleted_date"] == null) ? null : DateTime.parse(json["deleted_date"]),
      invoiceCount: json["invoice_count"]?? 0,
    );
  }

  Map<String, dynamic> toJson({required bool isLend}) => {
        "date": (date == null) ? null : date!.toIso8601String(),
        "name": name.text,
        "invoice_count": invoiceCount,
        "information_list": List<dynamic>.from(informationList.map((x) => x.toJson())),
        "remark": remark.text,
        "money_list": List<dynamic>.from(moneyList.map((x) => x.toJson(isLend: isLend))),
        "total_list": List<dynamic>.from(totalList.map((x) => x.toJson())),
        "partner_list": List<dynamic>.from(partnerList.map((x) => x.partnerValueToJson())),
        "_id": id,
        "deleted_date": (deletedDate == null) ? null : deletedDate!.toIso8601String(),
      };

  Map<String, dynamic> constValueToJson({required bool isLend}) => {
        "name": name.text,
        "invoice_count": invoiceCount,
        "information_list": List<dynamic>.from(informationList.map((x) => x.toJson())),
        "remark": remark.text,
        "money_list": List<dynamic>.from(moneyList.map((x) => x.constValueToJson(isLend: isLend))),
        "total_list": List<dynamic>.from(totalList.map((x) => x.toJson())),
        "partner_list": List<dynamic>.from(partnerList.map((x) => x.partnerValueToJson())),
        "deleted_date": (deletedDate == null) ? null : deletedDate!.toIso8601String(),
      };
  Map<String, dynamic> partnerValueToJson() => {
        "name": name.text,
        "information_list": List<dynamic>.from(informationList.map((x) => x.toJson())),
        "remark": remark.text,
      };
}

class InformationCustomerModel {
  TextEditingController title;
  TextEditingController subtitle;
  bool isSelectedTitle;
  bool isSelectedSubtitle;

  InformationCustomerModel({
    required this.title,
    required this.subtitle,
    this.isSelectedTitle = false,
    this.isSelectedSubtitle = false,
  });

  factory InformationCustomerModel.fromJson(Map<String, dynamic> json) => InformationCustomerModel(
        title: TextEditingController(text: json["title"]),
        subtitle: TextEditingController(text: json["subtitle"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title.text,
        "subtitle": subtitle.text,
      };
}

class MoneyCustomerModel {
  TextEditingController remark;
  bool isDelete;
  bool isHover;
  List<ActiveLogModel> activeLogModelList;
  String? overwriteOnId;

  String? id; //const value
  String? employeeId; //const value
  String? employeeName; //const value

  String? customerId; //const value
  String? customerName; //const value

  TextEditingController value;
  String? moneyType;
  // TextEditingController detail;
  DateTime? date; //const value

  MoneyCustomerModel({
    required this.activeLogModelList,
    required this.remark,
    this.id,
    this.employeeId,
    this.employeeName,
    this.customerId,
    this.customerName,
    required this.value,
    this.moneyType,
    // required this.detail,
    this.date,
    this.isDelete = false,
    this.isHover = false,
    this.overwriteOnId,
  });

  factory MoneyCustomerModel.fromJson(Map<String, dynamic> json) => MoneyCustomerModel(
        activeLogModelList: List<ActiveLogModel>.from(json["active_log_list"].map((x) => ActiveLogModel.fromJson(x))),
        remark: TextEditingController(text: json["remark"]),

        overwriteOnId: (json["overwrite_on_id"] == null) ? null : json["overwrite_on_id"],
        isDelete: (json["is_delete"] == null) ? false : json["is_delete"],

        id: json["_id"],
        date: (json["date"] == null) ? null : DateTime.parse(json["date"]),
        value: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["value"].toString(), isRound: false, isAllowZeroAtLast: false)),
        moneyType: json["money_type"],
        employeeId: json["employee_id"],
        employeeName: json["employee_name"],

        customerId: json["customer_id"],
        customerName: json["customer_name"],
        // detail: TextEditingController(text: json["detail"]),
      );

  Map<String, dynamic> toJson({required bool isLend}) => {
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),
        "is_delete": isDelete,
        "overwrite_on_id": overwriteOnId,
        "remark": remark.text,

        "_id": id,
        "date": (date == null) ? null : date!.toIso8601String(),
        "value": (isLend ? 1 : -1) * textEditingControllerToDouble(controller: value)!,
        "money_type": moneyType,
        "employee_id": employeeId,
        "employee_name": employeeName,

        "customer_id": employeeId,
        "customer_name": employeeName,
        // "detail": detail.text,
      };
  Map<String, dynamic> constValueToJson({required bool isLend}) => {
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),
        // "_id": id,
        "value": (isLend ? 1 : -1) * textEditingControllerToDouble(controller: value)!,
        "money_type": moneyType,
        "employee_id": employeeId,
        "employee_name": employeeName,

        "customer_id": employeeId,
        "customer_name": employeeName,
        "remark": remark.text,
      };
}

List<MoneyCustomerModelMoneyType> moneyCustomerModelMoneyTypeFromJson({required dynamic str}) =>
    List<MoneyCustomerModelMoneyType>.from(json.decode(json.encode(str)).map((x) => MoneyCustomerModelMoneyType.fromJson(x)));

class MoneyCustomerModelMoneyType {
  String moneyType;
  double totalForADay;
  List<MoneyCustomerModel> moneyList;
  MoneyCustomerModelMoneyType({
    required this.moneyType,
    required this.moneyList,
    required this.totalForADay,
  });
  factory MoneyCustomerModelMoneyType.fromJson(Map<String, dynamic> json) => MoneyCustomerModelMoneyType(
        moneyList: List<MoneyCustomerModel>.from(json["money_list"].map((x) => MoneyCustomerModel.fromJson(x))),
        moneyType: json["money_type"],
        totalForADay: json["total_for_a_day"],
      );
}

CustomerModel cloneCustomer({required int customerIndex, required List<CustomerModel> customerModelList}) {
  final String? id = customerModelList[customerIndex].id;
  final TextEditingController name = TextEditingController(text: customerModelList[customerIndex].name.text);
  final TextEditingController remark = TextEditingController(text: customerModelList[customerIndex].remark.text);
  final int invoiceCount = customerModelList[customerIndex].invoiceCount;
  final DateTime? deletedDate = customerModelList[customerIndex].deletedDate;
  // List<MoneyCustomerModel> moneyList = [];
  // for (int moneyIndex = 0; moneyIndex < customerModelListGlobal[customerIndex].moneyList.length; moneyIndex++) {
  //   final TextEditingController value = TextEditingController(text: customerModelListGlobal[customerIndex].moneyList[moneyIndex].value.text);
  //   final String? moneyType = customerModelListGlobal[customerIndex].moneyList[moneyIndex].moneyType;
  //   final TextEditingController detail = TextEditingController(text: customerModelListGlobal[customerIndex].moneyList[moneyIndex].detail.text);
  //   moneyList.add(MoneyCustomerModel(value: value, moneyType: moneyType, detail: detail));
  // }

  List<InformationCustomerModel> informationList = [];
  for (int informationIndex = 0; informationIndex < customerModelList[customerIndex].informationList.length; informationIndex++) {
    final TextEditingController title = TextEditingController(text: customerModelList[customerIndex].informationList[informationIndex].title.text);
    final TextEditingController subtitle = TextEditingController(text: customerModelList[customerIndex].informationList[informationIndex].subtitle.text);
    informationList.add(InformationCustomerModel(title: title, subtitle: subtitle));
  }

  List<CustomerModel> partnerList = [];
  for (int partnerIndex = 0; partnerIndex < customerModelList[customerIndex].partnerList.length; partnerIndex++) {
    final TextEditingController name = TextEditingController(text: customerModelList[customerIndex].partnerList[partnerIndex].name.text);
    final String? id = customerModelList[customerIndex].partnerList[partnerIndex].id;

    final TextEditingController remark = TextEditingController(text: customerModelList[customerIndex].remark.text);
    final int invoiceCount = customerModelList[customerIndex].invoiceCount;
    List<InformationCustomerModel> informationList = [];
    for (int informationIndex = 0; informationIndex < customerModelList[customerIndex].partnerList[partnerIndex].informationList.length; informationIndex++) {
      final TextEditingController title =
          TextEditingController(text: customerModelList[customerIndex].partnerList[partnerIndex].informationList[informationIndex].title.text);
      final TextEditingController subtitle =
          TextEditingController(text: customerModelList[customerIndex].partnerList[partnerIndex].informationList[informationIndex].subtitle.text);
      informationList.add(InformationCustomerModel(title: title, subtitle: subtitle));
    }

    partnerList.add(CustomerModel(
      name: name,
      id: id,
      informationList: informationList,
      remark: remark,
      moneyList: [],
      totalList: [],
      partnerList: [],
      invoiceCount: invoiceCount,
    ));
  }

  // List<MoneyTypeAndValueForInputModel> totalList = [];
  // for (int totalIndex = 0; totalIndex < customerModelListGlobal[customerIndex].totalList.length; totalIndex++) {
  //   final TextEditingController value = TextEditingController(text: customerModelListGlobal[customerIndex].totalList[totalIndex].amount.text);
  //   final String moneyType = customerModelListGlobal[customerIndex].totalList[totalIndex].moneyType;
  //   totalList.add(MoneyTypeAndValueForInputModel(amount: value, moneyType: moneyType));
  // }

  return CustomerModel(
    id: id,
    name: name,
    remark: remark,
    moneyList: [],
    informationList: informationList,
    totalList: [],
    deletedDate: deletedDate,
    partnerList: partnerList,
    invoiceCount: invoiceCount,
  );
}
