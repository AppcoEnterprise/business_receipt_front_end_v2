import 'package:business_receipt/env/function/rate.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/text_limit.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/currency_model.dart';
import 'package:business_receipt/model/employee_model/card/card_other_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';

//["USD", "KHR", "THB"]
List<String> moneyTypeOnlyList({required String? moneyTypeDefault, bool isHasNone = false, required bool isNotCheckDeleted}) {
  List<String> moneyTypeList = isHasNone ? [noneStrGlobal] : [];
  for (int currencyIndex = 0; currencyIndex < currencyModelListAdminGlobal.length; currencyIndex++) {
    if ((currencyModelListAdminGlobal[currencyIndex].deletedDate == null) || isNotCheckDeleted) {
      moneyTypeList.add(currencyModelListAdminGlobal[currencyIndex].moneyType);
    }
  }
  if (moneyTypeDefault != null) {
    if (moneyTypeDefault.isNotEmpty) {
      final int moneyTypeIndex = moneyTypeList.indexWhere((element) => (element == moneyTypeDefault)); //never equal -1
      if (moneyTypeIndex == -1) {
        moneyTypeList.add(moneyTypeDefault);
      }
    }
  }
  return moneyTypeList;
}

//["USD", "KHR", "THB"]
List<String> moneyTypeOfDiscountCardOnlyList({
  required List<String> moneyTypeList,
  required List<BuyAndSellDiscountRate> buyAndSellDiscountRateList,
  required bool isNotCheckDeleted,
}) {
  List<String> moneyTypeResultList = [];
  for (int currencyIndex = 0; currencyIndex < currencyModelListAdminGlobal.length; currencyIndex++) {
    if ((currencyModelListAdminGlobal[currencyIndex].deletedDate == null) || isNotCheckDeleted) {
      final String moneyTypeInside = currencyModelListAdminGlobal[currencyIndex].moneyType;
      bool isRateNotEmpty = true;
      for (int moneyTypeIndex = 0; moneyTypeIndex < moneyTypeList.length; moneyTypeIndex++) {
        if (moneyTypeList[moneyTypeIndex] != moneyTypeInside) {
          final BuyAndSellDiscountRate rateModel = getDiscountRateModel(
            rateTypeFirst: moneyTypeList[moneyTypeIndex],
            rateTypeLast: moneyTypeInside,
            buyAndSellDiscountRateList: buyAndSellDiscountRateList,
          )!;
          final bool isBuyRate = rateModel.rateType.first == moneyTypeList[moneyTypeIndex];
          final bool isRateBuyOrSellEmpty;
          if (isBuyRate) {
            isRateBuyOrSellEmpty = rateModel.sell.discountValue.text.isEmpty;
          } else {
            isRateBuyOrSellEmpty = rateModel.buy.discountValue.text.isEmpty;
          }
          if (isRateBuyOrSellEmpty) {
            isRateNotEmpty = false;
            break;
          }
        }
      }
      if (isRateNotEmpty) {
        moneyTypeResultList.add(moneyTypeInside);
      }
    }
  }
  return moneyTypeResultList;
}

CurrencyModel findMoneyModelByMoneyType({required String moneyType}) {
  //TODO: add more condition with avoiding no rate
  for (int currencyListIndex = 0; currencyListIndex < currencyModelListAdminGlobal.length; currencyListIndex++) {
    // if ((currencyModelListAdminGlobal[currencyListIndex].deletedDate == null) || isAdmin) {
      if (currencyModelListAdminGlobal[currencyListIndex].moneyType == moneyType) {
        return currencyModelListAdminGlobal[currencyListIndex];
      }
    // }
  }
  return CurrencyModel(decimalPlace: maxPlaceNumberGlobal, moneyType: moneyType, moneyTypeLanguagePrint: moneyType, name: "", symbol: "", valueList: []);
}

// String findMoneyTypeLanguagePrint({required String moneyType}) {
//   for (int currencyListIndex = 0; currencyListIndex < currencyModelListAdminGlobal.length; currencyListIndex++) {
//     if (currencyModelListAdminGlobal[currencyListIndex].moneyType == moneyType) {
//       return currencyModelListAdminGlobal[currencyListIndex].moneyTypeLanguagePrint;
//     }
//   }
//   return moneyType;
// }

// String findSymbolPlaceByMoneyType({required String moneyType}) {
//   for (int currencyListIndex = 0; currencyListIndex < currencyModelListAdminGlobal.length; currencyListIndex++) {
//     if (currencyModelListAdminGlobal[currencyListIndex].moneyType == moneyType) {
//       return currencyModelListAdminGlobal[currencyListIndex].symbol;
//     }
//   }
//   return "";
// }
ValidButtonModel checkLowerTheExistMoney({required double moneyNumber, required String moneyType}) {
  final int moneyIndex = amountAndProfitModelGlobal.indexWhere((element) => (element.moneyType == moneyType));
  final bool moneyMatch = (moneyIndex != -1);
  if (moneyMatch) {
    final bool isLowerMoneyStock = (amountAndProfitModelGlobal[moneyIndex].amount < moneyNumber);
    if (isLowerMoneyStock) {
      // return false;
      return ValidButtonModel(
        isValid: false,
        errorType: ErrorTypeEnum.compareNumber,
        overwriteRule: "invoice money must lower than or equal total money.",
        errorLocationList: [
          TitleAndSubtitleModel(title: "money type", subtitle: moneyType),
          TitleAndSubtitleModel(
            title: "invoice money",
            subtitle: formatAndLimitNumberTextGlobal(valueStr: moneyNumber.toString(), isRound: false),
          ),
          TitleAndSubtitleModel(
            title: "total money",
            subtitle: formatAndLimitNumberTextGlobal(valueStr: amountAndProfitModelGlobal[moneyIndex].amount.toString(), isRound: false),
          ),
        ],
        error: "invoice money is large than total money.",
        detailList: [
          TitleAndSubtitleModel(
            title:
                "${formatAndLimitNumberTextGlobal(valueStr: amountAndProfitModelGlobal[moneyIndex].amount.toString(), isRound: false)} >= ${formatAndLimitNumberTextGlobal(valueStr: moneyNumber.toString(), isRound: false)}",
            subtitle: "invalid compare",
          ),
        ],
      );
    }
  } else {
    // return false;
    return ValidButtonModel(
      isValid: false,
      errorType: ErrorTypeEnum.compareNumber,
      overwriteRule: "invoice money must lower than or equal total money.",
      errorLocationList: [
        TitleAndSubtitleModel(title: "money type", subtitle: moneyType),
        TitleAndSubtitleModel(
          title: "invoice money",
          subtitle: formatAndLimitNumberTextGlobal(valueStr: moneyNumber.toString(), isRound: false),
        ),
        TitleAndSubtitleModel(
          title: "total money",
          subtitle: formatAndLimitNumberTextGlobal(valueStr: "0", isRound: false),
        ),
      ],
      error: "invoice money is more than total money.",
      detailList: [
        TitleAndSubtitleModel(
          title: "0 < ${formatAndLimitNumberTextGlobal(valueStr: moneyNumber.toString(), isRound: false)}",
          subtitle: "invalid compare",
        ),
      ],
    );
  }
  // return true;
  return ValidButtonModel(isValid: true);
}
