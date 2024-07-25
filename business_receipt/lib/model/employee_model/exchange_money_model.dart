import 'dart:convert';

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:flutter/material.dart';

List<ExchangeMoneyModel> exchangeMoneyModelListFromJson({required dynamic str}) =>
    List<ExchangeMoneyModel>.from(json.decode(json.encode(str)).map((x) => ExchangeMoneyModel.fromJson(x)));
List<dynamic> exchangeMoneyModelListToJson({required List<ExchangeMoneyModel> data}) => List<dynamic>.from(data.map((x) => x.toJson()));
List<dynamic> exchangeMoneyModelListNoConstToJson({required List<ExchangeMoneyModel> data}) => List<dynamic>.from(data.map((x) => x.noConstToJson()));

ExchangeMoneyModel exchangeMoneyModelFromJson({required dynamic str}) => ExchangeMoneyModel.fromJson(json.decode(json.encode(str)));

class ExchangeMoneyModel {
  ExchangeMoneyModel({
    this.date,
    this.dateOld,
    required this.exchangeList,
    this.isDelete = false,
    this.overwriteOnId,
    this.id,
    required this.remark,
    required this.activeLogModelList,
  });

  bool isDelete;
  String? overwriteOnId;
  TextEditingController remark;
  String? id;
  DateTime? date;
  DateTime? dateOld;
  // bool isCalculateCard;
  List<ExchangeListExchangeMoneyModel> exchangeList;
  List<ActiveLogModel> activeLogModelList;

  factory ExchangeMoneyModel.fromJson(Map<String, dynamic> json) => ExchangeMoneyModel(
        id: json["_id"],
        remark: TextEditingController(text: json["remark"]),
        overwriteOnId: (json["overwrite_on_id"] == null) ? null : json["overwrite_on_id"],
        isDelete: (json["is_delete"] == null) ? false : json["is_delete"],
        date: (json["date"] == null) ? null : DateTime.parse(json["date"]),
        dateOld: (json["date_old"] == null) ? null : DateTime.parse(json["date_old"]),
        exchangeList: List<ExchangeListExchangeMoneyModel>.from(json["exchange_list"].map((x) => ExchangeListExchangeMoneyModel.fromJson(x))),
        activeLogModelList: List<ActiveLogModel>.from(json["active_log_list"].map((x) => ActiveLogModel.fromJson(x))),  
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "is_delete": isDelete,
        "remark": remark.text,
        "overwrite_on_id": overwriteOnId,
        "date": (date == null) ? null : date!.toIso8601String(),
        "date_old": (dateOld == null) ? null : dateOld!.toIso8601String(),
        "exchange_list": List<dynamic>.from(exchangeList.map((x) => x.toJson())),
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),
      };

  Map<String, dynamic> noConstToJson() => {
        "remark": remark.text,
        // "date": date.toIso8601String(),
        "exchange_list": List<dynamic>.from(exchangeList.map((x) => x.noConstToJson())),
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),
      };
}

class ExchangeListExchangeMoneyModel {
  ExchangeListExchangeMoneyModel({
    required this.getMoney,
    required this.getMoneyFocusNode,
    required this.giveMoney,
    required this.giveMoneyFocusNode,
    this.isSelectedOtherRate = false,
    this.selectedRateIndex = 0,
    this.rate,
  });
  int selectedRateIndex; //for frontend
  bool isSelectedOtherRate; //for frontend
  TextEditingController getMoney;
  FocusNode getMoneyFocusNode; //for frontend
  TextEditingController giveMoney;
  FocusNode giveMoneyFocusNode; //for frontend
  bool? isChangeOnGetMoney;
  RateForCalculateModel? rate;

  factory ExchangeListExchangeMoneyModel.fromJson(Map<String, dynamic> json) => ExchangeListExchangeMoneyModel(
        getMoney: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["get_money"].toString(), isRound: true, isAllowZeroAtLast: false)),
        getMoneyFocusNode: FocusNode(),
        giveMoney: TextEditingController(
            text: formatAndLimitNumberTextGlobal(
                valueStr: (-1 * double.parse(json["give_money"].toString())).toString(), isRound: false, isAllowZeroAtLast: false)),
        giveMoneyFocusNode: FocusNode(),
        rate: RateForCalculateModel.fromJson(json["rate"]),
      );

  Map<String, dynamic> toJson() => {
        "get_money": textEditingControllerToDouble(controller: getMoney),
        "give_money": (-1 * textEditingControllerToDouble(controller: giveMoney)!), //never be null, already check condition
        "rate": rate!.toJson(),
      };
  Map<String, dynamic> noConstToJson() => {
        "get_money": textEditingControllerToDouble(controller: getMoney),
        "give_money": (-1 * textEditingControllerToDouble(controller: giveMoney)!), //never be null, already check condition
        // "profit": profit,
        "rate": (rate == null) ? null : rate!.toJson(),
      };
}

class AdditionMoneyModel {
  AdditionMoneyModel({required this.addMoney, required this.moneyType});

  TextEditingController addMoney;
  String moneyType;
}
