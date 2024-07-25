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
import 'package:business_receipt/model/admin_model/chart_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class ChartAdminSideMenu extends StatefulWidget {
  String title;
  ChartAdminSideMenu({Key? key, required this.title}) : super(key: key);

  @override
  State<ChartAdminSideMenu> createState() => _ChartAdminSideMenuState();
}



class _ChartAdminSideMenuState extends State<ChartAdminSideMenu> {
  DateTime? date = DateTime.now();
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
            Widget dateSelectedWidget() {
              void onTapUnlessDisableAndValid() async {
                final DateTime currentDate = DateTime.now();
                date = await showDatePicker(
                  context: context,
                  initialDate: date!,
                  firstDate: firstDateGlobal!,
                  lastDate: currentDate,
                );
                date ??= currentDate;
                setState(() {});
              }

              return pickDateAsyncButtonOrContainerWidget(
                level: Level.normal,
                context: context,
                dateStr: formatDateDateToStr(date: date!),
                onTapFunction: onTapUnlessDisableAndValid,
              );
            }

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
                      menuItemStrList: moneyTypeOnlyList(moneyTypeDefault: moneyType, isHasNone: true, isNotCheckDeleted: true),
                    )
                  : Container();
            }

            Widget paddingWidget({required Widget widget}) {
              return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)), child: widget);
            }

            return Column(children: [
              paddingWidget(widget: dateSelectedWidget()),
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

      void calculateOnTapFunction() {
        // ChartModel chartModel = ChartModel(
        //   chartExchange: [],
        //   chartCard: [],
        //   charExcel: [],
        //   profit: Profit(
        //     profitCardList: [],
        //     profitCardMergeList: [],
        //     profitExchangeAndCardAndExcelList: [],
        //     profitExchangeAndCardAndExcelMergeList: [],
        //     profitExchangeList: [],
        //     profitExchangeMergeList: [],
        //     profitExcelList: [],
        //     profitExcelMergeList: [],
        //   ),
        //   count: Count(
        //     countCard: CountModel(countList: []),
        //     countExcel: CountModel(countList: []),
        //     countExchange: CountModel(countList: []),
        //     countExchangeAndCardAndExcel: CountModel(countList: []),
        //   ),
        // );
        void callBack() {
          Widget calculateCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: []);
          }

          void cancelFunctionOnTap() {
            closeDialogGlobal(context: context);
          }

          actionDialogSetStateGlobal(
            dialogHeight: dialogSizeGlobal(level: Level.large),
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
          // chartModel: chartModel,
          selectedDate: date!,
          chartType: chartTypeStrList[chartTypeIndex],
          moneyType: moneyType,
        );
      }

      return BodyTemplateSideMenu(
        title: widget.title,
        inWrapWidgetList: inWrapWidgetList(),
        calculateOnTapFunction: calculateOnTapFunction,
      );
    }

    return bodyTemplateSideMenu();
    // return Container();
  }
}
