// To parse this JSON data, do
//
//     final transferOrder = transferOrderFromJson(jsonString);

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<TransferOrder> transferOrderFromJson({required dynamic str}) =>
    List<TransferOrder>.from(json.decode(json.encode(str)).map((x) => TransferOrder.fromJson(x)));

TransferOrder transferMoneyModelFromJson({required dynamic str}) => TransferOrder.fromJson(json.decode(json.encode(str)));

String transferOrderToJson(List<TransferOrder> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransferOrder {
  TextEditingController remark;
  String? id;
  bool isDelete;
  String? overwriteOnId;
  DateTime? date;
  List<MoneyListTransfer> mergeMoneyList;
  List<MoneyListTransfer> moneyList;
  PartnerAndSenderAndReceiver partner;
  PartnerAndSenderAndReceiver? sender;
  PartnerAndSenderAndReceiver receiver;
  DateTime? dateOld;
  bool isTransfer;
  bool isUseBank;
  bool isOtherBank;
  List<ActiveLogModel> activeLogModelList;

  TransferOrder({
    required this.activeLogModelList,
    required this.mergeMoneyList,
    required this.remark,
    this.id,
    this.isDelete = false,
    this.overwriteOnId,
    this.date,
    this.dateOld,
    required this.moneyList,
    required this.partner,
    required this.sender,
    required this.receiver,
    required this.isTransfer,
    required this.isUseBank,
    required this.isOtherBank,
  });

  factory TransferOrder.fromJson(Map<String, dynamic> json) => TransferOrder(
        activeLogModelList: List<ActiveLogModel>.from(json["active_log_list"].map((x) => ActiveLogModel.fromJson(x))),
        remark: TextEditingController(text: json["remark"]),
        id: json["_id"],
        isDelete: (json["is_delete"] == null) ? false : json["is_delete"],
        overwriteOnId: (json["overwrite_on_id"] == null) ? null : json["overwrite_on_id"],
        date: (json["date"] == null) ? null : DateTime.parse(json["date"]),
        dateOld: (json["date_old"] == null) ? null : DateTime.parse(json["date_old"]),
        mergeMoneyList: List<MoneyListTransfer>.from(json["merge_money_list"].map((x) => MoneyListTransfer.fromJson(x))),
        moneyList: List<MoneyListTransfer>.from(json["money_list"].map((x) => MoneyListTransfer.fromJson(x))),
        partner: PartnerAndSenderAndReceiver.fromJson(json["partner"]),
        sender: (json["sender"] == null) ? null : PartnerAndSenderAndReceiver.fromJson(json["sender"]),
        receiver: PartnerAndSenderAndReceiver.fromJson(json["receiver"]),
        isTransfer: json["is_transfer"],
        isUseBank: json["is_use_bank"],
        isOtherBank: json["is_other_bank"],
      );

  Map<String, dynamic> toJson() => {
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),
        "remark": remark.text,
        "_id": id,
        "is_delete": isDelete,
        "overwrite_on_id": overwriteOnId,
        "date": (date == null) ? null : date!.toIso8601String(),
        "money_list": List<dynamic>.from(moneyList.map((x) => x.toJson(isAddDate: true))),
        "merge_money_list": List<dynamic>.from(mergeMoneyList.map((x) => x.toJson(isAddDate: false))),
        "partner": partner.toJson(),
        "sender": (sender == null) ? null : sender!.toJson(),
        "receiver": receiver.toJson(),
        "date_old": (dateOld == null) ? null : dateOld!.toIso8601String(),
        "is_transfer": isTransfer,
        "is_use_bank": isUseBank,
        "is_other_bank": isOtherBank,
      };

  Map<String, dynamic> noConstToJson() => {
        "active_log_list": List<dynamic>.from(activeLogModelList.map((x) => x.toJson())),
        "remark": remark.text,
        "is_delete": isDelete,
        "money_list": List<dynamic>.from(moneyList.map((x) => x.toJson(isAddDate: true))),
        "merge_money_list": List<dynamic>.from(mergeMoneyList.map((x) => x.toJson(isAddDate: false))),
        "partner": partner.toJson(),
        "sender": (sender == null) ? null : sender!.toJson(),
        "receiver": receiver.toJson(),
        "is_transfer": isTransfer,
        "is_use_bank": isUseBank,
        "is_other_bank": isOtherBank,
      };
}

class PartnerAndSenderAndReceiver {
  String? nameAndInformationId;
  TextEditingController name;
  int? invoiceCount;
  List<InformationCustomerModel> informationList;
  int selectedIndex; //const value

  PartnerAndSenderAndReceiver({
    this.selectedIndex = -1,
    this.nameAndInformationId,
    this.invoiceCount,
    required this.name,
    required this.informationList,
  });

  factory PartnerAndSenderAndReceiver.fromJson(Map<String, dynamic> json) => PartnerAndSenderAndReceiver(
        nameAndInformationId: json["name_and_information_id"],
        name: TextEditingController(text: json["name"]),
        informationList: List<InformationCustomerModel>.from(json["information_list"].map((x) => InformationCustomerModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name_and_information_id": nameAndInformationId,
        "name": name.text,
        "information_list": List<dynamic>.from(informationList.map((x) => x.toJson())),
      };
}

class MoneyListTransfer {
  String? moneyType;
  TextEditingController value;
  double? fee;
  double profit;
  TextEditingController discountFee;
  DateTime? transferDate;
  bool isEditFee;

  MoneyListTransfer({
    this.moneyType,
    this.isEditFee = false,
    required this.value,
    this.fee,
    this.profit = 0,
    required this.discountFee,
    this.transferDate,
  });

  factory MoneyListTransfer.fromJson(Map<String, dynamic> json) => MoneyListTransfer(
        moneyType: json["money_type"],
        value: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["value"].toString(), isRound: true, isAllowZeroAtLast: false)),
        fee: json["fee"],
        profit: json["profit"],
        discountFee:
            TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["discount_fee"].toString(), isRound: true, isAllowZeroAtLast: false)),
        transferDate: (json["transfer_date"] == null) ? null : DateTime.parse(json["transfer_date"]),
      );

  Map<String, dynamic> toJson({required bool isAddDate}) => isAddDate
      ? {
          "money_type": moneyType,
          "value": textEditingControllerToDouble(controller: value),
          "fee": fee,
          "profit": profit,
          "discount_fee": textEditingControllerToDouble(controller: discountFee),
          "transfer_date": transferDate!.toIso8601String(),
        }
      : {
          "money_type": moneyType,
          "value": textEditingControllerToDouble(controller: value),
          "fee": fee,
          "profit": profit,
          "discount_fee": textEditingControllerToDouble(controller: discountFee),
        };
}

class MoneyTypeTransferOrder {
  String moneyType;
  double totalAmount;
  List<MoneyListTransfer> moneyList;
  MoneyTypeTransferOrder({
    required this.moneyType,
    required this.totalAmount,
    required this.moneyList,
  });
}

TransferOrder cloneTransferOrder({required TransferOrder transferOrder}) {
  List<MoneyListTransfer> mergeMoneyList = [];

  for (int mergeIndex = 0; mergeIndex < transferOrder.mergeMoneyList.length; mergeIndex++) {
    mergeMoneyList.add(MoneyListTransfer(
      moneyType: transferOrder.mergeMoneyList[mergeIndex].moneyType,
      value: TextEditingController(text: transferOrder.mergeMoneyList[mergeIndex].value.text),
      fee: transferOrder.mergeMoneyList[mergeIndex].fee,
      profit: transferOrder.mergeMoneyList[mergeIndex].profit,
      discountFee: TextEditingController(text: transferOrder.mergeMoneyList[mergeIndex].discountFee.text),
      transferDate: transferOrder.mergeMoneyList[mergeIndex].transferDate,
    ));
  }

  List<MoneyListTransfer> moneyList = [];
  for (int moneyIndex = 0; moneyIndex < transferOrder.moneyList.length; moneyIndex++) {
    moneyList.add(MoneyListTransfer(
      moneyType: transferOrder.moneyList[moneyIndex].moneyType,
      value: TextEditingController(text: transferOrder.moneyList[moneyIndex].value.text),
      fee: transferOrder.moneyList[moneyIndex].fee,
      profit: transferOrder.moneyList[moneyIndex].profit,
      discountFee: TextEditingController(text: transferOrder.moneyList[moneyIndex].discountFee.text),
      transferDate: transferOrder.moneyList[moneyIndex].transferDate,
    ));
  }
  PartnerAndSenderAndReceiver? getClonePartnerOrSenderOrReceiver({required PartnerAndSenderAndReceiver? partnerOrSenderOrReceiver}) {
    if (partnerOrSenderOrReceiver == null) {
      return null;
    }
    List<InformationCustomerModel> informationList = [];
    for (int informationIndex = 0; informationIndex < partnerOrSenderOrReceiver.informationList.length; informationIndex++) {
      informationList.add(InformationCustomerModel(
        title: TextEditingController(text: partnerOrSenderOrReceiver.informationList[informationIndex].title.text),
        subtitle: TextEditingController(text: partnerOrSenderOrReceiver.informationList[informationIndex].subtitle.text),
        isSelectedSubtitle: partnerOrSenderOrReceiver.informationList[informationIndex].isSelectedSubtitle,
        isSelectedTitle: partnerOrSenderOrReceiver.informationList[informationIndex].isSelectedTitle,
      ));
    }
    return PartnerAndSenderAndReceiver(
      nameAndInformationId: partnerOrSenderOrReceiver.nameAndInformationId,
      name: TextEditingController(text: partnerOrSenderOrReceiver.name.text),
      informationList: informationList,
    );
  }

  return TransferOrder(
    activeLogModelList: transferOrder.activeLogModelList,
    remark: TextEditingController(text: transferOrder.remark.text),
    id: transferOrder.id,
    isDelete: transferOrder.isDelete,
    overwriteOnId: transferOrder.overwriteOnId,
    date: transferOrder.date,
    dateOld: transferOrder.dateOld,
    mergeMoneyList: mergeMoneyList,
    moneyList: moneyList,
    partner: getClonePartnerOrSenderOrReceiver(partnerOrSenderOrReceiver: transferOrder.partner)!,
    sender: getClonePartnerOrSenderOrReceiver(partnerOrSenderOrReceiver: transferOrder.sender),
    receiver: getClonePartnerOrSenderOrReceiver(partnerOrSenderOrReceiver: transferOrder.receiver)!,
    isTransfer: transferOrder.isTransfer,
    isUseBank: transferOrder.isUseBank,
    isOtherBank: transferOrder.isOtherBank,
  );
}

List<MatchTransferList> matchTransferListFromJson({required dynamic str}) =>
    List<MatchTransferList>.from(json.decode(json.encode(str)).map((x) => MatchTransferList.fromJson(x)));

class MatchTransferList {
  List<TransferOrder> currentList;
  List<TransferOrder> pastList;

  MatchTransferList({
    required this.currentList,
    required this.pastList,
  });

  factory MatchTransferList.fromJson(Map<String, dynamic> json) => MatchTransferList(
        currentList: List<TransferOrder>.from(json["current_list"].map((x) => TransferOrder.fromJson(x))),
        pastList: List<TransferOrder>.from(json["past_list"].map((x) => TransferOrder.fromJson(x))),
      );
}
