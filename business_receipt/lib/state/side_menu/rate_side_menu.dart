// ignore_for_file: must_be_immutable
import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/rate.dart';
import 'package:business_receipt/env/function/request_api/rate_request_api_env.dart';
import 'package:business_receipt/env/function/slider_env.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/toggle_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/text_limit.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/currency_model.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class RateAdminSideMenu extends StatefulWidget {
  String title;
  RateAdminSideMenu({Key? key, required this.title}) : super(key: key);

  @override
  State<RateAdminSideMenu> createState() => _RateAdminSideMenuState();
}

class _RateAdminSideMenuState extends State<RateAdminSideMenu> {
  @override
  void initState() {
    // void initRateToTempDB() {
    //   bool isEmptyRate = rateModelListAdminGlobal.isEmpty;
    //   if (isEmptyRate) {
    //     getLastRateGlobal(
    //       callBack: () {
    //         _isLoadingOnGetLastRate = false;
    //         setState(() {});
    //       },
    //       context: context,
    //     );
    //   } else {
    //     _isLoadingOnGetLastRate = false;
    //   }
    // }

    // initRateToTempDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      Widget rateButtonWidget({required int rateModelIndex}) {
        Widget setWidthSizeBox() {
          DateTime? deletedDateOrNull = getDeleteDateTimeRate(rateModelIndex: rateModelIndex);
          final bool isDeletedRate = (deletedDateOrNull != null);
          bool isShowRateSuggestion() {
            if (rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.isEmpty || rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.isEmpty) {
              return false;
            } else {
              final rateBaseFirstIndex = rateModelListAdminGlobal.indexWhere((element) {
                final bool isMatchMoneyTypeAndMainMoneyType = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.first) &&
                    (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.last);
                final bool isMatchMoneyTypeAndMainMoneyTypeReverse = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.last) &&
                    (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.first);
                return (isMatchMoneyTypeAndMainMoneyType || isMatchMoneyTypeAndMainMoneyTypeReverse);
              });
              final rateBaseLastIndex = rateModelListAdminGlobal.indexWhere((element) {
                final bool isMatchMoneyTypeAndMainMoneyType = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.first) &&
                    (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.last);
                final bool isMatchMoneyTypeAndMainMoneyTypeReverse = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.last) &&
                    (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.first);
                return (isMatchMoneyTypeAndMainMoneyType || isMatchMoneyTypeAndMainMoneyTypeReverse);
              });
              final bool isNotMatchBaseRateFirst = (rateBaseFirstIndex == -1);
              final bool isNotMatchBaseRateLast = (rateBaseLastIndex == -1);
              if (isNotMatchBaseRateFirst || isNotMatchBaseRateLast) {
                return false;
              } else {
                final BuyOrSellRateModel? baseBuyFirstOrNull = rateModelListAdminGlobal[rateBaseFirstIndex].buy;
                final BuyOrSellRateModel? baseSellFirstOrNull = rateModelListAdminGlobal[rateBaseFirstIndex].sell;

                final BuyOrSellRateModel? baseBuyLastOrNull = rateModelListAdminGlobal[rateBaseLastIndex].buy;
                final BuyOrSellRateModel? baseSellLastOrNull = rateModelListAdminGlobal[rateBaseLastIndex].sell;

                final bool isHasBaseBuyFirstOrNull = (baseBuyFirstOrNull == null);
                final bool isHasBaseSellFirstOrNull = (baseSellFirstOrNull == null);

                final bool isHasBaseBuyLastOrNull = (baseBuyLastOrNull == null);
                final bool isHasBaseSellLastOrNull = (baseSellLastOrNull == null);

                if (isHasBaseBuyFirstOrNull || isHasBaseSellFirstOrNull || isHasBaseBuyLastOrNull || isHasBaseSellLastOrNull) {
                  return false;
                } else {
                  final int place = rateModelListAdminGlobal[rateModelIndex].place;

                  final double baseBuyRateFirstNumber = textEditingControllerToDouble(controller: baseBuyFirstOrNull.value)!;
                  final double baseSellRateFirstNumber = textEditingControllerToDouble(controller: baseSellFirstOrNull.value)!;

                  final double baseBuyRateLastNumber = textEditingControllerToDouble(controller: baseBuyLastOrNull.value)!;
                  final double baseSellRateLastNumber = textEditingControllerToDouble(controller: baseSellLastOrNull.value)!;
                  final double suggestBuyRateNumber = double.parse(formatAndLimitNumberTextGlobal(
                    valueStr: (baseBuyRateFirstNumber / baseSellRateLastNumber).toString(),
                    isRound: false,
                    isAddComma: false,
                    places: place,
                    isAllowZeroAtLast: false,
                  ));
                  final double suggestSellRateNumber = double.parse(formatAndLimitNumberTextGlobal(
                    valueStr: (baseSellRateFirstNumber / baseBuyRateLastNumber).toString(),
                    isRound: true,
                    isAddComma: false,
                    places: place,
                    isAllowZeroAtLast: false,
                  ));

                  final BuyOrSellRateModel? selectedBuyRateOrNull = rateModelListAdminGlobal[rateModelIndex].buy;
                  final BuyOrSellRateModel? selectedSellRateOrNull = rateModelListAdminGlobal[rateModelIndex].sell;
                  final bool isNotNullSelectedBuyRate = (selectedBuyRateOrNull != null);
                  final bool isNotNullSelectedSellRate = (selectedSellRateOrNull != null);
                  if (isNotNullSelectedBuyRate && isNotNullSelectedSellRate) {
                    final double selectedBuyRateNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateModelIndex].buy!.value)!;
                    final double selectedSellRateNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateModelIndex].sell!.value)!;

                    final bool isBaseAndSelectedBuyRateEqual = (suggestBuyRateNumber == selectedBuyRateNumber);
                    final bool isBaseAndSelectedSellRateEqual = (suggestSellRateNumber == selectedSellRateNumber);
                    if (isBaseAndSelectedBuyRateEqual && isBaseAndSelectedSellRateEqual) {
                      return false;
                    }
                  }
                }
              }
            }

            return true;
          }

          void onTapUnlessDisable() {
            void rateEditorDialog() {
              final bool isEditingRate = (profileModelEmployeeGlobal == null && !isDeletedRate);
              if (isEditingRate) {
                editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.rate);
              }
              RateModel rateModelTemp = cloneRateModel(rateModelIndex: rateModelIndex);
              bool isInitAnalysis = true;
              bool outOfDateQuery = false;
              int skip = 0;
              AnalysisExchangeModel analysisExchangeModelTemp = AnalysisExchangeModel(leftList: [], rateType: []);
              final isBuyOrSellRateNull = ((rateModelTemp.buy == null) || (rateModelTemp.sell == null));
              if (isBuyOrSellRateNull) {
                rateModelTemp.buy = BuyOrSellRateModel(discountOptionList: [], value: TextEditingController());
                rateModelTemp.sell = BuyOrSellRateModel(discountOptionList: [], value: TextEditingController());
              }
              ValidButtonModel validToSaveRate() {
                bool isValidate = true;

                //-----------------check rate text empty or not--------------------
                final bool isBuyRateNotEmpty = rateModelTemp.buy!.value.text.isNotEmpty;
                if (isBuyRateNotEmpty) {
                  final bool isRateEqual0 = (double.parse(formatTextToNumberStrGlobal(valueStr: rateModelTemp.buy!.value.text)) == 0);
                  if (isRateEqual0) {
                    // return false;
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.valueOfNumber,
                      error: "buy rate value equal 0.",
                      errorLocationList: [TitleAndSubtitleModel(title: "buy rate value", subtitle: rateModelTemp.buy!.value.text)],
                    );
                  } else {
                    isValidate = true;
                  }
                } else {
                  // return false;
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfNumber,
                    error: "buy rate value is empty.",
                    errorLocationList: [TitleAndSubtitleModel(title: "buy rate value", subtitle: rateModelTemp.buy!.value.text)],
                  );
                }

                final bool isSellRateNotEmpty = rateModelTemp.sell!.value.text.isNotEmpty;
                if (isSellRateNotEmpty) {
                  final bool isRateEqual0 = (double.parse(formatTextToNumberStrGlobal(valueStr: rateModelTemp.sell!.value.text)) == 0);
                  if (isRateEqual0) {
                    // return false;
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.valueOfNumber,
                      error: "sell rate value equal 0.",
                      errorLocationList: [TitleAndSubtitleModel(title: "sell rate value", subtitle: rateModelTemp.sell!.value.text)],
                    );
                  } else {
                    isValidate = true;
                  }
                } else {
                  // return false;
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfNumber,
                    error: "sell rate value is empty.",
                    errorLocationList: [TitleAndSubtitleModel(title: "sell rate value", subtitle: rateModelTemp.sell!.value.text)],
                  );
                }

                bool isNotSameRateBaseOn({required List<String> rateTempList, required List<String> rateMainList}) {
                  if (rateTempList.isNotEmpty && rateMainList.isNotEmpty) {
                    return (rateTempList.first != rateMainList.first) || (rateTempList.last != rateMainList.last);
                  } else {
                    return false;
                  }
                }

                final bool isNotEmptyOnBuyAndSellRow = (rateModelTemp.buy!.value.text.isNotEmpty && rateModelTemp.sell!.value.text.isNotEmpty);
                if (isNotEmptyOnBuyAndSellRow) {
                  final double buyRateNumber = double.parse(formatTextToNumberStrGlobal(valueStr: rateModelTemp.buy!.value.text));
                  final double sellRateNumber = double.parse(formatTextToNumberStrGlobal(valueStr: rateModelTemp.sell!.value.text));

                  //buy rate must lesser than Sell rate, if not than isValidate = false

                  final bool isBuyEqualSell = (buyRateNumber == sellRateNumber);
                  if (isBuyEqualSell) {
                    // return false;
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.compareNumber,
                      error: "buy rate value is equal with sell rate value.",
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "buy rate value", subtitle: rateModelTemp.buy!.value.text),
                        TitleAndSubtitleModel(title: "sell rate value", subtitle: rateModelTemp.sell!.value.text),
                      ],
                      detailList: [
                        TitleAndSubtitleModel(title: "${rateModelTemp.buy!.value.text} < ${rateModelTemp.sell!.value.text}", subtitle: "invalid compare"),
                      ],
                    );
                  }

                  final bool isBuyLargeThanSell = (buyRateNumber > sellRateNumber);
                  if (isBuyLargeThanSell) {
                    // return false;
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.compareNumber,
                      error: "buy rate value is larger than sell rate value.",
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "buy rate value", subtitle: rateModelTemp.buy!.value.text),
                        TitleAndSubtitleModel(title: "sell rate value", subtitle: rateModelTemp.sell!.value.text),
                      ],
                      detailList: [
                        TitleAndSubtitleModel(title: "${rateModelTemp.buy!.value.text} < ${rateModelTemp.sell!.value.text}", subtitle: "invalid compare"),
                      ],
                    );
                  }

                  //---------------check current rate and previous rate-------------------

                  BuyOrSellRateModel? rateBuy = rateModelListAdminGlobal[rateModelIndex].buy;
                  BuyOrSellRateModel? rateSell = rateModelListAdminGlobal[rateModelIndex].sell;
                  final bool isSameBuy = (buyRateNumber == ((rateBuy == null) ? null : textEditingControllerToDouble(controller: rateBuy.value)));
                  final bool isSameSell = (sellRateNumber == ((rateSell == null) ? null : textEditingControllerToDouble(controller: rateSell.value)));

                  //-------------------check both buy and Sell rate, if one of them false. So false----------------
                  if (isSameBuy && isSameSell) {
                    isValidate = false;
                  }

                  for (int discountOptionIndex = 0; discountOptionIndex < rateModelTemp.buy!.discountOptionList.length; discountOptionIndex++) {
                    final bool isBuyDiscountOptionEmpty = rateModelTemp.buy!.discountOptionList[discountOptionIndex].text.isEmpty;
                    if (isBuyDiscountOptionEmpty) {
                      // return false;
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.valueOfNumber,
                        error: "buy discount is empty.",
                        errorLocationList: [
                          TitleAndSubtitleModel(title: "buy discount index", subtitle: discountOptionIndex.toString()),
                          TitleAndSubtitleModel(
                            title: "buy discount",
                            subtitle: rateModelTemp.buy!.discountOptionList[discountOptionIndex].text,
                          ),
                        ],
                      );
                    }
                  }
                  final int buyDiscountOptionLengthTemp = rateModelTemp.buy!.discountOptionList.length;

                  final bool rateModelBuyNotNull = (rateModelListAdminGlobal[rateModelIndex].buy != null);
                  if (rateModelBuyNotNull) {
                    final int buyDiscountOptionLength = rateModelListAdminGlobal[rateModelIndex].buy!.discountOptionList.length;
                    final bool isBuyDiscountOptionLengthNotSame = (buyDiscountOptionLengthTemp != buyDiscountOptionLength);
                    if (isBuyDiscountOptionLengthNotSame) {
                      isValidate = true;
                    } else {
                      for (int buyDiscountOptionIndex = 0; buyDiscountOptionIndex < buyDiscountOptionLengthTemp; buyDiscountOptionIndex++) {
                        final double? buyDiscountOptionTemp =
                            textEditingControllerToDouble(controller: rateModelTemp.buy!.discountOptionList[buyDiscountOptionIndex]); //never be null, because already null check above
                        final double buyDiscountOption = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateModelIndex].buy!.discountOptionList[buyDiscountOptionIndex])!;
                        final bool isBuyDiscountOptionNotSame = (buyDiscountOptionTemp != buyDiscountOption);
                        if (isBuyDiscountOptionNotSame) {
                          isValidate = true;
                        }
                      }
                    }
                  }

                  for (int discountOptionIndex = 0; discountOptionIndex < rateModelTemp.sell!.discountOptionList.length; discountOptionIndex++) {
                    final bool isSellDiscountOptionEmpty = rateModelTemp.sell!.discountOptionList[discountOptionIndex].text.isEmpty;
                    if (isSellDiscountOptionEmpty) {
                      // return false;
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.valueOfNumber,
                        error: "sell discount is empty.",
                        errorLocationList: [
                          TitleAndSubtitleModel(title: "sell discount index", subtitle: discountOptionIndex.toString()),
                          TitleAndSubtitleModel(
                            title: "sell discount",
                            subtitle: rateModelTemp.sell!.discountOptionList[discountOptionIndex].text,
                          ),
                        ],
                      );
                    }
                  }

                  final bool rateModelSellNotNull = (rateModelListAdminGlobal[rateModelIndex].buy != null);
                  if (rateModelSellNotNull) {
                    final int sellDiscountOptionLengthTemp = rateModelTemp.sell!.discountOptionList.length;
                    final int sellDiscountOptionLength = rateModelListAdminGlobal[rateModelIndex].sell!.discountOptionList.length;
                    final bool isSellDiscountOptionLengthNotSame = (sellDiscountOptionLengthTemp != sellDiscountOptionLength);
                    if (isSellDiscountOptionLengthNotSame) {
                      isValidate = true;
                    } else {
                      for (int sellDiscountOptionIndex = 0; sellDiscountOptionIndex < sellDiscountOptionLengthTemp; sellDiscountOptionIndex++) {
                        final double sellDiscountOptionTemp =
                            textEditingControllerToDouble(controller: rateModelTemp.sell!.discountOptionList[sellDiscountOptionIndex])!; //never be null, because already null check above
                        final double sellDiscountOption = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateModelIndex].sell!.discountOptionList[sellDiscountOptionIndex])!;
                        final bool isSellDiscountOptionNotSame = (sellDiscountOptionTemp != sellDiscountOption);
                        if (isSellDiscountOptionNotSame) {
                          isValidate = true;
                        }
                      }
                    }
                  }
                }

                if (rateModelTemp.rateValueBaseOn.first.isEmpty && rateModelTemp.rateValueBaseOn.last.isNotEmpty) {
                  // return false;
                  return ValidButtonModel(isValid: false, error: "both base on rate selected, otherwise both base on rate empty.");
                }
                // if (rateModelTemp.rateValueBaseOn.first.isEmpty) {
                //   // return false;
                //   return ValidButtonModel(
                //     isValid: false,
                //     errorType: ErrorTypeEnum.valueOfNumber,
                //     error: "rate value base on first is empty.",
                //     errorLocationList: [
                //       TitleAndSubtitleModel(title: "rate value base on first", subtitle: rateModelTemp.rateValueBaseOn.first.toString()),
                //     ],
                //   );
                // }
                // if (rateModelTemp.rateValueBaseOn.last.isNotEmpty) {
                //   // return false;
                //   return ValidButtonModel(
                //     isValid: false,
                //     errorType: ErrorTypeEnum.valueOfNumber,
                //     error: "rate value base on last is not empty.",
                //     errorLocationList: [
                //       TitleAndSubtitleModel(title: "rate value base on last", subtitle: rateModelTemp.rateValueBaseOn.last.toString()),
                //     ],
                //   );
                // }
                if (rateModelTemp.rateValueBaseOn.first.isNotEmpty && rateModelTemp.rateValueBaseOn.last.isEmpty) {
                  // return false;
                  return ValidButtonModel(isValid: false, error: "both base on rate selected, otherwise both base on rate empty.");
                }
                // if (rateModelTemp.rateValueBaseOn.first.isNotEmpty) {
                //   // return false;
                //   return ValidButtonModel(
                //     isValid: false,
                //     errorType: ErrorTypeEnum.valueOfNumber,
                //     error: "rate value base on first is not empty.",
                //     errorLocationList: [
                //       TitleAndSubtitleModel(title: "rate value base on first", subtitle: rateModelTemp.rateValueBaseOn.first.toString()),
                //     ],
                //   );
                // }
                // if (rateModelTemp.rateValueBaseOn.last.isEmpty) {
                //   // return false;
                //   return ValidButtonModel(
                //     isValid: false,
                //     errorType: ErrorTypeEnum.valueOfNumber,
                //     error: "rate value base on last is empty.",
                //     errorLocationList: [
                //       TitleAndSubtitleModel(title: "rate value base on last", subtitle: rateModelTemp.rateValueBaseOn.last.toString()),
                //     ],
                //   );
                // }

                if (rateModelTemp.rateValueBaseOn.first.isNotEmpty && rateModelTemp.rateValueBaseOn.last.isNotEmpty) {
                  final bool isFirstRateSame = rateModelTemp.rateValueBaseOn.first.first == rateModelTemp.rateValueBaseOn.last.first;
                  final bool isLastRateSame = rateModelTemp.rateValueBaseOn.first.last == rateModelTemp.rateValueBaseOn.last.last;
                  if (isFirstRateSame && isLastRateSame) {
                    // return false;

                    if (isFirstRateSame) {
                      // return false;
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.compareNumber,
                        error: "rate value base on first is same with rate value base on last.",
                        errorLocationList: [
                          TitleAndSubtitleModel(title: "rate value base on first", subtitle: rateModelTemp.rateValueBaseOn.first.toString()),
                          TitleAndSubtitleModel(title: "rate value base on last", subtitle: rateModelTemp.rateValueBaseOn.last.toString()),
                        ],
                        detailList: [
                          TitleAndSubtitleModel(
                            title: "${rateModelTemp.rateValueBaseOn.first} == ${rateModelTemp.rateValueBaseOn.last}",
                            subtitle: "invalid compare",
                          ),
                        ],
                      );
                    }
                    if (isLastRateSame) {
                      // return false;
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.compareNumber,
                        error: "rate value base on last is same with rate value base on first.",
                        errorLocationList: [
                          TitleAndSubtitleModel(title: "rate value base on first", subtitle: rateModelTemp.rateValueBaseOn.first.toString()),
                          TitleAndSubtitleModel(title: "rate value base on last", subtitle: rateModelTemp.rateValueBaseOn.last.toString()),
                        ],
                        detailList: [
                          TitleAndSubtitleModel(
                            title: "${rateModelTemp.rateValueBaseOn.first} == ${rateModelTemp.rateValueBaseOn.last}",
                            subtitle: "invalid compare",
                          ),
                        ],
                      );
                    }
                  }
                }

                if (rateModelTemp.limit.first.text.isEmpty) {
                  // return false;
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfNumber,
                    error: "minimum rate is empty.",
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "minimum rate", subtitle: rateModelTemp.limit.first.text),
                    ],
                  );
                }
                if (rateModelTemp.limit.last.text.isEmpty) {
                  // return false;
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfNumber,
                    error: "maximum rate is empty.",
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "maximum rate", subtitle: rateModelTemp.limit.last.text),
                    ],
                  );
                }

                // if (textEditingControllerToDouble(controller: rateModelTemp.limit.first)! == 0 ||
                //     textEditingControllerToDouble(controller: rateModelTemp.limit.last)! == 0) {
                //   // return false;

                // }
                if (textEditingControllerToDouble(controller: rateModelTemp.limit.first)! == 0) {
                  // return false;
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.compareNumber,
                    error: "minimum rate equal 0.",
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "minimum rate", subtitle: rateModelTemp.limit.first.text),
                    ],
                  );
                }
                if (textEditingControllerToDouble(controller: rateModelTemp.limit.last)! == 0) {
                  // return false;

                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.compareNumber,
                    error: "maximum rate equal 0.",
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "maximum rate", subtitle: rateModelTemp.limit.last.text),
                    ],
                  );
                }

                if (textEditingControllerToDouble(controller: rateModelTemp.limit.first)! >= textEditingControllerToDouble(controller: rateModelTemp.limit.last)!) {
                  // return false;
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.compareNumber,
                    error: "minimum rate is larger or equal than maximum rate.",
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "minimum rate", subtitle: rateModelTemp.limit.first.text),
                      TitleAndSubtitleModel(title: "maximum rate", subtitle: rateModelTemp.limit.last.text),
                    ],
                    detailList: [
                      TitleAndSubtitleModel(
                        title: "${rateModelTemp.limit.first.text} >= ${rateModelTemp.limit.last.text}",
                        subtitle: "invalid compare",
                      ),
                    ],
                  );
                }

                final double limitFirstNumber = textEditingControllerToDouble(controller: rateModelTemp.limit.first)!;
                final double limitLastNumber = textEditingControllerToDouble(controller: rateModelTemp.limit.last)!;
                final double buyValueNumber = textEditingControllerToDouble(controller: rateModelTemp.buy!.value)!;
                final double sellValueNumber = textEditingControllerToDouble(controller: rateModelTemp.sell!.value)!;
                // final bool isValidateBetweenLimit = (limitFirstNumber <= buyValueNumber && buyValueNumber <= limitLastNumber) &&
                //     (limitFirstNumber <= sellValueNumber && sellValueNumber <= limitLastNumber);
                // if (!isValidateBetweenLimit) {
                //   // return false;

                // }
                if (!(limitFirstNumber <= buyValueNumber && buyValueNumber <= limitLastNumber)) {
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.compareNumber,
                    error: "buy rate value is not between $limitFirstNumber and $limitLastNumber.",
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "buy rate value", subtitle: rateModelTemp.buy!.value.text),
                    ],
                    detailList: [
                      TitleAndSubtitleModel(
                        title: "$limitFirstNumber <= $buyValueNumber <= $limitLastNumber",
                        subtitle: "invalid compare",
                      ),
                    ],
                  );
                }

                if (!(limitFirstNumber <= sellValueNumber && sellValueNumber <= limitLastNumber)) {
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.compareNumber,
                    error: "sell rate value is not between $limitFirstNumber and $limitLastNumber.",
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "sell rate value", subtitle: rateModelTemp.sell!.value.text),
                    ],
                    detailList: [
                      TitleAndSubtitleModel(
                        title: "$limitFirstNumber <= $sellValueNumber <= $limitLastNumber",
                        subtitle: "invalid compare",
                      ),
                    ],
                  );
                }

                for (int buyDiscountIndex = 0; buyDiscountIndex < rateModelTemp.buy!.discountOptionList.length; buyDiscountIndex++) {
                  final double buyDiscountValueNumber = textEditingControllerToDouble(controller: rateModelTemp.buy!.discountOptionList[buyDiscountIndex])!;
                  final bool isValidateBetweenLimit = (limitFirstNumber <= buyDiscountValueNumber && buyDiscountValueNumber <= limitLastNumber);
                  if (!isValidateBetweenLimit) {
                    // return false;
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.compareNumber,
                      error: "buy discount value is not between $limitFirstNumber and $limitLastNumber.",
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "buy discount index", subtitle: buyDiscountIndex.toString()),
                        TitleAndSubtitleModel(title: "buy discount value", subtitle: rateModelTemp.buy!.discountOptionList[buyDiscountIndex].text),
                      ],
                      detailList: [
                        TitleAndSubtitleModel(
                          title: "$limitFirstNumber <= $buyDiscountValueNumber <= $limitLastNumber",
                          subtitle: "invalid compare",
                        ),
                      ],
                    );
                  }
                }

                for (int sellDiscountIndex = 0; sellDiscountIndex < rateModelTemp.sell!.discountOptionList.length; sellDiscountIndex++) {
                  final double sellDiscountValueNumber = textEditingControllerToDouble(controller: rateModelTemp.sell!.discountOptionList[sellDiscountIndex])!;
                  final bool isValidateBetweenLimit = (limitFirstNumber <= sellDiscountValueNumber && sellDiscountValueNumber <= limitLastNumber);
                  if (!isValidateBetweenLimit) {
                    // return false;
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.compareNumber,
                      error: "sell discount value is not between $limitFirstNumber and $limitLastNumber.",
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "sell discount index", subtitle: sellDiscountIndex.toString()),
                        TitleAndSubtitleModel(title: "sell discount value", subtitle: rateModelTemp.sell!.discountOptionList[sellDiscountIndex].text),
                      ],
                      detailList: [
                        TitleAndSubtitleModel(
                          title: "$limitFirstNumber <= $sellDiscountValueNumber <= $limitLastNumber",
                          subtitle: "invalid compare",
                        ),
                      ],
                    );
                  }
                }

                bool isValidateRateBaseOnFirst = false;
                if (rateModelTemp.rateValueBaseOn.first.length == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.length) {
                  if (isNotSameRateBaseOn(rateTempList: rateModelTemp.rateValueBaseOn.first, rateMainList: rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first)) {
                    isValidateRateBaseOnFirst = true;
                  } else {
                    isValidateRateBaseOnFirst = false;
                  }
                } else {
                  isValidateRateBaseOnFirst = true;
                }

                bool isValidateRateBaseOnLast = false;
                if (rateModelTemp.rateValueBaseOn.last.length == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.length) {
                  if (isNotSameRateBaseOn(rateTempList: rateModelTemp.rateValueBaseOn.last, rateMainList: rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last)) {
                    isValidateRateBaseOnLast = true;
                  } else {
                    isValidateRateBaseOnLast = false;
                  }
                } else {
                  isValidateRateBaseOnLast = true;
                }

                bool isValidatePlaceAndConfigPlaceAndLimit = false;
                final bool isNotSameConfigPlace = rateModelTemp.configPlace != rateModelListAdminGlobal[rateModelIndex].configPlace;
                final bool isNotSamePlace = rateModelTemp.place != rateModelListAdminGlobal[rateModelIndex].place;
                final bool isNotSamePriority = rateModelTemp.priority != rateModelListAdminGlobal[rateModelIndex].priority;
                final bool isNotSameDisplay = rateModelTemp.display != rateModelListAdminGlobal[rateModelIndex].display;
                final bool isNotSameLimitFirst = limitFirstNumber != textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateModelIndex].limit.first);
                final bool isNotSameLimitLast = limitLastNumber != textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateModelIndex].limit.last);
                if (isNotSameConfigPlace || isNotSamePlace || isNotSamePriority || isNotSameDisplay || isNotSameLimitFirst || isNotSameLimitLast) {
                  isValidatePlaceAndConfigPlaceAndLimit = true;
                }

                return ValidButtonModel(
                  isValid: (isValidate || isValidateRateBaseOnFirst || isValidateRateBaseOnLast || isValidatePlaceAndConfigPlaceAndLimit),
                  errorType: ErrorTypeEnum.nothingChange,
                );
              }

              Widget contentDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                void queryAnalysisExchangeBySkip() {
                  if (!outOfDateQuery) {
                    final int beforeQuery = analysisExchangeModelTemp.leftList.length;
                    void callBack() {
                      final int afterQuery = analysisExchangeModelTemp.leftList.length;
                      if (beforeQuery == afterQuery) {
                        outOfDateQuery = true;
                      } else {
                        skip = skip + queryLimitNumberGlobal;
                      }
                      setStateFromDialog(() {});
                    }

                    getAnalysisExchangeByRateTypeAdmin(callBack: callBack, context: context, rateType: rateModelTemp.rateType, skip: skip, analysisExchangeModel: analysisExchangeModelTemp);
                  }
                }

                if (isInitAnalysis) {
                  queryAnalysisExchangeBySkip();
                  isInitAnalysis = false;
                }

                Widget rateAndSettingWidget() {
                  Widget paddingBottomRateTitleWidget() {
                    Widget rateTitleWidget() {
                      final String rateTitle = "$rateStrGlobal ${rateModelTemp.rateType.first} - ${rateModelTemp.rateType.last}";
                      return Text(rateTitle, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold));
                    }

                    Widget suggestionButton() {
                      void onTapUnlessDisable() {
                        final rateBaseFirstIndex = rateModelListAdminGlobal.indexWhere((element) {
                          final bool isMatchMoneyTypeAndMainMoneyType = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.first) &&
                              (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.last);
                          final bool isMatchMoneyTypeAndMainMoneyTypeReverse = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.last) &&
                              (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.first);
                          return (isMatchMoneyTypeAndMainMoneyType || isMatchMoneyTypeAndMainMoneyTypeReverse);
                        });
                        final rateBaseLastIndex = rateModelListAdminGlobal.indexWhere((element) {
                          final bool isMatchMoneyTypeAndMainMoneyType = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.first) &&
                              (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.last);
                          final bool isMatchMoneyTypeAndMainMoneyTypeReverse = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.last) &&
                              (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.first);
                          return (isMatchMoneyTypeAndMainMoneyType || isMatchMoneyTypeAndMainMoneyTypeReverse);
                        });

                        final int place = rateModelListAdminGlobal[rateModelIndex].place;

                        final double baseBuyRateFirstNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateBaseFirstIndex].buy!.value)!;
                        final double baseSellRateFirstNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateBaseFirstIndex].sell!.value)!;

                        final double baseBuyRateLastNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateBaseLastIndex].buy!.value)!;
                        final double baseSellRateLastNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateBaseLastIndex].sell!.value)!;
                        final String suggestBuyRateStr = formatAndLimitNumberTextGlobal(
                          valueStr: (baseBuyRateFirstNumber / baseSellRateLastNumber).toString(),
                          isRound: false,
                          isAllowZeroAtLast: false,
                          places: place,
                        );
                        final String suggestSellRateStr = formatAndLimitNumberTextGlobal(
                          valueStr: (baseSellRateFirstNumber / baseBuyRateLastNumber).toString(),
                          isRound: true,
                          isAllowZeroAtLast: false,
                          places: place,
                        );
                        rateModelTemp.buy!.value.text = suggestBuyRateStr;
                        rateModelTemp.sell!.value.text = suggestSellRateStr;
                        setStateFromDialog(() {});
                      }

                      // Widget insideSizeBoxWidget() {
                      //   return Text(acceptSuggestionStrGlobal, style: textStyleGlobal(level: Level.mini, color: textButtonColorGlobal));
                      // }

                      ValidButtonModel checkValidButton() {
                        final rateBaseFirstIndex = rateModelListAdminGlobal.indexWhere((element) {
                          final bool isMatchMoneyTypeAndMainMoneyType = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.first) &&
                              (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.last);
                          final bool isMatchMoneyTypeAndMainMoneyTypeReverse = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.last) &&
                              (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.first);
                          return (isMatchMoneyTypeAndMainMoneyType || isMatchMoneyTypeAndMainMoneyTypeReverse);
                        });
                        final rateBaseLastIndex = rateModelListAdminGlobal.indexWhere((element) {
                          final bool isMatchMoneyTypeAndMainMoneyType = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.first) &&
                              (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.last);
                          final bool isMatchMoneyTypeAndMainMoneyTypeReverse = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.last) &&
                              (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.first);
                          return (isMatchMoneyTypeAndMainMoneyType || isMatchMoneyTypeAndMainMoneyTypeReverse);
                        });

                        final int place = rateModelListAdminGlobal[rateModelIndex].place;

                        final double baseBuyRateFirstNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateBaseFirstIndex].buy!.value)!;
                        final double baseSellRateFirstNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateBaseFirstIndex].sell!.value)!;

                        final double baseBuyRateLastNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateBaseLastIndex].buy!.value)!;
                        final double baseSellRateLastNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateBaseLastIndex].sell!.value)!;
                        final double suggestBuyRateNumber = double.parse(formatAndLimitNumberTextGlobal(
                          valueStr: (baseBuyRateFirstNumber / baseSellRateLastNumber).toString(),
                          isRound: false,
                          isAddComma: false,
                          places: place,
                          isAllowZeroAtLast: false,
                        ));
                        final double suggestSellRateNumber = double.parse(formatAndLimitNumberTextGlobal(
                          valueStr: (baseSellRateFirstNumber / baseBuyRateLastNumber).toString(),
                          isRound: true,
                          isAddComma: false,
                          places: place,
                          isAllowZeroAtLast: false,
                        ));
                        bool isMatchBuyRate = false;
                        bool isMatchSellRate = false;
                        final bool isNotNullBuy = (rateModelTemp.buy != null);
                        final bool isNotNullSell = (rateModelTemp.sell != null);
                        if (isNotNullBuy && isNotNullSell) {
                          double buyRateNumber = 0;
                          double sellRateNumber = 0;
                          if (rateModelTemp.buy!.value.text.isNotEmpty) {
                            buyRateNumber = textEditingControllerToDouble(controller: rateModelTemp.buy!.value)!;
                          }
                          if (rateModelTemp.sell!.value.text.isNotEmpty) {
                            sellRateNumber = textEditingControllerToDouble(controller: rateModelTemp.sell!.value)!;
                          }
                          isMatchBuyRate = (buyRateNumber == suggestBuyRateNumber);
                          isMatchSellRate = (sellRateNumber == suggestSellRateNumber);
                        }
                        if (isMatchBuyRate && isMatchSellRate) {
                          // return false;
                          return ValidButtonModel(isValid: false, error: "accepted suggestion");
                        }
                        // return true;
                        return ValidButtonModel(isValid: true);
                      }

                      ValidButtonModel validModel() {
                        if (!isEditingRate) {
                          return ValidButtonModel(isValid: false, error: "employee does not have permission to edit rate");
                        }
                        return checkValidButton();
                      }

                      return isShowRateSuggestion()
                          ? Padding(
                              padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
                              child: acceptSuggestButtonOrContainerWidget(
                                context: context,
                                level: Level.mini,
                                onTapFunction: onTapUnlessDisable,
                                // validModel: (checkValidButton() && isEditingRate),
                                validModel: validModel(),
                              ),
                            )
                          : Container();
                    }

                    return Padding(
                      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                      child: Row(children: [rateTitleWidget(), suggestionButton()]),
                    );
                  }

                  Widget textFieldWidget({required String labelText, required Function onChangeFromOutsiderFunction, required TextEditingController controller, required bool isBuyRate}) {
                    Widget rateTextFieldWidget() {
                      void onTapFromOutsiderFunction() {}
                      return Padding(
                        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                        child: textFieldGlobal(
                          isEnabled: isEditingRate,
                          labelText: labelText,
                          level: Level.normal,
                          controller: controller,
                          onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                          textFieldDataType: TextFieldDataType.double,
                          onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                        ),
                      );
                    }

                    Widget suggestionTextProviderWidget() {
                      if (isShowRateSuggestion()) {
                        final rateBaseFirstIndex = rateModelListAdminGlobal.indexWhere((element) {
                          final bool isMatchMoneyTypeAndMainMoneyType = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.first) &&
                              (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.last);
                          final bool isMatchMoneyTypeAndMainMoneyTypeReverse = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.last) &&
                              (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.first.first);
                          return (isMatchMoneyTypeAndMainMoneyType || isMatchMoneyTypeAndMainMoneyTypeReverse);
                        });
                        final rateBaseLastIndex = rateModelListAdminGlobal.indexWhere((element) {
                          final bool isMatchMoneyTypeAndMainMoneyType = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.first) &&
                              (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.last);
                          final bool isMatchMoneyTypeAndMainMoneyTypeReverse = (element.rateType.first == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.last) &&
                              (element.rateType.last == rateModelListAdminGlobal[rateModelIndex].rateValueBaseOn.last.first);
                          return (isMatchMoneyTypeAndMainMoneyType || isMatchMoneyTypeAndMainMoneyTypeReverse);
                        });

                        final int place = rateModelListAdminGlobal[rateModelIndex].place;

                        final double baseBuyRateFirstNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateBaseFirstIndex].buy!.value)!;
                        final double baseSellRateFirstNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateBaseFirstIndex].sell!.value)!;

                        final double baseBuyRateLastNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateBaseLastIndex].buy!.value)!;
                        final double baseSellRateLastNumber = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateBaseLastIndex].sell!.value)!;
                        final String suggestBuyRateStr = formatAndLimitNumberTextGlobal(
                          valueStr: (baseBuyRateFirstNumber / baseSellRateLastNumber).toString(),
                          isRound: false,
                          places: place,
                          isAllowZeroAtLast: false,
                        );
                        final String suggestSellRateStr = formatAndLimitNumberTextGlobal(
                          valueStr: (baseSellRateFirstNumber / baseBuyRateLastNumber).toString(),
                          isRound: true,
                          places: place,
                          isAllowZeroAtLast: false,
                        );
                        return Text("$suggestStrGlobal: ${isBuyRate ? suggestBuyRateStr : suggestSellRateStr}", style: textStyleGlobal(level: Level.mini));
                      }
                      return Container();
                    }

                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [rateTextFieldWidget(), suggestionTextProviderWidget()]);
                  }

                  Widget discountOptionsWidget({required BuyOrSellRateModel buyOrSell}) {
                    ValidButtonModel checkDiscountOptionFunction() {
                      for (int discountOptionIndex = 0; discountOptionIndex < buyOrSell.discountOptionList.length; discountOptionIndex++) {
                        final bool isBuyDiscountOptionEmpty = buyOrSell.discountOptionList[discountOptionIndex].text.isEmpty;
                        if (isBuyDiscountOptionEmpty) {
                          // return false;
                          return ValidButtonModel(
                            isValid: false,
                            errorType: ErrorTypeEnum.valueOfNumber,
                            error: "discount is empty.",
                            errorLocationList: [
                              TitleAndSubtitleModel(title: "discount index", subtitle: discountOptionIndex.toString()),
                              TitleAndSubtitleModel(title: "discount value", subtitle: ""),
                            ],
                          );
                        }
                      }
                      // return true;
                      return ValidButtonModel(isValid: true);
                    }

                    Widget discountOptionListWidget() {
                      Widget textFieldAndDeleteWidget({required int discountOptionIndex}) {
                        void onTapUnlessDisable() {
                          //TODO: do something
                        }
                        void onDeleteUnlessDisable() {
                          buyOrSell.discountOptionList.removeAt(discountOptionIndex);
                          setStateFromDialog(() {});
                        }

                        Widget insideSizeBoxWidget() {
                          void onChangeFromOutsiderFunction() {
                            setStateFromDialog(() {});
                          }

                          void onTapFromOutsiderFunction() {}
                          return textFieldGlobal(
                            isEnabled: isEditingRate,
                            labelText: discountOptionStrGlobal,
                            level: Level.mini,
                            controller: buyOrSell.discountOptionList[discountOptionIndex],
                            onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                            textFieldDataType: TextFieldDataType.double,
                            onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                          );
                        }

                        return CustomButtonGlobal(
                          level: Level.mini,
                          isDisable: true,
                          insideSizeBoxWidget: insideSizeBoxWidget(),
                          onTapUnlessDisable: onTapUnlessDisable,
                          onDeleteUnlessDisable: isEditingRate ? onDeleteUnlessDisable : null,
                        );
                      }

                      Widget paddingBottomAddButtonWidget() {
                        Widget addButtonWidget() {
                          void onTapFunction() {
                            buyOrSell.discountOptionList.add(TextEditingController());
                            setStateFromDialog(() {});
                          }

                          ValidButtonModel validModel() {
                            if (!isEditingRate) {
                              return ValidButtonModel(isValid: false, error: "employee does not have permission to edit rate");
                            }
                            return checkDiscountOptionFunction();
                          }

                          return addButtonOrContainerWidget(
                            context: context,
                            // validModel: (checkDiscountOptionFunction() && isEditingRate),
                            validModel: validModel(),
                            level: Level.mini,
                            isExpanded: true,
                            onTapFunction: onTapFunction,
                            currentAddButtonQty: buyOrSell.discountOptionList.length,
                            maxAddButtonLimit: rateDiscountAddButtonLimitGlobal,
                          );
                        }

                        return addButtonWidget();
                      }

                      return Column(children: [
                        for (int discountOptionIndex = 0; discountOptionIndex < buyOrSell.discountOptionList.length; discountOptionIndex++)
                          textFieldAndDeleteWidget(discountOptionIndex: discountOptionIndex),
                        paddingBottomAddButtonWidget(),
                      ]);
                    }

                    return Padding(padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.large)), child: discountOptionListWidget());
                  }

                  Widget paddingBuyRateWidget() {
                    Widget paddingBuyRateTextFieldWidget() {
                      void onChangeFromOutsiderFunction() {
                        setStateFromDialog(() {});
                      }

                      return textFieldWidget(
                        labelText: labelBuyRateStrGlobal,
                        controller: rateModelTemp.buy!.value,
                        onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                        isBuyRate: true,
                      );
                    }

                    // return Column(children: [paddingBuyRateTextFieldWidget(), discountOptionsWidget(buyOrSell: rateModelTemp.buy!)]);
                    return Padding(
                      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                      child: CustomButtonGlobal(
                        insideSizeBoxWidget: Column(children: [paddingBuyRateTextFieldWidget(), discountOptionsWidget(buyOrSell: rateModelTemp.buy!)]),
                        onTapUnlessDisable: () {},
                      ),
                    );
                  }

                  Widget paddingSellRateWidget() {
                    Widget paddingSellRateTextFieldWidget() {
                      void onChangeFromOutsiderFunction() {
                        setStateFromDialog(() {});
                      }

                      return textFieldWidget(
                        labelText: labelSellRateStrGlobal,
                        controller: rateModelTemp.sell!.value,
                        onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                        isBuyRate: false,
                      );
                    }

                    // return Column(children: [paddingSellRateTextFieldWidget(), discountOptionsWidget(buyOrSell: rateModelTemp.sell!)]);
                    return Padding(
                      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                      child: CustomButtonGlobal(
                        insideSizeBoxWidget: Column(children: [paddingSellRateTextFieldWidget(), discountOptionsWidget(buyOrSell: rateModelTemp.sell!)]),
                        onTapUnlessDisable: () {},
                      ),
                    );
                  }

                  Widget scrollBuySellWidget() {
                    // Widget paddingVerticalPlaceTextWidget() {
                    //   Widget placeTextWidget() {
                    //     return Text("$decimalStrGlobal = ${rateModelTemp.place}", style: textStyleGlobal(level: Level.normal));
                    //   }

                    //   return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)), child: placeTextWidget());
                    // }

                    Widget placeSliderWidget() {
                      final double minSlider = -1 * maxPlaceNumberGlobal.toDouble();
                      final double maxSlider = maxPlaceNumberGlobal.toDouble();

                      // return sliderPositiveAndNegativeWidgetGlobal(
                      //   sliderValue: rateModelTemp.place.toDouble(),
                      //   onChangeFunction: ({required double newValue}) {
                      //     if (isEditingRate) {
                      //       rateModelTemp.place = newValue.toInt();
                      //       setStateFromDialog(() {});
                      //     }
                      //   },
                      //   maxSlider: maxSlider,
                      //   minSlider: minSlider,
                      //   // divisionsSlider: divisionsSlider,
                      // );

                      return Padding(
                        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                        child: CustomButtonGlobal(
                          insideSizeBoxWidget: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text("$decimalStrGlobal = ${rateModelTemp.place}", style: textStyleGlobal(level: Level.normal)),
                            sliderPositiveAndNegativeWidgetGlobal(
                              sliderValue: rateModelTemp.place.toDouble(),
                              onChangeFunction: ({required double newValue}) {
                                if (isEditingRate) {
                                  rateModelTemp.place = newValue.toInt();
                                  setStateFromDialog(() {});
                                }
                              },
                              maxSlider: maxSlider,
                              minSlider: minSlider,
                              // divisionsSlider: divisionsSlider,
                            ),
                          ]),
                          onTapUnlessDisable: () {},
                        ),
                      );
                    }

                    // Widget paddingTopConfigPlaceTextWidget() {
                    //   Widget placeTextWidget() {
                    //     return Text("$staticStrGlobal = ${rateModelTemp.configPlace}", style: textStyleGlobal(level: Level.normal));
                    //   }

                    //   return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)), child: placeTextWidget());
                    // }

                    Widget configPlaceSliderWidget() {
                      final double minSlider = -1 * maxPlaceNumberGlobal.toDouble();
                      final double maxSlider = maxPlaceNumberGlobal.toDouble();

                      // return sliderPositiveAndNegativeWidgetGlobal(
                      //   sliderValue: rateModelTemp.configPlace!.toDouble(),
                      //   onChangeFunction: ({required double newValue}) {
                      //     if (isEditingRate) {
                      //       rateModelTemp.configPlace = newValue.toInt();
                      //       setStateFromDialog(() {});
                      //     }
                      //   },
                      //   maxSlider: maxSlider,
                      //   minSlider: minSlider,
                      //   // divisionsSlider: divisionsSlider,
                      // );
                      return Padding(
                        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                        child: CustomButtonGlobal(
                          insideSizeBoxWidget: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text("$staticStrGlobal = ${rateModelTemp.configPlace}", style: textStyleGlobal(level: Level.normal)),
                            sliderPositiveAndNegativeWidgetGlobal(
                              sliderValue: rateModelTemp.configPlace!.toDouble(),
                              onChangeFunction: ({required double newValue}) {
                                if (isEditingRate) {
                                  rateModelTemp.configPlace = newValue.toInt();
                                  setStateFromDialog(() {});
                                }
                              },
                              maxSlider: maxSlider,
                              minSlider: minSlider,
                              // divisionsSlider: divisionsSlider,
                            ),
                          ]),
                          onTapUnlessDisable: () {},
                        ),
                      );
                    }

                    // Widget paddingTopPriorityTextWidget() {
                    //   Widget placeTextWidget() {
                    //     return Text("$priorityStrGlobal = ${rateModelTemp.priority}", style: textStyleGlobal(level: Level.normal));
                    //   }

                    //   return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)), child: placeTextWidget());
                    // }

                    Widget configPrioritySliderWidget() {
                      // return sliderWidgetGlobal(
                      //   sliderValue: rateModelTemp.priority.toDouble(),
                      //   onChangeFunction: ({required double newValue}) {
                      //     if (isEditingRate) {
                      //       rateModelTemp.priority = newValue.toInt();
                      //       setStateFromDialog(() {});
                      //     }
                      //   },
                      //   maxSlider: rateModelListAdminGlobal.length.toDouble(),
                      //   minSlider: 1,
                      // );
                      return Padding(
                        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                        child: CustomButtonGlobal(
                          insideSizeBoxWidget: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text("$priorityStrGlobal = ${rateModelTemp.priority}", style: textStyleGlobal(level: Level.normal)),
                            sliderWidgetGlobal(
                              sliderValue: rateModelTemp.priority.toDouble(),
                              onChangeFunction: ({required double newValue}) {
                                if (isEditingRate) {
                                  rateModelTemp.priority = newValue.toInt();
                                  setStateFromDialog(() {});
                                }
                              },
                              maxSlider: rateModelListAdminGlobal.length.toDouble(),
                              minSlider: 1,
                            ),
                          ]),
                          onTapUnlessDisable: () {},
                        ),
                      );
                    }

                    List<String> valueToStringListRate({required String value}) {
                      return [value.substring(0, 3), value.substring(value.length - 3, value.length)];
                    }

                    Widget rateBaseWidget() {
                      Widget rateBaseFirstDropDrownWidget() {
                        void onTapFunction() {}
                        void onChangedFunction({required String value, required int index}) {
                          if (value == noneStrGlobal) {
                            rateModelTemp.rateValueBaseOn.first = [];
                          } else {
                            rateModelTemp.rateValueBaseOn.first = valueToStringListRate(value: value);
                          }
                          setStateFromDialog(() {});
                        }

                        String? selected() {
                          return rateModelTemp.rateValueBaseOn.first.isEmpty ? null : "${rateModelTemp.rateValueBaseOn.first.first}$minusStrGlobal${rateModelTemp.rateValueBaseOn.first.last}";
                        }

                        final bool isAdmin = (profileModelEmployeeGlobal == null);
                        return (isAdmin && !isDeletedRate)
                            ? customDropdown(
                                level: Level.normal,
                                labelStr: firstRateValueBaseOnStrGlobal,
                                onTapFunction: onTapFunction,
                                onChangedFunction: onChangedFunction,
                                selectedStr: selected(),
                                menuItemStrList: rateOnlyList(isShowAllRate: true, rateTypeDefault: selected(), isShowNone: true),
                              )
                            : textFieldGlobal(
                                isEnabled: false,
                                controller: TextEditingController(text: selected()),
                                onChangeFromOutsiderFunction: () {},
                                labelText: firstRateValueBaseOnStrGlobal,
                                level: Level.normal,
                                textFieldDataType: TextFieldDataType.str,
                                onTapFromOutsiderFunction: () {},
                              );
                      }

                      Widget rateBaseLastDropDrownWidget() {
                        void onTapFunction() {}
                        void onChangedFunction({required String value, required int index}) {
                          if (value == noneStrGlobal) {
                            rateModelTemp.rateValueBaseOn.last = [];
                          } else {
                            rateModelTemp.rateValueBaseOn.last = valueToStringListRate(value: value);
                          }
                          setStateFromDialog(() {});
                        }

                        String? selected() {
                          return rateModelTemp.rateValueBaseOn.last.isEmpty ? null : "${rateModelTemp.rateValueBaseOn.last.first}$minusStrGlobal${rateModelTemp.rateValueBaseOn.last.last}";
                        }

                        final bool isAdmin = (profileModelEmployeeGlobal == null);
                        return Padding(
                          padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)),
                          child: (isAdmin && !isDeletedRate)
                              ? customDropdown(
                                  level: Level.normal,
                                  labelStr: lastRateValueBaseOnStrGlobal,
                                  onTapFunction: onTapFunction,
                                  onChangedFunction: onChangedFunction,
                                  selectedStr: selected(),
                                  menuItemStrList: rateOnlyList(isShowAllRate: true, rateTypeDefault: selected(), isShowNone: true),
                                )
                              : textFieldGlobal(
                                  isEnabled: false,
                                  controller: TextEditingController(text: selected()),
                                  onChangeFromOutsiderFunction: () {},
                                  labelText: lastRateValueBaseOnStrGlobal,
                                  level: Level.normal,
                                  textFieldDataType: TextFieldDataType.str,
                                  onTapFromOutsiderFunction: () {},
                                ),
                        );
                      }

                      return Padding(
                        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                        child: CustomButtonGlobal(
                          insideSizeBoxWidget: Column(children: [rateBaseFirstDropDrownWidget(), rateBaseLastDropDrownWidget()]),
                          onTapUnlessDisable: () {},
                        ),
                      );
                    }

                    Widget limitRateWidget() {
                      Widget minimumRateWidget() {
                        void onTapFromOutsiderFunction() {}
                        void onChangeFromOutsiderFunction() {
                          setStateFromDialog(() {});
                        }

                        return Padding(
                          padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
                          child: textFieldGlobal(
                            isEnabled: isEditingRate,
                            labelText: minimumStrGlobal,
                            level: Level.normal,
                            controller: rateModelTemp.limit.first,
                            onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                            textFieldDataType: TextFieldDataType.double,
                            onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                          ),
                        );
                      }

                      Widget maximumRateWidget() {
                        void onTapFromOutsiderFunction() {}
                        void onChangeFromOutsiderFunction() {
                          setStateFromDialog(() {});
                        }

                        return Padding(
                          padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
                          child: textFieldGlobal(
                            isEnabled: isEditingRate,
                            labelText: maximumStrGlobal,
                            level: Level.normal,
                            controller: rateModelTemp.limit.last,
                            onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                            textFieldDataType: TextFieldDataType.double,
                            onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                          ),
                        );
                      }

                      // return Row(children: [Expanded(child: minimumRateWidget()), Expanded(child: maximumRateWidget())]);
                      return Padding(
                        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                        child: CustomButtonGlobal(
                          insideSizeBoxWidget: Row(children: [Expanded(child: minimumRateWidget()), Expanded(child: maximumRateWidget())]),
                          onTapUnlessDisable: () {},
                        ),
                      );
                    }

                    Widget toggleWidget() {
                      Widget insideSizeBoxWidget() {
                        Widget text() {
                          return Text(visibilityStrGlobal, style: textStyleGlobal(level: Level.normal));
                        }

                        Widget toggle() {
                          void doNothing() {
                            setStateFromDialog(() {});
                          }

                          void callback() {
                            rateModelTemp.display = !rateModelTemp.display;
                            setStateFromDialog(() {});
                          }

                          return showAndHideToggleWidgetGlobal(isLeftSelected: rateModelTemp.display, onToggle: isEditingRate ? callback : doNothing);
                        }

                        return Row(children: [Expanded(child: text()), toggle()]);
                      }

                      return CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: () {});
                    }

                    return Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              paddingBuyRateWidget(),
                              paddingSellRateWidget(),
                              limitRateWidget(),
                              // paddingVerticalPlaceTextWidget(),
                              placeSliderWidget(),
                              // paddingTopConfigPlaceTextWidget(),
                              configPlaceSliderWidget(),
                              // paddingTopPriorityTextWidget(),
                              configPrioritySliderWidget(),
                              // rateBaseFirstDropDrownWidget(),
                              // rateBaseLastDropDrownWidget(),
                              rateBaseWidget(),
                              toggleWidget(),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.large)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        paddingBottomRateTitleWidget(),
                        scrollBuySellWidget(),
                      ],
                    ),
                  );
                }

                Widget analysisWidget() {
                  Widget analysisTitleWidget() {
                    return Padding(
                      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                      child: Text(analysisStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
                    );
                  }

                  Widget analysisListWidget() {
                    void topFunction() {}
                    void bottomFunction() {
                      queryAnalysisExchangeBySkip();
                    }

                    List<Widget> inWrapWidgetList() {
                      final List<String> rateType = analysisExchangeModelTemp.rateType;
                      final bool isBuyRate = analysisExchangeModelTemp.isBuy!;

                      final operateStr = isBuyRate ? "x" : "/";

                      final String getMoneyTypeStr = isBuyRate ? rateType.first : rateType.last;
                      final String giveMoneyTypeStr = isBuyRate ? rateType.last : rateType.first;
                      Widget exchangeElementWidget({required int exchangeIndex}) {
                        void onTapUnlessDisable() {}
                        Widget insideSizeBoxWidget() {
                          final int getMoneyPlace = findMoneyModelByMoneyType(moneyType: getMoneyTypeStr).decimalPlace!;
                          final String getMoneyStr = formatAndLimitNumberTextGlobal(
                            valueStr: analysisExchangeModelTemp.leftList[exchangeIndex].getMoney.toString(),
                            isRound: false,
                            places: (getMoneyPlace >= 0) ? (getMoneyPlace * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                            isAllowZeroAtLast: false,
                          );
                          final String rateValueStr = formatAndLimitNumberTextGlobal(
                            valueStr: analysisExchangeModelTemp.leftList[exchangeIndex].rateValue.toString(),
                            isRound: false,
                            // places: (getMoneyPlace >= 0) ? (getMoneyPlace * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                            isAllowZeroAtLast: false,
                          );
                          final int giveMoneyPlace = findMoneyModelByMoneyType(moneyType: giveMoneyTypeStr).decimalPlace!;
                          final String giveMoneyStr = formatAndLimitNumberTextGlobal(
                            valueStr: analysisExchangeModelTemp.leftList[exchangeIndex].giveMoney.toString(),
                            isRound: false,
                            places: (giveMoneyPlace >= 0) ? (giveMoneyPlace * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                            isAllowZeroAtLast: false,
                          );
                          final String exchangeStr = "$getMoneyStr $getMoneyTypeStr $operateStr $rateValueStr = $giveMoneyStr $giveMoneyTypeStr";
                          return scrollText(textStr: exchangeStr, textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.topLeft);
                        }

                        return CustomButtonGlobal(sizeBoxWidth: dialogSizeGlobal(level: Level.mini), insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
                      }

                      return [for (int exchangeIndex = 0; exchangeIndex < analysisExchangeModelTemp.leftList.length; exchangeIndex++) exchangeElementWidget(exchangeIndex: exchangeIndex)];
                    }

                    return Expanded(
                      child: wrapScrollDetectWidget(
                        inWrapWidgetList: inWrapWidgetList(),
                        topFunction: topFunction,
                        bottomFunction: bottomFunction,
                        isShowSeeMoreWidget: !outOfDateQuery,
                      ),
                    );
                    // return Container();
                  }

                  Widget totalAndAvgWidget() {
                    final List<String> rateType = analysisExchangeModelTemp.rateType;
                    final bool isBuyRate = analysisExchangeModelTemp.isBuy!;

                    final String getMoneyTypeStr = isBuyRate ? rateType.first : rateType.last;
                    final String giveMoneyTypeStr = isBuyRate ? rateType.last : rateType.first;

                    final int getMoneyPlace = findMoneyModelByMoneyType(moneyType: getMoneyTypeStr).decimalPlace!;
                    final String getMoneyStr = formatAndLimitNumberTextGlobal(
                      valueStr: analysisExchangeModelTemp.totalGetMoney.toString(),
                      isRound: false,
                      places: (getMoneyPlace >= 0) ? (getMoneyPlace * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                      isAllowZeroAtLast: false,
                    );
                    final String rateValueStr = formatAndLimitNumberTextGlobal(
                      valueStr: analysisExchangeModelTemp.averageRateValue.toString(),
                      isRound: false,
                      // places: (getMoneyPlace >= 0) ? (getMoneyPlace * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                      isAllowZeroAtLast: false,
                    );
                    final int giveMoneyPlace = findMoneyModelByMoneyType(moneyType: giveMoneyTypeStr).decimalPlace!;
                    final String giveMoneyStr = formatAndLimitNumberTextGlobal(
                      valueStr: analysisExchangeModelTemp.totalGiveMoney.toString(),
                      isRound: false,
                      places: (giveMoneyPlace >= 0) ? (giveMoneyPlace * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                      isAllowZeroAtLast: false,
                    );
                    final String firstRateStr = formatAndLimitNumberTextGlobal(valueStr: analysisExchangeModelTemp.firstRateValue.toString(), isRound: false, isAllowZeroAtLast: false);
                    final String lastRateStr = formatAndLimitNumberTextGlobal(valueStr: analysisExchangeModelTemp.lastRateValue.toString(), isRound: false, isAllowZeroAtLast: false);

                    final String profitMoneyTypeStr = rateType.last;
                    final int profitPlace = findMoneyModelByMoneyType(moneyType: profitMoneyTypeStr).decimalPlace!;
                    final String profitStr = formatAndLimitNumberTextGlobal(
                      valueStr: analysisExchangeModelTemp.profit.toString(),
                      isRound: false,
                      places: (profitPlace >= 0) ? (profitPlace * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                      isAllowZeroAtLast: false,
                    );
                    final bool isAnalysisEmpty = analysisExchangeModelTemp.leftList.isEmpty;
                    return Padding(
                      padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.large), bottom: paddingSizeGlobal(level: Level.normal)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(
                          children: [
                            Text("$totalGetMoneyStrGlobal: ", style: textStyleGlobal(level: Level.normal)),
                            Text("$getMoneyStr $getMoneyTypeStr", style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            Text("$totalGiveMoneyStrGlobal: ", style: textStyleGlobal(level: Level.normal)),
                            Text("$giveMoneyStr $giveMoneyTypeStr", style: textStyleGlobal(level: Level.normal, color: negativeColorGlobal, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        isAnalysisEmpty
                            ? Container()
                            : Row(
                                children: [
                                  Text("$rateStrGlobal: ", style: textStyleGlobal(level: Level.normal)),
                                  Text("$firstRateStr - $lastRateStr ($getMoneyTypeStr -> $giveMoneyTypeStr)", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                                ],
                              ),
                        isAnalysisEmpty
                            ? Container()
                            : Row(
                                children: [
                                  Text("$averageRateStrGlobal: ", style: textStyleGlobal(level: Level.normal)),
                                  Text("$rateValueStr ($getMoneyTypeStr -> $giveMoneyTypeStr)", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                                ],
                              ),
                        Row(
                          children: [
                            Text("$profitStrGlobal: ", style: textStyleGlobal(level: Level.normal)),
                            Text(
                              "$profitStr $profitMoneyTypeStr",
                              style: textStyleGlobal(
                                level: Level.normal,
                                color: (analysisExchangeModelTemp.profit! >= 0) ? positiveColorGlobal : negativeColorGlobal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        isAnalysisEmpty
                            ? Container()
                            : Text(isBuyRate ? waitingForSellExchangeStrGlobal : waitingForBuyingExchangeStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold))
                      ]),
                    );
                  }

                  final bool isIsBuyNotNull = (analysisExchangeModelTemp.isBuy == null);
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    analysisTitleWidget(),
                    (isInitAnalysis || isIsBuyNotNull) ? Container() : totalAndAvgWidget(),
                    (isInitAnalysis || isIsBuyNotNull) ? Container() : analysisListWidget(),
                  ]);
                }

                return Row(children: [
                  Expanded(flex: flexTypeGlobal, child: rateAndSettingWidget()),
                  Expanded(flex: flexValueGlobal, child: analysisWidget()),
                ]);
              }

              void cancelButtonFunction() {
                final bool isAdmin = (profileModelEmployeeGlobal == null);
                if (isAdmin) {
                  void okFunction() {
                    adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.rate);
                    closeDialogGlobal(context: context);
                  }

                  void cancelFunction() {}
                  confirmationDialogGlobal(
                    context: context,
                    okFunction: okFunction,
                    cancelFunction: cancelFunction,
                    titleStr: cancelEditingSettingGlobal,
                    subtitleStr: cancelEditingSettingConfirmGlobal,
                  );
                } else {
                  closeDialogGlobal(context: context);
                }
              }

              void saveButtonFunction() {
                //buy and Sell rate are valid and have different value also

                void callback() {
                  adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.rate);
                  setState(() {});
                  closeDialogGlobal(context: context);
                }

                BuyOrSellRateModel? rateBuy = rateModelListAdminGlobal[rateModelIndex].buy;
                BuyOrSellRateModel? rateSell = rateModelListAdminGlobal[rateModelIndex].sell;
                final double? buyRateNumberCurrent = (rateBuy == null) ? null : textEditingControllerToDouble(controller: rateBuy.value);
                final double? sellRateNumberCurrent = (rateSell == null) ? null : textEditingControllerToDouble(controller: rateSell.value);
                final double buyRateNumberNew = double.parse(formatTextToNumberStrGlobal(valueStr: rateModelTemp.buy!.value.text, isAllowMinus: false));
                final double sellRateNumberNew = double.parse(formatTextToNumberStrGlobal(valueStr: rateModelTemp.sell!.value.text, isAllowMinus: false));
                final bool isChangeBuyRate = (buyRateNumberCurrent != buyRateNumberNew);
                final bool isChangeSellRate = (sellRateNumberCurrent != sellRateNumberNew);
                updateRateAdminGlobal(
                  callBack: callback,
                  context: context,
                  rateModel: rateModelTemp,
                  isChangeBuyRate: isChangeBuyRate,
                  isChangeSellRate: isChangeSellRate,
                );
              }

              actionDialogSetStateGlobal(
                dialogHeight: dialogSizeGlobal(level: Level.mini),
                dialogWidth: dialogSizeGlobal(level: Level.normal),
                context: context,
                contentFunctionReturnWidget: contentDialog,
                cancelFunctionOnTap: cancelButtonFunction,
                validSaveButtonFunction: () => validToSaveRate(),
                saveFunctionOnTap: isEditingRate ? saveButtonFunction : null,
              );
            }

            if (profileModelEmployeeGlobal == null) {
              askingForChangeDialogGlobal(context: context, allowFunction: rateEditorDialog, editSettingTypeEnum: EditSettingTypeEnum.rate);
            } else {
              rateEditorDialog();
            }
          }

          Widget insideSizeBoxWidget() {
            Widget paddingAndColumnWidget() {
              Widget rateAndProfitAndOverFlowWidget() {
                Widget paddingBottomAndCenterRateTypeWidget() {
                  Widget centerRateType() {
                    final String rateMerge = "${rateModelListAdminGlobal[rateModelIndex].rateType.first} - ${rateModelListAdminGlobal[rateModelIndex].rateType.last}";
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(rateMerge, style: textStyleGlobal(level: Level.normal, color: isDeletedRate ? deleteTextColorGlobal : defaultTextColorGlobal))],
                    );
                  }

                  return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)), child: centerRateType());
                }

                String textProviderStr({required double? textNumber}) {
                  final bool isNullRateValue = (textNumber == null);
                  if (isNullRateValue) {
                    return nullOnRateStrGlobal;
                  } else {
                    final int? configPlace = rateModelListAdminGlobal[rateModelIndex].configPlace;
                    final String rateFormat = formatAndLimitNumberTextGlobal(valueStr: textNumber.toString(), isRound: false, configPlace: configPlace, isAllowZeroAtLast: false);
                    return rateFormat.toString();
                  }
                }

                Widget rateWidget({required String titleStr, required double? rateValue}) {
                  return Row(children: [
                    Text(titleStr, style: textStyleGlobal(level: Level.normal, color: isDeletedRate ? deleteTextColorGlobal : defaultTextColorGlobal)),
                    Text(
                      textProviderStr(textNumber: rateValue),
                      style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold, color: isDeletedRate ? deleteTextColorGlobal : defaultTextColorGlobal),
                    ),
                  ]);
                }

                Widget buyRateOrNotYetWidget() {
                  BuyOrSellRateModel? rateBuy = rateModelListAdminGlobal[rateModelIndex].buy;
                  return rateWidget(titleStr: "$buyTitleStrGlobal: ", rateValue: (rateBuy == null) ? null : textEditingControllerToDouble(controller: rateBuy.value));
                }

                Widget sellRateOrNotYetWidget() {
                  BuyOrSellRateModel? rateSell = rateModelListAdminGlobal[rateModelIndex].sell;
                  return rateWidget(titleStr: "$sellTitleStrGlobal: ", rateValue: (rateSell == null) ? null : textEditingControllerToDouble(controller: rateSell.value));
                }

                Widget suggestionWidget() {
                  // Widget suggestionTextWidget() {
                  //   return Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [Text(changeRateSuggestionStrGlobal, style: textStyleGlobal(level: Level.mini, color: textButtonColorGlobal))],
                  //   );
                  // }

                  // return isShowRateSuggestion()
                  //     ? Padding(
                  //         padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)),
                  //         child: CustomButtonGlobal(elevation: 0, insideSizeBoxWidget: suggestionTextWidget(), onTapUnlessDisable: onTapUnlessDisable, colorSideBox: acceptSuggestButtonColorGlobal),
                  //       )
                  //     : Container();
                  return isShowRateSuggestion()
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(changeRateSuggestionStrGlobal, style: textStyleGlobal(level: Level.normal, color: acceptSuggestButtonColorGlobal))],
                        )
                      : Container();
                }

                Widget showOrHideRateWidget() {
                  final String showOrHideStr =
                      (rateModelListAdminGlobal[rateModelIndex].display && (rateModelListAdminGlobal[rateModelIndex].buy != null && rateModelListAdminGlobal[rateModelIndex].sell != null))
                          ? showStrGlobal
                          : hideStrGlobal;
                  final Color showOrHideColor =
                      (rateModelListAdminGlobal[rateModelIndex].display && (rateModelListAdminGlobal[rateModelIndex].buy != null && rateModelListAdminGlobal[rateModelIndex].sell != null))
                          ? positiveColorGlobal
                          : negativeColorGlobal;
                  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(showOrHideStr, style: textStyleGlobal(level: Level.normal, color: showOrHideColor))]);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    paddingBottomAndCenterRateTypeWidget(),
                    buyRateOrNotYetWidget(),
                    sellRateOrNotYetWidget(),
                    isDeletedRate ? Container() : suggestionWidget(),
                    Spacer(),
                    isDeletedRate ? Container() : showOrHideRateWidget(),
                    isDeletedRate
                        ? scrollText(
                            textStr: "$deleteAtStrGlobal ${formatFullDateToStr(date: deletedDateOrNull.add(const Duration(days: deleteAtDay)))}",
                            textStyle: textStyleGlobal(level: Level.mini, fontWeight: FontWeight.bold, color: Colors.red),
                            alignment: Alignment.topCenter,
                          )
                        : Container(),
                  ],
                );
              }

              return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.normal)), child: rateAndProfitAndOverFlowWidget());
            }

            return paddingAndColumnWidget();
          }

          return CustomButtonGlobal(sizeBoxWidth: sizeBoxWidthGlobal, sizeBoxHeight: sizeBoxHeightGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
        }

        return setWidthSizeBox();
      }

      return BodyTemplateSideMenu(
        inWrapWidgetList: [for (int rateModelIndex = 0; rateModelIndex < rateModelListAdminGlobal.length; rateModelIndex++) rateButtonWidget(rateModelIndex: rateModelIndex)],
        title: widget.title,
      );
    }

    return bodyTemplateSideMenu();
  }
}
