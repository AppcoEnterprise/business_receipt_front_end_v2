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
  UpAndDownChart profitList;
  DateTypeEnum dateTypeEnum;
  ChartUpAndDown({super.key, required this.profitList, required this.dateTypeEnum});

  @override
  State<ChartUpAndDown> createState() => _ChartUpAndDownState();
}

class _ChartUpAndDownState extends State<ChartUpAndDown> {
  @override
  Widget build(BuildContext context) {
    String dateStr = "";
    double maxX = -1;
    List<ChartXAxis> chartXAxisList = [];
    DateTime date = DateTime.now();

    if (widget.dateTypeEnum == DateTypeEnum.day) {
      dateStr = "(00:00:00 AM ${formatDateDateToStr(date: date)}  -  23:59:59 PM ${formatDateDateToStr(date: date)})";
      maxX = 24;
      chartXAxisList = [
        for (int hourIndex = 0; hourIndex < maxX; hourIndex++) ChartXAxis(title: "$hourIndex", value: hourIndex.toDouble(), subtitle: 'h'),
      ];
    } else if (widget.dateTypeEnum == DateTypeEnum.month) {
      dateStr = "(00:00:00 AM ${formatDateDateToStr(date: DateTime(date.year, date.month, date.day - 30))}  -  23:59:59 PM ${formatDateDateToStr(date: date)})";
      maxX = 30;
      chartXAxisList = [
        for (int dayIndex = 1; dayIndex <= maxX; dayIndex++)
          ChartXAxis(
            title: DateTime(date.year, date.month, date.day - (30 - dayIndex)).day.toString(),
            subtitle: DateTime(date.year, date.month, date.day - (30 - dayIndex)).month.toString(),
            value: dayIndex.toDouble(),
          ),
      ];
    } else if (widget.dateTypeEnum == DateTypeEnum.year) {
      dateStr = "(00:00:00 AM ${formatDateDateToStr(date: DateTime(date.year, date.month - 12, date.day))}  -  23:59:59 PM ${formatDateDateToStr(date: date)})";
      maxX = 12;
      chartXAxisList = [
        for (int monthIndex = 1; monthIndex <= maxX; monthIndex++)
          ChartXAxis(
            title: DateTime(date.year, date.month - (12 - monthIndex), date.day).month.toString(),
            subtitle: DateTime(date.year, date.month - (12 - monthIndex), date.day).year.toString(),
            value: monthIndex.toDouble(),
          ),
      ];
    } else if (widget.dateTypeEnum == DateTypeEnum.all) {
      dateStr = "(from $yearlyLimitGlobal years ago)";
      maxX = yearlyLimitGlobal.toDouble();
      chartXAxisList = [
        for (int yearIndex = 1; yearIndex <= yearlyLimitGlobal; yearIndex++)
          ChartXAxis(
            title: DateTime(date.year - (yearlyLimitGlobal - yearIndex), date.month, date.day).year.toString(),
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

    Widget chartWidget({required UpAndDownChart profitList, required List<ChartXAxis> chartXAxisList}) {
      chartXAxisList.sort((a, b) => a.value.compareTo(b.value));
      Widget drawLine({double? width, double? height, required Color color, int? xIndex}) {
        return InkWell(
          onTap: () {
            if (xIndex != null) {
              Widget contentDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                final int place = findMoneyModelByMoneyType(moneyType: profitList.moneyType).decimalPlace!;
                final String profitStr = formatAndLimitNumberTextGlobal(
                  isRound: true,
                  isAddComma: true,
                  valueStr: profitList.upAndDownList[xIndex].value.toString(),
                  isAllowZeroAtLast: false,
                  places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                );
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "${formatFullDateToStr(date: profitList.upAndDownList[xIndex].startDate)} - ${formatFullDateToStr(date: profitList.upAndDownList[xIndex].endDate)}",
                    style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)),
                    child: Row(children: [
                      Text("$profitIsStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                      Text(
                        "$profitStr ${profitList.moneyType}",
                        style: textStyleGlobal(
                          level: Level.normal,
                          fontWeight: FontWeight.bold,
                          color: (profitList.upAndDownList[xIndex].value >= 0) ? positiveColorGlobal : negativeColorGlobal,
                        ),
                      ),
                    ]),
                  ),
                ]);
              }

              void okFunction() {
                closeDialogGlobal(context: context);
              }

              actionDialogSetStateGlobal(
                context: context,
                dialogWidth: okChartSizeBoxWidthGlobal,
                dialogHeight: okChartSizeBoxHeightGlobal,
                contentFunctionReturnWidget: contentDialog,
                okFunctionOnTap: okFunction,
              );
            }
          },
          child: Container(height: height, width: width, color: color),
        );
      }

      int findXDateByDateList({required int xIndex}) {
        for (int profitIndex = 0; profitIndex < profitList.upAndDownList.length; profitIndex++) {
          if (convertDateToShortNumber(startDate: profitList.upAndDownList[profitIndex].startDate) == chartXAxisList[xIndex].value) {
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
      for (int upAndDownIndex = 0; upAndDownIndex < profitList.upAndDownList.length; upAndDownIndex++) {
        if (profitList.upAndDownList[upAndDownIndex].value >= 0) {
          positiveChartColumnList.add(profitList.upAndDownList[upAndDownIndex].value);
        } else {
          negativeChartColumnList.add(profitList.upAndDownList[upAndDownIndex].value.abs());
        }
      }
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
        print("================================");
        print("xIndex: $xIndex");
        final bool isNotOutOfIndex = (xUpDate < profitList.upAndDownList.length);
        bool isExistedInDown = false;
        for (int i = 0; i < profitList.upAndDownList.length; i++) {
          final double valueDate = convertDateToShortNumber(startDate: profitList.upAndDownList[i].startDate);
          if (valueDate == chartXAxisList[xIndex].value) {
            isExistedInDown = true;
            break;
          }
        }
        if (isNotOutOfIndex) {
          if (profitList.upAndDownList[xUpDate].value >= 0) {
            final double valueDate = convertDateToShortNumber(startDate: profitList.upAndDownList[xUpDate].startDate);
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
              valueStr: (profitList.upAndDownList[xUpDate].value - betweenChartNumber).toString(),
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
            print("1");
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
                ? ((profitList.upAndDownList[xDownDate].value < 0) && (profitList.upAndDownList[(xUpDate - 1)].value != 0) && isExistedInDown)
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
          print("3");
          return Expanded(
            child: (profitList.upAndDownList[xDownDate].value < 0 && isExistedInDown)
                ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                    Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                  ])
                : Container(),
          );
        }
      }

      Widget valueDownLineWidget({required int xIndex}) {
        final bool isNotOutOfIndex = (xDownDate < profitList.upAndDownList.length);
        if (isNotOutOfIndex) {
          if (profitList.upAndDownList[xDownDate].value < 0) {
            final double valueDate = convertDateToShortNumber(startDate: profitList.upAndDownList[xDownDate].startDate);
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
              valueStr: (profitList.upAndDownList[xDownDate].value.abs() - betweenChartNumber).toString(),
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
          child: Row(
            children: [
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
                                    child: Container(
                                      color: ((profitUpIndex % 2) == 0) ? Colors.red : Colors.blue,
                                      child: Text(
                                        "${formatAndLimitNumberTextGlobal(valueStr: upChartColumnList[profitUpIndex].toString(), isRound: false)} ${widget.profitList.moneyType}",
                                        style: textStyleGlobal(level: Level.mini),
                                      ),
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
                                          "-${formatAndLimitNumberTextGlobal(valueStr: downChartColumnList[profitDownIndex].toString(), isRound: false)} ${widget.profitList.moneyType}",
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
            ],
          ),
        )
      ]);
    }

    return Scaffold(body: chartWidget(profitList: widget.profitList, chartXAxisList: chartXAxisList));
  }
}
