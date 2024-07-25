// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/active_log.dart';
import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/card.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/drop_down_and_text_field_provider.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/rate.dart';
import 'package:business_receipt/env/function/request_api/card_request_api_env.dart';
import 'package:business_receipt/env/function/text/text_area_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/toggle_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/active_log.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/employee_model/card/sell_card_model.dart';
import 'package:business_receipt/model/employee_model/exchange_money_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class AddCardStockEmployeeSideMenu extends StatefulWidget {
  String title;
  Function callback;
  AddCardStockEmployeeSideMenu({Key? key, required this.title, required this.callback}) : super(key: key);

  @override
  State<AddCardStockEmployeeSideMenu> createState() => _AddCardStockEmployeeSideMenuState();
}

class _AddCardStockEmployeeSideMenuState extends State<AddCardStockEmployeeSideMenu> {
  // bool _isLoadingOnInitCard = true;
  // bool isShowPrevious = false;
  String? companyNameStr;
  String? categoryStr;
  bool isOtherMainStock = false;
  List<String> menuItemStrList = [];
  List<ActiveLogModel> activeLogModelAddMCardStockList = [];
  CardMainPriceListCardModel cardMainPriceListCardModelTemp = CardMainPriceListCardModel(
    activeLogModelList: [],
    price: TextEditingController(),
    stock: TextEditingController(),
    rateList: [],
    remark: TextEditingController(),
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      ValidButtonModel isValidCard() {
        final bool isMoneyTypeNull = (cardMainPriceListCardModelTemp.moneyType == null && cardMainPriceListCardModelTemp.moneyType == "");
        if (isMoneyTypeNull) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfString,
            errorLocationList: [TitleAndSubtitleModel(title: "money type", subtitle: cardMainPriceListCardModelTemp.moneyType ?? "")],
            error: "money is empty",
          );
        }
        final bool isPriceEmpty = cardMainPriceListCardModelTemp.price.text.isEmpty;
        if (isPriceEmpty) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfNumber,
            errorLocationList: [TitleAndSubtitleModel(title: "price", subtitle: cardMainPriceListCardModelTemp.price.text)],
            error: "price is empty",
          );
        } else {
          final bool isPriceEqual0 = (textEditingControllerToDouble(controller: cardMainPriceListCardModelTemp.price) == 0);
          if (isPriceEqual0) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              errorLocationList: [TitleAndSubtitleModel(title: "price", subtitle: cardMainPriceListCardModelTemp.price.text)],
              error: "price equal 0",
            );
          }
        }

        final bool isStockEmpty = cardMainPriceListCardModelTemp.stock.text.isEmpty;
        if (isStockEmpty) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfNumber,
            errorLocationList: [TitleAndSubtitleModel(title: "stock", subtitle: cardMainPriceListCardModelTemp.stock.text)],
            error: "stock is empty",
          );
        } else {
          final bool isStockEqual0 = (textEditingControllerToDouble(controller: cardMainPriceListCardModelTemp.stock) == 0);
          if (isStockEqual0) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              errorLocationList: [TitleAndSubtitleModel(title: "stock", subtitle: cardMainPriceListCardModelTemp.stock.text)],
              error: "stock equal 0",
            );
          }
        }

        for (int rateIndex = 0; rateIndex < cardMainPriceListCardModelTemp.rateList.length; rateIndex++) {
          final bool isRateIdNull = (cardMainPriceListCardModelTemp.rateList[rateIndex].rateId == null);
          final bool isDiscountEmpty = cardMainPriceListCardModelTemp.rateList[rateIndex].discountValue.text.isEmpty;
          final bool isPercentageEmpty = cardMainPriceListCardModelTemp.rateList[rateIndex].percentage.text.isEmpty;
          // if (isRateIdNull || isDiscountEmpty || isPercentageEmpty) {
          //   // return false;
          // }

          if (isRateIdNull) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfString,
              errorLocationList: [
                TitleAndSubtitleModel(title: "rate index", subtitle: rateIndex.toString()),
                TitleAndSubtitleModel(title: "rate id", subtitle: cardMainPriceListCardModelTemp.rateList[rateIndex].rateId ?? ""),
              ],
              error: "please select rate",
            );
          }
          if (isDiscountEmpty) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              errorLocationList: [
                TitleAndSubtitleModel(title: "rate index", subtitle: rateIndex.toString()),
                TitleAndSubtitleModel(title: "discount value", subtitle: cardMainPriceListCardModelTemp.rateList[rateIndex].discountValue.text),
              ],
              error: "discount value is empty",
            );
          }
          if (isPercentageEmpty) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              errorLocationList: [
                TitleAndSubtitleModel(title: "rate index", subtitle: rateIndex.toString()),
                TitleAndSubtitleModel(title: "percentage", subtitle: cardMainPriceListCardModelTemp.rateList[rateIndex].percentage.text),
              ],
              error: "percentage is empty",
            );
          }
        }

        // final bool isLowerCardStock = checkLowerTheExistCard(
        //   companyNameStr: companyNameStr!,
        //   categoryNumber: double.parse(categoryStr!),
        //   qtyNumber: textEditingControllerToInt(controller: cardMainPriceListCardModelTemp.stock)!,
        // );
        // if (!isLowerCardStock) {
        //   return false;
        // }

        final double moneyNumber = double.parse(formatAndLimitNumberTextGlobal(
          valueStr: (textEditingControllerToInt(controller: cardMainPriceListCardModelTemp.stock)! *
                  textEditingControllerToDouble(controller: cardMainPriceListCardModelTemp.price)!)
              .toString(),
          isRound: false,
          isAllowZeroAtLast: false,
          isAddComma: false,
        ));
        final ValidButtonModel checkLowerTheExistMoneyModel = checkLowerTheExistMoney(
          moneyNumber: moneyNumber,
          moneyType: cardMainPriceListCardModelTemp.moneyType!,
        );
        if (!checkLowerTheExistMoneyModel.isValid) {
          // return false;
          return checkLowerTheExistMoneyModel;
        }

        final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
        final int categoryIndex =
            cardModelListGlobal[companyNameIndex].categoryList.indexWhere((element) => (element.category.text == categoryStr)); //never equal -1
        final int limitIndex = cardModelListGlobal[companyNameIndex]
            .categoryList[categoryIndex]
            .limitList
            .indexWhere((element) => (element.moneyType == cardMainPriceListCardModelTemp.moneyType));

        final double startCardNumber =
            textEditingControllerToDouble(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].limitList[limitIndex].limit.first)!;
        final double lastCardNumber =
            textEditingControllerToDouble(controller: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].limitList[limitIndex].limit.last)!;
        final double priceCardNumber = textEditingControllerToDouble(controller: cardMainPriceListCardModelTemp.price)!;
        final bool isValidateCardBetweenLimit = (startCardNumber <= priceCardNumber && priceCardNumber <= lastCardNumber);
        if (!isValidateCardBetweenLimit) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.compareNumber,
            overwriteRule: "price must between limit.",
            errorLocationList: [
              TitleAndSubtitleModel(title: "price", subtitle: cardMainPriceListCardModelTemp.price.text),
              TitleAndSubtitleModel(title: "limit", subtitle: "$startCardNumber - $lastCardNumber"),
            ],
            error: "price is not between limit",
            detailList: [
              TitleAndSubtitleModel(
                title: "$startCardNumber <= ${cardMainPriceListCardModelTemp.price.text} <= $lastCardNumber",
                subtitle: "invalid compare",
              ),
            ],
          );
        }

        for (int rateIndex = 0; rateIndex < cardMainPriceListCardModelTemp.rateList.length; rateIndex++) {
          final RateModel rateModel = getRateModel(
            rateTypeFirst: cardMainPriceListCardModelTemp.rateList[rateIndex].rateType.first,
            rateTypeLast: cardMainPriceListCardModelTemp.rateList[rateIndex].rateType.last,
          )!;
          final double limitRateFirstNumber = textEditingControllerToDouble(controller: rateModel.limit.first)!;
          final double limitRateLastNumber = textEditingControllerToDouble(controller: rateModel.limit.last)!;
          final double discountRateNumber = textEditingControllerToDouble(controller: cardMainPriceListCardModelTemp.rateList[rateIndex].discountValue)!;
          final double percentageRateNumber = textEditingControllerToDouble(controller: cardMainPriceListCardModelTemp.rateList[rateIndex].percentage)!;
          final bool isValidateRateBetweenLimit = (limitRateFirstNumber <= discountRateNumber && discountRateNumber <= limitRateLastNumber);
          final bool isValidatePercentageBetweenLimit = (0 < percentageRateNumber && percentageRateNumber <= 100);
          // if (!isValidateRateBetweenLimit || !isValidatePercentageBetweenLimit) {
          //   // return false;
          // }
          if (!isValidateRateBetweenLimit) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.compareNumber,
              overwriteRule: "rate value must between limit.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "rate value", subtitle: cardMainPriceListCardModelTemp.rateList[rateIndex].discountValue.text),
                TitleAndSubtitleModel(title: "limit", subtitle: "$limitRateFirstNumber - $limitRateLastNumber"),
              ],
              error: "rate value is not between limit",
              detailList: [
                TitleAndSubtitleModel(
                  title: "$limitRateFirstNumber <= ${cardMainPriceListCardModelTemp.rateList[rateIndex].discountValue.text} <= $limitRateLastNumber",
                  subtitle: "invalid compare",
                ),
              ],
            );
          }

          if (!isValidatePercentageBetweenLimit) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.compareNumber,
              overwriteRule: "percentage value must between 0 - 100.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "percentage value", subtitle: cardMainPriceListCardModelTemp.rateList[rateIndex].percentage.text),
                TitleAndSubtitleModel(title: "limit", subtitle: "0 - 100"),
              ],
              error: "percentage value is not between 0 - 100",
              detailList: [
                TitleAndSubtitleModel(
                  title: "0 < ${cardMainPriceListCardModelTemp.rateList[rateIndex].percentage.text} <= 100",
                  subtitle: "invalid compare",
                ),
              ],
            );
          }
        }
        if (cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].count >= maxInsertStockGlobal) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.compareNumber,
            overwriteRule: "invoice count must lower than $maxInsertStockGlobal.",
            errorLocationList: [
              TitleAndSubtitleModel(title: "invoice count", subtitle: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].count.toString()),
              TitleAndSubtitleModel(title: "limit", subtitle: maxInsertStockGlobal.toString()),
            ],
            error: "invoice count is more than $maxInsertStockGlobal",
            detailList: [
              TitleAndSubtitleModel(
                title: "${cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].count} < $maxInsertStockGlobal",
                subtitle: "invalid compare",
              ),
            ],
          );
        }
        // return true;
        return ValidButtonModel(isValid: true);
      }

      void historyOnTapFunction() {
        limitHistory();
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
                children: [Text(addCardStockHistoryStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))], //TODO: change this
              ),
            );
          }

          //TODO: change this function name
          Widget addCardToStockHistoryListWidget() {
            List<Widget> inWrapWidgetList() {
              return [
                for (int addStockIndex = 0; addStockIndex < mainCardModelListEmployeeGlobal.length; addStockIndex++) //TODO: change this
                  HistoryElement(
                    isForceShowNoEffect: false,
                    isAdminEditing: false,
                    index: addStockIndex,
                    informationAndCardMainStockModel: mainCardModelListEmployeeGlobal[addStockIndex], //TODO: change this
                    setStateOutsider: setStateOutsider,
                  )
              ];
            }

            void topFunction() {}
            void bottomFunction() {
              if (!outOfDataQueryMainCardListGlobal) {
                //TODO: change this
                final int beforeQuery = mainCardModelListEmployeeGlobal.length; //TODO: change this
                void callBack() {
                  final int afterQuery = mainCardModelListEmployeeGlobal.length; //TODO: change this

                  if (beforeQuery == afterQuery) {
                    outOfDataQueryMainCardListGlobal = true; //TODO: change this
                  } else {
                    skipMainCardListGlobal = skipMainCardListGlobal + queryLimitNumberGlobal; //TODO: change this
                  }
                  setStateFromDialog(() {});
                }

                getAddCardStockListEmployeeGlobal(
                  employeeId: profileModelEmployeeGlobal!.id!,
                  callBack: callBack,
                  context: context,
                  skip: skipMainCardListGlobal,
                  targetDate: DateTime.now(),
                  mainCardModelListEmployee: mainCardModelListEmployeeGlobal,
                );
              }
            }

            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: !outOfDataQueryMainCardListGlobal,
            );
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleTextWidget(), Expanded(child: addCardToStockHistoryListWidget())]);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini),
          dialogWidth: dialogSizeGlobal(level: Level.mini),
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      List<Widget> inWrapWidgetList() {
        Widget addCardStockWidget() {
          void calculateTheLastPercentage() {
            if (cardMainPriceListCardModelTemp.rateList.length > 1) {
              double totalPercentage = 0;
              for (int rateIndex = 0; rateIndex < (cardMainPriceListCardModelTemp.rateList.length - 1); rateIndex++) {
                totalPercentage =
                    totalPercentage + (textEditingControllerToDouble(controller: cardMainPriceListCardModelTemp.rateList[rateIndex].percentage) ?? 0);
              }
              cardMainPriceListCardModelTemp.rateList.last.percentage.text = formatAndLimitNumberTextGlobal(
                valueStr: (100 - totalPercentage).toString(),
                isRound: false,
              );
            }
          }

          Widget paddingRightAndBottomWidget({required Widget widget}) {
            return Padding(
                padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal), bottom: paddingSizeGlobal(level: Level.normal)), child: widget);
          }

          Widget paddingBottomWidget({required Widget widget}) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: paddingSizeGlobal(level: Level.normal),
                left: paddingSizeGlobal(level: Level.mini),
                right: paddingSizeGlobal(level: Level.mini),
              ),
              child: widget,
            );
          }

          Widget insideSizeBoxWidget() {
            Widget singleToggleListWidget() {
              Widget invoiceCountWidget() {
                final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
                final int categoryIndex =
                    cardModelListGlobal[companyNameIndex].categoryList.indexWhere((element) => (element.category.text == categoryStr)); //never equal -1
                final String invoiceCountStr = formatAndLimitNumberTextGlobal(
                  valueStr: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].count.toString(),
                  isRound: false,
                );
                return Padding(
                  padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                  child: Text(" |  Invoice: $invoiceCountStr/$maxInsertStockGlobal", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                );
              }

              return Padding(
                padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
                child: Row(
                  children: [
                    paddingRightAndBottomWidget(widget: singleToggleGlobal(singleOptionStr: insertCardStockStrGlobal, color: positiveColorGlobal)),
                    paddingRightAndBottomWidget(widget: singleToggleGlobal(singleOptionStr: decreaseMoneyStrGlobal, color: negativeColorGlobal)),
                    ((companyNameStr != null) && (categoryStr != null)) ? invoiceCountWidget() : Container(),
                  ],
                ),
              );
            }

            Widget selectCompanyNameAndCategoryWidget() {
              Widget companyNameDropDownWidget() {
                void onTapFunction() {}
                final String? cardCompanyNameTemp = companyNameStr;
                void onChangedFunction({required String value, required int index}) {
                  companyNameStr = value;
                  categoryStr = null;
                  menuItemStrList = [];
                  isOtherMainStock = false;
                  cardMainPriceListCardModelTemp.price.text = "";
                  cardMainPriceListCardModelTemp.moneyType = "";

                  addActiveLogElement(
                    activeLogModelList: activeLogModelAddMCardStockList,
                    activeLogModel: ActiveLogModel(idTemp: "card company name dropdown", activeType: ActiveLogTypeEnum.selectDropdown, locationList: [
                      Location(title: "card company name dropdown", subtitle: "${(cardCompanyNameTemp == null) ? "" : "$cardCompanyNameTemp to "}$value"),
                    ]),
                  );

                  setState(() {});
                }

                return customDropdown(
                  level: Level.normal,
                  labelStr: cardCompanyNameStrGlobal,
                  onTapFunction: onTapFunction,
                  onChangedFunction: onChangedFunction,
                  selectedStr: companyNameStr,
                  menuItemStrList: cardCompanyNameOnlyList(),
                );
              }

              Widget categoryDropDownWidget() {
                void onTapFunction() {}
                final String? categoryTemp = categoryStr;
                void onChangedFunction({required String value, required int index}) {
                  categoryStr = value;
                  menuItemStrList = [];
                  isOtherMainStock = false;
                  cardMainPriceListCardModelTemp.price.text = "";
                  cardMainPriceListCardModelTemp.moneyType = "";
                  addActiveLogElement(
                    activeLogModelList: activeLogModelAddMCardStockList,
                    activeLogModel: ActiveLogModel(idTemp: "category dropdown", activeType: ActiveLogTypeEnum.selectDropdown, locationList: [
                      Location(title: "category dropdown", subtitle: "${(categoryTemp == null) ? "" : "$categoryTemp to "}$value"),
                    ]),
                  );

                  setState(() {});
                }

                return customDropdown(
                  level: Level.normal,
                  labelStr: categoryCardStrGlobal,
                  onTapFunction: onTapFunction,
                  onChangedFunction: onChangedFunction,
                  selectedStr: categoryStr,
                  menuItemStrList: cardCategoryOnlyList(companyNameStr: companyNameStr),
                );
              }

              return Row(children: [
                Expanded(
                  flex: flexValueGlobal,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: paddingSizeGlobal(level: Level.mini),
                      left: paddingSizeGlobal(level: Level.mini),
                      bottom: (companyNameStr == null || (cardMainPriceListCardModelTemp.moneyType == null) || (cardMainPriceListCardModelTemp.moneyType == ""))
                          ? paddingSizeGlobal(level: Level.mini)
                          : 0,
                    ),
                    child: companyNameDropDownWidget(),
                  ),
                ),
                (companyNameStr == null)
                    ? Container()
                    : Expanded(
                        flex: flexTypeGlobal,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: paddingSizeGlobal(level: Level.mini),
                            bottom: ((cardMainPriceListCardModelTemp.moneyType == null) || (cardMainPriceListCardModelTemp.moneyType == ""))
                                ? paddingSizeGlobal(level: Level.mini)
                                : 0,
                          ),
                          child: categoryDropDownWidget(),
                        ),
                      ),
              ]);
            }

            Widget priceAndMoneyTypeWidget() {
              Widget priceTextFieldWidget() {
                final String mainPriceTemp = cardMainPriceListCardModelTemp.price.text;
                void onChangeFromOutsiderFunction() {
                  final String mainPriceChangedTemp = cardMainPriceListCardModelTemp.price.text;
                  addActiveLogElement(
                    activeLogModelList: activeLogModelAddMCardStockList,
                    activeLogModel: ActiveLogModel(
                      idTemp: "stock price dropdown or textfield",
                      activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                      locationList: [
                        Location(
                          color: (mainPriceTemp.length < mainPriceChangedTemp.length) ? ColorEnum.green : ColorEnum.red,
                          title: "stock price textfield",
                          subtitle: "${mainPriceTemp.isEmpty ? "" : "$mainPriceTemp to "}$mainPriceChangedTemp",
                        ),
                      ],
                    ),
                  );
                  setState(() {});
                }

                // return textFieldGlobal(
                //   textFieldDataType: TextFieldDataType.double,
                //   controller: cardMainPriceListCardModelTemp.price,
                //   onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                //   labelText: mainPriceCardStrGlobal,
                //   level: Level.normal,
                //   onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                // );

                Function onTapToSelectFunction() {
                  void onTapToSelect() {}

                  return onTapToSelect;
                }

                void onChangedDropDrownFunction({required String value, required int index}) {
                  isOtherMainStock = (value == otherStrGlobal);
                  if (!isOtherMainStock) {
                    cardMainPriceListCardModelTemp.price.text = value;
                  }
                  final String mainPriceChangedTemp = cardMainPriceListCardModelTemp.price.text;
                  addActiveLogElement(
                    activeLogModelList: activeLogModelAddMCardStockList,
                    activeLogModel: ActiveLogModel(
                      idTemp: "stock price dropdown or textfield",
                      activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                      locationList: [
                        Location(title: "stock price dropdown", subtitle: "${mainPriceTemp.isEmpty ? "" : "$mainPriceTemp to "}$mainPriceChangedTemp"),
                      ],
                    ),
                  );
                  setState(() {});
                }

                void onDeleteFunction() {
                  isOtherMainStock = false;
                  cardMainPriceListCardModelTemp.price.text = "";
                  addActiveLogElement(
                    activeLogModelList: activeLogModelAddMCardStockList,
                    activeLogModel: ActiveLogModel(
                      idTemp: "stock price dropdown or textfield",
                      activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                      locationList: [Location(color: ColorEnum.red, title: "button name", subtitle: "delete button")],
                    ),
                  );
                  setState(() {});
                }

                return Padding(
                  padding: EdgeInsets.only(right: isOtherMainStock ? paddingSizeGlobal(level: Level.mini) : 0),
                  child: DropDownAndTextFieldProviderGlobal(
                    level: Level.normal,
                    labelStr: mainPriceCardStrGlobal,
                    onTapFunction: onTapToSelectFunction,
                    onChangedDropDrownFunction: onChangedDropDrownFunction,
                    selectedStr: cardMainPriceListCardModelTemp.price.text,
                    menuItemStrList: menuItemStrList,
                    controller: cardMainPriceListCardModelTemp.price,
                    textFieldDataType: TextFieldDataType.double,
                    isEnabled: (cardMainPriceListCardModelTemp.moneyType != null && cardMainPriceListCardModelTemp.moneyType != ""),
                    isShowTextField: isOtherMainStock,
                    onDeleteFunction: onDeleteFunction,
                    onChangedTextFieldFunction: onChangeFromOutsiderFunction,
                  ),
                );
              }

              Widget moneyTypeDropDownWidget() {
                void onTapFunction() {}
                final String? moneyTypeTemp = cardMainPriceListCardModelTemp.moneyType;
                void onChangedFunction({required String value, required int index}) {
                  cardMainPriceListCardModelTemp.moneyType = value;
                  menuItemStrList = [];
                  cardMainPriceListCardModelTemp.price.text = "";
                  final int companyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr)); //never equal -1
                  final int categoryIndex = cardModelListGlobal[companyNameIndex].categoryList.indexWhere((element) =>
                      (textEditingControllerToDouble(controller: element.category) ==
                          double.parse(formatAndLimitNumberTextGlobal(valueStr: categoryStr!, isRound: false, isAddComma: false)))); //never equal -1

                  for (int mainPriceIndex = 0;
                      mainPriceIndex < cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList.length;
                      mainPriceIndex++) {
                    final String moneyTypeStr =
                        cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].moneyType!; //never equal null
                    final String mainPriceStr =
                        cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].price.text; //never equal null
                    final bool isMatchMoneyType = (moneyTypeStr == cardMainPriceListCardModelTemp.moneyType);
                    final bool isDeleted = cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].isDelete;
                    final bool isNotMatchMainPrice = !menuItemStrList.contains(mainPriceStr);
                    if (isMatchMoneyType && isNotMatchMainPrice && !isDeleted) {
                      menuItemStrList.add(cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].price.text);
                    }
                  }
                  if (menuItemStrList.isNotEmpty) {
                    cardMainPriceListCardModelTemp.price.text = menuItemStrList.first;
                  }

                  addActiveLogElement(
                    activeLogModelList: activeLogModelAddMCardStockList,
                    activeLogModel: ActiveLogModel(idTemp: "money type dropdown", activeType: ActiveLogTypeEnum.selectDropdown, locationList: [
                      Location(title: "money type dropdown", subtitle: "${(moneyTypeTemp == null) ? "" : "$moneyTypeTemp to "}$value"),
                    ]),
                  );
                  setState(() {});
                }

                return customDropdown(
                  level: Level.normal,
                  labelStr: moneyTypeStrGlobal,
                  onTapFunction: onTapFunction,
                  onChangedFunction: onChangedFunction,
                  selectedStr: (companyNameStr != null && categoryStr != null) ? cardMainPriceListCardModelTemp.moneyType : null,
                  menuItemStrList: (companyNameStr != null && categoryStr != null)
                      ? getMoneyTypeCardIndex(
                          companyNameStr: companyNameStr!,
                          categoryNumber: double.parse(formatAndLimitNumberTextGlobal(valueStr: categoryStr!, isRound: false, isAddComma: false)),
                        )
                      : [],
                );
              }

              return (companyNameStr == null || categoryStr == null)
                  ? Container()
                  : Row(children: [
                      ((companyNameStr == null) ||
                              (categoryStr == null) ||
                              (cardMainPriceListCardModelTemp.moneyType == null) ||
                              (cardMainPriceListCardModelTemp.moneyType == ""))
                          ? Container()
                          : Expanded(flex: flexValueGlobal, child: priceTextFieldWidget()),
                      Expanded(
                        flex: flexTypeGlobal,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: paddingSizeGlobal(level: Level.mini),
                            left: (companyNameStr == null ||
                                    categoryStr == null ||
                                    (cardMainPriceListCardModelTemp.moneyType == null) ||
                                    (cardMainPriceListCardModelTemp.moneyType == ""))
                                ? paddingSizeGlobal(level: Level.mini)
                                : 0,
                            bottom: ((cardMainPriceListCardModelTemp.moneyType == null) || (cardMainPriceListCardModelTemp.moneyType == ""))
                                ? paddingSizeGlobal(level: Level.mini)
                                : 0,
                          ),
                          child: moneyTypeDropDownWidget(),
                        ),
                      ),
                    ]);
            }

            Widget textFieldStockWidget() {
              final String stockTemp = cardMainPriceListCardModelTemp.stock.text;
              void onChangeFromOutsiderFunction() {
                final bool isStockNotEmpty = cardMainPriceListCardModelTemp.stock.text.isNotEmpty;
                if (isStockNotEmpty) {
                  cardMainPriceListCardModelTemp.maxStock = textEditingControllerToInt(controller: cardMainPriceListCardModelTemp.stock)!;
                } else {
                  cardMainPriceListCardModelTemp.maxStock = 0;
                }
                final String stockChangedTemp = cardMainPriceListCardModelTemp.stock.text;
                addActiveLogElement(
                  activeLogModelList: activeLogModelAddMCardStockList,
                  activeLogModel: ActiveLogModel(
                    idTemp: "stock textfield",
                    activeType: ActiveLogTypeEnum.typeTextfield,
                    locationList: [
                      Location(
                        color: (stockTemp.length < stockChangedTemp.length) ? ColorEnum.green : ColorEnum.red,
                        title: "stock textfield",
                        subtitle: "${stockTemp.isEmpty ? "" : "$stockTemp to "}$stockChangedTemp",
                      ),
                    ],
                  ),
                );
                setState(() {});
              }

              void onTapFromOutsiderFunction() {}

              return paddingBottomWidget(
                widget: textFieldGlobal(
                  textFieldDataType: TextFieldDataType.int,
                  controller: cardMainPriceListCardModelTemp.stock,
                  onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                  labelText: stockCardStrGlobal,
                  level: Level.normal,
                  onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                ),
              );
            }

            Widget rateListWidget() {
              Widget paddingAddRateButtonWidget() {
                Widget addRateButtonWidget() {
                  ValidButtonModel isValid() {
                    for (int rateIndex = 0; rateIndex < cardMainPriceListCardModelTemp.rateList.length; rateIndex++) {
                      final bool isRateIdNull = (cardMainPriceListCardModelTemp.rateList[rateIndex].rateId == null);
                      final bool isDiscountEmpty = cardMainPriceListCardModelTemp.rateList[rateIndex].discountValue.text.isEmpty;
                      final bool isPercentageEmpty = cardMainPriceListCardModelTemp.rateList[rateIndex].percentage.text.isEmpty;
                      // if (isRateIdNull || isDiscountEmpty || isPercentageEmpty) {
                      //   return false;
                      // }
                      if (isRateIdNull) {
                        // return false;
                        return ValidButtonModel(
                          isValid: false,
                          errorType: ErrorTypeEnum.valueOfString,
                          errorLocationList: [
                            TitleAndSubtitleModel(title: "rate index", subtitle: rateIndex.toString()),
                            TitleAndSubtitleModel(title: "rate id", subtitle: cardMainPriceListCardModelTemp.rateList[rateIndex].rateId ?? ""),
                          ],
                          error: "please select rate",
                        );
                      }
                      if (isDiscountEmpty) {
                        // return false;
                        return ValidButtonModel(
                          isValid: false,
                          errorType: ErrorTypeEnum.valueOfNumber,
                          errorLocationList: [
                            TitleAndSubtitleModel(title: "rate index", subtitle: rateIndex.toString()),
                            TitleAndSubtitleModel(title: "discount value", subtitle: cardMainPriceListCardModelTemp.rateList[rateIndex].discountValue.text),
                          ],
                          error: "discount value is empty",
                        );
                      }
                      if (isPercentageEmpty) {
                        // return false;
                        return ValidButtonModel(
                          isValid: false,
                          errorType: ErrorTypeEnum.valueOfNumber,
                          errorLocationList: [
                            TitleAndSubtitleModel(title: "rate index", subtitle: rateIndex.toString()),
                            TitleAndSubtitleModel(title: "percentage", subtitle: cardMainPriceListCardModelTemp.rateList[rateIndex].percentage.text),
                          ],
                          error: "percentage is empty",
                        );
                      }
                    }
                    // return true;
                    return ValidButtonModel(isValid: true);
                  }

                  final int rateLengthTemp = cardMainPriceListCardModelTemp.rateList.length;
                  void onTapFunction() {
                    cardMainPriceListCardModelTemp.rateList.add(RateForCalculateModel(
                      rateType: [],
                      discountValue: TextEditingController(),
                      usedModelList: [],
                      percentage: TextEditingController(),
                    ));

                    final int rateLengthChangeTemp = cardMainPriceListCardModelTemp.rateList.length;
                    addActiveLogElement(
                      activeLogModelList: activeLogModelAddMCardStockList,
                      activeLogModel: ActiveLogModel(
                        activeType: ActiveLogTypeEnum.clickButton,
                        locationList: [
                          Location(title: "rate length", subtitle: "$rateLengthTemp to $rateLengthChangeTemp"),
                          Location(color: ColorEnum.green, title: "button name", subtitle: "add name"),
                        ],
                      ),
                    );
                    setState(() {});
                  }

                  return addButtonOrContainerWidget(
                    context: context,
                    level: Level.mini,
                    validModel: isValid(),
                    onTapFunction: onTapFunction,
                    currentAddButtonQty: cardMainPriceListCardModelTemp.rateList.length,
                    maxAddButtonLimit: cardMainPriceRateAddButtonLimitGlobal,
                  );
                }

                return Padding(padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.normal)), child: addRateButtonWidget());
              }

              Widget rateProviderWidget({required int rateIndex}) {
                void onDeleteUnlessDisable() {
                  cardMainPriceListCardModelTemp.rateList.removeAt(rateIndex);
                  setState(() {});
                }

                Widget insideSizeBoxWidget() {
                  Widget dropDownRateWidget() {
                    String? getSelectedRateStr() {
                      String? selectedStr;
                      final bool isRateIdNotNull = (cardMainPriceListCardModelTemp.rateList[rateIndex].rateId != null);
                      if (isRateIdNotNull) {
                        final String rateFirstStr = cardMainPriceListCardModelTemp.rateList[rateIndex].rateType.first;
                        final String rateLastStr = cardMainPriceListCardModelTemp.rateList[rateIndex].rateType.last;
                        final bool isBuyRate = cardMainPriceListCardModelTemp.rateList[rateIndex].isBuyRate!;
                        if (isBuyRate) {
                          selectedStr = "$rateFirstStr$arrowStrGlobal$rateLastStr";
                        } else {
                          selectedStr = "$rateLastStr$arrowStrGlobal$rateFirstStr";
                        }
                      }
                      return selectedStr;
                    }

                    void onTapFunction() {
                      //TODO: do something and setState
                    }
                    final List<String> rateTypeTemp = cardMainPriceListCardModelTemp.rateList[rateIndex].rateType;
                    final bool isBuyTemp = cardMainPriceListCardModelTemp.rateList[rateIndex].isBuyRate ?? false;
                    final String? rateTemp = rateTypeTemp.isEmpty
                        ? null
                        : (isBuyTemp ? "${rateTypeTemp.first} -> ${rateTypeTemp.last}" : "${rateTypeTemp.last} -> ${rateTypeTemp.first}");
                    void onChangedFunction({required String value, required int index}) {
                      if (value != noneStrGlobal) {
                        cardMainPriceListCardModelTemp.rateList[rateIndex] = getRateForCalculateModelByRateStr(rateStr: value);
                        cardMainPriceListCardModelTemp.rateList[rateIndex].percentage.text = (cardMainPriceListCardModelTemp.rateList.length == 1) ? "100" : "";
                      } else {
                        cardMainPriceListCardModelTemp.rateList[rateIndex] = RateForCalculateModel(
                          rateType: [],
                          discountValue: TextEditingController(),
                          usedModelList: [],
                          percentage: TextEditingController(),
                        );
                      }
                      calculateTheLastPercentage();

                      addActiveLogElement(
                        activeLogModelList: activeLogModelAddMCardStockList,
                        activeLogModel: ActiveLogModel(
                          idTemp: "select rate, ${rateIndex.toString()}",
                          activeType: ActiveLogTypeEnum.selectDropdown,
                          locationList: [
                            Location(title: "rate index", subtitle: rateIndex.toString()),
                            Location(title: "select rate", subtitle: rateTemp ?? "none"),
                          ],
                        ),
                      );
                      setState(() {});
                    }

                    return customDropdown(
                      level: Level.mini,
                      labelStr: rateTypeStrGlobal,
                      onTapFunction: onTapFunction,
                      onChangedFunction: onChangedFunction,
                      selectedStr: getSelectedRateStr(),
                      menuItemStrList: rateOnlyList(isShowAllRate: false, rateTypeDefault: getSelectedRateStr(), isShowNone: false),
                    );
                  }

                  final bool isRateIdNull = (cardMainPriceListCardModelTemp.rateList[rateIndex].rateId == null);
                  if (isRateIdNull) {
                    return dropDownRateWidget();
                  } else {
                    Widget paddingRightTextFieldWidget({required bool isEnable, required String labelText, required TextEditingController controller}) {
                      Widget textFieldRateDiscountWidget() {
                        final String strTemp = controller.text;
                        void onChangeFromOutsiderFunction() {
                          calculateTheLastPercentage();
                          final String strChangeTemp = controller.text;
                          final List<String> rateTypeTemp = cardMainPriceListCardModelTemp.rateList[rateIndex].rateType;
                          final bool isBuyTemp = cardMainPriceListCardModelTemp.rateList[rateIndex].isBuyRate ?? false;
                          final String rateTemp = rateTypeTemp.isEmpty
                              ? "none"
                              : (isBuyTemp ? "${rateTypeTemp.first} -> ${rateTypeTemp.last}" : "${rateTypeTemp.last} -> ${rateTypeTemp.first}");
                          addActiveLogElement(
                            activeLogModelList: activeLogModelAddMCardStockList,
                            activeLogModel: ActiveLogModel(
                              idTemp: "$labelText textfield, ${rateIndex.toString()}",
                              activeType: ActiveLogTypeEnum.typeTextfield,
                              locationList: [
                                Location(title: "rate index", subtitle: rateIndex.toString()),
                                Location(title: "rate type", subtitle: rateTemp),
                                Location(
                                  color: (strTemp.length < strChangeTemp.length) ? ColorEnum.green : ColorEnum.red,
                                  title: "$labelText textfield",
                                  subtitle: "${strTemp.isEmpty ? "" : "$strTemp to "}$strChangeTemp",
                                ),
                              ],
                            ),
                          );
                          setState(() {});
                        }

                        void onTapFromOutsiderFunction() {}
                        return textFieldGlobal(
                          isEnabled: isEnable,
                          textFieldDataType: TextFieldDataType.double,
                          controller: controller,
                          onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                          labelText: labelText,
                          level: Level.mini,
                          onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                        );
                      }

                      return Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)), child: textFieldRateDiscountWidget());
                    }

                    return Row(children: [
                      Expanded(
                        flex: flexValueGlobal,
                        child: paddingRightTextFieldWidget(
                          isEnable: ((cardMainPriceListCardModelTemp.rateList.length - 1) != rateIndex),
                          // isEnable: true,
                          labelText: percentageStrGlobal,
                          controller: cardMainPriceListCardModelTemp.rateList[rateIndex].percentage,
                        ),
                      ),
                      Expanded(
                        flex: flexValueGlobal,
                        child: paddingRightTextFieldWidget(
                          isEnable: true,
                          labelText: rateStrGlobal,
                          controller: cardMainPriceListCardModelTemp.rateList[rateIndex].discountValue,
                        ),
                      ),
                      Expanded(flex: flexTypeGlobal, child: dropDownRateWidget()),
                    ]);
                  }
                }

                void onTapUnlessDisable() {
                  //TODO: do something and setState
                }

                return CustomButtonGlobal(
                    isDisable: true,
                    onDeleteUnlessDisable: onDeleteUnlessDisable,
                    insideSizeBoxWidget: insideSizeBoxWidget(),
                    onTapUnlessDisable: onTapUnlessDisable);
              }

              return Column(children: [
                for (int rateIndex = 0; rateIndex < cardMainPriceListCardModelTemp.rateList.length; rateIndex++) rateProviderWidget(rateIndex: rateIndex),
                paddingAddRateButtonWidget(),
              ]);
            }

            Widget remarkTextFieldWidget() {
              void onTapFromOutsiderFunction() {}
              final String remarkTemp = cardMainPriceListCardModelTemp.remark.text;
              void onChangeFromOutsiderFunction() {
                final String remarkChangedTemp = cardMainPriceListCardModelTemp.remark.text;
                addActiveLogElement(
                  activeLogModelList: activeLogModelAddMCardStockList,
                  activeLogModel: ActiveLogModel(
                    idTemp: "remark textfield",
                    activeType: ActiveLogTypeEnum.typeTextfield,
                    locationList: [
                      Location(
                        color: (remarkTemp.length < remarkChangedTemp.length) ? ColorEnum.green : ColorEnum.red,
                        title: "remark textfield",
                        subtitle: "${remarkTemp.isEmpty ? "" : "$remarkTemp to "}$remarkChangedTemp",
                      ),
                    ],
                  ),
                );
                setState(() {});
              }

              return paddingBottomWidget(
                widget: textAreaGlobal(
                  controller: cardMainPriceListCardModelTemp.remark,
                  onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                  onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                  labelText: remarkOptionalStrGlobal,
                  level: Level.normal,
                ),
              );
            }

            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              singleToggleListWidget(),
              selectCompanyNameAndCategoryWidget(),
              priceAndMoneyTypeWidget(),
              textFieldStockWidget(),
              remarkTextFieldWidget(),
              rateListWidget()
            ]);
          }

          void onTapUnlessDisable() {}
          return CustomButtonGlobal(
            sizeBoxWidth: dialogSizeGlobal(level: Level.mini),
            insideSizeBoxWidget: insideSizeBoxWidget(),
            onTapUnlessDisable: onTapUnlessDisable,
          );
        }

        return [addCardStockWidget()];
      }

      void updateCardStockToDBOrPrint({required isPrint}) {
        addMainStockCardCheckForFinalEdition(activeLogModelList: activeLogModelAddMCardStockList, rateList: cardMainPriceListCardModelTemp.rateList);
        
        setFinalEditionActiveLog(activeLogModelList: activeLogModelAddMCardStockList);
        cardMainPriceListCardModelTemp.activeLogModelList = activeLogModelAddMCardStockList;
        void callBack() {
          isOtherMainStock = false;
          companyNameStr = null;
          categoryStr = null;
          cardMainPriceListCardModelTemp = CardMainPriceListCardModel(
              activeLogModelList: [], price: TextEditingController(), stock: TextEditingController(), rateList: [], remark: TextEditingController());

          if (isPrint) {
            printCardStockInvoice(cardStockModel: mainCardModelListEmployeeGlobal.first, context: context);
          }

          sellCardModelTempSideMenuListGlobal = [];

          sellCardAdvanceModelTempSellCardGlobal = SellCardModel(activeLogModelList: [], moneyTypeList: [], remark: TextEditingController());
          exchangeAnalysisCardSellCardGlobal = ExchangeMoneyModel(activeLogModelList: [], exchangeList: [], remark: TextEditingController());

          textFieldController2DSellCardGlobal = [];
          menuItemStr3DSellCardGlobal = [];
          isShowTextField2DSellCardGlobal = [];

          buyAndSellDiscountRateListSellCardGlobal = [];

          for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
            for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++) {
              limitMainStockList(categoryCardModel: cardModelListGlobal[cardIndex].categoryList[categoryIndex]);
            }
          }
          // setState(() {});
          activeLogModelAddMCardStockList = [];
          widget.callback();
        }

        final int cardCompanyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr));
        final int categoryIndex = cardModelListGlobal[cardCompanyNameIndex].categoryList.indexWhere((element) => (element.category.text == categoryStr));

        final String cardCompanyNameId = cardModelListGlobal[cardCompanyNameIndex].id!;
        final String cardCompanyName = cardModelListGlobal[cardCompanyNameIndex].cardCompanyName.text;
        // final String language = cardModelListAdminGlobal[cardCompanyNameIndex].language;
        final String categoryId = cardModelListGlobal[cardCompanyNameIndex].categoryList[categoryIndex].id!;
        final double category = textEditingControllerToDouble(controller: cardModelListGlobal[cardCompanyNameIndex].categoryList[categoryIndex].category)!;

        updateMainCardGlobal(
          context: context,
          callBack: callBack,
          cardCompanyNameId: cardCompanyNameId,
          cardCompanyName: cardCompanyName,
          categoryId: categoryId,
          category: category,
          mainCard: cardMainPriceListCardModelTemp,
          // language: language,
        );
      }

      void saveOnTapFunction() {
        // void callBack() {
        //   companyNameStr = null;
        //   categoryStr = null;
        //   cardMainPriceListCardModelTemp = CardMainPriceListCardModel(price: TextEditingController(), stock: TextEditingController(), rateList: [], remark: TextEditingController());
        //   setState(() {});
        // }

        // final int cardCompanyNameIndex = cardModelListAdminGlobal.indexWhere((element) => (element.cardCompanyName.text == companyNameStr));
        // final int categoryIndex = cardModelListAdminGlobal[cardCompanyNameIndex].categoryList.indexWhere((element) => (element.category.text == categoryStr));

        // final String cardCompanyNameId = cardModelListAdminGlobal[cardCompanyNameIndex].id!;
        // final String cardCompanyName = cardModelListAdminGlobal[cardCompanyNameIndex].cardCompanyName.text;
        // // final String language = cardModelListAdminGlobal[cardCompanyNameIndex].language;
        // final String categoryId = cardModelListAdminGlobal[cardCompanyNameIndex].categoryList[categoryIndex].id!;
        // final double category = textEditingControllerToDouble(controller: cardModelListAdminGlobal[cardCompanyNameIndex].categoryList[categoryIndex].category)!;

        // updateMainCardGlobal(
        //   context: context,
        //   callBack: callBack,
        //   cardCompanyNameId: cardCompanyNameId,
        //   cardCompanyName: cardCompanyName,
        //   categoryId: categoryId,
        //   category: category,
        //   mainCard: cardMainPriceListCardModelTemp,
        //   // language: language,
        // );
        updateCardStockToDBOrPrint(isPrint: false);
      }

      void saveAndPrintOnTapFunction() {
        updateCardStockToDBOrPrint(isPrint: true);
      }

      void clearFunction() {
        companyNameStr = null;
        categoryStr = null;
        menuItemStrList = [];
        isOtherMainStock = false;
        cardMainPriceListCardModelTemp = CardMainPriceListCardModel(
          activeLogModelList: [],
          price: TextEditingController(),
          stock: TextEditingController(),
          rateList: [],
          remark: TextEditingController(),
        );
        setState(() {});
      }

      return BodyTemplateSideMenu(
        title: widget.title,
        isValidSaveOnTap: isValidCard(),
        isValidSaveAndPrintOnTap: isValidCard(),
        // isValidShowPrevious: isValidShowPrevious(),
        // isShowPrevious: isShowPrevious,
        // previousWidget: previousWidget(),
        // previousOnTapFunction: previousOnTapFunction,
        inWrapWidgetList: inWrapWidgetList(),
        historyOnTapFunction: historyOnTapFunction,
        saveOnTapFunction: saveOnTapFunction,
        saveAndPrintOnTapFunction: saveAndPrintOnTapFunction,
        clearFunction: clearFunction,
      );
    }

    return bodyTemplateSideMenu();
  }
}
