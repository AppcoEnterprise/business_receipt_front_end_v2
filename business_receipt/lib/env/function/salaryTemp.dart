

// // import 'package:business_receipt/env/function/button/custom_button_env.dart';
// // import 'package:business_receipt/env/function/dialog_env.dart';
// // import 'package:business_receipt/env/function/request_api/salary_request_api_env.dart';
// // import 'package:flutter/material.dart';

// // Widget subSalaryDetailWidget() {
// //   void topFunction() {}
// //   void bottomFunction() {
// //     if (!outOfDataQuerySalaryList) {
// //       final int beforeQuery = salaryListEmployee.length;
// //       void callBack() {
// //         final int afterQuery = salaryListEmployee.length;

// //         if (beforeQuery == afterQuery) {
// //           outOfDataQuerySalaryList = true;
// //         } else {
// //           skipSalaryList = skipSalaryList + queryLimitNumberGlobal;
// //         }
// //         setStateFromDialog(() {});
// //       }

// //       getSalaryListEmployeeGlobal(
// //           callBack: callBack, context: context, skip: skipSalaryList, salaryListEmployee: salaryListEmployeeGlobal, employeeId: profileModelEmployeeTemp.id!);
// //     }
// //   }

// //   Widget salaryWidget() {
// //     return Padding(
// //       padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)),
// //       child: Text(salaryStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
// //     );
// //   }

// //   List<Widget> inWrapWidgetList() {
// //     Widget employeeButtonWidget({required int dateIndex}) {
// //       Widget setWidthSizeBox() {
// //         Widget insideSizeBoxWidget() {
// //           return Center(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text(salaryListEmployee[dateIndex].dateYMDStr, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
// //                 // scrollText(textStr: salaryListEmployeeGlobal[dateIndex].date, textStyle: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold), alignment: Alignment.topCenter),
// //                 SalaryLoading(
// //                   level: Level.normal,
// //                   salaryIndex: dateIndex,
// //                   alignment: Alignment.topCenter,
// //                   salaryListEmployee: salaryListEmployee,
// //                 ),
// //               ],
// //             ),
// //           );
// //         }

// //         void onTapUnlessDisable() {
// //           Widget editEmployeeDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
// //             double salaryTotal = 0;
// //             Widget salaryInvoiceAndMoneyInUsedTextWidget() {
// //               Widget salaryTextWidget() {
// //                 final double earningForInvoice =
// //                     textEditingControllerToDouble(controller: salaryListEmployee[dateIndex].salaryList.last.salaryCalculation.earningForInvoice)!;
// //                 final int invoiceCount = salaryListEmployee[dateIndex].displayBusinessOptionModel.exchangeCount +
// //                     salaryListEmployee[dateIndex].displayBusinessOptionModel.sellCardCount +
// //                     salaryListEmployee[dateIndex].displayBusinessOptionModel.excelCount +
// //                     salaryListEmployee[dateIndex].displayBusinessOptionModel.transferCount;
// //                 final double invoiceCalculate = invoiceCount * earningForInvoice;
// //                 salaryTotal = salaryTotal + invoiceCalculate;
// //                 final int place =
// //                     findMoneyModelByMoneyType(moneyType: salaryListEmployee[dateIndex].salaryList.last.salaryCalculation.moneyType!).decimalPlace!;
// //                 final String earningForInvoiceStr = formatAndLimitNumberTextGlobal(
// //                   valueStr: earningForInvoice.toString(),
// //                   isRound: false,
// //                   isAllowZeroAtLast: false,
// //                   // places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
// //                 );
// //                 final String invoiceCalculateStr = formatAndLimitNumberTextGlobal(
// //                   valueStr: invoiceCalculate.toString(),
// //                   isRound: false,
// //                   isAllowZeroAtLast: false,
// //                   places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
// //                 );
// //                 final String invoiceCountStr = formatAndLimitNumberTextGlobal(
// //                   valueStr: invoiceCount.toString(),
// //                   isRound: false,
// //                   isAllowZeroAtLast: false,
// //                   places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
// //                 );

// //                 final double earningForMoneyInUsed =
// //                     textEditingControllerToDouble(controller: salaryListEmployee[dateIndex].salaryList.last.salaryCalculation.earningForMoneyInUsed)!;
// //                 double mergeMoneyInUsed = 0;
// //                 for (int currencyIndex = 0; currencyIndex < salaryListEmployee[dateIndex].amountAndProfitModel.length; currencyIndex++) {
// //                   if (salaryListEmployee[dateIndex].salaryList.last.salaryCalculation.moneyType ==
// //                       salaryListEmployee[dateIndex].amountAndProfitModel[currencyIndex].moneyType) {
// //                     mergeMoneyInUsed += salaryListEmployee[dateIndex].amountAndProfitModel[currencyIndex].amountInUsed;
// //                   } else {
// //                     RateModel? rateModel = getRateModel(
// //                         rateTypeFirst: salaryListEmployee[dateIndex].amountAndProfitModel[currencyIndex].moneyType,
// //                         rateTypeLast: salaryListEmployee[dateIndex].salaryList.last.salaryCalculation.moneyType!);
// //                     if (rateModel != null) {
// //                       if (rateModel.buy != null && rateModel.sell != null) {
// //                         double averageRateNumber = (textEditingControllerToDouble(controller: rateModel.buy!.value)! +
// //                                 textEditingControllerToDouble(controller: rateModel.sell!.value)!) /
// //                             2;
// //                         final bool isMulti = salaryListEmployee[dateIndex].amountAndProfitModel[currencyIndex].moneyType == rateModel.rateType.first;
// //                         if (isMulti) {
// //                           mergeMoneyInUsed += (salaryListEmployee[dateIndex].amountAndProfitModel[currencyIndex].amountInUsed * averageRateNumber);
// //                         } else {
// //                           mergeMoneyInUsed += (salaryListEmployee[dateIndex].amountAndProfitModel[currencyIndex].amountInUsed / averageRateNumber);
// //                         }
// //                       } else {
// //                         mergeMoneyInUsed = 0;
// //                         break;
// //                       }
// //                     } else {
// //                       mergeMoneyInUsed = 0;
// //                       break;
// //                     }
// //                   }
// //                 }
// //                 final moneyInUsedCalculate = mergeMoneyInUsed * earningForMoneyInUsed;
// //                 salaryTotal = salaryTotal + moneyInUsedCalculate;
// //                 // final int place = findMoneyModelByMoneyType(moneyType: salaryListEmployee[dateIndex].salaryList.last.salaryCalculation.moneyType!).decimalPlace!;
// //                 final String earningForMoneyInUsedStr = formatAndLimitNumberTextGlobal(
// //                   valueStr: earningForMoneyInUsed.toString(),
// //                   isRound: false,
// //                   isAllowZeroAtLast: false,
// //                   // places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
// //                 );
// //                 final String moneyInUsedCalculateStr = formatAndLimitNumberTextGlobal(
// //                   valueStr: moneyInUsedCalculate.toString(),
// //                   isRound: false,
// //                   isAllowZeroAtLast: false,
// //                   places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
// //                 );
// //                 final String mergeMoneyInUsedStr = formatAndLimitNumberTextGlobal(
// //                   valueStr: mergeMoneyInUsed.toString(),
// //                   isRound: false,
// //                   isAllowZeroAtLast: false,
// //                   places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
// //                 );

// //                 return Padding(
// //                   padding: EdgeInsets.only(bottom: printPaddingSizeGlobal(level: Level.normal)),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       SingleChildScrollView(
// //                         scrollDirection: Axis.horizontal,
// //                         child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //                           Text("$invoiceSalaryStrGlobalUSD: ", style: textStyleGlobal(level: Level.normal)),
// //                           Text("$invoiceCountStr * $earningForInvoiceStr = ", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
// //                           Text("$invoiceCalculateStr ${salaryListEmployee[dateIndex].salaryList.last.salaryCalculation.moneyType}",
// //                               style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal, fontWeight: FontWeight.bold)),
// //                         ]),
// //                       ),
// //                       SingleChildScrollView(
// //                         scrollDirection: Axis.horizontal,
// //                         child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //                           Text("$moneyInUsedSalaryStrGlobalUSD: ", style: textStyleGlobal(level: Level.normal)),
// //                           Text("$mergeMoneyInUsedStr * $earningForMoneyInUsedStr = ", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
// //                           Text("$moneyInUsedCalculateStr ${salaryListEmployee[dateIndex].salaryList.last.salaryCalculation.moneyType}",
// //                               style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal, fontWeight: FontWeight.bold)),
// //                         ]),
// //                       )
// //                     ],
// //                   ),
// //                 );
// //               }

// //               void onTapUnlessDisable() {}
// //               return Padding(
// //                 padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
// //                 child: Row(children: [Expanded(child: CustomButtonGlobal(insideSizeBoxWidget: salaryTextWidget(), onTapUnlessDisable: onTapUnlessDisable))]),
// //               );
// //             }

// //             return Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Padding(
// //                   padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
// //                   child: Row(
// //                     children: [
// //                       Text("${salaryListEmployee[dateIndex].dateYMDStr} ( ", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
// //                       SalaryLoading(
// //                         level: Level.large,
// //                         salaryIndex: dateIndex,
// //                         alignment: Alignment.topCenter,
// //                         salaryListEmployee: salaryListEmployee,
// //                       ),
// //                       Text(")", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
// //                     ],
// //                   ),
// //                 ),
// //                 Expanded(
// //                   child: SingleChildScrollView(
// //                     child: Padding(
// //                       padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
// //                       child: Column(children: [
// //                         salaryInvoiceAndMoneyInUsedTextWidget(),
// //                         for (int salaryIndex = (salaryListEmployee[dateIndex].salaryList.length - 1); salaryIndex >= 0; salaryIndex--)
// //                           SalaryElementLoading(dateIndex: dateIndex, salaryIndex: salaryIndex, salaryListEmployee: salaryListEmployee),
// //                       ]),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             );
// //           }

// //           void cancelFunctionOnTap() {
// //             closeDialogGlobal(context: context);
// //           }

// //           actionDialogSetStateGlobal(
// //             dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.1,
// //             dialogWidth: dialogSizeGlobal(level: Level.mini),
// //             cancelFunctionOnTap: cancelFunctionOnTap,
// //             context: context,
// //             contentFunctionReturnWidget: editEmployeeDialog,
// //           );
// //         }

// //         return CustomButtonGlobal(
// //             sizeBoxWidth: sizeBoxWidthGlobal,
// //             sizeBoxHeight: sizeBoxHeightGlobal,
// //             insideSizeBoxWidget: insideSizeBoxWidget(),
// //             onTapUnlessDisable: onTapUnlessDisable);
// //       }

// //       return setWidthSizeBox();
// //     }

// //     return [for (int dateIndex = 0; dateIndex < salaryListEmployee.length; dateIndex++) employeeButtonWidget(dateIndex: dateIndex)];
// //   }

// //   return Padding(
// //     padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.large)),
// //     child: Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         salaryWidget(),
// //         Expanded(
// //           child: isCreateNewEmployee
// //               ? Container()
// //               : wrapScrollDetectWidget(
// //                   inWrapWidgetList: inWrapWidgetList(),
// //                   topFunction: topFunction,
// //                   bottomFunction: bottomFunction,
// //                   isShowSeeMoreWidget: !outOfDataQuerySalaryList,
// //                 ),
// //         )
// //       ],
// //     ),
// //   );
// // }

// import 'dart:async';

// import 'package:business_receipt/env/function/salary.dart';
// import 'package:business_receipt/env/function/text/scroll_text_env.dart';
// import 'package:business_receipt/env/function/text/text_config_env.dart';
// import 'package:business_receipt/env/function/text/text_style_env.dart';
// import 'package:business_receipt/env/value_env/color_env.dart';
// import 'package:business_receipt/env/value_env/invoice_type.dart';
// import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
// import 'package:business_receipt/env/value_env/other_value_env.dart';
// import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
// import 'package:business_receipt/model/employee_model/salary_model.dart';
// import 'package:business_receipt/model/money_type_and_value_model.dart';
// import 'package:flutter/material.dart';

// class SalaryLoading extends StatefulWidget {
//   int subSalaryIndex;
//   int salaryIndex;
//   Level level;
//   Alignment alignment;
//   double? width;
//   List<SalaryMergeByMonthModel> salaryListEmployee; //TODO: SalaryMergeByMonthModel or SubSalaryModel, if use SalaryMergeByMonthModel need idnex
//   SalaryLoading({
//     Key? key,
//     required this.salaryIndex,
//     required this.subSalaryIndex,
//     required this.level,
//     required this.alignment,
//     this.width,
//     required this.salaryListEmployee,
//   }) : super(key: key);

//   @override
//   State<SalaryLoading> createState() => _SalaryLoadingState();
// }

// class _SalaryLoadingState extends State<SalaryLoading> {
//   @override
//   Widget build(BuildContext context) {
//     final bool isLastArray = (widget.subSalaryIndex == 0);
//     if (isLastArray) {
//       Timer(const Duration(seconds: loadingSalarySecondNumber), () {
//         if (mounted) {
//           setState(() {});
//         }
//       });
//     }
//     if (widget.salaryListEmployee[widget.salaryIndex].subSalaryList.isEmpty || widget.salaryListEmployee[widget.salaryIndex].subSalaryList.isEmpty) {
//       return Container();
//     } else {
//       MoneyTypeAndValueModel moneyTypeAndValueModel = getSalaryEarningForHour(
//         salaryList: widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].salaryHistoryList,
//       );
//       final SalaryCalculation salaryCalculation =
//           widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].salaryHistoryList.last.salaryCalculation;
//       final double maxSalaryNumber = textEditingControllerToDouble(controller: salaryCalculation.maxPayAmount)!;
//       final String salaryMoneyType = salaryCalculation.moneyType!;
//       // for (int moneyTypeAndValueModelIndex = 0; moneyTypeAndValueModelIndex < moneyTypeAndValueModelList.length; moneyTypeAndValueModelIndex++) {
//         double salaryNumber = moneyTypeAndValueModel.value;
//         // final String salaryMoneyType = moneyTypeAndValueModel.moneyType;
//         // if (salaryMoneyType == salaryCalculation.moneyType) {
//           final bool isSimpleSalary = salaryCalculation.salaryAdvanceList.isEmpty;
//           if (isSimpleSalary) {
//             final SalaryCalculationEarningForInvoice earningForInvoiceModel = salaryCalculation.earningForInvoice!;
//             final double invoicePercentageCount = double.parse(formatAndLimitNumberTextGlobal(
//                 valueStr: (widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].displayBusinessOptionModel.exchangeSetting
//                             .exchangePercentage +
//                         widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].displayBusinessOptionModel.sellCardSetting
//                             .sellCardPercentage +
//                         widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].displayBusinessOptionModel.importFromExcelSetting
//                             .excelPercentage +
//                         widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].displayBusinessOptionModel.transferSetting
//                             .transferPercentage)
//                     .toString(),
//                 isRound: false,
//                 places: 2));
//             final double invoiceCalculate = invoicePercentageCount * textEditingControllerToDouble(controller: earningForInvoiceModel.payAmount)!;
//             salaryNumber = salaryNumber + invoiceCalculate;
//             final SalaryCalculationEarningForMoneyInUsed earningForMoneyInUsed = salaryCalculation.earningForMoneyInUsed!;
//             final double payAmountNumber = textEditingControllerToDouble(controller: earningForMoneyInUsed.payAmount)!;
//             for (int currencyIndex = 0;
//                 currencyIndex < widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel.length;
//                 currencyIndex++) {
//               for (int moneyIndex = 0; moneyIndex < earningForMoneyInUsed.moneyList.length; moneyIndex++) {
//                 if (widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].moneyType ==
//                     earningForMoneyInUsed.moneyList[moneyIndex].moneyType) {
//                   final double moneyTargetNumber = textEditingControllerToDouble(controller: earningForMoneyInUsed.moneyList[moneyIndex].moneyAmount)!;
//                   final double amountInUsed =
//                       widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].amountInUsed;
//                   salaryNumber = salaryNumber + (amountInUsed * payAmountNumber / moneyTargetNumber);
//                   break;
//                 }
//               }
//             }
//           } else {
//             void addAdvanceToSalary({
//               required String amountInUsedAndProfitMoneyType,
//               required InvoiceEnum invoiceEnum,
//               required AmountInUsedAndProfitModel amountInUsedAndProfitModel,
//               required double countPercentage,
//             }) {
//               List<SalaryAdvance> salaryAdvanceList = salaryCalculation.salaryAdvanceList;
//               for (int advanceIndex = 0; advanceIndex < salaryAdvanceList.length; advanceIndex++) {
//                 if (salaryAdvanceList[advanceIndex].invoiceType == invoiceEnum) {
//                   final SalaryCalculationEarningForInvoice earningForInvoice = salaryAdvanceList[advanceIndex].earningForInvoice; //0.02
//                   final double earningForInvoicePayAmountNumber =
//                       earningForInvoice.payAmount.text.isEmpty ? 0 : textEditingControllerToDouble(controller: earningForInvoice.payAmount)!;
//                   final double invoiceCalculate = countPercentage * earningForInvoicePayAmountNumber;
//                   salaryNumber = salaryNumber + invoiceCalculate;
//                   // final double earningForInvoicePayAmountNumber = textEditingControllerToDouble(controller: earningForInvoice.payAmount)!;
//                   // for (int moneyIndex = 0; moneyIndex < earningForInvoice.combineMoneyInUsed.length; moneyIndex++) {
//                   // if (earningForInvoice.combineMoneyInUsed[moneyIndex].moneyType == amountInUsedAndProfitMoneyType) {
//                   // final double moneyTargetNumber = textEditingControllerToDouble(controller: earningForInvoice.combineMoneyInUsed[moneyIndex].moneyAmount)!;
//                   // final double invoiceCalculate = countPercentage * earningForInvoicePayAmountNumber;
//                   // salaryNumber = salaryNumber + invoiceCalculate;
//                   // break;
//                   // }

//                   final SalaryCalculationEarningForMoneyInUsed earningForMoneyInUsed = salaryAdvanceList[advanceIndex].earningForMoneyInUsed;
//                   final double earningForMoneyInUsedPayAmountNumber = textEditingControllerToDouble(controller: earningForMoneyInUsed.payAmount)!;
//                   for (int moneyIndex = 0; moneyIndex < earningForMoneyInUsed.moneyList.length; moneyIndex++) {
//                     if (earningForMoneyInUsed.moneyList[moneyIndex].moneyType == amountInUsedAndProfitMoneyType) {
//                       final double moneyTargetNumber = textEditingControllerToDouble(controller: earningForMoneyInUsed.moneyList[moneyIndex].moneyAmount)!;
//                       final double amountInUsed = amountInUsedAndProfitModel.amountInUsed;
//                       salaryNumber = salaryNumber + (amountInUsed * earningForMoneyInUsedPayAmountNumber / moneyTargetNumber);
//                       break;
//                     }
//                   }
//                 }

//                 // break;
//                 // }
//               }
//             }

//             for (int currencyIndex = 0;
//                 currencyIndex < widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel.length;
//                 currencyIndex++) {
//               if (widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].exchange != null) {
//                 addAdvanceToSalary(
//                   amountInUsedAndProfitMoneyType:
//                       widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].moneyType,
//                   invoiceEnum: InvoiceEnum.exchange,
//                   amountInUsedAndProfitModel:
//                       widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].exchange!,
//                   countPercentage: widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].displayBusinessOptionModel.exchangeSetting
//                       .exchangePercentage,
//                 );
//               }
//               if (widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].sellCard != null) {
//                 addAdvanceToSalary(
//                   amountInUsedAndProfitMoneyType:
//                       widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].moneyType,
//                   invoiceEnum: InvoiceEnum.sellCard,
//                   amountInUsedAndProfitModel:
//                       widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].sellCard!,
//                   countPercentage: widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].displayBusinessOptionModel.sellCardSetting
//                       .sellCardPercentage,
//                 );
//               }
//               if (widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].excel != null) {
//                 addAdvanceToSalary(
//                   amountInUsedAndProfitMoneyType:
//                       widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].moneyType,
//                   invoiceEnum: InvoiceEnum.importFromExcel,
//                   amountInUsedAndProfitModel:
//                       widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].excel!,
//                   countPercentage: widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].displayBusinessOptionModel
//                       .importFromExcelSetting.excelPercentage,
//                 );
//               }
//               if (widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].transfer != null) {
//                 addAdvanceToSalary(
//                   amountInUsedAndProfitMoneyType:
//                       widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].moneyType,
//                   invoiceEnum: InvoiceEnum.transfer,
//                   amountInUsedAndProfitModel:
//                       widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].amountAndProfitModel[currencyIndex].transfer!,
//                   countPercentage: widget.salaryListEmployee[widget.salaryIndex].subSalaryList[widget.subSalaryIndex].displayBusinessOptionModel.transferSetting
//                       .transferPercentage,
//                 );
//               }
//             }
//           }
//         // }
//         salaryCalculationMoney = salaryNumber;
//       // }
//       // List<MoneyTypeAndValueModel> salaryCalculationMoneyLimitedList = [];
//       // double totalSalaryTemp = 0;
//       // for (int moneyTypeAndValueModelIndex = 0; moneyTypeAndValueModelIndex < salaryCalculationMoneyList.length; moneyTypeAndValueModelIndex++) {
//         // final double salaryCalculationNumber = salaryCalculationMoney.value;
//         // final String salaryCalculationMoneyType = salaryCalculationMoneyList[moneyTypeAndValueModelIndex].moneyType;
//         // if (salaryMoneyType == salaryCalculationMoneyType) {
//           // if ((totalSalaryTemp + salaryCalculationMoney) > maxSalaryNumber) {
//           //   salaryCalculationMoneyLimitedList.add(MoneyTypeAndValueModel(value: (maxSalaryNumber - totalSalaryTemp), moneyType: salaryMoneyType));
//           //   break;
//           // } else {
//           //   totalSalaryTemp = totalSalaryTemp + salaryCalculationNumber;
//           //   salaryCalculationMoneyLimitedList.add(MoneyTypeAndValueModel(value: salaryCalculationNumber, moneyType: salaryMoneyType));
//           // }
//         // } else {
//         //   double rateNumber = 0;
//         //   bool isMulti = true;
//         //   final RateModel? rateModel = getRateModel(rateTypeFirst: salaryMoneyType, rateTypeLast: salaryCalculationMoneyType);
//         //   if (rateModel != null) {
//         //     if (rateModel.buy != null && rateModel.sell != null) {
//         //       final double buyNumber = textEditingControllerToDouble(controller: rateModel.buy!.value)!;
//         //       final double sellNumber = textEditingControllerToDouble(controller: rateModel.sell!.value)!;
//         //       rateNumber = (buyNumber + sellNumber) / 2;
//         //       isMulti = salaryMoneyType == rateModel.rateType.first; //TODO: check this line, it should be salaryMoneyType or salaryCalculationMoneyType
//         //     }
//         //   } else {
//         //     final int salaryCalculationCurrencyIndex = currencyModelListAdminGlobal.indexWhere((element) => (element.moneyType == salaryCalculationMoneyType));
//         //     final int totalSalaryCurrencyIndex = currencyModelListAdminGlobal.indexWhere((element) => (element.moneyType == salaryMoneyType));

//         //     final double salaryCalculationCurrencyRate = currencyModelListAdminGlobal[salaryCalculationCurrencyIndex].defaultRate!;
//         //     final double totalSalaryCurrencyRate = currencyModelListAdminGlobal[totalSalaryCurrencyIndex].defaultRate!;

//         //     if (salaryCalculationCurrencyRate <= totalSalaryCurrencyRate) {
//         //       rateNumber = totalSalaryCurrencyRate; //TODO: check this line, it should be totalSalaryCurrencyRate or salaryCalculationCurrencyRate
//         //       isMulti = false; //TODO: check this line, it should be false or true
//         //     } else {
//         //       rateNumber = salaryCalculationCurrencyRate; //TODO: check this line, it should be totalSalaryCurrencyRate or salaryCalculationCurrencyRate
//         //       isMulti = true; //TODO: check this line, it should be false or true
//         //     }
//         //   }
//         //   if ((totalSalaryTemp + (isMulti ? (salaryCalculationNumber * rateNumber) : (salaryCalculationNumber / rateNumber))) > maxSalaryNumber) {
//         //     salaryCalculationMoneyLimitedList.add(MoneyTypeAndValueModel(value: (maxSalaryNumber - totalSalaryTemp), moneyType: salaryMoneyType));
//         //     break;
//         //   } else {
//         //     totalSalaryTemp = totalSalaryTemp + (isMulti ? (salaryCalculationNumber * rateNumber) : (salaryCalculationNumber / rateNumber));
//         //     salaryCalculationMoneyLimitedList.add(MoneyTypeAndValueModel(value: salaryCalculationNumber, moneyType: salaryMoneyType));
//         //   }
//         // }
//       // }
//       // String moneyStrList = "";
//       // for (int moneyTypeAndValueModelIndex = 0; moneyTypeAndValueModelIndex < salaryCalculationMoneyLimitedList.length; moneyTypeAndValueModelIndex++) {
//       //   final double salaryNumber = salaryCalculationMoneyLimitedList[moneyTypeAndValueModelIndex].value;
//       //   final String salaryStr = formatAndLimitNumberTextGlobal(valueStr: salaryNumber.toString(), isRound: false);
//       //   final String moneyType = salaryCalculationMoneyLimitedList[moneyTypeAndValueModelIndex].moneyType;
//       //   final bool isLastIndex = (moneyTypeAndValueModelIndex == (salaryCalculationMoneyLimitedList.length - 1));
//       //   final String providerOrEmpty = isLastIndex ? "" : providerStrGlobal;
//       //   moneyStrList = "$moneyStrList $salaryStr $moneyType $providerOrEmpty";
//       // }
//       return scrollText(
//         textStr: "moneyStrList",
//         textStyle: textStyleGlobal(level: widget.level, color: positiveColorGlobal),
//         width: widget.width,
//         alignment: widget.alignment,
//       );
//     }
//   }
// }
