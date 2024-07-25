// To parse this JSON data, do
//
//     final transfer = transferFromJson(jsonString);

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<TransferModel> transferFromJson({required dynamic str}) => List<TransferModel>.from(json.decode(json.encode(str)).map((x) => TransferModel.fromJson(x)));

String transferToJson(List<TransferModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransferModel {
  String? id; //const value
  DateTime? deletedDate;
  String? customerId; //const value
  // TextEditingController partnerName;
  List<MoneyTypeList> moneyTypeList;

  TransferModel({
    this.id,
    this.deletedDate,
    this.customerId,
    required this.moneyTypeList,
  });

  factory TransferModel.fromJson(Map<String, dynamic> json) => TransferModel(
        id: json["_id"],
        deletedDate: (json["deleted_date"] == null) ? null : DateTime.parse(json["deleted_date"]),
        customerId: json["customer_id"],
        moneyTypeList: List<MoneyTypeList>.from(json["money_type_list"].map((x) => MoneyTypeList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "deleted_date": (deletedDate == null) ? null : deletedDate!.toIso8601String(),
        "customer_id": customerId,
        "money_type_list": List<dynamic>.from(moneyTypeList.map((x) => x.toJson())),
      };
  Map<String, dynamic> constValueToJson() => {
        // "_id": id,
        "deleted_date": (deletedDate == null) ? null : deletedDate!.toIso8601String(),
        "customer_id": customerId,
        "money_type_list": List<dynamic>.from(moneyTypeList.map((x) => x.toJson())),
      };
}

class MoneyTypeList {
  String? moneyType;
  TextEditingController shareFeePercentage;
  List<TextEditingController> limitValue;
  List<MoneyList> moneyList;
  bool isTransferSelectedPrint;
  bool isReceiverSelectedPrint;

  MoneyTypeList({
    this.isTransferSelectedPrint = false,
    this.isReceiverSelectedPrint = false,
    required this.moneyType,
    required this.shareFeePercentage,
    required this.limitValue,
    required this.moneyList,
  });

  factory MoneyTypeList.fromJson(Map<String, dynamic> json) => MoneyTypeList(
        moneyType: json["money_type"],
        shareFeePercentage: TextEditingController(
            text: formatAndLimitNumberTextGlobal(valueStr: json["share_fee_percentage"].toString(), isRound: false, isAllowZeroAtLast: false)),
        limitValue: List<TextEditingController>.from(json["limit_value"]
            .map((x) => TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: x.toString(), isRound: true, isAllowZeroAtLast: false)))),
        moneyList: List<MoneyList>.from(json["money_list"].map((x) => MoneyList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "money_type": moneyType,
        "share_fee_percentage": textEditingControllerToDouble(controller: shareFeePercentage),
        "limit_value": List<dynamic>.from(limitValue.map((x) => textEditingControllerToDouble(controller: x))),
        // List<dynamic>.from(limitValue.map((x) => x)),
        "money_list": List<dynamic>.from(moneyList.map((x) => x.toJson())),
      };
}

class MoneyList {
  TextEditingController fee;
  TextEditingController startValue;
  TextEditingController endValue;
  List<TextEditingController> limitFee;
  bool isTransfer; //const value

  bool isSelectedPrint;
  MoneyList({
    this.isSelectedPrint = true,
    required this.fee,
    required this.startValue,
    required this.endValue,
    required this.limitFee,
    this.isTransfer = true,
  });

  factory MoneyList.fromJson(Map<String, dynamic> json) => MoneyList(
        fee: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["fee"].toString(), isRound: false, isAllowZeroAtLast: false)),
        // json["fee"],
        startValue:
            TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["start_value"].toString(), isRound: false, isAllowZeroAtLast: false)),
        // json["start_value"],
        endValue: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["end_value"].toString(), isRound: false, isAllowZeroAtLast: false)),
        // json["end_value"],
        limitFee: List<TextEditingController>.from(json["limit_fee"]
            .map((x) => TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: x.toString(), isRound: true, isAllowZeroAtLast: false)))),
        // List<int>.from(json["limit_fee"].map((x) => x)),

        isTransfer: json["is_transfer"],
      );

  Map<String, dynamic> toJson() => {
        "fee": textEditingControllerToDouble(controller: fee),
        "start_value": textEditingControllerToDouble(controller: startValue),
        "end_value": textEditingControllerToDouble(controller: endValue),
        "limit_fee": List<dynamic>.from(limitFee.map((x) => textEditingControllerToDouble(controller: x))),
        "is_transfer": isTransfer,
        //  List<dynamic>.from(limitFee.map((x) => x)),
      };
}

TransferModel cloneTransferModel({required int transferIndex}) {
  final String? id = transferModelListGlobal[transferIndex].id;
  final String? customerId = transferModelListGlobal[transferIndex].customerId;
  final DateTime? deletedDate = transferModelListGlobal[transferIndex].deletedDate;
  List<MoneyTypeList> moneyTypeList = [];
  for (int moneyTypeIndex = 0; moneyTypeIndex < transferModelListGlobal[transferIndex].moneyTypeList.length; moneyTypeIndex++) {
    final TextEditingController shareFeePercentage =
        TextEditingController(text: transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].shareFeePercentage.text);
    final String? moneyType = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyType;
    List<TextEditingController> limitValue = [];
    for (int limitValueIndex = 0; limitValueIndex < transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].limitValue.length; limitValueIndex++) {
      limitValue.add(TextEditingController(text: transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].limitValue[limitValueIndex].text));
    }
    List<MoneyList> moneyList = [];
    for (int moneyListIndex = 0; moneyListIndex < transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList.length; moneyListIndex++) {
      final TextEditingController fee =
          TextEditingController(text: transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyListIndex].fee.text);
      final TextEditingController startValue =
          TextEditingController(text: transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyListIndex].startValue.text);
      final TextEditingController endValue =
          TextEditingController(text: transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyListIndex].endValue.text);

      final bool isTransfer = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyListIndex].isTransfer;
      List<TextEditingController> limitFee = [];
      for (int limitFeeIndex = 0;
          limitFeeIndex < transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyListIndex].limitFee.length;
          limitFeeIndex++) {
        limitFee.add(TextEditingController(
            text: transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyListIndex].limitFee[limitFeeIndex].text));
      }
      moneyList.add(MoneyList(fee: fee, startValue: startValue, endValue: endValue, limitFee: limitFee, isTransfer: isTransfer));
    }
    moneyTypeList.add(MoneyTypeList(moneyType: moneyType, limitValue: limitValue, moneyList: moneyList, shareFeePercentage: shareFeePercentage));
  }
  return TransferModel(deletedDate: deletedDate, id: id, customerId: customerId, moneyTypeList: moneyTypeList);
}
