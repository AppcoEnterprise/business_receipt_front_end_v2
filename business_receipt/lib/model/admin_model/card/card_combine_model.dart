// To parse this JSON data, do
//
//     final cardCombineModel = cardCombineModelFromJson(jsonString);

import 'package:business_receipt/env/function/card.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

List<CardCombineModel> cardCombineModelFromJson({required dynamic str}) =>
    List<CardCombineModel>.from(json.decode(json.encode(str)).map((x) => CardCombineModel.fromJson(x)));

List<dynamic> cardCombineModelToJson(List<CardCombineModel> data) => List<dynamic>.from(data.map((x) => x.toJson()));

class CardCombineModel {
  TextEditingController combineName;
  bool isSelectedPrint;
  List<SubCardCombineModel> cardList;

  CardCombineModel({
    required this.combineName,
     this.isSelectedPrint = false,
    required this.cardList,
  });

  factory CardCombineModel.fromJson(Map<String, dynamic> json) => CardCombineModel(
        // combineName: json["combine_name"],
        combineName: TextEditingController(text: json["combine_name"]),
        cardList: List<SubCardCombineModel>.from(json["card_list"].map((x) => SubCardCombineModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "combine_name": combineName.text,
        "card_list": List<dynamic>.from(cardList.map((x) => x.toJson())),
      };
}

class SubCardCombineModel {
  String? cardCompanyId;
  String? categoryId;
  String? cardCompanyName;
  double? category;
  String? sellPriceId;
  String? sellPrice;
  CardSellPriceListCardModel? cardSellPriceListCardModel;

  SubCardCombineModel({
    this.cardCompanyId,
    this.categoryId,
    this.cardCompanyName,
    this.category,
    this.sellPriceId,
    this.sellPrice,
    this.cardSellPriceListCardModel,
  });

  factory SubCardCombineModel.fromJson(Map<String, dynamic> json) {
    final String cardCompanyId = json["card_company_id"];
    final String categoryId = json["category_id"];
    final String sellPriceId = json["sell_price_id"];

    final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.id == cardCompanyId));

    final int categoryIndex = cardModelListGlobal[companyNameIndex].categoryList.indexWhere((element) => (element.id == categoryId));

    final int sellPriceIndex =
        cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList.indexWhere((element) => (element.id == sellPriceId));

    return SubCardCombineModel(
      cardCompanyId: cardCompanyId,
      categoryId: categoryId,
      sellPriceId: sellPriceId,
      cardCompanyName: cardModelListGlobal[companyNameIndex].cardCompanyName.text,
      category: textEditingControllerToDouble(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].category),
      sellPrice: sellPriceModelToStr(
        cardSellPriceListCardModel: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex],
      ),
      cardSellPriceListCardModel: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex],
    );
  }

  Map<String, dynamic> toJson() => {
        "card_company_id": cardCompanyId,
        "category_id": categoryId,
        "sell_price_id": sellPriceId,
      };
}

List<CardCombineModel> cardCombineClone() {
  List<CardCombineModel> cardCombineList = [];
  for (int cardCombineIndex = 0; cardCombineIndex < cardCombineModelListGlobal.length; cardCombineIndex++) {
    CardCombineModel cardCombineModel = cardCombineModelListGlobal[cardCombineIndex];
    List<SubCardCombineModel> subCardCombineList = [];
    for (int subCardCombineIndex = 0; subCardCombineIndex < cardCombineModel.cardList.length; subCardCombineIndex++) {
      SubCardCombineModel subCardCombineModel = cardCombineModel.cardList[subCardCombineIndex];

      // final int companyNameIndex =
      //     cardModelListGlobal.indexWhere((element) => (element.id == cardCombineModel.cardList[subCardCombineIndex].cardCompanyId)); //never equal -1

      // final int categoryIndex =
      //     cardModelListGlobal[companyNameIndex].categoryList.indexWhere((element) => (element.id == cardCombineModel.cardList[subCardCombineIndex].categoryId));

      // final int sellPriceIndex = cardModelListGlobal[companyNameIndex]
      //     .categoryList[categoryIndex]
      //     .sellPriceList
      //     .indexWhere((element) => (element.id == cardCombineModel.cardList[subCardCombineIndex].sellPriceId)); //never equal -1

      subCardCombineList.add(SubCardCombineModel(
        cardCompanyId: subCardCombineModel.cardCompanyId,
        categoryId: subCardCombineModel.categoryId,
        sellPriceId: subCardCombineModel.sellPriceId,
        cardCompanyName: subCardCombineModel.cardCompanyName,
        category: subCardCombineModel.category,
        sellPrice: subCardCombineModel.sellPrice,
        cardSellPriceListCardModel: subCardCombineModel.cardSellPriceListCardModel,
      ));
    }
    cardCombineList.add(CardCombineModel(
      combineName: TextEditingController(text: cardCombineModel.combineName.text),
      cardList: subCardCombineList,
    ));
  }
  return cardCombineList;
}
