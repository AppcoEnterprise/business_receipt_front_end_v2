// // To parse this JSON data, do
// //
// //     final salaryModel = salaryModelFromJson(jsonString);

// import 'package:business_receipt/env/function/text/text_config_env.dart';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'dart:convert';

// class SalaryModel {
//   DateTime startDate;
//   DateTime endDate;
//   SalaryCalculation salaryCalculation;
//   TextEditingController remark;

//   SalaryModel({
//     required this.startDate,
//     required this.endDate,
//     required this.salaryCalculation,
//     required this.remark,
//   });

//   factory SalaryModel.fromJson(Map<String, dynamic> json) => SalaryModel(
//         startDate: DateTime.parse(json["start_date"]),
//         endDate: DateTime.parse(json["end_date"]),
//         salaryCalculation: SalaryCalculation.fromJson(json["salary_calculation"]),
//         remark: TextEditingController(text: json["remark"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "start_date": startDate.toIso8601String(),
//         "end_date": endDate.toIso8601String(),
//         "salary_calculation": salaryCalculation.toJson(),
//         "remark": remark.text,
//       };
// }

// class SalaryCalculation {
//   String? moneyType;
//   TextEditingController earningForSecond;

//   SalaryCalculation({
//     this.moneyType,
//     required this.earningForSecond,
//   });

//   factory SalaryCalculation.fromJson(Map<String, dynamic> json) => SalaryCalculation(
//         moneyType: json["money_type"],
//         // earningForSecond: json["earning_for_second"],
//         earningForSecond: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["earning_for_second"].toString(), isRound: true, isAllowZeroAtLast: false)),
//       );

//   Map<String, dynamic> toJson() => {
//         "money_type": moneyType,
//         // "earning_for_second": earningForSecond,
//         "earning_for_second": textEditingControllerToDouble(controller: earningForSecond)!,
//       };
// }

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/invoice_type.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:business_receipt/model/money_type_and_value_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<SalaryMergeByMonthModel> salaryMergeByMonthModelFromJson({required dynamic str}) =>
    List<SalaryMergeByMonthModel>.from(json.decode(json.encode(str)).map((x) => SalaryMergeByMonthModel.fromJson(x)));

List<dynamic> salaryMergeByMonthModelToJson(List<SalaryMergeByMonthModel> data) => List<dynamic>.from(data.map((x) => x.toJson()));

class SalaryMergeByMonthModel {
  List<SubSalaryModel> subSalaryList;
  DateTime date;
  List<MoneyTypeAndValueModel> totalList;
  int skipSalaryList;
  bool outOfDataQuerySalaryList;

  SalaryMergeByMonthModel({
    required this.subSalaryList,
    required this.date,
    required this.totalList,
    this.skipSalaryList = 0,
    this.outOfDataQuerySalaryList = false,
  });

  factory SalaryMergeByMonthModel.fromJson(Map<String, dynamic> json) => SalaryMergeByMonthModel(
        subSalaryList: List<SubSalaryModel>.from(json["salary_list"].map((x) => SubSalaryModel.fromJson(x))),
        date: DateTime.parse(json["date"]),
        totalList: List<MoneyTypeAndValueModel>.from(json["total_list"].map((x) => MoneyTypeAndValueModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    return {
      "salary_list": List<dynamic>.from(subSalaryList.map((x) => x.toJson())),
      "total_list": List<dynamic>.from(totalList.map((x) => x.toJson())),
      "date": date,
    };
  }
}

List<SubSalaryModel> salaryModelFromJson({required dynamic str}) =>
    List<SubSalaryModel>.from(json.decode(json.encode(str)).map((x) => SubSalaryModel.fromJson(x)));

List<dynamic> salaryModelToJson(List<SubSalaryModel> data) => List<dynamic>.from(data.map((x) => x.toJson()));

class SubSalaryModel {
  List<SalaryHistory> salaryHistoryList;
  List<AmountAndProfitModel> amountAndProfitModel;
  DisplayBusinessOptionProfileEmployeeModel displayBusinessOptionModel;
  String dateYMDStr;
  DateTime? date;

  SubSalaryModel({
    required this.salaryHistoryList,
    required this.dateYMDStr,
    required this.amountAndProfitModel,
    required this.displayBusinessOptionModel,
    this.date,
  });

  factory SubSalaryModel.fromJson(Map<String, dynamic> json) => SubSalaryModel(
        salaryHistoryList: List<SalaryHistory>.from(json["salary_list"].map((x) => SalaryHistory.fromJson(x))),
        dateYMDStr: json["date"],
        date: DateTime.parse(json["date_without_format"]),
        amountAndProfitModel: (json["amount_and_profit"] == null) ? [] : amountAndProfitModelFromJson(str: json["amount_and_profit"]),
        displayBusinessOptionModel: (json["profile_employee"] == null)
            ? DisplayBusinessOptionProfileEmployeeModel()
            : profileModelEmployeeFromJson(str: json["profile_employee"]).displayBusinessOptionModel,
      );

  Map<String, dynamic> toJson() {
    return {
      "salary_list": List<dynamic>.from(salaryHistoryList.map((x) => x.toJson())),
      "date": dateYMDStr,
    };
  }
}

class SalaryHistory {
  String id;
  DateTime startDate;
  SalaryCalculation salaryCalculation;
  DateTime? endDate;
  String remark;

  SalaryHistory({
    required this.id,
    required this.startDate,
    required this.salaryCalculation,
    required this.endDate,
    this.remark = "",
  });

  factory SalaryHistory.fromJson(Map<String, dynamic> json) => SalaryHistory(
        id: json["_id"],
        startDate: DateTime.parse(json["start_date"]),
        salaryCalculation: SalaryCalculation.fromJson(json["salary_calculation"]),
        endDate: (json["end_date"] == null) ? null : DateTime.parse(json["end_date"]),
        remark: json["remark"] ?? "",
      );

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "start_date": startDate.toIso8601String(),
      "salary_calculation": salaryCalculation.toJson(),
      "end_date": (endDate == null) ? null : endDate!.toIso8601String(),
      "remark": remark,
    };
  }
}

class SalaryCalculation {
  String? id;
  DateTime startDate;
  DateTime endDate;
  String? moneyType;
  bool isSimpleSalary;
  TextEditingController earningForHour;
  TextEditingController maxPayAmount;
  SalaryCalculationEarningForInvoice? earningForInvoice;
  SalaryCalculationEarningForMoneyInUsed? earningForMoneyInUsed;
  List<SalaryAdvance> salaryAdvanceList;

  SalaryCalculation({
    this.id,
    this.isSimpleSalary = true,
    required this.startDate,
    required this.endDate,
    this.moneyType,
    required this.earningForHour,
    required this.maxPayAmount,
    required this.earningForInvoice,
    required this.earningForMoneyInUsed,
    required this.salaryAdvanceList,
  });

  factory SalaryCalculation.fromJson(Map<String, dynamic> json_) {
    return SalaryCalculation(
      id: json_["_id"],
      startDate: DateTime.parse(json_["start_date"]),
      endDate: DateTime.parse(json_["end_date"]),
      moneyType: json_["money_type"],
      earningForHour: TextEditingController(
        text: formatAndLimitNumberTextGlobal(
          valueStr: json_["earning_for_hour"].toString(),
          isRound: true,
          isAllowZeroAtLast: false,
        ),
      ),
      maxPayAmount: TextEditingController(
        text: formatAndLimitNumberTextGlobal(
          valueStr: json_["max_pay_amount"].toString(),
          isRound: true,
          isAllowZeroAtLast: false,
        ),
      ),
      earningForInvoice: (json_["earning_for_invoice"] == null)
          ? SalaryCalculationEarningForInvoice(payAmount: TextEditingController(), combineMoneyInUsed: [])
          : SalaryCalculationEarningForInvoice.fromJson(json_["earning_for_invoice"]),
      earningForMoneyInUsed: (json_["earning_for_money_in_used"] == null)
          ? SalaryCalculationEarningForMoneyInUsed(payAmount: TextEditingController(), moneyList: [])
          : SalaryCalculationEarningForMoneyInUsed.fromJson(json_["earning_for_money_in_used"]),
      salaryAdvanceList: List<SalaryAdvance>.from(json_["advance_salary_list"].map((x) => SalaryAdvance.fromJson(x))),
    );
  }
  Map<String, dynamic> toJson() {
    final bool isSimpleSalary = salaryAdvanceList.isEmpty;
    return {
      "_id": id,
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "money_type": moneyType,
      "earning_for_hour": textEditingControllerToDouble(controller: earningForHour)!,
      "max_pay_amount": textEditingControllerToDouble(controller: maxPayAmount)!,
      "earning_for_invoice": (earningForInvoice == null || !isSimpleSalary) ? null : earningForInvoice!.toJson(),
      "earning_for_money_in_used": (earningForMoneyInUsed == null || !isSimpleSalary) ? null : earningForMoneyInUsed!.toJson(),
      "advance_salary_list": List<dynamic>.from(salaryAdvanceList.map((x) => x.toJson())),
    };
  }
}

class SalaryCalculationEarningForInvoice {
  TextEditingController payAmount;
  List<CombineMoneyInUsed> combineMoneyInUsed;

  SalaryCalculationEarningForInvoice({
    required this.payAmount,
    required this.combineMoneyInUsed,
  });

  factory SalaryCalculationEarningForInvoice.fromJson(Map<String, dynamic> json) => SalaryCalculationEarningForInvoice(
        payAmount: TextEditingController(
          text: formatAndLimitNumberTextGlobal(
            valueStr: json["pay_amount"].toString(),
            isRound: true,
            isAllowZeroAtLast: false,
          ),
        ),
        combineMoneyInUsed: List<CombineMoneyInUsed>.from(json["combine_money_in_used"].map((x) => CombineMoneyInUsed.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pay_amount": textEditingControllerToDouble(controller: payAmount)!,
        "combine_money_in_used": List<dynamic>.from(combineMoneyInUsed.map((x) => x.toJson())),
      };
}

class CombineMoneyInUsed {
  String? moneyType;
  TextEditingController moneyAmount;

  CombineMoneyInUsed({
    this.moneyType,
    required this.moneyAmount,
  });

  factory CombineMoneyInUsed.fromJson(Map<String, dynamic> json) => CombineMoneyInUsed(
        moneyType: json["money_type"],
        moneyAmount: TextEditingController(
          text: formatAndLimitNumberTextGlobal(
            valueStr: json["money_amount"].toString(),
            isRound: true,
            isAllowZeroAtLast: false,
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "money_type": moneyType,
        "money_amount": textEditingControllerToDouble(controller: moneyAmount)!,
      };
}

class SalaryCalculationEarningForMoneyInUsed {
  TextEditingController payAmount;
  List<CombineMoneyInUsed> moneyList;

  SalaryCalculationEarningForMoneyInUsed({
    required this.payAmount,
    required this.moneyList,
  });

  factory SalaryCalculationEarningForMoneyInUsed.fromJson(Map<String, dynamic> json) => SalaryCalculationEarningForMoneyInUsed(
        payAmount: TextEditingController(
          text: formatAndLimitNumberTextGlobal(
            valueStr: json["pay_amount"].toString(),
            isRound: true,
            isAllowZeroAtLast: false,
          ),
        ),
        moneyList: List<CombineMoneyInUsed>.from(json["money_list"].map((x) => CombineMoneyInUsed.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pay_amount": textEditingControllerToDouble(controller: payAmount)!,
        "money_list": List<dynamic>.from(moneyList.map((x) => x.toJson())),
      };
}

class SalaryAdvance {
  InvoiceEnum invoiceType;
  SalaryCalculationEarningForInvoice earningForInvoice;
  SalaryCalculationEarningForMoneyInUsed earningForMoneyInUsed;

  SalaryAdvance({
    required this.invoiceType,
    required this.earningForInvoice,
    required this.earningForMoneyInUsed,
  });

  factory SalaryAdvance.fromJson(Map<String, dynamic> json) => SalaryAdvance(
        invoiceType: invoiceTypeQueryGlobal(invoiceStr: json["invoice_type"])!,
        earningForInvoice: SalaryCalculationEarningForInvoice.fromJson(json["earning_for_invoice"]),
        earningForMoneyInUsed: SalaryCalculationEarningForMoneyInUsed.fromJson(json["earning_for_money_in_used"]),
      );

  Map<String, dynamic> toJson() => {
        "invoice_type": invoiceTypeStrGlobal(invoiceEnum: invoiceType),
        "earning_for_invoice": earningForInvoice.toJson(),
        "earning_for_money_in_used": earningForMoneyInUsed.toJson(),
      };
}
