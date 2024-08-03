// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/chart/chart.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/draw_line.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/request_api/chart_request_api_env.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/toggle_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/date.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_or_admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/chart_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class ChartAdminSideMenu extends StatefulWidget {
  String title;
  ChartAdminSideMenu({Key? key, required this.title}) : super(key: key);

  @override
  State<ChartAdminSideMenu> createState() => _ChartAdminSideMenuState();
}

class _ChartAdminSideMenuState extends State<ChartAdminSideMenu> {
  // DateTime? date = DateTime.now();
  int dateTypeIndex = 0;
  int chartTypeIndex = 0;
  String? moneyType;
  // double detailWidth = 400;
  // double detailHeight = 340;
  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      List<Widget> inWrapWidgetList() {
        Widget addCardStockWidget() {
          Widget insideSizeBoxWidget() {
            Widget dateTypeDropDownWidget() {
              void onTapFunction() {}
              void onChangedFunction({required String value, required int index}) {
                dateTypeIndex = index;
                setState(() {});
              }

              return customDropdown(
                level: Level.normal,
                labelStr: dateTypeNameStrGlobal,
                onTapFunction: onTapFunction,
                onChangedFunction: onChangedFunction,
                selectedStr: dateTypeStrList[dateTypeIndex],
                menuItemStrList: dateTypeStrList,
              );
            }

            Widget chartTypeDropDownWidget() {
              void onTapFunction() {}
              void onChangedFunction({required String value, required int index}) {
                chartTypeIndex = index;
                moneyType = null;
                setState(() {});
              }

              return customDropdown(
                level: Level.normal,
                labelStr: chartTypeNameStrGlobal,
                onTapFunction: onTapFunction,
                onChangedFunction: onChangedFunction,
                selectedStr: chartTypeStrList[chartTypeIndex],
                menuItemStrList: chartTypeStrList,
              );
            }

            Widget moneyTypeDropDownWidget() {
              void onTapFunction() {}
              void onChangedFunction({required String value, required int index}) {
                if (value == noneStrGlobal) {
                  moneyType = null;
                } else {
                  moneyType = value;
                }
                setState(() {});
              }

              return (chartTypeIndex == 0)
                  ? customDropdown(
                      level: Level.normal,
                      labelStr: moneyTypeStrGlobal,
                      onTapFunction: onTapFunction,
                      onChangedFunction: onChangedFunction,
                      selectedStr: moneyType,
                      menuItemStrList: moneyTypeOnlyList(moneyTypeDefault: moneyType, isHasNone: false, isNotCheckDeleted: false),
                    )
                  : Container();
            }

            Widget paddingWidget({required Widget widget}) {
              return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: widget);
            }

            return Column(children: [
              // paddingWidget(widget: dateSelectedWidget()),
              paddingWidget(widget: dateTypeDropDownWidget()),
              (chartTypeIndex == 0) ? paddingWidget(widget: chartTypeDropDownWidget()) : chartTypeDropDownWidget(),
              moneyTypeDropDownWidget(),
            ]);
          }

          void onTapUnlessDisable() {}
          return CustomButtonGlobal(sizeBoxWidth: dialogSizeGlobal(level: Level.mini), insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
        }

        return [addCardStockWidget()];
      }

      Future<void> calculateOnTapFunction() async {
        final DateTime currentDate = DateTime.now();
        DateTime? date;
        if (getDateTypeEnumByIndex(index: dateTypeIndex) == DateTypeEnum.day) {
          date = await showDatePicker(
            context: context,
            initialDate: currentDate,
            firstDate: firstDateGlobal!,
            lastDate: currentDate,
          );
        } else if (getDateTypeEnumByIndex(index: dateTypeIndex) == DateTypeEnum.month) {
          List<DateTime> dateTimeList = getMonthInYear(startDate: firstDateGlobal!, endDate: currentDate);
          int selectedDate = dateTimeList.length - 1;
          void cancelFunctionOnTap() {
            closeDialogGlobal(context: context);
          }

          Widget calculateCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
            Widget dateButtonWidget({required int dateIndex}) {
              void onTapUnlessDisable() {
                selectedDate = dateIndex;
                setStateFromDialog(() {});
              }
              Widget insideSizeBoxWidget() {
                return Text(formatDateYMToStr(date: dateTimeList[dateIndex]), style: textStyleGlobal(level: Level.normal,  color: (selectedDate == dateIndex) ? Colors.black : Colors.white));
              }

              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini), right: paddingSizeGlobal(level: Level.mini)),
                child: CustomButtonGlobal(isDisable: (selectedDate == dateIndex), colorSideBox: Colors.blue, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable),
              );
            }

            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: Text("Select Month", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
              ),
              SingleChildScrollView(
                child: Wrap(children: [
                  for (int i = 0; i < dateTimeList.length; i++) dateButtonWidget(dateIndex: i),
                ]),
              ),
            ]);
          }

          void okFunctionOnTap() {
            date = dateTimeList[selectedDate];
            closeDialogGlobal(context: context);
          }

          await actionDialogSetStateGlobal(
            dialogWidth: okChartSizeBoxWidthGlobal,
            dialogHeight: okChartSizeBoxHeightGlobal,
            cancelFunctionOnTap: cancelFunctionOnTap,
            context: context,
            okFunctionOnTap: okFunctionOnTap,
            contentFunctionReturnWidget: calculateCardDialog,
          );
        } else if (getDateTypeEnumByIndex(index: dateTypeIndex) == DateTypeEnum.year) {
          List<DateTime> dateTimeList = getYearInAllYear(startDate: firstDateGlobal!, endDate: currentDate);
          int selectedDate = dateTimeList.length - 1;
          void cancelFunctionOnTap() {
            closeDialogGlobal(context: context);
          }

          Widget calculateCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
            Widget dateButtonWidget({required int dateIndex}) {
              void onTapUnlessDisable() {}
              Widget insideSizeBoxWidget() {
                return Text(formatDateYToStr(date: dateTimeList[dateIndex]), style: textStyleGlobal(level: Level.normal, color: (selectedDate == dateIndex) ? Colors.black : Colors.white));
              }

              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini), right: paddingSizeGlobal(level: Level.mini)),
                child: CustomButtonGlobal(isDisable: (selectedDate == dateIndex), colorSideBox: Colors.blue, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable),
              );
            }

            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: Text("Select Year", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
              ),
              SingleChildScrollView(
                child: Wrap(children: [
                  for (int i = 0; i < dateTimeList.length; i++) dateButtonWidget(dateIndex: i),
                ]),
              ),
            ]);
          }

          void okFunctionOnTap() {
            date = dateTimeList[selectedDate];
            closeDialogGlobal(context: context);
          }

          await actionDialogSetStateGlobal(
            dialogWidth: okChartSizeBoxWidthGlobal,
            dialogHeight: okChartSizeBoxHeightGlobal,
            cancelFunctionOnTap: cancelFunctionOnTap,
            context: context,
            okFunctionOnTap: okFunctionOnTap,
            contentFunctionReturnWidget: calculateCardDialog,
          );
        } else {}
        if (date != null) {
          void callBack({required UpAndDownProfitChart? chartProfitModelTemp, required List<UpAndDownCountElement>? chartCountModelListTemp, required String chartType}) {
            Widget calculateCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
              if (chartTypeIndex == 0) {
                Widget wallDetailWidget({required int xIndex}) {
                  final String profitStr = formatAndLimitNumberTextGlobal(
                    isRound: false,
                    valueStr: chartProfitModelTemp!.upAndDownProfitList[xIndex].profitMerge.toString(),
                  );
                  Widget invoiceDetailWidget({required String titleStr, required List<ProfitAndRateElement> profitList}) {
                    if (profitList.isEmpty) {
                      return Container();
                    } else {
                      Widget profitSeparateWidget({required int profitIndex}) {
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
                                  "$profitSeparateResultStr ${chartProfitModelTemp.moneyType}",
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
                    Padding(
                      padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)),
                      child: Row(children: [
                        Text("$profitIsStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                        Text(
                          "$profitStr ${chartProfitModelTemp.moneyType}",
                          style: textStyleGlobal(
                            level: Level.normal,
                            fontWeight: FontWeight.bold,
                            color: (chartProfitModelTemp.upAndDownProfitList[xIndex].profitMerge >= 0) ? positiveColorGlobal : negativeColorGlobal,
                          ),
                        ),
                      ]),
                    ),
                    invoiceDetailWidget(titleStr: exchangeProfitStrGlobal, profitList: chartProfitModelTemp.upAndDownProfitList[xIndex].exchangeProfitList),
                    invoiceDetailWidget(titleStr: cardProfitStrGlobal, profitList: chartProfitModelTemp.upAndDownProfitList[xIndex].sellCardProfitList),
                    invoiceDetailWidget(titleStr: transferProfitStrGlobal, profitList: chartProfitModelTemp.upAndDownProfitList[xIndex].transferProfitList),
                    invoiceDetailWidget(titleStr: excelProfitStrGlobal, profitList: chartProfitModelTemp.upAndDownProfitList[xIndex].excelProfitList),
                  ]);
                }

                List<UpAndDownWallElement> upAndDownList = [];
                for (int xIndex = 0; xIndex < chartProfitModelTemp!.upAndDownProfitList.length; xIndex++) {
                  upAndDownList.add(UpAndDownWallElement(
                    startDate: chartProfitModelTemp.upAndDownProfitList[xIndex].startDate,
                    endDate: chartProfitModelTemp.upAndDownProfitList[xIndex].endDate,
                    value: chartProfitModelTemp.upAndDownProfitList[xIndex].profitMerge,
                  ));
                }

                return SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text("All Profit Marge By ${chartProfitModelTemp.moneyType}", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                    ChartUpAndDownWall(
                      upAndDownList: upAndDownList,
                      wallDetailWidget: wallDetailWidget,
                      dateTypeEnum: getDateTypeEnumByIndex(index: dateTypeIndex),
                      yTitleDetailStr: chartProfitModelTemp.moneyType!,
                    ),
                  ]),
                );
              } else if (chartTypeIndex == 1) {
                Widget wallDetailWidget({required int xIndex}) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                      child: Text(
                        "Total Count: ${formatAndLimitNumberTextGlobal(valueStr: chartCountModelListTemp![xIndex].totalCount.toString(), isRound: false)}",
                        style: textStyleGlobal(level: Level.normal),
                      ),
                    ),
                    (chartCountModelListTemp[xIndex].exchangeCount == 0)
                        ? Container()
                        : Text(
                            "Exchange Count: ${formatAndLimitNumberTextGlobal(valueStr: chartCountModelListTemp[xIndex].exchangeCount.toString(), isRound: false)}",
                            style: textStyleGlobal(level: Level.normal),
                          ),
                    (chartCountModelListTemp[xIndex].sellCardCount == 0)
                        ? Container()
                        : Text(
                            "Sell Card Count: ${formatAndLimitNumberTextGlobal(valueStr: chartCountModelListTemp[xIndex].sellCardCount.toString(), isRound: false)}",
                            style: textStyleGlobal(level: Level.normal),
                          ),
                    (chartCountModelListTemp[xIndex].excelCount == 0)
                        ? Container()
                        : Text(
                            "Excel Count: ${formatAndLimitNumberTextGlobal(valueStr: chartCountModelListTemp[xIndex].excelCount.toString(), isRound: false)}",
                            style: textStyleGlobal(level: Level.normal),
                          ),
                    (chartCountModelListTemp[xIndex].transferCount == 0)
                        ? Container()
                        : Text(
                            "Transfer Count: ${formatAndLimitNumberTextGlobal(valueStr: chartCountModelListTemp[xIndex].transferCount.toString(), isRound: false)}",
                            style: textStyleGlobal(level: Level.normal),
                          ),
                  ]);
                }

                List<UpAndDownWallElement> upAndDownList = [];
                for (int xIndex = 0; xIndex < chartCountModelListTemp!.length; xIndex++) {
                  upAndDownList.add(UpAndDownWallElement(
                    startDate: chartCountModelListTemp[xIndex].startDate,
                    endDate: chartCountModelListTemp[xIndex].endDate,
                    value: chartCountModelListTemp[xIndex].totalCount.toDouble(),
                  ));
                }

                return SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text("Count Invoices", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                    ChartUpAndDownWall(
                      upAndDownList: upAndDownList,
                      wallDetailWidget: wallDetailWidget,
                      dateTypeEnum: getDateTypeEnumByIndex(index: dateTypeIndex),
                      yTitleDetailStr: "invoices",
                    ),
                  ]),
                );
                // return SingleChildScrollView(
                //   child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                //     Text("Count Invoices", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                //     ChartUp(upList: chartCountModelListTemp!, dateTypeEnum: getDateTypeEnumByIndex(index: dateTypeIndex)),
                //   ]),
                // );
              }
              return Container();
            }

            void cancelFunctionOnTap() {
              closeDialogGlobal(context: context);
            }

            actionDialogSetStateGlobal(
              dialogHeight: dialogSizeGlobal(level: Level.mini),
              dialogWidth: dialogSizeGlobal(level: Level.large),
              cancelFunctionOnTap: cancelFunctionOnTap,
              context: context,
              contentFunctionReturnWidget: calculateCardDialog,
            );
          }

          getChartAdminGlobal(
            callBack: callBack,
            context: context,
            chartDateTypeStr: dateTypeStrList[dateTypeIndex],
            selectedDate: date!,
            chartType: chartTypeStrList[chartTypeIndex],
            moneyType: moneyType,
          );
        }
      }

      ValidButtonModel isValidCalculateOnTap() {
        if (moneyType != null || (chartTypeIndex != 0)) {
          return ValidButtonModel(isValid: true);
        } else {
          return ValidButtonModel(
            isValid: moneyType != null,
            errorType: ErrorTypeEnum.valueOfString,
            error: "money type is not selected",
          );
        }
      }

      return BodyTemplateSideMenu(
        title: widget.title,
        inWrapWidgetList: inWrapWidgetList(),
        isValidCalculateOnTap: isValidCalculateOnTap(),
        calculateOnTapFunction: () {
          calculateOnTapFunction();
        },
      );
    }

    return bodyTemplateSideMenu();
    // return Container();
  }
}
