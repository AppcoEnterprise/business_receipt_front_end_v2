import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/employee_model/card/card_other_model.dart';
import 'package:flutter/material.dart';

DateTime? getDeleteDateTimeRate({required int rateModelIndex}) {
  final List<String> rateType = rateModelListAdminGlobal[rateModelIndex].rateType;
  final DateTime? deletedDateFirst = findMoneyModelByMoneyType(moneyType: rateType.first).deletedDate;
  final DateTime? deletedDateLast = findMoneyModelByMoneyType(moneyType: rateType.last).deletedDate;
  final bool isDeletedRate = ((deletedDateFirst != null) || (deletedDateLast != null));
  DateTime? deletedDateOrNull;
  if (isDeletedRate) {
    if ((deletedDateFirst == null) && (deletedDateLast != null)) {
      deletedDateOrNull = deletedDateLast;
    } else if ((deletedDateFirst != null) && (deletedDateLast == null)) {
      deletedDateOrNull = deletedDateFirst;
    } else if ((deletedDateFirst != null) && (deletedDateLast != null)) {
      if (deletedDateFirst.isBefore(deletedDateLast)) {
        deletedDateOrNull = deletedDateFirst;
      } else {
        deletedDateOrNull = deletedDateLast;
      }
    }
  }
  return deletedDateOrNull;
}

//["USD -> KHR", "KHR -> USD", "USD -> THB", "THB -> USD"]
List<String> rateOnlyList({required bool isShowNone, required bool isShowAllRate, required String? rateTypeDefault}) {
  List<String> rateList = [];
  if (isShowNone) {
    rateList.add(noneStrGlobal);
  }
  for (int rateIndex = 0; rateIndex < rateModelListAdminGlobal.length; rateIndex++) {
    if (rateModelListAdminGlobal[rateIndex].display) {
      if (isShowAllRate) {
        List<String> rateType = rateModelListAdminGlobal[rateIndex].rateType;
        final String rateFirstStr = rateType.first;
        final String rateLastStr = rateType.last;
        final String selectedStr = "$rateFirstStr$minusStrGlobal$rateLastStr";
        rateList.add(selectedStr);
      } else {
        if (rateModelListAdminGlobal[rateIndex].display) {
          DateTime? deleteDateTimeRate = getDeleteDateTimeRate(rateModelIndex: rateIndex);
          if (deleteDateTimeRate == null) {
            bool isShowRate = false;
            final bool isBuyModelNotNull = (rateModelListAdminGlobal[rateIndex].buy != null);
            final bool isSellModelNotNull = (rateModelListAdminGlobal[rateIndex].sell != null);
            if (isBuyModelNotNull && isSellModelNotNull) {
              final TextEditingController buyController = rateModelListAdminGlobal[rateIndex].buy!.value;
              final TextEditingController sellController = rateModelListAdminGlobal[rateIndex].sell!.value;
              final bool isBuySellModelNotEmpty = ((buyController.text.isNotEmpty) && (sellController.text.isNotEmpty));
              if (isBuySellModelNotEmpty) {
                final bool isBuyNotEqual0 = (textEditingControllerToDouble(controller: buyController) != 0);
                final bool isSellNotEqual0 = (textEditingControllerToDouble(controller: sellController) != 0);
                if (isBuyNotEqual0 && isSellNotEqual0) {
                  isShowRate = true;
                }
              }
            }
            if (isShowRate) {
              List<String> rateType = rateModelListAdminGlobal[rateIndex].rateType;
              final String rateFirstStr = rateType.first;
              final String rateLastStr = rateType.last;
              final String selectedStr = "$rateFirstStr$arrowStrGlobal$rateLastStr";
              final String selectedReverseStr = "$rateLastStr$arrowStrGlobal$rateFirstStr";
              rateList.add(selectedStr);
              rateList.add(selectedReverseStr);
            }
          }
        }
      }
    }
  }
  if (rateTypeDefault != null) {
    if (rateTypeDefault.isNotEmpty) {
      final int moneyTypeIndex = rateList.indexWhere((element) => (element == rateTypeDefault)); //never equal -1
      if (moneyTypeIndex == -1) {
        rateList.add(rateTypeDefault);
      }
    }
  }
  return rateList;
}

List<String> convertRateStrToRateTypeStrList({required String rateStr}) {
  final int betweenRateFirstAndLastIndex = rateStr.indexOf(arrowStrGlobal); //betweenRateFirstAndLastIndex never equal -1
  final String rateFirstStr = rateStr.substring(0, betweenRateFirstAndLastIndex);
  final String rateLastStr = rateStr.substring(betweenRateFirstAndLastIndex + arrowStrGlobal.length);
  return [rateFirstStr, rateLastStr];
}

//rateStr = "USD->KHR"
RateForCalculateModel getRateForCalculateModelByRateStr({required String rateStr}) {
  final List<String> rateTypeList = convertRateStrToRateTypeStrList(rateStr: rateStr);
  final int rateIndex = rateModelListAdminGlobal.indexWhere((element) {
    final bool isMatchMoneyTypeAndMainMoneyType = (element.rateType.first == rateTypeList.first) && (element.rateType.last == rateTypeList.last);
    final bool isMatchMoneyTypeAndMainMoneyTypeReverse = (element.rateType.first == rateTypeList.last) && (element.rateType.last == rateTypeList.first);
    return (isMatchMoneyTypeAndMainMoneyType || isMatchMoneyTypeAndMainMoneyTypeReverse);
  }); //rateIndex never equal -1

  final bool isBuyRate = rateModelListAdminGlobal[rateIndex].rateType.first == rateTypeList.first;
  final List<String> rateType = [rateModelListAdminGlobal[rateIndex].rateType.first, rateModelListAdminGlobal[rateIndex].rateType.last];
  if (isBuyRate) {
    final TextEditingController valueController = TextEditingController(text: rateModelListAdminGlobal[rateIndex].buy!.value.text);
    final double value = textEditingControllerToDouble(controller: valueController)!;
    final String rateId = rateModelListAdminGlobal[rateIndex].buy!.id!;
    return RateForCalculateModel(
      rateId: rateId,
      rateType: rateType,
      isBuyRate: isBuyRate,
      value: value,
      discountValue: valueController,
      usedModelList: [],
      percentage: TextEditingController(),
    );
  } else {
    final TextEditingController valueController = TextEditingController(text: rateModelListAdminGlobal[rateIndex].sell!.value.text);
    final double value = textEditingControllerToDouble(controller: valueController)!;
    final String rateId = rateModelListAdminGlobal[rateIndex].sell!.id!;
    return RateForCalculateModel(
      rateId: rateId,
      rateType: rateType,
      isBuyRate: isBuyRate,
      value: value,
      discountValue: valueController,
      usedModelList: [],
      percentage: TextEditingController(),
    );
  }
}

RateModel? getRateModel({required String rateTypeFirst, required String rateTypeLast}) {
  final int rateIndex = rateModelListAdminGlobal.indexWhere((element) {
    final String rateTypeFirstInside = element.rateType.first;
    final String rateTypeLastInside = element.rateType.last;
    final bool isRateMatch = ((rateTypeFirst == rateTypeFirstInside) && (rateTypeLast == rateTypeLastInside));
    final bool isRateMatchReverse = ((rateTypeFirst == rateTypeLastInside) && (rateTypeLast == rateTypeFirstInside));
    return (isRateMatch || isRateMatchReverse);
  });

  final bool isNotMatch = (rateIndex == -1);
  return isNotMatch ? null : rateModelListAdminGlobal[rateIndex];
}

RateForCalculateModel? getRateForCalculateModelByRateModel({required String rateTypeFirst, required String rateTypeLast}) {
  final RateModel? rateModelOrNull = getRateModel(rateTypeFirst: rateTypeFirst, rateTypeLast: rateTypeLast);
  final bool isRateModelNull = (rateModelOrNull == null);
  if (isRateModelNull) {
    return null;
  } else {
    final List<String> rateType = rateModelOrNull.rateType;
    final bool isBuyRate = (rateType.first == rateTypeFirst);
    final BuyOrSellRateModel buyOrSellRateModel = isBuyRate ? rateModelOrNull.buy! : rateModelOrNull.sell!;
    final String rateId = buyOrSellRateModel.id!;
    final double value = textEditingControllerToDouble(controller: buyOrSellRateModel.value)!;
    final TextEditingController discountValue =
        TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: value.toString(), isRound: false, isAllowZeroAtLast: true));
    return RateForCalculateModel(
      rateType: rateType,
      isBuyRate: isBuyRate,
      rateId: rateId,
      value: value,
      discountValue: discountValue,
      usedModelList: [],
      percentage: TextEditingController(),
    );
  }
}

BuyAndSellDiscountRate? getDiscountRateModel({
  required String rateTypeFirst,
  required String rateTypeLast,
  required List<BuyAndSellDiscountRate> buyAndSellDiscountRateList,
}) {
  final int rateIndex = buyAndSellDiscountRateList.indexWhere((element) {
    final String rateTypeFirstInside = element.rateType.first;
    final String rateTypeLastInside = element.rateType.last;
    final bool isRateMatch = ((rateTypeFirst == rateTypeFirstInside) && (rateTypeLast == rateTypeLastInside));
    final bool isRateMatchReverse = ((rateTypeFirst == rateTypeLastInside) && (rateTypeLast == rateTypeFirstInside));
    return (isRateMatch || isRateMatchReverse);
  });

  final bool isNotMatch = (rateIndex == -1);
  return isNotMatch ? null : buyAndSellDiscountRateList[rateIndex];
}

RateForCalculateModel? getDiscountRateForCalculateModel(
    {required String rateTypeFirst, required String rateTypeLast, required List<BuyAndSellDiscountRate> buyAndSellDiscountRateList}) {
  final BuyAndSellDiscountRate? rateModelOrNull =
      getDiscountRateModel(rateTypeFirst: rateTypeFirst, rateTypeLast: rateTypeLast, buyAndSellDiscountRateList: buyAndSellDiscountRateList);
  final bool isRateModelNull = (rateModelOrNull == null);
  if (isRateModelNull) {
    return null;
  } else {
    final List<String> rateType = rateModelOrNull.rateType;
    final bool isBuyRate = (rateType.first == rateTypeFirst);
    final RateForCalculateModel buyOrSellRateModel = isBuyRate ? rateModelOrNull.buy : rateModelOrNull.sell;
    return cloneRateForCalculate(rateForCalculate: buyOrSellRateModel);
  }
}
