import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/draw_line.dart';
import 'package:business_receipt/env/function/hover_and_button.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/employee_model/card/card_main_stock_model.dart';
import 'package:business_receipt/model/employee_model/card/company_x_category_model.dart';
import 'package:business_receipt/model/employee_model/card/sell_card_model.dart';
import 'package:business_receipt/model/employee_model/excel_employee_model.dart';
import 'package:business_receipt/model/employee_model/exchange_money_model.dart';
import 'package:business_receipt/model/employee_model/give_card_to_mat_model.dart';
import 'package:business_receipt/model/employee_model/give_money_to_mat_model.dart';
import 'package:business_receipt/model/employee_model/history_model.dart';
import 'package:business_receipt/model/employee_model/other_in_or_out_come_model.dart';
import 'package:business_receipt/model/employee_model/transfer_order_model.dart';
import 'package:business_receipt/model/money_type_and_value_model.dart';
import 'package:flutter/material.dart';

Widget customInvoiceWidgetGlobal({
  required bool isForceShowNoEffect,
  required bool isDelete,
  String? overwriteId,
  DateTime? dateOld,
  required Function onTapUnlessDisable,
  required Function customHoverFunction,
  Function? onPrintFunction,
  Function? onDeleteFunction,
  required String? remark,
  String? OtherFooterShowStr,
  bool isHovering = false,
  required String invoiceIdStr,
  required String invoiceTypeStr,
  required DateTime date,
  required List<MoneyTypeAndValueModel> getFromCustomerMoneyList,
  required List<MoneyTypeAndValueModel> giveToCustomerMoneyList,
  required List<CompanyNameXCategoryXStockModel> getFromCustomerCardList,
  required List<CompanyNameXCategoryXStockModel> giveToCustomerCardList,
  required List<MoneyTypeAndValueModel> profitList,
  required List<MoneyList> moneyTotalList,
  required List<CardList> cardTotalList,
  required int index,
  required bool isAdminEditing,
  required BuildContext context,
}) {
  final bool isHasOverwriteId = (overwriteId != null);
  // final bool isDelete = (overwriteId != null);
  Widget headerWidget() {
    Widget invoiceTypeTextWidget() {
      return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text("${index + 1}. $invoiceTypeStr", style: textStyleGlobal(level: Level.mini, fontWeight: FontWeight.bold))]);
    }

    Widget invoiceIdTextWidget() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(invoiceIdStr, style: textStyleGlobal(level: Level.mini))],
      );
    }

    Widget dateTextWidget() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [Text(formatFullDateToStr(date: date), style: textStyleGlobal(level: Level.mini))],
      );
    }

    return Column(
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Expanded(child: invoiceTypeTextWidget()), Expanded(child: invoiceIdTextWidget()), Expanded(child: dateTextWidget())]),
        isHasOverwriteId
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text("$deleteInvoiceIdHistoryStrGlobal: $overwriteId", style: textStyleGlobal(level: Level.mini, fontWeight: FontWeight.bold))],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("$deleteInvoiceDateHistoryStrGlobal: ${formatFullDateToStr(date: dateOld!)}",
                          style: textStyleGlobal(level: Level.mini, fontWeight: FontWeight.bold))
                    ],
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  Widget bodyWidget() {
    bool is3OrMoreListIsNotEmpty = false;
    int countList = 0;
    if (getFromCustomerMoneyList.isNotEmpty) {
      countList++;
    }
    if (giveToCustomerMoneyList.isNotEmpty) {
      countList++;
    }
    if (getFromCustomerCardList.isNotEmpty) {
      countList++;
    }
    if (giveToCustomerCardList.isNotEmpty) {
      countList++;
    }
    is3OrMoreListIsNotEmpty = (countList >= 3);
    final Widget noEffectMoneyTextWidget = ((moneyTotalList.isEmpty && isForceShowNoEffect) || isDelete)
        ? Text("(no effect)", style: textStyleGlobal(level: Level.normal, color: Colors.grey))
        : Container();
    final Widget noEffectCardTextWidget = (((cardTotalList.isEmpty && isForceShowNoEffect) || isDelete))
        ? Text("(no effect)", style: textStyleGlobal(level: Level.normal, color: Colors.grey))
        : Container();
    Widget valueAndMoneyTypeTextWidget({required List<MoneyTypeAndValueModel> getOrGiveList, required int moneyIndex, required bool isPositiveValue}) {
      final String moneyTypeStr = getOrGiveList[moneyIndex].moneyType;
      final String valueStr =
          formatAndLimitNumberTextGlobal(valueStr: getOrGiveList[moneyIndex].value.abs().toString(), isRound: false, isAllowZeroAtLast: false);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${isPositiveValue ? "" : "-"}$valueStr $moneyTypeStr ",
                style: textStyleGlobal(
                  level: Level.normal,
                  color: isPositiveValue ? positiveColorGlobal : negativeColorGlobal,
                ),
              ),
              is3OrMoreListIsNotEmpty ? Container() : noEffectMoneyTextWidget,
            ],
          ),
          is3OrMoreListIsNotEmpty ? noEffectMoneyTextWidget : Container(),
        ],
      );
    }

    Widget cardTypeAndStockTextWidget({required List<CompanyNameXCategoryXStockModel> getOrGiveList, required int cardIndex, required bool isPositiveValue}) {
      final String companyNameStr = getOrGiveList[cardIndex].companyName;
      final String categoryStr =
          formatAndLimitNumberTextGlobal(valueStr: getOrGiveList[cardIndex].category.toString(), isRound: false, isAllowZeroAtLast: false);
      final String stockStr =
          formatAndLimitNumberTextGlobal(valueStr: (getOrGiveList[cardIndex].stock!.abs()).toString(), isRound: false, isAllowZeroAtLast: false);
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$companyNameStr x $categoryStr: ${isPositiveValue ? "" : "-"}$stockStr ",
              style: textStyleGlobal(
                level: Level.normal,
                color: isPositiveValue ? positiveColorGlobal : negativeColorGlobal,
              ),
            ),
            is3OrMoreListIsNotEmpty ? Container() : noEffectCardTextWidget,
          ],
        ),
        is3OrMoreListIsNotEmpty ? noEffectCardTextWidget : Container(),
      ]);
    }

    Widget titleTextWidget({required String titleStr}) {
      return Padding(
        padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(titleStr, style: textStyleGlobal(level: Level.mini))]),
      );
    }

    Widget getMoneyListWidget() {
      return getFromCustomerMoneyList.isEmpty
          ? Container()
          : Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleTextWidget(titleStr: getMoneyFromCustomerStrGlobal),
                  for (int moneyIndex = 0; moneyIndex < getFromCustomerMoneyList.length; moneyIndex++)
                    valueAndMoneyTypeTextWidget(moneyIndex: moneyIndex, getOrGiveList: getFromCustomerMoneyList, isPositiveValue: true),
                ]),
              ),
            );
    }

    Widget giveMoneyListWidget() {
      return giveToCustomerMoneyList.isEmpty
          ? Container()
          : Expanded(
              child: Padding(
              padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                titleTextWidget(titleStr: giveMoneyToCustomerStrGlobal),
                for (int moneyIndex = 0; moneyIndex < giveToCustomerMoneyList.length; moneyIndex++)
                  valueAndMoneyTypeTextWidget(moneyIndex: moneyIndex, getOrGiveList: giveToCustomerMoneyList, isPositiveValue: false)
              ]),
            ));
    }

    Widget getCardListWidget() {
      return getFromCustomerCardList.isEmpty
          ? Container()
          : Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleTextWidget(titleStr: getCardFromCustomerStrGlobal),
                  for (int cardIndex = 0; cardIndex < getFromCustomerCardList.length; cardIndex++)
                    cardTypeAndStockTextWidget(cardIndex: cardIndex, getOrGiveList: getFromCustomerCardList, isPositiveValue: true),
                ]),
              ),
            );
    }

    Widget giveCardListWidget() {
      return giveToCustomerCardList.isEmpty
          ? Container()
          : Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleTextWidget(titleStr: giveCardToCustomerStrGlobal),
                  for (int cardIndex = 0; cardIndex < giveToCustomerCardList.length; cardIndex++)
                    cardTypeAndStockTextWidget(cardIndex: cardIndex, getOrGiveList: giveToCustomerCardList, isPositiveValue: false),
                ]),
              ),
            );
    }

    return Row(
        crossAxisAlignment: CrossAxisAlignment.start, children: [getMoneyListWidget(), giveMoneyListWidget(), getCardListWidget(), giveCardListWidget()]);
  }

  Widget footerWidget() {
    Widget paddingBottomDrawLineWidget() {
      return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)), child: drawLineGlobal());
    }

    // Widget printAndDeleteWidget() {
    //   Widget printWidget() {
    //     return Padding(
    //       padding: EdgeInsets.only(right: ((onDeleteFunction == null) ? 0 : paddingSizeGlobal(level: Level.mini))),
    //       child: printButtonOrContainerWidget(level: Level.mini, onTapFunction: onPrintFunction),
    //     );
    //   }

    //   Widget deleteWidget() {
    //     return deleteButtonOrContainerWidget(level: Level.mini, onTapFunction: onDeleteFunction);
    //   }

    //   Widget popupMenuButtonWidget() {
    //     PopupMenuItem printPopupMenuItem() {
    //       Widget printIcon = iconGlobal(iconData: printIconGlobal, color: saveAndPrintButtonColorGlobal, level: Level.mini);
    //       Widget printText = Text(printContentButtonStrGlobal, style: textStyleGlobal(level: Level.mini, color: saveAndPrintButtonColorGlobal));

    //       return PopupMenuItem(
    //           value: 1, child: Row(children: [printIcon, Padding(padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)), child: printText)]));
    //     }

    //     PopupMenuItem deletePopupMenuItem() {
    //       Widget deleteIcon = iconGlobal(iconData: deleteIconGlobal, color: deleteButtonColorGlobal, level: Level.mini);
    //       Widget deleteText = Text(deleteGlobal, style: textStyleGlobal(level: Level.mini, color: deleteButtonColorGlobal));
    //       return PopupMenuItem(value: 2, child: Row(children: [deleteIcon, deleteText]));
    //     }

    //     return PopupMenuButton(
    //       tooltip: "",
    //       onSelected: (value) {
    //         if (value == 1) {
    //           if (onPrintFunction != null) {
    //             onPrintFunction();
    //           }
    //         } else if (value == 2) {
    //           if (onDeleteFunction != null) {
    //             onDeleteFunction();
    //           }
    //         }
    //       },
    //       itemBuilder: (ctx) => (onDeleteFunction == null) ? [printPopupMenuItem()] : [printPopupMenuItem(), deletePopupMenuItem()],
    //     );
    //   }

    //   return (isHovering && !isDelete)
    //       ? Padding(
    //           padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)),
    //           child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [printWidget(), deleteWidget()]))
    //       : !isDelete
    //           ? (onPrintFunction == null)
    //               ? Container()
    //               : popupMenuButtonWidget()
    //           : Container();
    // }

    Widget totalWidgets() {
      Widget profitListWidget() {
        String profitListStr = "$profitStrGlobal: ";
        for (int moneyIndex = 0; moneyIndex < profitList.length; moneyIndex++) {
          final String profitStr = formatAndLimitNumberTextGlobal(valueStr: profitList[moneyIndex].value.toString(), isRound: false, isAllowZeroAtLast: false);
          final String moneyTypeStr = profitList[moneyIndex].moneyType;
          final bool isLastIndex = ((profitList.length - 1) == moneyIndex);
          profitListStr = "$profitListStr $profitStr $moneyTypeStr ${isLastIndex ? "" : " | "}";
        }
        Widget profitTextColorProviderListWidget() {
          Widget profitAndProviderLineWidget({required int moneyIndex}) {
            final bool isLastIndex = ((profitList.length - 1) == moneyIndex);
            final Color colorProvider = (profitList[moneyIndex].value >= 0) ? positiveColorGlobal : negativeColorGlobal;

            final int place = findMoneyModelByMoneyType(moneyType: profitList[moneyIndex].moneyType).decimalPlace!;
            final profitStr = formatAndLimitNumberTextGlobal(
              valueStr: profitList[moneyIndex].value.toString(),
              isRound: false,
              places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
              isAllowZeroAtLast: false,
            );
            return Wrap(direction: Axis.horizontal, children: [
              Text("$profitStr ${profitList[moneyIndex].moneyType}", style: textStyleGlobal(level: Level.mini, color: colorProvider)),
              Text((isLastIndex ? "" : " | "), style: textStyleGlobal(level: Level.mini)),
            ]);
          }

          //TODO: desrease 20 elements from top and bottom to make it faster showing history
          return Wrap(direction: Axis.horizontal, children: [
            Text("$thisInvoiceProfitStrGlobal: ", style: textStyleGlobal(level: Level.mini)),
            for (int moneyIndex = 0; moneyIndex < profitList.length; moneyIndex++) profitAndProviderLineWidget(moneyIndex: moneyIndex),
          ]);
          // return SingleChildScrollView(
          //   child: Row(children: [
          //     Text("$thisInvoiceProfitStrGlobal: ", style: textStyleGlobal(level: Level.mini)),
          //     for (int moneyIndex = 0; moneyIndex < profitList.length; moneyIndex++) profitAndProviderLineWidget(moneyIndex: moneyIndex),
          //   ]),
          // );
        }

        return (profitList.isEmpty || isHasOverwriteId || isDelete) ? Container() : profitTextColorProviderListWidget();
      }

      Widget totalMoneyListWidget() {
        String totalListStr = "$totalMoneyStrGlobal: ";
        for (int moneyIndex = 0; moneyIndex < moneyTotalList.length; moneyIndex++) {
          final int place = findMoneyModelByMoneyType(moneyType: moneyTotalList[moneyIndex].moneyType).decimalPlace!;
          final String amountStr = formatAndLimitNumberTextGlobal(
            valueStr: moneyTotalList[moneyIndex].amount.toString(),
            isRound: false,
            isAllowZeroAtLast: false,
            places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
          );
          final String moneyTypeStr = moneyTotalList[moneyIndex].moneyType;
          final bool isLastIndex = ((moneyTotalList.length - 1) == moneyIndex);
          totalListStr = "$totalListStr $amountStr $moneyTypeStr ${isLastIndex ? "" : " | "}";
        }
        final bool isMoneyListEmpty = moneyTotalList.isEmpty;
        return isMoneyListEmpty ? Container() : Row(children: [Expanded(child: Text(totalListStr, style: textStyleGlobal(level: Level.mini)))]);
        // : scrollText(textStr: totalListStr, textStyle: textStyleGlobal(level: Level.mini), alignment: Alignment.centerLeft);
      }

      Widget totalCardListWidget() {
        String totalListStr = "$totalCardStrGlobal: ";
        for (int cardIndex = 0; cardIndex < cardTotalList.length; cardIndex++) {
          // final bool isLastIndex = ((cardTotalList.length - 1) == cardIndex);
          final String cardCompanyName = cardTotalList[cardIndex].cardCompanyName;
          for (int categoryIndex = 0; categoryIndex < cardTotalList[cardIndex].categoryList.length; categoryIndex++) {
            final String categoryStr = formatAndLimitNumberTextGlobal(
              valueStr: cardTotalList[cardIndex].categoryList[categoryIndex].category.toString(),
              isRound: false,
              isAllowZeroAtLast: false,
            );
            final String stockStr = formatAndLimitNumberTextGlobal(
              valueStr: cardTotalList[cardIndex].categoryList[categoryIndex].stock.toString(),
              isRound: false,
              isAllowZeroAtLast: false,
            );

            totalListStr = "$totalListStr $cardCompanyName x $categoryStr: $stockStr | "; //BUG: add more condition to show " | "
          }
        }
        totalListStr = totalListStr.substring(0, (totalListStr.length - 3));
        final bool isCardListEmpty = cardTotalList.isEmpty;
        return isCardListEmpty ? Container() : Row(children: [Expanded(child: Text(totalListStr, style: textStyleGlobal(level: Level.mini)))]);
        // : scrollText(textStr: totalListStr, textStyle: textStyleGlobal(level: Level.mini), alignment: Alignment.centerLeft);
      }

      Widget remarkWidget() {
        return ((remark == null) || remark.isEmpty)
            ? Container()
            : Row(children: [Expanded(child: Text("$remarkStrGlobal: ${remark.replaceAll("|", "\n")}", style: textStyleGlobal(level: Level.mini)))]);
      }

      Widget giveOrGetWidget() {
        return ((OtherFooterShowStr == null) || OtherFooterShowStr.isEmpty)
            ? Container()
            : Row(children: [Expanded(child: Text(OtherFooterShowStr, style: textStyleGlobal(level: Level.mini)))]);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [profitListWidget(), totalMoneyListWidget(), totalCardListWidget(), giveOrGetWidget(), remarkWidget()],
      );
    }

    return Column(children: [
      paddingBottomDrawLineWidget(),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: totalWidgets()),
        isAdminEditing
            ? Container()
            : printAndDeleteWidgetGlobal(
                context: context,
                isDelete: isDelete,
                isHovering: isHovering,
                onDeleteFunction: onDeleteFunction,
                onPrintFunction: onPrintFunction,
              ),
      ]),
    ]);
  }

  return CustomButtonGlobal(
    isDisable: isDelete,
    sizeBoxWidth: dialogSizeGlobal(level: Level.mini),
    insideSizeBoxWidget: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [headerWidget(), bodyWidget(), footerWidget()]),
    onTapUnlessDisable: onTapUnlessDisable,
    customHoverFunction: customHoverFunction,
  );
}

void addUniqueByMoneyType({required String moneyType, required double value, required List<MoneyTypeAndValueModel> moneyTypeAndValueList}) {
  final int matchMoneyTypeIndex = moneyTypeAndValueList.indexWhere((element) => (element.moneyType == moneyType));
  final bool isMatchMoneyType = (matchMoneyTypeIndex != -1);
  if (isMatchMoneyType) {
    // moneyTypeAndValueList[matchMoneyTypeIndex].value = moneyTypeAndValueList[matchMoneyTypeIndex].value + value;
    moneyTypeAndValueList[matchMoneyTypeIndex].value = double.parse(formatAndLimitNumberTextGlobal(
      valueStr: (moneyTypeAndValueList[matchMoneyTypeIndex].value + value).toString(),
      isRound: false,
      isAddComma: false,
      isAllowZeroAtLast: false,
    ));
  } else {
    moneyTypeAndValueList.add(MoneyTypeAndValueModel(value: value, moneyType: moneyType));
  }
}

void exchangeToMerge({
  required ExchangeMoneyModel exchangeMoneyModel,
  required List<MoneyTypeAndValueModel> getFromCustomerMoneyList,
  required List<MoneyTypeAndValueModel> giveToCustomerMoneyList,
  required List<MoneyTypeAndValueModel> profitList,
}) {
  for (int exchangeIndex = 0; exchangeIndex < exchangeMoneyModel.exchangeList.length; exchangeIndex++) {
    final bool isBuyRate = exchangeMoneyModel.exchangeList[exchangeIndex].rate!.isBuyRate!;
    final List<String> rateType = exchangeMoneyModel.exchangeList[exchangeIndex].rate!.rateType;
    final double getFromCustomerNumber = textEditingControllerToDouble(controller: exchangeMoneyModel.exchangeList[exchangeIndex].getMoney)!;
    final String getFromCustomerMoneyTypeStr = isBuyRate ? rateType.first : rateType.last;
    final double giveToCustomerNumber = textEditingControllerToDouble(controller: exchangeMoneyModel.exchangeList[exchangeIndex].giveMoney)!;
    final String giveToCustomerMoneyTypeStr = isBuyRate ? rateType.last : rateType.first;

    // final String profitMoneyTypeStr =
    final double profitNumber = exchangeMoneyModel.exchangeList[exchangeIndex].rate!.profit ?? 0;
    addUniqueByMoneyType(value: profitNumber, moneyType: rateType.last, moneyTypeAndValueList: profitList);
    // final int matchProfitIndex = profitList.indexWhere((element) => (element.moneyType == rateType.last));
    // final bool isMatchProfit = (matchProfitIndex != -1);
    // if (isMatchProfit) {
    //   final double profitMergeNumber = getFromCustomerMoneyList[matchProfitIndex].value;
    //   profitList[matchProfitIndex].value = profitNumber + profitMergeNumber;
    // } else {
    //   profitList.add(MoneyTypeAndValueModel(value: profitNumber, moneyType: rateType.last));
    // }

    addUniqueByMoneyType(value: getFromCustomerNumber, moneyType: getFromCustomerMoneyTypeStr, moneyTypeAndValueList: getFromCustomerMoneyList);
    // final int matchGetFromCustomerIndex = getFromCustomerMoneyList.indexWhere((element) => (element.moneyType == getFromCustomerMoneyTypeStr));
    // final bool isMatchGetFromCustomer = (matchGetFromCustomerIndex != -1);
    // if (isMatchGetFromCustomer) {
    //   final double getFromCustomerMergeNumber = getFromCustomerMoneyList[matchGetFromCustomerIndex].value;

    //   getFromCustomerMoneyList[matchGetFromCustomerIndex].value = getFromCustomerNumber + getFromCustomerMergeNumber;
    // } else {
    //   getFromCustomerMoneyList.add(MoneyTypeAndValueModel(value: getFromCustomerNumber, moneyType: getFromCustomerMoneyTypeStr));
    // }

    addUniqueByMoneyType(value: giveToCustomerNumber, moneyType: giveToCustomerMoneyTypeStr, moneyTypeAndValueList: giveToCustomerMoneyList);
    // final int matchGiveToCustomerIndex = giveToCustomerMoneyList.indexWhere((element) => (element.moneyType == giveToCustomerMoneyTypeStr));
    // final bool isMatchGiveToCustomer = (matchGiveToCustomerIndex != -1);
    // if (isMatchGiveToCustomer) {
    //   final double getFromCustomerMergeNumber = giveToCustomerMoneyList[matchGiveToCustomerIndex].value;
    //   giveToCustomerMoneyList[matchGiveToCustomerIndex].value = giveToCustomerNumber + getFromCustomerMergeNumber;
    // } else {
    //   giveToCustomerMoneyList.add(MoneyTypeAndValueModel(value: giveToCustomerNumber, moneyType: giveToCustomerMoneyTypeStr));
    // }
  }
}

void addCardStockToMerge({
  required InformationAndCardMainStockModel cardMainStockModel,
  required List<MoneyTypeAndValueModel> getFromCustomerMoneyList,
  required List<MoneyTypeAndValueModel> giveToCustomerMoneyList,
  required List<CompanyNameXCategoryXStockModel> getFromCustomerCardList,
  required List<CompanyNameXCategoryXStockModel> giveToCustomerCardList,
}) {
  final String companyName = cardMainStockModel.cardCompanyName;
  final double category = cardMainStockModel.category;
  final int stock = cardMainStockModel.mainPrice.maxStock;
  final String moneyType = cardMainStockModel.mainPrice.moneyType!;
  final double price = textEditingControllerToDouble(controller: cardMainStockModel.mainPrice.price)!;
  getFromCustomerCardList.add(CompanyNameXCategoryXStockModel(companyName: companyName, category: category, stock: stock));
  giveToCustomerMoneyList.add(MoneyTypeAndValueModel(value: price * stock, moneyType: moneyType));
}

void sellCardToMerge({
  // required int invoiceIndex,
  required SellCardModel sellCardModel,
  required List<MoneyTypeAndValueModel> getFromCustomerMoneyList,
  required List<MoneyTypeAndValueModel> giveToCustomerMoneyList,
  required List<CompanyNameXCategoryXStockModel> getFromCustomerCardList,
  required List<CompanyNameXCategoryXStockModel> giveToCustomerCardList,
  required List<MoneyTypeAndValueModel> profitList,
}) {
  final bool isSeparate = (sellCardModel.mergeCalculate == null);
  void getProfitAndGetFromCustomerWidget({required List<CustomerMoneyListSellCardModel> customerMoneyList}) {
    for (int getMoneyIndex = 0; getMoneyIndex < customerMoneyList.length; getMoneyIndex++) {
      if (customerMoneyList[getMoneyIndex].getMoney != null && customerMoneyList[getMoneyIndex].giveMoney != null) {
        final String moneyTypeStr = customerMoneyList[getMoneyIndex].moneyType!;

        final double getMoneyNumber = double.parse(
            formatAndLimitNumberTextGlobal(valueStr: customerMoneyList[getMoneyIndex].getMoney, isRound: false, isAddComma: false, isAllowZeroAtLast: false));
        addUniqueByMoneyType(value: getMoneyNumber, moneyType: moneyTypeStr, moneyTypeAndValueList: getFromCustomerMoneyList);

        final double giveMoneyNumber = customerMoneyList[getMoneyIndex].giveMoney!;
        final bool isHasChange = (giveMoneyNumber < 0);
        if (isHasChange) {
          addUniqueByMoneyType(value: -1 * giveMoneyNumber, moneyType: moneyTypeStr, moneyTypeAndValueList: giveToCustomerMoneyList);
        }

        final RateForCalculateModel? rate = customerMoneyList[getMoneyIndex].rate;
        final bool isHasRate = (rate != null);
        if (isHasRate) {
          addUniqueByMoneyType(value: rate.profit!, moneyType: rate.rateType.last, moneyTypeAndValueList: profitList);
        }
      }
    }
  }

  if (!isSeparate) {
    getProfitAndGetFromCustomerWidget(customerMoneyList: sellCardModel.mergeCalculate!.customerMoneyList);
  }
  for (int moneyIndex = 0; moneyIndex < sellCardModel.moneyTypeList.length; moneyIndex++) {
    getProfitAndGetFromCustomerWidget(customerMoneyList: sellCardModel.moneyTypeList[moneyIndex].calculate.customerMoneyList);

    final RateForCalculateModel? rate = sellCardModel.moneyTypeList[moneyIndex].rate;
    final bool isHasRate = (rate != null);
    if (isHasRate) {
      addUniqueByMoneyType(value: rate.profit!, moneyType: rate.rateType.last, moneyTypeAndValueList: profitList);
    }
    final String moneyTypeStr = sellCardModel.moneyTypeList[moneyIndex].calculate.moneyType;
    for (int cardIndex = 0; cardIndex < sellCardModel.moneyTypeList[moneyIndex].cardList.length; cardIndex++) {
      final double profitNumber = sellCardModel.moneyTypeList[moneyIndex].cardList[cardIndex].profit;
      addUniqueByMoneyType(value: profitNumber, moneyType: moneyTypeStr, moneyTypeAndValueList: profitList);
      for (int mainIndex = 0; mainIndex < sellCardModel.moneyTypeList[moneyIndex].cardList[cardIndex].mainPriceQtyList.length; mainIndex++) {
        RateForCalculateModel? rate = sellCardModel.moneyTypeList[moneyIndex].cardList[cardIndex].mainPriceQtyList[mainIndex].rate;
        if (rate != null) {
          addUniqueByMoneyType(value: rate.profit!, moneyType: rate.rateType.last, moneyTypeAndValueList: profitList);
        }
      }
      final String companyName = sellCardModel.moneyTypeList[moneyIndex].cardList[cardIndex].cardCompanyName;
      final double category = sellCardModel.moneyTypeList[moneyIndex].cardList[cardIndex].category;
      final int qty = sellCardModel.moneyTypeList[moneyIndex].cardList[cardIndex].qty;
      giveToCustomerCardList.add(CompanyNameXCategoryXStockModel(companyName: companyName, category: category, stock: qty));
    }
  }
}

void borrowOrLendToMerge({
  // required int invoiceIndex,
  required MoneyCustomerModel moneyCustomerModel,
  required List<MoneyTypeAndValueModel> getFromCustomerMoneyList,
  required List<MoneyTypeAndValueModel> giveToCustomerMoneyList,
}) {
  final double valueStr = textEditingControllerToDouble(controller: moneyCustomerModel.value)!;
  final String moneyTypeStr = moneyCustomerModel.moneyType!;
  final isPositive = (valueStr > 0);
  if (isPositive) {
    getFromCustomerMoneyList.add(MoneyTypeAndValueModel(value: valueStr, moneyType: moneyTypeStr));
  } else {
    giveToCustomerMoneyList.add(MoneyTypeAndValueModel(value: valueStr, moneyType: moneyTypeStr));
  }
}

void giveMoneyToMatToMerge({
  // required int invoiceIndex,
  required GiveMoneyToMatModel giveMoneyToMatModel,
  required List<MoneyTypeAndValueModel> getFromCustomerMoneyList,
  required List<MoneyTypeAndValueModel> giveToCustomerMoneyList,
}) {
  final double valueStr = textEditingControllerToDouble(controller: giveMoneyToMatModel.value)!;
  final String moneyTypeStr = giveMoneyToMatModel.moneyType!;
  if (giveMoneyToMatModel.isGetFromMat) {
    getFromCustomerMoneyList.add(MoneyTypeAndValueModel(value: valueStr, moneyType: moneyTypeStr));
  } else {
    giveToCustomerMoneyList.add(MoneyTypeAndValueModel(value: valueStr, moneyType: moneyTypeStr));
  }
}

void giveCardToMatToMerge({
  required GiveCardToMatModel giveCardToMatModel,
  required List<CompanyNameXCategoryXStockModel> getFromCustomerCardList,
  required List<CompanyNameXCategoryXStockModel> giveToCustomerCardList,
}) {
  final String companyName = giveCardToMatModel.cardCompanyName!;
  final double category = giveCardToMatModel.category!;
  final int stock = textEditingControllerToInt(controller: giveCardToMatModel.qty)!;
  if (giveCardToMatModel.isGetFromMat) {
    getFromCustomerCardList.add(CompanyNameXCategoryXStockModel(companyName: companyName, category: category, stock: stock));
  } else {
    giveToCustomerCardList.add(CompanyNameXCategoryXStockModel(companyName: companyName, category: category, stock: stock));
  }
}

void otherInOrOutComeToMerge({
  required OtherInOrOutComeModel otherInOrOutComeModel,
  required List<MoneyTypeAndValueModel> getFromCustomerMoneyList,
  required List<MoneyTypeAndValueModel> giveToCustomerMoneyList,
}) {
  final double valueStr = textEditingControllerToDouble(controller: otherInOrOutComeModel.value)!;
  final String moneyTypeStr = otherInOrOutComeModel.moneyType!;
  final isPositive = (valueStr > 0);
  if (isPositive) {
    getFromCustomerMoneyList.add(MoneyTypeAndValueModel(value: valueStr, moneyType: moneyTypeStr));
  } else {
    giveToCustomerMoneyList.add(MoneyTypeAndValueModel(value: valueStr, moneyType: moneyTypeStr));
  }
}

void transferToMerge({
  required TransferOrder transferMoneyModel,
  required List<MoneyTypeAndValueModel> getFromCustomerMoneyList,
  required List<MoneyTypeAndValueModel> giveToCustomerMoneyList,
  required List<MoneyTypeAndValueModel> profitList,
}) {
  List<MoneyListTransfer> mergeOrSeparateMoneyList =
      (transferMoneyModel.mergeMoneyList.isEmpty) ? transferMoneyModel.moneyList : transferMoneyModel.mergeMoneyList;
  for (int moneyIndex = 0; moneyIndex < mergeOrSeparateMoneyList.length; moneyIndex++) {
    final String moneyTypeStr = mergeOrSeparateMoneyList[moneyIndex].moneyType!;
    final double feeNumber = textEditingControllerToDouble(controller: mergeOrSeparateMoneyList[moneyIndex].discountFee)!;
    final double valueNumber = textEditingControllerToDouble(controller: mergeOrSeparateMoneyList[moneyIndex].value)!;
    final double profitNumber = mergeOrSeparateMoneyList[moneyIndex].profit;
    addUniqueByMoneyType(value: profitNumber, moneyType: moneyTypeStr, moneyTypeAndValueList: profitList);
    addUniqueByMoneyType(value: feeNumber, moneyType: moneyTypeStr, moneyTypeAndValueList: getFromCustomerMoneyList);
    if (transferMoneyModel.isTransfer) {
      addUniqueByMoneyType(value: valueNumber, moneyType: moneyTypeStr, moneyTypeAndValueList: getFromCustomerMoneyList);
    } else {
      addUniqueByMoneyType(value: valueNumber, moneyType: moneyTypeStr, moneyTypeAndValueList: giveToCustomerMoneyList);
    }
  }
}

void excelToMerge({
  // required int invoiceIndex,
  required ExcelDataList excelData,
  required List<MoneyTypeAndValueModel> getFromCustomerMoneyList,
  required List<MoneyTypeAndValueModel> giveToCustomerMoneyList,
  required List<MoneyTypeAndValueModel> profitList,
}) {
  final double valueNumber = excelData.amount;
  final double profitNumber = excelData.profit;
  final String moneyTypeStr = excelData.moneyType;
  final isPositive = (valueNumber > 0);
  if (isPositive) {
    getFromCustomerMoneyList.add(MoneyTypeAndValueModel(value: valueNumber, moneyType: moneyTypeStr));
  } else {
    giveToCustomerMoneyList.add(MoneyTypeAndValueModel(value: valueNumber, moneyType: moneyTypeStr));
  }

  addUniqueByMoneyType(value: profitNumber, moneyType: moneyTypeStr, moneyTypeAndValueList: profitList);
}
