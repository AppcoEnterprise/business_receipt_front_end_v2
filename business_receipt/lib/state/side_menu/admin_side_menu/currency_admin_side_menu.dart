// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/request_api/currency_request_api_env.dart';
import 'package:business_receipt/env/function/slider_env.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/text_limit.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/currency_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/override_lib/currency_lib/currency.dart';
import 'package:business_receipt/override_lib/currency_lib/currency_list_view.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class CurrencyAdminSideMenu extends StatefulWidget {
  String title;
  CurrencyAdminSideMenu({Key? key, required this.title}) : super(key: key);

  @override
  State<CurrencyAdminSideMenu> createState() => _CurrencyAdminSideMenuState();
}

class _CurrencyAdminSideMenuState extends State<CurrencyAdminSideMenu> {
  // bool _isLoadingOnGetCurrent = true;
  @override
  void initState() {
    // void initCurrencyToTempDB() {
    //   bool isEmptyCurrent = currencyModelListAdminGlobal.isEmpty;
    //   if (isEmptyCurrent) {
    //     getCurrencyGlobal(
    //       callBack: () {
    //         _isLoadingOnGetCurrent = false;
    //         setState(() {});
    //       },
    //       context: context,
    //     );
    //   } else {
    //     _isLoadingOnGetCurrent = false;
    //   }
    // }

    // initCurrencyToTempDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      Widget currencyButtonWidget({required int currencyIndex}) {
        Widget setWidthSizeBox() {
          Widget insideSizeBoxWidget() {
            Widget paddingAndColumnWidget() {
              Widget moneyTypeAndSymbolAndNameWidget() {
                final String symbol = currencyModelListAdminGlobal[currencyIndex].symbol!;
                final String moneyType = currencyModelListAdminGlobal[currencyIndex].moneyType;
                final String name = currencyModelListAdminGlobal[currencyIndex].name!;
                final DateTime? deleteDateOrNull = currencyModelListAdminGlobal[currencyIndex].deletedDate;
                Widget symbolTextWidget() {
                  return Text(symbol,
                      style: textStyleGlobal(
                          level: Level.large, fontWeight: FontWeight.bold, color: (deleteDateOrNull == null) ? defaultTextColorGlobal : deleteTextColorGlobal));
                }

                Widget moneyTypeTextWidget() {
                  return Text(moneyType,
                      style: textStyleGlobal(level: Level.normal, color: (deleteDateOrNull == null) ? defaultTextColorGlobal : deleteTextColorGlobal));
                }

                Widget nameScrollTextWidget() {
                  return scrollText(
                    textStr: name,
                    textStyle: textStyleGlobal(level: Level.mini, color: (deleteDateOrNull == null) ? defaultTextColorGlobal : deleteTextColorGlobal),
                    alignment: Alignment.topCenter,
                  );
                }

                Widget deleteDateScrollTextWidget() {
                  return (deleteDateOrNull == null)
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)),
                          child: scrollText(
                            textStr: "$deleteAtStrGlobal ${formatFullDateToStr(date: deleteDateOrNull.add(const Duration(days: deleteAtDay)))}",
                            textStyle: textStyleGlobal(level: Level.mini, fontWeight: FontWeight.bold, color: Colors.red),
                            alignment: Alignment.topCenter,
                          ),
                        );
                }

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [symbolTextWidget(), moneyTypeTextWidget(), nameScrollTextWidget(), deleteDateScrollTextWidget()]);
              }

              return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.normal)), child: moneyTypeAndSymbolAndNameWidget());
            }

            return paddingAndColumnWidget();
          }

          void onTapUnlessDisable() {
            void currencyEditorDialog() {
              final DateTime? deleteDateOrNull = currencyModelListAdminGlobal[currencyIndex].deletedDate;
              int sliderValue = currencyModelListAdminGlobal[currencyIndex].decimalPlace!;

              // if (deleteDateOrNull == null) {
              editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.currency);
              // }

              ValidButtonModel validToSaveMoney() {
                bool isNotSame = (sliderValue != currencyModelListAdminGlobal[currencyIndex].decimalPlace);

                // for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
                //   for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++) {
                //     for (int priceIndex = 0; priceIndex < cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList.length; priceIndex++) {
                //       final String cardMoneyType = cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[priceIndex].moneyType!;
                //       if (cardMoneyType == currencyMoneyType) {
                //         return ValidButtonModel(
                //           isValid: false,
                //           error: "card price is still using $cardMoneyType",
                //           // overwriteRule: "",
                //           errorLocationList: [
                //             TitleAndSubtitleModel(title: "card", subtitle: "sell price"),
                //             TitleAndSubtitleModel(title: "card company name", subtitle: cardModelListGlobal[cardIndex].cardCompanyName.text),
                //             TitleAndSubtitleModel(
                //               title: "card category",
                //               subtitle: cardModelListGlobal[cardIndex].categoryList[categoryIndex].category.text,
                //             ),
                //             TitleAndSubtitleModel(title: "price index", subtitle: priceIndex.toString()),
                //             TitleAndSubtitleModel(title: "money type", subtitle: cardMoneyType),
                //           ],
                //         );
                //       }
                //     }
                //     // if(cardModelListGlobal[cardIndex].categoryList[categoryIndex].)
                //   }
                // }

                // for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
                //   for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++) {
                //     for (int priceIndex = 0; priceIndex < cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList.length; priceIndex++) {
                //       final String cardMoneyType = cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList[priceIndex].moneyType!;
                //       if (cardMoneyType == currencyMoneyType) {
                //         return ValidButtonModel(
                //           isValid: false,
                //           error: "card price is still using $cardMoneyType",
                //           // overwriteRule: "",
                //           errorLocationList: [
                //             TitleAndSubtitleModel(title: "card", subtitle: "stock"),
                //             TitleAndSubtitleModel(title: "card company name", subtitle: cardModelListGlobal[cardIndex].cardCompanyName.text),
                //             TitleAndSubtitleModel(
                //               title: "card category",
                //               subtitle: cardModelListGlobal[cardIndex].categoryList[categoryIndex].category.text,
                //             ),
                //             TitleAndSubtitleModel(title: "price index", subtitle: priceIndex.toString()),
                //             TitleAndSubtitleModel(title: "money type", subtitle: cardMoneyType),
                //           ],
                //         );
                //       }
                //     }
                //   }
                // }

                // for (int transferIndex = 0; transferIndex < transferModelListGlobal.length; transferIndex++) {
                //   for (int moneyTypeIndex = 0; moneyTypeIndex < transferModelListGlobal[transferIndex].moneyTypeList.length; moneyTypeIndex++) {
                //     final String transferMoneyType = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyType!;
                //     if (transferMoneyType == currencyMoneyType) {
                //       return ValidButtonModel(
                //         isValid: false,
                //         error: "transfer is still using $transferMoneyType",
                //         errorLocationList: [
                //           TitleAndSubtitleModel(title: "money type", subtitle: transferMoneyType),
                //         ],
                //       );
                //     }
                //   }
                // }

                // for (int amountIndex = 0; amountIndex < amountAndProfitModelGlobal.length; amountIndex++) {
                //   if (currencyMoneyType == amountAndProfitModelGlobal[amountIndex].moneyType) {
                //     if (amountAndProfitModelGlobal[amountIndex].amount != 0) {
                //       return ValidButtonModel(
                //         isValid: false,
                //         error: "amount of $currencyMoneyType is not 0",
                //         errorLocationList: [
                //           TitleAndSubtitleModel(
                //             title: "total amount",
                //             subtitle: formatAndLimitNumberTextGlobal(valueStr: amountAndProfitModelGlobal[amountIndex].amount.toString(), isRound: false),
                //           ),
                //         ],
                //       );
                //     }
                //   }
                // }

                // return ValidButtonModel(isValid: isNotSame, errorStr: "Currency decimal place is the same as before");
                return ValidButtonModel(isValid: isNotSame, errorType: ErrorTypeEnum.nothingChange);
              }

              Widget contentDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                Widget paddingBottomRateTitleWidget() {
                  Widget currencyTitleWidget() {
                    final String rateTitle =
                        "$currencyOfStrGlobal ${currencyModelListAdminGlobal[currencyIndex].name} (${currencyModelListAdminGlobal[currencyIndex].symbol})";
                    return scrollText(
                        textStr: rateTitle, textStyle: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold), alignment: Alignment.topLeft);
                  }

                  return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: currencyTitleWidget());
                }

                Widget paddingVerticalPlaceTextWidget() {
                  Widget placeTextWidget() {
                    return Text("$decimalStrGlobal = $sliderValue", style: textStyleGlobal(level: Level.normal));
                  }

                  return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)), child: placeTextWidget());
                }

                Widget sliderWidget() {
                  final double minSlider = -1 * maxPlaceNumberGlobal.toDouble();
                  final double maxSlider = maxPlaceNumberGlobal.toDouble();
                  // final int divisionsSlider = (minSlider.abs() + maxSlider.abs()).round();

                  return sliderPositiveAndNegativeWidgetGlobal(
                    sliderValue: sliderValue.toDouble(),
                    onChangeFunction: ({required double newValue}) {
                      if (deleteDateOrNull == null) {
                        sliderValue = newValue.toInt();
                        setStateFromDialog(() {});
                      }
                    },
                    maxSlider: maxSlider,
                    minSlider: minSlider,
                    // divisionsSlider: divisionsSlider,
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    paddingBottomRateTitleWidget(),
                    paddingVerticalPlaceTextWidget(),
                    sliderWidget(),
                  ],
                );
              }

              void cancelFunctionOnTap() {
                void okFunction() {
                  adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.currency);
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
              }

              void saveFunctionOnTap() {
                void callBack() {
                  adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.currency);
                  setState(() {});
                  closeDialogGlobal(context: context);
                }

                currencyModelListAdminGlobal[currencyIndex].decimalPlace = sliderValue;
                updateCurrencyGlobal(callBack: callBack, context: context, currencyModelTemp: currencyModelListAdminGlobal[currencyIndex]);
              }

              void deleteFunctionOnTap() {
                void okFunction() {
                  void callBack() {
                    adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.currency);
                    setState(() {});
                    closeDialogGlobal(context: context);
                  }

                  currencyModelListAdminGlobal[currencyIndex].decimalPlace = sliderValue;
                  deleteCurrencyGlobal(callBack: callBack, context: context, moneyType: currencyModelListAdminGlobal[currencyIndex].moneyType);
                }

                void cancelFunction() {}
                confirmationDialogGlobal(
                  context: context,
                  okFunction: okFunction,
                  cancelFunction: cancelFunction,
                  titleStr: "$deleteGlobal ${currencyModelListAdminGlobal[currencyIndex].moneyType}",
                  subtitleStr: deleteConfirmGlobal,
                );
              }

              void restoreFunctionOnTap() {
                void okFunction() {
                  void callBack() {
                    adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.currency);
                    setState(() {});
                    closeDialogGlobal(context: context);
                  }

                  currencyModelListAdminGlobal[currencyIndex].decimalPlace = sliderValue;
                  restoreCurrencyGlobal(callBack: callBack, context: context, moneyType: currencyModelListAdminGlobal[currencyIndex].moneyType);
                }

                void cancelFunction() {}
                confirmationDialogGlobal(
                  context: context,
                  okFunction: okFunction,
                  cancelFunction: cancelFunction,
                  titleStr: "$restoreGlobal ${currencyModelListAdminGlobal[currencyIndex].moneyType}",
                  subtitleStr: restoreConfirmGlobal,
                );
              }

              ValidButtonModel isDeleted() {
                final String currencyMoneyType = currencyModelListAdminGlobal[currencyIndex].moneyType;
                for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
                  for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++) {
                    for (int priceIndex = 0; priceIndex < cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList.length; priceIndex++) {
                      final String cardMoneyType = cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[priceIndex].moneyType!;
                      if (cardMoneyType == currencyMoneyType) {
                        return ValidButtonModel(
                          isValid: false,
                          error: "card price is still using $cardMoneyType",
                          // overwriteRule: "",
                          errorLocationList: [
                            TitleAndSubtitleModel(title: "card", subtitle: "sell price"),
                            TitleAndSubtitleModel(title: "card company name", subtitle: cardModelListGlobal[cardIndex].cardCompanyName.text),
                            TitleAndSubtitleModel(
                              title: "card category",
                              subtitle: cardModelListGlobal[cardIndex].categoryList[categoryIndex].category.text,
                            ),
                            TitleAndSubtitleModel(title: "price index", subtitle: priceIndex.toString()),
                            TitleAndSubtitleModel(title: "money type", subtitle: cardMoneyType),
                          ],
                        );
                      }
                    }
                    // if(cardModelListGlobal[cardIndex].categoryList[categoryIndex].)
                  }
                }

                for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
                  for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++) {
                    for (int priceIndex = 0; priceIndex < cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList.length; priceIndex++) {
                      final String cardMoneyType = cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList[priceIndex].moneyType!;
                      if (cardMoneyType == currencyMoneyType) {
                        return ValidButtonModel(
                          isValid: false,
                          error: "card price is still using $cardMoneyType",
                          // overwriteRule: "",
                          errorLocationList: [
                            TitleAndSubtitleModel(title: "card", subtitle: "stock"),
                            TitleAndSubtitleModel(title: "card company name", subtitle: cardModelListGlobal[cardIndex].cardCompanyName.text),
                            TitleAndSubtitleModel(
                              title: "card category",
                              subtitle: cardModelListGlobal[cardIndex].categoryList[categoryIndex].category.text,
                            ),
                            TitleAndSubtitleModel(title: "price index", subtitle: priceIndex.toString()),
                            TitleAndSubtitleModel(title: "money type", subtitle: cardMoneyType),
                          ],
                        );
                      }
                    }
                  }
                }

                for (int transferIndex = 0; transferIndex < transferModelListGlobal.length; transferIndex++) {
                  for (int moneyTypeIndex = 0; moneyTypeIndex < transferModelListGlobal[transferIndex].moneyTypeList.length; moneyTypeIndex++) {
                    final String transferMoneyType = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyType!;
                    if (transferMoneyType == currencyMoneyType) {
                      return ValidButtonModel(
                        isValid: false,
                        error: "transfer is still using $transferMoneyType",
                        errorLocationList: [
                          TitleAndSubtitleModel(title: "money type", subtitle: transferMoneyType),
                        ],
                      );
                    }
                  }
                }

                for (int amountIndex = 0; amountIndex < amountAndProfitModelGlobal.length; amountIndex++) {
                  if (currencyMoneyType == amountAndProfitModelGlobal[amountIndex].moneyType) {
                    if (amountAndProfitModelGlobal[amountIndex].amount != 0) {
                      return ValidButtonModel(
                        isValid: false,
                        error: "amount of $currencyMoneyType is not 0",
                        errorLocationList: [
                          TitleAndSubtitleModel(
                            title: "total amount",
                            subtitle: formatAndLimitNumberTextGlobal(valueStr: amountAndProfitModelGlobal[amountIndex].amount.toString(), isRound: false),
                          ),
                        ],
                      );
                    }
                  }
                }

                // return ValidButtonModel(isValid: isNotSame, errorStr: "Currency decimal place is the same as before");
                return ValidButtonModel(isValid: true);
              }

              actionDialogSetStateGlobal(
                context: context,
                contentFunctionReturnWidget: contentDialog,
                cancelFunctionOnTap: cancelFunctionOnTap,
                validSaveButtonFunction: () => validToSaveMoney(),
                saveFunctionOnTap: (deleteDateOrNull == null) ? saveFunctionOnTap : null,
                dialogHeight: dialogSizeGlobal(level: Level.mini),
                dialogWidth: dialogSizeGlobal(level: Level.mini),
                validDeleteFunctionOnTap: () => isDeleted(),
                deleteFunctionOnTap: (deleteDateOrNull == null) ? deleteFunctionOnTap : null,
                restoreFunctionOnTap: (deleteDateOrNull == null) ? null : restoreFunctionOnTap,
              );
            }

            askingForChangeDialogGlobal(context: context, allowFunction: currencyEditorDialog, editSettingTypeEnum: EditSettingTypeEnum.currency);
          }

          return CustomButtonGlobal(
              sizeBoxWidth: sizeBoxWidthGlobal,
              sizeBoxHeight: sizeBoxHeightGlobal,
              insideSizeBoxWidget: insideSizeBoxWidget(),
              onTapUnlessDisable: onTapUnlessDisable);
        }

        return setWidthSizeBox();
      }

      void addOnTapFunction() {
        void addCurrencyDialog() {
          currenciesOptionGlobal = [];
          void callBack() {
            Currency? currencyTemp;
            editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.currency);

            Widget contentDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chooseACurrencyStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: CurrencyListView(
                      showFlag: true,
                      showSearchField: true,
                      showCurrencyName: true,
                      showCurrencyCode: true,
                      onSelect: (Currency currency) {
                        currencyTemp = currency;
                      },
                      // favorite: ['SEK'],
                    ),
                  ),
                ],
              );
            }

            void cancelFunctionOnTap() {
              adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.currency);
              closeDialogGlobal(context: context);
            }

            void afterCloseFunction() {
              if (currencyTemp != null) {
                final int currencyIndex =
                    moneyTypeOnlyList(moneyTypeDefault: null, isNotCheckDeleted: true).indexWhere((element) => (element == currencyTemp!.code));
                final bool isExistCurrencies = currencyIndex != -1;
                if (isExistCurrencies) {
                  void okFunction() {
                    adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.currency);
                    closeDialogGlobal(context: context);
                  }

                  okDialogGlobal(
                    context: context,
                    okFunction: okFunction,
                    titleStr: "$cantAddCurrencyGlobal (${currencyTemp!.code})",
                    subtitleStr: currencyExistedAdminStrGlobal,
                  );
                } else {
                  void okFunction() {
                    void callBack() {
                      adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.currency);
                      setState(() {});
                    }

                    updateCurrencyGlobal(callBack: callBack, context: context, currencyModelTemp: CurrencyModel(moneyType: currencyTemp!.code, valueList: []));
                  }

                  void cancelFunction() {}
                  confirmationDialogGlobal(
                    context: context,
                    okFunction: okFunction,
                    cancelFunction: cancelFunction,
                    titleStr: "$addCurrencyGlobal (${currencyTemp!.code})",
                    subtitleStr: currencyTemp!.name,
                  );
                }
              }
            }

            actionDialogSetStateGlobal(
              context: context,
              contentFunctionReturnWidget: contentDialog,
              cancelFunctionOnTap: cancelFunctionOnTap,
              dialogHeight: dialogSizeGlobal(level: Level.mini),
              dialogWidth: dialogSizeGlobal(level: Level.mini),
              afterCloseFunction: afterCloseFunction,
            );
          }

          getCurrenciesOptionAdminGlobal(callBack: callBack, context: context);
        }

        askingForChangeDialogGlobal(context: context, allowFunction: addCurrencyDialog, editSettingTypeEnum: EditSettingTypeEnum.currency);
      }

      return BodyTemplateSideMenu(
        inWrapWidgetList: [
          for (int currencyIndex = 0; currencyIndex < currencyModelListAdminGlobal.length; currencyIndex++) currencyButtonWidget(currencyIndex: currencyIndex)
        ],
        title: widget.title,
        addOnTapFunction: addOnTapFunction,
        currentAddButtonQty: currencyModelListAdminGlobal.length,
        maxAddButtonLimit: currencyAddButtonLimitGlobal,
      );
    }

    // return _isLoadingOnGetCurrent ? Container() : bodyTemplateSideMenu();
    return bodyTemplateSideMenu();
  }
}
