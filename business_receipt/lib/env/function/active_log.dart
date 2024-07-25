import 'dart:convert';

import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/draw_line.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/active_log.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/employee_model/card/sell_card_model.dart';
import 'package:business_receipt/model/employee_model/exchange_money_model.dart';
import 'package:business_receipt/model/employee_model/transfer_order_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

void addActiveLogElement({
  required List<ActiveLogModel> activeLogModelList,
  required ActiveLogModel activeLogModel,
  bool isDropdownFromDropdownOrTextfield = false,
}) {
  activeLogModel.startDate = DateTime.now();
  while (activeLogModelList.length >= activeLogLimitNumberGlobal) {
    activeLogModelList.removeAt(0);
  }
  activeLogModelList.add(activeLogModel);
  if ((activeLogModel.activeType == ActiveLogTypeEnum.typeTextfield) || (activeLogModel.activeType == ActiveLogTypeEnum.changeBetweenDropdownAndTextfield)) {
    if (activeLogModelList.length >= 2) {
      if (!isDropdownFromDropdownOrTextfield) {
        final bool isSameActiveType = (activeLogModelList[(activeLogModelList.length - 2)].activeType == activeLogModel.activeType);
        final bool isSameLocationLength = (activeLogModelList[(activeLogModelList.length - 2)].locationList.length == activeLogModel.locationList.length);
        final DateTime startOrEndDateTime =
            activeLogModelList[(activeLogModelList.length - 2)].endDate ?? activeLogModelList[(activeLogModelList.length - 2)].startDate!;
        final bool isDelaySecond = (activeLogModel.startDate!.difference(startOrEndDateTime).inSeconds.abs() < activeLogDelaySecondGlobal);
        if (isSameActiveType && isSameLocationLength && isDelaySecond) {
          String beforeToStr = "";
          bool isFirstTypingBeforeToStr = true;
          if (activeLogModelList.length >= 3) {
            final bool isSameActiveType = (activeLogModelList[(activeLogModelList.length - 3)].activeType == activeLogModel.activeType);
            final bool isSameLocationLength = (activeLogModelList[(activeLogModelList.length - 3)].locationList.length == activeLogModel.locationList.length);
            // final bool isDelaySecond = (activeLogModel.startDate!.difference(activeLogModelList[(activeLogModelList.length - 3)].startDate!).inSeconds.abs() <
            //     activeLogDelaySecondGlobal);

            isFirstTypingBeforeToStr = !(isSameActiveType && isSameLocationLength);
          }
          bool isOtherInListActiveLog = false;
          if (!isFirstTypingBeforeToStr) {
            final int toStrListIndex = activeLogModelList[(activeLogModelList.length - 2)].locationList.last.subtitle.indexOf(" to ");
            if (toStrListIndex != -1) {
              beforeToStr = activeLogModelList[(activeLogModelList.length - 2)].locationList.last.subtitle.substring(0, toStrListIndex);
              isOtherInListActiveLog = activeLogModelList[(activeLogModelList.length - 2)].locationList.last.subtitle.substring(toStrListIndex + 4) == "other";
            } else {
              beforeToStr = activeLogModelList[(activeLogModelList.length - 2)].locationList.last.subtitle;
            }
          }
          if (!isOtherInListActiveLog) {
            activeLogModelList.removeLast();
            activeLogModelList.last.endDate = activeLogModel.startDate;

            final int toStrIndex = activeLogModel.locationList.last.subtitle.indexOf(" to ");
            String afterToStr = "";
            if (toStrIndex != -1) {
              afterToStr = activeLogModel.locationList.last.subtitle.substring(toStrIndex + 4);
            } else {
              afterToStr = activeLogModel.locationList.last.subtitle;
            }
            activeLogModelList.last.locationList.last.subtitle = isFirstTypingBeforeToStr ? afterToStr : "$beforeToStr to $afterToStr";
            activeLogModelList.last.locationList.last.color = (beforeToStr.length < afterToStr.length) ? ColorEnum.green : ColorEnum.red;
          }
        }
      }
    }
  }

  for (int activeIndex = 0; activeIndex < activeLogModelList.length; activeIndex++) {
    final int toStrIndex = activeLogModel.locationList.last.subtitle.indexOf(" to ");
    if (toStrIndex != -1) {
      final String afterToStr = activeLogModel.locationList.last.subtitle.substring(toStrIndex + 4);
      final String beforeToStr = activeLogModel.locationList.last.subtitle.substring(0, toStrIndex);
      if (beforeToStr == afterToStr) {
        activeLogModelList[activeIndex].locationList.last.subtitle = beforeToStr;
      }
    }
  }
}

//activeLogModelList = [1, 1, 1, 3, 2]
void setFinalEditionActiveLog({required List<ActiveLogModel> activeLogModelList}) {
  List<String> idTempList = [];
  for (int activeIndex = (activeLogModelList.length - 1); activeIndex >= 0; activeIndex--) {
    if (activeLogModelList[activeIndex].idTemp != null) {
      if (!idTempList.contains(activeLogModelList[activeIndex].idTemp)) {
        activeLogModelList[activeIndex].locationList.last.subtitle += " (final edition)";
        idTempList.add(activeLogModelList[activeIndex].idTemp!);
      }
    }
  }
}

void exchangeCheckForFinalEdition({required List<ActiveLogModel> activeLogModelList, required List<ExchangeListExchangeMoneyModel> exchangeList}) {
  for (int activeIndex = 0; activeIndex < activeLogModelList.length; activeIndex++) {
    if (activeLogModelList[activeIndex].locationList.first.title == "exchange index") {
      final int exchangeIndex = int.parse(activeLogModelList[activeIndex].locationList.first.subtitle);
      if (exchangeIndex >= exchangeList.length) {
        activeLogModelList[activeIndex].idTemp = null;
      }
    }
  }
}

void sellCardCheckForFinalEdition({required List<ActiveLogModel> activeLogModelList, required SellCardModel sellCardModel}) {
  for (int activeIndex = 0; activeIndex < activeLogModelList.length; activeIndex++) {
    if (activeLogModelList[activeIndex].locationList.first.title == "get money index") {
      final int calculateIndex = int.parse(activeLogModelList[activeIndex].locationList.first.subtitle);
      if (activeLogModelList[activeIndex].locationList.length >= 2) {
        if (activeLogModelList[activeIndex].locationList[1].title == "money type") {
          final String moneyTypeStr = activeLogModelList[activeIndex].locationList[1].subtitle;
          if (sellCardModel.mergeCalculate == null) {
            for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardModel.moneyTypeList.length; moneyTypeIndex++) {
              if (calculateIndex >= sellCardModel.moneyTypeList.length && moneyTypeStr == sellCardModel.moneyTypeList[moneyTypeIndex].calculate.moneyType) {
                activeLogModelList[activeIndex].idTemp = null;
              }
            }
          }
        }
      }
    }
  }
}

void transferCheckForFinalEdition({
  required List<ActiveLogModel> activeLogModelList,
  required List<MoneyListTransfer> moneyList,
  required List<MoneyListTransfer> mergeMoneyList,
}) {
  for (int activeIndex = 0; activeIndex < activeLogModelList.length; activeIndex++) {
    if (activeLogModelList[activeIndex].locationList.first.title == "money index") {
      final int moneyIndex = int.parse(activeLogModelList[activeIndex].locationList.first.subtitle);
      if (moneyIndex >= moneyList.length) {
        activeLogModelList[activeIndex].idTemp = null;
      }
    } else if (activeLogModelList[activeIndex].locationList.first.title == "merge money index") {
      final int mergeMoneyIndex = int.parse(activeLogModelList[activeIndex].locationList.first.subtitle);
      if (mergeMoneyIndex >= mergeMoneyList.length) {
        activeLogModelList[activeIndex].idTemp = null;
      }
    }
  }
}

void addMainStockCardCheckForFinalEdition({required List<ActiveLogModel> activeLogModelList, required List<RateForCalculateModel> rateList}) {
  for (int activeIndex = 0; activeIndex < activeLogModelList.length; activeIndex++) {
    if (activeLogModelList[activeIndex].locationList.first.title == "rate index") {
      final int rateIndex = int.parse(activeLogModelList[activeIndex].locationList.first.subtitle);
      if (rateIndex >= rateList.length) {
        activeLogModelList[activeIndex].idTemp = null;
      }
    }
  }
}

Widget activeLogListWidget({required List<ActiveLogModel> activeLogModelList}) {
  int count = 0;
  Widget activeLogWidgetElement({required ActiveLogModel activeLogModel}) {
    count++;
    Widget locationWidgetElement({required Location location}) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text("${location.title}: ", style: textStyleGlobal(level: Level.normal)),
          Text(location.subtitle, style: textStyleGlobal(level: Level.normal, color: getColorEnumToColors(colorEnum: location.color ?? ColorEnum.black))),
        ]),
      ]);
    }

    Widget drownLineWithPadding() {
      if (count != activeLogModelList.length) {
        double hight = 0;

        final DateTime currentDate = activeLogModel.endDate ?? activeLogModel.startDate!;
        final DateTime nextDate = activeLogModelList[count].startDate!;
        final int second = currentDate.difference(nextDate).inSeconds.abs();
        if (0 <= second && second < 60) {
          hight = 50;
        } else if (60 <= second && second < 300) {
          hight = 100;
        } else if (300 <= second && second < 600) {
          hight = 150;
        } else if (600 <= second && second < 900) {
          hight = 200;
        } else if (900 <= second && second < 3600) {
          hight = 250;
        } else if (3600 <= second && second < 7200) {
          hight = 300;
        } else if (7200 <= second && second < 10800) {
          hight = 350;
        } else if (10800 <= second && second < 14400) {
          hight = 400;
        } else if (14400 <= second && second < 18000) {
          hight = 450;
        } else {
          hight = 500;
        }

        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(height: hight, width: 2, color: Colors.black),
            Text(" ${secondNumberToHMSStr(second)}", style: textStyleGlobal(level: Level.normal)),
          ]),
          drawLineGlobal(),
        ]);
      } else {
        return Container();
      }
    }

    return Padding(
      padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.large), bottom: paddingSizeGlobal(level: Level.mini)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(
              "$count. ${getActiveLogEnumToString(activeLogTypeEnum: activeLogModel.activeType)}",
              style: textStyleGlobal(level: Level.normal),
            ),
          ),
          Expanded(
            child: (activeLogModel.endDate == null)
                ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(formatFullDateToStr(date: activeLogModel.startDate!), style: textStyleGlobal(level: Level.normal)),
                  ])
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "start: ${formatFullDateToStr(date: activeLogModel.startDate!)}",
                        style: TextStyle(fontSize: textSizeGlobal(level: Level.mini) * 1.25),
                      ),
                      Text(
                        "end: ${formatFullDateToStr(date: activeLogModel.endDate!)}",
                        style: TextStyle(fontSize: textSizeGlobal(level: Level.mini) * 1.25),
                      ),
                    ],
                  ),
          )
        ]),
        // Text("Location: ", style: textStyleGlobal(level: Level.normal)),
        for (int locationIndex = 0; locationIndex < activeLogModel.locationList.length; locationIndex++)
          locationWidgetElement(location: activeLogModel.locationList[locationIndex]),
        Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)), child: drawLineGlobal()),
        drownLineWithPadding(),
      ]),
    );
  }

  return activeLogModelList.isEmpty
      ? Container()
      : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.large), bottom: paddingSizeGlobal(level: Level.normal)),
            child: Text("Active Log", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
          ),
          for (int activeIndex = 0; activeIndex < activeLogModelList.length; activeIndex++)
            activeLogWidgetElement(activeLogModel: activeLogModelList[activeIndex])
        ]);
}
