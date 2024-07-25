// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/request_api/history_request_api_env.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/cash_model.dart';
import 'package:business_receipt/model/employee_model/history_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/history_employee_side_menu.dart';
import 'package:flutter/material.dart';

class HistoryAdminSideMenu extends StatefulWidget {
  String title;
  HistoryAdminSideMenu({Key? key, required this.title}) : super(key: key);

  @override
  State<HistoryAdminSideMenu> createState() => _HistoryAdminSideMenuState();
}

class _HistoryAdminSideMenuState extends State<HistoryAdminSideMenu> {
  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      Widget? customRowBetweenHeaderAndBodyWidget() {
        Widget customTotalListWidget({required String titleStr, required List<Widget> totalListWidget}) {
          Widget titleTextWidget() {
            return Padding(
              padding: EdgeInsets.only(
                  left: paddingSizeGlobal(level: Level.mini), top: paddingSizeGlobal(level: Level.large), bottom: paddingSizeGlobal(level: Level.mini)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text(titleStr, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold))],
              ),
            );
          }

          Widget paddingTotalListWidget() {
            return Column(children: [
              for (int totalIndex = 0; totalIndex < totalListWidget.length; totalIndex++)
                Padding(
                  padding: EdgeInsets.only(
                      bottom: paddingSizeGlobal(level: Level.mini), left: paddingSizeGlobal(level: Level.mini), right: paddingSizeGlobal(level: Level.mini)),
                  child: totalListWidget[totalIndex],
                ),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleTextWidget(), paddingTotalListWidget()]);
        }

        Widget totalAndProfitListWidget() {
          Widget amountTextWidget({required int amountAndProfitIndex}) {
            Widget insideSizeBoxWidget() {
              Widget moneyTypeTextWidget() {
                final String moneyTypeStr = amountAndProfitModelGlobal[amountAndProfitIndex].moneyType;
                return Padding(
                  padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                  child: Text(moneyTypeStr, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                );
              }

              Widget scrollTextAmountWidget() {
                final String moneyTypeStr = amountAndProfitModelGlobal[amountAndProfitIndex].moneyType;
                final int place = findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!;
                final String amountStr = formatAndLimitNumberTextGlobal(
                  valueStr: amountAndProfitModelGlobal[amountAndProfitIndex].amount.toString(),
                  isRound: false,
                  isAllowZeroAtLast: false,
                  places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                );
                return scrollText(
                    textStr: "$totalsStrGlobal $amountStr $moneyTypeStr", textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.topCenter);
              }

              Widget scrollTextProfitWidget() {
                final String moneyTypeStr = amountAndProfitModelGlobal[amountAndProfitIndex].moneyType;
                final Color colorProvider = (amountAndProfitModelGlobal[amountAndProfitIndex].profit >= 0) ? positiveColorGlobal : negativeColorGlobal;
                final int place = findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!;
                final String profitStr = formatAndLimitNumberTextGlobal(
                  valueStr: amountAndProfitModelGlobal[amountAndProfitIndex].profit.toString(),
                  isRound: false,
                  isAllowZeroAtLast: false,
                  places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                );
                // return scrollText(textStr: "$profitIsStrGlobal $profitStr $moneyTypeStr", textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.topCenter);
                return SingleChildScrollView(
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("$profitIsStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                  Text("$profitStr $moneyTypeStr", style: textStyleGlobal(level: Level.normal, color: colorProvider)),
                ]));
              }

              return Column(children: [moneyTypeTextWidget(), scrollTextAmountWidget(), scrollTextProfitWidget()]);
            }

            void onTapUnlessDisable() {}
            return CustomButtonGlobal(sizeBoxWidth: sizeBoxWidthGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
          }

          return (amountAndProfitModelGlobal.isEmpty)
              ? Container()
              : customTotalListWidget(
                  titleStr: amountAndProfitStrGlobal,
                  totalListWidget: [
                    for (int amountAndProfitIndex = 0; amountAndProfitIndex < amountAndProfitModelGlobal.length; amountAndProfitIndex++)
                      amountTextWidget(amountAndProfitIndex: amountAndProfitIndex)
                  ],
                );
        }

        Widget cardStockListWidget() {
          Widget cardWidget({required int cardIndex}) {
            Widget companyNameTextWidget() {
              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: Text(cardModelListGlobal[cardIndex].cardCompanyName.text, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
              );
            }

            Widget categoryListWidget() {
              Widget categoryWidget({required int categoryIndex}) {
                final String categoryStr = cardModelListGlobal[cardIndex].categoryList[categoryIndex].category.text;
                int stockNumber = cardModelListGlobal[cardIndex].categoryList[categoryIndex].totalStock;
                // for (int mainStockIndex = 0;
                //     mainStockIndex < cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList.length;
                //     mainStockIndex++) {
                //   stockNumber = stockNumber +
                //       textEditingControllerToInt(controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList[mainStockIndex].stock)!;
                // }
                final String stockStr = formatAndLimitNumberTextGlobal(valueStr: stockNumber.toString(), isRound: false, isAllowZeroAtLast: false);
                return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text(categoryStr, style: textStyleGlobal(level: Level.normal))])),
                  Expanded(child: Text(": $stockStr", style: textStyleGlobal(level: Level.normal))),
                ]);
              }

              return Column(children: [
                for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++)
                  categoryWidget(categoryIndex: categoryIndex)
              ]);
            }

            void onTapUnlessDisable() {}
            return CustomButtonGlobal(
                sizeBoxWidth: sizeBoxWidthGlobal,
                insideSizeBoxWidget: Column(children: [companyNameTextWidget(), categoryListWidget()]),
                onTapUnlessDisable: onTapUnlessDisable);
          }

          return (cardModelListGlobal.isEmpty)
              ? Container()
              : customTotalListWidget(
                  titleStr: cardStockStrGlobal,
                  totalListWidget: [for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) cardWidget(cardIndex: cardIndex)],
                );
        }

        final bool isShowTotalList = (cardModelListGlobal.isNotEmpty || amountAndProfitModelGlobal.isNotEmpty);

        return isShowTotalList ? SingleChildScrollView(child: Column(children: [totalAndProfitListWidget(), cardStockListWidget()])) : null;
      }

      List<Widget> inWrapWidgetList() {
        Widget employeeButtonWidget({required int employeeIndex}) {
          Widget setWidthSizeBox() {
            Widget employeeNameWidget() {
              final String employeeName = profileEmployeeModelListAdminGlobal[employeeIndex].name.text;
              return scrollText(
                  textStr: employeeName, textStyle: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold), alignment: Alignment.center);
            }

            void onTapUnlessDisable() {
              // print(profileEmployeeModelListAdminGlobal[employeeIndex].firstDate);
              // historySelectedByDate(
              //     context: context,
              //     firstDate: profileEmployeeModelListAdminGlobal[employeeIndex].firstDate?? DateTime.now(),
              //     isAdminEditing: true,
              //     employeeId: profileEmployeeModelListAdminGlobal[employeeIndex].id!,
              //     isNotViewOnly: false,
              //   );
              List<HistoryModel> historyList = [];
              CashModel cashModel = CashModel(cashList: []);
              List<AmountAndProfitModel> amountAndProfitModel = [];
              List<CardModel> cardModelList = [];
              DateTime targetDate = DateTime.now();
              DateTime? firstDate;
              void callBack({required DateTime? firstDateNew, required bool isExisted}) {
                if (isExisted) {
                  firstDate = firstDateNew;
                  void cancelFunctionOnTap() {
                    closeDialogGlobal(context: context);
                    // setState(() {});
                  }

                  Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                    return HistoryEmployeeSideMenu(
                      isSelectedDateAtInit: true,
                      title: historyOptionEmployeeStrGlobal,
                      cashModel: cashModel,
                      historyList: historyList,
                      targetDate: targetDate,
                      isCurrentDate: true,
                      employeeId: profileEmployeeModelListAdminGlobal[employeeIndex].id!,
                      firstDate: firstDate,
                      amountAndProfitModel: amountAndProfitModel,
                      cardModelList: cardModelList,
                      isNotViewOnly: false,
                      isForceShowHistory: true,
                      salaryHistoryList: const [],
                      displayBusinessOptionModel: null,
                      isAdminEditing: true,
                    );
                  }

                  actionDialogSetStateGlobal(
                    dialogHeight: dialogSizeGlobal(level: Level.normal),
                    dialogWidth: dialogSizeGlobal(level: Level.large),
                    cancelFunctionOnTap: cancelFunctionOnTap,
                    context: context,
                    contentFunctionReturnWidget: contentFunctionReturnWidget,
                  );
                } else {
                  void okFunction() {
                    closeDialogGlobal(context: context);
                  }

                  okDialogGlobal(
                    context: context,
                    okFunction: okFunction,
                    titleStr: noHistoryStrGlobal,
                    subtitleStr: "$noHistoryContentStrGlobal ${formatDateDateToStr(date: targetDate)}",
                  );
                }
              }

              getHistoryByDateEmployeeGlobal(
                callBack: callBack,
                context: context,
                employeeId: profileEmployeeModelListAdminGlobal[employeeIndex].id!,
                historyList: historyList,
                targetDate: targetDate,
                cashModel: cashModel,
                amountAndProfitModel: amountAndProfitModel,
                cardModelList: cardModelList,
                salaryList: [],
                exchangeModelListEmployee: [],
                transferModelListEmployee: [],
                sellCardModelListEmployee: [],
                mainCardModelListEmployee: [],
                borrowOrLendModelListEmployee: [],
                giveMoneyToMatModelListEmployee: [],
                giveCardToMatModelListEmployee: [],
                otherInOrOutComeModelListEmployee: [],
                excelListEmployee: [],
                isNeedHistory: false,
              );
            }

            return CustomButtonGlobal(
                sizeBoxWidth: sizeBoxWidthGlobal,
                sizeBoxHeight: sizeBoxHeightGlobal,
                insideSizeBoxWidget: employeeNameWidget(),
                onTapUnlessDisable: onTapUnlessDisable);
          }

          return setWidthSizeBox();
        }

        return [
          for (int profileEmployeeListIndex = 0; profileEmployeeListIndex < profileEmployeeModelListAdminGlobal.length; profileEmployeeListIndex++)
            employeeButtonWidget(employeeIndex: profileEmployeeListIndex)
        ];
      }

      return BodyTemplateSideMenu(
        title: widget.title,
        customRowBetweenHeaderAndBodyWidget: customRowBetweenHeaderAndBodyWidget(),
        inWrapWidgetList: inWrapWidgetList(),
      );
    }

    return bodyTemplateSideMenu();
  }
}
