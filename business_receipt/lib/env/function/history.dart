// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:business_receipt/env/function/active_log.dart';
import 'package:business_receipt/env/function/card.dart';
import 'package:business_receipt/env/function/customer.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/merge_value_from_model.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/refresh_page_env.dart';
import 'package:business_receipt/env/function/request_api/history_request_api_env.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/invoice_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_or_admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/text_limit.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/card/card_combine_model.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/admin_model/currency_model.dart';
import 'package:business_receipt/model/admin_model/customer_information_category.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/admin_model/excel_admin_model.dart';
import 'package:business_receipt/model/admin_model/mission_model.dart';
import 'package:business_receipt/model/admin_model/print_model.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/admin_model/transfer_model.dart';
import 'package:business_receipt/model/admin_or_employee_list_asking_for_change.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/card/card_main_stock_model.dart';
import 'package:business_receipt/model/employee_model/card/company_x_category_model.dart';
import 'package:business_receipt/model/employee_model/card/sell_card_model.dart';
import 'package:business_receipt/model/employee_model/cash_model.dart';
import 'package:business_receipt/model/employee_model/excel_employee_model.dart';
import 'package:business_receipt/model/employee_model/exchange_money_model.dart';
import 'package:business_receipt/model/employee_model/give_card_to_mat_model.dart';
import 'package:business_receipt/model/employee_model/give_money_to_mat_model.dart';
import 'package:business_receipt/model/employee_model/history_model.dart';
import 'package:business_receipt/model/employee_model/other_in_or_out_come_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:business_receipt/model/employee_model/salary_model.dart';
import 'package:business_receipt/model/employee_model/transfer_order_model.dart';
import 'package:business_receipt/model/money_type_and_value_model.dart';
import 'package:business_receipt/state/side_menu/set_up_print_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HistoryElement extends StatefulWidget {
  HistoryModel? historyModel;
  int index;

  bool isCurrentDate;
  bool isForceShowNoEffect;
  bool isAdminEditing;

  ExchangeMoneyModel? exchangeMoneyModel;
  InformationAndCardMainStockModel? informationAndCardMainStockModel;
  SellCardModel? sellCardModel;
  MoneyCustomerModel? borrowingOrLending;
  GiveMoneyToMatModel? giveMoneyToMatModel;
  GiveCardToMatModel? giveCardToMatModel;
  OtherInOrOutComeModel? otherInOrOutComeModel;
  TransferOrder? transferMoneyModel;
  ExcelDataList? excelData;

  Function setStateOutsider;
  HistoryElement({
    super.key,
    required this.isForceShowNoEffect,
    required this.isAdminEditing,
    this.isCurrentDate = true,
    this.historyModel,
    this.exchangeMoneyModel,
    this.transferMoneyModel,
    this.informationAndCardMainStockModel,
    this.sellCardModel,
    this.borrowingOrLending,
    this.giveMoneyToMatModel,
    this.giveCardToMatModel,
    this.otherInOrOutComeModel,
    // this.borrowingOrLending,
    this.excelData,
    required this.setStateOutsider,
    required this.index,
  });

  @override
  State<HistoryElement> createState() => _HistoryElementState();
}

Widget rateAndProfitWidget({required RateForCalculateModel rate, required String getFromStr, required String giveToStr, required String spaceStr}) {
  // final RateForCalculateModel rate = widget.exchangeMoneyModel!.exchangeList[exchangeIndex].rate!;
  final bool isBuyRate = rate.isBuyRate!;
  final List<String> rateType = rate.rateType;
  final String getMoneyTypeStr = isBuyRate ? rateType[0] : rateType[1];
  final String giveMoneyTypeStr = isBuyRate ? rateType[1] : rateType[0];
  // final String getFromStr = widget.exchangeMoneyModel!.exchangeList[exchangeIndex].getMoney.text;
  // final String giveToStr = widget.exchangeMoneyModel!.exchangeList[exchangeIndex].giveMoney.text;
  final String rateValueStr = formatAndLimitNumberTextGlobal(valueStr: rate.value.toString(), isRound: false);
  final String rateDiscountStr = rate.discountValue.text;
  final double rateDiscountNumber = textEditingControllerToDouble(controller: rate.discountValue)!;
  final String operatorStr = isBuyRate ? multiplyNumberStrGlobal : divideNumberStrGlobal;
  final String profitStr = formatAndLimitNumberTextGlobal(valueStr: rate.profit.toString(), isRound: false);
  final List<LeftListAnalysisExchangeModel> usedModelList = rate.usedModelList;
  Widget usedModelElementWidget({required int usedIndex}) {
    final String getFromStr = formatAndLimitNumberTextGlobal(valueStr: usedModelList[usedIndex].getMoney.toString(), isRound: false);
    final String getMoneyTypeStr = isBuyRate ? rateType[1] : rateType[0];
    final String giveToStr = formatAndLimitNumberTextGlobal(valueStr: usedModelList[usedIndex].giveMoney.abs().toString(), isRound: false);
    final String giveMoneyTypeStr = isBuyRate ? rateType[0] : rateType[1];
    final String rateValueStr = formatAndLimitNumberTextGlobal(valueStr: usedModelList[usedIndex].rateValue.toString(), isRound: false);
    final String operatorStr = !isBuyRate ? multiplyNumberStrGlobal : divideNumberStrGlobal;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          Text("${spaceStr}Previous Rate: ", style: textStyleGlobal(level: Level.normal)),
          Text("$getFromStr $getMoneyTypeStr", style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal)),
          Text(" $operatorStr ", style: textStyleGlobal(level: Level.normal)),
          Text(rateValueStr, style: textStyleGlobal(level: Level.normal)),
          Text(" $equalStrGlobal ", style: textStyleGlobal(level: Level.normal)),
          Text("$giveToStr $giveMoneyTypeStr", style: textStyleGlobal(level: Level.normal, color: negativeColorGlobal)),
        ]),
      ),
    ]);
  }

  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    // Text(
    //   "${isBuyRate ? buyTitleStrGlobal : sellTitleStrGlobal} ${rateType[0]} -> ${rateType[1]}",
    //   style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
    // ),
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        Text("${spaceStr}Current Rate: ", style: textStyleGlobal(level: Level.normal)),
        Text("$getFromStr $getMoneyTypeStr", style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal)),
        Text(" $operatorStr ", style: textStyleGlobal(level: Level.normal)),
        (rateDiscountNumber == rate.value)
            ? Text(rateDiscountStr, style: textStyleGlobal(level: Level.normal))
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(rateValueStr, style: TextStyle(fontSize: textSizeGlobal(level: Level.mini), decoration: TextDecoration.lineThrough)),
                Text(rateDiscountStr, style: textStyleGlobal(level: Level.mini)),
              ]),
        Text(" $equalStrGlobal ", style: textStyleGlobal(level: Level.normal)),
        Text("$giveToStr $giveMoneyTypeStr", style: textStyleGlobal(level: Level.normal, color: negativeColorGlobal)),
      ]),
    ),
    for (int usedIndex = 0; usedIndex < usedModelList.length; usedIndex++) usedModelElementWidget(usedIndex: usedIndex),
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        Text("${spaceStr}Profit Rate: ", style: textStyleGlobal(level: Level.normal)),
        Text(
          "$profitStr ${rateType[1]}",
          style: textStyleGlobal(level: Level.normal, color: (rate.profit! >= 0) ? positiveColorGlobal : negativeColorGlobal),
        ),
      ]),
    ),
  ]);
}

class _HistoryElementState extends State<HistoryElement> {
  bool isHoveringOutsider = false;
  @override
  Widget build(BuildContext context) {
    // void onTapUnlessDisable() {}
    void customHoverFunction({required bool isHovering}) {
      isHoveringOutsider = isHovering;
      if (mounted) {
        setState(() {});
      }
    }

    if (widget.exchangeMoneyModel != null) {
      List<MoneyTypeAndValueModel> getFromCustomerMoneyList = [];
      List<MoneyTypeAndValueModel> giveToCustomerMoneyList = [];
      List<MoneyTypeAndValueModel> profitList = [];
      exchangeToMerge(
        exchangeMoneyModel: widget.exchangeMoneyModel!,
        getFromCustomerMoneyList: getFromCustomerMoneyList,
        giveToCustomerMoneyList: giveToCustomerMoneyList,
        profitList: profitList,
      );

      void onDeleteFunction() {
        void deleteDialog() {
          void okFunction() {
            void callBack() {
              // widget.exchangeMoneyModel!.isDelete = true;
              refreshPageGlobal();
              // widget.setStateOutsider();
            }

            closeDialogGlobal(context: context);
            deleteInvoiceEmployee(
              callBack: callBack,
              context: context,
              invoiceId: widget.exchangeMoneyModel!.id!,
              date: widget.exchangeMoneyModel!.date!,
              invoiceType: exchangeQueryGlobal,
              remark: widget.exchangeMoneyModel!.remark.text,
            );
          }

          void cancelFunction() {
            widget.setStateOutsider();
          }

          confirmationWithTextFieldDialogGlobal(
            subtitleStr: deleteConfirmGlobal,
            context: context,
            titleStr: "${widget.index + 1}. $exchangeTitleGlobal",
            remarkController: widget.exchangeMoneyModel!.remark,
            okFunction: okFunction,
            cancelFunction: cancelFunction,
            init: invalidInvoiceGlobal,
          );
        }

        askingForChangeDialogGlobal(context: context, allowFunction: deleteDialog, editSettingTypeEnum: EditSettingTypeEnum.delete);
      }

      void onPrintFunction() {
        // await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
        // loadingDialogGlobal(context: context, loadingTitle: printingExchangeInvoiceStrGlobal);
        printExchangeMoneyInvoice(exchangeModel: widget.exchangeMoneyModel!, context: context);
        // closeDialogGlobal(context: context);
      }

      Widget invoiceBoxWidget({required Function? onTapUnlessDisable}) {
        return customInvoiceWidgetGlobal(
          context: context,
          isForceShowNoEffect: widget.isForceShowNoEffect,
          remark: widget.exchangeMoneyModel!.remark.text,
          dateOld: widget.exchangeMoneyModel!.dateOld,
          date: widget.exchangeMoneyModel!.date!,
          invoiceTypeStr: exchangeTitleGlobal,
          getFromCustomerMoneyList: getFromCustomerMoneyList,
          giveToCustomerMoneyList: giveToCustomerMoneyList,
          profitList: profitList,
          getFromCustomerCardList: [],
          giveToCustomerCardList: [],
          invoiceIdStr: widget.exchangeMoneyModel!.id!,
          moneyTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.moneyList,
          cardTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.cardList,
          isHovering: isHoveringOutsider,
          onDeleteFunction: widget.isCurrentDate ? onDeleteFunction : null,
          onPrintFunction: !widget.isAdminEditing ? onPrintFunction : null,
          customHoverFunction: customHoverFunction,
          onTapUnlessDisable: onTapUnlessDisable ?? () {},
          isDelete: widget.exchangeMoneyModel!.isDelete,
          overwriteId: widget.exchangeMoneyModel!.overwriteOnId,
          index: widget.index,
          isAdminEditing: widget.isAdminEditing,
        );
      }

      void onTapUnlessDisable() {
        Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleTextWidget() {
            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("$exchangeTitleGlobal Detail", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))], //TODO: change this
              ),
            );
          }

          Widget invoiceCalculateWidget() {
            Widget exchangeElementCalculateWidget({required int exchangeIndex}) {
              final RateForCalculateModel rateModel = widget.exchangeMoneyModel!.exchangeList[exchangeIndex].rate!;
              final bool isBuyRate = rateModel.isBuyRate!;
              final List<String> rateType = rateModel.rateType;
              final String getFromStr = widget.exchangeMoneyModel!.exchangeList[exchangeIndex].getMoney.text;
              final String giveToStr = widget.exchangeMoneyModel!.exchangeList[exchangeIndex].giveMoney.text;
              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "${isBuyRate ? buyTitleStrGlobal : sellTitleStrGlobal} ${rateType[0]} -> ${rateType[1]}",
                    style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                  ),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(children: [
                  //     Text("   Current Rate: ", style: textStyleGlobal(level: Level.normal)),
                  //     Text("$getFromStr $getMoneyTypeStr", style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal)),
                  //     Text(" $operatorStr ", style: textStyleGlobal(level: Level.normal)),
                  //     (rateDiscountNumber == rateModel.value)
                  //         ? Text(rateDiscountStr, style: textStyleGlobal(level: Level.normal))
                  //         : Column(children: [
                  //             Text(rateValueStr, style: TextStyle(fontSize: textSizeGlobal(level: Level.mini), decoration: TextDecoration.lineThrough)),
                  //             Text(rateDiscountStr, style: textStyleGlobal(level: Level.mini)),
                  //           ]),
                  //     Text(" $equalStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                  //     Text("$giveToStr $giveMoneyTypeStr", style: textStyleGlobal(level: Level.normal, color: negativeColorGlobal)),
                  //   ]),
                  // ),
                  // for (int usedIndex = 0; usedIndex < usedModelList.length; usedIndex++) usedModelElementWidget(usedIndex: usedIndex),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(children: [
                  //     Text("   Profit: ", style: textStyleGlobal(level: Level.normal)),
                  //     Text(
                  //       "$profitStr ${rateType[1]}",
                  //       style: textStyleGlobal(level: Level.normal, color: (rateModel.profit! >= 0) ? positiveColorGlobal : negativeColorGlobal),
                  //     ),
                  //   ]),
                  // ),
                  rateAndProfitWidget(rate: rateModel, getFromStr: getFromStr, giveToStr: giveToStr, spaceStr: "   "),
                ]),
              );
            }

            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: invoiceBoxWidget(onTapUnlessDisable: null),
              ),
              for (int exchangeIndex = 0; exchangeIndex < widget.exchangeMoneyModel!.exchangeList.length; exchangeIndex++)
                exchangeElementCalculateWidget(exchangeIndex: exchangeIndex),
              activeLogListWidget(activeLogModelList: widget.exchangeMoneyModel!.activeLogModelList),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleTextWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                  child: invoiceCalculateWidget(),
                ),
              ),
            ),
          ]);
        }

        void cancelFunctionOnTap() {
          closeDialogGlobal(context: context);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.05,
          dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.05,
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      return invoiceBoxWidget(onTapUnlessDisable: onTapUnlessDisable);
    } else if (widget.informationAndCardMainStockModel != null) {
      List<MoneyTypeAndValueModel> getFromCustomerMoneyList = [];
      List<MoneyTypeAndValueModel> giveToCustomerMoneyList = [];
      List<CompanyNameXCategoryXStockModel> getFromCustomerCardList = [];
      List<CompanyNameXCategoryXStockModel> giveToCustomerCardList = [];
      addCardStockToMerge(
        cardMainStockModel: widget.informationAndCardMainStockModel!,
        getFromCustomerMoneyList: getFromCustomerMoneyList,
        giveToCustomerMoneyList: giveToCustomerMoneyList,
        getFromCustomerCardList: getFromCustomerCardList,
        giveToCustomerCardList: giveToCustomerCardList,
      );
      void onDeleteFunction() {
        askingForChangeDialogGlobal(
          context: context,
          allowFunction: () {
            void okFunction() {
              void callBack() {
                // widget.informationAndCardMainStockModel!.mainPrice.isDelete = true;
                // widget.setStateOutsider();
                refreshPageGlobal();
              }

              closeDialogGlobal(context: context);
              deleteInvoiceEmployee(
                callBack: callBack,
                context: context,
                invoiceId: widget.informationAndCardMainStockModel!.mainPrice.id!,
                date: widget.informationAndCardMainStockModel!.mainPrice.date!,
                invoiceType: cardMainStockQueryGlobal,
                cardCompanyNameId: widget.informationAndCardMainStockModel!.cardCompanyNameId,
                categoryId: widget.informationAndCardMainStockModel!.categoryId,
                remark: widget.informationAndCardMainStockModel!.mainPrice.remark.text,
              );
            }

            void cancelFunction() {
              widget.setStateOutsider();
            }

            confirmationWithTextFieldDialogGlobal(
              subtitleStr: deleteConfirmGlobal,
              context: context,
              titleStr: "${widget.index + 1}. $cardMainStockTitleGlobal",
              remarkController: widget.informationAndCardMainStockModel!.mainPrice.remark,
              okFunction: okFunction,
              cancelFunction: cancelFunction,
              init: invalidInvoiceGlobal,
            );
          },
          editSettingTypeEnum: EditSettingTypeEnum.delete,
        );
      }

      void onPrintFunction() {
        printCardStockInvoice(cardStockModel: widget.informationAndCardMainStockModel!, context: context);
      }

      Widget invoiceBoxWidget({required Function? onTapUnlessDisable}) {
        return customInvoiceWidgetGlobal(
          context: context,
          isForceShowNoEffect: widget.isForceShowNoEffect,
          remark: widget.informationAndCardMainStockModel!.mainPrice.remark.text,
          dateOld: widget.informationAndCardMainStockModel!.mainPrice.dateOld,
          date: widget.informationAndCardMainStockModel!.mainPrice.date!,
          invoiceTypeStr: cardMainStockTitleGlobal,
          getFromCustomerMoneyList: getFromCustomerMoneyList,
          giveToCustomerMoneyList: giveToCustomerMoneyList,
          getFromCustomerCardList: getFromCustomerCardList,
          giveToCustomerCardList: giveToCustomerCardList,
          profitList: [],
          invoiceIdStr: widget.informationAndCardMainStockModel!.mainPrice.id!,
          moneyTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.moneyList,
          cardTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.cardList,
          isHovering: isHoveringOutsider,
          onDeleteFunction: widget.isCurrentDate ? onDeleteFunction : null,
          onPrintFunction: !widget.isAdminEditing ? onPrintFunction : null,
          customHoverFunction: customHoverFunction,
          onTapUnlessDisable: onTapUnlessDisable ?? () {},
          isDelete: widget.informationAndCardMainStockModel!.mainPrice.isDelete,
          overwriteId: widget.informationAndCardMainStockModel!.mainPrice.overwriteOnId,
          index: widget.index,
          isAdminEditing: widget.isAdminEditing,
        );
      }

      void onTapUnlessDisable() {
        Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleTextWidget() {
            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("$cardMainStockTitleGlobal Detail", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))
                ], //TODO: change this
              ),
            );
          }

          Widget invoiceCalculateWidget() {
            final String companyStr = widget.informationAndCardMainStockModel!.cardCompanyName;
            final String categoryStr = formatAndLimitNumberTextGlobal(valueStr: widget.informationAndCardMainStockModel!.category.toString(), isRound: false);

            final String companyIdStr = widget.informationAndCardMainStockModel!.cardCompanyNameId;
            final String categoryIdStr = widget.informationAndCardMainStockModel!.categoryId;

            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: invoiceBoxWidget(onTapUnlessDisable: null),
              ),
              cardStockWidget(
                companyStr: companyStr,
                categoryStr: categoryStr,
                companyIdStr: companyIdStr,
                categoryIdStr: categoryIdStr,
                mainPriceModel: widget.informationAndCardMainStockModel!.mainPrice,
              ),
              activeLogListWidget(activeLogModelList: widget.informationAndCardMainStockModel!.mainPrice.activeLogModelList),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleTextWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                  child: invoiceCalculateWidget(),
                ),
              ),
            ),
          ]);
        }

        void cancelFunctionOnTap() {
          closeDialogGlobal(context: context);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.05,
          dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.05,
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      return invoiceBoxWidget(onTapUnlessDisable: onTapUnlessDisable);
      // return customInvoiceWidgetGlobal(
      //   isForceShowNoEffect: widget.isForceShowNoEffect,
      //   remark: widget.informationAndCardMainStockModel!.mainPrice.remark.text,
      //   dateOld: widget.informationAndCardMainStockModel!.mainPrice.dateOld,
      //   date: widget.informationAndCardMainStockModel!.mainPrice.date!,
      //   invoiceTypeStr: cardMainStockTitleGlobal,
      //   getFromCustomerMoneyList: getFromCustomerMoneyList,
      //   giveToCustomerMoneyList: giveToCustomerMoneyList,
      //   getFromCustomerCardList: getFromCustomerCardList,
      //   giveToCustomerCardList: giveToCustomerCardList,
      //   profitList: [],
      //   invoiceIdStr: widget.informationAndCardMainStockModel!.mainPrice.id!,
      //   moneyTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.moneyList,
      //   cardTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.cardList,
      //   isHovering: isHoveringOutsider,
      //   onDeleteFunction: widget.isCurrentDate ? onDeleteFunction : null,
      //   onPrintFunction: !widget.isAdminEditing ? onPrintFunction : null,
      //   customHoverFunction: customHoverFunction,
      //   onTapUnlessDisable: onTapUnlessDisable,
      //   isDelete: widget.informationAndCardMainStockModel!.mainPrice.isDelete,
      //   overwriteId: widget.informationAndCardMainStockModel!.mainPrice.overwriteOnId,
      //   index: widget.index,
      //   isAdminEditing: widget.isAdminEditing,
      // );
    } else if (widget.sellCardModel != null) {
      List<MoneyTypeAndValueModel> getFromCustomerMoneyList = [];
      List<MoneyTypeAndValueModel> giveToCustomerMoneyList = [];
      List<CompanyNameXCategoryXStockModel> getFromCustomerCardList = [];
      List<CompanyNameXCategoryXStockModel> giveToCustomerCardList = [];
      List<MoneyTypeAndValueModel> profitList = [];
      sellCardToMerge(
        sellCardModel: widget.sellCardModel!,
        getFromCustomerMoneyList: getFromCustomerMoneyList,
        giveToCustomerMoneyList: giveToCustomerMoneyList,
        getFromCustomerCardList: getFromCustomerCardList,
        giveToCustomerCardList: giveToCustomerCardList,
        profitList: profitList,
      );

      void onDeleteFunction() {
        askingForChangeDialogGlobal(
          context: context,
          allowFunction: () {
            void okFunction() {
              void callBack() {
                // widget.sellCardModel!.isDelete = true;
                // widget.setStateOutsider();
                refreshPageGlobal();
              }

              closeDialogGlobal(context: context);

              deleteInvoiceEmployee(
                callBack: callBack,
                context: context,
                invoiceId: widget.sellCardModel!.id!,
                date: widget.sellCardModel!.date!,
                invoiceType: sellCardQueryGlobal,
                remark: widget.sellCardModel!.remark.text,
              );
            }

            void cancelFunction() {
              widget.setStateOutsider();
            }

            confirmationWithTextFieldDialogGlobal(
              subtitleStr: deleteConfirmGlobal,
              context: context,
              titleStr: "${widget.index + 1}. $sellCardTitleGlobal",
              remarkController: widget.sellCardModel!.remark,
              okFunction: okFunction,
              cancelFunction: cancelFunction,
              init: invalidInvoiceGlobal,
            );
          },
          editSettingTypeEnum: EditSettingTypeEnum.delete,
        );
      }

      void onPrintFunction() {
        printSellCardInvoice(context: context, sellCardModel: widget.sellCardModel!);
      }

      Widget invoiceBoxWidget({required Function? onTapUnlessDisable}) {
        return customInvoiceWidgetGlobal(
          context: context,
          isForceShowNoEffect: widget.isForceShowNoEffect,
          remark: widget.sellCardModel!.remark.text,
          dateOld: widget.sellCardModel!.dateOld,
          date: widget.sellCardModel!.date!,
          invoiceTypeStr: sellCardTitleGlobal,
          getFromCustomerMoneyList: getFromCustomerMoneyList,
          giveToCustomerMoneyList: giveToCustomerMoneyList,
          getFromCustomerCardList: getFromCustomerCardList,
          giveToCustomerCardList: giveToCustomerCardList,
          profitList: profitList,
          invoiceIdStr: widget.sellCardModel!.id!,
          moneyTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.moneyList,
          cardTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.cardList,
          isHovering: isHoveringOutsider,
          onDeleteFunction: widget.isCurrentDate ? onDeleteFunction : null,
          onPrintFunction: !widget.isAdminEditing ? onPrintFunction : null,
          customHoverFunction: customHoverFunction,
          onTapUnlessDisable: onTapUnlessDisable ?? () {},
          isDelete: widget.sellCardModel!.isDelete,
          overwriteId: widget.sellCardModel!.overwriteOnId,
          index: widget.index,
          isAdminEditing: widget.isAdminEditing,
        );
      }

      void onTapUnlessDisable() {
        Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleTextWidget() {
            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("$sellCardTitleGlobal Detail", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))], //TODO: change this
              ),
            );
          }

          Widget calculateWidget() {
            Widget getAndGiveMoneyWidget({
              required CalculateSellCardModel? calculate,
              RateForCalculateModel? mergeRate,
              String? mergeMoneyType,
              required String spaceStr,
            }) {
              if (calculate == null) {
                return Container();
              } else {
                final String totalTypeMoneyStr = calculate.moneyType;
                final double totalMoneyNumber = calculate.totalMoney;
                final String totalMoneyStr = formatAndLimitNumberTextGlobal(valueStr: totalMoneyNumber.toString(), isRound: false);
                if (calculate.customerMoneyList.isNotEmpty) {
                  Widget rateCondition() {
                    Widget customerElementWidget({required int customerIndex}) {
                      final double getMoneyNumber = textEditingControllerToDouble(controller: calculate.customerMoneyList[customerIndex].getMoneyController)!;
                      final String getMoneyStr = formatAndLimitNumberTextGlobal(valueStr: getMoneyNumber.toString(), isRound: false);
                      final double giveMoneyNumber = calculate.customerMoneyList[customerIndex].giveMoney!;
                      final String moneyTypeStr = calculate.customerMoneyList[customerIndex].moneyType!;
                      final RateForCalculateModel? rate = calculate.customerMoneyList[customerIndex].rate;
                      if (rate == null) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            Text("$spaceStr   Get From Customer: ", style: textStyleGlobal(level: Level.normal)),
                            Text("$getMoneyStr $moneyTypeStr", style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal)),
                          ]),
                        );
                      } else {
                        final String giveFromTopStr = (customerIndex == 0)
                            ? formatAndLimitNumberTextGlobal(valueStr: totalMoneyNumber.toString(), isRound: false)
                            : formatAndLimitNumberTextGlobal(valueStr: calculate.customerMoneyList[customerIndex - 1].giveMoney!.toString(), isRound: false);

                        // final int getFromPlace = findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!;
                        final String getFromTopStr = formatAndLimitNumberTextGlobal(
                          valueStr: (getMoneyNumber + giveMoneyNumber).toString(),
                          isRound: false,
                          // places: (getFromPlace >= 0) ? (getFromPlace * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                        );
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          rateAndProfitWidget(rate: rate, getFromStr: getFromTopStr, giveToStr: giveFromTopStr, spaceStr: "      "),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              Text("$spaceStr   Get From Customer: ", style: textStyleGlobal(level: Level.normal)),
                              Text("$getMoneyStr $moneyTypeStr", style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal)),
                            ]),
                          ),
                        ]);
                      }
                    }

                    final String giveMoneyLastStr = formatAndLimitNumberTextGlobal(
                      valueStr: calculate.customerMoneyList.last.giveMoney!.toString(),
                      isRound: false,
                    );
                    final String moneyTypeLastStr = calculate.customerMoneyList.last.moneyType!;
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      for (int customerIndex = 0; customerIndex < calculate.customerMoneyList.length; customerIndex++)
                        customerElementWidget(customerIndex: customerIndex),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Text("$spaceStr   Give To Customer: ", style: textStyleGlobal(level: Level.normal)),
                          Text("$giveMoneyLastStr $moneyTypeLastStr", style: textStyleGlobal(level: Level.normal, color: negativeColorGlobal)),
                        ]),
                      ),
                    ]);
                  }

                  return Padding(
                    padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "${spaceStr}Get And Give Money",
                        style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Text("$spaceStr   Total Card Price: ", style: textStyleGlobal(level: Level.normal)),
                          Text("$totalMoneyStr $totalTypeMoneyStr", style: textStyleGlobal(level: Level.normal)),
                        ]),
                      ),
                      rateCondition(),
                    ]),
                  );
                } else {
                  Widget rateCondition() {
                    if (mergeRate == null) {
                      return Container();
                    } else {
                      final double discountRateNumber = textEditingControllerToDouble(controller: mergeRate.discountValue)!;
                      final int totalPlace = findMoneyModelByMoneyType(moneyType: mergeMoneyType!).decimalPlace!;
                      final String totalMoneyResultStr = formatAndLimitNumberTextGlobal(
                        valueStr:
                            !mergeRate.isBuyRate! ? (totalMoneyNumber * discountRateNumber).toString() : (totalMoneyNumber / discountRateNumber).toString(),
                        isRound: true,
                        places: totalPlace,
                      );
                      return rateAndProfitWidget(rate: mergeRate, getFromStr: totalMoneyResultStr, giveToStr: totalMoneyStr, spaceStr: "$spaceStr   ");
                    }
                  }

                  return Padding(
                    padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("${spaceStr}Merge Money By $mergeMoneyType", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Text("$spaceStr   Sub Total Card Price: ", style: textStyleGlobal(level: Level.normal)),
                          Text("$totalMoneyStr $totalTypeMoneyStr", style: textStyleGlobal(level: Level.normal)),
                        ]),
                      ),
                      rateCondition(),
                    ]),
                  );
                }
              }
            }

            Widget elementMoneyTypeCalculateWidget({required int moneyTypeIndex}) {
              final String moneyTypeStr = widget.sellCardModel!.moneyTypeList[moneyTypeIndex].calculate.moneyType;
              Widget elementCardCalculateWidget({required int cardIndex}) {
                final String companyNameStr = widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList[cardIndex].cardCompanyName;
                final String cardCompanyNameIdStr = widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList[cardIndex].cardCompanyNameId;
                final String categoryStr = formatAndLimitNumberTextGlobal(
                  valueStr: widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList[cardIndex].category.toString(),
                  isRound: false,
                );
                final String categoryIdStr = widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList[cardIndex].categoryId;
                final int qtyNumber = widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList[cardIndex].qty;
                final String qtyStr = formatAndLimitNumberTextGlobal(valueStr: qtyNumber.toString(), isRound: false);
                final double sellPriceNumber = widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList[cardIndex].sellPrice.value;
                final double sellPriceDiscountNumber = double.parse(formatTextToNumberStrGlobal(
                  valueStr: widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList[cardIndex].sellPrice.discountValue,
                ));
                final String sellPriceStr = formatAndLimitNumberTextGlobal(valueStr: sellPriceNumber.toString(), isRound: false);
                final String sellPriceDiscountStr = formatAndLimitNumberTextGlobal(valueStr: sellPriceDiscountNumber.toString(), isRound: false);
                final String sellPriceMoneyTypeStr = widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList[cardIndex].sellPrice.moneyType;
                final int place = findMoneyModelByMoneyType(moneyType: sellPriceMoneyTypeStr).decimalPlace!;
                final String qtyMultiSellPriceStr = formatAndLimitNumberTextGlobal(
                  valueStr: (qtyNumber * sellPriceDiscountNumber).toString(),
                  isRound: true,
                  places: place,
                );

                Widget mainPriceElementWidget({required int mainIndex}) {
                  MainPriceQty mainPriceQty = widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList[mainIndex];
                  final int subQtyNumber = mainPriceQty.qty;
                  final String subQtyStr = formatAndLimitNumberTextGlobal(valueStr: subQtyNumber.toString(), isRound: false);
                  final double mainPriceNumber = double.parse(formatTextToNumberStrGlobal(valueStr: mainPriceQty.mainPrice.price.text));
                  final String mainPriceStr = formatAndLimitNumberTextGlobal(valueStr: mainPriceNumber.toString(), isRound: false);
                  final String mainPriceMoneyTypeStr = mainPriceQty.mainPrice.moneyType!;
                  Widget rateWidget() {
                    final RateForCalculateModel? rate = mainPriceQty.rate;
                    if (rate == null) {
                      final int place = findMoneyModelByMoneyType(moneyType: sellPriceMoneyTypeStr).decimalPlace!;
                      final double subSellPriceXQtyNumber = double.parse(formatAndLimitNumberTextGlobal(
                        valueStr: (subQtyNumber * sellPriceDiscountNumber).toString(),
                        isRound: true,
                        isAddComma: false,
                        places: place,
                      ));
                      final double subProfitMainCardNumber = subSellPriceXQtyNumber - (subQtyNumber * mainPriceNumber);
                      final String subProfitMainCardStr = formatAndLimitNumberTextGlobal(valueStr: subProfitMainCardNumber.toString(), isRound: false);

                      // final double profitCardNumber = widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList[cardIndex].profit;
                      // final String profitCardStr = formatAndLimitNumberTextGlobal(valueStr: profitCardNumber.toString(), isRound: false);
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Text("         Profit Card: ", style: textStyleGlobal(level: Level.normal)),
                          Text(
                            "$subProfitMainCardStr $sellPriceMoneyTypeStr",
                            style: textStyleGlobal(level: Level.normal, color: (subProfitMainCardNumber >= 0) ? positiveColorGlobal : negativeColorGlobal),
                          ),
                        ]),
                      );
                    } else {
                      // final String operatorStr = rate.isBuyRate! ? multiplyNumberStrGlobal : divideNumberStrGlobal;
                      // final String rateValueStr = formatAndLimitNumberTextGlobal(valueStr: rate.value.toString(), isRound: false);
                      final double rateDiscountNumber = textEditingControllerToDouble(controller: rate.discountValue)!;

                      final int ratePlace = findMoneyModelByMoneyType(moneyType: sellPriceMoneyTypeStr).decimalPlace!;
                      final double rateConvertMainToSellNumber =
                          !rate.isBuyRate! ? (subQtyNumber * mainPriceNumber * rateDiscountNumber) : (subQtyNumber * mainPriceNumber / rateDiscountNumber);

                      final String rateConvertMainToSellStr = formatAndLimitNumberTextGlobal(
                        valueStr: rateConvertMainToSellNumber.toString(),
                        isRound: false,
                        places: (ratePlace >= 0) ? (ratePlace * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                      );
                      final int qtyMultiMainPricePlace = findMoneyModelByMoneyType(moneyType: mainPriceMoneyTypeStr).decimalPlace!;
                      final String qtyMultiMainPriceStr = formatAndLimitNumberTextGlobal(
                        valueStr: (subQtyNumber * mainPriceNumber).toString(),
                        isRound: false,
                        places: (qtyMultiMainPricePlace >= 0)
                            ? (qtyMultiMainPricePlace * multiPlaceOfProfitNumberWhenPlaceMoreThan0)
                            : placeOfProfitNumberWhenPlaceMoreThan0,
                      );

                      // final List<LeftListAnalysisExchangeModel> usedModelList = rate.usedModelList;
                      // Widget usedModelElementWidget({required int usedIndex}) {
                      //   final String getFromStr = formatAndLimitNumberTextGlobal(valueStr: usedModelList[usedIndex].getMoney.toString(), isRound: false);
                      //   final String getMoneyTypeStr = rate.isBuyRate! ? rate.rateType[1] : rate.rateType[0];
                      //   final String giveToStr = formatAndLimitNumberTextGlobal(valueStr: usedModelList[usedIndex].giveMoney.toString(), isRound: false);
                      //   final String giveMoneyTypeStr = rate.isBuyRate! ? rate.rateType[0] : rate.rateType[1];
                      //   final String rateValueStr = formatAndLimitNumberTextGlobal(valueStr: usedModelList[usedIndex].rateValue.toString(), isRound: false);
                      //   return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      //     SingleChildScrollView(
                      //       scrollDirection: Axis.horizontal,
                      //       child: Row(children: [
                      //         Text("         Previous Rate: ", style: textStyleGlobal(level: Level.normal)),
                      //         Text("$getFromStr $getMoneyTypeStr", style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal)),
                      //         Text(" $operatorStr ", style: textStyleGlobal(level: Level.normal)),
                      //         Text(rateValueStr, style: textStyleGlobal(level: Level.normal)),
                      //         Text(" $equalStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                      //         Text("$giveToStr $giveMoneyTypeStr", style: textStyleGlobal(level: Level.normal, color: negativeColorGlobal)),
                      //       ]),
                      //     ),
                      //   ]);
                      // }

                      final int place = findMoneyModelByMoneyType(moneyType: sellPriceMoneyTypeStr).decimalPlace!;
                      final double subSellPriceXQtyNumber = double.parse(formatAndLimitNumberTextGlobal(
                        valueStr: (subQtyNumber * sellPriceDiscountNumber).toString(),
                        isRound: true,
                        isAddComma: false,
                        places: place,
                      ));
                      final double subProfitMainCardNumber = subSellPriceXQtyNumber - rateConvertMainToSellNumber;
                      final String subProfitMainCardStr = formatAndLimitNumberTextGlobal(valueStr: subProfitMainCardNumber.toString(), isRound: false);
                      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        // SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal,
                        //   child: Row(children: [
                        //     Text("         Convert Rate: ", style: textStyleGlobal(level: Level.normal)),
                        //     Text("$rateConvertMainToSellStr $sellPriceMoneyTypeStr", style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal)),
                        //     Text(" $operatorStr ", style: textStyleGlobal(level: Level.normal)),
                        //     (rateDiscountNumber == rate.value)
                        //         ? Text(rate.discountValue.text, style: textStyleGlobal(level: Level.normal))
                        //         : Column(children: [
                        //             Text(rateValueStr, style: TextStyle(fontSize: textSizeGlobal(level: Level.mini), decoration: TextDecoration.lineThrough)),
                        //             Text(rate.discountValue.text, style: textStyleGlobal(level: Level.mini)),
                        //           ]),
                        //     Text(" $equalStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                        //     Text("$qtyMultiMainPriceStr $mainPriceMoneyTypeStr", style: textStyleGlobal(level: Level.normal, color: negativeColorGlobal)),
                        //   ]),
                        // ),
                        // for (int usedIndex = 0; usedIndex < usedModelList.length; usedIndex++) usedModelElementWidget(usedIndex: usedIndex),
                        rateAndProfitWidget(rate: rate, getFromStr: rateConvertMainToSellStr, giveToStr: qtyMultiMainPriceStr, spaceStr: "         "),
                        // SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal,
                        //   child: Row(children: [
                        //     Text("         Profit Rate: ", style: textStyleGlobal(level: Level.normal)),
                        //     Text(
                        //       "$profitRateStr ${rate.rateType[1]}",
                        //       style: textStyleGlobal(level: Level.normal, color: (rate.profit! >= 0) ? positiveColorGlobal : negativeColorGlobal),
                        //     ),
                        //   ]),
                        // ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            Text("         Profit Card: ", style: textStyleGlobal(level: Level.normal)),
                            Text(
                              "$subProfitMainCardStr $sellPriceMoneyTypeStr",
                              style: textStyleGlobal(level: Level.normal, color: (subProfitMainCardNumber >= 0) ? positiveColorGlobal : negativeColorGlobal),
                            ),
                          ]),
                        ),
                      ]);
                    }
                  }

                  final RateForCalculateModel? rate = mainPriceQty.rate;
                  final int place = (rate == null) ? findMoneyModelByMoneyType(moneyType: mainPriceMoneyTypeStr).decimalPlace! : maxPlaceNumberGlobal;
                  final String qtyMultiMainPriceConditionPlaceStr =
                      formatAndLimitNumberTextGlobal(valueStr: (subQtyNumber * mainPriceNumber).toString(), isRound: false, places: place);
                  final String stockStr = mainPriceQty.mainPrice.stock.text;
                  final String maxStockStr = formatAndLimitNumberTextGlobal(valueStr: mainPriceQty.mainPrice.maxStock.toString(), isRound: false);
                  final String mainIndexStr = mainPriceQty.mainPrice.id!;
                  final String stockDateStr = formatFullDateToStr(date: mainPriceQty.mainPrice.date!);

                  String percentageRateFirstStr = "";
                  if (mainPriceQty.mainPrice.rateList.isNotEmpty) {
                    if (mainPriceQty.mainPrice.rateList.length == 1) {
                      percentageRateFirstStr = "100";
                    } else {
                      final int stockNumber = textEditingControllerToInt(controller: mainPriceQty.mainPrice.stock)!;
                      int totalQty = (stockNumber == 0) ? mainPriceQty.qty.abs() : stockNumber;
                      for (int subMainIndex = (mainIndex + 1);
                          subMainIndex < widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList.length;
                          subMainIndex++) {
                        MainPriceQty subMainPriceQty = widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList[subMainIndex];
                        if (subMainPriceQty.mainPrice.id == mainPriceQty.mainPrice.id) {
                          final int subStockNumber = textEditingControllerToInt(controller: subMainPriceQty.mainPrice.stock)!;
                          totalQty = totalQty + ((subStockNumber == 0) ? subMainPriceQty.qty.abs() : subStockNumber);
                        } else {
                          break;
                        }
                      }

                      final double percentageQty = (totalQty / mainPriceQty.mainPrice.maxStock * 100);
                      double totalPercentage = 0;
                      for (int rateIndex = (mainPriceQty.mainPrice.rateList.length - 1); rateIndex >= 0; rateIndex--) {
                        totalPercentage = totalPercentage + textEditingControllerToDouble(controller: mainPriceQty.mainPrice.rateList[rateIndex].percentage)!;
                        if (percentageQty <= totalPercentage) {
                          percentageRateFirstStr = mainPriceQty.mainPrice.rateList[rateIndex].percentage.text;
                          break;
                        }
                        // if(percentageQty >= double.parse(mainPriceQty.mainPrice.rateList[rateIndex].percentage.text)) {
                        //   percentageRateFirstStr = mainPriceQty.mainPrice.rateList[rateIndex].percentage.text;
                        //   break;
                        // }
                      }
                    }
                    percentageRateFirstStr = " | $percentageRateFirstStr %";
                  }
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    scrollText(
                      textStr: "      Stock: ($stockStr/$maxStockStr$percentageRateFirstStr) ($mainIndexStr)",
                      textStyle: textStyleGlobal(level: Level.normal),
                      alignment: Alignment.centerLeft,
                    ),
                    scrollText(
                      textStr: "         Stock Date: $stockDateStr",
                      textStyle: textStyleGlobal(level: Level.normal),
                      alignment: Alignment.centerLeft,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        Text("         Stock Price: ", style: textStyleGlobal(level: Level.normal)),
                        Text("$subQtyStr card", style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal)),
                        Text(" $multiplyNumberStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                        Text(mainPriceStr, style: textStyleGlobal(level: Level.normal)),
                        Text(" $equalStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                        Text(
                          "$qtyMultiMainPriceConditionPlaceStr $mainPriceMoneyTypeStr",
                          style: textStyleGlobal(level: Level.normal, color: negativeColorGlobal),
                        ),
                      ]),
                    ),
                    rateWidget(),
                  ]);
                }

                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      Text(
                        "   $companyNameStr x $categoryStr ($cardCompanyNameIdStr x $categoryIdStr)",
                        style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      Text("      Sell Price: ", style: textStyleGlobal(level: Level.normal)),
                      Text("$qtyStr card", style: textStyleGlobal(level: Level.normal, color: negativeColorGlobal)),
                      Text(" $multiplyNumberStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                      (sellPriceDiscountNumber == sellPriceNumber)
                          ? Text(sellPriceDiscountStr, style: textStyleGlobal(level: Level.normal))
                          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(sellPriceStr, style: TextStyle(fontSize: textSizeGlobal(level: Level.mini), decoration: TextDecoration.lineThrough)),
                              Text(sellPriceDiscountStr, style: textStyleGlobal(level: Level.mini)),
                            ]),
                      Text(" $equalStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                      Text("$qtyMultiSellPriceStr $sellPriceMoneyTypeStr", style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal)),
                    ]),
                  ),
                  for (int mainIndex = 0;
                      mainIndex < widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList.length;
                      mainIndex++)
                    mainPriceElementWidget(mainIndex: mainIndex),
                  getAndGiveMoneyWidget(
                    calculate: widget.sellCardModel!.moneyTypeList[moneyTypeIndex].calculate,
                    mergeRate: widget.sellCardModel!.moneyTypeList[moneyTypeIndex].rate,
                    mergeMoneyType: (widget.sellCardModel!.mergeCalculate == null) ? null : widget.sellCardModel!.mergeCalculate!.moneyType,
                    spaceStr: "   ",
                  ),
                ]);
              }

              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Calculate by $moneyTypeStr", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                  for (int cardIndex = 0; cardIndex < widget.sellCardModel!.moneyTypeList[moneyTypeIndex].cardList.length; cardIndex++)
                    elementCardCalculateWidget(cardIndex: cardIndex),
                ]),
              );
            }

            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: invoiceBoxWidget(onTapUnlessDisable: null),
              ),
              getAndGiveMoneyWidget(calculate: widget.sellCardModel!.mergeCalculate, spaceStr: ""),
              for (int moneyTypeIndex = 0; moneyTypeIndex < widget.sellCardModel!.moneyTypeList.length; moneyTypeIndex++)
                elementMoneyTypeCalculateWidget(moneyTypeIndex: moneyTypeIndex),
              activeLogListWidget(activeLogModelList: widget.sellCardModel!.activeLogModelList),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleTextWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                  child: calculateWidget(),
                ),
              ),
            ),
          ]);
        }

        void cancelFunctionOnTap() {
          closeDialogGlobal(context: context);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.05,
          dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.05,
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      return invoiceBoxWidget(onTapUnlessDisable: onTapUnlessDisable);
    } else if (widget.borrowingOrLending != null) {
      List<MoneyTypeAndValueModel> getFromCustomerMoneyList = [];
      List<MoneyTypeAndValueModel> giveToCustomerMoneyList = [];
      borrowOrLendToMerge(
        moneyCustomerModel: widget.borrowingOrLending!,
        getFromCustomerMoneyList: getFromCustomerMoneyList,
        giveToCustomerMoneyList: giveToCustomerMoneyList,
      );
      void onPrintFunction() {
        printBorrowOrLendInvoice(context: context, borrowOrLend: widget.borrowingOrLending!);
      }

      Widget invoiceBoxWidget({required Function? onTapUnlessDisable}) {
        return customInvoiceWidgetGlobal(
          context: context,
          isForceShowNoEffect: widget.isForceShowNoEffect,
          remark: widget.borrowingOrLending!.remark.text,
          dateOld: null,
          date: widget.borrowingOrLending!.date!,
          invoiceTypeStr: (textEditingControllerToDouble(controller: widget.borrowingOrLending!.value)! >= 0) ? lendTitleGlobal : borrowTitleGlobal,
          getFromCustomerMoneyList: getFromCustomerMoneyList,
          giveToCustomerMoneyList: giveToCustomerMoneyList,
          getFromCustomerCardList: [],
          giveToCustomerCardList: [],
          profitList: [],
          invoiceIdStr: widget.borrowingOrLending!.id!,
          moneyTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.moneyList,
          cardTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.cardList,
          isHovering: isHoveringOutsider,
          // onDeleteFunction: onDeleteFunction,
          onPrintFunction: !widget.isAdminEditing ? onPrintFunction : null,
          customHoverFunction: customHoverFunction,
          onTapUnlessDisable: onTapUnlessDisable ?? () {},
          isDelete: widget.borrowingOrLending!.isDelete,
          overwriteId: widget.borrowingOrLending!.overwriteOnId, index: widget.index,
          isAdminEditing: widget.isAdminEditing,
        );
      }

      void onTapUnlessDisable() {
        Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleTextWidget() {
            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("$cardMainStockTitleGlobal Detail", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))
                ], //TODO: change this
              ),
            );
          }

          Widget invoiceCalculateWidget() {
            final String customerIdStr = widget.borrowingOrLending!.customerId!;
            final String customerNameStr = widget.borrowingOrLending!.customerName!;
            final String moneyTypeStr = widget.borrowingOrLending!.moneyType!;
            final double valueNumber = textEditingControllerToDouble(controller: widget.borrowingOrLending!.value)!;
            final bool isBorrow = (valueNumber < 0);
            final String valueStr = formatAndLimitNumberTextGlobal(valueStr: valueNumber.toString(), isRound: false);
            final String employeeNameStr = widget.borrowingOrLending!.employeeName!;
            final String employeeIdStr = widget.borrowingOrLending!.employeeId!;
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: invoiceBoxWidget(onTapUnlessDisable: null),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Text("${isBorrow ? "Losing Money To" : "Increasing Money By"} $customerNameStr ($customerIdStr)",
                      style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold))
                ]),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [Text("   Employee Name: $employeeNameStr ($employeeIdStr)", style: textStyleGlobal(level: Level.normal))]),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Text("   Amount: ", style: textStyleGlobal(level: Level.normal)),
                  Text(
                    "$valueStr $moneyTypeStr",
                    style: textStyleGlobal(level: Level.normal, color: isBorrow ? negativeColorGlobal : positiveColorGlobal),
                  ),
                ]),
              ),
              activeLogListWidget(activeLogModelList: widget.borrowingOrLending!.activeLogModelList),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleTextWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                  child: invoiceCalculateWidget(),
                ),
              ),
            ),
          ]);
        }

        void cancelFunctionOnTap() {
          closeDialogGlobal(context: context);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.05,
          dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.05,
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      return invoiceBoxWidget(onTapUnlessDisable: onTapUnlessDisable);
    } else if (widget.giveMoneyToMatModel != null) {
      List<MoneyTypeAndValueModel> getFromCustomerMoneyList = [];
      List<MoneyTypeAndValueModel> giveToCustomerMoneyList = [];
      giveMoneyToMatToMerge(
        giveMoneyToMatModel: widget.giveMoneyToMatModel!,
        getFromCustomerMoneyList: getFromCustomerMoneyList,
        giveToCustomerMoneyList: giveToCustomerMoneyList,
      );

      final String giverStr = widget.giveMoneyToMatModel!.isGetFromMat ? widget.giveMoneyToMatModel!.employeeName! : profileModelEmployeeGlobal!.name.text;
      final String getterStr = widget.giveMoneyToMatModel!.isGetFromMat ? profileModelEmployeeGlobal!.name.text : widget.giveMoneyToMatModel!.employeeName!;

      void onPrintFunction() {
        printGiveMoneyToMatInvoice(context: context, giveMoneyToMatModel: widget.giveMoneyToMatModel!);
      }

      Widget invoiceBoxWidget({required Function? onTapUnlessDisable}) {
        return customInvoiceWidgetGlobal(
          context: context,
          isForceShowNoEffect: widget.isForceShowNoEffect,
          remark: widget.giveMoneyToMatModel!.remark.text,
          dateOld: null,
          date: widget.giveMoneyToMatModel!.date!,
          invoiceTypeStr: widget.giveMoneyToMatModel!.isGetFromMat ? getMoneyFromMatTitleGlobal : giveMoneyToMatTitleGlobal,
          getFromCustomerMoneyList: getFromCustomerMoneyList,
          giveToCustomerMoneyList: giveToCustomerMoneyList,
          getFromCustomerCardList: [],
          giveToCustomerCardList: [],
          profitList: [],
          invoiceIdStr: widget.giveMoneyToMatModel!.id!,
          moneyTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.moneyList,
          cardTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.cardList,
          isHovering: isHoveringOutsider,
          onPrintFunction: !widget.isAdminEditing ? onPrintFunction : null,
          customHoverFunction: customHoverFunction,
          onTapUnlessDisable: onTapUnlessDisable ?? () {},
          isDelete: widget.giveMoneyToMatModel!.isDelete,
          overwriteId: widget.giveMoneyToMatModel!.overwriteOnId,
          OtherFooterShowStr: "$giverStr -> $getterStr",
          index: widget.index,
          isAdminEditing: widget.isAdminEditing,
        );
      }

      void onTapUnlessDisable() {
        Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleTextWidget() {
            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("$cardMainStockTitleGlobal Detail", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))
                ], //TODO: change this
              ),
            );
          }

          Widget invoiceCalculateWidget() {
            final String giverIdStr = widget.giveMoneyToMatModel!.isGetFromMat ? widget.giveMoneyToMatModel!.employeeId! : profileModelEmployeeGlobal!.id!;
            final String getterIdStr = widget.giveMoneyToMatModel!.isGetFromMat ? profileModelEmployeeGlobal!.id! : widget.giveMoneyToMatModel!.employeeId!;

            final bool isGetFromMat = widget.giveMoneyToMatModel!.isGetFromMat;
            final String moneyTypeStr = widget.giveMoneyToMatModel!.moneyType!;
            final String valueStr = formatAndLimitNumberTextGlobal(valueStr: widget.giveMoneyToMatModel!.value.text.toString(), isRound: false);
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: invoiceBoxWidget(onTapUnlessDisable: null),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Text("$giverStr -> $getterStr ($giverIdStr -> $getterIdStr)", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                ]),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Text("   Amount: ", style: textStyleGlobal(level: Level.normal)),
                  Text("$valueStr $moneyTypeStr", style: textStyleGlobal(level: Level.normal, color: isGetFromMat ? positiveColorGlobal : negativeColorGlobal)),
                ]),
              ),
              activeLogListWidget(activeLogModelList: widget.giveMoneyToMatModel!.activeLogModelList),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleTextWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                  child: invoiceCalculateWidget(),
                ),
              ),
            ),
          ]);
        }

        void cancelFunctionOnTap() {
          closeDialogGlobal(context: context);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.05,
          dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.05,
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      return invoiceBoxWidget(onTapUnlessDisable: onTapUnlessDisable);
    } else if (widget.giveCardToMatModel != null) {
      List<CompanyNameXCategoryXStockModel> getFromCustomerCardList = [];
      List<CompanyNameXCategoryXStockModel> giveToCustomerCardList = [];
      giveCardToMatToMerge(
        giveCardToMatModel: widget.giveCardToMatModel!,
        getFromCustomerCardList: getFromCustomerCardList,
        giveToCustomerCardList: giveToCustomerCardList,
      );

      void onPrintFunction() {
        printGiveCardToMatInvoice(context: context, giveCardToMatModel: widget.giveCardToMatModel!);
      }

      final String giverStr = widget.giveCardToMatModel!.isGetFromMat ? widget.giveCardToMatModel!.employeeName! : profileModelEmployeeGlobal!.name.text;
      final String getterStr = widget.giveCardToMatModel!.isGetFromMat ? profileModelEmployeeGlobal!.name.text : widget.giveCardToMatModel!.employeeName!;

      Widget invoiceBoxWidget({required Function? onTapUnlessDisable}) {
        return customInvoiceWidgetGlobal(
          context: context,
          isForceShowNoEffect: widget.isForceShowNoEffect,
          remark: widget.giveCardToMatModel!.remark.text,
          dateOld: null,
          date: widget.giveCardToMatModel!.date!,
          invoiceTypeStr: widget.giveCardToMatModel!.isGetFromMat ? getCardFromMatTitleGlobal : giveCardToMatTitleGlobal,
          getFromCustomerMoneyList: [],
          giveToCustomerMoneyList: [],
          getFromCustomerCardList: getFromCustomerCardList,
          giveToCustomerCardList: giveToCustomerCardList,
          profitList: [],
          invoiceIdStr: widget.giveCardToMatModel!.id!,
          moneyTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.moneyList,
          cardTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.cardList,
          isHovering: isHoveringOutsider,
          // onDeleteFunction: onDeleteFunction,
          onPrintFunction: !widget.isAdminEditing ? onPrintFunction : null,
          customHoverFunction: customHoverFunction,
          onTapUnlessDisable: onTapUnlessDisable ?? () {},
          isDelete: widget.giveCardToMatModel!.isDelete,
          overwriteId: widget.giveCardToMatModel!.overwriteOnId,
          OtherFooterShowStr: "$giverStr -> $getterStr", index: widget.index,
          isAdminEditing: widget.isAdminEditing,
        );
      }

      void onTapUnlessDisable() {
        Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleTextWidget() {
            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("$cardMainStockTitleGlobal Detail", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))
                ], //TODO: change this
              ),
            );
          }

          Widget invoiceCalculateWidget() {
            final bool isGetFromMat = widget.giveCardToMatModel!.isGetFromMat;
            final String giverIdStr = widget.giveCardToMatModel!.isGetFromMat ? widget.giveCardToMatModel!.employeeId! : profileModelEmployeeGlobal!.id!;
            final String getterIdStr = widget.giveCardToMatModel!.isGetFromMat ? profileModelEmployeeGlobal!.id! : widget.giveCardToMatModel!.employeeId!;
            final String companyNameStr = widget.giveCardToMatModel!.cardCompanyName!;
            final String companyNameIdStr = widget.giveCardToMatModel!.cardCompanyNameId!;
            final String categoryIdStr = widget.giveCardToMatModel!.categoryId!;
            final String categoryStr = formatAndLimitNumberTextGlobal(valueStr: widget.giveCardToMatModel!.category.toString(), isRound: false);

            Widget rateElementWidget({required int mainIndex, required int rateIndex}) {
              final String percentageStr = widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.rateList[rateIndex].percentage.text;
              final double valueNumber = widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.rateList[rateIndex].value!;
              final String rateValueStr = formatAndLimitNumberTextGlobal(valueStr: valueNumber.toString(), isRound: false);
              final double rateDiscountNumber = textEditingControllerToDouble(
                  controller: widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.rateList[rateIndex].discountValue)!;
              final String rateDiscountStr = widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.rateList[rateIndex].discountValue.text;
              final List<String> rateType = widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.rateList[rateIndex].rateType;
              final bool isBuyRate = widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.rateList[rateIndex].isBuyRate!;
              final String rateStr = isBuyRate ? "${rateType.first} -> ${rateType.last}" : "${rateType.last} -> ${rateType.first}";
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Text("            $percentageStr % | $rateStr: ", style: textStyleGlobal(level: Level.normal)),
                  (rateDiscountNumber == valueNumber)
                      ? Text(rateDiscountStr, style: textStyleGlobal(level: Level.normal))
                      : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(rateValueStr, style: TextStyle(fontSize: textSizeGlobal(level: Level.mini), decoration: TextDecoration.lineThrough)),
                          Text(rateDiscountStr, style: textStyleGlobal(level: Level.mini)),
                        ]),
                ]),
              );
            }

            // final String qtyStr = widget.giveCardToMatModel!.qty.text;
            Widget mainPriceElementWidget({required int mainIndex}) {
              final String qtyStr = formatAndLimitNumberTextGlobal(
                valueStr: widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].qty.toString(),
                isRound: false,
              );
              final String stockStr = widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.stock.text;
              final String maxStockStr = formatAndLimitNumberTextGlobal(
                valueStr: widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.maxStock.toString(),
                isRound: false,
              );
              final String stockIdStr = widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.id!;
              final String stockPriceStr = widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.price.text;
              final String stockMoneyTypeStr = widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.moneyType!;
              final String stockDateStr = formatFullDateToStr(
                date: widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.date!,
              );
              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      Text("      Stock: ($stockStr/$maxStockStr) ($stockIdStr)", style: textStyleGlobal(level: Level.normal)),
                    ]),
                  ),
                  scrollText(
                    textStr: "         Stock Date: $stockDateStr",
                    textStyle: textStyleGlobal(level: Level.normal),
                    alignment: Alignment.centerLeft,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      Text("         Qty: ", style: textStyleGlobal(level: Level.normal)),
                      Text(
                        "${isGetFromMat ? "" : "-"}$qtyStr card",
                        style: textStyleGlobal(level: Level.normal, color: isGetFromMat ? positiveColorGlobal : negativeColorGlobal),
                      ),
                    ]),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [Text("         Stock Price: $stockPriceStr $stockMoneyTypeStr", style: textStyleGlobal(level: Level.normal))]),
                  ),
                  widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.rateList.isEmpty
                      ? Container()
                      : Text("         Rate Initiate", style: textStyleGlobal(level: Level.normal)),
                  for (int rateIndex = 0; rateIndex < widget.giveCardToMatModel!.mainPriceQtyList[mainIndex].mainPrice.rateList.length; rateIndex++)
                    rateElementWidget(rateIndex: rateIndex, mainIndex: mainIndex),
                ]),
              );
            }

            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: invoiceBoxWidget(onTapUnlessDisable: null),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Text("$giverStr -> $getterStr ($giverIdStr -> $getterIdStr)", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                ]),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Text(
                    "   $companyNameStr x $categoryStr ($companyNameIdStr x $categoryIdStr)",
                    style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              for (int mainIndex = 0; mainIndex < widget.giveCardToMatModel!.mainPriceQtyList.length; mainIndex++) mainPriceElementWidget(mainIndex: mainIndex),
              activeLogListWidget(activeLogModelList: widget.giveCardToMatModel!.activeLogModelList),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleTextWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                  child: invoiceCalculateWidget(),
                ),
              ),
            ),
          ]);
        }

        void cancelFunctionOnTap() {
          closeDialogGlobal(context: context);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.05,
          dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.05,
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      return invoiceBoxWidget(onTapUnlessDisable: onTapUnlessDisable);
    } else if (widget.otherInOrOutComeModel != null) {
      List<MoneyTypeAndValueModel> getFromCustomerMoneyList = [];
      List<MoneyTypeAndValueModel> giveToCustomerMoneyList = [];
      otherInOrOutComeToMerge(
        otherInOrOutComeModel: widget.otherInOrOutComeModel!,
        getFromCustomerMoneyList: getFromCustomerMoneyList,
        giveToCustomerMoneyList: giveToCustomerMoneyList,
      );
      void onPrintFunction() {
        printOtherInOrOutComeInvoice(otherInOrOutComeModel: widget.otherInOrOutComeModel!, context: context);
      }

      Widget invoiceBoxWidget({required Function? onTapUnlessDisable}) {
        return customInvoiceWidgetGlobal(
          context: context,
          isForceShowNoEffect: widget.isForceShowNoEffect,
          remark: widget.otherInOrOutComeModel!.remark.text,
          dateOld: null,
          date: widget.otherInOrOutComeModel!.date!,
          invoiceTypeStr:
              (textEditingControllerToDouble(controller: widget.otherInOrOutComeModel!.value)! >= 0) ? otherIncomeTitleGlobal : otherOutcomeTitleGlobal,
          getFromCustomerMoneyList: getFromCustomerMoneyList,
          giveToCustomerMoneyList: giveToCustomerMoneyList,
          getFromCustomerCardList: [],
          giveToCustomerCardList: [],
          profitList: [],
          invoiceIdStr: widget.otherInOrOutComeModel!.id!,
          moneyTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.moneyList,
          cardTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.cardList,
          isHovering: isHoveringOutsider,
          // onDeleteFunction: onDeleteFunction,
          onPrintFunction: !widget.isAdminEditing ? onPrintFunction : null,
          customHoverFunction: customHoverFunction,
          onTapUnlessDisable: onTapUnlessDisable ?? () {},
          isDelete: widget.otherInOrOutComeModel!.isDelete,
          overwriteId: widget.otherInOrOutComeModel!.overwriteOnId, index: widget.index,
          isAdminEditing: widget.isAdminEditing,
        );
      }

      void onTapUnlessDisable() {
        Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleTextWidget() {
            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("$cardMainStockTitleGlobal Detail", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))
                ], //TODO: change this
              ),
            );
          }

          Widget invoiceCalculateWidget() {
            final bool isIncrease = textEditingControllerToDouble(controller: widget.otherInOrOutComeModel!.value)! >= 0;
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: invoiceBoxWidget(onTapUnlessDisable: null),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Text(isIncrease ? "Increase Money" : "Decrease Money", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                ]),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Text("   Amount: ", style: textStyleGlobal(level: Level.normal)),
                  Text(
                    "${widget.otherInOrOutComeModel!.value.text} ${widget.otherInOrOutComeModel!.moneyType!}",
                    style: textStyleGlobal(level: Level.normal, color: isIncrease ? positiveColorGlobal : negativeColorGlobal),
                  ),
                ]),
              ),
              activeLogListWidget(activeLogModelList: widget.otherInOrOutComeModel!.activeLogModelList),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleTextWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                  child: invoiceCalculateWidget(),
                ),
              ),
            ),
          ]);
        }

        void cancelFunctionOnTap() {
          closeDialogGlobal(context: context);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.05,
          dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.05,
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      return invoiceBoxWidget(onTapUnlessDisable: onTapUnlessDisable);
    } else if (widget.transferMoneyModel != null) {
      List<MoneyTypeAndValueModel> getFromCustomerMoneyList = [];
      List<MoneyTypeAndValueModel> giveToCustomerMoneyList = [];
      List<MoneyTypeAndValueModel> profitList = [];
      transferToMerge(
        transferMoneyModel: widget.transferMoneyModel!,
        getFromCustomerMoneyList: getFromCustomerMoneyList,
        giveToCustomerMoneyList: giveToCustomerMoneyList,
        profitList: profitList,
      );

      void onDeleteFunction() {
        askingForChangeDialogGlobal(
          context: context,
          allowFunction: () {
            void okFunction() {
              void callBack() {
                // widget.exchangeMoneyModel!.isDelete = true;
                refreshPageGlobal();
                // widget.setStateOutsider();
              }

              closeDialogGlobal(context: context);
              deleteInvoiceEmployee(
                callBack: callBack,
                context: context,
                invoiceId: widget.transferMoneyModel!.id!,
                date: widget.transferMoneyModel!.date!,
                invoiceType: transferQueryGlobal,
                remark: widget.transferMoneyModel!.remark.text,
              );
            }

            void cancelFunction() {
              widget.setStateOutsider();
            }

            confirmationWithTextFieldDialogGlobal(
              subtitleStr: deleteConfirmGlobal,
              context: context,
              titleStr: "${widget.index + 1}. $transferTitleGlobal",
              remarkController: widget.transferMoneyModel!.remark,
              okFunction: okFunction,
              cancelFunction: cancelFunction,
              init: invalidInvoiceGlobal,
            );
          },
          editSettingTypeEnum: EditSettingTypeEnum.delete,
        );
      }

      void onPrintFunction() {
        // await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
        // loadingDialogGlobal(context: context, loadingTitle: printingExchangeInvoiceStrGlobal);
        printTransferInvoice(transferOrder: widget.transferMoneyModel!, context: context);
        // closeDialogGlobal(context: context);
      }

      Widget invoiceBoxWidget({required Function? onTapUnlessDisable}) {
        return customInvoiceWidgetGlobal(
          context: context,
          isForceShowNoEffect: widget.isForceShowNoEffect,
          remark: widget.transferMoneyModel!.remark.text,
          dateOld: widget.transferMoneyModel!.dateOld,
          date: widget.transferMoneyModel!.date!,
          invoiceTypeStr: transferTitleGlobal,
          getFromCustomerMoneyList: getFromCustomerMoneyList,
          giveToCustomerMoneyList: giveToCustomerMoneyList,
          profitList: profitList,
          getFromCustomerCardList: [],
          giveToCustomerCardList: [],
          invoiceIdStr: widget.transferMoneyModel!.id!,
          moneyTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.moneyList,
          cardTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.cardList,
          isHovering: isHoveringOutsider,
          onDeleteFunction: widget.isCurrentDate ? onDeleteFunction : null,
          onPrintFunction: !widget.isAdminEditing ? onPrintFunction : null,
          customHoverFunction: customHoverFunction,
          onTapUnlessDisable: onTapUnlessDisable ?? () {},
          isDelete: widget.transferMoneyModel!.isDelete,
          overwriteId: widget.transferMoneyModel!.overwriteOnId,
          index: widget.index,
          isAdminEditing: widget.isAdminEditing,
        );
      }

      void onTapUnlessDisable() {
        Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleTextWidget() {
            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("$cardMainStockTitleGlobal Detail", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))
                ], //TODO: change this
              ),
            );
          }

          Widget invoiceCalculateWidget() {
            final String transferOrReceiveStr = widget.transferMoneyModel!.isTransfer ? "Customer Transfer Money" : "Customer Receive Money";
            final String otherOrOwnBank = widget.transferMoneyModel!.isUseBank
                ? (widget.transferMoneyModel!.isOtherBank ? "Customer Uses Other Bank" : "Customer Uses Own Bank")
                : "Use Cash";

            Widget informationWidget({required PartnerAndSenderAndReceiver partnerAndSenderAndReceiver, required String titleStr}) {
              Widget informationElementWidget({required int informationIndex}) {
                final String titleStr = partnerAndSenderAndReceiver.informationList[informationIndex].title.text;

                final String subtitleStr = partnerAndSenderAndReceiver.informationList[informationIndex].subtitle.text;
                return scrollText(textStr: "      $titleStr: $subtitleStr", alignment: Alignment.centerLeft, textStyle: textStyleGlobal(level: Level.normal));
              }

              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  scrollText(
                    textStr: "   $titleStr",
                    alignment: Alignment.centerLeft,
                    textStyle: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                  ),
                  partnerAndSenderAndReceiver.name.text.isEmpty
                      ? Container()
                      : scrollText(
                          textStr:
                              "      Name: ${partnerAndSenderAndReceiver.name.text} ${(partnerAndSenderAndReceiver.nameAndInformationId == null) ? "" : "(${partnerAndSenderAndReceiver.nameAndInformationId})"}",
                          alignment: Alignment.centerLeft,
                          textStyle: textStyleGlobal(level: Level.normal),
                        ),
                  for (int informationIndex = 0; informationIndex < partnerAndSenderAndReceiver.informationList.length; informationIndex++)
                    informationElementWidget(informationIndex: informationIndex),
                ]),
              );
            }

            Widget moneyWidget() {
              Widget moneyModelWidget({required List<MoneyListTransfer> moneyList, required bool isHasFee}) {
                Widget moneyElementWidget({required int moneyIndex}) {
                  final double amountNumber = textEditingControllerToDouble(controller: moneyList[moneyIndex].value)!;
                  final double feeNumber = moneyList[moneyIndex].fee!;
                  final double discountFeeNumber = textEditingControllerToDouble(controller: moneyList[moneyIndex].discountFee)!;
                  final String feeStr = formatAndLimitNumberTextGlobal(valueStr: feeNumber.toString(), isRound: false);
                  final double profitNumber = moneyList[moneyIndex].profit;
                  final String profitStr = formatAndLimitNumberTextGlobal(valueStr: profitNumber.toString(), isRound: false);
                  final double feeShareNumber = profitNumber - feeNumber;
                  final String feeShareStr = formatAndLimitNumberTextGlobal(valueStr: feeShareNumber.toString(), isRound: false);
                  return Padding(
                    padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      (moneyList[moneyIndex].transferDate != null)
                          ? scrollText(
                              textStr: "      ${formatFullWithoutSSDateToStr(date: moneyList[moneyIndex].transferDate!)}",
                              alignment: Alignment.centerLeft,
                              textStyle: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                            )
                          : Text("      Merge By ${moneyList[moneyIndex].moneyType}", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Text("         Amount: ", style: textStyleGlobal(level: Level.normal)),
                          Text(
                            "${moneyList[moneyIndex].value.text} ${moneyList[moneyIndex].moneyType}",
                            style: textStyleGlobal(
                              level: Level.normal,
                              color: isHasFee ? ((amountNumber >= 0) ? positiveColorGlobal : negativeColorGlobal) : defaultTextColorGlobal,
                            ),
                          ),
                        ]),
                      ),
                      isHasFee
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(children: [
                                Text("         Fee: ", style: textStyleGlobal(level: Level.normal)),
                                (discountFeeNumber == feeNumber)
                                    ? Text(
                                        moneyList[moneyIndex].discountFee.text,
                                        style: textStyleGlobal(level: Level.normal, color: (feeNumber >= 0) ? positiveColorGlobal : negativeColorGlobal),
                                      )
                                    : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text(
                                          feeStr,
                                          style: TextStyle(
                                            fontSize: textSizeGlobal(level: Level.mini),
                                            decoration: TextDecoration.lineThrough,
                                            color: (feeNumber >= 0) ? positiveColorGlobal : negativeColorGlobal,
                                          ),
                                        ),
                                        Text(
                                          moneyList[moneyIndex].discountFee.text,
                                          style: textStyleGlobal(level: Level.mini, color: (feeNumber >= 0) ? positiveColorGlobal : negativeColorGlobal),
                                        ),
                                      ]),
                                Text(
                                  " ${moneyList[moneyIndex].moneyType!}",
                                  style: textStyleGlobal(level: Level.normal, color: (feeNumber >= 0) ? positiveColorGlobal : negativeColorGlobal),
                                ),
                              ]),
                            )
                          : Container(),
                      isHasFee
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(children: [
                                Text("         Fee Share: ", style: textStyleGlobal(level: Level.normal)),
                                Text(
                                  "$feeShareStr ${moneyList[moneyIndex].moneyType}",
                                  style: textStyleGlobal(level: Level.normal, color: (feeShareNumber >= 0) ? positiveColorGlobal : negativeColorGlobal),
                                ),
                              ]),
                            )
                          : Container(),
                      isHasFee
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(children: [
                                Text("         Profit: ", style: textStyleGlobal(level: Level.normal)),
                                Text(
                                  "$profitStr ${moneyList[moneyIndex].moneyType}",
                                  style: textStyleGlobal(level: Level.normal, color: (profitNumber >= 0) ? positiveColorGlobal : negativeColorGlobal),
                                ),
                              ]),
                            )
                          : Container(),
                    ]),
                  );
                }

                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  for (int moneyIndex = 0; moneyIndex < moneyList.length; moneyIndex++) moneyElementWidget(moneyIndex: moneyIndex),
                ]);
              }

              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                scrollText(
                  textStr: "   Get And Give Money",
                  alignment: Alignment.centerLeft,
                  textStyle: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                ),
                moneyModelWidget(moneyList: widget.transferMoneyModel!.moneyList, isHasFee: widget.transferMoneyModel!.mergeMoneyList.isEmpty),
                widget.transferMoneyModel!.mergeMoneyList.isEmpty
                    ? Container()
                    : scrollText(
                        textStr: "   Merge Money",
                        alignment: Alignment.centerLeft,
                        textStyle: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                      ),
                widget.transferMoneyModel!.mergeMoneyList.isEmpty
                    ? Container()
                    : moneyModelWidget(moneyList: widget.transferMoneyModel!.mergeMoneyList, isHasFee: true),
              ]);
            }

            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: invoiceBoxWidget(onTapUnlessDisable: null),
              ),
              scrollText(
                textStr: "$transferOrReceiveStr, $otherOrOwnBank",
                alignment: Alignment.centerLeft,
                textStyle: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
              ),
              informationWidget(partnerAndSenderAndReceiver: widget.transferMoneyModel!.partner, titleStr: "Partner"),
              (widget.transferMoneyModel!.sender == null)
                  ? Container()
                  : informationWidget(partnerAndSenderAndReceiver: widget.transferMoneyModel!.sender!, titleStr: "Sender"),
              informationWidget(partnerAndSenderAndReceiver: widget.transferMoneyModel!.receiver, titleStr: "Receiver"),
              moneyWidget(),
              activeLogListWidget(activeLogModelList: widget.transferMoneyModel!.activeLogModelList),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleTextWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                  child: invoiceCalculateWidget(),
                ),
              ),
            ),
          ]);
        }

        void cancelFunctionOnTap() {
          closeDialogGlobal(context: context);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.05,
          dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.05,
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      return invoiceBoxWidget(onTapUnlessDisable: onTapUnlessDisable);
    } else if (widget.excelData != null) {
      List<MoneyTypeAndValueModel> getFromCustomerMoneyList = [];
      List<MoneyTypeAndValueModel> giveToCustomerMoneyList = [];
      List<MoneyTypeAndValueModel> profitList = [];
      excelToMerge(
        excelData: widget.excelData!,
        getFromCustomerMoneyList: getFromCustomerMoneyList,
        giveToCustomerMoneyList: giveToCustomerMoneyList,
        profitList: profitList,
      );

      void onPrintFunction() {
        for (int otherIndex = 0; otherIndex < printModelGlobal.otherList.length; otherIndex++) {
          if (printModelGlobal.otherList[otherIndex].title.text == widget.excelData!.printTypeName) {
            printOtherInvoice(context: context, printCustomize: printModelGlobal.otherList[otherIndex]);
            return;
          }
        }
        setUpOtherPrint(isCreateNewOtherPrint: true, otherIndex: null, context: context, setState: setState);
      }

      Widget invoiceBoxWidget({required Function? onTapUnlessDisable}) {
        return customInvoiceWidgetGlobal(
          context: context,
          isForceShowNoEffect: widget.isForceShowNoEffect,
          remark: widget.excelData!.remark.text,
          OtherFooterShowStr: widget.excelData!.name,
          dateOld: null,
          date: widget.excelData!.date,
          invoiceTypeStr: excelStrGlobal,
          getFromCustomerMoneyList: getFromCustomerMoneyList,
          giveToCustomerMoneyList: giveToCustomerMoneyList,
          getFromCustomerCardList: [],
          giveToCustomerCardList: [],
          profitList: profitList,
          invoiceIdStr: widget.excelData!.id!,
          moneyTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.moneyList,
          cardTotalList: (widget.historyModel == null) ? [] : widget.historyModel!.cardList,
          isHovering: isHoveringOutsider,
          // onDeleteFunction: onDeleteFunction,
          onPrintFunction: !widget.isAdminEditing ? onPrintFunction : null,
          customHoverFunction: customHoverFunction,
          onTapUnlessDisable: onTapUnlessDisable ?? () {},
          isDelete: false,
          overwriteId: null,
          index: widget.index,
          isAdminEditing: widget.isAdminEditing,
        );
      }

      void onTapUnlessDisable() {
        Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleTextWidget() {
            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("$excelStrGlobal Detail", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))], //TODO: change this
              ),
            );
          }

          Widget invoiceCalculateWidget() {
            Widget textWidget({required String titleStr, required String subtitleStr}) {
              return scrollText(textStr: "$titleStr: $subtitleStr", textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.centerLeft);
            }

            final String moneyTypeStr = widget.excelData!.moneyType;
            final double profitNumber = widget.excelData!.profit;
            final double amountNumber = widget.excelData!.amount;
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: invoiceBoxWidget(onTapUnlessDisable: null),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [Text(widget.excelData!.name, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold))]),
              ),
              textWidget(titleStr: "   Invoice Id", subtitleStr: widget.excelData!.id!),
              textWidget(titleStr: "   Date", subtitleStr: formatFullDateToStr(date: widget.excelData!.date)),
              textWidget(titleStr: "   Status", subtitleStr: widget.excelData!.status),
              textWidget(titleStr: "   ID", subtitleStr: widget.excelData!.txnID),
              textWidget(titleStr: "   Print Type Name", subtitleStr: widget.excelData!.printTypeName),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Text("   Amount: ", style: textStyleGlobal(level: Level.normal)),
                  Text(
                    "${formatAndLimitNumberTextGlobal(valueStr: amountNumber.toString(), isRound: false)} $moneyTypeStr",
                    style: textStyleGlobal(level: Level.normal, color: (amountNumber >= 0) ? positiveColorGlobal : negativeColorGlobal),
                  ),
                  Text(" (no effect)", style: textStyleGlobal(level: Level.normal, color: Colors.grey)),
                ]),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Text("   Profit: ", style: textStyleGlobal(level: Level.normal)),
                  Text(
                    "${formatAndLimitNumberTextGlobal(valueStr: profitNumber.toString(), isRound: false)} $moneyTypeStr",
                    style: textStyleGlobal(level: Level.normal, color: (profitNumber >= 0) ? positiveColorGlobal : negativeColorGlobal),
                  ),
                ]),
              ),
              activeLogListWidget(activeLogModelList: widget.excelData!.activeLogModelList),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleTextWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                  child: invoiceCalculateWidget(),
                ),
              ),
            ),
          ]);
        }

        void cancelFunctionOnTap() {
          closeDialogGlobal(context: context);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.05,
          dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.05,
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      return invoiceBoxWidget(onTapUnlessDisable: onTapUnlessDisable);
    }
    return const Text("out of widget");
  }
}

Future<void> initHistoryModel({required Response<dynamic> response}) async {
  // if (isResetHistoryLimit) {
  // skipHistoryListGlobal = queryLimitNumberGlobal;
  // outOfDataQueryHistoryListGlobal = false;
  historyListGlobal = [];

  skipExchangeListGlobal = queryLimitNumberGlobal;
  outOfDataQueryExchangeListGlobal = false;
  exchangeModelListEmployeeGlobal = [];

  skipSellCardListGlobal = queryLimitNumberGlobal;
  outOfDataQuerySellCardListGlobal = false;
  sellCardModelListEmployeeGlobal = [];

  skipMainCardListGlobal = queryLimitNumberGlobal;
  outOfDataQueryMainCardListGlobal = false;
  mainCardModelListEmployeeGlobal = [];

  skipBorrowOrLendListGlobal = queryLimitNumberGlobal;
  outOfDataQueryBorrowOrLendListGlobal = false;
  borrowOrLendModelListEmployeeGlobal = [];

  skipGiveMoneyToMatListGlobal = queryLimitNumberGlobal;
  outOfDataQueryGiveMoneyToMatListGlobal = false;
  giveMoneyToMatModelListEmployeeGlobal = [];

  skipGiveCardToMatListGlobal = queryLimitNumberGlobal;
  outOfDataQueryGiveCardToMatListGlobal = false;
  giveCardToMatModelListEmployeeGlobal = [];

  skipOtherInOrOutComeToMatListGlobal = queryLimitNumberGlobal;
  outOfDataQueryOtherInOrOutComeListGlobal = false;
  otherInOrOutComeModelListEmployeeGlobal = [];

  skipTransferListGlobal = queryLimitNumberGlobal;
  outOfDataQueryTransferListGlobal = false;

  transferModelListEmployeeGlobal = [];
  adminIsEditingGlobal = response.data["is_admin_editing_setting"];
  deletingHistoryGlobal = response.data["is_deleting_history"];
  currencyModelListAdminGlobal = currencyModelListFromJson(str: response.data["money_list"]);
  cardModelListGlobal = (response.data["card_list"] == null) ? [] : cardModelListFromJson(str: response.data["card_list"]);
  cardCombineModelListGlobal = (response.data["card_combine_list"] == null) ? [] : cardCombineModelFromJson(str: response.data["card_combine_list"]);
  rateModelListAdminGlobal = (response.data["rate_list"] == null) ? [] : rateModelListFromJson(str: response.data["rate_list"]);
  customerModelListGlobal = (response.data["customer_list"] == null) ? [] : customerModelListFromJson(str: response.data["customer_list"]);
  profileEmployeeModelListAdminGlobal =
      (response.data["employee_profile_list"] == null) ? [] : profileModelListEmployeeFromJson(str: response.data["employee_profile_list"]);
  transferModelListGlobal = (response.data["transfer_list"] == null) ? [] : transferFromJson(str: response.data["transfer_list"]);
  amountAndProfitModelGlobal = amountAndProfitModelFromJson(str: response.data["amount_and_profit"]);
  historyListGlobal = historyModelListFromJson(str: response.data["history_list"]);

  cashModelGlobal = cashModelFromJson(str: response.data["cash"]);

  printModelGlobal = (response.data["print"] == null)
      ? PrintModel(
          communicationList: [],
          footer: ElementPrintModel(title: TextEditingController(), subtitle: TextEditingController()),
          header: ElementPrintModel(title: TextEditingController(), subtitle: TextEditingController()),
          selectedLanguage: languageDefaultStr,
          otherList: [],
        )
      : printModelFromJson(str: response.data["print"]);
  missionModelGlobal =
      (response.data["mission"] == null) ? MissionModel(closeSellingDate: [], totalService: 0) : missionModelFromJson(str: response.data["mission"]);
  exchangeModelListEmployeeGlobal = (response.data["exchange_list"] == null) ? [] : exchangeMoneyModelListFromJson(str: response.data["exchange_list"]);
  transferModelListEmployeeGlobal =
      (response.data["transfer_employee_list"] == null) ? [] : transferOrderFromJson(str: response.data["transfer_employee_list"]);
  sellCardModelListEmployeeGlobal = (response.data["sell_card_list"] == null) ? [] : sellCardModelListFromJson(str: response.data["sell_card_list"]);
  mainCardModelListEmployeeGlobal =
      (response.data["add_card_stock_list"] == null) ? [] : informationAndCardMainStockModelListFromJson(str: response.data["add_card_stock_list"]);

  borrowOrLendModelListEmployeeGlobal = (response.data["borrow_or_lend_list"] == null)
      ? []
      : List<MoneyCustomerModel>.from(json.decode(json.encode(response.data["borrow_or_lend_list"])).map((x) => MoneyCustomerModel.fromJson(x)));
  giveMoneyToMatModelListEmployeeGlobal =
      (response.data["give_money_to_mat_list"] == null) ? [] : giveMoneyToMatModelListFromJson(str: response.data["give_money_to_mat_list"]);
  giveCardToMatModelListEmployeeGlobal =
      (response.data["give_card_to_mat_list"] == null) ? [] : giveCardToMatModelListFromJson(str: response.data["give_card_to_mat_list"]);
  otherInOrOutComeModelListEmployeeGlobal =
      (response.data["other_in_or_out_come_list"] == null) ? [] : otherInOrOutComeModelListFromJson(str: response.data["other_in_or_out_come_list"]);
  salaryListEmployeeGlobal = salaryMergeByMonthModelFromJson(str: response.data["salary_list"]);
  firstDateGlobal = (response.data["first_date"] == null) ? null : DateTime.parse(response.data["first_date"]);
  excelAdminModelListGlobal = (response.data["excel_admin_list"] == null) ? [] : excelAdminModelFromJson(str: response.data["excel_admin_list"]);
  excelListEmployeeGlobal = (response.data["excel_employee_list"] == null) ? [] : excelEmployeeModelListFromJson(str: response.data["excel_employee_list"]);
  excelHistoryListEmployeeGlobal = (response.data["excel_history_employee_list"] == null)
      ? []
      : List<ExcelDataList>.from(json.decode(json.encode(response.data["excel_history_employee_list"])).map((x) => ExcelDataList.fromJson(x)));
  customerCategoryListGlobal = (response.data["customer_information_category_list_last"] == null)
      ? []
      : customerInformationCategoryListFromJson(str: response.data["customer_information_category_list_last"]);
  excelCategoryListGlobal = (response.data["excel_category_list"] == null)
      ? []
      : List<TextEditingController>.from(json.decode(json.encode(response.data["excel_category_list"])).map((x) => TextEditingController(text: x.toString())));
  upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
  askingForChangeFromAdminGlobal = adminOrEmployeeListAskingForChangeFromJson(str: response.data["admin_asking_for_change"]);
  askingForChangeFromEmployeeListGlobal = adminOrEmployeeListAskingForChangeFromJsonList(str: response.data["employee_list_asking_for_change"]);
  createCustomerWithoutTransferListOnly();

  // currencyModelListAdminGlobal = currencyModelListFromJson(str: response.data["money_list"]);
  // cardModelListGlobal = (response.data["card_list"] == null) ? [] : cardModelListFromJson(str: response.data["card_list"]);
  // rateModelListAdminGlobal = (response.data["rate_list"] == null) ? [] : rateModelListFromJson(str: response.data["rate_list"]);
  // customerModelListGlobal = (response.data["customer_list"] == null) ? [] : customerModelListFromJson(str: response.data["customer_list"]);
  // profileEmployeeModelListAdminGlobal =
  //     (response.data["employee_profile_list"] == null) ? [] : profileModelListEmployeeFromJson(str: response.data["employee_profile_list"]);
  // transferModelListGlobal = (response.data["transfer_list"] == null) ? [] : transferFromJson(str: response.data["transfer_list"]);
  // amountAndProfitModelGlobal = amountAndProfitModelFromJson(str: response.data["amount_and_profit"]);
  // historyListGlobal = historyModelListFromJson(str: response.data["history_list"]);

  // cashModelGlobal = cashModelFromJson(str: response.data["cash"]);

  // printModelGlobal = (response.data["print"] == null)
  //     ? PrintModel(
  //         communicationList: [],
  //         footer: ElementPrintModel(title: TextEditingController(), subtitle: TextEditingController()),
  //         header: ElementPrintModel(title: TextEditingController(), subtitle: TextEditingController()),
  //         selectedLanguage: languageDefaultStr,
  //         otherList: [],
  //       )
  //     : printModelFromJson(str: response.data["print"]);
  // missionModelGlobal =
  //     (response.data["mission"] == null) ? MissionModel(closeSellingDate: [], totalService: 0) : missionModelFromJson(str: response.data["mission"]);
  // exchangeModelListEmployeeGlobal = (response.data["exchange_list"] == null) ? [] : exchangeMoneyModelListFromJson(str: response.data["exchange_list"]);
  // transferModelListEmployeeGlobal =
  //     (response.data["transfer_employee_list"] == null) ? [] : transferOrderFromJson(str: response.data["transfer_employee_list"]);
  // sellCardModelListEmployeeGlobal = (response.data["sell_card_list"] == null) ? [] : sellCardModelListFromJson(str: response.data["sell_card_list"]);
  // mainCardModelListEmployeeGlobal =
  //     (response.data["add_card_stock_list"] == null) ? [] : informationAndCardMainStockModelListFromJson(str: response.data["add_card_stock_list"]);
  // borrowOrLendModelListEmployeeGlobal = (response.data["borrow_or_lend_list"] == null)
  //     ? []
  //     : List<MoneyCustomerModel>.from(json.decode(json.encode(response.data["borrow_or_lend_list"])).map((x) => MoneyCustomerModel.fromJson(x)));
  // giveMoneyToMatModelListEmployeeGlobal =
  //     (response.data["give_money_to_mat_list"] == null) ? [] : giveMoneyToMatModelListFromJson(str: response.data["give_money_to_mat_list"]);
  // giveCardToMatModelListEmployeeGlobal =
  //     (response.data["give_card_to_mat_list"] == null) ? [] : giveCardToMatModelListFromJson(str: response.data["give_card_to_mat_list"]);
  // otherInOrOutComeModelListEmployeeGlobal =
  //     (response.data["other_in_or_out_come_list"] == null) ? [] : otherInOrOutComeModelListFromJson(str: response.data["other_in_or_out_come_list"]);
  // salaryListEmployeeGlobal = salaryModelFromJson(str: response.data["salary_list"]);
  // firstDateGlobal = (response.data["first_date"] == null) ? null : DateTime.parse(response.data["first_date"]);
  // excelAdminModelListGlobal = (response.data["excel_admin_list"] == null) ? [] : excelAdminModelFromJson(str: response.data["excel_admin_list"]);
  // excelListEmployeeGlobal = (response.data["excel_employee_list"] == null) ? [] : excelEmployeeModelListFromJson(str: response.data["excel_employee_list"]);
  // excelHistoryListEmployeeGlobal = (response.data["excel_history_employee_list"] == null)
  //     ? []
  //     : List<DataList>.from(json.decode(json.encode(response.data["excel_history_employee_list"])).map((x) => DataList.fromJson(x)));
  // customerCategoryListGlobal = (response.data["customer_information_category_list_last"] == null)
  //     ? []
  //     : customerInformationCategoryListFromJson(str: response.data["customer_information_category_list_last"]);
  await initPrint();
}

void limitHistory() {
  // skipHistoryListGlobal = queryLimitNumberGlobal;
  // outOfDataQueryHistoryListGlobal = false;
  if (historyListGlobal.length > queryLimitNumberGlobal) {
    List<HistoryModel> historyListTemp = [];
    for (int index = 0; index < queryLimitNumberGlobal; index++) {
      historyListTemp.add(historyListGlobal[index]);
    }
    historyListGlobal = historyListTemp;
  }

  skipExchangeListGlobal = queryLimitNumberGlobal;
  outOfDataQueryExchangeListGlobal = false;
  if (exchangeModelListEmployeeGlobal.length > queryLimitNumberGlobal) {
    List<ExchangeMoneyModel> exchangeModelListEmployeeTemp = [];
    for (int index = 0; index < queryLimitNumberGlobal; index++) {
      exchangeModelListEmployeeTemp.add(exchangeModelListEmployeeGlobal[index]);
    }
    exchangeModelListEmployeeGlobal = exchangeModelListEmployeeTemp;
  }

  skipSellCardListGlobal = queryLimitNumberGlobal;
  outOfDataQuerySellCardListGlobal = false;
  if (sellCardModelListEmployeeGlobal.length > queryLimitNumberGlobal) {
    List<SellCardModel> sellCardModelListEmployeeTemp = [];
    for (int index = 0; index < queryLimitNumberGlobal; index++) {
      sellCardModelListEmployeeTemp.add(sellCardModelListEmployeeGlobal[index]);
    }
    sellCardModelListEmployeeGlobal = sellCardModelListEmployeeTemp;
  }

  skipMainCardListGlobal = queryLimitNumberGlobal;
  outOfDataQueryMainCardListGlobal = false;
  if (mainCardModelListEmployeeGlobal.length > queryLimitNumberGlobal) {
    List<InformationAndCardMainStockModel> mainCardModelListEmployeeTemp = [];
    for (int index = 0; index < queryLimitNumberGlobal; index++) {
      mainCardModelListEmployeeTemp.add(mainCardModelListEmployeeGlobal[index]);
    }
    mainCardModelListEmployeeGlobal = mainCardModelListEmployeeTemp;
  }

  skipBorrowOrLendListGlobal = queryLimitNumberGlobal;
  outOfDataQueryBorrowOrLendListGlobal = false;
  if (borrowOrLendModelListEmployeeGlobal.length > queryLimitNumberGlobal) {
    List<MoneyCustomerModel> borrowOrLendModelListEmployeeTemp = [];
    for (int index = 0; index < queryLimitNumberGlobal; index++) {
      borrowOrLendModelListEmployeeTemp.add(borrowOrLendModelListEmployeeGlobal[index]);
    }
    borrowOrLendModelListEmployeeGlobal = borrowOrLendModelListEmployeeTemp;
  }

  skipGiveMoneyToMatListGlobal = queryLimitNumberGlobal;
  outOfDataQueryGiveMoneyToMatListGlobal = false;
  if (giveMoneyToMatModelListEmployeeGlobal.length > queryLimitNumberGlobal) {
    List<GiveMoneyToMatModel> giveMoneyToMatModelListEmployeeTemp = [];
    for (int index = 0; index < queryLimitNumberGlobal; index++) {
      giveMoneyToMatModelListEmployeeTemp.add(giveMoneyToMatModelListEmployeeGlobal[index]);
    }
    giveMoneyToMatModelListEmployeeGlobal = giveMoneyToMatModelListEmployeeTemp;
  }

  skipGiveCardToMatListGlobal = queryLimitNumberGlobal;
  outOfDataQueryGiveCardToMatListGlobal = false;
  if (giveCardToMatModelListEmployeeGlobal.length > queryLimitNumberGlobal) {
    List<GiveCardToMatModel> giveCardToMatModelListEmployeeTemp = [];
    for (int index = 0; index < queryLimitNumberGlobal; index++) {
      giveCardToMatModelListEmployeeTemp.add(giveCardToMatModelListEmployeeGlobal[index]);
    }
    giveCardToMatModelListEmployeeGlobal = giveCardToMatModelListEmployeeTemp;
  }

  skipOtherInOrOutComeToMatListGlobal = queryLimitNumberGlobal;
  outOfDataQueryOtherInOrOutComeListGlobal = false;
  if (otherInOrOutComeModelListEmployeeGlobal.length > queryLimitNumberGlobal) {
    List<OtherInOrOutComeModel> otherInOrOutComeModelListEmployeeTemp = [];
    for (int index = 0; index < queryLimitNumberGlobal; index++) {
      otherInOrOutComeModelListEmployeeTemp.add(otherInOrOutComeModelListEmployeeGlobal[index]);
    }
    otherInOrOutComeModelListEmployeeGlobal = otherInOrOutComeModelListEmployeeTemp;
  }

  skipExcelListGlobal = queryLimitNumberGlobal;
  outOfDataQueryExcelListGlobal = false;
  for (int excelIndex = 0; excelIndex < excelListEmployeeGlobal.length; excelIndex++) {
    if (excelListEmployeeGlobal[excelIndex].dataList.length > queryLimitNumberGlobal) {
      List<ExcelDataList> excelListEmployeeDataListTemp = [];
      for (int index = 0; index < queryLimitNumberGlobal; index++) {
        excelListEmployeeDataListTemp.add(excelListEmployeeGlobal[excelIndex].dataList[index]);
      }
      excelListEmployeeGlobal[excelIndex].dataList = excelListEmployeeDataListTemp;
    }
  }

  skipExcelHistoryListGlobal = queryLimitNumberGlobal;
  outOfDataQueryExcelHistoryListGlobal = false;
  if (excelHistoryListEmployeeGlobal.length > queryLimitNumberGlobal) {
    List<ExcelDataList> excelHistoryListEmployeeTemp = [];
    for (int index = 0; index < queryLimitNumberGlobal; index++) {
      excelHistoryListEmployeeTemp.add(excelHistoryListEmployeeGlobal[index]);
    }
    excelHistoryListEmployeeGlobal = excelHistoryListEmployeeTemp;
  }

  skipTransferListGlobal = queryLimitNumberGlobal;
  outOfDataQueryTransferListGlobal = false;
  if (transferModelListEmployeeGlobal.length > queryLimitNumberGlobal) {
    List<TransferOrder> transferModelListEmployeeTemp = [];
    for (int index = 0; index < queryLimitNumberGlobal; index++) {
      transferModelListEmployeeTemp.add(transferModelListEmployeeGlobal[index]);
    }
    transferModelListEmployeeGlobal = transferModelListEmployeeTemp;
  }

  // skipSalaryListGlobal = queryLimitNumberGlobal;
  // outOfDataQuerySalaryListGlobal = false;
  for (int salaryIndex = 0; salaryIndex < salaryListEmployeeGlobal.length; salaryIndex++) {
    salaryListEmployeeGlobal[salaryIndex].skipSalaryList = queryLimitNumberGlobal;
    salaryListEmployeeGlobal[salaryIndex].outOfDataQuerySalaryList = false;
    if (salaryIndex == 0) {
      if (salaryListEmployeeGlobal[salaryIndex].subSalaryList.length > queryLimitNumberGlobal) {
        List<SubSalaryModel> salaryListEmployeeTemp = [];
        for (int index = 0; index < queryLimitNumberGlobal; index++) {
          salaryListEmployeeTemp.add(salaryListEmployeeGlobal[salaryIndex].subSalaryList[index]);
        }
        salaryListEmployeeGlobal[salaryIndex].subSalaryList = salaryListEmployeeTemp;
      }
    } else {
      salaryListEmployeeGlobal[salaryIndex].subSalaryList = [];
    }
  }
  // if (salaryListEmployeeGlobal.length > queryLimitNumberGlobal) {
  //   List<SubSalaryModel> salaryListEmployeeTemp = [];
  //   for (int index = 0; index < queryLimitNumberGlobal; index++) {
  //     salaryListEmployeeTemp.add(salaryListEmployeeGlobal[index]);
  //   }
  //   salaryListEmployeeGlobal = salaryListEmployeeTemp;
  // }
}
