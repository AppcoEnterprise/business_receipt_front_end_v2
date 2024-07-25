import 'dart:convert';

import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/rate.dart';
import 'package:business_receipt/env/function/request_api/card_request_api_env.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/employee_model/card/card_other_model.dart';
import 'package:business_receipt/model/employee_model/card/company_x_category_model.dart';
import 'package:business_receipt/model/employee_model/card/sell_card_model.dart';
import 'package:business_receipt/model/money_type_and_value_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:flutter/material.dart';

//---------------------query card stock---------------------------------

Future<void> getMoreMainStockWithCondition({
  required CardCategoryListCardModel categoryCardModel,
  required BuildContext context,
  required Function setStateFromDialog,
  required String cardCompanyNameId,
  required String categoryId,
  required bool isAdminQuery,
  required DateTime targetDate,
}) async {
  if (!categoryCardModel.outOfDataQueryCardMainStockList) {
    //TODO: change this
    final int beforeQuery = categoryCardModel.mainPriceList.length; //TODO: change this
    void callBack() {
      final int afterQuery = categoryCardModel.mainPriceList.length; //TODO: change this

      if (beforeQuery == afterQuery) {
        categoryCardModel.outOfDataQueryCardMainStockList = true; //TODO: change this
      } else {
        categoryCardModel.skipCardMainStockList += queryLimitNumberGlobal; //TODO: change this
      }
      setStateFromDialog(() {});
    }

    isAdminQuery
        ? await getMainCardListAdminGlobal(
            callBack: callBack,
            cardCompanyNameId: cardCompanyNameId,
            categoryId: categoryId,
            context: context,
            skip: categoryCardModel.skipCardMainStockList,
            cardMainPriceListCardModelList: categoryCardModel.mainPriceList,
          )
        : await getMainCardListEmployeeGlobal(
            callBack: callBack,
            targetDate: targetDate,
            cardCompanyNameId: cardCompanyNameId,
            categoryId: categoryId,
            context: context,
            skip: categoryCardModel.skipCardMainStockList,
            cardMainPriceListCardModelList: categoryCardModel.mainPriceList,
          ); //TODO: change this
  }
}

void limitMainStockList({required CardCategoryListCardModel categoryCardModel}) {
  categoryCardModel.skipCardMainStockList = queryLimitNumberGlobal;
  categoryCardModel.outOfDataQueryCardMainStockList = false;
  // selectedCategoryIndex = categoryIndex;

  if (categoryCardModel.mainPriceList.length > queryLimitNumberGlobal) {
    List<CardMainPriceListCardModel> mainPriceListTemp = [];
    for (int index = 0; index < queryLimitNumberGlobal; index++) {
      mainPriceListTemp.add(categoryCardModel.mainPriceList[index]);
    }
    categoryCardModel.mainPriceList = mainPriceListTemp;
  }
}

//------------------get all price list----------------
List<MoneyTypeAndValueModel> getCardPriceOnlyList({required String companyNameStr, required double categoryNumber}) {
  List<MoneyTypeAndValueModel> cardPriceList = [];

  final int qtyNumber = getQty(companyNameStr: companyNameStr, categoryNumber: categoryNumber);

  final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
  final String companyNameId = cardModelListGlobal[companyNameIndex].id!;
  final int categoryIndex = cardModelListGlobal[companyNameIndex]
      .categoryList
      .indexWhere((element) => (textEditingControllerToDouble(controller: element.category) == categoryNumber)); //never equal -1
  final String categoryId = cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].id!;

  bool isMatchQtyBetweenStartAndEndValue({required CardSellPriceListCardModel cardSellPriceListCardModel, required int qtyNumber}) {
    final int startValueNumber = textEditingControllerToInt(controller: cardSellPriceListCardModel.startValue)!;
    final int endValueNumber = textEditingControllerToInt(controller: cardSellPriceListCardModel.endValue)!;
    return ((startValueNumber <= qtyNumber) && (qtyNumber <= endValueNumber));
  }

  // for (int cardCombineIndex = 0; cardCombineIndex < cardCombineModelListGlobal.length; cardCombineIndex++) {
  //   for (int cardSubCombineIndex = 0; cardSubCombineIndex < cardCombineModelListGlobal[cardCombineIndex].cardList.length; cardSubCombineIndex++) {
  //     final String cardCombineCompanyId = cardCombineModelListGlobal[cardCombineIndex].cardList[cardSubCombineIndex].cardCompanyId!;
  //     final String cardCombineCategoryId = cardCombineModelListGlobal[cardCombineIndex].cardList[cardSubCombineIndex].categoryId!;
  //     final String sellPriceId = cardCombineModelListGlobal[cardCombineIndex].cardList[cardSubCombineIndex].sellPriceId!;
  //     if (companyNameId == cardCombineCompanyId && categoryId == cardCombineCategoryId) {
  //       break;
  //     }
  //   }
  // }

  for (int sellPriceIndex = 0; sellPriceIndex < cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList.length; sellPriceIndex++) {
    // final int startValueNumber =
    //     textEditingControllerToInt(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].startValue)!;
    // final int endValueNumber =
    //     textEditingControllerToInt(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].endValue)!;
    // if ((startValueNumber <= qtyNumber) && (qtyNumber <= endValueNumber)) {
    //   final double priceNumber =
    //       textEditingControllerToDouble(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].price)!;
    //   final String moneyTypeStr = cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType!;
    //   cardPriceList.add(MoneyTypeAndValueModel(value: priceNumber, moneyType: moneyTypeStr));
    // }
    final bool isMatchQty = isMatchQtyBetweenStartAndEndValue(
      cardSellPriceListCardModel: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex],
      qtyNumber: qtyNumber,
    );
    if (isMatchQty) {
      final double priceNumber =
          textEditingControllerToDouble(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].price)!;
      final String moneyTypeStr = cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType!;
      final String sellPriceId = cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].id!;
      cardPriceList.add(MoneyTypeAndValueModel(value: priceNumber, moneyType: moneyTypeStr, sellPriceId: sellPriceId));
    }
  }
  //cardPriceList = [{sellPriceId: "111", value: 1000, moneyType: USD}, {sellPriceId: "222", value: 2000, moneyType: KHR}]
  for (int cardPriceIndex = 0; cardPriceIndex < cardPriceList.length; cardPriceIndex++) {
    //cardCombineModelListGlobal= [{combineName: "t", cardList: [{cardCompanyId: "111", categoryId: "222", sellPriceId: "333"}, {cardCompanyId: "444", categoryId: "555", sellPriceId: "666"}]}
    for (int cardCombineIndex = 0; cardCombineIndex < cardCombineModelListGlobal.length; cardCombineIndex++) {
      for (int cardSubCombineIndex = 0; cardSubCombineIndex < cardCombineModelListGlobal[cardCombineIndex].cardList.length; cardSubCombineIndex++) {
        final String cardCombineCompanyId = cardCombineModelListGlobal[cardCombineIndex].cardList[cardSubCombineIndex].cardCompanyId!;
        final String cardCombineCategoryId = cardCombineModelListGlobal[cardCombineIndex].cardList[cardSubCombineIndex].categoryId!;
        final String sellPriceId = cardCombineModelListGlobal[cardCombineIndex].cardList[cardSubCombineIndex].sellPriceId!;
        if (companyNameId == cardCombineCompanyId && categoryId == cardCombineCategoryId && cardPriceList[cardPriceIndex].sellPriceId == sellPriceId) {
          bool isAllMatch = true;
          for (int cardSubSubCombineIndex = 0;
              cardSubSubCombineIndex < cardCombineModelListGlobal[cardCombineIndex].cardList.length;
              cardSubSubCombineIndex++) {
            if (cardSubSubCombineIndex != cardSubCombineIndex) {
              final String cardCompanyId = cardCombineModelListGlobal[cardCombineIndex].cardList[cardSubSubCombineIndex].cardCompanyId!;
              final String categoryId = cardCombineModelListGlobal[cardCombineIndex].cardList[cardSubSubCombineIndex].categoryId!;
              final String sellPriceId = cardCombineModelListGlobal[cardCombineIndex].cardList[cardSubSubCombineIndex].sellPriceId!;
              final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.id == cardCompanyId));

              final int categoryIndex = cardModelListGlobal[companyNameIndex].categoryList.indexWhere((element) => (element.id == categoryId));
              if (cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].qty.text.isNotEmpty) {
                final int qtyNumber = textEditingControllerToInt(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].qty)!;
                if (qtyNumber != 0) {
                  final int sellPriceIndex =
                      cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList.indexWhere((element) => (element.id == sellPriceId));

                  final bool isMatchQty = isMatchQtyBetweenStartAndEndValue(
                    cardSellPriceListCardModel: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex],
                    qtyNumber: qtyNumber,
                  );
                  if (!isMatchQty) {
                    isAllMatch = false;
                    break;
                  }
                } else {
                  isAllMatch = false;
                  break;
                }
              } else {
                isAllMatch = false;
                break;
              }
            }
          }
          if (isAllMatch) {
            final MoneyTypeAndValueModel moneyTypeAndValueModel = cardPriceList[cardPriceIndex];
            cardPriceList.removeAt(cardPriceIndex);
            cardPriceList.insert(0, moneyTypeAndValueModel);

          }
        }
      }
    }
  }
  return cardPriceList;
}

List<MoneyTypeAndValueModel> getCardDiscountPriceOnlyList({required String companyNameStr, required double categoryNumber}) {
  List<MoneyTypeAndValueModel> cardDiscountPriceList = [];
  MoneyTypeAndValueModel? sellPriceModel = getSellPriceBySelectedSellPriceIndex(companyNameStr: companyNameStr, categoryNumber: categoryNumber);
  final bool isSellPriceModelNotNull = (sellPriceModel != null);
  if (isSellPriceModelNotNull) {
    final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
    final int categoryIndex = cardModelListGlobal[companyNameIndex]
        .categoryList
        .indexWhere((element) => (textEditingControllerToDouble(controller: element.category) == categoryNumber)); //never equal -1
    for (int sellPriceIndex = 0; sellPriceIndex < cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList.length; sellPriceIndex++) {
      final String moneyTypeStr = cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType!; //never equal null
      final bool isMatchMoneyType = (moneyTypeStr == sellPriceModel.moneyType);
      if (isMatchMoneyType) {
        final double priceNumber =
            textEditingControllerToDouble(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].price)!;
        final String moneyTypeStr = cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType!;
        cardDiscountPriceList.add(MoneyTypeAndValueModel(value: priceNumber, moneyType: moneyTypeStr));
      }
    }
  }
  return cardDiscountPriceList;
}

//------------------get value form card main class---------------
int getSelectedSellPriceIndex({required String companyNameStr, required double categoryNumber}) {
  final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
  final int categoryIndex = cardModelListGlobal[companyNameIndex]
      .categoryList
      .indexWhere((element) => (textEditingControllerToDouble(controller: element.category) == categoryNumber)); //never equal -1
  return cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].selectedSellPriceIndex;
}

int getSelectedSellDiscountPriceIndex({required String companyNameStr, required double categoryNumber}) {
  final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
  final int categoryIndex = cardModelListGlobal[companyNameIndex]
      .categoryList
      .indexWhere((element) => (textEditingControllerToDouble(controller: element.category) == categoryNumber)); //never equal -1
  return cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].selectedSellDiscountPriceIndex;
}

bool getIsShowTextField({required String companyNameStr, required double categoryNumber}) {
  final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
  final int categoryIndex = cardModelListGlobal[companyNameIndex]
      .categoryList
      .indexWhere((element) => (textEditingControllerToDouble(controller: element.category) == categoryNumber)); //never equal -1
  return cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].isShowTextField;
}

double getDiscountPriceNumber({required String companyNameStr, required double categoryNumber}) {
  MoneyTypeAndValueModel getSellDiscountPriceBySelectedSellPriceIndex() {
    List<MoneyTypeAndValueModel> cardDiscountPriceList = getCardDiscountPriceOnlyList(companyNameStr: companyNameStr, categoryNumber: categoryNumber);
    final int selectedSellDiscountPriceIndex = getSelectedSellDiscountPriceIndex(companyNameStr: companyNameStr, categoryNumber: categoryNumber);
    return cardDiscountPriceList[selectedSellDiscountPriceIndex]; //cardDiscountPriceList will never be empty
  }

  MoneyTypeAndValueModel cardDiscountPriceModel = getSellDiscountPriceBySelectedSellPriceIndex();
  final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
  final int categoryIndex = cardModelListGlobal[companyNameIndex]
      .categoryList
      .indexWhere((element) => (textEditingControllerToDouble(controller: element.category) == categoryNumber)); //never equal -1

  final bool isNullDiscount = (cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].discountPriceAndMoneyTypeController == null);
  if (isNullDiscount) {
    final String priceStr = formatAndLimitNumberTextGlobal(valueStr: cardDiscountPriceModel.value.toString(), isRound: false, isAllowZeroAtLast: false);
    final String moneyType = cardDiscountPriceModel.moneyType;
    final String priceAndMoneyTypeStr = "$priceStr$spaceStrGlobal$moneyType";
    cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].discountPriceAndMoneyTypeController = TextEditingController(text: priceAndMoneyTypeStr);
  }
  final TextEditingController discountPriceController = cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].discountPriceAndMoneyTypeController!;
  double discountPriceNumber = 0;
  final bool isDiscountPriceNotEmpty = discountPriceController.text.isNotEmpty;
  if (isDiscountPriceNotEmpty) {
    discountPriceNumber = textEditingControllerToDouble(controller: discountPriceController)!;
  }
  return discountPriceNumber;
}

int getQty({required String companyNameStr, required double categoryNumber}) {
  final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
  final int categoryIndex = cardModelListGlobal[companyNameIndex]
      .categoryList
      .indexWhere((element) => (textEditingControllerToDouble(controller: element.category) == categoryNumber)); //never equal -1

  final TextEditingController qtyController = cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].qty;
  int qtyNumber = 0;
  final bool isQtyStrNotEmpty = qtyController.text.isNotEmpty;
  if (isQtyStrNotEmpty) {
    qtyNumber = textEditingControllerToInt(controller: qtyController)!;
  }
  return qtyNumber;
}

//----------------------------get index by price and money type------------------------------------
int getSelectedSellPriceIndexByPriceAndMoneyTypeStr({required String companyNameStr, required double categoryNumber, required String priceAndMoneyTypeStr}) {
  final MoneyTypeAndValueModel moneyTypeAndValueModel = convertStringToMoneyTypeAndValueModel(priceAndMoneyTypeStr: priceAndMoneyTypeStr);
  List<MoneyTypeAndValueModel> cardPriceList = getCardPriceOnlyList(companyNameStr: companyNameStr, categoryNumber: categoryNumber);
  for (int sellPriceIndex = 0; sellPriceIndex < cardPriceList.length; sellPriceIndex++) {
    final bool isMatchPrice = (cardPriceList[sellPriceIndex].value == moneyTypeAndValueModel.value);
    final bool isMatchMoneyType = (cardPriceList[sellPriceIndex].moneyType == moneyTypeAndValueModel.moneyType);
    if (isMatchPrice && isMatchMoneyType) {
      return sellPriceIndex;
    }
  }
  return -1; //never reach this line
}

int getSelectedSellDiscountPriceIndexByPriceAndMoneyTypeStr(
    {required String companyNameStr, required double category, required String discountPriceAndMoneyTypeStr}) {
  final MoneyTypeAndValueModel moneyTypeAndDiscountValueModel = convertStringToMoneyTypeAndValueModel(priceAndMoneyTypeStr: discountPriceAndMoneyTypeStr);
  final List<MoneyTypeAndValueModel> moneyTypeAndDiscountValueModelList =
      getCardDiscountPriceOnlyList(companyNameStr: companyNameStr, categoryNumber: category);

  return moneyTypeAndDiscountValueModelList.indexWhere((element) {
    final bool isMatchValue = (element.value == moneyTypeAndDiscountValueModel.value);
    final bool isMatchMoneyType = (element.moneyType == moneyTypeAndDiscountValueModel.moneyType);
    return (isMatchValue && isMatchMoneyType);
  }); //never equal -1
}

//------------------get sell price model from sell price list --------------------------------------
MoneyTypeAndValueModel? getSellPriceBySelectedSellPriceIndex({required String companyNameStr, required double categoryNumber}) {
  //card price list
  List<MoneyTypeAndValueModel> cardPriceList = getCardPriceOnlyList(companyNameStr: companyNameStr, categoryNumber: categoryNumber);
  final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
  final int categoryIndex = cardModelListGlobal[companyNameIndex]
      .categoryList
      .indexWhere((element) => (textEditingControllerToDouble(controller: element.category) == categoryNumber));
  final int selectedSellPriceIndex = cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].selectedSellPriceIndex;
  final bool isCardPriceListEmpty = cardPriceList.isEmpty;
  return isCardPriceListEmpty ? null : cardPriceList[selectedSellPriceIndex];
}

//------------------get discount price and money type, can't return model, because sometime discount value can be null--------------------------------------
String getSellDiscountPriceBySelectedSellDiscountPriceIndex({required String companyNameStr, required double categoryNumber}) {
  List<MoneyTypeAndValueModel> cardDiscountPriceList = getCardDiscountPriceOnlyList(companyNameStr: companyNameStr, categoryNumber: categoryNumber);

  int selectedSellDiscountPriceIndex = getSelectedSellDiscountPriceIndex(companyNameStr: companyNameStr, categoryNumber: categoryNumber);

  final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
  final int categoryIndex = cardModelListGlobal[companyNameIndex]
      .categoryList
      .indexWhere((element) => (textEditingControllerToDouble(controller: element.category) == categoryNumber)); //never equal -1
  //get selectedSellPriceIndex of cardListAdminGlobal
  final bool isNullDiscount = (cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].discountPriceAndMoneyTypeController == null);
  if (isNullDiscount) {
    final String priceStr = formatAndLimitNumberTextGlobal(
        valueStr: cardDiscountPriceList[selectedSellDiscountPriceIndex].value.toString(), isRound: false, isAllowZeroAtLast: false);
    final String moneyType = cardDiscountPriceList[selectedSellDiscountPriceIndex].moneyType;
    final String priceAndMoneyTypeStr = "$priceStr$spaceStrGlobal$moneyType";

    cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].discountPriceAndMoneyTypeController = TextEditingController(text: priceAndMoneyTypeStr);
  }
  return cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].discountPriceAndMoneyTypeController!.text;
}

//--------------------------get profit----------------------------------------
double? calculateProfit({
  required String companyNameStr,
  required double categoryNumber,
  required List<BuyAndSellDiscountRate> buyAndSellDiscountRateList,
  List<MainPriceQty>? mainPriceQtyList,
  required bool isEqualMainAndSellPrice,
}) {
  final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
  final int categoryIndex = cardModelListGlobal[companyNameIndex]
      .categoryList
      .indexWhere((element) => (textEditingControllerToDouble(controller: element.category) == categoryNumber)); //never equal -1

  final MoneyTypeAndValueModel? moneyTypeAndValueModel = getSellPriceBySelectedSellPriceIndex(companyNameStr: companyNameStr, categoryNumber: categoryNumber);
  final bool isMoneyTypeAndValueNotNull = (moneyTypeAndValueModel != null);
  if (isMoneyTypeAndValueNotNull) {
    final String moneyType = moneyTypeAndValueModel.moneyType;
    final bool isMainPriceListNotEmpty = cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList.isNotEmpty;
    if (isMainPriceListNotEmpty) {
      final int qtyNumber = getQty(companyNameStr: companyNameStr, categoryNumber: categoryNumber);

      // int subTotalNumber = 0;
      // for (int cardIndex = 0; cardIndex < cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList.length; cardIndex++) {
      //   subTotalNumber = subTotalNumber +
      //       textEditingControllerToInt(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList[cardIndex].stock)!;
      // }
      // //qty 250
      // //subTotalNumber = 216
      // if (qtyNumber > subTotalNumber) {//250 > 216

      // }

      double profit = 0;
      double discountPriceNumber = 0;
      if (isEqualMainAndSellPrice) {
        discountPriceNumber = moneyTypeAndValueModel.value;
      } else {
        discountPriceNumber = getDiscountPriceNumber(companyNameStr: companyNameStr, categoryNumber: categoryNumber); //KHR
      }

      int mainStockTempNumber = 0;
      for (int mainPriceIndex = 0; mainPriceIndex < cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList.length; mainPriceIndex++) {
        mainStockTempNumber = mainStockTempNumber +
            textEditingControllerToInt(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].stock)!;
      }
      if (mainStockTempNumber < qtyNumber) {
        return null;
      }
      int qtyNumberTemp = qtyNumber; //15
      final List<CardMainPriceListCardModel> cardMainSeparateByRateList = [];

      for (int mainPriceIndex = 0; mainPriceIndex < cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList.length; mainPriceIndex++) {
        final CardMainPriceListCardModel cardMainPriceListCardModel =
            cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex];

        final DateTime? date = cardMainPriceListCardModel.date;
        final bool isDelete = cardMainPriceListCardModel.isDelete;
        final String? id = cardMainPriceListCardModel.id;
        final String? moneyType = cardMainPriceListCardModel.moneyType;
        final String price = cardMainPriceListCardModel.price.text;
        final String stock = cardMainPriceListCardModel.stock.text;
        final double stockNumber = textEditingControllerToDouble(controller: cardMainPriceListCardModel.stock)!;
        final String remark = cardMainPriceListCardModel.remark.text;
        final int maxStock = cardMainPriceListCardModel.maxStock;
        final bool isAddToStock = cardMainPriceListCardModel.isAddToStock;
        if (cardMainPriceListCardModel.rateList.isEmpty) {
          // final CardMainPriceListCardModel cardMainSeparateByRate = ;
          cardMainSeparateByRateList.add(CardMainPriceListCardModel(
            activeLogModelList: [],
            isAddToStock: isAddToStock,
            date: date,
            isDelete: isDelete,
            moneyType: moneyType,
            price: TextEditingController(text: price),
            stock: TextEditingController(text: stock),
            rateList: [],
            id: id,
            maxStock: maxStock,
            remark: TextEditingController(text: remark),
          ));
        } else {
          final List<CardMainPriceListCardModel> cardMainSeparateByRateListTemp = [];
          int firstRatePercentageIndex = 0;
          final double percentageStockNumber =
              textEditingControllerToInt(controller: cardMainPriceListCardModel.stock)! * 100 / cardMainPriceListCardModel.maxStock;
          double percentageIncreaseNumber = 0;
          //4 * 100 / 10 = 40
          for (int rateIndex = (cardMainPriceListCardModel.rateList.length - 1); rateIndex >= 0; rateIndex--) {
            percentageIncreaseNumber =
                percentageIncreaseNumber + textEditingControllerToDouble(controller: cardMainPriceListCardModel.rateList[rateIndex].percentage)!;
            //[0] 40 < 0
            //[1] 40 < 70
            if (percentageStockNumber < percentageIncreaseNumber) {
              firstRatePercentageIndex = rateIndex;
              break;
            }
          }
          for (int rateIndex = (cardMainPriceListCardModel.rateList.length - 1); rateIndex >= firstRatePercentageIndex; rateIndex--) {
            RateForCalculateModel rate = cloneRateForCalculate(rateForCalculate: cardMainPriceListCardModel.rateList[rateIndex]);
            final double percentageNumber = textEditingControllerToDouble(controller: rate.percentage)!;
            String stockWithPercentageStr = "";
            if (rateIndex == firstRatePercentageIndex) {
              double totalStockNumber = 0;

              for (int mainIndex = 0; mainIndex < cardMainSeparateByRateListTemp.length; mainIndex++) {
                totalStockNumber = totalStockNumber + textEditingControllerToInt(controller: cardMainSeparateByRateListTemp[mainIndex].stock)!;
              }
              stockWithPercentageStr = formatAndLimitNumberTextGlobal(valueStr: (stockNumber - totalStockNumber).toString(), isRound: false);
            } else {
              // stockWithPercentageStr = formatAndLimitNumberTextGlobal(valueStr: (percentageNumber * stockNumber / 100).toString(), isRound: true, places: 0);
              stockWithPercentageStr = formatAndLimitNumberTextGlobal(valueStr: (percentageNumber * maxStock / 100).toString(), isRound: true, places: 0);
            }
            if (stockWithPercentageStr != "0") {
              final CardMainPriceListCardModel cardMainSeparateByRate = CardMainPriceListCardModel(
                activeLogModelList: [],
                isAddToStock: isAddToStock,
                date: date,
                isDelete: isDelete,
                moneyType: moneyType,
                price: TextEditingController(text: price),
                stock: TextEditingController(text: stockWithPercentageStr),
                rateList: [rate],
                id: id,
                maxStock: maxStock,
                remark: TextEditingController(text: remark),
              );
              // cardMainSeparateByRateList.add(cardMainSeparateByRate);
              cardMainSeparateByRateListTemp.insert(0, cardMainSeparateByRate);
            }
          }
          cardMainSeparateByRateList.addAll(cardMainSeparateByRateListTemp);
        }
      }
      if (mainPriceQtyList != null) {}
      for (int mainPriceIndex = 0; mainPriceIndex < cardMainSeparateByRateList.length; mainPriceIndex++) {
        final CardMainPriceListCardModel cardMainPriceListCardModel = cardMainSeparateByRateList[mainPriceIndex];

        final String mainMoneyType = cardMainPriceListCardModel.moneyType!; //USD
        final double mainPriceNumber = textEditingControllerToDouble(controller: cardMainPriceListCardModel.price)!;
        double mainPriceConvertRateNumber = 0;
        final bool isSameMoneyType = (moneyType == mainMoneyType);
        RateForCalculateModel? convertRate;
        if (isSameMoneyType) {
          mainPriceConvertRateNumber = mainPriceNumber;
        } else {
          //get rate list from main price
          final List<RateForCalculateModel> rateList = cardMainPriceListCardModel.rateList;

          //get index of rate match with money type and main money type
          final int rateIndex = rateList.indexWhere((element) {
            final bool isMatchMoneyTypeAndMainMoneyType = (element.rateType.first == moneyType) && (element.rateType.last == mainMoneyType);
            final bool isMatchMoneyTypeAndMainMoneyTypeReverse = (element.rateType.first == mainMoneyType) && (element.rateType.last == moneyType);
            final bool isBuyRateMainPrice = (element.rateType.first == moneyType);
            final bool isMatchBuyRate = (element.isBuyRate == isBuyRateMainPrice);
            return ((isMatchMoneyTypeAndMainMoneyType || isMatchMoneyTypeAndMainMoneyTypeReverse) && isMatchBuyRate);
          });

          final bool isRateIndexMatch = (rateIndex != -1);
          if (isRateIndexMatch) {
            //matched rate index
            final double rateNumber = textEditingControllerToDouble(controller: rateList[rateIndex].discountValue)!;
            final bool isBuyRate = rateList[rateIndex].isBuyRate!;
            if (isBuyRate) {
              mainPriceConvertRateNumber = mainPriceNumber / rateNumber;
            } else {
              mainPriceConvertRateNumber = double.parse(
                formatAndLimitNumberTextGlobal(
                  isRound: true,
                  isAddComma: false,
                  valueStr: (mainPriceNumber * rateNumber).toString(),
                  isAllowZeroAtLast: false,
                ),
              );
            }
            convertRate = rateList[rateIndex];
          } else {
            final BuyAndSellDiscountRate? rateModelOrNull = getDiscountRateModel(
              rateTypeFirst: moneyType,
              rateTypeLast: mainMoneyType,
              buyAndSellDiscountRateList: buyAndSellDiscountRateList,
            );
            final bool isRateIndexMatch = (rateModelOrNull != null);
            if (isRateIndexMatch) {
              final bool isBuyRate = (rateModelOrNull.rateType.first == mainMoneyType);
              if (isBuyRate) {
                convertRate = rateModelOrNull.sell;
                final bool isSellNotEmpty = (rateModelOrNull.sell.discountValue.text.isNotEmpty); //NOTE: this is not wrong
                if (isSellNotEmpty) {
                  final double rateNumber = textEditingControllerToDouble(controller: rateModelOrNull.sell.discountValue)!; //NOTE: this is not wrong
                  mainPriceConvertRateNumber = mainPriceNumber * rateNumber;
                } else {
                  //TODO: pup up a textField to enter the missing rate value
                  final bool isMainPriceQtyListNotNull = (mainPriceQtyList != null);
                  if (isMainPriceQtyListNotNull) {
                    for (int mainIndex = 0; mainIndex < mainPriceQtyList.length; mainIndex++) {
                      mainPriceQtyList.removeAt(mainIndex);
                    }
                  }
                  return null;
                }
              } else {
                convertRate = rateModelOrNull.buy;
                final bool isBuyNotEmpty = (rateModelOrNull.buy.discountValue.text.isNotEmpty); //NOTE: this is not wrong
                if (isBuyNotEmpty) {
                  final double rateNumber = textEditingControllerToDouble(controller: rateModelOrNull.buy.discountValue)!; //NOTE: this is not wrong
                  mainPriceConvertRateNumber = mainPriceNumber / rateNumber;
                } else {
                  //TODO: pup up a textField to enter the missing rate value
                  final bool isMainPriceQtyListNotNull = (mainPriceQtyList != null);
                  if (isMainPriceQtyListNotNull) {
                    for (int mainIndex = 0; mainIndex < mainPriceQtyList.length; mainIndex++) {
                      mainPriceQtyList.removeAt(mainIndex);
                    }
                  }
                  return null;
                }
              }
            } else {
              //TODO: pup up a textField to enter the missing rate value
              final bool isMainPriceQtyListNotNull = (mainPriceQtyList != null);
              if (isMainPriceQtyListNotNull) {
                for (int mainIndex = 0; mainIndex < mainPriceQtyList.length; mainIndex++) {
                  mainPriceQtyList.removeAt(mainIndex);
                }
              }
              return null;
            }
          }
        }
        final int stockNumber = textEditingControllerToInt(controller: cardMainPriceListCardModel.stock)!; //10
        final bool isOutOfStock = ((stockNumber - qtyNumberTemp) < 0); //10
        if (isOutOfStock) {
          final bool isMainPriceQtyListNotNull = (mainPriceQtyList != null);
          if (isMainPriceQtyListNotNull) {
            final MainPriceQty mainPriceQty = MainPriceQty(qty: stockNumber, mainPrice: cardMainPriceListCardModel, rate: convertRate);
            mainPriceQtyList.add(mainPriceQty);
          }
          qtyNumberTemp = qtyNumberTemp - stockNumber; //50 - 10

          final int place = findMoneyModelByMoneyType(moneyType: moneyType).decimalPlace!;
          final double qtyXDiscountPriceNumber = double.parse(formatAndLimitNumberTextGlobal(
            isRound: true,
            isAddComma: false,
            valueStr: (stockNumber * discountPriceNumber).toString(),
            isAllowZeroAtLast: false,
            places: place,
          ));
          final double qtyXCategoryPrice = double.parse(formatAndLimitNumberTextGlobal(
            isRound: true,
            isAddComma: false,
            valueStr: (stockNumber * mainPriceConvertRateNumber).toString(),
            isAllowZeroAtLast: false,
          ));
          profit = double.parse(formatAndLimitNumberTextGlobal(
            valueStr: (profit + qtyXDiscountPriceNumber - qtyXCategoryPrice).toString(),
            isRound: false,
            isAddComma: false,
            isAllowZeroAtLast: false,
          ));
        } else {
          final bool isMainPriceQtyListNotNull = (mainPriceQtyList != null);
          if (isMainPriceQtyListNotNull) {
            final MainPriceQty mainPriceQty = MainPriceQty(qty: qtyNumberTemp, mainPrice: cardMainPriceListCardModel, rate: convertRate);
            mainPriceQtyList.add(mainPriceQty);
          }
          final int place = findMoneyModelByMoneyType(moneyType: moneyType).decimalPlace!;
          final double qtyXDiscountPriceNumber = double.parse(formatAndLimitNumberTextGlobal(
            isRound: true,
            isAddComma: false,
            valueStr: (qtyNumberTemp * discountPriceNumber).toString(),
            isAllowZeroAtLast: false,
            places: place,
          ));
          final double qtyXCategoryMainPrice = double.parse(formatAndLimitNumberTextGlobal(
            isRound: true,
            isAddComma: false,
            valueStr: (qtyNumberTemp * mainPriceConvertRateNumber).toString(),
            isAllowZeroAtLast: false,
          ));
          profit = double.parse(formatAndLimitNumberTextGlobal(
            valueStr: (profit + qtyXDiscountPriceNumber - qtyXCategoryMainPrice).toString(),
            isRound: false,
            isAddComma: false,
            isAllowZeroAtLast: false,
          ));

          break;
        }
      }
      final bool isMainPriceQtyListNotNull = (mainPriceQtyList != null);
      if (isMainPriceQtyListNotNull) {
        //mainIndex = 3 - 1 = 2
        for (int mainIndex = (mainPriceQtyList.length - 1); mainIndex >= 0; mainIndex--) {
          int outOfMatchIndex = (mainIndex - 1); //[2] outOfMatchIndex = 1
          bool isAllMatch = true;
          //[2] subMainIndex = 1
          for (int subMainIndex = outOfMatchIndex; subMainIndex >= 0; subMainIndex--) {
            //[2][1] true
            if (mainPriceQtyList[mainIndex].mainPrice.id != mainPriceQtyList[subMainIndex].mainPrice.id) {
              outOfMatchIndex = subMainIndex; //[2][1]outOfMatchIndex = 1
              isAllMatch = false;
              break;
            }
          }

          //[2] isAllMatch = false
          if (isAllMatch) {
            outOfMatchIndex = 0;
          }
          if (((mainIndex - outOfMatchIndex) > 1) && isAllMatch) {
            int trimTotalStockNumber = 0;
            //[2] trimMainIndex = 1
            //[2] max trimMainIndex = 2
            for (int trimMainIndex = outOfMatchIndex; trimMainIndex <= mainIndex; trimMainIndex++) {
              trimTotalStockNumber = trimTotalStockNumber + textEditingControllerToInt(controller: mainPriceQtyList[trimMainIndex].mainPrice.stock)!;
            }
            final int stockIndex = cardModelListGlobal[companyNameIndex]
                .categoryList[categoryIndex]
                .mainPriceList
                .indexWhere((element) => (element.id == mainPriceQtyList[mainIndex].mainPrice.id));
            final int stockNUmber =
                textEditingControllerToInt(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList[stockIndex].stock)!;
            final int trimStockNumber = textEditingControllerToInt(controller: mainPriceQtyList[mainIndex].mainPrice.stock)!;
            mainPriceQtyList[mainIndex].mainPrice.stock.text = formatAndLimitNumberTextGlobal(
              valueStr: (trimStockNumber + stockNUmber - trimTotalStockNumber).toString(),
              isRound: false,
            );
            mainIndex = outOfMatchIndex;
          }
        }
        for (int mainIndex = 0; mainIndex < mainPriceQtyList.length; mainIndex++) {
          final int outsideMainMatchIndex = cardModelListGlobal[companyNameIndex]
              .categoryList[categoryIndex]
              .mainPriceList
              .indexWhere((element) => (element.id == mainPriceQtyList[mainIndex].mainPrice.id));
          mainPriceQtyList[mainIndex].mainPrice.rateList =
              cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList[outsideMainMatchIndex].rateList;
        }

        for (int mainIndex = 0; mainIndex < mainPriceQtyList.length; mainIndex++) {
          int targetAddIndex = -1;
          int totalStockNumber = textEditingControllerToInt(controller: mainPriceQtyList[mainIndex].mainPrice.stock)!;
          for (int subMainIndex = (mainIndex + 1); subMainIndex < mainPriceQtyList.length; subMainIndex++) {
            if (mainPriceQtyList[mainIndex].mainPrice.id != mainPriceQtyList[subMainIndex].mainPrice.id) {
              targetAddIndex = (subMainIndex - 1);
              mainIndex = targetAddIndex;
              break;
            } else {
              totalStockNumber = totalStockNumber + textEditingControllerToInt(controller: mainPriceQtyList[subMainIndex].mainPrice.stock)!;
            }
          }
          if (targetAddIndex == -1) {
            targetAddIndex = mainPriceQtyList.length - 1;
            mainIndex = targetAddIndex; //break the loop
          }

          final int outsideMainMatchIndex = cardModelListGlobal[companyNameIndex]
              .categoryList[categoryIndex]
              .mainPriceList
              .indexWhere((element) => (element.id == mainPriceQtyList[targetAddIndex].mainPrice.id));
          final int fullStockNumber = textEditingControllerToInt(
            controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList[outsideMainMatchIndex].stock,
          )!;

          final int stockNumber = textEditingControllerToInt(controller: mainPriceQtyList[targetAddIndex].mainPrice.stock)!;
          mainPriceQtyList[targetAddIndex].mainPrice.stock.text = formatAndLimitNumberTextGlobal(
            valueStr: (fullStockNumber + (stockNumber - totalStockNumber)).toString(),
            isRound: false,
          );
        }
      }
      final int place = findMoneyModelByMoneyType(moneyType: moneyType).decimalPlace!;
      return double.parse(formatAndLimitNumberTextGlobal(
        isRound: true,
        isAddComma: false,
        valueStr: profit.toString(),
        isAllowZeroAtLast: false,
        places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
      ));
    } else {
      return null;
    }
  }
  return null;
}

//-----------------convert String to Model----------------
MoneyTypeAndValueModel convertStringToMoneyTypeAndValueModel({required String priceAndMoneyTypeStr}) {
  final int spaceIndex = priceAndMoneyTypeStr.indexOf(spaceStrGlobal); //spaceIndex never equal -1
  final String priceStr = priceAndMoneyTypeStr.substring(0, spaceIndex);
  final String moneyTypeStr = priceAndMoneyTypeStr.substring(spaceIndex + spaceStrGlobal.length);
  final double priceNumber = double.parse(formatAndLimitNumberTextGlobal(isRound: false, isAddComma: false, valueStr: priceStr, isAllowZeroAtLast: false));
  return MoneyTypeAndValueModel(value: priceNumber, moneyType: moneyTypeStr);
}

CompanyNameXCategoryXStockModel convertStringToCompanyNameXCategoryModel({required String companyNameXCategoryStr}) {
  final int betweenCardCompanyNameAndCategoryIndex =
      companyNameXCategoryStr.indexOf(betweenCardCompanyNameAndCategoryStrGlobal); //betweenCardCompanyNameAndCategoryIndex never equal -1
  final String companyNameStr = companyNameXCategoryStr.substring(0, betweenCardCompanyNameAndCategoryIndex);
  final String categoryStr = companyNameXCategoryStr.substring(betweenCardCompanyNameAndCategoryIndex + betweenCardCompanyNameAndCategoryStrGlobal.length);
  final double categoryNumber =
      double.parse(formatAndLimitNumberTextGlobal(isRound: false, isAddComma: false, valueStr: categoryStr, isAllowZeroAtLast: false));
  return CompanyNameXCategoryXStockModel(companyName: companyNameStr, category: categoryNumber);
}

//------------------------------add money type when it doesn't have-------------------------
String customValueAndMoneyType({required String valueStr, required String moneyTypeStr}) {
  final int spaceIndex = valueStr.indexOf(spaceStrGlobal); //spaceIndex never equal -1
  final bool isHasSpace = (spaceIndex != -1);
  if (isHasSpace) {
    return valueStr;
  } else {
    return "$valueStr$spaceStrGlobal$moneyTypeStr";
  }
}

//---------------------get only company name-----------------------------------------------
//["Cellcard", "Smart", "Metfone"]
List<String> cardCompanyNameOnlyList() {
  List<String> cardCompanyNameList = [];
  for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
    cardCompanyNameList.add(cardModelListGlobal[cardIndex].cardCompanyName.text);
  }

  return cardCompanyNameList;
}

List<String> cardCategoryOnlyList({required String? companyNameStr}) {
  List<String> cardCategoryList = [];
  final bool isCompanyNameNotNull = (companyNameStr != null);
  if (isCompanyNameNotNull) {
    final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //can be -1
    final bool isMatchCompany = (companyNameIndex != -1);
    if (isMatchCompany) {
      for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[companyNameIndex].categoryList.length; categoryIndex++) {
        cardCategoryList.add(cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].category.text);
      }
    }
  }
  return cardCategoryList;
}

ValidButtonModel checkLowerTheExistCard({required String companyNameStr, required double categoryNumber, required int qtyNumber}) {
  //100
  for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
    final String companyNameInsideStr = cardModelListGlobal[cardIndex].cardCompanyName.text;
    final bool isMatchCompanyName = (companyNameInsideStr == companyNameStr);
    if (isMatchCompanyName) {
      for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++) {
        final TextEditingController categoryController = cardModelListGlobal[cardIndex].categoryList[categoryIndex].category;
        final double categoryInsideNumber = textEditingControllerToDouble(controller: categoryController)!;
        final bool isMatchCategory = (categoryInsideNumber == categoryNumber);
        if (isMatchCategory) {
          int totalStockNumber = 0; //105
          for (int mainIndex = 0; mainIndex < cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList.length; mainIndex++) {
            totalStockNumber = totalStockNumber +
                textEditingControllerToInt(controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList[mainIndex].stock)!;
          }
          // return !(totalStockNumber < qtyNumber); //105 < 100
          return ValidButtonModel(
            isValid: !(totalStockNumber < qtyNumber),
            error: "Stock is not enough",
            errorLocationList: [
              TitleAndSubtitleModel(title: "card name", subtitle: companyNameStr),
              TitleAndSubtitleModel(title: "category", subtitle: formatAndLimitNumberTextGlobal(valueStr: categoryNumber.toString(), isRound: false)),
              TitleAndSubtitleModel(title: "card stock", subtitle: formatAndLimitNumberTextGlobal(valueStr: qtyNumber.toString(), isRound: false)),
              TitleAndSubtitleModel(title: "card order", subtitle: formatAndLimitNumberTextGlobal(valueStr: qtyNumber.toString(), isRound: false)),
            ],
            detailList: [
              TitleAndSubtitleModel(
                title:
                    "${formatAndLimitNumberTextGlobal(valueStr: qtyNumber.toString(), isRound: false)} <= ${formatAndLimitNumberTextGlobal(valueStr: totalStockNumber.toString(), isRound: false)}",
                subtitle: "invalid compare",
              ),
            ],
          );
        }
      }
    }
  }
  // return true;
  return ValidButtonModel(isValid: true);
}

List<String> getMoneyTypeCardIndex({required String companyNameStr, required double categoryNumber}) {
  final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
  final int categoryIndex = cardModelListGlobal[companyNameIndex]
      .categoryList
      .indexWhere((element) => (textEditingControllerToDouble(controller: element.category) == categoryNumber)); //never equal -1
  List<String> moneyTypeList = [];
  for (int moneyIndex = 0; moneyIndex < cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].limitList.length; moneyIndex++) {
    moneyTypeList.add(cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].limitList[moneyIndex].moneyType!);
  }
  return moneyTypeList;
}

//--------------------card widget-------------------------
Widget cardStockWidget({
  required CardMainPriceListCardModel mainPriceModel,
  required String companyStr,
  required String categoryStr,
  required String companyIdStr,
  required String categoryIdStr,
}) {
  // Widget textWidget({required String titleStr, required String subtitleStr}) {
  //   return scrollText(textStr: "$titleStr: $subtitleStr", textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.centerLeft);
  // }
  // final String companyStr = widget.informationAndCardMainStockModel!.cardCompanyName;
  // final String categoryStr = formatAndLimitNumberTextGlobal(valueStr: widget.informationAndCardMainStockModel!.category.toString(), isRound: false);
  // final String qtyStr = mainPriceModel.stock.text;
  // final int qtyNumber = textEditingControllerToInt(controller: mainPriceModel.stock)!;
  final String priceStr = mainPriceModel.price.text;
  final double priceNumber = textEditingControllerToDouble(controller: mainPriceModel.price)!;
  final String moneyType = mainPriceModel.moneyType!;

  final String maxStockStr = formatAndLimitNumberTextGlobal(valueStr: mainPriceModel.maxStock.toString(), isRound: false);

  final int place = findMoneyModelByMoneyType(moneyType: moneyType).decimalPlace!;
  final String amountStr = formatAndLimitNumberTextGlobal(
    valueStr: (mainPriceModel.maxStock * priceNumber).toString(),
    isRound: false,
    places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  );

  Widget rateElementWidget({required int rateIndex}) {
    final String percentageStr = mainPriceModel.rateList[rateIndex].percentage.text;
    final double valueNumber = mainPriceModel.rateList[rateIndex].value!;
    final String rateValueStr = formatAndLimitNumberTextGlobal(valueStr: valueNumber.toString(), isRound: false);
    final double rateDiscountNumber = textEditingControllerToDouble(controller: mainPriceModel.rateList[rateIndex].discountValue)!;
    final String rateDiscountStr = mainPriceModel.rateList[rateIndex].discountValue.text;
    final List<String> rateType = mainPriceModel.rateList[rateIndex].rateType;
    final bool isBuyRate = mainPriceModel.rateList[rateIndex].isBuyRate!;
    final String rateStr = isBuyRate ? "${rateType.first} -> ${rateType.last}" : "${rateType.last} -> ${rateType.first}";
    return Padding(
      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          Text("   $percentageStr % | $rateStr: ", style: textStyleGlobal(level: Level.normal)),
          (rateDiscountNumber == valueNumber)
              ? Text(rateDiscountStr, style: textStyleGlobal(level: Level.normal))
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(rateValueStr, style: TextStyle(fontSize: textSizeGlobal(level: Level.mini), decoration: TextDecoration.lineThrough)),
                  Text(rateDiscountStr, style: textStyleGlobal(level: Level.mini)),
                ]),
        ]),
      ),
    );
  }

  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        Text(
          "$companyStr x $categoryStr ($companyIdStr x $categoryIdStr)",
          style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
        ),
      ]),
    ),
    scrollText(
      textStr: "   Insert Date: ${formatFullDateToStr(date: mainPriceModel.date!)}",
      textStyle: textStyleGlobal(level: Level.normal),
      alignment: Alignment.centerLeft,
    ),
    scrollText(
      textStr: "   Available Stock: ${mainPriceModel.stock.text}/$maxStockStr",
      textStyle: textStyleGlobal(level: Level.normal),
      alignment: Alignment.centerLeft,
    ),
    Padding(
      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          Text("   $maxStockStr card", style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal)),
          Text(" $multiplyNumberStrGlobal $priceStr $equalStrGlobal ", style: textStyleGlobal(level: Level.normal)),
          Text("$amountStr $moneyType", style: textStyleGlobal(level: Level.normal, color: negativeColorGlobal)),
        ]),
      ),
    ),
    mainPriceModel.rateList.isEmpty ? Container() : Text("Rate Initiate", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
    for (int rateIndex = 0; rateIndex < mainPriceModel.rateList.length; rateIndex++) rateElementWidget(rateIndex: rateIndex),
  ]);
}

String sellPriceModelToStr({required CardSellPriceListCardModel cardSellPriceListCardModel}) {
  // final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.id == subCardCombineModel.cardCompanyId));
  // final int categoryIndex =
  //     cardModelListGlobal[companyNameIndex].categoryList.indexWhere((element) => (element.id == subCardCombineModel.categoryId));
  // final int sellPriceIndex = cardModelListGlobal[cardCombineIndex]
  //     .categoryList[categoryIndex]
  //     .sellPriceList
  //     .indexWhere((element) => (element.id == subCardCombineModel.sellPriceId));

  // final CardSellPriceListCardModel cardSellPriceListCardModel =
  //     cardModelListGlobal[cardCombineIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex];
  final String miniStr = cardSellPriceListCardModel.startValue.text;
  final String maxiStr = cardSellPriceListCardModel.endValue.text;
  final String priceStr = cardSellPriceListCardModel.price.text;
  final String moneyTypeStr = cardSellPriceListCardModel.moneyType!;
  return "$miniStr <= x <= $maxiStr | $priceStr $moneyTypeStr";
}
