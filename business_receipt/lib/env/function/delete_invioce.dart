
// ExchangeMoneyModel reverseExchange({required ExchangeMoneyModel exchangeMoneyModel}) {
//   print("exchangeMoneyModel => ${exchangeMoneyModel.toJson()}");
//   final String reverseId = exchangeMoneyModel.id!;
//   final DateTime reverseDate = exchangeMoneyModel.date!;
//   List<ExchangeListExchangeMoneyModel> reverseExchangeList = [];
//   for (int exchangeIndex = 0; exchangeIndex < exchangeMoneyModel.exchangeList.length; exchangeIndex++) {
//     TextEditingController reverseGetMoney = TextEditingController(text: (-1 * textEditingControllerToDouble(controller: exchangeMoneyModel.exchangeList[exchangeIndex].getMoney)!).toString());
//     TextEditingController reverseGiveMoney = TextEditingController(text: (-1 * textEditingControllerToDouble(controller: exchangeMoneyModel.exchangeList[exchangeIndex].giveMoney)!).toString());
//     RateForCalculateModel reverseRate = RateForCalculateModel(
//       discountValue: TextEditingController(text: exchangeMoneyModel.exchangeList[exchangeIndex].rate!.discountValue.text),
//       rateType: exchangeMoneyModel.exchangeList[exchangeIndex].rate!.rateType,
//       isBuyRate: exchangeMoneyModel.exchangeList[exchangeIndex].rate!.isBuyRate!,
//       isSelectedOtherRate: exchangeMoneyModel.exchangeList[exchangeIndex].rate!.isSelectedOtherRate,
//       profit: -1 * exchangeMoneyModel.exchangeList[exchangeIndex].rate!.profit!,
//       rateId: exchangeMoneyModel.exchangeList[exchangeIndex].rate!.rateId,
//       value: exchangeMoneyModel.exchangeList[exchangeIndex].rate!.value,
//       usedModelList: exchangeMoneyModel.exchangeList[exchangeIndex].rate!.usedModelList,
//     );

//     //  exchangeMoneyModel.exchangeList[exchangeIndex].rate!;

//     reverseExchangeList.add(ExchangeListExchangeMoneyModel(getMoney: reverseGetMoney, giveMoney: reverseGiveMoney, rate: reverseRate, getMoneyFocusNode: FocusNode(), giveMoneyFocusNode: FocusNode()));
//   }
//   return ExchangeMoneyModel(id: reverseId, date: reverseDate,isDelete: true, overwriteOnId: reverseId, exchangeList: reverseExchangeList);
// }

// SellCardModel reverseSellCard({required SellCardModel sellCardModel}) {
//   final String reverseId = sellCardModel.id!;
//   CalculateSellCardModel reverseCustomerMoneyListFunction({required CalculateSellCardModel mergeCalculate}) {
//     // CalculateSellCardModel reverseMergeCalculate;
//     // mergeCalculate.totalMoney = -1 * sellCardModel.mergeCalculate!.totalMoney;
//     // mergeCalculate.moneyType = sellCardModel.mergeCalculate!.moneyType;
//     // mergeCalculate.totalProfit = -1 * sellCardModel.mergeCalculate!.totalProfit!;
//     // mergeCalculate.convertMoney = -1 * sellCardModel.mergeCalculate!.convertMoney!;

//     List<CustomerMoneyListSellCardModel> reverseCustomerMoneyList = [];
//     for (int customerMoneyIndex = 0; customerMoneyIndex < mergeCalculate.customerMoneyList.length; customerMoneyIndex++) {
//       reverseCustomerMoneyList.add(CustomerMoneyListSellCardModel(
//         moneyType: mergeCalculate.customerMoneyList[customerMoneyIndex].moneyType,
//         getMoney: (-1 * double.parse(mergeCalculate.customerMoneyList[customerMoneyIndex].getMoney!)).toString(),
//         giveMoney: (-1 * mergeCalculate.customerMoneyList[customerMoneyIndex].giveMoney!),
//         rate: mergeCalculate.customerMoneyList[customerMoneyIndex].rate,
//       ));
//     }
//     return CalculateSellCardModel(
//       totalMoney: (-1 * mergeCalculate.totalMoney),
//       moneyType: mergeCalculate.moneyType,
//       convertMoney: (mergeCalculate.convertMoney == null) ? null : (-1 * mergeCalculate.convertMoney!),
//       totalProfit: (-1 * mergeCalculate.totalProfit!),
//       customerMoneyList: reverseCustomerMoneyList,
//     );
//   }

//   CalculateSellCardModel? reverseMergeCalculate;
//   final bool isMerge = (sellCardModel.mergeCalculate != null);
//   if (isMerge) {
//     reverseMergeCalculate = reverseCustomerMoneyListFunction(mergeCalculate: sellCardModel.mergeCalculate!);
//   }
//   List<MoneyTypeListSellCardModel> reverseMoneyTypeList = [];
//   for (int moneyTypeIndex = 0; moneyTypeIndex < sellCardModel.moneyTypeList.length; moneyTypeIndex++) {
//     // final String reverseMoneyType = sellCardModel.moneyTypeList[moneyTypeIndex].calculate.moneyType;
//     // final double reverseTotalMoney = (-1 * sellCardModel.moneyTypeList[moneyTypeIndex].calculate.totalMoney);
//     // final List<CustomerMoneyListSellCardModel> reverseCustomerMoneyList = reverseCustomerMoneyListFunction(customerMoneyList: sellCardModel.moneyTypeList[moneyTypeIndex].calculate.customerMoneyList);
//     final CalculateSellCardModel reverseCalculate = reverseCustomerMoneyListFunction(mergeCalculate: sellCardModel.moneyTypeList[moneyTypeIndex].calculate);

//     final List<CardListSellCardModel> reverseCardList = [];
//     for (int cardIndex = 0; cardIndex < sellCardModel.moneyTypeList[moneyTypeIndex].cardList.length; cardIndex++) {
//       final List<MainPriceQty> reverseMainPriceQtyList = [];
//       for (int mainPriceIndex = 0; mainPriceIndex < sellCardModel.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList.length; mainPriceIndex++) {
//         reverseMainPriceQtyList.add(MainPriceQty(
//           qty: (-1 * sellCardModel.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList[mainPriceIndex].qty),
//           mainPrice: sellCardModel.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList[mainPriceIndex].mainPrice,
//           rate: sellCardModel.moneyTypeList[moneyTypeIndex].cardList[cardIndex].mainPriceQtyList[mainPriceIndex].rate,
//         ));
//       }
//       reverseCardList.add(CardListSellCardModel(
//         qty: (-1 * sellCardModel.moneyTypeList[moneyTypeIndex].cardList[cardIndex].qty),
//         cardCompanyNameId: sellCardModel.moneyTypeList[moneyTypeIndex].cardList[cardIndex].cardCompanyNameId,
//         cardCompanyName: sellCardModel.moneyTypeList[moneyTypeIndex].cardList[cardIndex].cardCompanyName,
//         language: sellCardModel.moneyTypeList[moneyTypeIndex].cardList[cardIndex].language,
//         categoryId: sellCardModel.moneyTypeList[moneyTypeIndex].cardList[cardIndex].categoryId,
//         category: sellCardModel.moneyTypeList[moneyTypeIndex].cardList[cardIndex].category,
//         profit: (-1 * sellCardModel.moneyTypeList[moneyTypeIndex].cardList[cardIndex].profit),
//         sellPrice: sellCardModel.moneyTypeList[moneyTypeIndex].cardList[cardIndex].sellPrice,
//         mainPriceQtyList: reverseMainPriceQtyList,
//       ));
//     }

//     reverseMoneyTypeList.add(MoneyTypeListSellCardModel(calculate: reverseCalculate, cardList: reverseCardList));
//   }
//   return SellCardModel(isDelete: true, overwriteOnId: reverseId, moneyTypeList: reverseMoneyTypeList, mergeCalculate: reverseMergeCalculate);
// }
