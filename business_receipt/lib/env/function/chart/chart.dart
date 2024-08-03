import 'dart:io';
import 'dart:math';

import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/date.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/text_limit.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/chart_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartUpAndDownWall extends StatefulWidget {
  List<UpAndDownWallElement> upAndDownList;
  DateTypeEnum dateTypeEnum;
  Function wallDetailWidget;
  String yTitleDetailStr;
  ChartUpAndDownWall({super.key,required this. yTitleDetailStr,required this.wallDetailWidget, required this.upAndDownList, required this.dateTypeEnum});

  @override
  State<ChartUpAndDownWall> createState() => _ChartUpAndDownWallState();
}

class _ChartUpAndDownWallState extends State<ChartUpAndDownWall> {
  @override
  Widget build(BuildContext context) {
    String dateStr = "";
    List<ChartXAxis> chartXAxisList = [];
    // DateTime date = DateTime.now();

    if (widget.dateTypeEnum == DateTypeEnum.day) {
      dateStr = "(00:00:00 AM ${formatDateDateToStr(date: DateTime(
        widget.upAndDownList.first.startDate.year,
        widget.upAndDownList.first.startDate.month,
        widget.upAndDownList.first.startDate.day,
      ))}  -  23:59:59 PM ${formatDateDateToStr(date: DateTime(
        widget.upAndDownList[widget.upAndDownList.length - 2].endDate.year,
        widget.upAndDownList[widget.upAndDownList.length - 2].endDate.month,
        widget.upAndDownList[widget.upAndDownList.length - 2].endDate.day,
      ))})";
      // const int maxX = 24;
      chartXAxisList = [for (int hourIndex = 0; hourIndex < widget.upAndDownList.length; hourIndex++) ChartXAxis(title: "$hourIndex", value: hourIndex.toDouble(), subtitle: 'h')];
    } else if (widget.dateTypeEnum == DateTypeEnum.month) {
      dateStr = "(00:00:00 AM ${formatDateDateToStr(date: DateTime(
        widget.upAndDownList.first.startDate.year,
        widget.upAndDownList.first.startDate.month,
        widget.upAndDownList.first.startDate.day,
      ))}  -  23:59:59 PM ${formatDateDateToStr(date: DateTime(
        widget.upAndDownList[widget.upAndDownList.length - 2].endDate.year,
        widget.upAndDownList[widget.upAndDownList.length - 2].endDate.month,
        widget.upAndDownList[widget.upAndDownList.length - 2].endDate.day,
      ))})";
      // maxX = getDaysInMonth(month: date.month, year: date.year);
      chartXAxisList = [
        for (int dayIndex = 0; dayIndex < widget.upAndDownList.length; dayIndex++)
          ChartXAxis(
            title: DateTime(
              widget.upAndDownList[dayIndex].startDate.year,
              widget.upAndDownList[dayIndex].startDate.month,
              widget.upAndDownList[dayIndex].startDate.day,
            ).day.toString(),
            subtitle: DateTime(
              widget.upAndDownList[dayIndex].startDate.year,
              widget.upAndDownList[dayIndex].startDate.month,
              widget.upAndDownList[dayIndex].startDate.day,
            ).month.toString(),
            value: dayIndex.toDouble(),
          ),
      ];
    } else if (widget.dateTypeEnum == DateTypeEnum.year) {
      dateStr = "(00:00:00 AM ${formatDateDateToStr(date: DateTime(
        widget.upAndDownList.first.startDate.year,
        widget.upAndDownList.first.startDate.month,
        widget.upAndDownList.first.startDate.day,
      ))}  -  23:59:59 PM ${formatDateDateToStr(date: DateTime(
        widget.upAndDownList[widget.upAndDownList.length - 2].endDate.year,
        widget.upAndDownList[widget.upAndDownList.length - 2].endDate.month,
        widget.upAndDownList[widget.upAndDownList.length - 2].endDate.day,
      ))})";
      // const int maxX = 12;
      chartXAxisList = [
        for (int monthIndex = 0; monthIndex < widget.upAndDownList.length; monthIndex++)
          ChartXAxis(
            title: DateTime(
              widget.upAndDownList[monthIndex].startDate.year,
              widget.upAndDownList[monthIndex].startDate.month,
              widget.upAndDownList[monthIndex].startDate.day,
            ).month.toString(),
            subtitle: DateTime(
              widget.upAndDownList[monthIndex].startDate.year,
              widget.upAndDownList[monthIndex].startDate.month,
              widget.upAndDownList[monthIndex].startDate.day,
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
              widget.upAndDownList[yearIndex].startDate.year,
              widget.upAndDownList[yearIndex].startDate.month,
              widget.upAndDownList[yearIndex].startDate.day,
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

    Widget chartWidget({required List<UpAndDownWallElement> upAndDownWallList, required List<ChartXAxis> chartXAxisList}) {
      chartXAxisList.sort((a, b) => a.value.compareTo(b.value));
      Widget drawLine({double? width, double? height, required Color color, int? xIndex}) {
        return InkWell(
          onTap: () {
            if (xIndex != null) {
              Widget contentDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "${formatFullDateToStr(date: upAndDownWallList[xIndex].startDate)} - ${formatFullDateToStr(date: upAndDownWallList[xIndex].endDate)}",
                    style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        widget.wallDetailWidget(xIndex: xIndex),
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
        for (int upAndDownIndex = 0; upAndDownIndex < upAndDownWallList.length; upAndDownIndex++) {
          if (convertDateToShortNumber(startDate: upAndDownWallList[upAndDownIndex].startDate) == chartXAxisList[xIndex].value) {
            return upAndDownIndex;
          }
        }
        return -1;
      }

      List<double> generateYAxisList({required List<double> upAndDownWallList}) {
        if (upAndDownWallList.isEmpty) {
          return [];
        }
        const int yNumber = 10;
        double miniNumber = 0;
        double maxNumber = 0;
        for (int i = 0; i < upAndDownWallList.length; i++) {
          if (i == 0) {
            miniNumber = upAndDownWallList[i];
            maxNumber = upAndDownWallList[i];
          } else {
            if (upAndDownWallList[i] < miniNumber) {
              miniNumber = upAndDownWallList[i];
            }
            if (upAndDownWallList[i] > maxNumber) {
              maxNumber = upAndDownWallList[i];
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
      for (int upAndDownIndex = 0; upAndDownIndex < upAndDownWallList.length; upAndDownIndex++) {
        if (upAndDownWallList [upAndDownIndex].value != 0) {
          if (upAndDownWallList[upAndDownIndex].value > 0) {
            positiveChartColumnList.add(upAndDownWallList[upAndDownIndex].value);
          } else {
            negativeChartColumnList.add(upAndDownWallList[upAndDownIndex].value.abs());
          }
        }
      }
      if (positiveChartColumnList.isNotEmpty || negativeChartColumnList.isNotEmpty) {
        final List<double> upChartColumnList = generateYAxisList( upAndDownWallList: positiveChartColumnList);
        int profitMaxYLineUp = upChartColumnList.isEmpty ? 0 : (upChartColumnList.length - 1);
        final List<double> downChartColumnList = generateYAxisList(upAndDownWallList: negativeChartColumnList);
        int profitMaxYLineDown = downChartColumnList.isEmpty ? 0 : (downChartColumnList.length - 1);

        int blinkFlex = 0;
        int valueFlex = 0;

        int xUpDate = 0;
        int xDownDate = 0;
        const int increaseIntNumber = 100;
        Widget valueUpLineWidget({required int xIndex}) {
          final bool isNotOutOfIndex = (xUpDate < upAndDownWallList.length);
          bool isExistedInDown = false;
          for (int i = 0; i < upAndDownWallList.length; i++) {
            final double valueDate = convertDateToShortNumber(startDate: upAndDownWallList[i].startDate);
            if (valueDate == chartXAxisList[xIndex].value) {
              isExistedInDown = true;
              break;
            }
          }
          if (isNotOutOfIndex) {
            if (upAndDownWallList[xUpDate].value == 0) {
              blinkFlex = 0;
              valueFlex = 0;
              xUpDate++;
            } else {
              if (upAndDownWallList[xUpDate].value >= 0) {
                final double valueDate = convertDateToShortNumber(startDate: upAndDownWallList[xUpDate].startDate);
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
                  valueStr: (upAndDownWallList[xUpDate].value - betweenChartNumber).toString(),
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
            return Expanded(
              child: (valueFlex == 0)
                  ? ((upAndDownWallList[xDownDate].value < 0) && (upAndDownWallList[(xUpDate - 1)].value != 0) && isExistedInDown)
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
              child: (upAndDownWallList[xDownDate].value < 0 && isExistedInDown)
                  ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.mini)),
                      Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.mini)),
                    ])
                  : Container(),
            );
          }
        }

        Widget valueDownLineWidget({required int xIndex}) {
          final bool isNotOutOfIndex = (xDownDate < upAndDownWallList.length);
          if (isNotOutOfIndex) {
            if (upAndDownWallList[xDownDate].value == 0) {
              blinkFlex = 0;
              valueFlex = 0;
              xDownDate++;
            } else {
              if (upAndDownWallList[xDownDate].value < 0) {
                final double valueDate = convertDateToShortNumber(startDate: upAndDownWallList[xDownDate].startDate);
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
                  valueStr: (upAndDownWallList[xDownDate].value.abs() - betweenChartNumber).toString(),
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
                                      "${formatAndLimitNumberTextGlobal(valueStr: upChartColumnList[profitUpIndex].toString(), isRound: false)} ${widget.yTitleDetailStr}",
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
                                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                                      Text(
                                        "-${formatAndLimitNumberTextGlobal(valueStr: downChartColumnList[profitDownIndex].toString(), isRound: false)} ${widget.yTitleDetailStr}",
                                        style: textStyleGlobal(level: Level.mini),
                                      ),
                                    ]),
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

    return chartWidget(upAndDownWallList: widget.upAndDownList, chartXAxisList: chartXAxisList);
  }
}




class LineChartDiagram extends StatelessWidget {
  final double maxX;
  final double maxY;
  final double minY;
  final List<LineChartModel> lineChartModelList;
  final List<ChartYAxis> chartYAxisList;
  final List<ChartXAxis> chartXAxisList;
  const LineChartDiagram(
      {super.key,
      required this.lineChartModelList,
      required this.chartYAxisList,
      required this.chartXAxisList,
      required this.maxX,
      required this.maxY,
      required this.minY});

  @override
  Widget build(BuildContext context) {
    return LineChart(sampleData1);
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: const LineTouchData(enabled: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 100,
              interval: 1,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              getTitlesWidget: leftTitleWidgets,
              showTitles: true,
              interval: 1,
              reservedSize: 75,
            ),
          ),
        ),
        lineBarsData: [
          for (int lineChartModelIndex = 0; lineChartModelIndex < lineChartModelList.length; lineChartModelIndex++)
            lineChartModelList[lineChartModelIndex].lineChartBarData()
        ],
        maxX: maxX,
        maxY: maxY,
        minX: 0,
        minY: minY,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text = "";
    for (int xIndex = 0; xIndex < chartYAxisList.length; xIndex++) {
      if (chartYAxisList[xIndex].value == value.toInt()) {
        text = chartYAxisList[xIndex].title;
        break;
      }
    }

    return Text(text, style: textStyleGlobal(level: Level.normal), textAlign: TextAlign.center);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget widget = Container();
    for (int xIndex = 0; xIndex < chartXAxisList.length; xIndex++) {
      if (chartXAxisList[xIndex].value == value.toInt()) {
        widget = Column(children: [
          Text(chartXAxisList[xIndex].title, style: textStyleGlobal(level: Level.normal)),
          Text(chartXAxisList[xIndex].subtitle, style: textStyleGlobal(level: Level.normal)),
        ]);
        break;
      }
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: widget);
  }
}
