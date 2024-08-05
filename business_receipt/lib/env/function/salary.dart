import 'dart:async';
import 'dart:convert';

import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/rate.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/invoice_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/salary_model.dart';
import 'package:business_receipt/model/money_type_and_value_model.dart';
import 'package:flutter/material.dart';

class SalaryValueModel {
  DateTime startDateCalculation;
  DateTime endDateCalculation;
  double value;
  SalaryValueModel({required this.value, required this.startDateCalculation, required this.endDateCalculation});
}

bool checkDateBetweenStartAndEnd({required DateTime startDate, required DateTime endDate, required DateTime date}) {
  final DateTime startDateDefault = defaultDate(hour: startDate.hour, minute: startDate.minute, second: startDate.second);
  final DateTime endDateDefault = defaultDate(hour: endDate.hour, minute: endDate.minute, second: endDate.second);
  final DateTime dateDefault = defaultDate(hour: date.hour, minute: date.minute, second: date.second);
  final bool isSmallerStartDate = (startDateDefault.compareTo(dateDefault) <= 0);
  final bool isLargerEndDate = (endDateDefault.compareTo(dateDefault) >= 0);
  return (isSmallerStartDate && isLargerEndDate);
}

SalaryValueModel getSalaryEarningForHourElement({required SalaryHistory salaryHistory}) {
  final double earningForHour = textEditingControllerToDouble(controller: salaryHistory.salaryCalculation.earningForHour)!;
  final DateTime startLogInDate = removeUAndTDate(date: salaryHistory.startDate);
  final DateTime startLogInDateDefault = defaultDate(hour: startLogInDate.hour, minute: startLogInDate.minute, second: startLogInDate.second);
  final DateTime startDateTarget = removeUAndTDate(date: salaryHistory.salaryCalculation.startDate);
  final DateTime endDateTarget = removeUAndTDate(date: salaryHistory.salaryCalculation.endDate);
  final bool isDateStartBetweenWorkTime = checkDateBetweenStartAndEnd(startDate: startDateTarget, endDate: endDateTarget, date: startLogInDate);

  DateTime? startDateCalculation;
  if (isDateStartBetweenWorkTime) {
    startDateCalculation = startLogInDate;
  } else {
    final bool isEarlyOpen = (startDateTarget.compareTo(startLogInDateDefault) >= 0);
    if (isEarlyOpen) {
      startDateCalculation = DateTime(startLogInDate.year, startLogInDate.month, startLogInDate.day, startDateTarget.hour, startDateTarget.minute);
    } else {
      startDateCalculation = DateTime(startLogInDate.year, startLogInDate.month, startLogInDate.day, endDateTarget.hour, endDateTarget.minute);
    }
  }
  DateTime? endDateCalculation;
  // salaryHistory.endDate ??= ;
  if (salaryHistory.endDate == null) {
    endDateCalculation = DateTime.now();
    final bool isDateEndBetweenWorkTime = checkDateBetweenStartAndEnd(startDate: startDateTarget, endDate: endDateTarget, date: endDateCalculation);
    if (!isDateEndBetweenWorkTime) {
      final DateTime endLogInDateDefault = defaultDate(hour: startLogInDate.hour, minute: startLogInDate.minute, second: startLogInDate.second);
      final bool isEarlyOpen = (startDateTarget.compareTo(endLogInDateDefault) >= 0);
      if (isEarlyOpen) {
        endDateCalculation = DateTime(startLogInDate.year, startLogInDate.month, startLogInDate.day, startDateTarget.hour, startDateTarget.minute);
      } else {
        endDateCalculation = DateTime(startLogInDate.year, startLogInDate.month, startLogInDate.day, endDateTarget.hour, endDateTarget.minute);
      }
    }
  } else {
    //else {
    final DateTime endLogInDate = removeUAndTDate(date: salaryHistory.endDate!);
    final DateTime endLogInDateDefault = defaultDate(hour: endLogInDate.hour, minute: endLogInDate.minute, second: endLogInDate.second);
    final bool isDateEndBetweenWorkTime = checkDateBetweenStartAndEnd(startDate: startDateTarget, endDate: endDateTarget, date: endLogInDate);
    if (isDateEndBetweenWorkTime) {
      endDateCalculation = endLogInDate;
    } else {
      final bool isLateClose = (endDateTarget.compareTo(endLogInDateDefault) <= 0);
      if (isLateClose) {
        endDateCalculation = DateTime(endLogInDate.year, endLogInDate.month, endLogInDate.day, endDateTarget.hour, endDateTarget.minute);
      } else {
        endDateCalculation = DateTime(endLogInDate.year, endLogInDate.month, endLogInDate.day, startDateTarget.hour, startDateTarget.minute);
      }
    }
  }
  // print("$startDateCalculation - $endDateCalculation => ${startDateCalculation.difference(endDateCalculation).inSeconds}");
  final bool isValidDate = (startDateCalculation.compareTo(endDateCalculation) < 0);
  final int secondBetween2Date = startDateCalculation.difference(endDateCalculation).inSeconds;
  final double value = double.parse(formatAndLimitNumberTextGlobal(
    valueStr: ((isValidDate ? secondBetween2Date : 0) * earningForHour / 3600).abs().toString(),
    isRound: false,
  ));
  return SalaryValueModel(startDateCalculation: startDateCalculation, endDateCalculation: endDateCalculation, value: value);
}

MoneyTypeAndValueModel getSalaryEarningForHour({required List<SalaryHistory> salaryList}) {
  MoneyTypeAndValueModel earningForDay = MoneyTypeAndValueModel(value: 0, moneyType: salaryList.last.salaryCalculation.moneyType!);
  for (int salaryIndex = 0; salaryIndex < salaryList.length; salaryIndex++) {
    final double salaryElementModel = getSalaryEarningForHourElement(salaryHistory: salaryList[salaryIndex]).value;

    earningForDay.value = earningForDay.value + salaryElementModel;
  }
  return earningForDay;
}

class SalaryLoading extends StatefulWidget {
  int subSalaryIndex;
  int salaryIndex;
  Level level;
  Alignment alignment;
  double? width;
  List<SalaryMergeByMonthModel> salaryListEmployee; //TODO: SalaryMergeByMonthModel or SubSalaryModel, if use SalaryMergeByMonthModel need idnex
  SalaryLoading({
    Key? key,
    required this.salaryIndex,
    required this.subSalaryIndex,
    required this.level,
    required this.alignment,
    this.width,
    required this.salaryListEmployee,
  }) : super(key: key);

  @override
  State<SalaryLoading> createState() => _SalaryLoadingState();
}

class _SalaryLoadingState extends State<SalaryLoading> {
  @override
  Widget build(BuildContext context) {
    final bool isLastArray = (widget.subSalaryIndex == 0 && widget.salaryIndex == 0);
    if (isLastArray) {
      Timer(const Duration(seconds: loadingSalarySecondNumber), () {
        if (mounted) {
          setState(() {});
        }
      });
    }
    // if (widget.salaryListEmployee[widget.salaryIndex].subSalaryList.isEmpty) {
    //   return Container();
    // } else {
    final MoneyTypeAndValueModel moneyTypeAndValueModel = calculateSalaryModel(subSalaryIndex: widget.subSalaryIndex, salaryIndex: widget.salaryIndex, salaryListEmployee: widget.salaryListEmployee);
      final String valueStr = formatAndLimitNumberTextGlobal(valueStr: moneyTypeAndValueModel.value.toString(), isRound: false);
      return scrollText(
        textStr: "$valueStr ${moneyTypeAndValueModel.moneyType}",
        textStyle: textStyleGlobal(level: widget.level, color: positiveColorGlobal),
        width: widget.width,
        alignment: widget.alignment,
      );
    // }
  }
}

MoneyTypeAndValueModel calculateSalaryModel({required int subSalaryIndex, required int salaryIndex, required List<SalaryMergeByMonthModel> salaryListEmployee}) {
  if (salaryListEmployee[salaryIndex].subSalaryList.isEmpty) {
    return MoneyTypeAndValueModel(value: 0, moneyType: '');
  }
  MoneyTypeAndValueModel moneyTypeAndValueModel = getSalaryEarningForHour(
    salaryList: salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].salaryHistoryList,
  );
  final SalaryCalculation salaryCalculation = salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].salaryHistoryList.last.salaryCalculation;
  final double maxSalaryNumber = textEditingControllerToDouble(controller: salaryCalculation.maxPayAmount)!;
  // final String salaryMoneyType = salaryCalculation.moneyType!;
  final bool isSimpleSalary = salaryCalculation.salaryAdvanceList.isEmpty;
  if (isSimpleSalary) {
    final SalaryCalculationEarningForInvoice earningForInvoiceModel = salaryCalculation.earningForInvoice!;
    final double invoicePercentageCount = double.parse(formatAndLimitNumberTextGlobal(
        valueStr: (salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].displayBusinessOptionModel.exchangeSetting.exchangePercentage +
                salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].displayBusinessOptionModel.sellCardSetting.sellCardPercentage +
                salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].displayBusinessOptionModel.importFromExcelSetting.excelPercentage +
                salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].displayBusinessOptionModel.transferSetting.transferPercentage)
            .toString(),
        isRound: false,
        places: 2));
    final double invoiceCalculate = invoicePercentageCount * textEditingControllerToDouble(controller: earningForInvoiceModel.payAmount)!;
    moneyTypeAndValueModel.value = moneyTypeAndValueModel.value + invoiceCalculate;
    final SalaryCalculationEarningForMoneyInUsed earningForMoneyInUsed = salaryCalculation.earningForMoneyInUsed!;
    final double payAmountNumber = textEditingControllerToDouble(controller: earningForMoneyInUsed.payAmount)!;
    for (int currencyIndex = 0; currencyIndex < salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel.length; currencyIndex++) {
      for (int moneyIndex = 0; moneyIndex < earningForMoneyInUsed.moneyList.length; moneyIndex++) {
        if (salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].moneyType == earningForMoneyInUsed.moneyList[moneyIndex].moneyType) {
          final double moneyTargetNumber = textEditingControllerToDouble(controller: earningForMoneyInUsed.moneyList[moneyIndex].moneyAmount)!;
          final double amountInUsed = salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].amountInUsed;
          moneyTypeAndValueModel.value = moneyTypeAndValueModel.value + (amountInUsed * payAmountNumber / moneyTargetNumber);
          break;
        }
      }
    }
  } else {
    void addAdvanceToSalary({
      required String amountInUsedAndProfitMoneyType,
      required InvoiceEnum invoiceEnum,
      required AmountInUsedAndProfitModel amountInUsedAndProfitModel,
      required double countPercentage,
    }) {
      List<SalaryAdvance> salaryAdvanceList = salaryCalculation.salaryAdvanceList;
      for (int advanceIndex = 0; advanceIndex < salaryAdvanceList.length; advanceIndex++) {
        if (salaryAdvanceList[advanceIndex].invoiceType == invoiceEnum) {
          final SalaryCalculationEarningForInvoice earningForInvoice = salaryAdvanceList[advanceIndex].earningForInvoice; //0.02
          final double earningForInvoicePayAmountNumber = earningForInvoice.payAmount.text.isEmpty ? 0 : textEditingControllerToDouble(controller: earningForInvoice.payAmount)!;
          final double invoiceCalculate = countPercentage * earningForInvoicePayAmountNumber;
          moneyTypeAndValueModel.value = moneyTypeAndValueModel.value + invoiceCalculate;
          // final double earningForInvoicePayAmountNumber = textEditingControllerToDouble(controller: earningForInvoice.payAmount)!;
          // for (int moneyIndex = 0; moneyIndex < earningForInvoice.combineMoneyInUsed.length; moneyIndex++) {
          // if (earningForInvoice.combineMoneyInUsed[moneyIndex].moneyType == amountInUsedAndProfitMoneyType) {
          // final double moneyTargetNumber = textEditingControllerToDouble(controller: earningForInvoice.combineMoneyInUsed[moneyIndex].moneyAmount)!;
          // final double invoiceCalculate = countPercentage * earningForInvoicePayAmountNumber;
          // salaryNumber = salaryNumber + invoiceCalculate;
          // break;
          // }

          final SalaryCalculationEarningForMoneyInUsed earningForMoneyInUsed = salaryAdvanceList[advanceIndex].earningForMoneyInUsed;
          final double earningForMoneyInUsedPayAmountNumber = textEditingControllerToDouble(controller: earningForMoneyInUsed.payAmount)!;
          for (int moneyIndex = 0; moneyIndex < earningForMoneyInUsed.moneyList.length; moneyIndex++) {
            if (earningForMoneyInUsed.moneyList[moneyIndex].moneyType == amountInUsedAndProfitMoneyType) {
              final double moneyTargetNumber = textEditingControllerToDouble(controller: earningForMoneyInUsed.moneyList[moneyIndex].moneyAmount)!;
              final double amountInUsed = amountInUsedAndProfitModel.amountInUsed;
              moneyTypeAndValueModel.value = moneyTypeAndValueModel.value + (amountInUsed * earningForMoneyInUsedPayAmountNumber / moneyTargetNumber);
              break;
            }
          }
        }

        // break;
        // }
      }
    }

    for (int currencyIndex = 0; currencyIndex < salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel.length; currencyIndex++) {
      if (salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].exchange != null) {
        addAdvanceToSalary(
          amountInUsedAndProfitMoneyType: salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].moneyType,
          invoiceEnum: InvoiceEnum.exchange,
          amountInUsedAndProfitModel: salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].exchange!,
          countPercentage: salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].displayBusinessOptionModel.exchangeSetting.exchangePercentage,
        );
      }
      if (salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].sellCard != null) {
        addAdvanceToSalary(
          amountInUsedAndProfitMoneyType: salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].moneyType,
          invoiceEnum: InvoiceEnum.sellCard,
          amountInUsedAndProfitModel: salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].sellCard!,
          countPercentage: salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].displayBusinessOptionModel.sellCardSetting.sellCardPercentage,
        );
      }
      if (salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].excel != null) {
        addAdvanceToSalary(
          amountInUsedAndProfitMoneyType: salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].moneyType,
          invoiceEnum: InvoiceEnum.importFromExcel,
          amountInUsedAndProfitModel: salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].excel!,
          countPercentage: salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].displayBusinessOptionModel.importFromExcelSetting.excelPercentage,
        );
      }
      if (salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].transfer != null) {
        addAdvanceToSalary(
          amountInUsedAndProfitMoneyType: salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].moneyType,
          invoiceEnum: InvoiceEnum.transfer,
          amountInUsedAndProfitModel: salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].amountAndProfitModel[currencyIndex].transfer!,
          countPercentage: salaryListEmployee[salaryIndex].subSalaryList[subSalaryIndex].displayBusinessOptionModel.transferSetting.transferPercentage,
        );
      }
    }
  }
  if (moneyTypeAndValueModel.value > maxSalaryNumber) {
    moneyTypeAndValueModel.value = maxSalaryNumber;
  }
  return moneyTypeAndValueModel;
}

// ignore: must_be_immutable
class SalaryElementLoading extends StatefulWidget {
  int dateIndex;
  int salaryIndex;
  int salaryHistoryIndex;

  List<SalaryMergeByMonthModel> salaryListEmployee; //TODO: SalaryMergeByMonthModel or SubSalaryModel, if use SalaryMergeByMonthModel need idnex
  SalaryElementLoading({super.key, required this.dateIndex, required this.salaryIndex, required this.salaryHistoryIndex, required this.salaryListEmployee});

  @override
  State<SalaryElementLoading> createState() => _SalaryElementLoadingState();
}

class _SalaryElementLoadingState extends State<SalaryElementLoading> {
  @override
  Widget build(BuildContext context) {
    final bool isLastArray = (widget.dateIndex == 0) &&
        (widget.salaryIndex == 0) &&
        (widget.salaryHistoryIndex == (widget.salaryListEmployee[widget.dateIndex].subSalaryList[widget.salaryIndex].salaryHistoryList.length - 1));
    if (isLastArray) {
      Timer(const Duration(seconds: loadingSalarySecondNumber), () {
        if (mounted) {
          setState(() {});
        }
      });
    }
    Widget insideSizeBoxWidget() {
      final SalaryValueModel salaryValueModel = getSalaryEarningForHourElement(
        salaryHistory: widget.salaryListEmployee[widget.dateIndex].subSalaryList[widget.salaryIndex].salaryHistoryList[widget.salaryHistoryIndex],
      );
      Widget hourTextWidget({required DateTime? date, required String titleStr}) {
        return Row(children: [
          Text("$titleStr: ", style: textStyleGlobal(level: Level.normal)),
          Text(
            ((date == null) ? isWorkingStrGlobal : formatDateHourToStr(date: date)),
            style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
          ),
        ]);
      }

      Widget startHourTextWidget() {
        return hourTextWidget(titleStr: startWorkStrGlobal, date: salaryValueModel.startDateCalculation);
      }

      Widget endHourTextWidget() {
        return hourTextWidget(titleStr: endWorkStrGlobal, date: salaryValueModel.endDateCalculation);
      }

      Widget salaryAndMoneyTypeTextWidget() {
        final String salaryElement = formatAndLimitNumberTextGlobal(valueStr: salaryValueModel.value.toString(), isRound: false);
        final String moneyType = widget.salaryListEmployee[widget.dateIndex].subSalaryList[widget.salaryIndex].salaryHistoryList[widget.salaryHistoryIndex].salaryCalculation.moneyType!;

        final int secondBetween2Date = salaryValueModel.startDateCalculation.difference(salaryValueModel.endDateCalculation).inSeconds;
        final double earning = textEditingControllerToDouble(
            controller: widget.salaryListEmployee[widget.dateIndex].subSalaryList[widget.salaryIndex].salaryHistoryList[widget.salaryHistoryIndex].salaryCalculation.earningForHour)!;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text("$earningStrGlobal: ", style: textStyleGlobal(level: Level.normal)),
              Text("${hhMmSsDuration(Duration(seconds: secondBetween2Date.abs()))} x $earning = ", style: textStyleGlobal(level: Level.normal)),
              Text("$salaryElement $moneyType", style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      }

      Widget remarkTextWidget() {
        final remark = widget.salaryListEmployee[widget.dateIndex].subSalaryList[widget.salaryIndex].salaryHistoryList[widget.salaryHistoryIndex].remark;
        return remark.isEmpty
            ? Container()
            : Text(
                "$remarkStrGlobal: ${widget.salaryListEmployee[widget.dateIndex].subSalaryList[widget.salaryIndex].salaryHistoryList[widget.salaryHistoryIndex].remark}",
                style: textStyleGlobal(level: Level.mini),
              );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [startHourTextWidget(), endHourTextWidget(), salaryAndMoneyTypeTextWidget(), remarkTextWidget()],
      );
    }

    void onTapUnlessDisable() {}
    return Padding(
      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
      child: Row(children: [Expanded(child: CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable))]),
    );
    // return Container();
  }
}
