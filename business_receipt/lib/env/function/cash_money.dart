import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/rate.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/cash_model.dart';

double totalEstimateStr({required CashModel cashModel, required List<AmountAndProfitModel> amountAndProfitModel}) {
  double totalEstimateNumber = 0;
  for (int currencyIndex = 0; currencyIndex < amountAndProfitModel.length; currencyIndex++) {
    if (cashModel.mergeBy == amountAndProfitModel[currencyIndex].moneyType) {
      totalEstimateNumber += amountAndProfitModel[currencyIndex].amount;
    } else {
      final int selectMoneyType = findMoneyTypeIndexByMoneyType(moneyType: amountAndProfitModel[currencyIndex].moneyType, cashModel: cashModel);
      if (selectMoneyType == -1) {
        RateModel? rateModel = getRateModel(rateTypeFirst: amountAndProfitModel[currencyIndex].moneyType, rateTypeLast: cashModel.mergeBy!);
        // print(rateModel != null);
        if (rateModel != null) {
          // print(rateModel.toJson());
          if (rateModel.buy != null && rateModel.sell != null) {
            double averageRateNumber = (textEditingControllerToDouble(controller: rateModel.buy!.value)! + textEditingControllerToDouble(controller: rateModel.sell!.value)!) / 2;
            final bool isMulti = amountAndProfitModel[currencyIndex].moneyType == rateModel.rateType.first;
            if (isMulti) {
              totalEstimateNumber += (amountAndProfitModel[currencyIndex].amount * averageRateNumber);
            } else {
              totalEstimateNumber += (amountAndProfitModel[currencyIndex].amount / averageRateNumber);
            }
          } else {
            return 0;
          }
        } else {
          return 0;
        }
      } else {
        final double? averageRateNumber = textEditingControllerToDouble(controller: cashModel.cashList[selectMoneyType].averageRate);
        if (averageRateNumber != null) {
          if (cashModel.cashList[selectMoneyType].isBuyRate) {
            totalEstimateNumber += (amountAndProfitModel[currencyIndex].amount * averageRateNumber);
          } else {
            totalEstimateNumber += (amountAndProfitModel[currencyIndex].amount / averageRateNumber);
          }
        } else {
          return 0;
        }
      }
    }
  }
  return totalEstimateNumber;
  // final int place = findMoneyModelByMoneyType(moneyType: cashModelGlobal.mergeBy!).decimalPlace!;
  // return formatAndLimitNumberTextGlobal(
  //   valueStr: totalEstimateNumber.toString(),
  //   isRound: false,
  //   isAllowZeroAtLast: false,
  //   places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  // );
}

double totalEstimateCashMoneyStr({required CashModel cashModel}) {
  double totalEstimateNumber = 0;
  // print(cashModel.toJson());
  for (int cashIndex = 0; cashIndex < cashModel.cashList.length; cashIndex++) {
    double totalElementNumber = 0;
    for (int moneyIndex = 0; moneyIndex < cashModel.cashList[cashIndex].moneyList.length; moneyIndex++) {
      totalElementNumber += textEditingControllerToDouble(controller: cashModel.cashList[cashIndex].moneyList[moneyIndex]) ?? 0;
    }
    if (cashModel.mergeBy == cashModel.cashList[cashIndex].moneyType) {
      totalEstimateNumber += totalElementNumber;
    } else {
      RateModel? rateModel = getRateModel(rateTypeFirst: cashModel.cashList[cashIndex].moneyType, rateTypeLast: cashModel.mergeBy!);
      // print(rateModel != null);
      if (rateModel != null) {
        if (rateModel.buy != null && rateModel.sell != null) {
          final double? averageRateNumber = textEditingControllerToDouble(controller: cashModel.cashList[cashIndex].averageRate);
          if (averageRateNumber != null) {
            // double averageRateNumber = (textEditingControllerToDouble(controller: rateModel.buy!.value)! + textEditingControllerToDouble(controller: rateModel.sell!.value)!) / 2;
            // print("totalEstimateCashMoneyStr => $averageRateNumber");
            final bool isMulti = cashModel.cashList[cashIndex].moneyType == rateModel.rateType.first;
            if (isMulti) {
              totalEstimateNumber += (totalElementNumber * averageRateNumber);
            } else {
              totalEstimateNumber += (totalElementNumber / averageRateNumber);
            }
          } else {
            return 0;
          }
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    }
  }
  return totalEstimateNumber;
}

String totalEstimateNumberToStr({required double totalNumber, required CashModel cashModel}) {
  final int place = findMoneyModelByMoneyType(moneyType: cashModel.mergeBy!).decimalPlace!;
  return formatAndLimitNumberTextGlobal(
    valueStr: totalNumber.toString(),
    isRound: false,
    isAllowZeroAtLast: false,
    places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  );
}

int findMoneyTypeIndexByMoneyType({required String? moneyType, required CashModel cashModel}) {
  return (moneyType == null) ? -1 : cashModel.cashList.indexWhere((element) => (element.moneyType == moneyType));
}
