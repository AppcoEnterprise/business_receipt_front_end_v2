// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:business_receipt/env/function/active_log.dart';
import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/drop_down_and_text_field_provider.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/merge_value_from_model.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/rate.dart';
import 'package:business_receipt/env/function/request_api/exchange_request_api_env.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_area_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/active_log.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/invoice_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/employee_model/exchange_money_model.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/money_type_and_value_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class ExchangeEmployeeSideMenu extends StatefulWidget {
  String title;
  Function callback;
  ExchangeEmployeeSideMenu({Key? key, required this.title, required this.callback}) : super(key: key);

  @override
  State<ExchangeEmployeeSideMenu> createState() => _ExchangeEmployeeSideMenuState();
}

class _ExchangeEmployeeSideMenuState extends State<ExchangeEmployeeSideMenu> {
  bool isAllowAnalysis = true;
  bool isFormatMoney = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      ValidButtonModel isValidExchange() {
        for (int exchangeIndex = 0; exchangeIndex < exchangeTempSideMenuGlobal.exchangeList.length; exchangeIndex++) {
          if (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoney.text.isEmpty) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              error: "get money from customer value is empty.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeIndex.toString()),
                TitleAndSubtitleModel(title: "get money from customer", subtitle: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoney.text),
              ],
            );
          }
          if (textEditingControllerToDouble(controller: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoney) == 0) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              error: "get money from customer value is 0.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeIndex.toString()),
                TitleAndSubtitleModel(title: "get money from customer", subtitle: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoney.text),
              ],
            );
          }
          if (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoney.text.isEmpty) {
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              error: "give money to customer value is empty.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeIndex.toString()),
                TitleAndSubtitleModel(title: "give money to customer", subtitle: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoney.text),
              ],
            );
          }
          if (textEditingControllerToDouble(controller: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoney) == 0) {
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              error: "give money to customer value is 0.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeIndex.toString()),
                TitleAndSubtitleModel(title: "give money to customer", subtitle: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoney.text),
              ],
            );
          }

          final bool isRateNotNull = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate != null);
          if (isRateNotNull) {
            final bool isRateMoneyNullAndEqual0 = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.value == 0);
            if (isRateMoneyNullAndEqual0) {
              return ValidButtonModel(
                isValid: false,
                errorType: ErrorTypeEnum.valueOfNumber,
                error: "rate value is 0.",
                errorLocationList: [
                  TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeIndex.toString()),
                  TitleAndSubtitleModel(title: "rate value", subtitle: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.value.toString()),
                ],
              );
            }
            if (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue.text.isEmpty) {
              // return false;
              return ValidButtonModel(
                isValid: false,
                errorType: ErrorTypeEnum.valueOfNumber,
                error: "discount rate value is empty.",
                errorLocationList: [
                  TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeIndex.toString()),
                  TitleAndSubtitleModel(
                      title: "discount rate value", subtitle: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue.text),
                ],
              );
            }
            if (textEditingControllerToDouble(controller: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue) == 0) {
              // return false;
              return ValidButtonModel(
                isValid: false,
                errorType: ErrorTypeEnum.valueOfNumber,
                error: "discount rate value is 0.",
                errorLocationList: [
                  TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeIndex.toString()),
                  TitleAndSubtitleModel(
                      title: "discount rate value", subtitle: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue.text),
                ],
              );
            }
          } else {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              error: "please select a rate above.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeIndex.toString()),
              ],
            );
          }

          final RateForCalculateModel rate = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!;
          final String moneyType = (rate.isBuyRate! ? rate.rateType.last : rate.rateType.first);
          double mergeGiveMoney = 0;
          for (int exchangeSubIndex = exchangeIndex; exchangeSubIndex < exchangeTempSideMenuGlobal.exchangeList.length; exchangeSubIndex++) {
            if (exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].rate != null) {
              final RateForCalculateModel rateSub = exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].rate!;
              final String moneyTypeSub = (rateSub.isBuyRate! ? rateSub.rateType.last : rateSub.rateType.first);
              if (moneyTypeSub == moneyType) {
                if (exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].giveMoney.text.isNotEmpty) {
                  mergeGiveMoney =
                      mergeGiveMoney + textEditingControllerToDouble(controller: exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].giveMoney)!;
                }
              }
            } else {
              // return false;
              return ValidButtonModel(
                isValid: false,
                errorType: ErrorTypeEnum.valueOfNumber,
                error: "please select a rate above.",
                errorLocationList: [
                  TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeSubIndex.toString()),
                ],
              );
            }
          }
          final ValidButtonModel lowerMoneyStockModel = checkLowerTheExistMoney(moneyNumber: mergeGiveMoney, moneyType: moneyType);
          if (!lowerMoneyStockModel.isValid) {
            return lowerMoneyStockModel;
          }

          final RateModel rateModel = getRateModel(rateTypeFirst: rate.rateType.first, rateTypeLast: rate.rateType.last)!;
          final double limitFirstNumber = textEditingControllerToDouble(controller: rateModel.limit.first)!;
          final double limitLastNumber = textEditingControllerToDouble(controller: rateModel.limit.last)!;
          final double discountRateNumber =
              textEditingControllerToDouble(controller: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue)!;
          final bool isValidateBetweenLimit = (limitFirstNumber <= discountRateNumber && discountRateNumber <= limitLastNumber);
          if (!isValidateBetweenLimit) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.compareNumber,
              overwriteRule: "rate value must between limit rate.",
              error: "rate value is not between limit rate.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeIndex.toString()),
                TitleAndSubtitleModel(title: "rate value", subtitle: discountRateNumber.toString()),
                TitleAndSubtitleModel(title: "limit rate", subtitle: "$limitFirstNumber - $limitLastNumber"),
              ],
            );
          }
        }
        // return true;
        return ValidButtonModel(isValid: isAllowAnalysis, error: "Please wait $delayApiRequestSecond seconds before analysis.");
      }

      void createOrClearAdditionMoney() {
        exchangeTempSideMenuGlobal.remark.text = "";
        additionMoneyModelListGlobal = [];
        if (isValidExchange().isValid) {
          for (int exchangeIndex = 0; exchangeIndex < exchangeTempSideMenuGlobal.exchangeList.length; exchangeIndex++) {
            final bool isBuy = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.isBuyRate!;
            final String rateTypeFirstStr = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.rateType.first;
            final String rateTypeLastStr = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.rateType.last;
            final String moneyTypeStr = isBuy ? rateTypeLastStr : rateTypeFirstStr;
            bool isExisted = false;
            for (int addIndex = 0; addIndex < additionMoneyModelListGlobal.length; addIndex++) {
              if (additionMoneyModelListGlobal[addIndex].moneyType == moneyTypeStr) {
                isExisted = true;
                break;
              }
            }
            if (!isExisted) {
              additionMoneyModelListGlobal.add(AdditionMoneyModel(addMoney: TextEditingController(), moneyType: moneyTypeStr));
            }
            // if(additionMoneyModelListGlobal.contains()) {

            // }
          }
        }
      }

      void calculateFromRate({required bool? isCalculateOnBuyRate, required bool isBuyRate}) {
        final String rateTypeFirst = exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].rate!.rateType.first;
        final String rateTypeLast = exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].rate!.rateType.last;
        final double rateNumber = double.parse(
          formatAndLimitNumberTextGlobal(
            valueStr: exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].rate!.discountValue.text,
            isRound: !isBuyRate,
            isAddComma: false,
            isAllowZeroAtLast: false,
          ),
        );
        final bool isCalculateOnBuyRateNull = (isCalculateOnBuyRate == null);
        if (isCalculateOnBuyRateNull) {
          isCalculateOnBuyRate = isBuyRate;
        }
        if (isCalculateOnBuyRate) {
          if (exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].getMoney.text.isNotEmpty) {
            final int getMoneyPlace = findMoneyModelByMoneyType(moneyType: isBuyRate ? rateTypeFirst : rateTypeLast).decimalPlace!;
            final int giveMoneyPlace = findMoneyModelByMoneyType(moneyType: isBuyRate ? rateTypeLast : rateTypeFirst).decimalPlace!;
            final double getMoneyNumber = double.parse(
              formatAndLimitNumberTextGlobal(
                valueStr: exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].getMoney.text,
                isRound: true,
                isAddComma: false,
                places: getMoneyPlace + (isFormatMoney ? 0 : 2),
                isAllowZeroAtLast: false,
              ),
            );
            final double resultNumber = isBuyRate ? (getMoneyNumber * rateNumber) : (getMoneyNumber / rateNumber);
            exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].giveMoney.text = formatAndLimitNumberTextGlobal(
              valueStr: resultNumber.toString(),
              isRound: false,
              isAddComma: true,
              places: giveMoneyPlace + (isFormatMoney ? 0 : 2),
              isAllowZeroAtLast: false,
            );
          }
        } else {
          if (exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].giveMoney.text.isNotEmpty) {
            final int getMoneyPlace = findMoneyModelByMoneyType(moneyType: isBuyRate ? rateTypeFirst : rateTypeLast).decimalPlace!;
            final int giveMoneyPlace = findMoneyModelByMoneyType(moneyType: isBuyRate ? rateTypeLast : rateTypeFirst).decimalPlace!;
            final double giveMoneyNumber = double.parse(
              formatAndLimitNumberTextGlobal(
                valueStr: exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].giveMoney.text,
                isRound: false,
                isAddComma: false,
                places: giveMoneyPlace + (isFormatMoney ? 0 : 2),
                isAllowZeroAtLast: false,
              ),
            );

            final double resultNumber = isBuyRate ? (giveMoneyNumber / rateNumber) : (giveMoneyNumber * rateNumber);
            exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].getMoney.text = formatAndLimitNumberTextGlobal(
              valueStr: resultNumber.toString(),
              isRound: true,
              isAddComma: true,
              places: getMoneyPlace + (isFormatMoney ? 0 : 2),
              isAllowZeroAtLast: false,
            );
          }
        }
      }

      Widget customBetweenHeaderAndBodyWidget() {
        Widget scrollHorizontalWidget() {
          Widget rateWidget({required int rateModelListIndex}) {
            Widget setSizeWidget() {
              Widget paddingBuyAndSellRateWidget() {
                Widget paddingRateWidget({required String rateTypeStr, required Function onTapUnlessDisable, required bool isSelected}) {
                  Widget rateContainer() {
                    Widget insideSizeBoxWidget() {
                      return Center(child: Text(rateTypeStr, style: textStyleGlobal(level: Level.large)));
                    }

                    return CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable, isDisable: isSelected);
                  }

                  return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)), child: rateContainer());
                }

                bool checkSelectedRate({required bool isCheckOnBuyRate}) {
                  final bool isRateNull = (exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].rate == null);
                  if (isRateNull) {
                    return false;
                  } else {
                    final String excRateTypeFirst = exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].rate!.rateType.first;
                    final String excRateTypeLast = exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].rate!.rateType.last;
                    final String rateTypeFirst = rateModelListAdminGlobal[rateModelListIndex].rateType.first;
                    final String rateTypeLast = rateModelListAdminGlobal[rateModelListIndex].rateType.last;
                    final bool isRateTypeMatch = ((excRateTypeFirst == rateTypeFirst) && (excRateTypeLast == rateTypeLast));
                    final bool isExcBuyRate = exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].rate!.isBuyRate!;
                    if (isRateTypeMatch && (isExcBuyRate == isCheckOnBuyRate)) {
                      return true;
                    } else {
                      return false;
                    }
                  }
                }

                Widget buyRateWidget() {
                  final String rateTypeFirstStr = rateModelListAdminGlobal[rateModelListIndex].rateType.first;
                  final String rateTypeLastStr = rateModelListAdminGlobal[rateModelListIndex].rateType.last;
                  final String rateTypeStr = "$rateTypeFirstStr$arrowStrGlobal$rateTypeLastStr";

                  void onTapUnlessDisable() {
                    final String rateId = rateModelListAdminGlobal[rateModelListIndex].buy!.id!;
                    final List<String> rateType = rateModelListAdminGlobal[rateModelListIndex].rateType;
                    final double value = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateModelListIndex].buy!.value)!; //never be null
                    final String valueStr = formatAndLimitNumberTextGlobal(valueStr: value.toString(), isRound: false, isAllowZeroAtLast: false);

                    exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].rate = RateForCalculateModel(
                      isBuyRate: true,
                      rateId: rateId,
                      discountValue: TextEditingController(text: valueStr),
                      rateType: rateType,
                      value: value,
                      usedModelList: [],
                      percentage: TextEditingController(),
                    );
                    exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].selectedRateIndex = rateModelListIndex;
                    exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].isSelectedOtherRate = false;
                    final bool isOnChangeGetMoneyNull =
                        (exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].isChangeOnGetMoney == null);
                    final bool isGetTextEmpty = exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].getMoney.text.isEmpty;
                    if (isOnChangeGetMoneyNull || isGetTextEmpty) {
                      final bool isGiveTextNotEmpty = exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].giveMoney.text.isNotEmpty;
                      if (isGiveTextNotEmpty) {
                        exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].giveMoneyFocusNode.requestFocus();
                        calculateFromRate(isCalculateOnBuyRate: false, isBuyRate: true);
                      } else {
                        exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].getMoneyFocusNode.requestFocus();
                      }
                    } else {
                      final bool isChangeOnGetMoney = exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].isChangeOnGetMoney!;
                      if (isChangeOnGetMoney) {
                        exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].getMoneyFocusNode.requestFocus();
                      } else {
                        exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].giveMoneyFocusNode.requestFocus();
                      }
                      calculateFromRate(isCalculateOnBuyRate: isChangeOnGetMoney, isBuyRate: true);
                    }
                    addActiveLogElement(
                      activeLogModelList: activeLogModelExchangeList,
                      activeLogModel: ActiveLogModel(
                        idTemp: "buy or sell rate, $onSelectExchangeSideMenuIndexGlobal",
                        activeType: ActiveLogTypeEnum.clickButton,
                        locationList: [
                          Location(title: "exchange index", subtitle: onSelectExchangeSideMenuIndexGlobal.toString()),
                          Location(title: "exchange rate", subtitle: "buy rate"),
                          Location(title: "button name", subtitle: rateTypeStr),
                        ],
                      ),
                    );
                    createOrClearAdditionMoney();
                    setState(() {});
                  }

                  return paddingRateWidget(
                      rateTypeStr: rateTypeStr, onTapUnlessDisable: onTapUnlessDisable, isSelected: checkSelectedRate(isCheckOnBuyRate: true));
                }

                Widget sellRateWidget() {
                  final String rateTypeFirstStr = rateModelListAdminGlobal[rateModelListIndex].rateType.first;
                  final String rateTypeLastStr = rateModelListAdminGlobal[rateModelListIndex].rateType.last;
                  final String rateTypeStr = "$rateTypeLastStr$arrowStrGlobal$rateTypeFirstStr";

                  void onTapUnlessDisable() {
                    String rateId = rateModelListAdminGlobal[rateModelListIndex].sell!.id!;
                    List<String> rateType = rateModelListAdminGlobal[rateModelListIndex].rateType;
                    double value = textEditingControllerToDouble(controller: rateModelListAdminGlobal[rateModelListIndex].sell!.value)!; //never be null
                    String valueStr = formatAndLimitNumberTextGlobal(valueStr: value.toString(), isRound: false, isAllowZeroAtLast: false);

                    exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].rate = RateForCalculateModel(
                      isBuyRate: false,
                      rateId: rateId,
                      discountValue: TextEditingController(text: valueStr),
                      rateType: rateType,
                      value: value,
                      usedModelList: [],
                      percentage: TextEditingController(),
                    );
                    exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].selectedRateIndex = rateModelListIndex;
                    exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].isSelectedOtherRate = false;
                    final bool isOnChangeGetMoneyNull =
                        (exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].isChangeOnGetMoney == null);
                    final bool isGiveTextEmpty = exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].giveMoney.text.isEmpty;
                    if (isOnChangeGetMoneyNull || isGiveTextEmpty) {
                      final bool isGetTextNotEmpty = exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].getMoney.text.isNotEmpty;
                      if (isGetTextNotEmpty) {
                        exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].getMoneyFocusNode.requestFocus();
                        calculateFromRate(isCalculateOnBuyRate: true, isBuyRate: false);
                      } else {
                        exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].giveMoneyFocusNode.requestFocus();
                      }
                    } else {
                      final bool isChangeOnGetMoney = exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].isChangeOnGetMoney!;
                      if (isChangeOnGetMoney) {
                        exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].getMoneyFocusNode.requestFocus();
                      } else {
                        exchangeTempSideMenuGlobal.exchangeList[onSelectExchangeSideMenuIndexGlobal].giveMoneyFocusNode.requestFocus();
                      }
                      calculateFromRate(isCalculateOnBuyRate: isChangeOnGetMoney, isBuyRate: false);
                    }
                    addActiveLogElement(
                      activeLogModelList: activeLogModelExchangeList,
                      activeLogModel: ActiveLogModel(
                        idTemp: "buy or sell rate, $onSelectExchangeSideMenuIndexGlobal",
                        activeType: ActiveLogTypeEnum.clickButton,
                        locationList: [
                          Location(title: "exchange index", subtitle: onSelectExchangeSideMenuIndexGlobal.toString()),
                          Location(title: "exchange rate", subtitle: "sell rate"),
                          Location(title: "button name", subtitle: rateTypeStr),
                        ],
                      ),
                    );
                    createOrClearAdditionMoney();
                    setState(() {});
                  }

                  return paddingRateWidget(
                      rateTypeStr: rateTypeStr, onTapUnlessDisable: onTapUnlessDisable, isSelected: checkSelectedRate(isCheckOnBuyRate: false));
                }

                Widget showRateProvider() {
                  final bool isNotNullRate =
                      ((rateModelListAdminGlobal[rateModelListIndex].buy != null) && (rateModelListAdminGlobal[rateModelListIndex].sell != null));
                  return isNotNullRate ? Column(children: [Expanded(child: buyRateWidget()), Expanded(child: sellRateWidget())]) : Container();
                }

                return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: showRateProvider());
              }

              DateTime? deletedDateOrNull = getDeleteDateTimeRate(rateModelIndex: rateModelListIndex);
              final bool isDeletedRate = (deletedDateOrNull != null);
              return isDeletedRate || !rateModelListAdminGlobal[rateModelListIndex].display
                  ? Container()
                  : Container(
                      margin: EdgeInsets.zero,
                      width: 300, //TODO: resize the width depending on the system width
                      height: sizeBoxHeightGlobal,
                      child: paddingBuyAndSellRateWidget(),
                    );
            }

            return setSizeWidget();
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (int rateModelListIndex = 0; rateModelListIndex < rateModelListAdminGlobal.length; rateModelListIndex++)
                rateWidget(rateModelListIndex: rateModelListIndex)
            ]),
          );
        }

        return Padding(padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)), child: scrollHorizontalWidget());
      }

      List<Widget> inWrapWidgetList() {
        Widget paddingRightBottomExchangeWidget({required int exchangeIndex}) {
          Widget exchangeWidget() {
            Function onTapToSelectFunction({required bool? isOnChangeOnGetMoney}) {
              void onTapToSelect() {
                onSelectExchangeSideMenuIndexGlobal = exchangeIndex;
                exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isChangeOnGetMoney = isOnChangeOnGetMoney;
                setState(() {});
              }

              return onTapToSelect;
            }

            final bool isSelected = (onSelectExchangeSideMenuIndexGlobal == exchangeIndex);
            Widget insideSizeBoxWidget() {
              Widget setSize() {
                void resetAllProfitToNull() {
                  for (int exchangeIndex = 0; exchangeIndex < exchangeTempSideMenuGlobal.exchangeList.length; exchangeIndex++) {
                    final bool isRateNotNull = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate != null);
                    if (isRateNotNull) {
                      exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.profit = null;
                    }
                  }
                }

                Widget totalWidget({required bool isGetMoney}) {
                  void onTapFunction() {
                    addActiveLogElement(
                      activeLogModelList: activeLogModelExchangeList,
                      activeLogModel: ActiveLogModel(
                        activeType: ActiveLogTypeEnum.clickButton,
                        locationList: [
                          Location(title: "exchange index", subtitle: exchangeIndex.toString()),
                          Location(title: "money", subtitle: isGetMoney ? "get money" : "give money"),
                          Location(color: ColorEnum.blue, title: "button name", subtitle: "total button"),
                        ],
                      ),
                    );
                    onTapToSelectFunction(isOnChangeOnGetMoney: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isChangeOnGetMoney)();
                    TextEditingController totalController = TextEditingController();
                    double leftNumber = 0;
                    final RateForCalculateModel rate = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!;
                    // final bool isBuyRate = rate.isBuyRate!;
                    final String moneyTypeStr = isGetMoney ? rate.rateType[rate.isBuyRate! ? 0 : 1] : rate.rateType[rate.isBuyRate! ? 1 : 0];
                    double getAndGiveNumber = 0;
                    for (int exchangeSubIndex = 0; exchangeSubIndex < exchangeTempSideMenuGlobal.exchangeList.length; exchangeSubIndex++) {
                      if (exchangeIndex != exchangeSubIndex) {
                        if (exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].rate != null) {
                          final RateForCalculateModel rateSub = exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].rate!;
                          if (isGetMoney) {
                            final String moneyTypeSub = (rateSub.isBuyRate! ? rateSub.rateType.first : rateSub.rateType.last);
                            if (moneyTypeSub == moneyTypeStr) {
                              if (exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].getMoney.text.isNotEmpty) {
                                getAndGiveNumber = getAndGiveNumber +
                                    textEditingControllerToDouble(controller: exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].getMoney)!;
                              }
                            }
                          } else {
                            final String moneyTypeSub = (rateSub.isBuyRate! ? rateSub.rateType.last : rateSub.rateType.first);
                            if (moneyTypeSub == moneyTypeStr) {
                              if (exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].giveMoney.text.isNotEmpty) {
                                getAndGiveNumber = getAndGiveNumber +
                                    textEditingControllerToDouble(controller: exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].giveMoney)!;
                              }
                            }
                          }
                        }
                      }
                    }

                    Widget contentWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                      Widget titleWidget() {
                        final String titleTotalStr = "Total ${isGetMoney ? "getting" : "giving"} money of ";
                        return Padding(
                          padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)),
                          child: Text("$titleTotalStr$moneyTypeStr", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
                        );
                      }

                      Widget confirmWidget() {
                        void onTapFromOutsiderFunction() {}

                        final String totalTemp = totalController.text;
                        void onChangeFromOutsiderFunction() {
                          final totalNumber = (totalController.text.isEmpty) ? 0 : textEditingControllerToDouble(controller: totalController)!;
                          leftNumber = (getAndGiveNumber - totalNumber).abs();

                          final String totalChangedTemp = totalController.text;
                          addActiveLogElement(
                            activeLogModelList: activeLogModelExchangeList,
                            activeLogModel: ActiveLogModel(
                              activeType: ActiveLogTypeEnum.typeTextfield,
                              locationList: [
                                Location(title: "exchange index", subtitle: exchangeIndex.toString()),
                                Location(title: "money", subtitle: isGetMoney ? "get money" : "give money"),
                                Location(
                                  color: (totalTemp.length < totalChangedTemp.length) ? ColorEnum.green : ColorEnum.red,
                                  title: "total textfield",
                                  subtitle: "${totalTemp.isEmpty ? "" : "$totalTemp to "}$totalChangedTemp",
                                ),
                              ],
                            ),
                          );

                          setStateFromDialog(() {});
                        }

                        return Padding(
                          padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal), top: paddingSizeGlobal(level: Level.normal)),
                          // child: Text(subtitleStr, style: textStyleGlobal(level: Level.normal)),
                          child: textFieldGlobal(
                            textFieldDataType: TextFieldDataType.double,
                            controller: totalController,
                            onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                            onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                            labelText: (isGetMoney ? getMoneyStrGlobal : giveMoneyStrGlobal),
                            level: Level.normal,
                          ),
                        );
                      }

                      Widget subtitleWidget() {
                        final String leftStr = formatAndLimitNumberTextGlobal(
                          valueStr: leftNumber.toString(),
                          isRound: false,
                          places: findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace! + (isFormatMoney ? 0 : 2),
                        );
                        return Padding(
                          padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                          child: scrollText(
                            alignment: Alignment.centerLeft,
                            textStr: "$getAndGiveNumber + $leftStr = ${(totalController.text.isEmpty) ? "0" : totalController.text}",
                            textStyle: textStyleGlobal(level: Level.normal),
                          ),
                        );
                      }

                      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleWidget(), subtitleWidget(), confirmWidget()]);
                    }

                    void okFunction() {
                      final String leftStr = formatAndLimitNumberTextGlobal(
                        valueStr: leftNumber.toString(),
                        isRound: false,
                        places: findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace! + (isFormatMoney ? 0 : 2),
                      );
                      if (isGetMoney) {
                        exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoney.text = leftStr;
                      } else {
                        exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoney.text = leftStr;
                      }
                      exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isChangeOnGetMoney = isGetMoney;
                      final bool isDiscountNotNull = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue.text.isNotEmpty;
                      if (isDiscountNotNull) {
                        final bool isBuyRate = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.isBuyRate!;
                        calculateFromRate(isCalculateOnBuyRate: isGetMoney, isBuyRate: isBuyRate);
                      }

                      resetAllProfitToNull();
                      closeDialogGlobal(context: context);

                      addActiveLogElement(
                        activeLogModelList: activeLogModelExchangeList,
                        activeLogModel: ActiveLogModel(
                          idTemp: "total dialog ok button, ${onSelectExchangeSideMenuIndexGlobal.toString()}, $isGetMoney",
                          activeType: ActiveLogTypeEnum.clickButton,
                          locationList: [
                            Location(title: "exchange index", subtitle: exchangeIndex.toString()),
                            Location(title: "money", subtitle: isGetMoney ? "get money" : "give money"),
                            Location(color: ColorEnum.blue, title: "button name", subtitle: "ok button"),
                          ],
                        ),
                      );
                      createOrClearAdditionMoney();
                      setState(() {});
                    }

                    void cancelFunctionOnTap() {
                      addActiveLogElement(
                        activeLogModelList: activeLogModelExchangeList,
                        activeLogModel: ActiveLogModel(
                          activeType: ActiveLogTypeEnum.clickButton,
                          locationList: [
                            Location(title: "exchange index", subtitle: exchangeIndex.toString()),
                            Location(title: "money", subtitle: isGetMoney ? "get money" : "give money"),
                            Location(color: ColorEnum.grey, title: "button name", subtitle: "cancel button"),
                          ],
                        ),
                      );
                      closeDialogGlobal(context: context);
                      setState(() {});
                    }

                    ValidButtonModel checkValidOk() {
                      if (totalController.text.isEmpty) {
                        // return false;
                        return ValidButtonModel(
                          isValid: false,
                          errorType: ErrorTypeEnum.valueOfNumber,
                          error: "total value is empty.",
                          errorLocationList: [
                            TitleAndSubtitleModel(title: "total value", subtitle: totalController.text),
                          ],
                        );
                      }
                      if (textEditingControllerToDouble(controller: totalController)! == 0) {
                        // return false;
                        return ValidButtonModel(
                          isValid: false,
                          errorType: ErrorTypeEnum.valueOfNumber,
                          error: "total value is 0.",
                          errorLocationList: [
                            TitleAndSubtitleModel(title: "total value", subtitle: totalController.text),
                          ],
                        );
                      }
                      if (textEditingControllerToDouble(controller: totalController)! <= getAndGiveNumber) {
                        return ValidButtonModel(
                          isValid: false,
                          errorType: ErrorTypeEnum.compareNumber,
                          overwriteRule: "total value must be less than total get and give money.",
                          error: "total value is not less than total get and give money.",
                          errorLocationList: [
                            TitleAndSubtitleModel(title: "total value", subtitle: totalController.text),
                            TitleAndSubtitleModel(
                              title: "total get and give money",
                              subtitle: formatAndLimitNumberTextGlobal(valueStr: getAndGiveNumber.toString(), isRound: false),
                            ),
                          ],
                          detailList: [
                            TitleAndSubtitleModel(
                              title: "${totalController.text} <= ${formatAndLimitNumberTextGlobal(valueStr: getAndGiveNumber.toString(), isRound: false)}",
                              subtitle: "invalid compare",
                            ),
                          ],
                        );
                      }
                      // return true;
                      return ValidButtonModel(isValid: true);
                    }

                    actionDialogSetStateGlobal(
                      dialogWidth: okSizeBoxWidthGlobal,
                      dialogHeight: okSizeBoxHeightGlobal * 1.5,
                      context: context,
                      okFunctionOnTap: okFunction,
                      cancelFunctionOnTap: cancelFunctionOnTap,
                      contentFunctionReturnWidget: contentWidget,
                      validOkButtonFunction: () => checkValidOk(),
                    );
                  }

                  ValidButtonModel isValidTotal() {
                    if (exchangeTempSideMenuGlobal.exchangeList.length <= 1) {
                      // return false;
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.compareNumber,
                        overwriteRule: "exchange element length must be more than 1.",
                        error: "exchange element length is ${exchangeTempSideMenuGlobal.exchangeList.length}.",
                      );
                    }
                    if (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate == null) {
                      // return false;
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.valueOfNumber,
                        error: "please select a rate above.",
                        errorLocationList: [
                          TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeIndex.toString()),
                        ],
                      );
                    }
                    if (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoney.text.isNotEmpty &&
                        exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoney.text.isNotEmpty) {
                      // return false;
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.compareNumber,
                        overwriteRule: "get money or give money must be empty.",
                        error: "get money and give money are not empty.",
                        errorLocationList: [
                          TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeIndex.toString()),
                          TitleAndSubtitleModel(title: "get money", subtitle: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoney.text),
                          TitleAndSubtitleModel(title: "give money", subtitle: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoney.text),
                        ],
                      );
                    }

                    for (int exchangeSubIndex = 0; exchangeSubIndex < exchangeTempSideMenuGlobal.exchangeList.length; exchangeSubIndex++) {
                      if (exchangeIndex != exchangeSubIndex) {
                        if (exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].getMoney.text.isEmpty) {
                          // return false;
                          return ValidButtonModel(
                            isValid: false,
                            errorType: ErrorTypeEnum.valueOfNumber,
                            error: "get money is empty.",
                            errorLocationList: [
                              TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeSubIndex.toString()),
                            ],
                          );
                        } else {
                          if (textEditingControllerToDouble(controller: exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].getMoney)! == 0) {
                            // return false;
                            return ValidButtonModel(
                              isValid: false,
                              errorType: ErrorTypeEnum.valueOfNumber,
                              error: "get money is 0.",
                              errorLocationList: [
                                TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeSubIndex.toString()),
                              ],
                            );
                          }
                        }
                        if (exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].giveMoney.text.isEmpty) {
                          // return false;
                          return ValidButtonModel(
                            isValid: false,
                            errorType: ErrorTypeEnum.valueOfNumber,
                            error: "give money is empty.",
                            errorLocationList: [
                              TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeSubIndex.toString()),
                            ],
                          );
                        } else {
                          if (textEditingControllerToDouble(controller: exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].giveMoney)! == 0) {
                            // return false;
                            return ValidButtonModel(
                              isValid: false,
                              errorType: ErrorTypeEnum.valueOfNumber,
                              error: "give money is 0.",
                              errorLocationList: [
                                TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeSubIndex.toString()),
                              ],
                            );
                          }
                        }
                      }
                    }
                    RateForCalculateModel rate = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!;
                    final String moneyTypeStr = isGetMoney ? rate.rateType[rate.isBuyRate! ? 0 : 1] : rate.rateType[rate.isBuyRate! ? 1 : 0];
                    int validValueCount = 0;
                    for (int exchangeSubIndex = 0; exchangeSubIndex < exchangeTempSideMenuGlobal.exchangeList.length; exchangeSubIndex++) {
                      if (exchangeIndex != exchangeSubIndex) {
                        if (exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].rate != null) {
                          final bool isBuyRate = exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].rate!.isBuyRate!;
                          if (isGetMoney) {
                            final String subMoneyTypeStr = exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].rate!.rateType[isBuyRate ? 0 : 1];
                            if (subMoneyTypeStr == moneyTypeStr) {
                              validValueCount++;
                            }
                          } else {
                            final String subMoneyTypeStr = exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].rate!.rateType[isBuyRate ? 1 : 0];
                            if (subMoneyTypeStr == moneyTypeStr) {
                              validValueCount++;
                            }
                          }

                          // final bool isBuyRate = exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].rate!.isBuyRate!;
                          // final String moneyTypeStr = exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].rate!.rateType[isBuyRate
                          //     ? isGetMoney
                          //         ? 0
                          //         : 1
                          //     : isGetMoney
                          //         ? 1
                          //         : 0];
                          // if (exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].rate != null) {
                          //   final RateForCalculateModel rateSub = exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].rate!;
                          //   final String moneyTypeSub = (rateSub.isBuyRate! ? rateSub.rateType.last : rateSub.rateType.first);
                          //   print("$moneyTypeSub == $moneyTypeStr => ${moneyTypeSub == moneyTypeStr}");
                          //   if (moneyTypeSub == moneyTypeStr) {
                          //     if (isGetMoney) {
                          //       // if (exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].getMoney.text.isNotEmpty) {
                          //       validValueCount++;
                          //       // }
                          //     } else {
                          //       // if (exchangeTempSideMenuGlobal.exchangeList[exchangeSubIndex].giveMoney.text.isNotEmpty) {
                          //       validValueCount++;
                          //       // }
                          //     }
                          //   }
                          // }
                        }
                      }
                    }
                    if (validValueCount <= 0) {
                      // return false;
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.compareNumber,
                        overwriteRule: "valid value count must be more than 0.",
                        error: "valid value count is $validValueCount.",
                        errorLocationList: [
                          TitleAndSubtitleModel(title: "exchange index", subtitle: exchangeIndex.toString()),
                          TitleAndSubtitleModel(title: "valid value count", subtitle: validValueCount.toString()),
                        ],
                      );
                    }
                    // return true;
                    return ValidButtonModel(isValid: true);
                  }

                  return Padding(
                    padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)),
                    child: totalButtonOrContainerWidget(level: Level.mini, validModel: isValidTotal(), onTapFunction: onTapFunction, context: context),
                  );
                }

                Widget getMoneyWidget() {
                  Widget getMoneyTextFieldWidget() {
                    final String getMoneyTemp = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoney.text;
                    void onChangeFromOutsiderFunction() {
                      resetAllProfitToNull();
                      void setGetMoneyToEmpty() {
                        exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoney.text = emptyStrGlobal;
                        // exchangeListTemp[exchangeIndex].isChangeOnGetMoney = null;
                      }

                      final bool isGetMoneyEmpty = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoney.text.isEmpty;
                      if (isGetMoneyEmpty) {
                        setGetMoneyToEmpty();
                      } else {
                        exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isChangeOnGetMoney = true;
                        final bool isRateNotNull = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate != null);
                        if (isRateNotNull) {
                          final bool isDiscountNotNull = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue.text.isNotEmpty;
                          if (isDiscountNotNull) {
                            final bool isBuyRate = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.isBuyRate!;
                            calculateFromRate(isCalculateOnBuyRate: true, isBuyRate: isBuyRate);
                          } else {
                            setGetMoneyToEmpty();
                          }
                        } else {
                          setGetMoneyToEmpty();
                        }
                      }
                      final String getMoneyChangedTemp = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoney.text;
                      addActiveLogElement(
                        activeLogModelList: activeLogModelExchangeList,
                        activeLogModel: ActiveLogModel(
                            idTemp: "get money textfield, ${exchangeIndex.toString()}",
                            activeType: ActiveLogTypeEnum.typeTextfield,
                            locationList: [
                              Location(title: "exchange index", subtitle: exchangeIndex.toString()),
                              Location(
                                color: (getMoneyTemp.length < getMoneyChangedTemp.length) ? ColorEnum.green : ColorEnum.red,
                                title: "get money textfield",
                                subtitle: "${getMoneyTemp.isEmpty ? "" : "$getMoneyTemp to "}$getMoneyChangedTemp",
                              ),
                            ]),
                      );
                      createOrClearAdditionMoney();
                      setState(() {});
                    }

                    String? suffixText;
                    final bool isRateNotNull = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate != null);

                    if (isRateNotNull) {
                      final bool isBuyRate = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.isBuyRate!;
                      final String rateTypeFirst = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.rateType.first;
                      final String rateTypeLast = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.rateType.last;
                      suffixText = isBuyRate ? rateTypeFirst : rateTypeLast;
                    }

                    return textFieldGlobal(
                      isEnabled: isSelected,
                      suffixText: suffixText,
                      focusNode: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoneyFocusNode,
                      textFieldDataType: TextFieldDataType.double,
                      controller: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoney,
                      onTapFromOutsiderFunction:
                          onTapToSelectFunction(isOnChangeOnGetMoney: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isChangeOnGetMoney ?? true),
                      onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                      labelText: getMoneyStrGlobal,
                      level: Level.normal,
                    );
                  }

                  return Column(children: [getMoneyTextFieldWidget(), totalWidget(isGetMoney: true)]);
                }

                Widget rateWidget() {
                  List<String> menuItemStrList = [];
                  String? selectedStr;
                  final bool isRateNotNull = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate != null);
                  final RateForCalculateModel? rate = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate;
                  String rateStr = "";
                  if (isRateNotNull) {
                    rateStr = rate!.isBuyRate! ? "${rate.rateType.first} -> ${rate.rateType.last}" : "${rate.rateType.last} -> ${rate.rateType.first}";
                    final bool isNotSelectedOtherRate = !exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isSelectedOtherRate;
                    if (isNotSelectedOtherRate) {
                      selectedStr = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue.text;
                      final String valueStr = formatAndLimitNumberTextGlobal(
                          valueStr: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.value.toString(), isRound: false, isAllowZeroAtLast: false);
                      menuItemStrList.add(valueStr);
                    }

                    if (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.isBuyRate!) {
                      menuItemStrList.addAll(List<String>.from(
                          rateModelListAdminGlobal[exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].selectedRateIndex]
                              .buy!
                              .discountOptionList
                              .map((x) => x.text)));
                    } else {
                      menuItemStrList.addAll(List<String>.from(
                          rateModelListAdminGlobal[exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].selectedRateIndex]
                              .sell!
                              .discountOptionList
                              .map((x) => x.text)));
                    }
                  }

                  void calculateRate() {
                    final bool? isOnChangeOnGetMoney = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isChangeOnGetMoney;
                    final bool isRateNotNull = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate != null);
                    void setEqualEmptyToTextField() {
                      final bool isisOnChangeOnGetMoneyNotNull = (isOnChangeOnGetMoney != null);
                      if (isisOnChangeOnGetMoneyNotNull) {
                        if (isOnChangeOnGetMoney) {
                          exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoney.text = emptyStrGlobal;
                        } else {
                          exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoney.text = emptyStrGlobal;
                        }
                      }
                    }

                    if (isRateNotNull) {
                      final bool isDiscountNotNull = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue.text.isNotEmpty;
                      if (isDiscountNotNull) {
                        final bool isBuyRate = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.isBuyRate!;
                        calculateFromRate(isCalculateOnBuyRate: isOnChangeOnGetMoney, isBuyRate: isBuyRate);
                      } else {
                        setEqualEmptyToTextField();
                      }
                    } else {
                      setEqualEmptyToTextField();
                    }
                  }

                  final String discountValueTemp = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate == null)
                      ? ""
                      : exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue.text;
                  void onChangedDropDrownFunction({required String value, required int index}) {
                    resetAllProfitToNull();
                    final bool isSelectedOtherRate = (value == otherStrGlobal);
                    exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isSelectedOtherRate = isSelectedOtherRate;
                    String discountValueChangedTemp = "other";
                    if (!isSelectedOtherRate) {
                      exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue.text = value;
                      discountValueChangedTemp = value;
                    }
                    calculateRate();

                    addActiveLogElement(
                      isDropdownFromDropdownOrTextfield: true,
                      activeLogModelList: activeLogModelExchangeList,
                      activeLogModel: ActiveLogModel(
                        idTemp: "rate dropdown or textfield, ${exchangeIndex.toString()}",
                        activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                        locationList: [
                          Location(title: "exchange index", subtitle: exchangeIndex.toString()),
                          Location(title: "rate", subtitle: rateStr),
                          Location(title: "rate dropdown", subtitle: "${discountValueTemp.isEmpty ? "" : "$discountValueTemp to "}$discountValueChangedTemp"),
                        ],
                      ),
                    );
                    createOrClearAdditionMoney();
                    setState(() {});
                  }

                  void onChangedTextFieldFunction() {
                    resetAllProfitToNull();
                    calculateRate();
                    final String discountValueChangedTemp = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue.text;
                    addActiveLogElement(
                      activeLogModelList: activeLogModelExchangeList,
                      activeLogModel: ActiveLogModel(
                        idTemp: "rate dropdown or textfield, ${exchangeIndex.toString()}",
                        activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                        locationList: [
                          Location(title: "exchange index", subtitle: exchangeIndex.toString()),
                          Location(title: "rate", subtitle: rateStr),
                          Location(
                            color: (discountValueTemp.length < discountValueChangedTemp.length) ? ColorEnum.green : ColorEnum.red,
                            title: "rate textfield",
                            subtitle: "${discountValueTemp.isEmpty ? "" : "$discountValueTemp to "}$discountValueChangedTemp",
                          ),
                        ],
                      ),
                    );
                    createOrClearAdditionMoney();
                    setState(() {});
                  }

                  void onDeleteFunction() {
                    resetAllProfitToNull();
                    exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isSelectedOtherRate = false;
                    exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate = null;

                    calculateRate();
                    addActiveLogElement(
                      activeLogModelList: activeLogModelExchangeList,
                      activeLogModel: ActiveLogModel(
                        idTemp: "rate dropdown or textfield, ${exchangeIndex.toString()}",
                        activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                        locationList: [
                          Location(title: "exchange index", subtitle: exchangeIndex.toString()),
                          Location(title: "rate", subtitle: rateStr),
                          Location(color: ColorEnum.red, title: "rate dropdown or textfield", subtitle: "click delete rate button"),
                        ],
                      ),
                    );
                    setState(() {});
                  }

                  TextEditingController? controllerProvider() {
                    return (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate == null)
                        ? null
                        : exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue;
                  }

                  return DropDownAndTextFieldProviderGlobal(
                    level: Level.normal,
                    labelStr: rateStrGlobal,
                    onTapFunction: onTapToSelectFunction(isOnChangeOnGetMoney: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isChangeOnGetMoney),
                    onChangedDropDrownFunction: onChangedDropDrownFunction,
                    selectedStr: selectedStr,
                    menuItemStrList: menuItemStrList,
                    controller: controllerProvider(),
                    textFieldDataType: TextFieldDataType.double,
                    isEnabled: (isRateNotNull && isSelected),
                    isShowTextField: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isSelectedOtherRate,
                    onDeleteFunction: onDeleteFunction,
                    onChangedTextFieldFunction: onChangedTextFieldFunction,
                  );
                }

                Widget giveMoneyWidget() {
                  Widget giveTextFieldWidget() {
                    final String giveMoneyTemp = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoney.text;
                    void onChangeFromOutsiderFunction() {
                      resetAllProfitToNull();
                      void setGetMoneyToEmpty() {
                        exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].getMoney.text = emptyStrGlobal;
                        // exchangeListTemp[exchangeIndex].isChangeOnGetMoney = null;
                      }

                      final bool isGiveMoneyEmpty = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoney.text.isEmpty;
                      if (isGiveMoneyEmpty) {
                        setGetMoneyToEmpty();
                      } else {
                        exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isChangeOnGetMoney = false;
                        final bool isRateNotNull = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate != null);
                        if (isRateNotNull) {
                          final bool isDiscountNotNull = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.discountValue.text.isNotEmpty;
                          if (isDiscountNotNull) {
                            final bool isBuyRate = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.isBuyRate!;
                            calculateFromRate(isCalculateOnBuyRate: false, isBuyRate: isBuyRate);
                          } else {
                            setGetMoneyToEmpty();
                          }
                        } else {
                          setGetMoneyToEmpty();
                        }
                      }
                      final String giveMoneyChangedTemp = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoney.text;
                      addActiveLogElement(
                        activeLogModelList: activeLogModelExchangeList,
                        activeLogModel: ActiveLogModel(
                            idTemp: "give money textfield, ${exchangeIndex.toString()}",
                            activeType: ActiveLogTypeEnum.typeTextfield,
                            locationList: [
                              Location(title: "exchange index", subtitle: exchangeIndex.toString()),
                              Location(
                                color: (giveMoneyTemp.length < giveMoneyChangedTemp.length) ? ColorEnum.green : ColorEnum.red,
                                title: "give money textfield",
                                subtitle: "${giveMoneyTemp.isEmpty ? "" : "$giveMoneyTemp to "}$giveMoneyChangedTemp",
                              ),
                            ]),
                      );
                      createOrClearAdditionMoney();
                      setState(() {});
                    }

                    String? suffixText;
                    final bool isRateNotNull = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate != null);
                    if (isRateNotNull) {
                      final bool isBuyRate = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.isBuyRate!;
                      final String rateTypeFirst = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.rateType.first;
                      final String rateTypeLast = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.rateType.last;
                      suffixText = isBuyRate ? rateTypeLast : rateTypeFirst;
                    }
                    return textFieldGlobal(
                      isEnabled: isSelected,
                      suffixText: suffixText,
                      focusNode: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoneyFocusNode,
                      textFieldDataType: TextFieldDataType.double,
                      controller: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].giveMoney,
                      onTapFromOutsiderFunction:
                          onTapToSelectFunction(isOnChangeOnGetMoney: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isChangeOnGetMoney ?? false),
                      onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                      labelText: giveMoneyStrGlobal,
                      level: Level.normal,
                    );
                  }

                  return Column(children: [giveTextFieldWidget(), totalWidget(isGetMoney: false)]);
                }

                Widget textStr({required String str}) {
                  return Text(str, style: textStyleGlobal(level: Level.large));
                }

                String operatorProvider() {
                  if (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate != null) {
                    return exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.isBuyRate! ? multiplyNumberStrGlobal : divideNumberStrGlobal;
                  }
                  return emptyStrGlobal;
                }

                Widget paddingRightAndTopWidget({required Widget widget}) {
                  return Padding(
                    padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal), top: paddingSizeGlobal(level: Level.normal)),
                    child: widget,
                  );
                }

                Widget paddingBottomTextWidget() {
                  Widget textAndDeleteWidget() {
                    Widget deleteButtonWidget() {
                      final bool isMoreThanOne = (exchangeTempSideMenuGlobal.exchangeList.length > 1);
                      void onTapFunction() {
                        final RateForCalculateModel? rate = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate;
                        String rateType = "";
                        if (rate != null) {
                          rateType = rate.isBuyRate!
                              ? "buy rate (${rate.rateType.first} -> ${rate.rateType.last})"
                              : "sell rate (${rate.rateType.last} -> ${rate.rateType.first})";
                        }
                        exchangeTempSideMenuGlobal.exchangeList.removeAt(exchangeIndex);
                        onSelectExchangeSideMenuIndexGlobal = 0;

                        addActiveLogElement(
                          activeLogModelList: activeLogModelExchangeList,
                          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
                            Location(title: "exchange index", subtitle: exchangeIndex.toString()),
                            Location(title: "exchange rate", subtitle: rateType),
                            Location(color: ColorEnum.red, title: "button name", subtitle: "delete button"),
                          ]),
                        );
                        createOrClearAdditionMoney();
                        setState(() {});
                      }

                      return deleteButtonOrContainerWidget(
                        context: context,
                        level: Level.mini,
                        onTapFunction: onTapFunction,
                        validModel: ValidButtonModel(
                          isValid: isMoreThanOne,
                          overwriteRule: "exchange element length must be more than 1.",
                          error: "exchange element length is ${exchangeTempSideMenuGlobal.exchangeList.length}",
                          errorType: ErrorTypeEnum.compareNumber,
                        ),
                      );
                    }

                    Widget paddingRightTextWidget() {
                      Widget textWidget() {
                        String rateOrEmptyStr = emptyStrGlobal;
                        final bool isRateNotNull = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate != null);
                        if (isRateNotNull) {
                          final bool isBuyRate = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.isBuyRate!;
                          final String rateTypeFirst = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.rateType.first;
                          final String rateTypeLast = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.rateType.last;
                          rateOrEmptyStr = isBuyRate ? "$rateTypeFirst$arrowStrGlobal$rateTypeLast" : "$rateTypeLast$arrowStrGlobal$rateTypeFirst";
                        }
                        return Text(rateOrEmptyStr, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold));
                      }

                      final bool isRateNotNull = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate != null);
                      return isRateNotNull
                          ? Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)), child: textWidget())
                          : textWidget();
                    }

                    return Row(children: [paddingRightTextWidget(), deleteButtonWidget()]);
                  }

                  return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)), child: textAndDeleteWidget());
                }

                Widget profitTextOrContainerWidget() {
                  bool isNotHasProfit = false;
                  final bool isRateNotNull = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate != null);
                  if (isRateNotNull) {
                    final bool isProfitNotNull = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.profit != null);
                    if (isProfitNotNull) {
                      isNotHasProfit = true;
                    }
                  }
                  if (isNotHasProfit) {
                    final String moneyTypeProfitAndTotalStr = exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.rateType.last;
                    final int place = findMoneyModelByMoneyType(moneyType: moneyTypeProfitAndTotalStr).decimalPlace!;
                    final String profitStr = formatAndLimitNumberTextGlobal(
                      valueStr: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.profit.toString(),
                      isRound: false,
                      places: ((place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0) +
                          (isFormatMoney ? 0 : 2),
                      isAllowZeroAtLast: false,
                    );
                    final bool isPositive = (exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].rate!.profit! >= 0);
                    return Padding(
                      padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.large)),
                      child: Row(
                        children: [
                          Text("$profitStrGlobal: ", style: textStyleGlobal(level: Level.mini)),
                          Text(
                            "$profitStr $moneyTypeProfitAndTotalStr",
                            style: textStyleGlobal(level: Level.mini, color: isPositive ? positiveColorGlobal : negativeColorGlobal),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                }

                return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                  paddingBottomTextWidget(),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 3, child: paddingRightAndTopWidget(widget: getMoneyWidget())),
                    Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal) * 1.5), child: textStr(str: operatorProvider())),
                    Expanded(flex: 2, child: rateWidget()),
                    Padding(
                      padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal), top: paddingSizeGlobal(level: Level.normal) * 1.5),
                      child: textStr(str: equalStrGlobal),
                    ),
                    Expanded(flex: 3, child: Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)), child: giveMoneyWidget())),
                  ]),
                  profitTextOrContainerWidget(),
                ]);
              }

              return setSize();
            }

            return CustomButtonGlobal(
              sizeBoxWidth: dialogSizeGlobal(level: Level.mini),
              isDisable: isSelected,
              insideSizeBoxWidget: insideSizeBoxWidget(),
              onTapUnlessDisable: onTapToSelectFunction(isOnChangeOnGetMoney: exchangeTempSideMenuGlobal.exchangeList[exchangeIndex].isChangeOnGetMoney),
            );
          }

          return Padding(
            padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini), bottom: paddingSizeGlobal(level: Level.mini)),
            child: exchangeWidget(),
          );
        }

        Widget remarkTextFieldWidget() {
          Widget remarkWidget() {
            void onTapFromOutsiderFunction() {}
            final String remarkTemp = exchangeTempSideMenuGlobal.remark.text;
            void onChangeFromOutsiderFunction() {
              final String remarkChangedTemp = exchangeTempSideMenuGlobal.remark.text;
              addActiveLogElement(
                activeLogModelList: activeLogModelExchangeList,
                activeLogModel: ActiveLogModel(idTemp: "remark textfield", activeType: ActiveLogTypeEnum.typeTextfield, locationList: [
                  Location(
                    color: (remarkTemp.length < remarkChangedTemp.length) ? ColorEnum.green : ColorEnum.red,
                    title: "remark textfield",
                    subtitle: "${remarkTemp.isEmpty ? "" : "$remarkTemp to "}$remarkChangedTemp",
                  ),
                ]),
              );
              setState(() {});
            }

            return Padding(
              padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)),
              child: textAreaGlobal(
                controller: exchangeTempSideMenuGlobal.remark,
                onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                labelText: remarkOptionalStrGlobal,
                level: Level.normal,
              ),
            );
          }

          Widget moreMoneyWidget({required int addIndex}) {
            void onTapFromOutsiderFunction() {}
            final String addMoneyTemp = additionMoneyModelListGlobal[addIndex].addMoney.text;
            void onChangeFromOutsiderFunction() {
              exchangeTempSideMenuGlobal.remark.text = "";
              if (isValidExchange().isValid) {
                // List<MoneyTypeAndValueModel> getFromCustomerMoneyList = [];
                List<MoneyTypeAndValueModel> giveToCustomerMoneyList = [];
                exchangeToMerge(
                  exchangeMoneyModel: exchangeTempSideMenuGlobal,
                  getFromCustomerMoneyList: [],
                  giveToCustomerMoneyList: giveToCustomerMoneyList,
                  profitList: [],
                );
                for (int addIndex = 0; addIndex < additionMoneyModelListGlobal.length; addIndex++) {
                  if (additionMoneyModelListGlobal[addIndex].addMoney.text.isNotEmpty) {
                    // giveToCustomerMoneyList.add(MoneyTypeAndValueModel(
                    //   moneyType: additionMoneyModelListGlobal[addIndex].moneyType,
                    //   value: textEditingControllerToDouble(controller: additionMoneyModelListGlobal[addIndex].addMoney)!,
                    // ));
                    for (int mergeIndex = 0; mergeIndex < giveToCustomerMoneyList.length; mergeIndex++) {
                      if (giveToCustomerMoneyList[mergeIndex].moneyType == additionMoneyModelListGlobal[addIndex].moneyType) {
                        // giveToCustomerMoneyList[mergeIndex].value = giveToCustomerMoneyList[mergeIndex].value + textEditingControllerToDouble(controller: additionMoneyModelListGlobal[addIndex].addMoney)!;
                        final String addMoneyStr = additionMoneyModelListGlobal[addIndex].addMoney.text;
                        final String mergeMoneyStr = formatAndLimitNumberTextGlobal(
                          valueStr: giveToCustomerMoneyList[mergeIndex].value.toString(),
                          isRound: false,
                        );
                        final double sumNumber = giveToCustomerMoneyList[mergeIndex].value +
                            textEditingControllerToDouble(controller: additionMoneyModelListGlobal[addIndex].addMoney)!;
                        final String sumStr = formatAndLimitNumberTextGlobal(valueStr: sumNumber.toString(), isRound: false);
                        final String moneyTypeStr = additionMoneyModelListGlobal[addIndex].moneyType;
                        exchangeTempSideMenuGlobal.remark.text += "\n   ($moneyTypeStr): $mergeMoneyStr + $addMoneyStr = $sumStr \n";
                        break;
                      }
                    }
                  }
                }
              }
              final String addMoneyChangedTemp = additionMoneyModelListGlobal[addIndex].addMoney.text;
              addActiveLogElement(
                activeLogModelList: activeLogModelExchangeList,
                activeLogModel: ActiveLogModel(idTemp: "add money textfield", activeType: ActiveLogTypeEnum.typeTextfield, locationList: [
                  Location(
                    color: (addMoneyTemp.length < addMoneyChangedTemp.length) ? ColorEnum.green : ColorEnum.red,
                    title: "add money textfield",
                    subtitle: "${addMoneyTemp.isEmpty ? "" : "$addMoneyTemp to "}$addMoneyChangedTemp",
                  ),
                ]),
              );
              setState(() {});
            }

            return Padding(
              padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)),
              child: Row(children: [
                Text("More ${additionMoneyModelListGlobal[addIndex].moneyType} | ", style: textStyleGlobal(level: Level.normal)),
                Expanded(
                  child: textFieldGlobal(
                    controller: additionMoneyModelListGlobal[addIndex].addMoney,
                    onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                    onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                    labelText: "amount of ${additionMoneyModelListGlobal[addIndex].moneyType} (optional)",
                    level: Level.mini,
                    textFieldDataType: TextFieldDataType.double,
                  ),
                ),
              ]),
            );
          }

          void onTapFromOutsiderFunction() {}
          return Padding(
            padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini), bottom: paddingSizeGlobal(level: Level.mini)),
            child: CustomButtonGlobal(
              sizeBoxWidth: dialogSizeGlobal(level: Level.mini),
              insideSizeBoxWidget: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                for (int addIndex = 0; addIndex < additionMoneyModelListGlobal.length; addIndex++) moreMoneyWidget(addIndex: addIndex),
                remarkWidget(),
              ]),
              onTapUnlessDisable: onTapFromOutsiderFunction,
            ),
          );

          // return
        }

        Widget customInvoiceWidget() {
          if (isValidExchange().isValid) {
            List<MoneyTypeAndValueModel> getFromCustomerMoneyList = [];
            List<MoneyTypeAndValueModel> giveToCustomerMoneyList = [];
            exchangeToMerge(
              exchangeMoneyModel: exchangeTempSideMenuGlobal,
              getFromCustomerMoneyList: getFromCustomerMoneyList,
              giveToCustomerMoneyList: giveToCustomerMoneyList,
              profitList: [],
            );
            return customInvoiceWidgetGlobal(
              context: context,
              isForceShowNoEffect: false,
              isAdminEditing: false,
              remark: exchangeTempSideMenuGlobal.remark.text,
              // dateOld: widget.exchangeMoneyModel!.dateOld,
              date: DateTime.now(),
              invoiceTypeStr: exchangeTitleGlobal,
              getFromCustomerMoneyList: getFromCustomerMoneyList,
              giveToCustomerMoneyList: giveToCustomerMoneyList,
              profitList: [],
              getFromCustomerCardList: [],
              giveToCustomerCardList: [],
              invoiceIdStr: "",
              moneyTotalList: [],
              cardTotalList: [],
              // isHovering: isHoveringOutsider,
              // onDeleteFunction: widget.isCurrentDate ? onDeleteFunction : null,
              // onPrintFunction: onPrintFunction,
              customHoverFunction: ({required bool isHovering}) {},
              onTapUnlessDisable: () {},
              isDelete: false,
              // overwriteId: widget.exchangeMoneyModel!.overwriteOnId,
              index: -1,
            );
          } else {
            return Container();
          }
        }

        return [
          for (int exchangeIndex = 0; exchangeIndex < exchangeTempSideMenuGlobal.exchangeList.length; exchangeIndex++)
            paddingRightBottomExchangeWidget(exchangeIndex: exchangeIndex),
          customInvoiceWidget(),
          remarkTextFieldWidget(),
        ];
      }

      void addOnTapFunction() {
        exchangeTempSideMenuGlobal.exchangeList.add(
          ExchangeListExchangeMoneyModel(
            getMoney: TextEditingController(),
            getMoneyFocusNode: FocusNode(),
            giveMoney: TextEditingController(),
            giveMoneyFocusNode: FocusNode(),
          ),
        );

        onSelectExchangeSideMenuIndexGlobal = exchangeTempSideMenuGlobal.exchangeList.length - 1;

        addActiveLogElement(
          activeLogModelList: activeLogModelExchangeList,
          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.green, title: "button name", subtitle: "add button"),
          ]),
        );
        createOrClearAdditionMoney();
        setState(() {});
      }

      void updateExchangeToDBOrPrint({required isPrint}) {
        void callBack() {
          onSelectExchangeSideMenuIndexGlobal = 0;
          additionMoneyModelListGlobal = [];
          exchangeTempSideMenuGlobal = ExchangeMoneyModel(
            activeLogModelList: [],
            exchangeList: [
              ExchangeListExchangeMoneyModel(
                getMoney: TextEditingController(),
                getMoneyFocusNode: FocusNode(),
                giveMoney: TextEditingController(),
                giveMoneyFocusNode: FocusNode(),
              ),
            ],
            remark: TextEditingController(),
          );
          if (isPrint) {
            printExchangeMoneyInvoice(exchangeModel: exchangeModelListEmployeeGlobal.first, context: context);
          }
          // setState(() {});
          isFormatMoney = true;
          activeLogModelExchangeList = [];
          widget.callback();
        }

        exchangeCheckForFinalEdition(activeLogModelList: activeLogModelExchangeList, exchangeList: exchangeTempSideMenuGlobal.exchangeList);

        setFinalEditionActiveLog(activeLogModelList: activeLogModelExchangeList);
        exchangeTempSideMenuGlobal.activeLogModelList = activeLogModelExchangeList;
        updateExchangeGlobal(callBack: callBack, context: context, exchangeTemp: exchangeTempSideMenuGlobal);
      }

      void saveOnTapFunction() {
        addActiveLogElement(
          activeLogModelList: activeLogModelExchangeList,
          activeLogModel: ActiveLogModel(idTemp: "save or save and print button", activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "save button"),
          ]),
        );

        updateExchangeToDBOrPrint(isPrint: false);
      }

      void analysisOnTapFunction() {
        addActiveLogElement(
          activeLogModelList: activeLogModelExchangeList,
          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "analysis button"),
          ]),
        );
        void callBack() {
          isAllowAnalysis = false;
          Future.delayed(const Duration(seconds: delayApiRequestSecond), () {
            isAllowAnalysis = true;
            if (mounted) {
              setState(() {});
            }
          });
          setState(() {});
        }

        setExchangeAnalysisGlobal(callBack: callBack, context: context, exchangeTemp: exchangeTempSideMenuGlobal);
      }

      void saveAndPrintOnTapFunction() {
        addActiveLogElement(
          activeLogModelList: activeLogModelExchangeList,
          activeLogModel: ActiveLogModel(idTemp: "save or save and print button", activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "save and print button"),
          ]),
        );
        updateExchangeToDBOrPrint(isPrint: true);
      }

      void historyOnTapFunction() {
        addActiveLogElement(
          activeLogModelList: activeLogModelExchangeList,
          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "history button"),
          ]),
        );
        limitHistory();
        void cancelFunctionOnTap() {
          closeDialogGlobal(context: context);
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
                children: [Text(exchangeHistoryStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))],
              ),
            );
          }

          Widget exchangeHistoryListWidget() {
            List<Widget> inWrapWidgetList() {
              return [
                for (int exchangeIndex = 0; exchangeIndex < exchangeModelListEmployeeGlobal.length; exchangeIndex++)
                  HistoryElement(
                    isForceShowNoEffect: false,
                    isAdminEditing: false,
                    index: exchangeIndex,
                    exchangeMoneyModel: exchangeModelListEmployeeGlobal[exchangeIndex],
                    setStateOutsider: setStateOutsider,
                  )
              ];
            }

            void topFunction() {}
            void bottomFunction() {
              if (!outOfDataQueryExchangeListGlobal) {
                final int beforeQuery = exchangeModelListEmployeeGlobal.length;
                void callBack() {
                  final int afterQuery = exchangeModelListEmployeeGlobal.length;

                  if (beforeQuery == afterQuery) {
                    outOfDataQueryExchangeListGlobal = true;
                  } else {
                    skipExchangeListGlobal = skipExchangeListGlobal + queryLimitNumberGlobal;
                  }
                  setStateFromDialog(() {});
                }

                getExchangeListEmployeeGlobal(
                  employeeId: profileModelEmployeeGlobal!.id!,
                  callBack: callBack,
                  context: context,
                  skip: skipExchangeListGlobal,
                  targetDate: DateTime.now(),
                  exchangeModelListEmployee: exchangeModelListEmployeeGlobal,
                );
              }
            }

            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: !outOfDataQueryExchangeListGlobal,
            );
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleTextWidget(), Expanded(child: exchangeHistoryListWidget())]);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini),
          dialogWidth: dialogSizeGlobal(level: Level.mini),
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      void clearFunction() {
        isFormatMoney = true;
        onSelectExchangeSideMenuIndexGlobal = 0;
        exchangeTempSideMenuGlobal = ExchangeMoneyModel(
          activeLogModelList: [],
          exchangeList: [
            ExchangeListExchangeMoneyModel(
              getMoney: TextEditingController(),
              getMoneyFocusNode: FocusNode(),
              giveMoney: TextEditingController(),
              giveMoneyFocusNode: FocusNode(),
            ),
          ],
          remark: TextEditingController(),
        );
        addActiveLogElement(
          activeLogModelList: activeLogModelExchangeList,
          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.red, title: "button name", subtitle: "clear button"),
          ]),
        );
        createOrClearAdditionMoney();
        setState(() {});
      }

      void formatToggleFunction() {
        isFormatMoney = !isFormatMoney;
        onSelectExchangeSideMenuIndexGlobal = 0;
        exchangeTempSideMenuGlobal = ExchangeMoneyModel(
          activeLogModelList: [],
          exchangeList: [
            ExchangeListExchangeMoneyModel(
              getMoney: TextEditingController(),
              getMoneyFocusNode: FocusNode(),
              giveMoney: TextEditingController(),
              giveMoneyFocusNode: FocusNode(),
            ),
          ],
          remark: TextEditingController(),
        );
        addActiveLogElement(
          activeLogModelList: activeLogModelExchangeList,
          activeLogModel: ActiveLogModel(idTemp: "toggle button name", activeType: ActiveLogTypeEnum.selectToggle, locationList: [
            Location(color: ColorEnum.blue, title: "toggle button name", subtitle: isFormatMoney ? "accurate to format" : "format to accurate"),
          ]),
        );
        createOrClearAdditionMoney();
        setState(() {});
      }

      return BodyTemplateSideMenu(
        title: widget.title,
        isValidAddOnTap: isValidExchange(),
        isValidSaveOnTap: isValidExchange(),
        isValidSaveAndPrintOnTap: isValidExchange(),
        isValidAnalysisOnTap: isValidExchange(),
        addOnTapFunction: addOnTapFunction,
        customBetweenHeaderAndBodyWidget: customBetweenHeaderAndBodyWidget(),
        inWrapWidgetList: inWrapWidgetList(),
        saveOnTapFunction: saveOnTapFunction,
        saveAndPrintOnTapFunction: saveAndPrintOnTapFunction,
        analysisOnTapFunction: analysisOnTapFunction,
        historyOnTapFunction: historyOnTapFunction,
        clearFunction: clearFunction,
        currentAddButtonQty: exchangeTempSideMenuGlobal.exchangeList.length,
        maxAddButtonLimit: exchangeInvoiceAddButtonLimitGlobal,
        formatToggleFunction: formatToggleFunction,
        isFormatToggle: isFormatMoney,
      );
    }

    // return _isLoadingOnInitExchange ? Container() : bodyTemplateSideMenu();
    return bodyTemplateSideMenu();
  }
}
