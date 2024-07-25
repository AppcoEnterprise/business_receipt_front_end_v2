// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:business_receipt/env/function/active_log.dart';
import 'package:business_receipt/env/function/button/button_env.dart';
import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/card.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/draw_line.dart';
import 'package:business_receipt/env/function/drop_down_and_text_field_provider.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/merge_value_from_model.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/rate.dart';
import 'package:business_receipt/env/function/request_api/card_request_api_env.dart';
import 'package:business_receipt/env/function/table_env.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_area_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/toggle_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/active_log.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/employee_model/card/card_other_model.dart';
import 'package:business_receipt/model/employee_model/card/company_x_category_model.dart';
import 'package:business_receipt/model/employee_model/card/sell_card_model.dart';
import 'package:business_receipt/model/employee_model/exchange_money_model.dart';
import 'package:business_receipt/model/money_type_and_value_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class SellCardEmployeeSideMenu extends StatefulWidget {
  String title;
  Function callback;
  SellCardEmployeeSideMenu({Key? key, required this.title, required this.callback}) : super(key: key);

  @override
  State<SellCardEmployeeSideMenu> createState() => _SellCardEmployeeSideMenuState();
}

class _SellCardEmployeeSideMenuState extends State<SellCardEmployeeSideMenu> {
  // bool _isLoadingOnInitCard = true;
  // bool _isShowPrevious = false;
  bool _isSeparate = false;
  bool _isInitCard = true;
  String? moneyTypeSelectForRemake;
  bool _isShowProfitOnGetMoneyFromCustomer = false; //TODO: set to db setting

  // SellCardModel sellCardAdvanceModelTempSellCardGlobal = SellCardModel(moneyTypeList: [], remark: TextEditingController());
  // ExchangeMoneyModel exchangeAnalysisCardSellCardGlobal = ExchangeMoneyModel(exchangeList: [], remark: TextEditingController());
  final List<TextEditingController> headerList = [
    TextEditingController(text: "Category"),
    TextEditingController(text: "Qty"),
    TextEditingController(text: "Price"),
    TextEditingController(text: "Discount"),
    TextEditingController(text: "Profit"),
    TextEditingController(text: "Total"),
  ];
  final List<int> expandedList = [2, 1, 2, 2, 2, 2];
  final List<WidgetType> widgetTypeList = [
    WidgetType.text,
    WidgetType.text,
    WidgetType.dropDown,
    WidgetType.dropDownOrTextField,
    WidgetType.numberText,
    WidgetType.text
  ];
  // List<List<TextEditingController>> textFieldController2DSellCardGlobal = [];
  // List<List<List<String>>> menuItemStr3DSellCardGlobal = [];
  // List<List<bool>> isShowTextField2DSellCardGlobal = [];

  // List<BuyAndSellDiscountRate> buyAndSellDiscountRateListSellCardGlobal = [];

  // final List<int> expandedList = [2, 1, 2, 2, 2, 2];
  // final List<WidgetType> widgetTypeList = [
  //   WidgetType.text,
  //   WidgetType.text,
  //   WidgetType.dropDown,
  //   WidgetType.dropDownOrTextField,
  //   WidgetType.numberText,
  //   WidgetType.text
  // ];

  // final List<TextEditingController> headerList = [
  //   TextEditingController(text: "Category"),
  //   TextEditingController(text: "Qty"),
  //   TextEditingController(text: "Price"),
  //   TextEditingController(text: "Discount"),
  //   TextEditingController(text: "Profit"),
  //   TextEditingController(text: "Total"),
  // ];
  void initRateDiscountList() {
    for (int rateIndex = 0; rateIndex < rateModelListAdminGlobal.length; rateIndex++) {
      if (rateModelListAdminGlobal[rateIndex].display) {
        final List<String> rateType = rateModelListAdminGlobal[rateIndex].rateType;
        RateForCalculateModel rateForCalculateModel({required BuyOrSellRateModel? buyOrSellRateModel, required bool isBuyRate}) {
          final bool isBuyOrSellRateModelNull = (buyOrSellRateModel == null);
          if (isBuyOrSellRateModelNull) {
            return RateForCalculateModel(
              rateId: null,
              rateType: rateType,
              isBuyRate: isBuyRate,
              value: null,
              discountValue: TextEditingController(),
              usedModelList: [],
              percentage: TextEditingController(),
            );
          } else {
            final String rateId = buyOrSellRateModel.id!;
            final double? value = buyOrSellRateModel.value.text.isEmpty ? null : textEditingControllerToDouble(controller: buyOrSellRateModel.value);
            final TextEditingController discountValue =
                TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: buyOrSellRateModel.value.text, isRound: false, isAllowZeroAtLast: false));
            return RateForCalculateModel(
              rateId: rateId,
              rateType: rateType,
              isBuyRate: isBuyRate,
              value: value,
              discountValue: discountValue,
              usedModelList: [],
              percentage: TextEditingController(),
            );
          }
        }

        final RateForCalculateModel buy = rateForCalculateModel(buyOrSellRateModel: rateModelListAdminGlobal[rateIndex].buy, isBuyRate: true);
        final RateForCalculateModel sell = rateForCalculateModel(buyOrSellRateModel: rateModelListAdminGlobal[rateIndex].sell, isBuyRate: false);
        buyAndSellDiscountRateListSellCardGlobal.add(BuyAndSellDiscountRate(buy: buy, sell: sell, rateType: rateType));
      }
    }
  }

  void initCardDiscountPriceBySellPriceFirstIndex() {
    for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
      //create companyName sting of cardListAdminGlobal
      final String companyNameStr = cardModelListGlobal[cardIndex].cardCompanyName.text;
      for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++) {
        //create qty controller of cardListAdminGlobal
        final TextEditingController qtyController = cardModelListGlobal[cardIndex].categoryList[categoryIndex].qty;

        //check qty empty or not
        final bool isQtyNotEmpty = qtyController.text.isNotEmpty;
        if (isQtyNotEmpty) {
          //create qty number
          final int qtyNumber = textEditingControllerToInt(controller: qtyController)!;
          final bool isQtyNotEqual0 = (qtyNumber != 0);
          if (isQtyNotEqual0) {
            //create qty category controller of cardListAdminGlobal
            final TextEditingController categoryController = cardModelListGlobal[cardIndex].categoryList[categoryIndex].category;

            //create category number
            final double categoryNumber = textEditingControllerToDouble(controller: categoryController)!;
            final List<MoneyTypeAndValueModel> cardPriceList = getCardPriceOnlyList(companyNameStr: companyNameStr, categoryNumber: categoryNumber);
            // for (int i = 0; i < cardPriceList.length; i++) {
            //   print("cardPriceList[$i].toJson() => ${cardPriceList[i].toJson()}");
            // }
            cardModelListGlobal[cardIndex].categoryList[categoryIndex].discountPriceAndMoneyTypeController =
                TextEditingController(text: "${cardPriceList.first.value}$spaceStrGlobal${cardPriceList.first.moneyType}");
            cardModelListGlobal[cardIndex].categoryList[categoryIndex].selectedSellDiscountPriceIndex = getSelectedSellDiscountPriceIndexByPriceAndMoneyTypeStr(
              companyNameStr: companyNameStr,
              category: categoryNumber,
              discountPriceAndMoneyTypeStr: customValueAndMoneyType(
                valueStr: cardModelListGlobal[cardIndex].categoryList[categoryIndex].discountPriceAndMoneyTypeController!.text,
                moneyTypeStr: cardPriceList.first.moneyType,
              ),
            );
          }
        }
      }
    }
  }

  bool getValidProfitRateByIndex({required int moneyTypeIndex, required SellCardModel sellCardAdvanceModelTemp}) {
    for (int cardIndex = 0; cardIndex < sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList.length; cardIndex++) {
      final bool isNotValidProfitRateInside = !sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList[cardIndex].isValidProfitRate;
      if (isNotValidProfitRateInside) {
        return false;
      }
    }
    return true;
  }

  String? findSpecialMoneyType({required SellCardModel sellCardAdvanceModelTemp}) {
    List<CountMoneyType> countMoneyTypeList = [];
    for (int i = 0; i < sellCardAdvanceModelTemp.moneyTypeList.length; i++) {
      String moneyType = sellCardAdvanceModelTemp.moneyTypeList[i].calculate.moneyType;
      int indexExist = -1;
      for (int j = 0; j < countMoneyTypeList.length; j++) {
        if (moneyType == countMoneyTypeList[j].moneyType) {
          indexExist = j;
        }
      }
      if (indexExist == -1) {
        countMoneyTypeList.add(CountMoneyType(count: 1, moneyType: moneyType));
      } else {
        countMoneyTypeList[indexExist].count++;
      }
    }
    countMoneyTypeList.sort((a, b) {
      return b.count.compareTo(a.count);
    });
    return (countMoneyTypeList.isEmpty) ? null : countMoneyTypeList.first.moneyType;
  }

  void clearCardOrderList({required bool isClearQty}) {
    if (isClearQty) {
      sellCardAdvanceModelTempSellCardGlobal.remark.clear();
    }
    for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
      for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++) {
        //create qty controller of cardListAdminGlobal
        final TextEditingController qtyController = cardModelListGlobal[cardIndex].categoryList[categoryIndex].qty;

        //check qty empty or not
        final bool isQtyNotEmpty = qtyController.text.isNotEmpty;
        if (isQtyNotEmpty) {
          if (isClearQty) {
            cardModelListGlobal[cardIndex].categoryList[categoryIndex].qty.clear();
          }
          cardModelListGlobal[cardIndex].categoryList[categoryIndex].selectedSellPriceIndex = 0;
          cardModelListGlobal[cardIndex].categoryList[categoryIndex].selectedSellDiscountPriceIndex = 0;
          cardModelListGlobal[cardIndex].categoryList[categoryIndex].isShowTextField = false;
          cardModelListGlobal[cardIndex].categoryList[categoryIndex].discountPriceAndMoneyTypeController = null;
        }
      }
    }
  }

  ValidButtonModel getValidGetMoneyFormCustomerFunction({required bool isSimpleCalculate, required SellCardModel sellCardAdvanceModelTemp}) {
    // ValidButtonModel getValidGetMoneyFormCustomer() {
    // bool validateRate({required RateForCalculateModel rate}) {
    //   if (rate.discountValue.text.isEmpty) {
    //     return false;
    //   }
    //   final RateModel rateModel = getRateModel(rateTypeFirst: rate.rateType.first, rateTypeLast: rate.rateType.last)!;
    //   final double limitRateFirstNumber = textEditingControllerToDouble(controller: rateModel.limit.first)!;
    //   final double limitRateLastNumber = textEditingControllerToDouble(controller: rateModel.limit.last)!;
    //   final double discountRateNumber = textEditingControllerToDouble(controller: rate.discountValue)!;
    //   return (limitRateFirstNumber <= discountRateNumber && discountRateNumber <= limitRateLastNumber);
    // }

    // for (int rateIndex = 0; rateIndex < buyAndSellDiscountRateList.length; rateIndex++) {
    //   if (!(validateRate(rate: buyAndSellDiscountRateList[rateIndex].buy) && validateRate(rate: buyAndSellDiscountRateList[rateIndex].sell))) {
    //     print("${!validateRate(rate: buyAndSellDiscountRateList[rateIndex].buy)} && ${validateRate(rate: buyAndSellDiscountRateList[rateIndex].sell)}");
    //     return false;
    //   }
    // }
    if (_isSeparate) {
      final bool isHasMoneyTypeList = sellCardAdvanceModelTemp.moneyTypeList.isNotEmpty;
      if (isHasMoneyTypeList) {
        for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTemp.moneyTypeList.length; moneyTypeIndex++) {
          final bool isDone = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].calculate.isDone;
          if (!isDone) {
            // return false;
            return ValidButtonModel(isValid: false, error: "please click done button.");
          }
          final bool isCustomerMoneyListMoreThan1 = (sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].calculate.customerMoneyList.length > 1);
          if (isCustomerMoneyListMoreThan1) {
            final int lastGetMoneyFromCustomerIndex = (sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].calculate.customerMoneyList.length - 1);
            final double? lastGiveMoneyToCustomerNumber =
                sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].calculate.customerMoneyList[lastGetMoneyFromCustomerIndex - 1].giveMoney;
            final bool isLastGiveMoneyToCustomerNull = (lastGiveMoneyToCustomerNumber == null);
            if (isLastGiveMoneyToCustomerNull) {
              // return false;
              return ValidButtonModel(isValid: false, error: "no give money to customer.");
            } else {
              final bool isNotHasChange = (lastGiveMoneyToCustomerNumber > 0);
              if (isNotHasChange) {
                // return false;
                return ValidButtonModel(isValid: false, error: "need more money from customer.");
              }
            }
          } else {
            // return false;
            return ValidButtonModel(isValid: false, error: "customer has not given money yet.");
          }
        }
      } else {
        // return false;
        return ValidButtonModel(isValid: false, error: "customer has not given money yet.");
      }
    } else {
      final bool isMergeCalculateNull = (sellCardAdvanceModelTemp.mergeCalculate == null);
      if (isMergeCalculateNull) {
        // return false;
        return ValidButtonModel(isValid: false, error: "merge option is invalid.");
      } else {
        final bool isDone = sellCardAdvanceModelTemp.mergeCalculate!.isDone;
        if (!isDone && !isSimpleCalculate) {
          // return false;
          return ValidButtonModel(isValid: false, error: "please click done button.");
        }
        final bool isCustomerMoneyListMoreThan1 = (sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.length > 1);
        if (isCustomerMoneyListMoreThan1) {
          final int lastGetMoneyFromCustomerIndex = (sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.length - 1);
          final double? lastGiveMoneyToCustomerNumber = sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList[lastGetMoneyFromCustomerIndex - 1].giveMoney;
          final bool isLastGiveMoneyToCustomerNull = (lastGiveMoneyToCustomerNumber == null);
          if (isLastGiveMoneyToCustomerNull) {
            // return false;
            return ValidButtonModel(isValid: false, error: "no give money to customer.");
          } else {
            final bool isNotHasChange = (lastGiveMoneyToCustomerNumber > 0);
            if (isNotHasChange) {
              // return false;
              return ValidButtonModel(isValid: false, error: "need more money from customer.");
            }
          }
        } else {
          // return false;
          return ValidButtonModel(isValid: false, error: "customer has not given money yet.");
        }
      }
    }
    bool isValidProfitRate = true;
    for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTemp.moneyTypeList.length; moneyTypeIndex++) {
      final String moneyTypeStr = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].calculate.moneyType;
      for (int cardIndex = 0; cardIndex < sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList.length; cardIndex++) {
        final String companyNameStr = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList[cardIndex].cardCompanyName;
        final double categoryNumber = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList[cardIndex].category;
        final String discountPriceStr = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList[cardIndex].sellPrice.discountValue;

        final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
        final int categoryIndex = cardModelListGlobal[companyNameIndex]
            .categoryList
            .indexWhere((element) => (textEditingControllerToDouble(controller: element.category) == categoryNumber)); //never equal -1
        final int limitIndex =
            cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].limitList.indexWhere((element) => (element.moneyType == moneyTypeStr));

        final double startCardNumber =
            textEditingControllerToDouble(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].limitList[limitIndex].limit.first)!;
        final double lastCardNumber =
            textEditingControllerToDouble(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].limitList[limitIndex].limit.last)!;
        final double discountPriceNumber = double.parse(formatAndLimitNumberTextGlobal(valueStr: discountPriceStr, isRound: false, isAddComma: false));
        final bool isValidateCardBetweenLimit = (startCardNumber <= discountPriceNumber && discountPriceNumber <= lastCardNumber);
        if (!isValidateCardBetweenLimit) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.compareNumber,
            error: "card price is not between $startCardNumber and $lastCardNumber.",
            errorLocationList: [
              TitleAndSubtitleModel(title: "Company Name", subtitle: companyNameStr),
              TitleAndSubtitleModel(title: "Category", subtitle: categoryNumber.toString()),
              TitleAndSubtitleModel(title: "Discount Price", subtitle: discountPriceStr),
            ],
            detailList: [TitleAndSubtitleModel(title: "$startCardNumber <= $discountPriceNumber <= $lastCardNumber", subtitle: "invalid compare")],
          );
        }
      }
      bool isNotValidProfitRate = !getValidProfitRateByIndex(moneyTypeIndex: moneyTypeIndex, sellCardAdvanceModelTemp: sellCardAdvanceModelTemp);
      if (isNotValidProfitRate) {
        isValidProfitRate = false;
        break;
      }
    }
    // return isValidProfitRate;
    return ValidButtonModel(isValid: isValidProfitRate, error: "invalid profit.");
    // }

    // return getValidGetMoneyFormCustomer;
  }

  void updateSellCardOrPrint({required bool isPrint, required SellCardModel sellCardAdvanceModelTemp, required bool isSimpleCalculate}) {
    if (!isSimpleCalculate) {
      closeDialogGlobal(context: context);
    }
    if (_isSeparate) {
      sellCardAdvanceModelTemp.mergeCalculate = null;
      for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTemp.moneyTypeList.length; moneyTypeIndex++) {
        sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].calculate.customerMoneyList.removeLast();
      }
    } else {
      sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.removeLast();
      for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTemp.moneyTypeList.length; moneyTypeIndex++) {
        sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].calculate.customerMoneyList = [];
      }
    }
    for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTemp.moneyTypeList.length; moneyTypeIndex++) {
      for (int cardIndex = 0; cardIndex < sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList.length; cardIndex++) {
        for (int mainPriceQtyIndex = 0;
            mainPriceQtyIndex < sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList.length;
            mainPriceQtyIndex++) {
          final int qty = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList[mainPriceQtyIndex].qty;
          final int stock = textEditingControllerToInt(
              controller: sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList[mainPriceQtyIndex].mainPrice.stock)!;
          sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList[mainPriceQtyIndex].mainPrice.stock.text =
              (stock - qty).toString();
        }
      }
    }

    addActiveLogElement(
      activeLogModelList: activeLogModelSellCardList,
      activeLogModel: ActiveLogModel(idTemp: isPrint ? "save and print button" : "save button", activeType: ActiveLogTypeEnum.clickButton, locationList: [
        Location(title: "card calculation", subtitle: isSimpleCalculate ? "simple calculation" : "advance calculation"),
        Location(color: ColorEnum.blue, title: "button name", subtitle: isPrint ? "save and print button" : "save button"),
      ]),
    );
    sellCardCheckForFinalEdition(activeLogModelList: activeLogModelSellCardList, sellCardModel: sellCardAdvanceModelTemp);
    setFinalEditionActiveLog(activeLogModelList: activeLogModelSellCardList);
    sellCardAdvanceModelTemp.activeLogModelList = activeLogModelSellCardList;
    void callBack() {
      sellCardAdvanceModelTemp.remark.clear();
      final CalculateSellCardModel calculateSellCardModel =
          CalculateSellCardModel(totalMoney: 0, moneyType: findSpecialMoneyType(sellCardAdvanceModelTemp: sellCardAdvanceModelTemp)!, customerMoneyList: []);
      sellCardAdvanceModelTemp =
          SellCardModel(activeLogModelList: [], moneyTypeList: [], mergeCalculate: calculateSellCardModel, remark: TextEditingController());
      textFieldController2DSellCardGlobal = [];
      menuItemStr3DSellCardGlobal = [];
      isShowTextField2DSellCardGlobal = [];
      buyAndSellDiscountRateListSellCardGlobal = [];
      sellCardModelTempSideMenuListGlobal = [];
      initRateDiscountList();
      _isInitCard = true;
      clearCardOrderList(isClearQty: true);
      if (isPrint) {
        printSellCardInvoice(context: context, sellCardModel: sellCardModelListEmployeeGlobal.first);
      }
      setState(() {});
      // if (!isSimpleCalculate) {
      activeLogModelSellCardList = [];
      widget.callback();
      // }
    }

    updateSellCardGlobal(callBack: callBack, context: context, sellCardModelTemp: sellCardAdvanceModelTemp);
  }

  void saveFunctionOnTap({required SellCardModel sellCardAdvanceModelTemp, required bool isSimpleCalculate}) {
    updateSellCardOrPrint(isPrint: false, sellCardAdvanceModelTemp: sellCardAdvanceModelTemp, isSimpleCalculate: isSimpleCalculate);
  }

  void saveAndPrintFunctionOnTap({required SellCardModel sellCardAdvanceModelTemp, required bool isSimpleCalculate}) {
    updateSellCardOrPrint(isPrint: true, sellCardAdvanceModelTemp: sellCardAdvanceModelTemp, isSimpleCalculate: isSimpleCalculate);
  }

  ValidButtonModel isValidCard({required bool isEqualMainAndSellPrice}) {
    bool isHasOrder = false;
    for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
      final String companyNameStr = cardModelListGlobal[cardIndex].cardCompanyName.text;
      for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++) {
        final bool isQtyNotNull = cardModelListGlobal[cardIndex].categoryList[categoryIndex].qty.text.isNotEmpty;
        if (isQtyNotNull) {
          final double qtyNumber = textEditingControllerToDouble(controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].qty)!;
          final bool isQtyNotEqual0 = (qtyNumber != 0);
          if (isQtyNotEqual0) {
            isHasOrder = true;
            final TextEditingController categoryController = cardModelListGlobal[cardIndex].categoryList[categoryIndex].category;
            final double categoryNumber = textEditingControllerToDouble(controller: categoryController)!;
            final List<MoneyTypeAndValueModel> cardPriceOnlyList = getCardPriceOnlyList(companyNameStr: companyNameStr, categoryNumber: categoryNumber);
            final bool isCardPriceEmpty = cardPriceOnlyList.isEmpty;
            final double? profitOrNull = calculateProfit(
              companyNameStr: companyNameStr,
              categoryNumber: categoryNumber,
              buyAndSellDiscountRateList: buyAndSellDiscountRateListSellCardGlobal,
              isEqualMainAndSellPrice: isEqualMainAndSellPrice,
            );

            final bool isProfitNull = (profitOrNull == null);
            // if (isCardPriceEmpty || isProfitNull) {
            //   // return false;
            // }
            if (isProfitNull) {
              // return false;
              return ValidButtonModel(
                isValid: false,
                error: "profit is invalid.",
                errorLocationList: [
                  TitleAndSubtitleModel(title: "Company Name", subtitle: companyNameStr),
                  TitleAndSubtitleModel(title: "Category", subtitle: categoryNumber.toString()),
                  TitleAndSubtitleModel(title: "profit", subtitle: ""),
                ],
              );
            }
            if (isCardPriceEmpty) {
              // return false;
              return ValidButtonModel(
                isValid: false,
                error: "card price is invalid.",
                errorLocationList: [
                  TitleAndSubtitleModel(title: "Company Name", subtitle: companyNameStr),
                  TitleAndSubtitleModel(title: "Category", subtitle: categoryNumber.toString()),
                  TitleAndSubtitleModel(title: "card price", subtitle: ""),
                ],
              );
            }
          } else {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              error: "qty equal 0.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "Company Name", subtitle: companyNameStr),
                TitleAndSubtitleModel(title: "Category", subtitle: cardModelListGlobal[cardIndex].categoryList[categoryIndex].category.text),
                TitleAndSubtitleModel(title: "qty", subtitle: cardModelListGlobal[cardIndex].categoryList[categoryIndex].qty.text),
              ],
            );
          }
        }
      }
    }
    return ValidButtonModel(isValid: isHasOrder, error: "no order.");
  }

  void calculateSellCardListByMoneyTypeFunction() {
    void calculateOnTapFunction({required String selectMoneyType, required SellCardModel sellCardAdvanceModelTemp}) {
      sellCardAdvanceModelTemp.date = null;
      sellCardAdvanceModelTemp.dateOld = null;
      sellCardAdvanceModelTemp.id = null;
      sellCardAdvanceModelTemp.isDelete = false;
      sellCardAdvanceModelTemp.mergeCalculate = null;
      sellCardAdvanceModelTemp.moneyTypeList = [];
      sellCardAdvanceModelTemp.overwriteOnId = null;
      sellCardAdvanceModelTemp.remark = TextEditingController();

      buyAndSellDiscountRateListSellCardGlobal = [];
      textFieldController2DSellCardGlobal = [];
      menuItemStr3DSellCardGlobal = [];
      isShowTextField2DSellCardGlobal = [];

      initRateDiscountList();
      initSellCardModel(isSimpleCalculate: true, moneyTypeFromSimpleCalculate: selectMoneyType, sellCardAdvanceModelTemp: sellCardAdvanceModelTemp);

      sellCardAdvanceModelTemp.mergeCalculate!.moneyType = selectMoneyType;
      initCardDiscountPriceBySellPriceFirstIndex();
      sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.insert(
        0,
        CustomerMoneyListSellCardModel(
          moneyType: sellCardAdvanceModelTemp.mergeCalculate!.moneyType,
          getMoney: sellCardAdvanceModelTemp.mergeCalculate!.totalMoney.toString(),
          giveMoney: 0,
          getMoneyController: TextEditingController(text: sellCardAdvanceModelTemp.mergeCalculate!.totalMoney.toString()),
        ),
      );
    }

    _isSeparate = false;
    sellCardModelTempSideMenuListGlobal = [];
    if (isValidCard(isEqualMainAndSellPrice: false).isValid) {
      for (int moneyIndex = 0; moneyIndex < currencyModelListAdminGlobal.length; moneyIndex++) {
        if (currencyModelListAdminGlobal[moneyIndex].deletedDate == null) {
          SellCardModel sellCardAdvanceModelTemp = SellCardModel(activeLogModelList: [], moneyTypeList: [], remark: TextEditingController());
          calculateOnTapFunction(selectMoneyType: currencyModelListAdminGlobal[moneyIndex].moneyType, sellCardAdvanceModelTemp: sellCardAdvanceModelTemp);
          if (getValidGetMoneyFormCustomerFunction(isSimpleCalculate: true, sellCardAdvanceModelTemp: sellCardAdvanceModelTemp).isValid) {
            sellCardModelTempSideMenuListGlobal.add(sellCardAdvanceModelTemp);
          }
        }
      }
    }
    setState(() {});
  }

  void cancelFunctionOnTap({required SellCardModel sellCardAdvanceModelTemp}) {
    void okFunction() {
      final CalculateSellCardModel calculateSellCardModel = CalculateSellCardModel(
        totalMoney: 0,
        moneyType: findSpecialMoneyType(sellCardAdvanceModelTemp: sellCardAdvanceModelTemp)!,
        customerMoneyList: [],
      );
      sellCardAdvanceModelTemp.remark.text = "";
      moneyTypeSelectForRemake = null;
      sellCardAdvanceModelTemp =
          SellCardModel(activeLogModelList: [], moneyTypeList: [], mergeCalculate: calculateSellCardModel, remark: TextEditingController());
      textFieldController2DSellCardGlobal = [];
      menuItemStr3DSellCardGlobal = [];
      isShowTextField2DSellCardGlobal = [];
      buyAndSellDiscountRateListSellCardGlobal = [];
      initRateDiscountList();
      _isInitCard = true;
      clearCardOrderList(isClearQty: false);
      closeDialogGlobal(context: context);
      calculateSellCardListByMoneyTypeFunction();
    }

    confirmationDialogGlobal(
        cancelFunction: () {},
        context: context,
        okFunction: okFunction,
        titleStr: gettingMoneyFromCustomerStrGlobal,
        subtitleStr: cancelEditingSettingConfirmGlobal);
  }

  Widget moneyTypeOptionWidget(
      {required CalculateSellCardModel calculateSellCardModel,
      required Function setStateFromDialog,
      required bool isShowTotalByMoneyTypeDropDown,
      required SellCardModel sellCardAdvanceModelTemp}) {
    Widget totalByTextWidget() {
      return Text(totalByCardStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold));
    }

    Widget textOrDropDownMoneyTypeWidget() {
      Widget moneyTypeTextWidget() {
        return Text(calculateSellCardModel.moneyType, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold));
      }

      Widget moneyTypeDropDownWidget() {
        final String selectedStr = calculateSellCardModel.moneyType;
        void onChangedFunction({required String value, required int index}) {
          calculateSellCardModel.moneyType = value;
          addActiveLogElement(
            activeLogModelList: activeLogModelSellCardList,
            activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.selectDropdown, locationList: [
              Location(title: "card calculation", subtitle: "advance calculation"),
              Location(title: "select merge money type", subtitle: "$selectedStr to $value"),
            ]),
          );

          _isInitCard = true;
          setStateFromDialog(() {});
        }

        void onTapFunction() {}
        List<String> moneyTypeList = [];
        for (int moneyTypeOfSellCardIndex = 0; moneyTypeOfSellCardIndex < sellCardAdvanceModelTemp.moneyTypeList.length; moneyTypeOfSellCardIndex++) {
          if (!moneyTypeList.contains(sellCardAdvanceModelTemp.moneyTypeList[moneyTypeOfSellCardIndex].calculate.moneyType)) {
            moneyTypeList.add(sellCardAdvanceModelTemp.moneyTypeList[moneyTypeOfSellCardIndex].calculate.moneyType);
          }
        }

        return SizedBox(
          width: dropdownMoneyTypeFixWidthGlobal,
          child: customDropdown(
            level: Level.mini,
            labelStr: moneyTypeStrGlobal,
            onTapFunction: onTapFunction,
            onChangedFunction: onChangedFunction,
            selectedStr: selectedStr,
            menuItemStrList: moneyTypeOfDiscountCardOnlyList(
              moneyTypeList: moneyTypeList,
              buyAndSellDiscountRateList: buyAndSellDiscountRateListSellCardGlobal, isNotCheckDeleted: false,
            ),
          ),
        );
      }

      return isShowTotalByMoneyTypeDropDown ? moneyTypeDropDownWidget() : moneyTypeTextWidget();
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [totalByTextWidget(), textOrDropDownMoneyTypeWidget()]);
  }

  void initSellCardModel({required bool isSimpleCalculate, String? moneyTypeFromSimpleCalculate, required SellCardModel sellCardAdvanceModelTemp}) {
    //-------------------------card model list to sell card model---------------------------------------
    for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
      final String companyNameId = cardModelListGlobal[cardIndex].id!;
      //create companyName sting of cardListAdminGlobal
      final String companyNameStr = cardModelListGlobal[cardIndex].cardCompanyName.text;
      // final String language = cardModelListAdminGlobal[cardIndex].language;
      for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++) {
        //create qty controller of cardListAdminGlobal
        final TextEditingController qtyController = cardModelListGlobal[cardIndex].categoryList[categoryIndex].qty;

        //check qty empty or not
        final bool isQtyNotEmpty = qtyController.text.isNotEmpty;
        if (isQtyNotEmpty) {
          //create qty number
          final int qtyNumber = textEditingControllerToInt(controller: qtyController)!;
          final bool isQtyNotEqual0 = (qtyNumber != 0);
          if (isQtyNotEqual0) {
            final String categoryId = cardModelListGlobal[cardIndex].categoryList[categoryIndex].id!;

            //create qty category controller of cardListAdminGlobal
            final TextEditingController categoryController = cardModelListGlobal[cardIndex].categoryList[categoryIndex].category;

            //create category number
            final double categoryNumber = textEditingControllerToDouble(controller: categoryController)!;

            MoneyTypeAndValueModel sellPriceModel = getSellPriceBySelectedSellPriceIndex(companyNameStr: companyNameStr, categoryNumber: categoryNumber)!;
            double sellDiscountPrice = 0;
            String sellDiscountPriceAndMoneyTypeStr = "";
            if (isSimpleCalculate) {
              sellDiscountPriceAndMoneyTypeStr = customValueAndMoneyType(valueStr: sellPriceModel.value.toString(), moneyTypeStr: sellPriceModel.moneyType);
              sellDiscountPrice = sellPriceModel.value;
            } else {
              sellDiscountPriceAndMoneyTypeStr =
                  getSellDiscountPriceBySelectedSellDiscountPriceIndex(companyNameStr: companyNameStr, categoryNumber: categoryNumber);

              // sellDiscountPrice = 0;
              final bool isSellDiscountPriceAndMoneyTypeStrNotEmpty = sellDiscountPriceAndMoneyTypeStr.isNotEmpty;
              if (isSellDiscountPriceAndMoneyTypeStrNotEmpty) {
                final TextEditingController discountPriceAndMoneyTypeController = cardModelListGlobal[cardIndex]
                    .categoryList[categoryIndex]
                    .discountPriceAndMoneyTypeController!; //discountPriceAndMoneyTypeController never null, cause it is already check null on getSellDiscountPriceBySelectedSellDiscountPriceIndex()
                //discountPriceAndMoneyTypeStr value always "2.01" like this, not "2.01 USD"

                sellDiscountPrice = textEditingControllerToDouble(controller: discountPriceAndMoneyTypeController)!;
              }
            }

            final double qtyXDiscountPrice = double.parse(
              formatAndLimitNumberTextGlobal(
                isRound: true,
                isAddComma: false,
                valueStr: (qtyNumber * sellDiscountPrice).toString(),
                places: findMoneyModelByMoneyType(moneyType: sellPriceModel.moneyType).decimalPlace!,
                isAllowZeroAtLast: false,
              ),
            );
            List<MainPriceQty> mainPriceQtyList = [];

            double? profitNumberOrNull = calculateProfit(
              companyNameStr: companyNameStr,
              categoryNumber: categoryNumber,
              buyAndSellDiscountRateList: buyAndSellDiscountRateListSellCardGlobal,
              mainPriceQtyList: mainPriceQtyList,
              isEqualMainAndSellPrice: isSimpleCalculate,
            );

            // for (int i = 0; i < mainPriceQtyList.length; i++) {
            //   print("mainPriceQtyList[$i].toJson() => ${mainPriceQtyList[i].toJson()}");
            // }
            final bool isValidProfitRate = (profitNumberOrNull != null);
            if (!isValidProfitRate) {
              profitNumberOrNull = 0;
            }
            // print("profitNumberOrNull => $profitNumberOrNull");

            final SellPriceSellCardModel sellPrice = SellPriceSellCardModel(
              value: sellPriceModel.value,
              discountValue: sellDiscountPriceAndMoneyTypeStr,
              moneyType: sellPriceModel.moneyType,
            );
            final int moneyTypeIndex =
                sellCardAdvanceModelTemp.moneyTypeList.indexWhere((element) => (element.calculate.moneyType == sellPriceModel.moneyType));
            final bool isHasMoneyType = (moneyTypeIndex != -1);
            if (isHasMoneyType) {
              // sellCardModelTemp.moneyTypeList[moneyTypeIndex].calculate.totalMoney += qtyXDiscountPrice;
              sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].calculate.totalMoney = double.parse(formatAndLimitNumberTextGlobal(
                valueStr: (sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].calculate.totalMoney + qtyXDiscountPrice).toString(),
                isRound: true,
                isAddComma: false,
                isAllowZeroAtLast: false,
              ));

              // sellCardModelTemp.moneyTypeList[moneyTypeIndex].calculate.totalProfit = sellCardModelTemp.moneyTypeList[moneyTypeIndex].calculate.totalProfit! + profitNumberOrNull;
              sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].calculate.totalProfit = double.parse(formatAndLimitNumberTextGlobal(
                valueStr: (sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].calculate.totalProfit! + profitNumberOrNull).toString(),
                isRound: true,
                isAddComma: false,
                isAllowZeroAtLast: false,
              ));
              sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList.add(CardListSellCardModel(
                cardCompanyNameId: companyNameId,
                cardCompanyName: companyNameStr,
                categoryId: categoryId,
                category: categoryNumber,
                profit: profitNumberOrNull,
                qty: qtyNumber,
                sellPrice: sellPrice,
                isValidProfitRate: isValidProfitRate,
                mainPriceQtyList: mainPriceQtyList,
                // language: language,
              ));
            } else {
              final CalculateSellCardModel calculateSellCardModel = CalculateSellCardModel(
                moneyType: sellPriceModel.moneyType,
                totalMoney: qtyXDiscountPrice,
                totalProfit: profitNumberOrNull,
                customerMoneyList: [
                  CustomerMoneyListSellCardModel(
                    moneyType: sellPriceModel.moneyType,
                    getMoneyController: TextEditingController(text: qtyXDiscountPrice.toString()),
                  )
                ],
              );
              final List<CardListSellCardModel> cardList = [
                CardListSellCardModel(
                  cardCompanyNameId: companyNameId,
                  cardCompanyName: companyNameStr,
                  categoryId: categoryId,
                  category: categoryNumber,
                  profit: profitNumberOrNull,
                  qty: qtyNumber,
                  sellPrice: sellPrice,
                  isValidProfitRate: isValidProfitRate,
                  mainPriceQtyList: mainPriceQtyList,
                  // language: language,
                )
              ];
              final MoneyTypeListSellCardModel moneyTypeListSellCardModel = MoneyTypeListSellCardModel(calculate: calculateSellCardModel, cardList: cardList);
              sellCardAdvanceModelTemp.moneyTypeList.add(moneyTypeListSellCardModel);
            }
          }
        }
      }
    }
    // sellCardModelTemp.mergeCalculate = getMergeCalculateModel(moneyTypeStr: findSpecialMoneyType()!);

    //-------------------------add mergePrice when merge is clicked---------------------------------------
    if (!_isSeparate) {
      sellCardAdvanceModelTemp.mergeCalculate ??= CalculateSellCardModel(
        totalMoney: 0,
        moneyType: moneyTypeFromSimpleCalculate ?? findSpecialMoneyType(sellCardAdvanceModelTemp: sellCardAdvanceModelTemp)!,
        customerMoneyList: [],
        isDone: isSimpleCalculate,
      );
      final String moneyTypeStr = sellCardAdvanceModelTemp.mergeCalculate!.moneyType;
      double totalMoneyNumber = 0;
      for (int moneyTypeCalculateIndex = 0; moneyTypeCalculateIndex < sellCardAdvanceModelTemp.moneyTypeList.length; moneyTypeCalculateIndex++) {
        final String moneyTypeInsideStr = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeCalculateIndex].calculate.moneyType;
        double totalMoneyInsideNumber = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeCalculateIndex].calculate.totalMoney;
        final bool isNotMatchMoneyTypeInAndOutSide = (moneyTypeStr != moneyTypeInsideStr);
        if (isNotMatchMoneyTypeInAndOutSide) {
          final RateForCalculateModel? rateForCalculateModel = getDiscountRateForCalculateModel(
            rateTypeFirst: moneyTypeStr,
            rateTypeLast: moneyTypeInsideStr,
            buyAndSellDiscountRateList: buyAndSellDiscountRateListSellCardGlobal,
          );
          if (rateForCalculateModel == null) {
            totalMoneyInsideNumber = 0;
          } else {
            sellCardAdvanceModelTemp.moneyTypeList[moneyTypeCalculateIndex].rate = cloneRateForCalculate(rateForCalculate: rateForCalculateModel);
            final bool isBuyRate = rateForCalculateModel.isBuyRate!;
            final double? rateDiscountNumberOrNull = textEditingControllerToDouble(controller: rateForCalculateModel.discountValue);

            final bool isRateDiscountNumberNull = (rateDiscountNumberOrNull == null);
            if (isRateDiscountNumberNull) {
              totalMoneyInsideNumber = 0;
            } else {
              if (isBuyRate) {
                totalMoneyInsideNumber = totalMoneyInsideNumber / rateDiscountNumberOrNull;
              } else {
                totalMoneyInsideNumber = totalMoneyInsideNumber * rateDiscountNumberOrNull;
              }
            }
          }
        }
        // sellCardModelTemp.moneyTypeList[moneyTypeCalculateIndex].calculate.convertMoney = totalMoneyInsideNumber;
        sellCardAdvanceModelTemp.moneyTypeList[moneyTypeCalculateIndex].calculate.convertMoney = double.parse(formatAndLimitNumberTextGlobal(
          valueStr: totalMoneyInsideNumber.toString(),
          isRound: true,
          isAddComma: false,
          isAllowZeroAtLast: false,
        ));

        // totalMoneyNumber += totalMoneyInsideNumber;
        totalMoneyNumber = double.parse(formatAndLimitNumberTextGlobal(
            valueStr: (totalMoneyNumber + totalMoneyInsideNumber).toString(),
            isRound: true,
            isAddComma: false,
            isAllowZeroAtLast: false,
            places: findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!));
      }
      final CustomerMoneyListSellCardModel customerMoneyListSellCardModel = CustomerMoneyListSellCardModel(
        moneyType: moneyTypeStr,
        getMoneyController: TextEditingController(text: totalMoneyNumber.toString()),
      );
      totalMoneyNumber = double.parse(formatAndLimitNumberTextGlobal(
        valueStr: totalMoneyNumber.toString(),
        isRound: true,
        isAddComma: false,
        places: findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!,
        isAllowZeroAtLast: false,
      ));
      sellCardAdvanceModelTemp.mergeCalculate =
          CalculateSellCardModel(totalMoney: totalMoneyNumber, moneyType: moneyTypeStr, customerMoneyList: [customerMoneyListSellCardModel]);

      // final String moneyTypeStr = sellCardModelTemp.mergeCalculate!.moneyType;
      // double totalMoneyNumber = 0;
      // for (int moneyTypeCalculateIndex = 0; moneyTypeCalculateIndex < sellCardModelTemp.moneyTypeList.length; moneyTypeCalculateIndex++) {
      //   final String moneyTypeInsideStr = sellCardModelTemp.moneyTypeList[moneyTypeCalculateIndex].calculate.moneyType;
      //   double totalMoneyInsideNumber = sellCardModelTemp.moneyTypeList[moneyTypeCalculateIndex].calculate.totalMoney;
      //   final bool isNotMatchMoneyTypeInAndOutSide = (moneyTypeStr != moneyTypeInsideStr);
      //   if (isNotMatchMoneyTypeInAndOutSide) {
      //     final RateForCalculateModel? rateForCalculateModel = getDiscountRateForCalculateModel(
      //       rateTypeFirst: moneyTypeStr,
      //       rateTypeLast: moneyTypeInsideStr,
      //       buyAndSellDiscountRateList: buyAndSellDiscountRateList,
      //     );
      //     sellCardModelTemp.moneyTypeList[moneyTypeCalculateIndex].rate = cloneRateForCalculate(rateForCalculate: rateForCalculateModel!);
      //     final bool isBuyRate = rateForCalculateModel.isBuyRate!;
      //     final double? rateDiscountNumberOrNull = textEditingControllerToDouble(controller: rateForCalculateModel.discountValue);

      //     final bool isRateDiscountNumberNull = (rateDiscountNumberOrNull == null);
      //     if (isRateDiscountNumberNull) {
      //       totalMoneyInsideNumber = 0;
      //     } else {
      //       if (isBuyRate) {
      //         totalMoneyInsideNumber = totalMoneyInsideNumber / rateDiscountNumberOrNull;
      //       } else {
      //         totalMoneyInsideNumber = totalMoneyInsideNumber * rateDiscountNumberOrNull;
      //       }
      //     }
      //   }
      //   // sellCardModelTemp.moneyTypeList[moneyTypeCalculateIndex].calculate.convertMoney = totalMoneyInsideNumber;
      //   sellCardModelTemp.moneyTypeList[moneyTypeCalculateIndex].calculate.convertMoney = double.parse(formatAndLimitNumberTextGlobal(
      //     valueStr: totalMoneyInsideNumber.toString(),
      //     isRound: true,
      //     isAddComma: false,
      //     isAllowZeroAtLast: false,
      //   ));

      //   // totalMoneyNumber += totalMoneyInsideNumber;
      //   totalMoneyNumber = double.parse(formatAndLimitNumberTextGlobal(
      //       valueStr: (totalMoneyNumber + totalMoneyInsideNumber).toString(),
      //       isRound: true,
      //       isAddComma: false,
      //       isAllowZeroAtLast: false,
      //       places: findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!));
      // }
      // final CustomerMoneyListSellCardModel customerMoneyListSellCardModel = CustomerMoneyListSellCardModel(moneyType: moneyTypeStr);
      // totalMoneyNumber = double.parse(formatAndLimitNumberTextGlobal(
      //   valueStr: totalMoneyNumber.toString(),
      //   isRound: true,
      //   isAddComma: false,
      //   places: findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!,
      //   isAllowZeroAtLast: false,
      // ));
      // sellCardModelTemp.mergeCalculate = CalculateSellCardModel(totalMoney: totalMoneyNumber, moneyType: moneyTypeStr, customerMoneyList: [customerMoneyListSellCardModel]);
    }

    //-------------------------sell card model to table column and row---------------------------------------
    for (int moneyTypeCalculateIndex = 0; moneyTypeCalculateIndex < sellCardAdvanceModelTemp.moneyTypeList.length; moneyTypeCalculateIndex++) {
      for (int cardInsideIndex = 0; cardInsideIndex < sellCardAdvanceModelTemp.moneyTypeList[moneyTypeCalculateIndex].cardList.length; cardInsideIndex++) {
        final String companyNameStr = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeCalculateIndex].cardList[cardInsideIndex].cardCompanyName;
        final int qtyNumber = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeCalculateIndex].cardList[cardInsideIndex].qty;
        final double categoryNumber = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeCalculateIndex].cardList[cardInsideIndex].category;

        List<MoneyTypeAndValueModel> moneyTypeAndValueModelList = getCardPriceOnlyList(companyNameStr: companyNameStr, categoryNumber: categoryNumber);

        List<String> menuItemSellPriceStrList = [];
        for (int moneyTypeAndValueModelIndex = 0; moneyTypeAndValueModelIndex < moneyTypeAndValueModelList.length; moneyTypeAndValueModelIndex++) {
          final String priceStr = formatAndLimitNumberTextGlobal(
            valueStr: moneyTypeAndValueModelList[moneyTypeAndValueModelIndex].value.toString(),
            isRound: false,
            isAllowZeroAtLast: false,
          );
          final String moneyTypeStr = moneyTypeAndValueModelList[moneyTypeAndValueModelIndex].moneyType;
          final String priceAndMoneyTypeStr = "$priceStr$spaceStrGlobal$moneyTypeStr";
          menuItemSellPriceStrList.add(priceAndMoneyTypeStr);
        }

        final int selectedSellPriceIndex = getSelectedSellPriceIndex(companyNameStr: companyNameStr, categoryNumber: categoryNumber);
        List<MoneyTypeAndValueModel> moneyTypeAndDiscountValueModelList =
            getCardDiscountPriceOnlyList(companyNameStr: companyNameStr, categoryNumber: categoryNumber);
        List<String> menuItemSellDiscountPriceStrList = [];
        for (int moneyTypeAndDiscountValueModelIndex = 0;
            moneyTypeAndDiscountValueModelIndex < moneyTypeAndDiscountValueModelList.length;
            moneyTypeAndDiscountValueModelIndex++) {
          final String priceStr = formatAndLimitNumberTextGlobal(
            valueStr: moneyTypeAndDiscountValueModelList[moneyTypeAndDiscountValueModelIndex].value.toString(),
            isRound: false,
            isAllowZeroAtLast: false,
          );
          final String moneyTypeStr = moneyTypeAndDiscountValueModelList[moneyTypeAndDiscountValueModelIndex].moneyType;
          final String priceAndMoneyTypeStr = "$priceStr$spaceStrGlobal$moneyTypeStr";
          menuItemSellDiscountPriceStrList.add(priceAndMoneyTypeStr);
        }
        final List<List<String>> menuItemStr2D = [[], [], menuItemSellPriceStrList, menuItemSellDiscountPriceStrList, [], []];
        menuItemStr3DSellCardGlobal.add(menuItemStr2D);

        List<TextEditingController> textFieldControllerList = [];
        final String categoryStr = formatAndLimitNumberTextGlobal(
          valueStr: categoryNumber.toString(),
          isRound: false,
          isAllowZeroAtLast: false,
        );
        final TextEditingController companyXCategoryStr = TextEditingController(text: "$companyNameStr$betweenCardCompanyNameAndCategoryStrGlobal$categoryStr");
        textFieldControllerList.add(companyXCategoryStr);

        final List<bool> isShowTextFieldList = [
          false,
          false,
          false,
          getIsShowTextField(companyNameStr: companyNameStr, categoryNumber: categoryNumber),
          false,
          false
        ];
        isShowTextField2DSellCardGlobal.add(isShowTextFieldList);

        final String qtyStr = formatAndLimitNumberTextGlobal(valueStr: qtyNumber.toString(), isRound: false, isAllowZeroAtLast: false);
        textFieldControllerList.add(TextEditingController(text: qtyStr));

        textFieldControllerList.add(TextEditingController(text: menuItemSellPriceStrList[selectedSellPriceIndex]));

        final String discountPriceAndMoneyTypeStr =
            sellCardAdvanceModelTemp.moneyTypeList[moneyTypeCalculateIndex].cardList[cardInsideIndex].sellPrice.discountValue;
        double discountPriceNumber = 0;
        final bool isShowTextField = getIsShowTextField(companyNameStr: companyNameStr, categoryNumber: categoryNumber);
        if (isShowTextField) {
          if (discountPriceAndMoneyTypeStr.isNotEmpty) {
            discountPriceNumber = double.parse(
                formatAndLimitNumberTextGlobal(isAddComma: false, valueStr: discountPriceAndMoneyTypeStr, isRound: false, isAllowZeroAtLast: false));
            textFieldControllerList.add(TextEditingController(text: discountPriceAndMoneyTypeStr));
          } else {
            textFieldControllerList.add(TextEditingController(text: null));
          }
        } else {
          if (discountPriceAndMoneyTypeStr.isNotEmpty) {
            discountPriceNumber = convertStringToMoneyTypeAndValueModel(priceAndMoneyTypeStr: discountPriceAndMoneyTypeStr).value;
            final int selectedSellDiscountPriceIndex = getSelectedSellDiscountPriceIndex(companyNameStr: companyNameStr, categoryNumber: categoryNumber);

            textFieldControllerList.add(TextEditingController(text: menuItemSellDiscountPriceStrList[selectedSellDiscountPriceIndex]));
          } else {
            textFieldControllerList.add(TextEditingController(text: null));
          }
        }
        final String moneyTypeProfitAndTotalStr = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeCalculateIndex].calculate.moneyType;
        final int place = findMoneyModelByMoneyType(moneyType: moneyTypeProfitAndTotalStr).decimalPlace!;
        final String profitStr = formatAndLimitNumberTextGlobal(
          valueStr: sellCardAdvanceModelTemp.moneyTypeList[moneyTypeCalculateIndex].cardList[cardInsideIndex].profit.toString(),
          isRound: false,
          places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
          isAllowZeroAtLast: false,
        );

        final bool isValidProfitRate = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeCalculateIndex].cardList[cardInsideIndex].isValidProfitRate;
        final String profitAndMoneyTypeStr = isValidProfitRate ? "$profitStr$spaceStrGlobal$moneyTypeProfitAndTotalStr" : errorStrGlobal;
        textFieldControllerList.add(TextEditingController(text: profitAndMoneyTypeStr));

        final String moneyTypeQtyXPriceStr = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeCalculateIndex].calculate.moneyType;
        final String qtyXPriceStr = formatAndLimitNumberTextGlobal(
          valueStr: (discountPriceNumber * qtyNumber).toString(),
          isRound: true,
          places: findMoneyModelByMoneyType(moneyType: moneyTypeProfitAndTotalStr).decimalPlace!,
          isAllowZeroAtLast: false,
        );
        final String qtyXPriceAndMoneyTypeStr = "$qtyXPriceStr$spaceStrGlobal$moneyTypeQtyXPriceStr";
        textFieldControllerList.add(TextEditingController(text: qtyXPriceAndMoneyTypeStr));
        textFieldController2DSellCardGlobal.add(textFieldControllerList);
      }
    }
  }

  @override
  void initState() {
    initRateDiscountList();
    // void initCardToTempDB() {
    //   bool isEmptyCard = cardModelListAdminGlobal.isEmpty;
    //   if (isEmptyCard) {
    //     void callback() {
    //       _isLoadingOnInitCard = false;
    //       initRateDiscountList();
    //       setState(() {});
    //     }

    //     initCardAdminOrEmployeeGlobal(callBack: callback, context: context, isAdminQuery: false);
    //   } else {
    //     _isLoadingOnInitCard = false;
    //   }
    // }

    // initCardToTempDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      Widget inWrapWidgetList() {
        Widget cardButtonWidget({required int cardIndex}) {
          Widget setWidthSizeBox() {
            Widget insideSizeBoxWidget() {
              Widget scrollTextWidget() {
                return scrollText(
                  textStr: cardModelListGlobal[cardIndex].cardCompanyName.text,
                  textStyle: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                  alignment: Alignment.topLeft,
                );
              }

              Widget categoryListWidget() {
                Widget paddingTopWidget({required int categoryIndex}) {
                  Widget textFieldAndChooseWidget() {
                    void queryMoreStock({required int qtyNumber, required Function callback}) async {
                      final int fullStockNumber = cardModelListGlobal[cardIndex].categoryList[categoryIndex].totalStock;
                      if (qtyNumber <= fullStockNumber) {
                        int subTotalNumber = 0;
                        do {
                          for (int stockIndex = 0; stockIndex < cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList.length; stockIndex++) {
                            final TextEditingController stockController =
                                cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList[stockIndex].stock;
                            subTotalNumber = subTotalNumber + textEditingControllerToInt(controller: stockController)!;
                          }
                          if (subTotalNumber < qtyNumber) {
                            await getMoreMainStockWithCondition(
                              targetDate: DateTime.now(),
                              isAdminQuery: false,
                              cardCompanyNameId: cardModelListGlobal[cardIndex].id!,
                              categoryId: cardModelListGlobal[cardIndex].categoryList[categoryIndex].id!,
                              categoryCardModel: cardModelListGlobal[cardIndex].categoryList[categoryIndex],
                              context: context,
                              setStateFromDialog: setState,
                            );
                          }
                          //[0]: 216 < 250
                        } while (subTotalNumber < qtyNumber);
                      }
                      callback();
                    }

                    Widget textFieldWidget() {
                      void onTapFromOutsiderFunction() {}
                      final String qtyTemp = cardModelListGlobal[cardIndex].categoryList[categoryIndex].qty.text;
                      return textFieldGlobal(
                        textFieldDataType: TextFieldDataType.int,
                        controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].qty,
                        onChangeFromOutsiderFunction: () {
                          final String qtyChangeTemp = cardModelListGlobal[cardIndex].categoryList[categoryIndex].qty.text;
                          final String cardCompanyNameStr = cardModelListGlobal[cardIndex].cardCompanyName.text;
                          final String categoryStr = cardModelListGlobal[cardIndex].categoryList[categoryIndex].category.text;
                          addActiveLogElement(
                            activeLogModelList: activeLogModelSellCardList,
                            activeLogModel: ActiveLogModel(
                              idTemp: "qty order, $cardCompanyNameStr x $categoryStr",
                              activeType: ActiveLogTypeEnum.typeTextfield,
                              locationList: [
                                Location(title: "card", subtitle: "$cardCompanyNameStr x $categoryStr"),
                                Location(
                                  color: (qtyTemp.length < qtyChangeTemp.length) ? ColorEnum.green : ColorEnum.red,
                                  title: "textfield order qty",
                                  subtitle: "${qtyTemp.isEmpty ? "" : "$qtyTemp to "}$qtyChangeTemp",
                                ),
                              ],
                            ),
                          );
                          if (cardModelListGlobal[cardIndex].categoryList[categoryIndex].qty.text.isNotEmpty) {
                            queryMoreStock(
                              qtyNumber: textEditingControllerToInt(controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].qty)!,
                              callback: () {
                                calculateSellCardListByMoneyTypeFunction();
                                // limitMainStockList(categoryCardModel: cardModelListGlobal[cardIndex].categoryList[categoryIndex]);
                              },
                            );
                          } else {
                            calculateSellCardListByMoneyTypeFunction();
                          }
                        },
                        labelText: "$qtyCardStrGlobal (${cardModelListGlobal[cardIndex].categoryList[categoryIndex].category.text})",
                        level: Level.mini,
                        onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                      );
                    }

                    Widget paddingChooseWidget() {
                      final TextEditingController qtyController = cardModelListGlobal[cardIndex].categoryList[categoryIndex].qty;
                      Widget buttonListWidget() {
                        Widget buttonWidget({required int qtySuggestion}) {
                          String qtySuggestionStr = formatAndLimitNumberTextGlobal(valueStr: qtySuggestion.toString(), isRound: false);
                          void onTapUnlessDisableAndValid() {
                            qtyController.text = qtySuggestionStr;
                            queryMoreStock(
                              qtyNumber: textEditingControllerToInt(controller: qtyController)!,
                              callback: () {
                                final String cardCompanyNameStr = cardModelListGlobal[cardIndex].cardCompanyName.text;
                                final String categoryStr = cardModelListGlobal[cardIndex].categoryList[categoryIndex].category.text;
                                addActiveLogElement(
                                  activeLogModelList: activeLogModelSellCardList,
                                  activeLogModel: ActiveLogModel(
                                    idTemp: "qty order, $cardCompanyNameStr x $categoryStr",
                                    activeType: ActiveLogTypeEnum.clickButton,
                                    locationList: [
                                      Location(title: "card", subtitle: "$cardCompanyNameStr x $categoryStr"),
                                      Location(color: ColorEnum.blue, title: "button qty", subtitle: qtySuggestionStr),
                                    ],
                                  ),
                                );

                                calculateSellCardListByMoneyTypeFunction();
                                // limitMainStockList(categoryCardModel: cardModelListGlobal[cardIndex].categoryList[categoryIndex]);
                              },
                            );
                          }

                          return Padding(
                            padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
                            child: buttonGlobal(
                                context: context, textStr: qtySuggestionStr, level: Level.mini, onTapUnlessDisableAndValid: onTapUnlessDisableAndValid),
                          );
                        }

                        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          buttonWidget(qtySuggestion: 1),
                          buttonWidget(qtySuggestion: 5),
                          buttonWidget(qtySuggestion: 10),
                          buttonWidget(qtySuggestion: 20)
                        ]);
                      }

                      return (qtyController.text.isEmpty || qtyController.text == "0") ? buttonListWidget() : Container();
                    }

                    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: textFieldWidget()), paddingChooseWidget()]);
                  }

                  return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)), child: textFieldAndChooseWidget());
                }

                return SingleChildScrollView(
                    child: Column(children: [
                  for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++)
                    paddingTopWidget(categoryIndex: categoryIndex)
                ]));
              }

              return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [scrollTextWidget(), Expanded(child: categoryListWidget())]);
            }

            void onTapUnlessDisable() {}

            return CustomButtonGlobal(sizeBoxWidth: sizeBoxWidthGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
          }

          return (cardModelListGlobal[cardIndex].deletedDate != null)
              ? Container()
              : Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)), child: setWidthSizeBox());
        }

        return Padding(
          padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal), bottom: paddingSizeGlobal(level: Level.large)),
          child: Container(
            height: sizeBoxHeightGlobal * 1.25,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                  child: Row(children: [
                    for (int currencyIndex = 0; currencyIndex < cardModelListGlobal.length; currencyIndex++) cardButtonWidget(cardIndex: currencyIndex)
                  ]),
                )),
          ),
        );
      }

      String createRemakeOnTapFunction({required SellCardModel sellCardAdvanceModelTemp}) {
        sellCardAdvanceModelTemp.remark.text = " \n ";
        // if (_isSeparate) {
        for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTemp.moneyTypeList.length; moneyTypeIndex++) {
          final isMergePrice = (sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].rate != null);
          for (int cardIndex = 0; cardIndex < sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList.length; cardIndex++) {
            final CardListSellCardModel cardListSellCardModel = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].cardList[cardIndex];
            final String cardCompanyName = cardListSellCardModel.cardCompanyName;
            final String category = formatAndLimitNumberTextGlobal(valueStr: cardListSellCardModel.category.toString(), isRound: false);
            String moneyType = cardListSellCardModel.sellPrice.moneyType;
            final String qty = formatAndLimitNumberTextGlobal(valueStr: cardListSellCardModel.qty.toString(), isRound: false);
            double sellPriceNumber = double.parse(formatTextToNumberStrGlobal(valueStr: cardListSellCardModel.sellPrice.discountValue));
            if (isMergePrice) {
              final String rateTypeFirst = sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].rate!.rateType.first;
              final double rateDiscountValue =
                  double.parse(formatTextToNumberStrGlobal(valueStr: sellCardAdvanceModelTemp.moneyTypeList[moneyTypeIndex].rate!.discountValue.text));
              final bool isMulti = (rateTypeFirst == moneyType);
              sellPriceNumber = isMulti ? (sellPriceNumber * rateDiscountValue) : (sellPriceNumber / rateDiscountValue);
              moneyType = sellCardAdvanceModelTemp.mergeCalculate!.moneyType;
            }
            final int place = findMoneyModelByMoneyType(moneyType: moneyType).decimalPlace!;
            final String sellPrice = formatAndLimitNumberTextGlobal(
              valueStr: sellPriceNumber.toString(),
              places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
              isRound: true,
            );
            final String total = formatAndLimitNumberTextGlobal(
              valueStr: (cardListSellCardModel.qty * sellPriceNumber).toString(),
              places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
              isRound: true,
            );

            sellCardAdvanceModelTemp.remark.text += "$cardCompanyName x $category: \n  $qty x $sellPrice = $total $moneyType \n ";
          }
        }
        return sellCardAdvanceModelTemp.remark.text;
        // }
      }

      void advanceCalculateOnTapFunction() {
        _isSeparate = true;
        _isInitCard = true;
        bool isAllowAnalysis = true;
        sellCardAdvanceModelTempSellCardGlobal = SellCardModel(activeLogModelList: [], moneyTypeList: [], remark: TextEditingController());
        buyAndSellDiscountRateListSellCardGlobal = [];

        bool getValidCard() {
          for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTempSellCardGlobal.moneyTypeList.length; moneyTypeIndex++) {
            final double totalNumber = sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].calculate.totalMoney;
            final bool isTotalNotEmptyOrNegative = (totalNumber <= 0);
            if (isTotalNotEmptyOrNegative) {
              return false;
            }
          }
          return true;
        }

        ValidButtonModel checkAnalysisExchangeValidate() {
          if (!isAllowAnalysis) {
            return ValidButtonModel(isValid: false, error: "Please wait $delayApiRequestSecond seconds before analysis.");
          }

          final ValidButtonModel getValidGetMoneyFormCustomerModel = getValidGetMoneyFormCustomerFunction(
            isSimpleCalculate: false,
            sellCardAdvanceModelTemp: sellCardAdvanceModelTempSellCardGlobal,
          );
          if (getValidGetMoneyFormCustomerModel.isValid) {
            for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTempSellCardGlobal.moneyTypeList.length; moneyTypeIndex++) {
              for (int cardIndex = 0; cardIndex < sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList.length; cardIndex++) {
                for (int mainPriceQtyIndex = 0;
                    mainPriceQtyIndex < sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList.length;
                    mainPriceQtyIndex++) {
                  final bool isHasRate =
                      (sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList[mainPriceQtyIndex].rate !=
                          null);
                  if (isHasRate) {
                    // return true;
                    return ValidButtonModel(isValid: true);
                  }
                }
              }
            }
            bool checkRateHasOrNot({required List<CustomerMoneyListSellCardModel> customerMoneyList}) {
              for (int customMoneyIndex = 0; customMoneyIndex < customerMoneyList.length; customMoneyIndex++) {
                final bool isHasRate = (customerMoneyList[customMoneyIndex].rate != null);
                if (isHasRate) {
                  return true;
                }
              }
              return false;
            }

            for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTempSellCardGlobal.moneyTypeList.length; moneyTypeIndex++) {
              final bool isHasTotalRate = (sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].rate != null);
              if (isHasTotalRate) {
                // return true;
                return ValidButtonModel(isValid: true);
              }

              // final bool isHasRate = checkRateHasOrNot(customerMoneyList: sellCardModelTemp.moneyTypeList[moneyTypeIndex].calculate.customerMoneyList);
              // if (isHasRate) {
              //   return true;
              // }
            }
            if (_isSeparate) {
              for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTempSellCardGlobal.moneyTypeList.length; moneyTypeIndex++) {
                // final bool isHasTotalRate = (sellCardModelTemp.moneyTypeList[moneyTypeIndex].rate != null);
                // if (isHasTotalRate) {
                //   return true;
                // }

                final bool isHasRate =
                    checkRateHasOrNot(customerMoneyList: sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].calculate.customerMoneyList);
                if (isHasRate) {
                  // return true;
                  return ValidButtonModel(isValid: true);
                }
              }
            } else {
              final bool isHasRate = checkRateHasOrNot(customerMoneyList: sellCardAdvanceModelTempSellCardGlobal.mergeCalculate!.customerMoneyList);
              if (isHasRate) {
                // return true;
                return ValidButtonModel(isValid: true);
              }
            }
            // return false;
            return ValidButtonModel(isValid: false, error: "no rate relate or customer does not give enough money.");
          } else {
            // return false;
            return getValidGetMoneyFormCustomerModel;
          }
        }

        bool isShowProfitDetail = false;
        Widget calculateCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          if (_isInitCard) {
            _isInitCard = false;
            sellCardAdvanceModelTempSellCardGlobal.moneyTypeList = [];
            textFieldController2DSellCardGlobal = [];
            menuItemStr3DSellCardGlobal = [];
            isShowTextField2DSellCardGlobal = [];

            initSellCardModel(isSimpleCalculate: false, sellCardAdvanceModelTemp: sellCardAdvanceModelTempSellCardGlobal);
          }
          void clearExchangeAnalysisCard() {
            final bool isClearExchange = !checkAnalysisExchangeValidate().isValid;
            if (isClearExchange) {
              exchangeAnalysisCardSellCardGlobal = ExchangeMoneyModel(activeLogModelList: [], exchangeList: [], remark: TextEditingController());
              setStateFromDialog(() {});
            }
          }

          clearExchangeAnalysisCard();

          Widget paddingBottomTableAndGetMoneyWidget() {
            Widget tableCardListAndGetMoneyWidget() {
              Widget yesNoButton({
                required bool isShowYesButton,
                required bool isShowButton,
                required CalculateSellCardModel? calculateSellCardModel,
                required TextEditingController? getMoneyController,
              }) {
                Widget doneAndNextAndXWidget() {
                  Widget paddingRightTopShowDoneTextProviderWidget() {
                    Widget showDoneTextProviderWidget() {
                      final int lastCustomerMoneyIndex = (calculateSellCardModel!.customerMoneyList.length - 1);
                      bool isDone = false;
                      if (calculateSellCardModel.customerMoneyList[lastCustomerMoneyIndex].giveMoney != null) {
                        isDone = (calculateSellCardModel.customerMoneyList[lastCustomerMoneyIndex].giveMoney! <= 0);
                      }
                      bool isShowDoneText = false;
                      if (lastCustomerMoneyIndex > 0) {
                        isShowDoneText = (calculateSellCardModel.customerMoneyList[lastCustomerMoneyIndex - 1].giveMoney! <= 0);
                      }
                      Widget doneTextWidget() {
                        return Text(doneStrGlobal, style: textStyleGlobal(level: Level.normal, color: doneTextColorGlobal));
                      }

                      Widget showYestButtonProviderWidget() {
                        Widget doneOrNextButtonProviderWidget() {
                          void onTapFunction() {
                            addActiveLogElement(
                              activeLogModelList: activeLogModelSellCardList,
                              activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
                                Location(title: "get money index", subtitle: lastCustomerMoneyIndex.toString()),
                                Location(title: "money type", subtitle: calculateSellCardModel.moneyType),
                                Location(color: isDone ? ColorEnum.blue : ColorEnum.green, title: "button name", subtitle: "${isDone ? "ok" : "next"} button"),
                              ]),
                            );

                            // final double giveMoneyNumber = calculateSellCardModel.customerMoneyList[lastCustomerMoneyIndex].giveMoney!;
                            // final bool isHasChange = (giveMoneyNumber < 0);
                            // if (!isHasChange) {
                            final String currentMoneyType = calculateSellCardModel.customerMoneyList[lastCustomerMoneyIndex].moneyType!;
                            calculateSellCardModel.customerMoneyList.add(
                              CustomerMoneyListSellCardModel(moneyType: currentMoneyType, getMoneyController: TextEditingController()),
                            );
                            // }
                            calculateSellCardModel.isDone = true;
                            calculateSellCardModel.isActive = true;
                            getMoneyController!.clear();

                            setStateFromDialog(() {});
                          }

                          return isDone
                              ? okButtonOrContainerWidget(context: context, level: Level.mini, onTapFunction: onTapFunction)
                              : nextButtonOrContainerWidget(context: context, level: Level.mini, onTapFunction: onTapFunction);
                        }

                        return isShowYesButton ? doneOrNextButtonProviderWidget() : Container();
                      }

                      return isShowDoneText ? doneTextWidget() : showYestButtonProviderWidget();
                    }

                    return Padding(
                      padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini), top: paddingSizeGlobal(level: Level.normal)),
                      child: showDoneTextProviderWidget(),
                    );
                  }

                  Widget paddingToDeleteWidget() {
                    Widget deleteButtonWidget() {
                      void onTapFunction() {
                        calculateSellCardModel!.customerMoneyList.removeLast();
                        if (calculateSellCardModel.customerMoneyList.isNotEmpty) {
                          calculateSellCardModel.customerMoneyList.removeLast();
                        }
                        String previousMoneyType = calculateSellCardModel.moneyType;
                        if (calculateSellCardModel.customerMoneyList.isNotEmpty) {
                          final int lastCustomerMoneyIndex = (calculateSellCardModel.customerMoneyList.length - 1);
                          previousMoneyType = calculateSellCardModel.customerMoneyList[lastCustomerMoneyIndex].moneyType!;
                        }
                        calculateSellCardModel.customerMoneyList.add(
                          CustomerMoneyListSellCardModel(moneyType: previousMoneyType, getMoneyController: TextEditingController()),
                        );
                        getMoneyController!.clear();
                        calculateSellCardModel.isDone = false;
                        calculateSellCardModel.isActive = true;
                        addActiveLogElement(
                          activeLogModelList: activeLogModelSellCardList,
                          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
                            Location(title: "get money index", subtitle: (calculateSellCardModel.customerMoneyList.length - 1).toString()),
                            Location(title: "money type", subtitle: calculateSellCardModel.moneyType),
                            Location(color: ColorEnum.red, title: "button name", subtitle: "delete button"),
                          ]),
                        );
                        setStateFromDialog(() {});
                      }

                      return deleteButtonOrContainerWidget(context: context, level: Level.mini, onTapFunction: onTapFunction);
                    }

                    return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)), child: deleteButtonWidget());
                  }

                  return Row(mainAxisAlignment: MainAxisAlignment.end, children: [paddingRightTopShowDoneTextProviderWidget(), paddingToDeleteWidget()]);
                }

                return isShowButton ? doneAndNextAndXWidget() : Container();
              }

              Widget calculateResult({
                required String operatorStr,
                required double getMoneyNumber,
                required String getMoneyType,
                required double giveMoneyNumber,
                required String giveMoneyType,
                required bool isShowYesButton,
                required bool isShowButton,
                required CalculateSellCardModel? calculateSellCardModel,
                required TextEditingController? getMoneyController,
              }) {
                final TextStyle textStyle = textStyleGlobal(level: Level.normal);
                final String getMoneyStr = formatAndLimitNumberTextGlobal(valueStr: getMoneyNumber.toString(), isRound: false, isAllowZeroAtLast: false);
                final String giveMoneyStr = formatAndLimitNumberTextGlobal(valueStr: giveMoneyNumber.toString(), isRound: false, isAllowZeroAtLast: false);
                final double givenTextWidth = findTextSize(text: "$getMoneyStr $getMoneyType", style: textStyle).width + 30;
                final double resultTextWidth = findTextSize(text: "$giveMoneyStr $giveMoneyType", style: textStyle).width + 30;
                final double textWidthLongest = (givenTextWidth > resultTextWidth) ? givenTextWidth : resultTextWidth;

                Widget minusOrMultiAndResultWidget() {
                  Widget operatorAndNumberWidget() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 30,
                          width: textWidthLongest,
                          child: Stack(
                            children: [
                              Positioned(top: -5, left: 0, child: Text(operatorStr, style: textStyle)),
                              Positioned(bottom: 0, right: 0, child: Text("$getMoneyStr $getMoneyType", style: textStyle)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  Widget lineAndNumberWidget() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 30,
                          width: textWidthLongest,
                          child: Stack(
                            children: [
                              Positioned(top: 1, left: 0, child: drawLineGlobal(width: textWidthLongest)),
                              Positioned(bottom: 0, right: 0, child: Text("$giveMoneyStr $giveMoneyType", style: textStyle)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(children: [
                    operatorAndNumberWidget(),
                    lineAndNumberWidget(),
                    yesNoButton(
                      isShowYesButton: isShowYesButton,
                      isShowButton: isShowButton,
                      calculateSellCardModel: calculateSellCardModel,
                      getMoneyController: getMoneyController,
                    )
                  ]);
                }

                final bool isGetMoneyNumberEqual0 = (getMoneyNumber == 0);
                return (isGetMoneyNumberEqual0) ? Container() : minusOrMultiAndResultWidget();
              }

              bool getIsNoMergeRateValue() {
                bool isNoRateValue = false;
                final String moneyType = findSpecialMoneyType(sellCardAdvanceModelTemp: sellCardAdvanceModelTempSellCardGlobal)!;
                for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTempSellCardGlobal.moneyTypeList.length; moneyTypeIndex++) {
                  final String moneyTypeInside = sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].calculate.moneyType;
                  final bool isRateTypeNotMatch = (moneyType != moneyTypeInside);
                  if (isRateTypeNotMatch) {
                    final RateForCalculateModel? rateForCalculateModel = getDiscountRateForCalculateModel(
                      rateTypeFirst: moneyType,
                      rateTypeLast: moneyTypeInside,
                      buyAndSellDiscountRateList: buyAndSellDiscountRateListSellCardGlobal,
                    );
                    if (rateForCalculateModel != null) {
                      final bool isDiscountEmpty = rateForCalculateModel.discountValue.text.isEmpty;
                      if (isDiscountEmpty) {
                        isNoRateValue = true;
                        break;
                      }
                    }
                  }
                }
                return isNoRateValue;
              }

              Widget paddingRightTableAndRateDiscountListWidget() {
                Widget tableAndRateDiscountListWidget() {
                  Widget tableWidget() {
                    void convertTableIntoSellPriceCardModel({
                      required List<List<TextEditingController>> controller2D,
                      required List<List<bool>> isShowTextField2D,
                      required List<List<TextEditingController>> oldController2D,
                      required List<List<bool>> oldIsShowTextField2D,
                      required int verticalIndex,
                      required int horizontalIndex,
                      required ActiveLogTypeEnum activeLog,
                    }) {
                      final String oldStr = oldController2D[verticalIndex][horizontalIndex].text;
                      final String newStr = controller2D[verticalIndex][horizontalIndex].text;

                      final String cardCompanyNameStr = oldController2D[verticalIndex].first.text;
                      if (horizontalIndex == 2) {
                        addActiveLogElement(
                          activeLogModelList: activeLogModelSellCardList,
                          activeLogModel: ActiveLogModel(
                            idTemp: "card price, $cardCompanyNameStr",
                            activeType: ActiveLogTypeEnum.selectDropdown,
                            locationList: [
                              Location(title: "card calculation", subtitle: "advance calculation"),
                              Location(title: "card", subtitle: cardCompanyNameStr),
                              Location(title: "price dropdown", subtitle: "${oldStr.isEmpty ? "" : "$oldStr to "}${(oldStr == newStr) ? "other" : newStr}"),
                            ],
                          ),
                        );
                      } else if (horizontalIndex == 3) {
                        if (activeLog == ActiveLogTypeEnum.typeTextfield) {
                          addActiveLogElement(
                            activeLogModelList: activeLogModelSellCardList,
                            activeLogModel: ActiveLogModel(
                              idTemp: "card main price, $cardCompanyNameStr",
                              activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                              locationList: [
                                Location(title: "card calculation", subtitle: "advance calculation"),
                                Location(title: "card", subtitle: cardCompanyNameStr),
                                Location(
                                  color: (oldStr.length < newStr.length) ? ColorEnum.green : ColorEnum.red,
                                  title: "price discount textfield",
                                  subtitle: "${oldStr.isEmpty ? "" : "$oldStr to "}$newStr",
                                ),
                              ],
                            ),
                          );
                        } else if (activeLog == ActiveLogTypeEnum.clickButton) {
                          addActiveLogElement(
                            activeLogModelList: activeLogModelSellCardList,
                            activeLogModel: ActiveLogModel(
                              idTemp: "card main price, $cardCompanyNameStr",
                              activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                              locationList: [
                                Location(title: "card calculation", subtitle: "advance calculation"),
                                Location(title: "card", subtitle: cardCompanyNameStr),
                                Location(color: ColorEnum.red, title: "button name", subtitle: "discount delete button"),
                              ],
                            ),
                          );
                        } else if (activeLog == ActiveLogTypeEnum.selectDropdown) {
                          addActiveLogElement(
                            activeLogModelList: activeLogModelSellCardList,
                            isDropdownFromDropdownOrTextfield: true,
                            activeLogModel: ActiveLogModel(
                              idTemp: "card main price, $cardCompanyNameStr",
                              activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                              locationList: [
                                Location(title: "card calculation", subtitle: "advance calculation"),
                                Location(title: "card", subtitle: cardCompanyNameStr),
                                Location(
                                  title: "price discount dropdown",
                                  subtitle: "${oldStr.isEmpty ? "" : "$oldStr to "}${(oldStr == newStr) ? "other" : newStr}",
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      for (int controllerIndex = 0; controllerIndex < controller2D.length; controllerIndex++) {
                        final String companyNameXCategoryStr = controller2D[controllerIndex][0].text;
                        final String priceAndMoneyTypeStr = controller2D[controllerIndex][2].text;
                        final String discountPriceAndMoneyTypeStr = controller2D[controllerIndex][3].text;
                        final bool isShowTextField = isShowTextField2D[controllerIndex][3];
                        final CompanyNameXCategoryXStockModel companyNameXCategoryModel =
                            convertStringToCompanyNameXCategoryModel(companyNameXCategoryStr: companyNameXCategoryStr);
                        final int companyNameIndex = cardModelListGlobal
                            .indexWhere((element) => (element.cardCompanyName.text == companyNameXCategoryModel.companyName)); //never equal -1
                        final int categoryIndex = cardModelListGlobal[companyNameIndex].categoryList.indexWhere(
                            (element) => (textEditingControllerToDouble(controller: element.category) == companyNameXCategoryModel.category)); //never equal -1

                        cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].selectedSellPriceIndex =
                            getSelectedSellPriceIndexByPriceAndMoneyTypeStr(
                          companyNameStr: companyNameXCategoryModel.companyName,
                          categoryNumber: companyNameXCategoryModel.category,
                          priceAndMoneyTypeStr: priceAndMoneyTypeStr,
                        );
                        if (priceAndMoneyTypeStr == oldController2D[controllerIndex][2].text) {
                          cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].discountPriceAndMoneyTypeController!.text =
                              discountPriceAndMoneyTypeStr;
                          cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].isShowTextField = isShowTextField;
                        } else {
                          cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].discountPriceAndMoneyTypeController!.text = priceAndMoneyTypeStr;
                          cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].isShowTextField = false;
                        }
                        final bool isDiscountPriceAndMoneyTypeNotEmpty =
                            cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].discountPriceAndMoneyTypeController!.text.isNotEmpty;
                        final bool isNotShowTextField = !cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].isShowTextField;
                        if (isDiscountPriceAndMoneyTypeNotEmpty && isNotShowTextField) {
                          final String priceMoneyType = convertStringToMoneyTypeAndValueModel(priceAndMoneyTypeStr: priceAndMoneyTypeStr).moneyType;
                          cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].selectedSellDiscountPriceIndex =
                              getSelectedSellDiscountPriceIndexByPriceAndMoneyTypeStr(
                            companyNameStr: companyNameXCategoryModel.companyName,
                            category: companyNameXCategoryModel.category,
                            discountPriceAndMoneyTypeStr: customValueAndMoneyType(
                              valueStr: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].discountPriceAndMoneyTypeController!.text,
                              moneyTypeStr: priceMoneyType,
                            ),
                          );
                        }
                      }
                      for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTempSellCardGlobal.moneyTypeList.length; moneyTypeIndex++) {
                        sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].calculate.customerMoneyList = [];
                      }
                      if (sellCardAdvanceModelTempSellCardGlobal.mergeCalculate != null) {
                        sellCardAdvanceModelTempSellCardGlobal.mergeCalculate!.customerMoneyList = [];
                      }
                      _isInitCard = true;
                      setStateFromDialog(() {});
                    }

                    // final List<List<Function>> callbackList = [
                    //   [],
                    //   [],
                    //   [({required String oldStr, required String newStr}) {}],
                    //   [({required String oldStr, required String newStr}) {}, ({required String oldStr, required String newStr}) {}],
                    //   [],
                    //   [],
                    // ];

                    return TableGlobalWidget(
                      // callbackList: callbackList,
                      headerList: headerList,
                      expandedList: expandedList,
                      widgetTypeList: widgetTypeList,
                      textFieldController2D: textFieldController2DSellCardGlobal,
                      menuItemStr3D: menuItemStr3DSellCardGlobal,
                      returnIsShowAndTextFieldController2DFunction: convertTableIntoSellPriceCardModel,
                      isShowTextField2D: isShowTextField2DSellCardGlobal,
                      isShowAddMoreButton: false,
                      isShowDeleteButton: false,
                      isNumberInputOnDropDownAndTextField: true,
                    );
                  }

                  Widget rateDiscountList() {
                    Widget rateListWidget() {
                      Widget buyAndSellRateWidget({required int buyAndSellDiscountRateIndex}) {
                        Widget insideSizeBoxWidget() {
                          Widget dropDownAndTextFieldProvider({required RateForCalculateModel rateForCalculateModel}) {
                            final bool isBuyRate = rateForCalculateModel.isBuyRate!;
                            final List<String> rateType = rateForCalculateModel.rateType;
                            final String labelStr =
                                isBuyRate ? "${rateType.first}$arrowStrGlobal${rateType.last}" : "${rateType.last}$arrowStrGlobal${rateType.first}";
                            List<String> menuItemStrList = [];
                            final RateModel rateModel = getRateModel(rateTypeFirst: rateType.first, rateTypeLast: rateType.last)!;
                            if (isBuyRate) {
                              final bool isBuyNotNull = (rateModel.buy != null);
                              if (isBuyNotNull) {
                                menuItemStrList = List<String>.from((rateModel.buy!.discountOptionList).map((x) => x.text));
                              }
                            } else {
                              final bool isSellNotNull = (rateModel.sell != null);
                              if (isSellNotNull) {
                                menuItemStrList = List<String>.from((rateModel.sell!.discountOptionList).map((x) => x.text));
                              }
                            }
                            final bool isNotSelectedOtherRate = !rateForCalculateModel.isSelectedOtherRate;
                            if (isNotSelectedOtherRate) {
                              final bool isRateValueNotNull = (rateForCalculateModel.value != null);
                              if (isRateValueNotNull) {
                                final String valueStr = formatAndLimitNumberTextGlobal(
                                  valueStr: rateForCalculateModel.value.toString(),
                                  isRound: false,
                                  isAllowZeroAtLast: false,
                                );
                                menuItemStrList.add(valueStr);
                              }
                            }

                            final String discountValueTemp = rateForCalculateModel.discountValue.text;
                            void onChangedDropDrownFunction({required String value, required int index}) {
                              final bool isSelectedOtherRate = (value == otherStrGlobal);
                              rateForCalculateModel.isSelectedOtherRate = isSelectedOtherRate;
                              if (!isSelectedOtherRate) {
                                rateForCalculateModel.discountValue.text = value;
                              }
                              if (_isSeparate) {
                                sellCardAdvanceModelTempSellCardGlobal.moneyTypeList = [];
                                sellCardAdvanceModelTempSellCardGlobal.remark = TextEditingController();
                                // sellCardAdvanceModelTemp = SellCardModel(moneyTypeList: [], remark: TextEditingController());
                              } else {
                                sellCardAdvanceModelTempSellCardGlobal.mergeCalculate!.customerMoneyList = [];
                              }
                              _isInitCard = true;
                              _isSeparate = true;

                              final String discountValueChangedTemp = rateForCalculateModel.discountValue.text;
                              addActiveLogElement(
                                isDropdownFromDropdownOrTextfield: true,
                                activeLogModelList: activeLogModelSellCardList,
                                activeLogModel: ActiveLogModel(
                                  idTemp: "rate, $labelStr",
                                  activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                                  locationList: [
                                    Location(title: "card calculation", subtitle: "advance calculation"),
                                    Location(title: "rate", subtitle: labelStr),
                                    Location(
                                      title: "rate dropdown",
                                      subtitle:
                                          "${discountValueTemp.isEmpty ? "" : "$discountValueTemp to "}${(discountValueTemp == discountValueChangedTemp) ? "other" : discountValueChangedTemp}",
                                    ),
                                  ],
                                ),
                              );
                              setStateFromDialog(() {});
                            }

                            void changeToSeparateWhenNoRateValueMatch() {
                              _isInitCard = true;
                              if (!_isSeparate) {
                                if (getIsNoMergeRateValue()) {
                                  _isSeparate = true;
                                  sellCardAdvanceModelTempSellCardGlobal = SellCardModel(
                                    activeLogModelList: [],
                                    moneyTypeList: [],
                                    remark: TextEditingController(),
                                  );
                                }
                              }
                            }

                            void onChangedTextFieldFunction() {
                              changeToSeparateWhenNoRateValueMatch();
                              _isSeparate = true;
                              final String discountValueChangedTemp = rateForCalculateModel.discountValue.text;
                              addActiveLogElement(
                                activeLogModelList: activeLogModelSellCardList,
                                activeLogModel: ActiveLogModel(
                                  idTemp: "rate, $labelStr",
                                  activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                                  locationList: [
                                    Location(title: "card calculation", subtitle: "advance calculation"),
                                    Location(title: "rate", subtitle: labelStr),
                                    Location(
                                      color: (discountValueTemp.length < discountValueChangedTemp.length) ? ColorEnum.green : ColorEnum.red,
                                      title: "rate textfield",
                                      subtitle: "${discountValueTemp.isEmpty ? "" : "$discountValueTemp to "}$discountValueChangedTemp",
                                    ),
                                  ],
                                ),
                              );
                              setStateFromDialog(() {});
                            }

                            void onDeleteFunction() {
                              rateForCalculateModel.isSelectedOtherRate = false;
                              rateForCalculateModel.discountValue.clear();
                              changeToSeparateWhenNoRateValueMatch();
                              _isSeparate = true;
                              addActiveLogElement(
                                activeLogModelList: activeLogModelSellCardList,
                                activeLogModel: ActiveLogModel(
                                  idTemp: "rate, $labelStr",
                                  activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                                  locationList: [
                                    Location(title: "card calculation", subtitle: "advance calculation"),
                                    Location(title: "rate", subtitle: labelStr),
                                    Location(color: ColorEnum.red, title: "rate dropdown or textfield", subtitle: "click delete rate button"),
                                  ],
                                ),
                              );
                              setStateFromDialog(() {});
                            }

                            void onTapFunction() {}
                            return DropDownAndTextFieldProviderGlobal(
                              labelStr: labelStr,
                              level: Level.mini,
                              menuItemStrList: menuItemStrList,
                              onChangedDropDrownFunction: onChangedDropDrownFunction,
                              onChangedTextFieldFunction: onChangedTextFieldFunction,
                              onDeleteFunction: onDeleteFunction,
                              onTapFunction: onTapFunction,
                              selectedStr: rateForCalculateModel.discountValue.text,
                              textFieldDataType: TextFieldDataType.double,
                              controller: rateForCalculateModel.discountValue,
                              isShowTextField: rateForCalculateModel.isSelectedOtherRate,
                            );
                          }

                          return Column(children: [
                            dropDownAndTextFieldProvider(rateForCalculateModel: buyAndSellDiscountRateListSellCardGlobal[buyAndSellDiscountRateIndex].buy),
                            dropDownAndTextFieldProvider(rateForCalculateModel: buyAndSellDiscountRateListSellCardGlobal[buyAndSellDiscountRateIndex].sell),
                          ]);
                        }

                        void onTapUnlessDisable() {}
                        return Padding(
                          padding: EdgeInsets.only(
                              left: paddingSizeGlobal(level: Level.mini),
                              bottom: paddingSizeGlobal(level: Level.large),
                              top: paddingSizeGlobal(level: Level.large)),
                          child: CustomButtonGlobal(
                            insideSizeBoxWidget: insideSizeBoxWidget(),
                            onTapUnlessDisable: onTapUnlessDisable,
                            sizeBoxWidth: discountRateCardWidthGlobal,
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
                          child: Row(children: [
                            for (int buyAndSellDiscountRateIndex = 0;
                                buyAndSellDiscountRateIndex < buyAndSellDiscountRateListSellCardGlobal.length;
                                buyAndSellDiscountRateIndex++)
                              buyAndSellRateWidget(buyAndSellDiscountRateIndex: buyAndSellDiscountRateIndex),
                          ]),
                        ),
                      );
                    }

                    return rateListWidget();
                  }

                  Widget paddingTopCalculateMainPriceList() {
                    Widget rateListWidget() {
                      Widget paddingRightCalculateMainPriceWidget({required int moneyTypeIndex, required int cardIndex}) {
                        Widget calculateMainPriceWidget() {
                          Widget setSizeWidget() {
                            Widget insideSizeBoxWidget() {
                              Widget paddingBottomTitleTextWidget() {
                                Widget titleTextWidget() {
                                  final String companyNameStr =
                                      sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList[cardIndex].cardCompanyName;
                                  final double categoryNumber =
                                      sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList[cardIndex].category;
                                  final String categoryStr =
                                      formatAndLimitNumberTextGlobal(valueStr: categoryNumber.toString(), isRound: false, isAllowZeroAtLast: false);
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$detailProfitOfStrGlobal $companyNameStr x $categoryStr",
                                        style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  );
                                }

                                return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: titleTextWidget());
                              }

                              Widget mergeMainPriceByMoneyTypeAndLineWidget() {
                                double totalMainPriceXQtyNumber = 0;
                                Widget mergeByMoneyType() {
                                  return Column(
                                    children: List.generate(
                                        sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList.length,
                                        (mainPriceQtyIndex) {
                                      String calculateStr = "";
                                      final String mergeMoneyTypeStr =
                                          sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList[cardIndex].sellPrice.moneyType;
                                      final int qtyNumber = sellCardAdvanceModelTempSellCardGlobal
                                          .moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList[mainPriceQtyIndex].qty;
                                      final String qtyStr =
                                          formatAndLimitNumberTextGlobal(valueStr: qtyNumber.toString(), isRound: false, isAllowZeroAtLast: false);
                                      final double mainPriceNumber = textEditingControllerToDouble(
                                        controller: sellCardAdvanceModelTempSellCardGlobal
                                            .moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList[mainPriceQtyIndex].mainPrice.price,
                                      )!;
                                      final String mainPriceStr =
                                          formatAndLimitNumberTextGlobal(valueStr: mainPriceNumber.toString(), isRound: false, isAllowZeroAtLast: false);
                                      RateForCalculateModel? rate = sellCardAdvanceModelTempSellCardGlobal
                                          .moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList[mainPriceQtyIndex].rate;
                                      final bool isRateNotNull = (rate != null);
                                      if (isRateNotNull) {
                                        final bool isBuyRate = rate.isBuyRate!;
                                        final String operatorStr = isBuyRate ? "/" : "x";
                                        final String rateDiscountStr =
                                            formatAndLimitNumberTextGlobal(valueStr: rate.discountValue.text, isRound: false, isAllowZeroAtLast: false);
                                        final double rateDiscountNumber = textEditingControllerToDouble(controller: rate.discountValue)!;
                                        final String moneyTypeStr = isBuyRate ? rate.rateType.last : rate.rateType.first;

                                        final int place = findMoneyModelByMoneyType(moneyType: mergeMoneyTypeStr).decimalPlace!;
                                        final double convertedResultNumber = double.parse(formatAndLimitNumberTextGlobal(
                                          valueStr: (isBuyRate
                                                  ? (qtyNumber * mainPriceNumber / rateDiscountNumber)
                                                  : (qtyNumber * mainPriceNumber * rateDiscountNumber))
                                              .toString(),
                                          isRound: false,
                                          isAddComma: false,
                                          isAllowZeroAtLast: false,
                                        ));
                                        final String convertedResultStr = formatAndLimitNumberTextGlobal(
                                          valueStr: convertedResultNumber.toString(),
                                          isRound: true,
                                          isAllowZeroAtLast: false,
                                          places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                                        );
                                        calculateStr =
                                            "- $qtyStr x $mainPriceStr $moneyTypeStr $operatorStr $rateDiscountStr = - $convertedResultStr $mergeMoneyTypeStr";
                                        // totalMainPriceXQtyNumber -= convertedResultNumber;

                                        totalMainPriceXQtyNumber = double.parse(formatAndLimitNumberTextGlobal(
                                          valueStr: (totalMainPriceXQtyNumber - convertedResultNumber).toString(),
                                          isRound: true,
                                          isAddComma: false,
                                          isAllowZeroAtLast: false,
                                        ));
                                      } else {
                                        final int place = findMoneyModelByMoneyType(moneyType: mergeMoneyTypeStr).decimalPlace!;
                                        // final double convertedResultNumber = (qtyNumber * mainPriceNumber);
                                        final double convertedResultNumber = double.parse(formatAndLimitNumberTextGlobal(
                                          valueStr: (qtyNumber * mainPriceNumber).toString(),
                                          isRound: false,
                                          isAddComma: false,
                                          isAllowZeroAtLast: false,
                                        ));
                                        final String convertedResultStr = formatAndLimitNumberTextGlobal(
                                          valueStr: convertedResultNumber.toString(),
                                          isRound: true,
                                          isAllowZeroAtLast: false,
                                          places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                                        );
                                        calculateStr = "- $qtyStr x $mainPriceStr $mergeMoneyTypeStr = - $convertedResultStr $mergeMoneyTypeStr";
                                        // totalMainPriceXQtyNumber -= convertedResultNumber;

                                        totalMainPriceXQtyNumber = double.parse(formatAndLimitNumberTextGlobal(
                                          valueStr: (totalMainPriceXQtyNumber - convertedResultNumber).toString(),
                                          isRound: true,
                                          isAddComma: false,
                                          isAllowZeroAtLast: false,
                                        ));
                                      }

                                      return scrollText(textStr: calculateStr, textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.topRight);
                                    }),
                                  );
                                }

                                Widget mainPriceXQtyAndMoneyTypeTextWidget() {
                                  final String mergeMoneyTypeStr =
                                      sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList[cardIndex].sellPrice.moneyType;
                                  final int place = findMoneyModelByMoneyType(moneyType: mergeMoneyTypeStr).decimalPlace!;
                                  final String totalMainPriceXQtyStr = formatAndLimitNumberTextGlobal(
                                    valueStr: totalMainPriceXQtyNumber.toString(),
                                    isRound: true,
                                    isAllowZeroAtLast: false,
                                    places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                                  );
                                  return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [Text("$totalMainPriceXQtyStr $mergeMoneyTypeStr", style: textStyleGlobal(level: Level.normal))]);
                                }

                                return Column(children: [mergeByMoneyType(), drawLineGlobal(), mainPriceXQtyAndMoneyTypeTextWidget()]);
                              }

                              Widget mainAndSellPriceCalculateTextWidget() {
                                Widget sumMainAndSellPriceWidget() {
                                  final double profitNumber = sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList[cardIndex].profit;
                                  final int qtyNumber = sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList[cardIndex].qty;
                                  final String sellPriceStr =
                                      sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList[cardIndex].sellPrice.discountValue;
                                  final double sellPriceNumber = double.parse(
                                      formatAndLimitNumberTextGlobal(valueStr: sellPriceStr, isRound: false, isAddComma: false, isAllowZeroAtLast: false));
                                  // final double qtyXSellPriceNumber = qtyNumber * sellPriceNumber;
                                  final double qtyXSellPriceNumber = double.parse(formatAndLimitNumberTextGlobal(
                                    valueStr: (qtyNumber * sellPriceNumber).toString(),
                                    isRound: false,
                                    isAddComma: false,
                                    isAllowZeroAtLast: false,
                                  ));

                                  final String mergeMoneyTypeStr =
                                      sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList[cardIndex].sellPrice.moneyType;
                                  // final int place = findMoneyModelByMoneyType(moneyType: mergeMoneyTypeStr).decimalPlace!;
                                  final String qtyXSellPriceStr = formatAndLimitNumberTextGlobal(
                                    valueStr: qtyXSellPriceNumber.toString(),
                                    isRound: true,
                                    isAllowZeroAtLast: false,
                                    isAddComma: false,
                                    places: findMoneyModelByMoneyType(moneyType: mergeMoneyTypeStr).decimalPlace!,
                                    // places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                                  );
                                  // final double qtyXMainPriceNumber = qtyXSellPriceNumber - profitNumber;
                                  // final String qtyXMainPriceStr = formatAndLimitNumberTextGlobal(
                                  //   valueStr: qtyXMainPriceNumber.toString(),
                                  //   isRound: false,
                                  //   isAllowZeroAtLast: false,
                                  //   places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                                  // );
                                  return calculateResult(
                                    operatorStr: "+",
                                    getMoneyNumber: double.parse(qtyXSellPriceStr),
                                    getMoneyType: mergeMoneyTypeStr,
                                    giveMoneyNumber: profitNumber,
                                    giveMoneyType: mergeMoneyTypeStr,
                                    isShowButton: false,
                                    isShowYesButton: false,
                                    calculateSellCardModel: null,
                                    getMoneyController: null,
                                  );
                                }

                                final bool isValidProfit =
                                    sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList[cardIndex].sellPrice.discountValue.isNotEmpty;
                                return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                  isValidProfit ? sumMainAndSellPriceWidget() : Text(errorStrGlobal, style: textStyleGlobal(level: Level.normal)),
                                ]);
                              }

                              ScrollController scrollController = ScrollController(initialScrollOffset: 1000);
                              return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.end, children: [
                                paddingBottomTitleTextWidget(),
                                Expanded(
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    child: Column(children: [mergeMainPriceByMoneyTypeAndLineWidget(), mainAndSellPriceCalculateTextWidget()]),
                                  ),
                                ),
                              ]);
                            }

                            void onTapUnlessDisable() {}
                            return CustomButtonGlobal(
                              sizeBoxWidth: calculateMaiPriceCardWidthGlobal,
                              sizeBoxHeight: calculateMaiPriceCardHeightGlobal,
                              insideSizeBoxWidget: insideSizeBoxWidget(),
                              onTapUnlessDisable: onTapUnlessDisable,
                            );
                          }

                          return setSizeWidget();
                        }

                        return Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)), child: calculateMainPriceWidget());
                      }

                      Widget toggleProfitDetailWidget() {
                        Widget insideSizeBoxWidget() {
                          void onToggle() {
                            isShowProfitDetail = !isShowProfitDetail;
                            addActiveLogElement(
                              activeLogModelList: activeLogModelSellCardList,
                              activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.selectToggle, locationList: [
                                Location(title: "card calculation", subtitle: "advance calculation"),
                                Location(
                                  color: isShowProfitDetail ? ColorEnum.blue : ColorEnum.red,
                                  title: "toggle button name",
                                  subtitle: isShowProfitDetail ? "hide to show profit detail" : "show to hide profit detail",
                                ),
                              ]),
                            );
                            setStateFromDialog(() {});
                          }

                          return Row(children: [
                            Padding(
                              padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)),
                              child: Text(detailProfitStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                            ),
                            showAndHideToggleWidgetGlobal(isLeftSelected: isShowProfitDetail, onToggle: onToggle),
                          ]);
                        }

                        void onTapUnlessDisable() {}
                        return Padding(
                          padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
                          child: CustomButtonGlobal(
                            sizeBoxWidth: 260,
                            insideSizeBoxWidget: insideSizeBoxWidget(),
                            onTapUnlessDisable: onTapUnlessDisable,
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          toggleProfitDetailWidget(),
                          isShowProfitDetail
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: paddingSizeGlobal(level: Level.large),
                                        left: paddingSizeGlobal(level: Level.mini),
                                        top: paddingSizeGlobal(level: Level.mini)),
                                    child: Row(children: [
                                      for (int moneyTypeIndex = 0;
                                          moneyTypeIndex < sellCardAdvanceModelTempSellCardGlobal.moneyTypeList.length;
                                          moneyTypeIndex++)
                                        for (int cardIndex = 0;
                                            cardIndex < sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].cardList.length;
                                            cardIndex++)
                                          paddingRightCalculateMainPriceWidget(moneyTypeIndex: moneyTypeIndex, cardIndex: cardIndex),
                                    ]),
                                  ),
                                )
                              : Container(),
                        ],
                      );
                    }

                    return rateListWidget();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Expanded(child: tableWidget()), rateDiscountList(), paddingTopCalculateMainPriceList()],
                  );
                }

                return Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)), child: tableAndRateDiscountListWidget());
              }

              Widget getMoneyWidget() {
                Widget paddingBottomToggleOrTextWidget() {
                  Widget toggleOrTextProvider() {
                    Widget toggleWidget() {
                      void onToggle() {
                        _isSeparate = !_isSeparate;
                        addActiveLogElement(
                          activeLogModelList: activeLogModelSellCardList,
                          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.selectToggle, locationList: [
                            Location(title: "card calculation", subtitle: "advance calculation"),
                            Location(
                              title: "toggle button name",
                              subtitle: _isSeparate ? "merge to separate" : "separate to merge",
                            ),
                          ]),
                        );

                        sellCardAdvanceModelTempSellCardGlobal.mergeCalculate = CalculateSellCardModel(
                            totalMoney: 0,
                            moneyType: findSpecialMoneyType(sellCardAdvanceModelTemp: sellCardAdvanceModelTempSellCardGlobal)!,
                            customerMoneyList: []);
                        _isInitCard = true;
                        setStateFromDialog(() {});
                      }

                      return separateAndMergeToggleWidgetGlobal(isLeftSelected: _isSeparate, onToggle: onToggle);
                    }

                    return getIsNoMergeRateValue() ? Container() : toggleWidget();
                  }

                  return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: toggleOrTextProvider());
                }

                Widget getMoneyFromCustomer() {
                  Widget paddingTotalProviderWidget() {
                    Widget totalProviderWidget() {
                      Widget paddingBottomGetMoneyFromCustomerWidget({
                        required CalculateSellCardModel calculateSellCardModel,
                        required bool isShowTotalByMoneyTypeDropDown,
                        required bool isValidProfitRate,
                      }) {
                        Widget getMoneyFromCustomerWidget() {
                          final TextEditingController getMoneyController = TextEditingController();
                          final int customerMoneyLastIndex = (calculateSellCardModel.customerMoneyList.length - 1);

                          final String? customerMoneyStrOrNull = calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].getMoney;
                          getMoneyController.value = copyValueAndMoveToLastGlobal(controller: getMoneyController, value: customerMoneyStrOrNull);
                          Widget insideSizeBoxWidget() {
                            Widget headerWidget() {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.normal)),
                                child: moneyTypeOptionWidget(
                                  calculateSellCardModel: calculateSellCardModel,
                                  setStateFromDialog: setStateFromDialog,
                                  isShowTotalByMoneyTypeDropDown: isShowTotalByMoneyTypeDropDown,
                                  sellCardAdvanceModelTemp: sellCardAdvanceModelTempSellCardGlobal,
                                ),
                              );
                            }

                            Widget bodyWidget() {
                              Widget totalAndCalculateListWidget() {
                                Widget mergeByMoneyTypeProvider() {
                                  Widget mergeByMoneyTypeAndLineWidget() {
                                    Widget mergeByMoneyType() {
                                      return Column(
                                        children: List.generate(sellCardAdvanceModelTempSellCardGlobal.moneyTypeList.length, (moneyTypeIndex) {
                                          final RateForCalculateModel? rate = sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].rate;
                                          final String totalMoneyTypeStr =
                                              sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].calculate.moneyType;
                                          final double totalMoneyNumber =
                                              sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].calculate.totalMoney;
                                          final String totalMoneyStr = formatAndLimitNumberTextGlobal(
                                            valueStr: totalMoneyNumber.toString(),
                                            isRound: false,
                                            places: findMoneyModelByMoneyType(moneyType: totalMoneyTypeStr).decimalPlace!,
                                            isAllowZeroAtLast: false,
                                          );
                                          String calculateStr;
                                          final bool isRateNotNull = (rate != null);
                                          if (isRateNotNull) {
                                            final bool isBuyRate = rate.isBuyRate!;
                                            final String operatorStr = isBuyRate ? "/" : "x";
                                            final String rateDiscountStr = rate.discountValue.text;
                                            final String mergeMoneyTypeStr = sellCardAdvanceModelTempSellCardGlobal.mergeCalculate!.moneyType;
                                            final String convertedResultStr = formatAndLimitNumberTextGlobal(
                                              valueStr: sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].calculate.convertMoney.toString(),
                                              isRound: true,
                                              isAllowZeroAtLast: false,
                                              places: findMoneyModelByMoneyType(moneyType: mergeMoneyTypeStr).decimalPlace!,
                                            );
                                            calculateStr =
                                                "$totalMoneyStr $totalMoneyTypeStr $operatorStr $rateDiscountStr = $convertedResultStr $mergeMoneyTypeStr";
                                          } else {
                                            calculateStr = "$totalMoneyStr $totalMoneyTypeStr";
                                          }
                                          return scrollText(
                                              textStr: "$calculateStr$space10TimesStrGlobal",
                                              textStyle: textStyleGlobal(level: Level.normal),
                                              alignment: Alignment.topRight);
                                        }),
                                      );
                                    }

                                    return Column(children: [mergeByMoneyType(), drawLineGlobal()]);
                                  }

                                  return isShowTotalByMoneyTypeDropDown ? mergeByMoneyTypeAndLineWidget() : Container();
                                }

                                Widget totalByMoneyTypeWidget() {
                                  final String totalStr = formatAndLimitNumberTextGlobal(
                                      valueStr: calculateSellCardModel.totalMoney.toString(), isRound: false, isAllowZeroAtLast: false);
                                  final String moneyTypeStr = calculateSellCardModel.moneyType;
                                  final String totalAndMoneyStr = "$totalStr $moneyTypeStr$space10TimesStrGlobal";
                                  return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [Text(totalAndMoneyStr, style: textStyleGlobal(level: Level.normal))]);
                                }

                                Widget detailGetMoneyWidget() {
                                  return Column(
                                    children: List.generate(calculateSellCardModel.customerMoneyList.length, (customerMoneyIndex) {
                                      final String? getMoneyStrOrNull = calculateSellCardModel.customerMoneyList[customerMoneyIndex].getMoney;
                                      final double? getMoneyNumberOrNull = (getMoneyStrOrNull == null)
                                          ? null
                                          : double.parse(formatAndLimitNumberTextGlobal(
                                              valueStr: getMoneyStrOrNull,
                                              isRound: false,
                                              isAddComma: false,
                                              isAllowZeroAtLast: false,
                                            ));
                                      final double? giveMoneyNumberOrNull = calculateSellCardModel.customerMoneyList[customerMoneyIndex].giveMoney;
                                      final String moneyTypeStr = calculateSellCardModel.customerMoneyList[customerMoneyIndex].moneyType!;
                                      final RateForCalculateModel? rateOrNull = calculateSellCardModel.customerMoneyList[customerMoneyIndex].rate;

                                      double perviousGiveMoneyNumber = calculateSellCardModel.totalMoney;
                                      final bool isCustomerMoneyLastIndexMoreThan0 = (customerMoneyIndex > 0);
                                      if (isCustomerMoneyLastIndexMoreThan0) {
                                        perviousGiveMoneyNumber = calculateSellCardModel.customerMoneyList[customerMoneyIndex - 1].giveMoney!;
                                      }

                                      final int lastCustomerMoneyIndex = (calculateSellCardModel.customerMoneyList.length - 1);
                                      final bool isLastCustomerGetMoneyIndex = (lastCustomerMoneyIndex == customerMoneyIndex);

                                      final bool isRateNotNull = (rateOrNull != null);
                                      final bool isGetAndGiveMoneyNull = (getMoneyNumberOrNull == null || giveMoneyNumberOrNull == null);
                                      if (isGetAndGiveMoneyNull) {
                                        if (isRateNotNull) {
                                          final TextEditingController lastRateValueNumberController =
                                              calculateSellCardModel.customerMoneyList[customerMoneyIndex].rate!.discountValue;
                                          final double? lastRateValueNumberOrNull = textEditingControllerToDouble(controller: lastRateValueNumberController);
                                          final bool isLastBuyRate = calculateSellCardModel.customerMoneyList[customerMoneyIndex].rate!.isBuyRate!;
                                          double lastRateResult = 0;
                                          final bool isLastRateValueNumberNotNull = (lastRateValueNumberOrNull != null);
                                          if (isLastRateValueNumberNotNull) {
                                            final bool isLastRateValueNumberNotEqual0 = (lastRateValueNumberOrNull != 0);
                                            if (isLastRateValueNumberNotEqual0) {
                                              // lastRateResult = isLastBuyRate ? (perviousGiveMoneyNumber / lastRateValueNumberOrNull) : (perviousGiveMoneyNumber * lastRateValueNumberOrNull);
                                              lastRateResult = double.parse(formatAndLimitNumberTextGlobal(
                                                valueStr: (isLastBuyRate
                                                        ? (perviousGiveMoneyNumber / lastRateValueNumberOrNull)
                                                        : (perviousGiveMoneyNumber * lastRateValueNumberOrNull))
                                                    .toString(),
                                                isRound: false,
                                                isAddComma: false,
                                                isAllowZeroAtLast: false,
                                              ));
                                            }
                                          }
                                          lastRateResult = double.parse(formatAndLimitNumberTextGlobal(
                                            valueStr: lastRateResult.toString(),
                                            isRound: true,
                                            isAddComma: false,
                                            places: findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!,
                                            isAllowZeroAtLast: false,
                                          ));
                                          return calculateResult(
                                            operatorStr: rateOrNull.isBuyRate! ? "/" : "x",
                                            getMoneyNumber: lastRateValueNumberOrNull ?? 0,
                                            getMoneyType: "${rateOrNull.rateType.first}-${rateOrNull.rateType.last}",
                                            giveMoneyNumber: lastRateResult,
                                            giveMoneyType: "$moneyTypeStr$space10TimesStrGlobal",
                                            isShowButton: isLastCustomerGetMoneyIndex,
                                            isShowYesButton: false,
                                            calculateSellCardModel: calculateSellCardModel,
                                            getMoneyController: getMoneyController,
                                          );
                                        }
                                      } else {
                                        if (isRateNotNull) {
                                          final TextEditingController lastRateValueNumberController =
                                              calculateSellCardModel.customerMoneyList[customerMoneyIndex].rate!.discountValue;
                                          final double? lastRateValueNumberOrNull = textEditingControllerToDouble(controller: lastRateValueNumberController);
                                          final bool isLastBuyRate = calculateSellCardModel.customerMoneyList[customerMoneyIndex].rate!.isBuyRate!;
                                          double lastRateResult = 0;
                                          final bool isLastRateValueNumberNotNull = (lastRateValueNumberOrNull != null);
                                          if (isLastRateValueNumberNotNull) {
                                            final bool isLastRateValueNumberNotEqual0 = (lastRateValueNumberOrNull != 0);
                                            if (isLastRateValueNumberNotEqual0) {
                                              // lastRateResult = isLastBuyRate ? (perviousGiveMoneyNumber / lastRateValueNumberOrNull) : (perviousGiveMoneyNumber * lastRateValueNumberOrNull);
                                              lastRateResult = double.parse(formatAndLimitNumberTextGlobal(
                                                valueStr: (isLastBuyRate
                                                        ? (perviousGiveMoneyNumber / lastRateValueNumberOrNull)
                                                        : (perviousGiveMoneyNumber * lastRateValueNumberOrNull))
                                                    .toString(),
                                                isRound: false,
                                                isAddComma: false,
                                                isAllowZeroAtLast: false,
                                              ));
                                            }
                                          }

                                          lastRateResult = double.parse(formatAndLimitNumberTextGlobal(
                                            valueStr: lastRateResult.toString(),
                                            isRound: true,
                                            isAddComma: false,
                                            places: findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!,
                                            isAllowZeroAtLast: false,
                                          ));
                                          return Column(children: [
                                            calculateResult(
                                              operatorStr: rateOrNull.isBuyRate! ? "/" : "x",
                                              getMoneyNumber: lastRateValueNumberOrNull ?? 0,
                                              getMoneyType: "${rateOrNull.rateType.first}-${rateOrNull.rateType.last}",
                                              giveMoneyNumber: lastRateResult,
                                              giveMoneyType: "$moneyTypeStr$space10TimesStrGlobal",
                                              isShowButton: false,
                                              isShowYesButton: false,
                                              calculateSellCardModel: calculateSellCardModel,
                                              getMoneyController: getMoneyController,
                                            ),
                                            calculateResult(
                                              operatorStr: "-",
                                              getMoneyNumber: getMoneyNumberOrNull,
                                              getMoneyType: "$moneyTypeStr$space10TimesStrGlobal",
                                              giveMoneyNumber: giveMoneyNumberOrNull,
                                              giveMoneyType: "$moneyTypeStr$space10TimesStrGlobal",
                                              isShowButton: isLastCustomerGetMoneyIndex,
                                              isShowYesButton: true,
                                              calculateSellCardModel: calculateSellCardModel,
                                              getMoneyController: getMoneyController,
                                            ),
                                          ]);
                                        } else {
                                          return calculateResult(
                                            operatorStr: "-",
                                            getMoneyNumber: getMoneyNumberOrNull,
                                            getMoneyType: "$moneyTypeStr$space10TimesStrGlobal",
                                            giveMoneyNumber: giveMoneyNumberOrNull,
                                            giveMoneyType: "$moneyTypeStr$space10TimesStrGlobal",
                                            isShowButton: isLastCustomerGetMoneyIndex,
                                            isShowYesButton: true,
                                            calculateSellCardModel: calculateSellCardModel,
                                            getMoneyController: getMoneyController,
                                          );
                                        }
                                      }
                                      return yesNoButton(
                                        isShowButton: (calculateSellCardModel.customerMoneyList.first.getMoney != null),
                                        isShowYesButton: false,
                                        calculateSellCardModel: calculateSellCardModel,
                                        getMoneyController: getMoneyController,
                                      );
                                    }),
                                  );
                                }

                                return Column(children: [mergeByMoneyTypeProvider(), totalByMoneyTypeWidget(), detailGetMoneyWidget()]);
                              }

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: paddingSizeGlobal(level: Level.large),
                                  right: paddingSizeGlobal(level: Level.normal),
                                  left: paddingSizeGlobal(level: Level.normal),
                                ),
                                child: totalAndCalculateListWidget(),
                              );
                            }

                            Widget footerWidget() {
                              Widget setUpBackground() {
                                const BoxDecoration boxDecoration = BoxDecoration(
                                  color: footerColorGlobal,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(borderRadiusGlobal),
                                    bottomRight: Radius.circular(borderRadiusGlobal),
                                  ),
                                );

                                Widget paddingProfitAndTextFieldAndMoneyTypeWidget() {
                                  Widget profitAndTextFieldAndMoneyTypeWidget() {
                                    Widget textFieldAndMoneyTypeWidget() {
                                      bool getShowTextFieldAndMoneyType() {
                                        bool isShowTextFieldAndMoneyType = true;
                                        final int customerMoneyLastIndex = (calculateSellCardModel.customerMoneyList.length - 1);
                                        if (customerMoneyLastIndex > 0) {
                                          final double? giveMoneyNumber = calculateSellCardModel.customerMoneyList[customerMoneyLastIndex - 1].giveMoney;
                                          final bool isGiveMoneyNumberNotNull = (giveMoneyNumber != null);
                                          if (isGiveMoneyNumberNotNull) {
                                            isShowTextFieldAndMoneyType = (giveMoneyNumber > 0);
                                          }
                                        }
                                        return (isShowTextFieldAndMoneyType || !calculateSellCardModel.isDone);
                                      }

                                      void calculateLastIndexGetMoney() {
                                        final int customerMoneyLastIndex = (calculateSellCardModel.customerMoneyList.length - 1);
                                        double perviousGiveMoneyNumber = calculateSellCardModel.totalMoney;
                                        String perviousMoneyTypeStr = calculateSellCardModel.moneyType;
                                        final bool isCustomerMoneyLastIndexMoreThan0 = (customerMoneyLastIndex > 0);
                                        if (isCustomerMoneyLastIndexMoreThan0) {
                                          perviousGiveMoneyNumber = calculateSellCardModel.customerMoneyList[customerMoneyLastIndex - 1].giveMoney!;
                                          perviousMoneyTypeStr = calculateSellCardModel.customerMoneyList[customerMoneyLastIndex - 1].moneyType!;
                                        }
                                        final String lastMoneyTypeStr = calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].moneyType!;
                                        final String? getMoneyStrOrNull = calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].getMoney;
                                        final double? lastGetMoneyNumber = (getMoneyStrOrNull == null)
                                            ? null
                                            : double.parse(formatAndLimitNumberTextGlobal(
                                                valueStr: getMoneyStrOrNull,
                                                isRound: false,
                                                isAddComma: false,
                                                isAllowZeroAtLast: false,
                                              ));
                                        final bool isLastGetMoneyNumberNotNull = (lastGetMoneyNumber != null);

                                        final bool isMatchMoneyType = (perviousMoneyTypeStr == lastMoneyTypeStr);
                                        if (isMatchMoneyType) {
                                          if (isLastGetMoneyNumberNotNull) {
                                            // final double minusResultStr = perviousGiveMoneyNumber - lastGetMoneyNumber;

                                            final double minusResultStr = double.parse(formatAndLimitNumberTextGlobal(
                                              valueStr: (perviousGiveMoneyNumber - lastGetMoneyNumber).toString(),
                                              isRound: true,
                                              isAddComma: false,
                                              isAllowZeroAtLast: false,
                                            ));

                                            final bool isHasChange = (minusResultStr < 0);
                                            calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].giveMoney =
                                                double.parse(formatAndLimitNumberTextGlobal(
                                              isAddComma: false,
                                              valueStr: minusResultStr.toString(),
                                              isRound: !isHasChange,
                                              places: findMoneyModelByMoneyType(moneyType: lastMoneyTypeStr).decimalPlace!,
                                              isAllowZeroAtLast: false,
                                            ));
                                          } else {
                                            calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].giveMoney = null;
                                          }
                                          calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].rate = null;
                                        } else {
                                          final TextEditingController lastRateValueNumberController =
                                              calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].rate!.discountValue;
                                          final double? lastRateValueNumberOrNull = textEditingControllerToDouble(controller: lastRateValueNumberController);
                                          final bool isLastBuyRate = calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].rate!.isBuyRate!;
                                          double lastRateResult = 0;
                                          final bool isLastRateValueNumberNotNull = (lastRateValueNumberOrNull != null);
                                          if (isLastRateValueNumberNotNull) {
                                            final bool isLastRateValueNumberNotEqual0 = (lastRateValueNumberOrNull != 0);
                                            if (isLastRateValueNumberNotEqual0) {
                                              // lastRateResult = isLastBuyRate ? (perviousGiveMoneyNumber / lastRateValueNumberOrNull) : (perviousGiveMoneyNumber * lastRateValueNumberOrNull);
                                              lastRateResult = double.parse(formatAndLimitNumberTextGlobal(
                                                valueStr: (isLastBuyRate
                                                        ? (perviousGiveMoneyNumber / lastRateValueNumberOrNull)
                                                        : (perviousGiveMoneyNumber * lastRateValueNumberOrNull))
                                                    .toString(),
                                                isRound: false,
                                                isAddComma: false,
                                                isAllowZeroAtLast: false,
                                              ));
                                            }
                                          }
                                          lastRateResult = double.parse(formatAndLimitNumberTextGlobal(
                                            isAddComma: false,
                                            valueStr: lastRateResult.toString(),
                                            isRound: true,
                                            places: findMoneyModelByMoneyType(moneyType: lastMoneyTypeStr).decimalPlace!,
                                            isAllowZeroAtLast: false,
                                          ));
                                          if (isLastGetMoneyNumberNotNull) {
                                            // final double minusResultStr = lastRateResult - lastGetMoneyNumber;

                                            final double minusResultStr = double.parse(formatAndLimitNumberTextGlobal(
                                              valueStr: (lastRateResult - lastGetMoneyNumber).toString(),
                                              isRound: true,
                                              isAddComma: false,
                                              isAllowZeroAtLast: false,
                                            ));

                                            final bool isHasChange = (minusResultStr < 0);
                                            calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].giveMoney =
                                                double.parse(formatAndLimitNumberTextGlobal(
                                              isAddComma: false,
                                              valueStr: minusResultStr.toString(),
                                              isRound: !isHasChange,
                                              places: findMoneyModelByMoneyType(moneyType: lastMoneyTypeStr).decimalPlace!,
                                              isAllowZeroAtLast: false,
                                            ));
                                          } else {
                                            calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].giveMoney = null;
                                          }
                                        }
                                      }

                                      void onTapFunction() {}

                                      Widget paddingRightTextFieldWidget() {
                                        Widget textFieldWidget() {
                                          final String getMoneyStrTemp = getMoneyController.text;
                                          void onChangeTextFieldFunction() {
                                            final int customerMoneyLastIndex = (calculateSellCardModel.customerMoneyList.length - 1);
                                            calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].getMoney =
                                                (getMoneyController.text.isEmpty) ? null : getMoneyController.text;
                                            calculateLastIndexGetMoney();
                                            final String getMoneyChangeStrTemp = getMoneyController.text;
                                            addActiveLogElement(
                                              activeLogModelList: activeLogModelSellCardList,
                                              activeLogModel: ActiveLogModel(
                                                idTemp: "get money, $customerMoneyLastIndex",
                                                activeType: ActiveLogTypeEnum.typeTextfield,
                                                locationList: [
                                                  Location(title: "get money index", subtitle: customerMoneyLastIndex.toString()),
                                                  Location(title: "money type", subtitle: calculateSellCardModel.moneyType),
                                                  Location(title: "card calculation", subtitle: "advance calculation"),
                                                  Location(
                                                    color: (getMoneyStrTemp.length < getMoneyChangeStrTemp.length) ? ColorEnum.green : ColorEnum.red,
                                                    title: "get money textfield",
                                                    subtitle: "${getMoneyStrTemp.isEmpty ? "" : "$getMoneyStrTemp to "}$getMoneyChangeStrTemp",
                                                  ),
                                                ],
                                              ),
                                            );
                                            setStateFromDialog(() {});
                                          }

                                          return textFieldGlobal(
                                            textFieldDataType: TextFieldDataType.double,
                                            controller: getMoneyController,
                                            onChangeFromOutsiderFunction: onChangeTextFieldFunction,
                                            labelText: getMoneyStrGlobal,
                                            level: Level.mini,
                                            onTapFromOutsiderFunction: onTapFunction,
                                            textFieldColor: textFieldOnFooterColorGlobal,
                                          );
                                        }

                                        return Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)), child: textFieldWidget());
                                      }

                                      Widget dropDownWidget() {
                                        final String selectedStrTemp = calculateSellCardModel.moneyType;
                                        void onChangedFunction({required String value, required int index}) {
                                          final int customerMoneyLastIndex = (calculateSellCardModel.customerMoneyList.length - 1);
                                          String perviousMoneyTypeStr = calculateSellCardModel.moneyType;
                                          final bool isCustomerMoneyLastIndexMoreThan0 = (customerMoneyLastIndex > 0);
                                          if (isCustomerMoneyLastIndexMoreThan0) {
                                            perviousMoneyTypeStr = calculateSellCardModel.customerMoneyList[customerMoneyLastIndex - 1].moneyType!;
                                          }
                                          calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].moneyType = value;
                                          final RateForCalculateModel? rateForCalculateModel = getDiscountRateForCalculateModel(
                                            rateTypeFirst: value,
                                            rateTypeLast: perviousMoneyTypeStr,
                                            buyAndSellDiscountRateList: buyAndSellDiscountRateListSellCardGlobal,
                                          );
                                          calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].rate =
                                              (rateForCalculateModel == null) ? null : cloneRateForCalculate(rateForCalculate: rateForCalculateModel);
                                          calculateLastIndexGetMoney();
                                          addActiveLogElement(
                                            activeLogModelList: activeLogModelSellCardList,
                                            activeLogModel: ActiveLogModel(
                                              idTemp: "selected money type, $customerMoneyLastIndex",
                                              activeType: ActiveLogTypeEnum.selectDropdown,
                                              locationList: [
                                                Location(title: "get money index", subtitle: customerMoneyLastIndex.toString()),
                                                Location(title: "money type", subtitle: calculateSellCardModel.moneyType),
                                                Location(title: "card calculation", subtitle: "advance calculation"),
                                                Location(title: "select money type", subtitle: "$selectedStrTemp to $value"),
                                              ],
                                            ),
                                          );
                                          setStateFromDialog(() {});
                                        }

                                        final int customerMoneyLastIndex = (calculateSellCardModel.customerMoneyList.length - 1);

                                        String perviousMoneyTypeStr = calculateSellCardModel.moneyType;
                                        final bool isCustomerMoneyLastIndexMoreThan0 = (customerMoneyLastIndex > 0);
                                        if (isCustomerMoneyLastIndexMoreThan0) {
                                          perviousMoneyTypeStr = calculateSellCardModel.customerMoneyList[customerMoneyLastIndex - 1].moneyType!;
                                        }
                                        return customDropdown(
                                          level: Level.mini,
                                          labelStr: moneyTypeStrGlobal,
                                          onTapFunction: onTapFunction,
                                          onChangedFunction: onChangedFunction,
                                          selectedStr: calculateSellCardModel.customerMoneyList[customerMoneyLastIndex].moneyType,
                                          menuItemStrList: moneyTypeOfDiscountCardOnlyList(
                                            moneyTypeList: [perviousMoneyTypeStr],
                                            buyAndSellDiscountRateList: buyAndSellDiscountRateListSellCardGlobal, isNotCheckDeleted: false,
                                          ),
                                        );
                                      }

                                      return (getShowTextFieldAndMoneyType() && getValidCard())
                                          ? Row(children: [
                                              Expanded(flex: flexValueGlobal, child: paddingRightTextFieldWidget()),
                                              Expanded(flex: flexTypeGlobal, child: dropDownWidget())
                                            ])
                                          : Container();
                                    }

                                    Widget paddingTopProfitWidget() {
                                      Widget profitScrollTextWidget() {
                                        String profitAndMoneyTypeStr = emptyStrGlobal;
                                        if (isValidProfitRate) {
                                          if (_isSeparate) {
                                            final String profitStr = formatAndLimitNumberTextGlobal(
                                                valueStr: calculateSellCardModel.totalProfit.toString(), isRound: false, isAllowZeroAtLast: false);
                                            final String profitMoneyTypeStr = calculateSellCardModel.moneyType;
                                            profitAndMoneyTypeStr = "$profitStr $profitMoneyTypeStr";
                                          } else {
                                            for (int moneyTypeIndex = 0;
                                                moneyTypeIndex < sellCardAdvanceModelTempSellCardGlobal.moneyTypeList.length;
                                                moneyTypeIndex++) {
                                              final String moneyTypeStr =
                                                  sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].calculate.moneyType;
                                              final int place = findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!;
                                              final String profitNumber = formatAndLimitNumberTextGlobal(
                                                isRound: true,
                                                isAddComma: false,
                                                valueStr:
                                                    sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].calculate.totalProfit!.toString(),
                                                places:
                                                    (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                                              );
                                              final bool isLastIndex = ((sellCardAdvanceModelTempSellCardGlobal.moneyTypeList.length - 1) == moneyTypeIndex);
                                              final String providerStr = isLastIndex ? emptyStrGlobal : providerStrGlobal;
                                              profitAndMoneyTypeStr = "$profitAndMoneyTypeStr $profitNumber $moneyTypeStr $providerStr";
                                            }
                                          }
                                        } else {
                                          profitAndMoneyTypeStr = errorStrGlobal;
                                        }
                                        return scrollText(
                                            textStr: "$profitIsStrGlobal $profitAndMoneyTypeStr",
                                            textStyle: textStyleGlobal(level: Level.mini, color: textFieldOnFooterColorGlobal),
                                            alignment: Alignment.topCenter);
                                      }

                                      return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)), child: profitScrollTextWidget());
                                    }

                                    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                      textFieldAndMoneyTypeWidget(),
                                      _isShowProfitOnGetMoneyFromCustomer ? paddingTopProfitWidget() : Container()
                                    ]);
                                  }

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: paddingSizeGlobal(level: Level.normal),
                                      vertical: paddingSizeGlobal(level: Level.mini),
                                    ),
                                    child: profitAndTextFieldAndMoneyTypeWidget(),
                                  );
                                }

                                return Container(decoration: boxDecoration, child: paddingProfitAndTextFieldAndMoneyTypeWidget());
                              }

                              return setUpBackground();
                            }

                            return Column(children: [headerWidget(), bodyWidget(), footerWidget()]);
                          }

                          return CustomButtonGlobal(
                            isPaddingInside: false,
                            sizeBoxWidth: calculateCardWidthGlobal,
                            insideSizeBoxWidget: insideSizeBoxWidget(),
                            onTapUnlessDisable: () {},
                          );
                        }

                        return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: getMoneyFromCustomerWidget());
                      }

                      Widget totalSeparateCardWidget() {
                        return Column(children: [
                          for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTempSellCardGlobal.moneyTypeList.length; moneyTypeIndex++)
                            paddingBottomGetMoneyFromCustomerWidget(
                              calculateSellCardModel: sellCardAdvanceModelTempSellCardGlobal.moneyTypeList[moneyTypeIndex].calculate,
                              isShowTotalByMoneyTypeDropDown: false,
                              isValidProfitRate:
                                  getValidProfitRateByIndex(moneyTypeIndex: moneyTypeIndex, sellCardAdvanceModelTemp: sellCardAdvanceModelTempSellCardGlobal),
                            )
                        ]);
                      }

                      Widget totalMergeCardWidget() {
                        bool isValidProfitRate = true;
                        for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardAdvanceModelTempSellCardGlobal.moneyTypeList.length; moneyTypeIndex++) {
                          bool isNotValidProfitRate =
                              !getValidProfitRateByIndex(moneyTypeIndex: moneyTypeIndex, sellCardAdvanceModelTemp: sellCardAdvanceModelTempSellCardGlobal);
                          if (isNotValidProfitRate) {
                            isValidProfitRate = false;
                            break;
                          }
                        }
                        return paddingBottomGetMoneyFromCustomerWidget(
                          calculateSellCardModel: sellCardAdvanceModelTempSellCardGlobal.mergeCalculate!,
                          isShowTotalByMoneyTypeDropDown: true,
                          isValidProfitRate: isValidProfitRate,
                        );
                      }

                      return _isSeparate ? totalSeparateCardWidget() : totalMergeCardWidget();
                    }

                    return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)), child: totalProviderWidget());
                  }

                  Widget paddingExchangeListWidget() {
                    Widget exchangeListWidget() {
                      Widget paddingBottomExchangeWidget({required int exchangeIndex}) {
                        Widget exchangeWidget() {
                          Widget insideSizeBoxWidget() {
                            final bool isBuyRate = exchangeAnalysisCardSellCardGlobal.exchangeList[exchangeIndex].rate!.isBuyRate!;
                            final List<String> rateType = exchangeAnalysisCardSellCardGlobal.exchangeList[exchangeIndex].rate!.rateType;
                            final String operatorStr = isBuyRate ? "x" : "/";
                            final String rateDiscountStr = formatAndLimitNumberTextGlobal(
                              valueStr: exchangeAnalysisCardSellCardGlobal.exchangeList[exchangeIndex].rate!.discountValue.text,
                              isRound: false,
                              isAllowZeroAtLast: false,
                            );

                            final String getMoneyTypeStr = isBuyRate ? rateType.first : rateType.last;
                            final int placeGetMoney = findMoneyModelByMoneyType(moneyType: getMoneyTypeStr).decimalPlace!;
                            final String getMoneyStr = formatAndLimitNumberTextGlobal(
                              valueStr: exchangeAnalysisCardSellCardGlobal.exchangeList[exchangeIndex].getMoney.text,
                              isRound: false,
                              isAllowZeroAtLast: false,
                              places:
                                  (placeGetMoney >= 0) ? (placeGetMoney * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                            );
                            final String giveMoneyTypeStr = isBuyRate ? rateType.last : rateType.first;
                            final int placeGiveMoney = findMoneyModelByMoneyType(moneyType: giveMoneyTypeStr).decimalPlace!;
                            final String giveMoneyStr = formatAndLimitNumberTextGlobal(
                              valueStr: exchangeAnalysisCardSellCardGlobal.exchangeList[exchangeIndex].giveMoney.text,
                              isRound: false,
                              isAllowZeroAtLast: false,
                              places:
                                  (placeGiveMoney >= 0) ? (placeGiveMoney * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                            );
                            final String resultAndMoneyTypeStr =
                                "$getMoneyStr $getMoneyTypeStr $operatorStr $rateDiscountStr = $giveMoneyStr $giveMoneyTypeStr";

                            final String profitStr = formatAndLimitNumberTextGlobal(
                              valueStr: exchangeAnalysisCardSellCardGlobal.exchangeList[exchangeIndex].rate!.profit.toString(),
                              isRound: false,
                              isAllowZeroAtLast: false,
                            );
                            final String profitAndMoneyTypeStr = "$profitIsStrGlobal $profitStr ${rateType.last}";
                            final bool isPositiveNumber = (exchangeAnalysisCardSellCardGlobal.exchangeList[exchangeIndex].rate!.profit! >= 0);
                            return Column(
                              children: [
                                scrollText(textStr: resultAndMoneyTypeStr, textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.topCenter),
                                Padding(
                                  padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)),
                                  child: scrollText(
                                    textStr: profitAndMoneyTypeStr,
                                    textStyle: textStyleGlobal(level: Level.mini, color: isPositiveNumber ? positiveColorGlobal : negativeColorGlobal),
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                              ],
                            );
                          }

                          void onTapUnlessDisable() {}
                          return CustomButtonGlobal(
                              sizeBoxWidth: calculateCardWidthGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
                        }

                        return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)), child: exchangeWidget());
                      }

                      return Column(children: [
                        for (int exchangeIndex = 0; exchangeIndex < exchangeAnalysisCardSellCardGlobal.exchangeList.length; exchangeIndex++)
                          paddingBottomExchangeWidget(exchangeIndex: exchangeIndex)
                      ]);
                    }

                    return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)), child: exchangeListWidget());
                  }

                  Widget remarkTextFieldWidget() {
                    void onTapFromOutsiderFunction() {}
                    void onChangeFromOutsiderFunction() {
                      setState(() {});
                    }

                    Widget suggestWidget() {
                      return Padding(
                        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                        child: acceptSuggestButtonOrContainerWidget(
                          context: context,
                          level: Level.mini,
                          onTapFunction: () {
                            createRemakeOnTapFunction(sellCardAdvanceModelTemp: sellCardAdvanceModelTempSellCardGlobal);
                          },
                        ),
                      );
                    }

                    Widget remarkWidget() {
                      return Padding(
                        padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)),
                        child: textAreaGlobal(
                          controller: sellCardAdvanceModelTempSellCardGlobal.remark,
                          onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                          onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                          labelText: remarkOptionalStrGlobal,
                          level: Level.normal,
                        ),
                      );
                    }

                    return Padding(
                      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                      child: CustomButtonGlobal(
                        sizeBoxWidth: calculateCardWidthGlobal,
                        insideSizeBoxWidget: Column(children: [suggestWidget(), remarkWidget()]),
                        onTapUnlessDisable: onTapFromOutsiderFunction,
                      ),
                    );

                    // return
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: [paddingTotalProviderWidget(), remarkTextFieldWidget(), paddingExchangeListWidget()]),
                  );
                }

                Widget paddingBottomAnalysisButtonWidget() {
                  void analysisFunctionOnTap() {
                    addActiveLogElement(
                      activeLogModelList: activeLogModelSellCardList,
                      activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
                        Location(title: "card calculation", subtitle: "advance calculation"),
                        Location(color: ColorEnum.blue, title: "button name", subtitle: "analysis button"),
                      ]),
                    );
                    void callBack() {
                      isAllowAnalysis = false;
                      Future.delayed(const Duration(seconds: delayApiRequestSecond), () {
                        isAllowAnalysis = true;
                        if (mounted) {
                          setStateFromDialog(() {});
                        }
                      });
                      setStateFromDialog(() {});
                    }

                    setExchangeAnalysisCardGlobal(
                        callBack: callBack,
                        context: context,
                        sellCardModelTemp: sellCardAdvanceModelTempSellCardGlobal,
                        exchangeAnalysisCard: exchangeAnalysisCardSellCardGlobal);
                  }

                  return Padding(
                    padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                    child: analysisButtonOrContainerWidget(
                      context: context,
                      level: Level.mini,
                      validModel: checkAnalysisExchangeValidate(),
                      onTapFunction: analysisFunctionOnTap,
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [paddingBottomToggleOrTextWidget(), paddingBottomAnalysisButtonWidget(), Expanded(child: getMoneyFromCustomer())],
                );
              }

              return Row(children: [Expanded(child: paddingRightTableAndRateDiscountListWidget()), getMoneyWidget()]);
            }

            return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: tableCardListAndGetMoneyWidget());
          }

          Widget paddingTitleTextWidget() {
            Widget titleTextWidget() {
              return Text(cardCalculateStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold));
            }

            return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: titleTextWidget());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [paddingTitleTextWidget(), Expanded(child: paddingBottomTableAndGetMoneyWidget())],
          );
        }

        initCardDiscountPriceBySellPriceFirstIndex();
        // buyAndSellDiscountRateList = [];
        initRateDiscountList();
        actionDialogSetStateGlobal(
          // analysisFunctionOnTap: analysisFunctionOnTap,
          // validAnalysisButtonFunction: validAnalysisButtonFunction,
          dialogHeight: dialogSizeGlobal(level: Level.mini),
          dialogWidth: dialogSizeGlobal(level: Level.large),
          cancelFunctionOnTap: () {
            cancelFunctionOnTap(sellCardAdvanceModelTemp: sellCardAdvanceModelTempSellCardGlobal);
          },
          context: context,
          validSaveButtonFunction: () =>
              getValidGetMoneyFormCustomerFunction(isSimpleCalculate: false, sellCardAdvanceModelTemp: sellCardAdvanceModelTempSellCardGlobal),
          saveFunctionOnTap: () {
            saveFunctionOnTap(sellCardAdvanceModelTemp: sellCardAdvanceModelTempSellCardGlobal, isSimpleCalculate: false);
          },
          validSaveAndPrintButtonFunction: () =>
              getValidGetMoneyFormCustomerFunction(isSimpleCalculate: false, sellCardAdvanceModelTemp: sellCardAdvanceModelTempSellCardGlobal),
          saveAndPrintFunctionOnTap: () {
            saveAndPrintFunctionOnTap(sellCardAdvanceModelTemp: sellCardAdvanceModelTempSellCardGlobal, isSimpleCalculate: false);
          },
          contentFunctionReturnWidget: calculateCardDialog,
        );
      }

      void historyOnTapFunction() {
        limitHistory();
        addActiveLogElement(
          activeLogModelList: activeLogModelSellCardList,
          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "history button"),
          ]),
        );
        void cancelFunctionOnTap() {
          closeDialogGlobal(context: context);
          // setState(() {});
        }

        Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          void setStateOutsider() {
            setStateFromDialog(() {});
          }

          Widget titleTextWidget() {
            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text(sellCardHistoryStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))], //TODO: change this
              ),
            );
          }

          Widget sellCardHistoryListWidget() {
            //TODO: change this function name
            List<Widget> inWrapWidgetList() {
              return [
                for (int cardSellIndex = 0; cardSellIndex < sellCardModelListEmployeeGlobal.length; cardSellIndex++) //TODO: change this
                  HistoryElement(
                    isForceShowNoEffect: false,
                    isAdminEditing: false,
                    index: cardSellIndex,
                    sellCardModel: sellCardModelListEmployeeGlobal[cardSellIndex], //TODO: change this
                    setStateOutsider: setStateOutsider,
                  )
              ];
            }

            void topFunction() {}
            void bottomFunction() {
              if (!outOfDataQuerySellCardListGlobal) {
                //TODO: change this
                final int beforeQuery = sellCardModelListEmployeeGlobal.length; //TODO: change this
                void callBack() {
                  final int afterQuery = sellCardModelListEmployeeGlobal.length; //TODO: change this

                  if (beforeQuery == afterQuery) {
                    outOfDataQuerySellCardListGlobal = true; //TODO: change this
                  } else {
                    skipSellCardListGlobal = skipSellCardListGlobal + queryLimitNumberGlobal; //TODO: change this
                  }
                  setStateFromDialog(() {});
                }

                getSellCardListEmployeeGlobal(
                  employeeId: profileModelEmployeeGlobal!.id!,
                  callBack: callBack,
                  context: context,
                  skip: skipSellCardListGlobal,
                  targetDate: DateTime.now(),
                  sellCardModelListEmployee: sellCardModelListEmployeeGlobal,
                ); //TODO: change this
              }
            }

            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: !outOfDataQuerySellCardListGlobal,
            );
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleTextWidget(), Expanded(child: sellCardHistoryListWidget())]);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini),
          dialogWidth: dialogSizeGlobal(level: Level.mini),
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      // void previousOnTapFunction() {}

      // Widget previousWidget() {
      //   return Container();
      // }

      // bool isValidShowPrevious() {
      //   //TODO: add condition
      //   return false;
      // }
      void clearFunction() {
        activeLogModelSellCardList = [];
        moneyTypeSelectForRemake = null;
        sellCardModelTempSideMenuListGlobal = [];
        clearCardOrderList(isClearQty: true);
        for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
          for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++) {
            limitMainStockList(categoryCardModel: cardModelListGlobal[cardIndex].categoryList[categoryIndex]);
          }
        }
        addActiveLogElement(
          activeLogModelList: activeLogModelSellCardList,
          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.red, title: "button name", subtitle: "clear button"),
          ]),
        );
        setState(() {});
      }

      List<Widget?> customRowBetweenHeaderAndBodyWidget() {
        Widget? mergeCalculateWidget({required int sellCardIndex}) {
          Widget? amountTextWidget({required SellCardModel sellCardAdvanceModelTemp}) {
            Widget insideSizeBoxWidget() {
              Widget moneyTypeTextWidget() {
                final String moneyTypeStr = sellCardAdvanceModelTemp.mergeCalculate!.moneyType;
                return Padding(
                  padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                  child: Text("$totalByCardStrGlobal$moneyTypeStr", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                );
              }

              Widget scrollTextAmountWidget() {
                final String moneyTypeStr = sellCardAdvanceModelTemp.mergeCalculate!.moneyType;
                final int place = findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!;
                final String amountStr = formatAndLimitNumberTextGlobal(
                  valueStr: sellCardAdvanceModelTemp.mergeCalculate!.totalMoney.toString(),
                  isRound: false,
                  isAllowZeroAtLast: false,
                  places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                );
                return Padding(
                  padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal), left: paddingSizeGlobal(level: Level.large)),
                  child: scrollText(
                      textStr: "$amountStr $moneyTypeStr",
                      textStyle: textStyleGlobal(level: Level.large, color: positiveColorGlobal),
                      alignment: Alignment.topLeft),
                );
              }

              Widget getMoneyTextFieldWidget() {
                Widget textFieldWidget() {
                  final String getMoneyFromCustomerTemp = sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.getMoneyController.text;
                  return Padding(
                    padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)),
                    child: textFieldGlobal(
                      textFieldDataType: TextFieldDataType.double,
                      controller: sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.getMoneyController,
                      labelText: getMoneyStrGlobal,
                      level: Level.normal,
                      onTapFromOutsiderFunction: () {},
                      onChangeFromOutsiderFunction: () {
                        final String getMoneyFromCustomerChangeTemp = sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.getMoneyController.text;
                        final String moneyTypeStr = sellCardAdvanceModelTemp.mergeCalculate!.moneyType;
                        addActiveLogElement(
                          activeLogModelList: activeLogModelSellCardList,
                          activeLogModel: ActiveLogModel(
                            idTemp: "get money, $moneyTypeStr",
                            activeType: ActiveLogTypeEnum.typeTextfield,
                            locationList: [
                              Location(title: "card calculation", subtitle: "simple calculation"),
                              Location(title: "calculate by", subtitle: moneyTypeStr),
                              Location(
                                color: (getMoneyFromCustomerTemp.length < getMoneyFromCustomerChangeTemp.length) ? ColorEnum.green : ColorEnum.red,
                                title: "get money textfield",
                                subtitle: "${getMoneyFromCustomerTemp.isEmpty ? "" : "$getMoneyFromCustomerTemp to "}$getMoneyFromCustomerChangeTemp",
                              ),
                            ],
                          ),
                        );
                        sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.getMoney =
                            sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.getMoneyController.text.isEmpty
                                ? "0"
                                : sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.getMoneyController.text;

                        final double getMoneyNumber = sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.getMoneyController.text.isEmpty
                            ? 0
                            : textEditingControllerToDouble(controller: sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.getMoneyController)!;

                        final double totalMoneyNumber = sellCardAdvanceModelTemp.mergeCalculate!.totalMoney;

                        sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.giveMoney = double.parse(formatAndLimitNumberTextGlobal(
                          valueStr: (totalMoneyNumber - getMoneyNumber).toString(),
                          isRound: false,
                          isAddComma: false,
                          places: findMoneyModelByMoneyType(moneyType: sellCardAdvanceModelTemp.mergeCalculate!.moneyType).decimalPlace!,
                        ));
                        setState(() {});
                      },
                    ),
                  );
                }

                Widget clearButtonWidget() {
                  void clearFunctionOnTap() {
                    final String moneyTypeStr = sellCardAdvanceModelTemp.mergeCalculate!.moneyType;
                    addActiveLogElement(
                      activeLogModelList: activeLogModelSellCardList,
                      activeLogModel: ActiveLogModel(
                        activeType: ActiveLogTypeEnum.clickButton,
                        locationList: [
                          Location(title: "calculate by", subtitle: moneyTypeStr),
                          Location(color: ColorEnum.red, title: "button name", subtitle: "clear button"),
                        ],
                      ),
                    );

                    sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.getMoneyController.clear();
                    sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.getMoney = "0";
                    sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.giveMoney = sellCardAdvanceModelTemp.mergeCalculate!.totalMoney;
                    setState(() {});
                  }

                  return clearButtonOrContainerWidget(
                    context: context,
                    validModel: ValidButtonModel(
                      isValid: sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.getMoneyController.text.isNotEmpty,
                      error: "customer has not give money yet.",
                    ),
                    level: Level.normal,
                    onTapFunction: clearFunctionOnTap,
                    isShowText: false,
                  );
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal), left: paddingSizeGlobal(level: Level.large)),
                  child: Row(children: [Expanded(child: textFieldWidget()), clearButtonWidget()]),
                );
              }

              Widget giveTextAmountWidget() {
                final String moneyTypeStr = sellCardAdvanceModelTemp.mergeCalculate!.moneyType;
                final int place = findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!;
                final String amountStr = formatAndLimitNumberTextGlobal(
                  valueStr: sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.giveMoney.toString(),
                  isRound: false,
                  isAllowZeroAtLast: false,
                  places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                );
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: paddingSizeGlobal(level: Level.normal),
                    top: paddingSizeGlobal(level: Level.normal),
                    left: paddingSizeGlobal(level: Level.large),
                  ),
                  child: scrollText(
                      textStr: "$amountStr $moneyTypeStr",
                      textStyle: textStyleGlobal(
                        level: Level.large,
                        color: (sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.giveMoney! >= 0) ? positiveColorGlobal : negativeColorGlobal,
                      ),
                      alignment: Alignment.topLeft),
                );
              }

              Widget saveOrSaveAndPrintWidget() {
                ValidButtonModel checkValidSave() {
                  if (sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.getMoneyController.text.isEmpty) {
                    // return false;
                    return ValidButtonModel(isValid: false, error: "customer has not give money yet.");
                  }
                  final double getMoneyNumber =
                      textEditingControllerToDouble(controller: sellCardAdvanceModelTemp.mergeCalculate!.customerMoneyList.first.getMoneyController)!;
                  if (getMoneyNumber == 0) {
                    // return false;
                    return ValidButtonModel(isValid: false, error: "customer has not give money yet.");
                  }

                  if (getMoneyNumber < sellCardAdvanceModelTemp.mergeCalculate!.totalMoney) {
                    // return false;
                    return ValidButtonModel(isValid: false, error: "customer does not give enough money.");
                  }

                  return getValidGetMoneyFormCustomerFunction(isSimpleCalculate: true, sellCardAdvanceModelTemp: sellCardAdvanceModelTemp);
                }

                return Row(children: [
                  Expanded(
                    flex: 2,
                    child: saveButtonOrContainerWidget(
                      context: context,
                      validModel: checkValidSave(),
                      level: Level.mini,
                      onTapFunction: () {
                        sellCardAdvanceModelTemp.remark.text = sellCardAdvanceModelTempSellCardGlobal.remark.text;
                        saveFunctionOnTap(sellCardAdvanceModelTemp: sellCardAdvanceModelTemp, isSimpleCalculate: true);
                      },
                    ),
                  ),
                  SizedBox(width: paddingSizeGlobal(level: Level.mini)),
                  Expanded(
                    flex: 3,
                    child: saveAndPrintButtonOrContainerWidget(
                      context: context,
                      validModel: checkValidSave(),
                      level: Level.mini,
                      onTapFunction: () {
                        sellCardAdvanceModelTemp.remark.text = sellCardAdvanceModelTempSellCardGlobal.remark.text;
                        saveAndPrintFunctionOnTap(sellCardAdvanceModelTemp: sellCardAdvanceModelTemp, isSimpleCalculate: true);
                      },
                    ),
                  ),
                ]);
              }

              return Column(children: [
                moneyTypeTextWidget(),
                Stack(
                  children: [
                    Column(children: [scrollTextAmountWidget(), getMoneyTextFieldWidget()]),
                    Positioned(top: 9, child: Text("-", style: TextStyle(fontSize: textSizeGlobal(level: Level.large) * 1.5)))
                  ],
                ),
                drawLineGlobal(),
                giveTextAmountWidget(),
                saveOrSaveAndPrintWidget(),
              ]);
            }

            void onTapUnlessDisable() {}
            return (sellCardAdvanceModelTemp.mergeCalculate!.totalMoney == 0)
                ? null
                : CustomButtonGlobal(sizeBoxWidth: sizeBoxWidthGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
          }

          return amountTextWidget(sellCardAdvanceModelTemp: sellCardModelTempSideMenuListGlobal[sellCardIndex]);
        }

        Widget cardStockListWidget() {
          Widget cardWidget() {
            void onTapUnlessDisable() {}
            Widget cardElement() {
              Widget cardElementTextWidget({required CardListSellCardModel cardListSellCardModel}) {
                final String cardCompanyName = cardListSellCardModel.cardCompanyName;
                final String category = formatAndLimitNumberTextGlobal(valueStr: cardListSellCardModel.category.toString(), isRound: false);
                final String qty = formatAndLimitNumberTextGlobal(valueStr: cardListSellCardModel.qty.toString(), isRound: false);
                return Text("$cardCompanyName x $category: -$qty", style: textStyleGlobal(level: Level.normal, color: negativeColorGlobal));
              }

              return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text(cardOrderStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                for (int cardIndex = 0; cardIndex < sellCardModelTempSideMenuListGlobal.first.moneyTypeList.length; cardIndex++)
                  for (int cardSubIndex = 0; cardSubIndex < sellCardModelTempSideMenuListGlobal.first.moneyTypeList[cardIndex].cardList.length; cardSubIndex++)
                    cardElementTextWidget(cardListSellCardModel: sellCardModelTempSideMenuListGlobal.first.moneyTypeList[cardIndex].cardList[cardSubIndex])
              ]);
            }

            return Row(
                children: [CustomButtonGlobal(sizeBoxWidth: sizeBoxWidthGlobal, insideSizeBoxWidget: cardElement(), onTapUnlessDisable: onTapUnlessDisable)]);
          }

          bool isShowCard() {
            for (int companyIndex = 0; companyIndex < cardModelListGlobal.length; companyIndex++) {
              for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[companyIndex].categoryList.length; categoryIndex++) {
                for (int mainIndexIndex = 0;
                    mainIndexIndex < cardModelListGlobal[companyIndex].categoryList[categoryIndex].mainPriceList.length;
                    mainIndexIndex++) {
                  if (cardModelListGlobal[companyIndex].categoryList[categoryIndex].mainPriceList[mainIndexIndex].maxStock != 0) {
                    return true;
                  }
                }
              }
            }
            return false;
          }

          return isShowCard() ? cardWidget() : Container();
        }

        Widget remarkTextFieldWidget() {
          void onTapFromOutsiderFunction() {}
          void onChangeFromOutsiderFunction() {
            setState(() {});
          }

          Widget moneyTypeDropDownWidget() {
            void onTapFunction() {}
            void onChangedFunction({required String value, required int index}) {
              if (index == 0) {
                moneyTypeSelectForRemake = null;
                sellCardAdvanceModelTempSellCardGlobal.remark.text = "";
              } else {
                moneyTypeSelectForRemake = value;
                final int indexMatch = sellCardModelTempSideMenuListGlobal.indexWhere((element) => element.mergeCalculate!.moneyType == value);
                sellCardAdvanceModelTempSellCardGlobal.remark.text =
                    createRemakeOnTapFunction(sellCardAdvanceModelTemp: sellCardModelTempSideMenuListGlobal[indexMatch]);
              }
              for (int indexSellCard = 0; indexSellCard < sellCardModelTempSideMenuListGlobal.length; indexSellCard++) {
                sellCardModelTempSideMenuListGlobal[indexSellCard].remark.text = sellCardAdvanceModelTempSellCardGlobal.remark.text;
              }
              setState(() {});
            }

            List<String> moneyTypeCustomize() {
              List<String> moneyList = ["None"];
              for (int sellCardIndex = 0; sellCardIndex < sellCardModelTempSideMenuListGlobal.length; sellCardIndex++) {
                if (sellCardModelTempSideMenuListGlobal[sellCardIndex].mergeCalculate!.totalMoney != 0) {
                  moneyList.add(sellCardModelTempSideMenuListGlobal[sellCardIndex].mergeCalculate!.moneyType);
                }
              }
              return moneyList;
            }

            return customDropdown(
              level: Level.normal,
              labelStr: createRemakeByMoneyTypeStrGlobal,
              onTapFunction: onTapFunction,
              onChangedFunction: onChangedFunction,
              selectedStr: moneyTypeSelectForRemake,
              // menuItemStrList: moneyTypeOnlyList(moneyTypeDefault: moneyTypeSelectForRemake, isHasNone: true),
              menuItemStrList: moneyTypeCustomize(),
            );
          }

          return Padding(
            padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini), bottom: paddingSizeGlobal(level: Level.normal)),
            child: CustomButtonGlobal(
              sizeBoxWidth: dialogSizeGlobal(level: Level.mini),
              insideSizeBoxWidget: Column(children: [
                Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)), child: moneyTypeDropDownWidget()),
                Padding(
                  padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)),
                  child: textAreaGlobal(
                    controller: sellCardAdvanceModelTempSellCardGlobal.remark,
                    onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                    onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                    labelText: remarkOptionalStrGlobal,
                    level: Level.normal,
                  ),
                ),
              ]),
              onTapUnlessDisable: onTapFromOutsiderFunction,
            ),
          );
        }

        return sellCardModelTempSideMenuListGlobal.isNotEmpty
            ? [
                for (int sellCardIndex = 0; sellCardIndex < sellCardModelTempSideMenuListGlobal.length; sellCardIndex++)
                  mergeCalculateWidget(sellCardIndex: sellCardIndex),
                cardStockListWidget(),
                remarkTextFieldWidget(),
              ]
            : [];
      }

      return BodyTemplateSideMenu(
        customBetweenHeaderAndBodyWidget: inWrapWidgetList(),
        title: widget.title,
        // isValidCalculateOnTap: isValidCard(isEqualMainAndSellPrice: false),
        isValidAdvanceCalculateOnTap: isValidCard(isEqualMainAndSellPrice: false),
        inWrapWidgetList: customRowBetweenHeaderAndBodyWidget(),
        advanceCalculateOnTapFunction: advanceCalculateOnTapFunction,
        historyOnTapFunction: historyOnTapFunction,
        clearFunction: clearFunction,
        // isValidShowPrevious: isValidShowPrevious(),
      );
    }

    // return _isLoadingOnInitCard ? Container() : bodyTemplateSideMenu();
    return bodyTemplateSideMenu();
  }
}
