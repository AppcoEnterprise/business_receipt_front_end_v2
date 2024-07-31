import 'dart:io';
import 'dart:math';

import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/draw_line.dart';
import 'package:business_receipt/env/function/drop_zone.dart';
import 'package:business_receipt/env/function/excel.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/date.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/text_limit.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/chart_model.dart';
import 'package:business_receipt/model/employee_model/file_model.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChartUpAndDown extends StatefulWidget {
  UpAndDownProfitChart upAndDown;
  DateTypeEnum dateTypeEnum;
  ChartUpAndDown({super.key, required this.upAndDown, required this.dateTypeEnum});

  @override
  State<ChartUpAndDown> createState() => _ChartUpAndDownState();
}

class _ChartUpAndDownState extends State<ChartUpAndDown> {
  @override
  Widget build(BuildContext context) {
    String dateStr = "";
    List<ChartXAxis> chartXAxisList = [];
    // DateTime date = DateTime.now();

    if (widget.dateTypeEnum == DateTypeEnum.day) {
      dateStr = "(00:00:00 AM ${formatDateDateToStr(date: DateTime(
        widget.upAndDown.upAndDownProfitList.first.startDate.year,
        widget.upAndDown.upAndDownProfitList.first.startDate.month,
        widget.upAndDown.upAndDownProfitList.first.startDate.day,
      ))}  -  23:59:59 PM ${formatDateDateToStr(date: DateTime(
        widget.upAndDown.upAndDownProfitList[widget.upAndDown.upAndDownProfitList.length - 2].endDate.year,
        widget.upAndDown.upAndDownProfitList[widget.upAndDown.upAndDownProfitList.length - 2].endDate.month,
        widget.upAndDown.upAndDownProfitList[widget.upAndDown.upAndDownProfitList.length - 2].endDate.day,
      ))})";
      // const int maxX = 24;
      chartXAxisList = [for (int hourIndex = 0; hourIndex < widget.upAndDown.upAndDownProfitList.length; hourIndex++) ChartXAxis(title: "$hourIndex", value: hourIndex.toDouble(), subtitle: 'h')];
    } else if (widget.dateTypeEnum == DateTypeEnum.month) {
      dateStr = "(00:00:00 AM ${formatDateDateToStr(date: DateTime(
        widget.upAndDown.upAndDownProfitList.first.startDate.year,
        widget.upAndDown.upAndDownProfitList.first.startDate.month,
        widget.upAndDown.upAndDownProfitList.first.startDate.day,
      ))}  -  23:59:59 PM ${formatDateDateToStr(date: DateTime(
        widget.upAndDown.upAndDownProfitList[widget.upAndDown.upAndDownProfitList.length - 2].endDate.year,
        widget.upAndDown.upAndDownProfitList[widget.upAndDown.upAndDownProfitList.length - 2].endDate.month,
        widget.upAndDown.upAndDownProfitList[widget.upAndDown.upAndDownProfitList.length - 2].endDate.day,
      ))})";
      // maxX = getDaysInMonth(month: date.month, year: date.year);
      chartXAxisList = [
        for (int dayIndex = 0; dayIndex < widget.upAndDown.upAndDownProfitList.length; dayIndex++)
          ChartXAxis(
            title: DateTime(
              widget.upAndDown.upAndDownProfitList[dayIndex].startDate.year,
              widget.upAndDown.upAndDownProfitList[dayIndex].startDate.month,
              widget.upAndDown.upAndDownProfitList[dayIndex].startDate.day,
            ).day.toString(),
            subtitle: DateTime(
              widget.upAndDown.upAndDownProfitList[dayIndex].startDate.year,
              widget.upAndDown.upAndDownProfitList[dayIndex].startDate.month,
              widget.upAndDown.upAndDownProfitList[dayIndex].startDate.day,
            ).month.toString(),
            value: dayIndex.toDouble(),
          ),
      ];
    } else if (widget.dateTypeEnum == DateTypeEnum.year) {
      dateStr = "(00:00:00 AM ${formatDateDateToStr(date: DateTime(
        widget.upAndDown.upAndDownProfitList.first.startDate.year,
        widget.upAndDown.upAndDownProfitList.first.startDate.month,
        widget.upAndDown.upAndDownProfitList.first.startDate.day,
      ))}  -  23:59:59 PM ${formatDateDateToStr(date: DateTime(
        widget.upAndDown.upAndDownProfitList[widget.upAndDown.upAndDownProfitList.length - 2].endDate.year,
        widget.upAndDown.upAndDownProfitList[widget.upAndDown.upAndDownProfitList.length - 2].endDate.month,
        widget.upAndDown.upAndDownProfitList[widget.upAndDown.upAndDownProfitList.length - 2].endDate.day,
      ))})";
      // const int maxX = 12;
      chartXAxisList = [
        for (int monthIndex = 0; monthIndex < widget.upAndDown.upAndDownProfitList.length; monthIndex++)
          ChartXAxis(
            title: DateTime(
              widget.upAndDown.upAndDownProfitList[monthIndex].startDate.year,
              widget.upAndDown.upAndDownProfitList[monthIndex].startDate.month,
              widget.upAndDown.upAndDownProfitList[monthIndex].startDate.day,
            ).month.toString(),
            subtitle: DateTime(
              widget.upAndDown.upAndDownProfitList[monthIndex].startDate.year,
              widget.upAndDown.upAndDownProfitList[monthIndex].startDate.month,
              widget.upAndDown.upAndDownProfitList[monthIndex].startDate.day,
            ).year.toString(),
            value: monthIndex.toDouble(),
          ),
      ];
    } else if (widget.dateTypeEnum == DateTypeEnum.all) {
      dateStr = "(from $yearlyLimitGlobal years ago)";
      // const int maxX = yearlyLimitGlobal;
      chartXAxisList = [
        for (int yearIndex = 1; yearIndex <= yearlyLimitGlobal; yearIndex++)
          ChartXAxis(
            title: DateTime(
              widget.upAndDown.upAndDownProfitList[yearIndex].startDate.year,
              widget.upAndDown.upAndDownProfitList[yearIndex].startDate.month,
              widget.upAndDown.upAndDownProfitList[yearIndex].startDate.day,
            ).year.toString(),
            subtitle: "",
            value: yearIndex.toDouble(),
          ),
      ];
    }

    double convertDateToShortNumber({required DateTime startDate}) {
      if (widget.dateTypeEnum == DateTypeEnum.day) {
        for (int chartXIndex = 0; chartXIndex < chartXAxisList.length; chartXIndex++) {
          if (startDate.hour.toString() == chartXAxisList[chartXIndex].title) {
            return chartXAxisList[chartXIndex].value;
          }
        }
      } else if (widget.dateTypeEnum == DateTypeEnum.month) {
        for (int chartXIndex = 0; chartXIndex < chartXAxisList.length; chartXIndex++) {
          if (startDate.day.toString() == chartXAxisList[chartXIndex].title && startDate.month.toString() == chartXAxisList[chartXIndex].subtitle) {
            return chartXAxisList[chartXIndex].value;
          }
        }
      } else if (widget.dateTypeEnum == DateTypeEnum.year) {
        for (int chartXIndex = 0; chartXIndex < chartXAxisList.length; chartXIndex++) {
          if (startDate.month.toString() == chartXAxisList[chartXIndex].title && startDate.year.toString() == chartXAxisList[chartXIndex].subtitle) {
            return chartXAxisList[chartXIndex].value;
          }
        }
      } else if (widget.dateTypeEnum == DateTypeEnum.all) {
        for (int chartXIndex = 0; chartXIndex < chartXAxisList.length; chartXIndex++) {
          if (startDate.year.toString() == chartXAxisList[chartXIndex].title) {
            return chartXAxisList[chartXIndex].value;
          }
        }
      }
      return 0;
    }

    Widget chartWidget({required UpAndDownProfitChart profitList, required List<ChartXAxis> chartXAxisList}) {
      chartXAxisList.sort((a, b) => a.value.compareTo(b.value));
      Widget drawLine({double? width, double? height, required Color color, int? xIndex}) {
        return InkWell(
          onTap: () {
            if (xIndex != null) {
              Widget contentDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                
                final String profitStr = formatAndLimitNumberTextGlobal(
                  isRound: false,
                  // isAddComma: true,
                  valueStr: profitList.upAndDownProfitList[xIndex].profitMerge.toString(),
                  // isAllowZeroAtLast: false,
                  // places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                );
                Widget invoiceDetailWidget({required String titleStr, required List<ProfitElement> profitList}) {
                  if (profitList.isEmpty) {
                    return Container();
                  } else {
                    Widget profitSeparateWidget({required int profitIndex}) {
                      print("==========================================");
                      print("${profitList[profitIndex].profit} == 0 => ${profitList[profitIndex].profit == 0}");
                      if (profitList[profitIndex].profit == 0) {
                        return Container();
                      } else {
                        final String profitSeparateStr = formatAndLimitNumberTextGlobal(
                          isRound: false,
                          valueStr: profitList[profitIndex].profit.toString(),
                        );
                        final String operatorStr = profitList[profitIndex].isBuyRate ? "x" : "/";
                        final String averageRateStr = formatAndLimitNumberTextGlobal(
                          isRound: false,
                          valueStr: profitList[profitIndex].averageRate.toString(),
                        );
                        final String profitSeparateResultStr = formatAndLimitNumberTextGlobal(
                          isRound: false,
                          valueStr: (profitList[profitIndex].isBuyRate
                                  ? (profitList[profitIndex].profit * profitList[profitIndex].averageRate)
                                  : (profitList[profitIndex].profit / profitList[profitIndex].averageRate))
                              .toString(),
                        );
                        return Padding(
                          padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              Text(
                                "$profitSeparateStr ${profitList[profitIndex].moneyType}",
                                style: textStyleGlobal(level: Level.normal, color: profitList[profitIndex].profit >= 0 ? positiveColorGlobal : negativeColorGlobal),
                              ),
                              Text(" $operatorStr $averageRateStr = ", style: textStyleGlobal(level: Level.normal)),
                              Text(
                                "$profitSeparateResultStr ${widget.upAndDown.moneyType}",
                                style: textStyleGlobal(level: Level.normal, color: profitList[profitIndex].profit >= 0 ? positiveColorGlobal : negativeColorGlobal),
                              ),
                            ]),
                          ),
                        );
                      }
                    }

                    bool isAllZero = true;
                    for (int profitIndex = 0; profitIndex < profitList.length; profitIndex++) {
                      if (profitList[profitIndex].profit != 0) {
                        isAllZero = false;
                        break;
                      }
                    }
                    print("isAllZero => $isAllZero");
                    return isAllZero
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text("Detail of $titleStr: ", style: textStyleGlobal(level: Level.normal)),
                              for (int profitIndex = 0; profitIndex < profitList.length; profitIndex++) profitSeparateWidget(profitIndex: profitIndex),
                            ]),
                          );
                  }
                }

                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "${formatFullDateToStr(date: profitList.upAndDownProfitList[xIndex].startDate)} - ${formatFullDateToStr(date: profitList.upAndDownProfitList[xIndex].endDate)}",
                    style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)),
                          child: Row(children: [
                            Text("$profitIsStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                            Text(
                              "$profitStr ${profitList.moneyType}",
                              style: textStyleGlobal(
                                level: Level.normal,
                                fontWeight: FontWeight.bold,
                                color: (profitList.upAndDownProfitList[xIndex].profitMerge >= 0) ? positiveColorGlobal : negativeColorGlobal,
                              ),
                            ),
                          ]),
                        ),
                        invoiceDetailWidget(titleStr: exchangeProfitStrGlobal, profitList: profitList.upAndDownProfitList[xIndex].exchangeProfitList),
                        invoiceDetailWidget(titleStr: cardProfitStrGlobal, profitList: profitList.upAndDownProfitList[xIndex].sellCardProfitList),
                        invoiceDetailWidget(titleStr: transferProfitStrGlobal, profitList: profitList.upAndDownProfitList[xIndex].transferProfitList),
                        invoiceDetailWidget(titleStr: excelProfitStrGlobal, profitList: profitList.upAndDownProfitList[xIndex].excelProfitList),
                      ]),
                    ),
                  ),
                ]);
              }

              void okFunction() {
                closeDialogGlobal(context: context);
              }

              actionDialogSetStateGlobal(
                context: context,
                dialogWidth: okChartSizeBoxWidthGlobal,
                dialogHeight: okChartSizeBoxHeightGlobal * 1.5,
                contentFunctionReturnWidget: contentDialog,
                okFunctionOnTap: okFunction,
              );
            }
          },
          child: Container(height: height, width: width, color: color),
        );
      }

      int findXDateByDateList({required int xIndex}) {
        for (int profitIndex = 0; profitIndex < profitList.upAndDownProfitList.length; profitIndex++) {
          if (convertDateToShortNumber(startDate: profitList.upAndDownProfitList[profitIndex].startDate) == chartXAxisList[xIndex].value) {
            return profitIndex;
          }
        }
        return -1;
      }

      List<double> generateYAxisList({required List<double> profitList}) {
        if (profitList.isEmpty) {
          return [];
        }
        const int yNumber = 10;
        double miniNumber = 0;
        double maxNumber = 0;
        for (int i = 0; i < profitList.length; i++) {
          if (i == 0) {
            miniNumber = profitList[i];
            maxNumber = profitList[i];
          } else {
            if (profitList[i] < miniNumber) {
              miniNumber = profitList[i];
            }
            if (profitList[i] > maxNumber) {
              maxNumber = profitList[i];
            }
          }
        }
        final double betweenNumber = maxNumber - miniNumber;
        final double multiNumber = betweenNumber / yNumber;

        double number1To10 = 0;
        int powNumber = 0;
        if (multiNumber < 1) {
          for (int powIndex = 0; powIndex < maxPlaceNumberGlobal; powIndex++) {
            final double number1To10Temp = multiNumber / pow(10, (-1 * powIndex));
            if (1 <= number1To10Temp && number1To10Temp < 10) {
              number1To10 = number1To10Temp;
              powNumber = (-1 * powIndex);
              break;
            }
          }
        } else {
          for (int powIndex = 0; powIndex < numberTextLengthGlobal; powIndex++) {
            final double number1To10Temp = multiNumber / pow(10, powIndex);
            if (1 <= number1To10Temp && number1To10Temp < 10) {
              number1To10 = number1To10Temp;
              powNumber = powIndex;
              break;
            }
          }
        }
        final double stepNumber = (((number1To10 <= 5) ? 5 : 10) * pow(10, powNumber)).toDouble();
        double startNumber = 0;
        if (miniNumber >= stepNumber) {
          final String startSetDotStr = (miniNumber * pow(10, (-1 * powNumber))).toString();
          final int dotIndex = startSetDotStr.indexOf(".");
          if (dotIndex != -1) {
            startNumber = double.parse(startSetDotStr.substring(0, dotIndex)) * pow(10, powNumber);
          } else {
            startNumber = miniNumber;
          }
        }
        List<double> resultList = [0];
        if (startNumber != 0) {
          resultList.add(startNumber);
        }

        while (resultList.last < maxNumber) {
          resultList.add(resultList.last + stepNumber);
        }
        return resultList;
      }

      final List<double> positiveChartColumnList = [];
      final List<double> negativeChartColumnList = [];
      for (int upAndDownIndex = 0; upAndDownIndex < profitList.upAndDownProfitList.length; upAndDownIndex++) {
        if (profitList.upAndDownProfitList[upAndDownIndex].profitMerge != 0) {
          if (profitList.upAndDownProfitList[upAndDownIndex].profitMerge > 0) {
            positiveChartColumnList.add(profitList.upAndDownProfitList[upAndDownIndex].profitMerge);
          } else {
            negativeChartColumnList.add(profitList.upAndDownProfitList[upAndDownIndex].profitMerge.abs());
          }
        }
      }
      if (positiveChartColumnList.isNotEmpty || negativeChartColumnList.isNotEmpty) {
        final List<double> upChartColumnList = generateYAxisList(profitList: positiveChartColumnList);
        int profitMaxYLineUp = upChartColumnList.isEmpty ? 0 : (upChartColumnList.length - 1);
        final List<double> downChartColumnList = generateYAxisList(profitList: negativeChartColumnList);
        int profitMaxYLineDown = downChartColumnList.isEmpty ? 0 : (downChartColumnList.length - 1);

        int blinkFlex = 0;
        int valueFlex = 0;

        int xUpDate = 0;
        int xDownDate = 0;
        const int increaseIntNumber = 100;
        Widget valueUpLineWidget({required int xIndex}) {
          final bool isNotOutOfIndex = (xUpDate < profitList.upAndDownProfitList.length);
          bool isExistedInDown = false;
          for (int i = 0; i < profitList.upAndDownProfitList.length; i++) {
            final double valueDate = convertDateToShortNumber(startDate: profitList.upAndDownProfitList[i].startDate);
            if (valueDate == chartXAxisList[xIndex].value) {
              isExistedInDown = true;
              break;
            }
          }
          if (isNotOutOfIndex) {
            if (profitList.upAndDownProfitList[xUpDate].profitMerge >= 0) {
              final double valueDate = convertDateToShortNumber(startDate: profitList.upAndDownProfitList[xUpDate].startDate);
              double betweenChartNumber = 0;
              if (upChartColumnList.isEmpty) {
                betweenChartNumber = 0;
              } else if (upChartColumnList.length == 1) {
                betweenChartNumber = 0;
              } else if (upChartColumnList.length == 2) {
                betweenChartNumber = upChartColumnList[1] * 2;
              } else {
                betweenChartNumber = (upChartColumnList[1] * 2) - upChartColumnList[2];
              }
              final double profitNumber = double.parse(formatAndLimitNumberTextGlobal(
                valueStr: (profitList.upAndDownProfitList[xUpDate].profitMerge - betweenChartNumber).toString(),
                isRound: false,
                isAddComma: false,
              ));

              final double profitLineNumber = double.parse(formatAndLimitNumberTextGlobal(
                valueStr: (upChartColumnList.last - betweenChartNumber).toString(),
                isRound: false,
                isAddComma: false,
              ));

              if (valueDate == chartXAxisList[xIndex].value) {
                valueFlex = int.parse(formatAndLimitNumberTextGlobal(
                  valueStr: (profitNumber * increaseIntNumber / profitLineNumber).toString(),
                  isRound: false,
                  isAddComma: false,
                  places: 0,
                ));
                blinkFlex = (increaseIntNumber - valueFlex);
                xUpDate++;
              } else {
                blinkFlex = profitMaxYLineUp * increaseIntNumber;
                valueFlex = 0;
              }
            } else {
              xUpDate++;
              return Expanded(
                child: (upChartColumnList.isEmpty)
                    ? Container()
                    : Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                        Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                      ]),
              );
            }
            return Expanded(
              child: (valueFlex == 0)
                  ? ((profitList.upAndDownProfitList[xDownDate].profitMerge < 0) && (profitList.upAndDownProfitList[(xUpDate - 1)].profitMerge != 0) && isExistedInDown)
                      ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                          Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                        ])
                      : Container()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.mini)),
                      child: Column(children: [
                        Expanded(flex: blinkFlex, child: Container()),
                        Expanded(flex: valueFlex, child: drawLine(color: Colors.green, xIndex: findXDateByDateList(xIndex: xIndex))),
                      ]),
                    ),
            );
          } else {
            return Expanded(
              child: (profitList.upAndDownProfitList[xDownDate].profitMerge < 0 && isExistedInDown)
                  ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                      Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                    ])
                  : Container(),
            );
          }
        }

        Widget valueDownLineWidget({required int xIndex}) {
          final bool isNotOutOfIndex = (xDownDate < profitList.upAndDownProfitList.length);
          if (isNotOutOfIndex) {
            if (profitList.upAndDownProfitList[xDownDate].profitMerge < 0) {
              final double valueDate = convertDateToShortNumber(startDate: profitList.upAndDownProfitList[xDownDate].startDate);
              double betweenChartNumber = 0;
              if (downChartColumnList.isEmpty) {
                betweenChartNumber = 0;
              } else if (downChartColumnList.length == 1) {
                betweenChartNumber = 0;
              } else if (downChartColumnList.length == 2) {
                betweenChartNumber = downChartColumnList[1] * 2;
              } else {
                betweenChartNumber = (downChartColumnList[1] * 2) - downChartColumnList[2];
              }
              final double profitNumber = double.parse(formatAndLimitNumberTextGlobal(
                valueStr: (profitList.upAndDownProfitList[xDownDate].profitMerge.abs() - betweenChartNumber).toString(),
                isRound: false,
                isAddComma: false,
              ));
              final double profitLineNumber = double.parse(formatAndLimitNumberTextGlobal(
                valueStr: (downChartColumnList.last - betweenChartNumber).toString(),
                isRound: false,
                isAddComma: false,
              ));

              if (valueDate == chartXAxisList[xIndex].value) {
                valueFlex = int.parse(formatAndLimitNumberTextGlobal(
                  valueStr: (profitNumber * increaseIntNumber / profitLineNumber).toString(),
                  isRound: false,
                  isAddComma: false,
                  places: 0,
                ));
                blinkFlex = (increaseIntNumber - valueFlex);
                xDownDate++;
              } else {
                blinkFlex = profitMaxYLineUp * increaseIntNumber;
                valueFlex = 0;
              }
            } else {
              xDownDate++;
              return Expanded(
                child: Column(children: [
                  Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                  Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                ]),
              );
            }
            return Expanded(
              child: (valueFlex == 0)
                  ? Column(children: [
                      Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                      Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                    ])
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.mini)),
                      child: Column(children: [
                        Expanded(flex: valueFlex, child: drawLine(color: Colors.red, xIndex: findXDateByDateList(xIndex: xIndex))),
                        Expanded(flex: blinkFlex, child: Container()),
                      ]),
                    ),
            );
          } else {
            return Expanded(
              child: upChartColumnList.isEmpty
                  ? Container()
                  : Column(children: [
                      Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                      Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                    ]),
            );
          }
        }

        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(dateStr, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
          SizedBox(
            // width: 1000,
            height: 500,
            child: Row(children: [
              SizedBox(
                width: 125,
                child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      upChartColumnList.isEmpty
                          ? Column(children: [Text("", style: textStyleGlobal(level: Level.mini)), Text("", style: textStyleGlobal(level: Level.mini))])
                          : Expanded(
                              flex: profitMaxYLineUp,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                for (int profitUpIndex = profitMaxYLineUp; profitUpIndex > 0; profitUpIndex--)
                                  Expanded(
                                    child: Text(
                                      "${formatAndLimitNumberTextGlobal(valueStr: upChartColumnList[profitUpIndex].toString(), isRound: false)} ${widget.upAndDown.moneyType}",
                                      style: textStyleGlobal(level: Level.mini),
                                    ),
                                  )
                              ]),
                            ),
                      downChartColumnList.isEmpty
                          ? Column(children: [Text("", style: textStyleGlobal(level: Level.mini)), Text("", style: textStyleGlobal(level: Level.mini))])
                          : Expanded(
                              flex: profitMaxYLineDown,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.end, children: [
                                for (int profitDownIndex = 1; profitDownIndex <= profitMaxYLineDown; profitDownIndex++)
                                  Expanded(
                                    child: Container(
                                      color: ((profitDownIndex % 2) == 0) ? Colors.red : Colors.blue,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                                        Text(
                                          "-${formatAndLimitNumberTextGlobal(valueStr: downChartColumnList[profitDownIndex].toString(), isRound: false)} ${widget.upAndDown.moneyType}",
                                          style: textStyleGlobal(level: Level.mini),
                                        ),
                                      ]),
                                    ),
                                  )
                              ]),
                            ),
                    ]),
                  ),
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [Expanded(child: drawLine(color: Colors.black, width: 2))]),
                ]),
              ),
              Expanded(
                child: Column(children: [
                  Expanded(
                    flex: profitMaxYLineUp,
                    child: Row(children: [for (int xIndex = 0; xIndex < chartXAxisList.length; xIndex++) valueUpLineWidget(xIndex: xIndex)]),
                  ),
                  drawLine(color: Colors.black, height: 2),
                  Expanded(
                    flex: profitMaxYLineDown,
                    child: Row(children: [for (int xIndex = 0; xIndex < chartXAxisList.length; xIndex++) valueDownLineWidget(xIndex: xIndex)]),
                  ),
                ]),
              ),
            ]),
          )
        ]);
      } else {
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(dateStr, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
          ]),
          SizedBox(
            // width: 1000,
            height: 500,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("No Data", style: textStyleGlobal(level: Level.normal)),
            ]),
          )
        ]);
      }
    }

    return chartWidget(profitList: widget.upAndDown, chartXAxisList: chartXAxisList);
  }
}

class ChartUp extends StatefulWidget {
  List<UpAndDownCountElement> upList;
  DateTypeEnum dateTypeEnum;
  ChartUp({super.key, required this.upList, required this.dateTypeEnum});

  @override
  State<ChartUp> createState() => _ChartUpState();
}

class _ChartUpState extends State<ChartUp> {
  @override
  Widget build(BuildContext context) {
    String dateStr = "";
    List<ChartXAxis> chartXAxisList = [];
    // DateTime date = DateTime.now();

    if (widget.dateTypeEnum == DateTypeEnum.day) {
      dateStr = "(00:00:00 AM ${formatDateDateToStr(date: DateTime(
        widget.upList.first.startDate.year,
        widget.upList.first.startDate.month,
        widget.upList.first.startDate.day,
      ))}  -  23:59:59 PM ${formatDateDateToStr(date: DateTime(
        widget.upList[widget.upList.length - 2].endDate.year,
        widget.upList[widget.upList.length - 2].endDate.month,
        widget.upList[widget.upList.length - 2].endDate.day,
      ))})";
      // const int maxX = 24;
      chartXAxisList = [for (int hourIndex = 0; hourIndex < widget.upList.length; hourIndex++) ChartXAxis(title: "$hourIndex", value: hourIndex.toDouble(), subtitle: 'h')];
    } else if (widget.dateTypeEnum == DateTypeEnum.month) {
      dateStr = "(00:00:00 AM ${formatDateDateToStr(date: DateTime(
        widget.upList.first.startDate.year,
        widget.upList.first.startDate.month,
        widget.upList.first.startDate.day,
      ))}  -  23:59:59 PM ${formatDateDateToStr(date: DateTime(
        widget.upList[widget.upList.length - 2].endDate.year,
        widget.upList[widget.upList.length - 2].endDate.month,
        widget.upList[widget.upList.length - 2].endDate.day,
      ))})";
      // maxX = getDaysInMonth(month: date.month, year: date.year);
      chartXAxisList = [
        for (int dayIndex = 0; dayIndex < widget.upList.length; dayIndex++)
          ChartXAxis(
            title: DateTime(
              widget.upList[dayIndex].startDate.year,
              widget.upList[dayIndex].startDate.month,
              widget.upList[dayIndex].startDate.day,
            ).day.toString(),
            subtitle: DateTime(
              widget.upList[dayIndex].startDate.year,
              widget.upList[dayIndex].startDate.month,
              widget.upList[dayIndex].startDate.day,
            ).month.toString(),
            value: dayIndex.toDouble(),
          ),
      ];
    } else if (widget.dateTypeEnum == DateTypeEnum.year) {
      dateStr = "(00:00:00 AM ${formatDateDateToStr(date: DateTime(
        widget.upList.first.startDate.year,
        widget.upList.first.startDate.month,
        widget.upList.first.startDate.day,
      ))}  -  23:59:59 PM ${formatDateDateToStr(date: DateTime(
        widget.upList[widget.upList.length - 2].endDate.year,
        widget.upList[widget.upList.length - 2].endDate.month,
        widget.upList[widget.upList.length - 2].endDate.day,
      ))})";
      // const int maxX = 12;
      chartXAxisList = [
        for (int monthIndex = 0; monthIndex < widget.upList.length; monthIndex++)
          ChartXAxis(
            title: DateTime(
              widget.upList[monthIndex].startDate.year,
              widget.upList[monthIndex].startDate.month,
              widget.upList[monthIndex].startDate.day,
            ).month.toString(),
            subtitle: DateTime(
              widget.upList[monthIndex].startDate.year,
              widget.upList[monthIndex].startDate.month,
              widget.upList[monthIndex].startDate.day,
            ).year.toString(),
            value: monthIndex.toDouble(),
          ),
      ];
    } else if (widget.dateTypeEnum == DateTypeEnum.all) {
      dateStr = "(from $yearlyLimitGlobal years ago)";
      // const int maxX = yearlyLimitGlobal;
      chartXAxisList = [
        for (int yearIndex = 1; yearIndex <= yearlyLimitGlobal; yearIndex++)
          ChartXAxis(
            title: DateTime(
              widget.upList[yearIndex].startDate.year,
              widget.upList[yearIndex].startDate.month,
              widget.upList[yearIndex].startDate.day,
            ).year.toString(),
            subtitle: "",
            value: yearIndex.toDouble(),
          ),
      ];
    }

    double convertDateToShortNumber({required DateTime startDate}) {
      if (widget.dateTypeEnum == DateTypeEnum.day) {
        for (int chartXIndex = 0; chartXIndex < chartXAxisList.length; chartXIndex++) {
          if (startDate.hour.toString() == chartXAxisList[chartXIndex].title) {
            return chartXAxisList[chartXIndex].value;
          }
        }
      } else if (widget.dateTypeEnum == DateTypeEnum.month) {
        for (int chartXIndex = 0; chartXIndex < chartXAxisList.length; chartXIndex++) {
          if (startDate.day.toString() == chartXAxisList[chartXIndex].title && startDate.month.toString() == chartXAxisList[chartXIndex].subtitle) {
            return chartXAxisList[chartXIndex].value;
          }
        }
      } else if (widget.dateTypeEnum == DateTypeEnum.year) {
        for (int chartXIndex = 0; chartXIndex < chartXAxisList.length; chartXIndex++) {
          if (startDate.month.toString() == chartXAxisList[chartXIndex].title && startDate.year.toString() == chartXAxisList[chartXIndex].subtitle) {
            return chartXAxisList[chartXIndex].value;
          }
        }
      } else if (widget.dateTypeEnum == DateTypeEnum.all) {
        for (int chartXIndex = 0; chartXIndex < chartXAxisList.length; chartXIndex++) {
          if (startDate.year.toString() == chartXAxisList[chartXIndex].title) {
            return chartXAxisList[chartXIndex].value;
          }
        }
      }
      return 0;
    }

    Widget chartWidget({required List<UpAndDownCountElement> countList, required List<ChartXAxis> chartXAxisList}) {
      chartXAxisList.sort((a, b) => a.value.compareTo(b.value));
      Widget drawLine({double? width, double? height, required Color color, int? xIndex}) {
        return InkWell(
          onTap: () {
            if (xIndex != null) {
              Widget contentDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "${formatFullDateToStr(date: countList[xIndex].startDate)} - ${formatFullDateToStr(date: countList[xIndex].endDate)}",
                    style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.normal)),
                          child: Text(
                            "Total Count: ${formatAndLimitNumberTextGlobal(valueStr: countList[xIndex].totalCount.toString(), isRound: false)}",
                            style: textStyleGlobal(level: Level.normal),
                          ),
                        ),
                        (countList[xIndex].exchangeCount == 0)
                            ? Container()
                            : Text(
                                "Exchange Count: ${formatAndLimitNumberTextGlobal(valueStr: countList[xIndex].exchangeCount.toString(), isRound: false)}",
                                style: textStyleGlobal(level: Level.normal),
                              ),
                        (countList[xIndex].sellCardCount == 0)
                            ? Container()
                            : Text(
                                "Sell Card Count: ${formatAndLimitNumberTextGlobal(valueStr: countList[xIndex].sellCardCount.toString(), isRound: false)}",
                                style: textStyleGlobal(level: Level.normal),
                              ),
                        (countList[xIndex].excelCount == 0)
                            ? Container()
                            : Text(
                                "Excel Count: ${formatAndLimitNumberTextGlobal(valueStr: countList[xIndex].excelCount.toString(), isRound: false)}",
                                style: textStyleGlobal(level: Level.normal),
                              ),
                        (countList[xIndex].transferCount == 0)
                            ? Container()
                            : Text(
                                "Transfer Count: ${formatAndLimitNumberTextGlobal(valueStr: countList[xIndex].transferCount.toString(), isRound: false)}",
                                style: textStyleGlobal(level: Level.normal),
                              ),
                      ]),
                    ),
                  ),
                ]);
              }

              void okFunction() {
                closeDialogGlobal(context: context);
              }

              actionDialogSetStateGlobal(
                context: context,
                dialogWidth: okChartSizeBoxWidthGlobal,
                dialogHeight: okChartSizeBoxHeightGlobal * 1.5,
                contentFunctionReturnWidget: contentDialog,
                okFunctionOnTap: okFunction,
              );
            }
          },
          child: Container(height: height, width: width, color: color),
        );
      }

      int findXDateByDateList({required int xIndex}) {
        for (int profitIndex = 0; profitIndex < countList.length; profitIndex++) {
          if (convertDateToShortNumber(startDate: countList[profitIndex].startDate) == chartXAxisList[xIndex].value) {
            return profitIndex;
          }
        }
        return -1;
      }

      List<double> generateYAxisList({required List<double> profitList}) {
        if (profitList.isEmpty) {
          return [];
        }
        const int yNumber = 10;
        double miniNumber = 0;
        double maxNumber = 0;
        for (int i = 0; i < profitList.length; i++) {
          if (i == 0) {
            miniNumber = profitList[i];
            maxNumber = profitList[i];
          } else {
            if (profitList[i] < miniNumber) {
              miniNumber = profitList[i];
            }
            if (profitList[i] > maxNumber) {
              maxNumber = profitList[i];
            }
          }
        }
        final double betweenNumber = maxNumber - miniNumber;
        final double multiNumber = betweenNumber / yNumber;

        double number1To10 = 0;
        int powNumber = 0;
        if (multiNumber < 1) {
          for (int powIndex = 0; powIndex < maxPlaceNumberGlobal; powIndex++) {
            final double number1To10Temp = multiNumber / pow(10, (-1 * powIndex));
            if (1 <= number1To10Temp && number1To10Temp < 10) {
              number1To10 = number1To10Temp;
              powNumber = (-1 * powIndex);
              break;
            }
          }
        } else {
          for (int powIndex = 0; powIndex < numberTextLengthGlobal; powIndex++) {
            final double number1To10Temp = multiNumber / pow(10, powIndex);
            if (1 <= number1To10Temp && number1To10Temp < 10) {
              number1To10 = number1To10Temp;
              powNumber = powIndex;
              break;
            }
          }
        }
        final double stepNumber = (((number1To10 <= 5) ? 5 : 10) * pow(10, powNumber)).toDouble();
        double startNumber = 0;
        if (miniNumber >= stepNumber) {
          final String startSetDotStr = (miniNumber * pow(10, (-1 * powNumber))).toString();
          final int dotIndex = startSetDotStr.indexOf(".");
          if (dotIndex != -1) {
            startNumber = double.parse(startSetDotStr.substring(0, dotIndex)) * pow(10, powNumber);
          } else {
            startNumber = miniNumber;
          }
        }
        List<double> resultList = [0];
        if (startNumber != 0) {
          resultList.add(startNumber);
        }

        while (resultList.last < maxNumber) {
          resultList.add(resultList.last + stepNumber);
        }
        return resultList;
      }

      final List<double> positiveChartColumnList = [];
      final List<double> negativeChartColumnList = [];
      for (int upAndDownIndex = 0; upAndDownIndex < countList.length; upAndDownIndex++) {
        if (countList[upAndDownIndex].totalCount != 0) {
          if (countList[upAndDownIndex].totalCount > 0) {
            positiveChartColumnList.add(countList[upAndDownIndex].totalCount.toDouble());
          } else {
            negativeChartColumnList.add(countList[upAndDownIndex].totalCount.toDouble().abs());
          }
        }
      }
      if (positiveChartColumnList.isNotEmpty || negativeChartColumnList.isNotEmpty) {
        final List<double> upChartColumnList = generateYAxisList(profitList: positiveChartColumnList);
        int profitMaxYLineUp = upChartColumnList.isEmpty ? 0 : (upChartColumnList.length - 1);
        final List<double> downChartColumnList = generateYAxisList(profitList: negativeChartColumnList);
        int profitMaxYLineDown = downChartColumnList.isEmpty ? 0 : (downChartColumnList.length - 1);

        int blinkFlex = 0;
        int valueFlex = 0;

        int xUpDate = 0;
        int xDownDate = 0;
        const int increaseIntNumber = 100;
        print("positiveChartColumnList => ${positiveChartColumnList.length}");
        Widget valueUpLineWidget({required int xIndex}) {
          final bool isNotOutOfIndex = (xUpDate < countList.length);
          print("=============================================================");
          print("xUpDate < countList.length => $isNotOutOfIndex");
          bool isExistedInDown = false;
          for (int i = 0; i < countList.length; i++) {
            final double valueDate = convertDateToShortNumber(startDate: countList[i].startDate);
            if (valueDate == chartXAxisList[xIndex].value) {
              isExistedInDown = true;
              break;
            }
          }
          if (isNotOutOfIndex) {
            print("countList[xUpDate].totalCount ${countList[xUpDate].totalCount} >= 0 => ${countList[xUpDate].totalCount >= 0}");

            if (countList[xUpDate].totalCount == 0) {
              blinkFlex = 0;
              valueFlex = 0;
              xUpDate++;
            } else {
              if (countList[xUpDate].totalCount >= 0) {
                final double valueDate = convertDateToShortNumber(startDate: countList[xUpDate].startDate);
                double betweenChartNumber = 0;
                if (upChartColumnList.isEmpty) {
                  betweenChartNumber = 0;
                } else if (upChartColumnList.length == 1) {
                  betweenChartNumber = 0;
                } else if (upChartColumnList.length == 2) {
                  betweenChartNumber = upChartColumnList[1] * 2;
                } else {
                  betweenChartNumber = (upChartColumnList[1] * 2) - upChartColumnList[2];
                }
                final double profitNumber = double.parse(formatAndLimitNumberTextGlobal(
                  valueStr: (countList[xUpDate].totalCount - betweenChartNumber).toString(),
                  isRound: false,
                  isAddComma: false,
                ));

                final double profitLineNumber = double.parse(formatAndLimitNumberTextGlobal(
                  valueStr: (upChartColumnList.last - betweenChartNumber).toString(),
                  isRound: false,
                  isAddComma: false,
                ));

                if (valueDate == chartXAxisList[xIndex].value) {
                  valueFlex = int.parse(formatAndLimitNumberTextGlobal(
                    valueStr: (profitNumber * increaseIntNumber / profitLineNumber).toString(),
                    isRound: false,
                    isAddComma: false,
                    places: 0,
                  ));
                  blinkFlex = (increaseIntNumber - valueFlex);
                  xUpDate++;
                } else {
                  blinkFlex = profitMaxYLineUp * increaseIntNumber;
                  valueFlex = 0;
                }
              } else {
                xUpDate++;
                return Expanded(
                  child: (upChartColumnList.isEmpty)
                      ? Container()
                      : Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                          Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                        ]),
                );
              }
            }
            print("blinkFlex => $blinkFlex");
            print("valueFlex => $valueFlex");
            return Expanded(
              child: (valueFlex == 0)
                  ? ((countList[xDownDate].totalCount < 0) && (countList[(xUpDate - 1)].totalCount != 0) && isExistedInDown)
                      ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                          Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                        ])
                      : Container()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.mini)),
                      child: Column(children: [
                        Expanded(flex: blinkFlex, child: Container()),
                        Expanded(flex: valueFlex, child: drawLine(color: Colors.green, xIndex: findXDateByDateList(xIndex: xIndex))),
                      ]),
                    ),
            );
          } else {
            return Expanded(
              child: (countList[xDownDate].totalCount < 0 && isExistedInDown)
                  ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                      Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                    ])
                  : Container(),
            );
          }
        }

        Widget valueDownLineWidget({required int xIndex}) {
          final bool isNotOutOfIndex = (xDownDate < countList.length);
          if (isNotOutOfIndex) {
            if (countList[xDownDate].totalCount < 0) {
              final double valueDate = convertDateToShortNumber(startDate: countList[xDownDate].startDate);
              double betweenChartNumber = 0;
              if (downChartColumnList.isEmpty) {
                betweenChartNumber = 0;
              } else if (downChartColumnList.length == 1) {
                betweenChartNumber = 0;
              } else if (downChartColumnList.length == 2) {
                betweenChartNumber = downChartColumnList[1] * 2;
              } else {
                betweenChartNumber = (downChartColumnList[1] * 2) - downChartColumnList[2];
              }
              final double profitNumber = double.parse(formatAndLimitNumberTextGlobal(
                valueStr: (countList[xDownDate].totalCount.abs() - betweenChartNumber).toString(),
                isRound: false,
                isAddComma: false,
              ));
              final double profitLineNumber = double.parse(formatAndLimitNumberTextGlobal(
                valueStr: (downChartColumnList.last - betweenChartNumber).toString(),
                isRound: false,
                isAddComma: false,
              ));

              if (valueDate == chartXAxisList[xIndex].value) {
                valueFlex = int.parse(formatAndLimitNumberTextGlobal(
                  valueStr: (profitNumber * increaseIntNumber / profitLineNumber).toString(),
                  isRound: false,
                  isAddComma: false,
                  places: 0,
                ));
                blinkFlex = (increaseIntNumber - valueFlex);
                xDownDate++;
              } else {
                blinkFlex = profitMaxYLineUp * increaseIntNumber;
                valueFlex = 0;
              }
            } else {
              xDownDate++;
              return Expanded(
                child: Column(children: [
                  Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                  Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                ]),
              );
            }
            return Expanded(
              child: (valueFlex == 0)
                  ? Column(children: [
                      Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                      Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                    ])
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.mini)),
                      child: Column(children: [
                        Expanded(flex: valueFlex, child: drawLine(color: Colors.red, xIndex: findXDateByDateList(xIndex: xIndex))),
                        Expanded(flex: blinkFlex, child: Container()),
                      ]),
                    ),
            );
          } else {
            return Expanded(
              child: upChartColumnList.isEmpty
                  ? Container()
                  : Column(children: [
                      Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                      Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                    ]),
            );
          }
        }

        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(dateStr, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
          SizedBox(
            // width: 1000,
            height: 500,
            child: Row(children: [
              SizedBox(
                width: 125,
                child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      upChartColumnList.isEmpty
                          ? Column(children: [Text("", style: textStyleGlobal(level: Level.mini)), Text("", style: textStyleGlobal(level: Level.mini))])
                          : Expanded(
                              flex: profitMaxYLineUp,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                for (int profitUpIndex = profitMaxYLineUp; profitUpIndex > 0; profitUpIndex--)
                                  Expanded(
                                    child: Text(
                                      formatAndLimitNumberTextGlobal(valueStr: upChartColumnList[profitUpIndex].toString(), isRound: false),
                                      style: textStyleGlobal(level: Level.mini),
                                    ),
                                  )
                              ]),
                            ),
                      downChartColumnList.isEmpty
                          ? Column(children: [Text("", style: textStyleGlobal(level: Level.mini)), Text("", style: textStyleGlobal(level: Level.mini))])
                          : Expanded(
                              flex: profitMaxYLineDown,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.end, children: [
                                for (int profitDownIndex = 1; profitDownIndex <= profitMaxYLineDown; profitDownIndex++)
                                  Expanded(
                                    child: Container(
                                      color: ((profitDownIndex % 2) == 0) ? Colors.red : Colors.blue,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                                        Text(
                                          "-${formatAndLimitNumberTextGlobal(valueStr: downChartColumnList[profitDownIndex].toString(), isRound: false)}",
                                          style: textStyleGlobal(level: Level.mini),
                                        ),
                                      ]),
                                    ),
                                  )
                              ]),
                            ),
                    ]),
                  ),
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [Expanded(child: drawLine(color: Colors.black, width: 2))]),
                ]),
              ),
              Expanded(
                child: Column(children: [
                  Expanded(
                    flex: profitMaxYLineUp,
                    child: Row(children: [for (int xIndex = 0; xIndex < chartXAxisList.length; xIndex++) valueUpLineWidget(xIndex: xIndex)]),
                  ),
                  drawLine(color: Colors.black, height: 2),
                  Expanded(
                    flex: profitMaxYLineDown,
                    child: Row(children: [for (int xIndex = 0; xIndex < chartXAxisList.length; xIndex++) valueDownLineWidget(xIndex: xIndex)]),
                  ),
                ]),
              ),
            ]),
          )
        ]);
      } else {
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(dateStr, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
          ]),
          SizedBox(
            // width: 1000,
            height: 500,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("No Data", style: textStyleGlobal(level: Level.normal)),
            ]),
          )
        ]);
      }
    }

    return chartWidget(countList: widget.upList, chartXAxisList: chartXAxisList);
  }
}
