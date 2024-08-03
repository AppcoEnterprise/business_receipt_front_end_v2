// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/button/button_env.dart';
import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/card.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/function/table_env.dart';
import 'package:business_receipt/env/function/request_api/card_request_api_env.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/active_log.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/icon_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/card/card_combine_model.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class CardAdminSideMenu extends StatefulWidget {
  String title;
  CardAdminSideMenu({Key? key, required this.title}) : super(key: key);

  @override
  State<CardAdminSideMenu> createState() => _CardAdminSideMenuState();
}

class _CardAdminSideMenuState extends State<CardAdminSideMenu> {
  // bool _isLoadingOnInitCard = true;
  @override
  void initState() {
    // void initCardToTempDB() {
    //   bool isEmptyCard = cardModelListAdminGlobal.isEmpty;
    //   if (isEmptyCard) {
    //     void callback() {
    //       _isLoadingOnInitCard = false;
    //       setState(() {});
    //     }

    //     initCardAdminOrEmployeeGlobal(callBack: callback, context: context, isAdminQuery: true);
    //   } else {
    //     _isLoadingOnInitCard = false;
    //   }
    // }

    // initCardToTempDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingOrBody() {
      Widget bodyTemplateSideMenu() {
        //if isCreateNewCard = true then cardIndex = null, else isCreateNewCard = false then cardIndex will never be null
        void setUpCardDialog({required bool isCreateNewCard, required int? cardIndex}) {
          DateTime? deleteDateOrNull;
          int selectedCategoryIndex = 0; //-1 mean not show category detail
          CardModel cardTemp = CardModel(cardCompanyName: TextEditingController(), categoryList: []);

          if (!isCreateNewCard) {
            cardTemp = cloneCardModel(cardIndex: cardIndex!, cardModelList: cardModelListGlobal);
            deleteDateOrNull = cardModelListGlobal[cardIndex].deletedDate;
          }
          // if (deleteDateOrNull == null) {
          editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.card);
          // }

          void initUnlessCategoryControllerListIsEmpty() {
            if (cardTemp.categoryList.isEmpty) {
              CardSellPriceListCardModel initCardCategoryListModel = CardSellPriceListCardModel(
                startValue: TextEditingController(),
                endValue: TextEditingController(),
                price: TextEditingController(),
                moneyType: null,
              );
              cardTemp.categoryList.add(CardCategoryListCardModel(
                totalStock: 0,
                ordered: 0,
                count: 0,
                category: TextEditingController(),
                mainPriceList: [],
                sellPriceList: [initCardCategoryListModel],
                qty: TextEditingController(),
                limitList: [],
                // mainPriceSeparateByPercentageList: [],
              ));
            }
          }

          initUnlessCategoryControllerListIsEmpty();

          ValidButtonModel isNoMainCardStock({int? categoryIndex}) {
            // double mainStock = 0;
            if (categoryIndex == null) {
              double mainStock = 0;
              for (int categoryIndex = 0; categoryIndex < cardTemp.categoryList.length; categoryIndex++) {
                for (int stockIndex = 0; stockIndex < cardTemp.categoryList[categoryIndex].mainPriceList.length; stockIndex++) {
                  mainStock = mainStock + cardTemp.categoryList[categoryIndex].mainPriceList[stockIndex].maxStock;
                }
              }
              // return (mainStock == 0);
              return ValidButtonModel(
                isValid: (mainStock == 0),
                errorType: ErrorTypeEnum.valueOfNumber,
                overwriteRule: "value must equal 0.",
                errorLocationList: [
                  TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                  TitleAndSubtitleModel(
                    title: "Total Stock",
                    subtitle: "${formatAndLimitNumberTextGlobal(valueStr: mainStock.toString(), isRound: false)} card",
                  ),
                ],
                error: "Total Stock of ${cardTemp.cardCompanyName.text} is not equal 0.",
              );
            } else {
              double mainStock = 0;
              for (int stockIndex = 0; stockIndex < cardTemp.categoryList[categoryIndex].mainPriceList.length; stockIndex++) {
                mainStock = mainStock + cardTemp.categoryList[categoryIndex].mainPriceList[stockIndex].maxStock;
              }
              // return (mainStock == 0);
              return ValidButtonModel(
                isValid: (mainStock == 0),
                errorType: ErrorTypeEnum.valueOfString,
                overwriteRule: "value must equal 0.",
                errorLocationList: [
                  TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                  TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                  TitleAndSubtitleModel(
                    title: "Total Stock",
                    subtitle: "${formatAndLimitNumberTextGlobal(valueStr: mainStock.toString(), isRound: false)} card",
                  ),
                ],
                error: "Total Stock is not equal 0.",
              );
            }
          }

          Widget editCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
            Widget columnWidget() {
              Widget companyNameTextFieldAndLanguageWidget() {
                Widget companyNameTextFieldWidget() {
                  void onChangeFromOutsiderFunction() {
                    setStateFromDialog(() {});
                  }

                  void onTapFromOutsiderFunction() {}
                  return textFieldGlobal(
                    // textFieldWidth: cardCompanyNameTextFieldWidthGlobal,
                    isEnabled: (deleteDateOrNull == null),
                    controller: cardTemp.cardCompanyName,
                    onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                    labelText: cardCompanyNameStrGlobal,
                    level: Level.normal,
                    textFieldDataType: TextFieldDataType.str,
                    onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                  );
                }

                Widget textFieldCompanyNameWidget() {
                  return SizedBox(width: nameTextFieldWidthGlobal, child: companyNameTextFieldWidget());
                }

                Widget deleteDateScrollTextWidget() {
                  return (deleteDateOrNull == null)
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)),
                          child: scrollText(
                            textStr: "$deleteAtStrGlobal ${formatFullDateToStr(date: deleteDateOrNull.add(const Duration(days: deleteAtDay)))}",
                            textStyle: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold, color: Colors.red),
                            alignment: Alignment.topCenter,
                          ),
                        );
                }

                return Row(children: [textFieldCompanyNameWidget(), deleteDateScrollTextWidget()]);
              }

              Widget paddingVerticalWidget() {
                Widget categoryWidget() {
                  Widget categoryListFixSizeWidget() {
                    final bool isMinWidth = (screenSizeFromDialog.width < minWithGlobal);
                    Widget addButtonWidget() {
                      ValidButtonModel validateToAddMoreCategory() {
                        // final String companyStr = cardTemp.cardCompanyName.text;
                        if (cardTemp.categoryList.isNotEmpty) {
                          for (int categoryIndex = 0; categoryIndex < cardTemp.categoryList.length; categoryIndex++) {
                            final bool isCategoryTextEmpty = cardTemp.categoryList[categoryIndex].category.text.isEmpty;
                            if (isCategoryTextEmpty) {
                              // return ValidButtonModel(isValid: false, errorStr: "Category textfield of $companyStr is blank");
                              return ValidButtonModel(
                                isValid: false,
                                errorType: ErrorTypeEnum.valueOfNumber,
                                errorLocationList: [
                                  TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                                  TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                                ],
                                error: "Category is empty.",
                              );
                            }
                            // return false;
                            if (textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].category)! == 0) {
                              // return ValidButtonModel(isValid: false, errorStr: "$companyStr category must not value 0");
                              return ValidButtonModel(
                                isValid: false,
                                errorType: ErrorTypeEnum.valueOfNumber,
                                errorLocationList: [
                                  TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                                  TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                                ],
                                error: "Category is equal 0.",
                              );
                            }
                          }
                        } else {
                          selectedCategoryIndex = 0;
                        }
                        // return (deleteDateOrNull == null);
                        // return ValidButtonModel(isValid: (deleteDateOrNull == null), errorStr: "$companyStr has been deleted");
                        return ValidButtonModel(
                          isValid: (deleteDateOrNull == null),
                          errorType: ErrorTypeEnum.deleted,
                          errorLocationList: [
                            TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                          ],
                          error: "Already deleted.",
                        );
                      }

                      void onTapFunction() {
                        // cardTemp.categoryList[selectedCategoryIndex].skipCardMainStockList = queryLimitNumberGlobal;
                        // cardTemp.categoryList[selectedCategoryIndex].outOfDataQueryCardMainStockList = false;
                        CardSellPriceListCardModel initCardCategoryListModel = CardSellPriceListCardModel(
                          startValue: TextEditingController(),
                          endValue: TextEditingController(),
                          price: TextEditingController(),
                          moneyType: null,
                        );
                        cardTemp.categoryList.add(CardCategoryListCardModel(
                          totalStock: 0, count: 0, ordered: 0,
                          category: TextEditingController(),
                          mainPriceList: [],
                          sellPriceList: [initCardCategoryListModel],
                          qty: TextEditingController(),
                          limitList: [],
                          // mainPriceSeparateByPercentageList: [],
                        ));
                        selectedCategoryIndex = cardTemp.categoryList.length - 1;
                        setStateFromDialog(() {});
                      }

                      Widget addButtonProvider() {
                        Widget maxAddButtonWidget() {
                          return addButtonOrContainerWidget(
                            context: context,
                            level: Level.mini,
                            onTapFunction: onTapFunction,
                            validModel: validateToAddMoreCategory(),
                            maxAddButtonLimit: cardCategoryAddButtonLimitGlobal,
                            currentAddButtonQty: cardTemp.categoryList.length,
                          );
                        }

                        Widget minAddButtonWidget() {
                          return buttonGlobal(
                            context: context,
                            level: Level.mini,
                            onTapUnlessDisableAndValid: onTapFunction,
                            validModel: validateToAddMoreCategory(),
                            icon: createIconGlobal,
                            colorSideBox: addButtonColorGlobal,
                          );
                        }

                        return isMinWidth ? minAddButtonWidget() : maxAddButtonWidget();
                      }

                      return addButtonProvider();
                    }

                    Widget paddingTopCategoryButtonWidget({required String? category, required int categoryIndex}) {
                      Widget categoryButtonWidget() {
                        final isTextStrNot = (category == null);
                        final String textOrEmptyStr = isTextStrNot ? emptyStrGlobal : category;
                        final bool isSelected = (categoryIndex == selectedCategoryIndex);
                        void onTapUnlessDisableAndValid() {
                          selectedCategoryIndex = categoryIndex;

                          limitMainStockList(categoryCardModel: cardTemp.categoryList[categoryIndex]);
                          // cardTemp.categoryList[selectedCategoryIndex].mainPriceList
                          setStateFromDialog(() {});
                        }

                        String? textProvider() {
                          return isMinWidth ? null : textOrEmptyStr;
                        }

                        MainAxisAlignment mainAxisAlignmentProvider() {
                          return isMinWidth ? MainAxisAlignment.center : MainAxisAlignment.start;
                        }

                        DateTime? deleteCategoryDateOrNull = (selectedCategoryIndex == -1) ? null : cardTemp.categoryList[categoryIndex].deletedDate;
                        return buttonGlobal(
                          context: context,
                          mainAxisAlignment: mainAxisAlignmentProvider(),
                          level: Level.normal,
                          isDisable: isSelected,
                          onTapUnlessDisableAndValid: onTapUnlessDisableAndValid,
                          textStr: textProvider(),
                          icon: Icons.sim_card,
                          colorSideBox: optionContainerColor,
                          colorTextAndIcon: (deleteCategoryDateOrNull == null) ? optionTextAndIconColorGlobal : deleteTextColorGlobal,
                        );
                      }

                      return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)), child: categoryButtonWidget());
                    }

                    double categoryLisWidthProvider() {
                      return isMinWidth ? categoryListMinWidthGlobal : categoryListMaxWidthGlobal;
                    }

                    return SizedBox(
                      width: categoryLisWidthProvider(),
                      child: SingleChildScrollView(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                          addButtonWidget(),
                          for (int categoryIndex = 0; categoryIndex < cardTemp.categoryList.length; categoryIndex++)
                            paddingTopCategoryButtonWidget(category: cardTemp.categoryList[categoryIndex].category.text, categoryIndex: categoryIndex)
                        ]),
                      ),
                    );
                  }

                  Widget categoryDetailExpandedWidget() {
                    DateTime? deleteCategoryDateOrNull = ((selectedCategoryIndex == -1) || cardTemp.categoryList.isEmpty) ? null : cardTemp.categoryList[selectedCategoryIndex].deletedDate;
                    Widget categoryDetailOrEmpty() {
                      Widget paddingColumnWidget() {
                        Widget columnWidget() {
                          Widget rowTextFieldAndDeleteButton() {
                            Widget deleteDateScrollTextWidget() {
                              final String totalStockStr = formatAndLimitNumberTextGlobal(
                                valueStr: cardTemp.categoryList[selectedCategoryIndex].totalStock.toString(),
                                isRound: false,
                              );
                              return Padding(
                                padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)),
                                child: (deleteCategoryDateOrNull == null)
                                    ? scrollText(
                                        textStr: "$totalStockStrGlobal: $totalStockStr card",
                                        textStyle: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                                        alignment: Alignment.topCenter,
                                      )
                                    : scrollText(
                                        textStr: "$deleteAtStrGlobal ${formatFullDateToStr(date: deleteCategoryDateOrNull.add(const Duration(days: deleteAtDay)))}",
                                        textStyle: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold, color: Colors.red),
                                        alignment: Alignment.topCenter,
                                      ),
                              );
                            }

                            Widget paddingRightTextFieldWidget() {
                              Widget textFieldWidget() {
                                void onTapFromOutsiderFunction() {}
                                return textFieldGlobal(
                                  isEnabled: ((deleteCategoryDateOrNull == null) && (deleteDateOrNull == null)),
                                  onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                                  textFieldWidth: nameTextFieldTextFieldWidthGlobal,
                                  controller: cardTemp.categoryList[selectedCategoryIndex].category,
                                  onChangeFromOutsiderFunction: () {
                                    setStateFromDialog(() {});
                                  },
                                  labelText: categoryCardStrGlobal,
                                  level: Level.normal,
                                  textFieldDataType: TextFieldDataType.double,
                                );
                              }

                              return Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)), child: textFieldWidget());
                            }

                            Widget deleteButtonWidget() {
                              void onTapFunction() {
                                if (cardTemp.categoryList[selectedCategoryIndex].id != null) {
                                  void okFunction() {
                                    void callback() {
                                      setState(() {});
                                    }

                                    //close the rate dialog
                                    closeDialogGlobal(context: context);

                                    deleteCardCategoryGlobal(
                                      callBack: callback,
                                      context: context,
                                      cardId: cardTemp.id!,
                                      categoryId: cardTemp.categoryList[selectedCategoryIndex].id!,
                                    ); //delete the existing card in database and local storage
                                  }

                                  void cancelFunction() {}
                                  confirmationDialogGlobal(
                                    context: context,
                                    okFunction: okFunction,
                                    cancelFunction: cancelFunction,
                                    titleStr:
                                        "$deleteGlobal ${cardTemp.cardCompanyName.text} x ${formatAndLimitNumberTextGlobal(valueStr: cardTemp.categoryList[selectedCategoryIndex].category.text.toString(), isRound: false)}",
                                    subtitleStr: deleteConfirmGlobal,
                                  );
                                } else {
                                  cardTemp.categoryList.removeAt(selectedCategoryIndex);
                                  selectedCategoryIndex = -1;
                                  setStateFromDialog(() {});
                                }
                              }

                              ValidButtonModel isValidToDelete() {
                                final bool isMainCardNotEmpty = cardTemp.categoryList[selectedCategoryIndex].mainPriceList.isNotEmpty;
                                // final String companyStr = cardTemp.cardCompanyName.text;
                                // final String categoryStr = cardTemp.categoryList[selectedCategoryIndex].category.text;
                                if (isMainCardNotEmpty) {
                                  // return false;
                                  // return ValidButtonModel(isValid: false, errorStr: "Stock of $companyStr x $categoryStr must be empty");
                                  return ValidButtonModel(
                                    isValid: false,
                                    errorType: ErrorTypeEnum.arrayLength,
                                    errorLocationList: [
                                      TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                                      TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[selectedCategoryIndex].category.text),
                                      TitleAndSubtitleModel(
                                        title: "Card Stock Length",
                                        subtitle: cardTemp.categoryList[selectedCategoryIndex].mainPriceList.length.toString(),
                                      ),
                                    ],
                                    error: "Card Stock Length is not equal 0.",
                                  );
                                }
                                // return (deleteDateOrNull == null) && isNoMainCardStock(categoryIndex: selectedCategoryIndex);
                                if (deleteDateOrNull != null) {
                                  // return ValidButtonModel(isValid: false, errorStr: "$companyStr x $categoryStr has been deleted");
                                  return ValidButtonModel(
                                    isValid: false,
                                    errorType: ErrorTypeEnum.deleted,
                                    errorLocationList: [
                                      TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                                    ],
                                    error: "Already deleted.",
                                  );
                                }
                                return isNoMainCardStock(categoryIndex: selectedCategoryIndex);
                              }

                              return deleteButtonOrContainerWidget(context: context, validModel: isValidToDelete(), level: Level.normal, onTapFunction: onTapFunction);
                            }

                            Widget restoreButtonWidget() {
                              void onTapFunction() {
                                void okFunction() {
                                  void callback() {
                                    setState(() {});
                                  }

                                  //close the rate dialog
                                  closeDialogGlobal(context: context);

                                  restoreCardCategoryGlobal(
                                    callBack: callback,
                                    context: context,
                                    cardId: cardTemp.id!,
                                    categoryId: cardTemp.categoryList[selectedCategoryIndex].id!,
                                  ); //delete the existing card in database and local storage
                                }

                                void cancelFunction() {}
                                confirmationDialogGlobal(
                                  context: context,
                                  okFunction: okFunction,
                                  cancelFunction: cancelFunction,
                                  titleStr:
                                      "$restoreGlobal ${cardTemp.cardCompanyName.text} x ${formatAndLimitNumberTextGlobal(valueStr: cardTemp.categoryList[selectedCategoryIndex].category.text.toString(), isRound: false)}",
                                  subtitleStr: restoreConfirmGlobal,
                                );
                              }

                              ValidButtonModel isValidToDelete() {
                                final bool isMainCardNotEmpty = cardTemp.categoryList[selectedCategoryIndex].mainPriceList.isNotEmpty;
                                // final String companyStr = cardTemp.cardCompanyName.text;
                                // final String categoryStr = cardTemp.categoryList[selectedCategoryIndex].category.text;
                                if (isMainCardNotEmpty) {
                                  // return false;
                                  // return ValidButtonModel(isValid: false, errorStr: "Stock of $companyStr x $categoryStr must be empty");
                                  return ValidButtonModel(
                                    isValid: false,
                                    errorType: ErrorTypeEnum.deleted,
                                    errorLocationList: [
                                      TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                                      TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[selectedCategoryIndex].category.text),
                                    ],
                                    error: "Already Deleted",
                                  );
                                }
                                // return (deleteDateOrNull == null);
                                // return ValidButtonModel(isValid: (deleteDateOrNull == null), errorStr: "$companyStr x $categoryStr has been restored");

                                return ValidButtonModel(
                                  isValid: (deleteDateOrNull == null),
                                  errorType: ErrorTypeEnum.deleted,
                                  errorLocationList: [
                                    TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                                  ],
                                  error: "Already deleted.",
                                );
                              }

                              return restoreButtonOrContainerWidget(context: context, validModel: isValidToDelete(), level: Level.normal, onTapFunction: onTapFunction);
                            }

                            return Row(children: [
                              paddingRightTextFieldWidget(),
                              ((deleteCategoryDateOrNull == null) || (deleteDateOrNull != null)) ? deleteButtonWidget() : Container(),
                              (deleteCategoryDateOrNull == null) ? Container() : restoreButtonWidget(),
                              deleteDateScrollTextWidget(),
                            ]);
                          }

                          Widget paddingTopTableWidget() {
                            Widget rowTableAndMainPriceWidget() {
                              Widget tableWidget() {
                                final List<TextEditingController> headerList = [
                                  TextEditingController(text: startCardStrGlobal),
                                  TextEditingController(text: endCardStrGlobal),
                                  TextEditingController(text: priceCardStrGlobal),
                                  TextEditingController(text: typeCardStrGlobal),
                                  TextEditingController(text: ""),
                                ];
                                final List<int> expandedList = [2, 2, 2, 1, 0];
                                final List<WidgetType> widgetTypeList = ((deleteCategoryDateOrNull == null) && (deleteDateOrNull == null))
                                    ? [WidgetType.textFieldInt, WidgetType.textFieldInt, WidgetType.textFieldDouble, WidgetType.dropDown, WidgetType.hiddenText]
                                    : [WidgetType.text, WidgetType.text, WidgetType.text, WidgetType.text, WidgetType.hiddenText];

                                // final List<List<String>> menuItemStr3D = [[], [], [], moneyTypeOnlyList()];

                                List<List<TextEditingController>> textFieldController2D = [];
                                List<List<List<String>>> menuItemStr3D = [];
                                List<List<bool>> isShowTextField2D = [];

                                void convertSellPriceCardModelIntoTable() {
                                  for (int sellPriceIndex = 0; sellPriceIndex < cardTemp.categoryList[selectedCategoryIndex].sellPriceList.length; sellPriceIndex++) {
                                    List<TextEditingController> controller1D = [];
                                    final TextEditingController startValue = cardTemp.categoryList[selectedCategoryIndex].sellPriceList[sellPriceIndex].startValue;
                                    controller1D.add(startValue);
                                    final TextEditingController endValue = cardTemp.categoryList[selectedCategoryIndex].sellPriceList[sellPriceIndex].endValue;
                                    controller1D.add(endValue);
                                    final TextEditingController price = cardTemp.categoryList[selectedCategoryIndex].sellPriceList[sellPriceIndex].price;
                                    controller1D.add(price);
                                    final TextEditingController moneyType = TextEditingController(text: cardTemp.categoryList[selectedCategoryIndex].sellPriceList[sellPriceIndex].moneyType);
                                    controller1D.add(moneyType);
                                    final TextEditingController id = TextEditingController(text: cardTemp.categoryList[selectedCategoryIndex].sellPriceList[sellPriceIndex].id);
                                    controller1D.add(id);
                                    textFieldController2D.add(controller1D);

                                    final List<List<String>> menuItemStr2D = [[], [], [], moneyTypeOnlyList(moneyTypeDefault: moneyType.text, isNotCheckDeleted: true), []];
                                    menuItemStr3D.add(menuItemStr2D);

                                    final List<bool> isShowTextFieldList = [false, false, false, false, false];
                                    isShowTextField2D.add(isShowTextFieldList);
                                  }
                                }

                                void convertTableIntoSellPriceCardModel({
                                  required List<List<TextEditingController>> controller2D,
                                  required List<List<bool>> isShowTextField2D,
                                  required List<List<TextEditingController>> oldController2D,
                                  required List<List<bool>> oldIsShowTextField2D,
                                  required int horizontalIndex,
                                  required int verticalIndex,
                                  required ActiveLogTypeEnum activeLog,
                                }) {
                                  cardTemp.categoryList[selectedCategoryIndex].sellPriceList = [];
                                  for (int colIndex = 0; colIndex < controller2D.length; colIndex++) {
                                    CardSellPriceListCardModel cardSellPriceListModel = CardSellPriceListCardModel(
                                      startValue: controller2D[colIndex][0],
                                      endValue: controller2D[colIndex][1],
                                      price: controller2D[colIndex][2],
                                      moneyType: controller2D[colIndex][3].text,
                                      id: controller2D[colIndex][4].text,
                                    );
                                    cardTemp.categoryList[selectedCategoryIndex].sellPriceList.add(cardSellPriceListModel);
                                  }

                                  for (int categoryIndex = 0; categoryIndex < cardTemp.categoryList.length; categoryIndex++) {
                                    for (int sellIndex = 0; sellIndex < cardTemp.categoryList[categoryIndex].sellPriceList.length; sellIndex++) {
                                      bool isExistOnSellMoneyType = false;
                                      if (cardTemp.categoryList[categoryIndex].sellPriceList[sellIndex].moneyType != null) {
                                        if (cardTemp.categoryList[categoryIndex].sellPriceList[sellIndex].moneyType!.isNotEmpty) {
                                          for (int limitIndex = 0; limitIndex < cardTemp.categoryList[categoryIndex].limitList.length; limitIndex++) {
                                            if (cardTemp.categoryList[categoryIndex].limitList[limitIndex].moneyType == cardTemp.categoryList[categoryIndex].sellPriceList[sellIndex].moneyType) {
                                              isExistOnSellMoneyType = true;
                                              break;
                                            }
                                          }
                                          if (!isExistOnSellMoneyType) {
                                            cardTemp.categoryList[categoryIndex].limitList.add(LimitModel(
                                              moneyType: cardTemp.categoryList[categoryIndex].sellPriceList[sellIndex].moneyType,
                                              limit: [TextEditingController(), TextEditingController()],
                                            ));
                                          }
                                        }
                                      }
                                    }

                                    for (int limitIndex = 0; limitIndex < cardTemp.categoryList[categoryIndex].limitList.length; limitIndex++) {
                                      bool isExistOnLimitMoneyType = false;
                                      for (int sellIndex = 0; sellIndex < cardTemp.categoryList[categoryIndex].sellPriceList.length; sellIndex++) {
                                        if (cardTemp.categoryList[categoryIndex].limitList[limitIndex].moneyType == cardTemp.categoryList[categoryIndex].sellPriceList[sellIndex].moneyType) {
                                          isExistOnLimitMoneyType = true;
                                          break;
                                        }
                                      }
                                      if (!isExistOnLimitMoneyType) {
                                        cardTemp.categoryList[categoryIndex].limitList.removeAt(limitIndex);
                                      }
                                    }
                                  }

                                  setStateFromDialog(() {});
                                }

                                convertSellPriceCardModelIntoTable();
                                return TableGlobalWidget(
                                  // callbackList: callbackList,
                                  expandedList: expandedList,
                                  isShowDeleteButton: ((deleteCategoryDateOrNull == null) && (deleteDateOrNull == null)),
                                  textFieldController2D: textFieldController2D,
                                  headerList: headerList,
                                  widgetTypeList: widgetTypeList,
                                  menuItemStr3D: menuItemStr3D,
                                  returnIsShowAndTextFieldController2DFunction: convertTableIntoSellPriceCardModel,
                                  isShowTextField2D: isShowTextField2D,
                                  isDisableAddMoreButton: !((deleteCategoryDateOrNull == null) || (deleteDateOrNull == null)),
                                  currentAddButtonQty: textFieldController2D.length,
                                  maxAddButtonLimit: cardPriceSetUpAddButtonLimitGlobal,
                                );
                              }

                              Widget mainPriceOrContainerWidget() {
                                Widget paddingMainPriceWidget() {
                                  Widget mainPriceFixWidget() {
                                    Widget mainCardWidget({required int mainCardIndex}) {
                                      Widget insideSizeBoxWidget() {
                                        Widget employeeWidget() {
                                          final String? employeeIdStr = cardTemp.categoryList[selectedCategoryIndex].mainPriceList[mainCardIndex].employeeId;
                                          final String? employeeNameStr = cardTemp.categoryList[selectedCategoryIndex].mainPriceList[mainCardIndex].employeeName;
                                          return scrollText(textStr: "$employeeNameStr ($employeeIdStr)", textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.topLeft);
                                        }

                                        Widget stockWidget() {
                                          final String stockStr = formatAndLimitNumberTextGlobal(
                                            valueStr: cardTemp.categoryList[selectedCategoryIndex].mainPriceList[mainCardIndex].stock.text,
                                            isRound: false,
                                            isAllowZeroAtLast: false,
                                          );
                                          final String maxStockStr = formatAndLimitNumberTextGlobal(
                                            valueStr: cardTemp.categoryList[selectedCategoryIndex].mainPriceList[mainCardIndex].maxStock.toString(),
                                            isRound: false,
                                            isAllowZeroAtLast: false,
                                          );
                                          return scrollText(textStr: "$stockCardStrGlobal: $stockStr/$maxStockStr", textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.topLeft);
                                        }

                                        Widget mainPriceWidget() {
                                          final String priceStr = formatAndLimitNumberTextGlobal(
                                            valueStr: cardTemp.categoryList[selectedCategoryIndex].mainPriceList[mainCardIndex].price.text,
                                            isRound: false,
                                            isAllowZeroAtLast: false,
                                          );
                                          final String moneyTypeStr = cardTemp.categoryList[selectedCategoryIndex].mainPriceList[mainCardIndex].moneyType!;

                                          return scrollText(textStr: "$mainPriceCardStrGlobal: $priceStr $moneyTypeStr", textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.topLeft);
                                        }

                                        Widget rateListWidget() {
                                          Widget rateWidget({required int rateIndex}) {
                                            final bool isBuyRate = cardTemp.categoryList[selectedCategoryIndex].mainPriceList[mainCardIndex].rateList[rateIndex].isBuyRate!;
                                            final List<String> rateType = cardTemp.categoryList[selectedCategoryIndex].mainPriceList[mainCardIndex].rateList[rateIndex].rateType;
                                            final String discountRateStr = cardTemp.categoryList[selectedCategoryIndex].mainPriceList[mainCardIndex].rateList[rateIndex].discountValue.text;
                                            final String rateStr = isBuyRate ? "${rateType.first}$arrowStrGlobal${rateType.last}" : "${rateType.last}$arrowStrGlobal${rateType.first}";
                                            final String percentageRateStr = cardTemp.categoryList[selectedCategoryIndex].mainPriceList[mainCardIndex].rateList[rateIndex].percentage.text;

                                            return Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [Text("$percentageRateStr % | $rateStr: $discountRateStr", style: textStyleGlobal(level: Level.mini))]);
                                          }

                                          return Column(children: [
                                            for (int rateIndex = 0; rateIndex < cardTemp.categoryList[selectedCategoryIndex].mainPriceList[mainCardIndex].rateList.length; rateIndex++)
                                              rateWidget(rateIndex: rateIndex)
                                          ]);
                                        }

                                        Widget dateWidget() {
                                          final String dateStr = formatFullDateToStr(date: cardTemp.categoryList[selectedCategoryIndex].mainPriceList[mainCardIndex].date!);

                                          return Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text(dateStr, style: textStyleGlobal(level: Level.mini))]);
                                        }

                                        return Column(children: [employeeWidget(), stockWidget(), mainPriceWidget(), rateListWidget(), dateWidget()]);
                                      }

                                      void onTapUnlessDisable() {}
                                      return CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
                                    }

                                    void bottomFunction() {
                                      //   if (!outOfDataQueryCardMainStockListGlobal) {
                                      //     //TODO: change this
                                      //     final int beforeQuery = cardTemp.categoryList[selectedCategoryIndex].mainPriceList.length; //TODO: change this
                                      //     void callBack() {
                                      //       final int afterQuery = cardTemp.categoryList[selectedCategoryIndex].mainPriceList.length; //TODO: change this

                                      //       if (beforeQuery == afterQuery) {
                                      //         outOfDataQueryCardMainStockListGlobal = true; //TODO: change this
                                      //       } else {
                                      //         skipCardMainStockListGlobal = skipCardMainStockListGlobal + queryLimitNumberGlobal; //TODO: change this
                                      //       }
                                      //       setStateFromDialog(() {});
                                      //     }

                                      //     getMainCardListAdminGlobal(
                                      //       callBack: callBack,
                                      //       cardCompanyNameId: cardTemp.id!,
                                      //       categoryId: cardTemp.categoryList[selectedCategoryIndex].id!,
                                      //       context: context,
                                      //       skip: skipCardMainStockListGlobal,
                                      //       cardMainPriceListCardModelList: cardTemp.categoryList[selectedCategoryIndex].mainPriceList,
                                      //     ); //TODO: change this
                                      //   }

                                      getMoreMainStockWithCondition(
                                        targetDate: DateTime.now(),
                                        isAdminQuery: true,
                                        cardCompanyNameId: cardTemp.id!,
                                        categoryId: cardTemp.categoryList[selectedCategoryIndex].id!,
                                        categoryCardModel: cardTemp.categoryList[selectedCategoryIndex],
                                        context: context,
                                        setStateFromDialog: setStateFromDialog,
                                      );
                                    }

                                    void topFunction() {}
                                    return SizedBox(
                                      width: sizeBoxWidthGlobal,
                                      child: wrapScrollDetectWidget(
                                        bottomFunction: bottomFunction,
                                        isShowSeeMoreWidget: !cardTemp.categoryList[selectedCategoryIndex].outOfDataQueryCardMainStockList,
                                        topFunction: topFunction,
                                        inWrapWidgetList: [
                                          for (int mainCardIndex = 0; mainCardIndex < cardTemp.categoryList[selectedCategoryIndex].mainPriceList.length; mainCardIndex++)
                                            mainCardWidget(mainCardIndex: mainCardIndex)
                                        ],
                                      ),
                                    );
                                    // return SingleChildScrollView(
                                    //   child: Padding(
                                    //     padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                                    //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                    //       for (int mainCardIndex = 0;
                                    //           mainCardIndex < cardTemp.categoryList[selectedCategoryIndex].mainPriceList.length;
                                    //           mainCardIndex++)
                                    //         mainCardWidget(mainCardIndex: mainCardIndex)
                                    //     ]),
                                    //   ),
                                    // );
                                  }

                                  return mainPriceFixWidget();
                                }

                                if (isCreateNewCard) {
                                  return Container();
                                } else {
                                  final bool isMainPriceEmpty = cardTemp.categoryList[selectedCategoryIndex].mainPriceList.isEmpty;
                                  if (isMainPriceEmpty) {
                                    return Container();
                                  } else {
                                    return paddingMainPriceWidget();
                                  }
                                }
                              }

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Expanded(child: tableWidget()), mainPriceOrContainerWidget()],
                              );
                            }

                            return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)), child: rowTableAndMainPriceWidget());
                          }

                          Widget limitPriceCardWidget() {
                            Widget limitWidget({required int limitIndex}) {
                              Widget insideSizeBoxWidget() {
                                Widget moneyTypeTextWidget() {
                                  return Text(
                                    "$maximumStrGlobal and $minimumStrGlobal $priceCardStrGlobal of ${cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].moneyType}",
                                    style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                                  );
                                }

                                Widget textFieldWidget({required String contentStr, required TextEditingController controller}) {
                                  void onTapFromOutsiderFunction() {}
                                  return textFieldGlobal(
                                    isEnabled: ((deleteCategoryDateOrNull == null) && (deleteDateOrNull == null)),
                                    onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                                    textFieldWidth: nameTextFieldTextFieldWidthGlobal,
                                    controller: controller,
                                    onChangeFromOutsiderFunction: () {
                                      setStateFromDialog(() {});
                                    },
                                    labelText: contentStr,
                                    level: Level.normal,
                                    textFieldDataType: TextFieldDataType.double,
                                  );
                                }

                                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  moneyTypeTextWidget(),
                                  Row(children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal), right: paddingSizeGlobal(level: Level.mini)),
                                        child: textFieldWidget(contentStr: minimumStrGlobal, controller: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.first),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal), left: paddingSizeGlobal(level: Level.mini)),
                                        child: textFieldWidget(contentStr: maximumStrGlobal, controller: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.last),
                                      ),
                                    ),
                                  ])
                                ]);
                              }

                              void onTapUnlessDisable() {}

                              return Padding(
                                padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini), right: paddingSizeGlobal(level: Level.mini)),
                                child: CustomButtonGlobal(sizeBoxWidth: sizeBoxWidthGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable),
                              );
                            }

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                                child: Row(children: [
                                  for (int limitIndex = 0; limitIndex < cardTemp.categoryList[selectedCategoryIndex].limitList.length; limitIndex++) limitWidget(limitIndex: limitIndex),
                                ]),
                              ),
                            );
                          }

                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [rowTextFieldAndDeleteButton(), limitPriceCardWidget(), Expanded(child: paddingTopTableWidget())]);
                        }

                        return Padding(padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)), child: columnWidget());
                      }

                      final bool isHideCategoryDetail = (cardTemp.categoryList.isEmpty || selectedCategoryIndex == -1);
                      return isHideCategoryDetail ? Container() : paddingColumnWidget();
                    }

                    return Expanded(child: categoryDetailOrEmpty());
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [categoryListFixSizeWidget(), categoryDetailExpandedWidget()],
                  );
                }

                return Expanded(child: Padding(padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.normal)), child: categoryWidget()));
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [companyNameTextFieldAndLanguageWidget(), paddingVerticalWidget()],
              );
            }

            return columnWidget();
          }

          void cancelFunctionOnTap() {
            void okFunction() {
              adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.card);
              if (selectedCategoryIndex != -1) {
                limitMainStockList(categoryCardModel: cardTemp.categoryList[selectedCategoryIndex]);
              }
              closeDialogGlobal(context: context);
            }

            void cancelFunction() {}
            confirmationDialogGlobal(context: context, okFunction: okFunction, cancelFunction: cancelFunction, titleStr: cancelEditingSettingGlobal, subtitleStr: cancelEditingSettingConfirmGlobal);
          }

          void saveFunctionOnTap() {
            void callback() {
              adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.card);
              setState(() {});
            }

            //close the rate dialog
            closeDialogGlobal(context: context);

            updateCardGlobal(callBack: callback, context: context, cardTemp: cardTemp);
          }

          ValidButtonModel validSaveButtonFunction() {
            //check null on value
            final bool isCardCompanyNameEmpty = cardTemp.cardCompanyName.text.isEmpty;
            if (isCardCompanyNameEmpty) {
              // return false;
              // return ValidButtonModel(isValid: false, errorStr: "Card company name must not be empty");
              return ValidButtonModel(
                isValid: false,
                errorType: ErrorTypeEnum.valueOfString,
                // errorLocationList: [
                //   TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                // ],
                error: "Company Name is empty.",
              );
            }
            for (int categoryIndex = 0; categoryIndex < cardTemp.categoryList.length; categoryIndex++) {
              final bool isCategoryEmpty = cardTemp.categoryList[categoryIndex].category.text.isEmpty;
              if (isCategoryEmpty) {
                // return false;
                // return ValidButtonModel(isValid: false, errorStr: "Category textfield of ${cardTemp.cardCompanyName.text} is blank.");

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.valueOfString,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                    TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                  ],
                  error: "Category is empty.",
                );
              } else {
                if (textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].category) == 0) {
                  // return false;
                  // return ValidButtonModel(isValid: false, errorStr: "Category textfield of ${cardTemp.cardCompanyName.text} must not value 0.");
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfString,
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                      TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                    ],
                    error: "Category equal 0.",
                  );
                }
              }

              if (categoryIndex != selectedCategoryIndex) {
                if (selectedCategoryIndex != -1) {
                  if (textEditingControllerToDouble(controller: cardTemp.categoryList[selectedCategoryIndex].category) ==
                      textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].category)) {
                    // return false;
                    // final String companyStr = cardTemp.cardCompanyName.text;
                    // final String categoryStr = cardTemp.categoryList[categoryIndex].category.text;
                    // return ValidButtonModel(isValid: false, errorStr: "Category ($categoryStr) textfield of $companyStr must be unique.");
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.valueUnique,
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                        TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                      ],
                      error: "Category is same as previous save.",
                    );
                  }
                }
              }

              if (selectedCategoryIndex != -1) {
                // final String companyNameStr = cardTemp.cardCompanyName.text;
                // final String categoryStr = cardTemp.categoryList[selectedCategoryIndex].category.text;
                for (int limitIndex = 0; limitIndex < cardTemp.categoryList[selectedCategoryIndex].limitList.length; limitIndex++) {
                  if (cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].moneyType == null) {
                    // return false;
                    // return ValidButtonModel(isValid: false, errorStr: "Money type of $companyNameStr x $categoryStr must not be empty.");
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.valueOfString,
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                        TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                      ],
                      error: "Category is equal 0.",
                    );
                  }
                  if (cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.isEmpty) {
                    // return false;
                    // return ValidButtonModel(isValid: false, errorStr: "Limit of $companyNameStr x $categoryStr must not be empty.");
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.arrayLength,
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                        TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[selectedCategoryIndex].category.text),
                        TitleAndSubtitleModel(
                          title: "Limit Length",
                          subtitle: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.length.toString(),
                        ),
                      ],
                      error: "Limit Length is equal 0.",
                    );
                  }
                  if (cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.length < 2) {
                    // return false;
                    // return ValidButtonModel(isValid: false, errorStr: "Limit of $companyNameStr x $categoryStr must have 2 value.");

                    return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.compareNumber,
                        overwriteRule: "Limit Length Must be 2",
                        errorLocationList: [
                          TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                          TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[selectedCategoryIndex].category.text),
                          TitleAndSubtitleModel(
                            title: "Limit Length",
                            subtitle: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.length.toString(),
                          ),
                        ],
                        error: "Limit Length is equal ${cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.length.toString()}.",
                        detailList: [
                          TitleAndSubtitleModel(
                            title: "${cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.length.toString()} == 2",
                            subtitle: "Invalid compare",
                          ),
                        ]);
                  }
                  if (cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.first.text.isEmpty) {
                    // return false;
                    // return ValidButtonModel(isValid: false, errorStr: "Minimum $priceCardStrGlobal of $companyNameStr x $categoryStr must not be empty.");
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.valueOfNumber,
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                        TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[selectedCategoryIndex].category.text),
                        TitleAndSubtitleModel(
                          title: "Minimum (${cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].moneyType})",
                          subtitle: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.first.text,
                        ),
                      ],
                      error: "Minimum value is empty.",
                    );
                  } else {
                    if (textEditingControllerToDouble(controller: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.first) == 0) {
                      // return false;
                      // return ValidButtonModel(isValid: false, errorStr: "Minimum $priceCardStrGlobal of $companyNameStr x $categoryStr must not value 0.");
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.valueOfNumber,
                        errorLocationList: [
                          TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                          TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[selectedCategoryIndex].category.text),
                          TitleAndSubtitleModel(
                            title: "Minimum (${cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].moneyType})",
                            subtitle: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.first.text,
                          ),
                        ],
                        error: "Minimum value is 0.",
                      );
                    }
                  }
                  if (cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.last.text.isEmpty) {
                    // return false;
                    // return ValidButtonModel(isValid: false, errorStr: "Maximum $priceCardStrGlobal of $companyNameStr x $categoryStr must not be empty.");
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.valueOfNumber,
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                        TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[selectedCategoryIndex].category.text),
                        TitleAndSubtitleModel(
                          title: "Maximum (${cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].moneyType})",
                          subtitle: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.last.text,
                        ),
                      ],
                      error: "Maximum value is empty.",
                    );
                  } else {
                    if (textEditingControllerToDouble(controller: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.last) == 0) {
                      // return false;
                      // return ValidButtonModel(isValid: false, errorStr: "Maximum $priceCardStrGlobal of $companyNameStr x $categoryStr must not value 0.");
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.valueOfNumber,
                        errorLocationList: [
                          TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                          TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[selectedCategoryIndex].category.text),
                          TitleAndSubtitleModel(
                            title: "Maximum (${cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].moneyType})",
                            subtitle: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.last.text,
                          ),
                        ],
                        error: "Maximum value is 0.",
                      );
                    }
                  }
                  final TextEditingController limitFirstController = cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.first;
                  final TextEditingController limitLastController = cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.last;
                  if (textEditingControllerToDouble(controller: limitFirstController)! == textEditingControllerToDouble(controller: limitLastController)!) {
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.compareNumber,
                      overwriteRule: "Minimum < Maximum",
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                        TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[selectedCategoryIndex].category.text),
                        TitleAndSubtitleModel(
                          title: "Minimum (${cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].moneyType})",
                          subtitle: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.first.text,
                        ),
                        TitleAndSubtitleModel(
                          title: "Maximum (${cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].moneyType})",
                          subtitle: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.last.text,
                        ),
                      ],
                      error: "Minimum value is equal to maximum value.",
                      detailList: [
                        TitleAndSubtitleModel(
                          title: "${limitFirstController.text} < ${limitLastController.text}",
                          subtitle: "Invalid compare",
                        ),
                      ],
                    );
                  }
                  if (textEditingControllerToDouble(controller: limitFirstController)! >= textEditingControllerToDouble(controller: limitLastController)!) {
                    // return false;
                    // return ValidButtonModel(
                    //   isValid: false,
                    //   errorStr:
                    //       "Minimum (${limitFirstController.text}) of $companyNameStr x $categoryStr must be less than maximum (${limitLastController.text}).",
                    // );
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.compareNumber,
                      overwriteRule: "Minimum < Maximum",
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                        TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[selectedCategoryIndex].category.text),
                        TitleAndSubtitleModel(
                          title: "Minimum (${cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].moneyType})",
                          subtitle: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.first.text,
                        ),
                        TitleAndSubtitleModel(
                          title: "Maximum (${cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].moneyType})",
                          subtitle: cardTemp.categoryList[selectedCategoryIndex].limitList[limitIndex].limit.last.text,
                        ),
                      ],
                      error: "Minimum value is larger than maximum value.",
                      detailList: [
                        TitleAndSubtitleModel(
                          title: "${limitFirstController.text} < ${limitLastController.text}",
                          subtitle: "Invalid compare",
                        ),
                      ],
                    );
                  }
                }
              }

              // for (int mainPriceIndex = 0; mainPriceIndex < cardTemp.categoryList[categoryIndex].mainPriceList.length; mainPriceIndex++) {
              //   final bool isStockEmpty = cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].stock.text.isEmpty;
              //   final bool isPriceEmpty = cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].price.text.isEmpty;
              //   final String? moneyTypeTemp = cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].moneyType;
              //   final bool isMoneyTypeEmpty = ((moneyTypeTemp == "") || (moneyTypeTemp == null));

              //   if (isStockEmpty || isPriceEmpty || isMoneyTypeEmpty) {
              //     return false;
              //   }

              //   for (int rateIndex = 0; rateIndex < cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList.length; rateIndex++) {
              //     final bool isRateTypeEmpty = cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList[rateIndex].rateType.isEmpty;
              //     final bool valueEmpty = cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList[rateIndex].discountValue.text.isEmpty;
              //     //rateId can't be empty
              //     if (isRateTypeEmpty || valueEmpty) {
              //       return false;
              //     }
              //   }
              // }

              final String companyNameStr = cardTemp.cardCompanyName.text;
              final String categoryStr = cardTemp.categoryList[categoryIndex].category.text;
              for (int sellPriceIndex = 0; sellPriceIndex < cardTemp.categoryList[categoryIndex].sellPriceList.length; sellPriceIndex++) {
                final bool isStartValueEmpty = cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].startValue.text.isEmpty;
                final bool isEndValueEmpty = cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].endValue.text.isEmpty;
                final bool isPriceEmpty = cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].price.text.isEmpty;
                final String? moneyTypeTemp = cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType;
                final bool isMoneyTypeEmpty = ((moneyTypeTemp == "") || (moneyTypeTemp == null));
                if (isStartValueEmpty) {
                  // return false;
                  // return ValidButtonModel(isValid: false, errorStr: "Start value of $companyNameStr x $categoryStr must not be empty.");
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfNumber,
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                      TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                      TitleAndSubtitleModel(title: "Table index", subtitle: sellPriceIndex.toString()),
                      TitleAndSubtitleModel(
                        title: "Start Value (${cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType})",
                        subtitle: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].startValue.text,
                      ),
                    ],
                    error: "Start value is empty.",
                  );
                }
                if (isEndValueEmpty) {
                  // return false;
                  // return ValidButtonModel(isValid: false, errorStr: "End value of $companyNameStr x $categoryStr must not be empty.");
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfNumber,
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                      TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                      TitleAndSubtitleModel(title: "Table index", subtitle: sellPriceIndex.toString()),
                      TitleAndSubtitleModel(
                        title: "End Value (${cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType})",
                        subtitle: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].endValue.text,
                      ),
                    ],
                    error: "End value is empty.",
                  );
                }
                if (isPriceEmpty) {
                  // return false;
                  // return ValidButtonModel(isValid: false, errorStr: "Price of $companyNameStr x $categoryStr must not be empty.");
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfNumber,
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                      TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                      TitleAndSubtitleModel(title: "Table index", subtitle: sellPriceIndex.toString()),
                      TitleAndSubtitleModel(
                        title: "Price (${cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType})",
                        subtitle: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].price.text,
                      ),
                    ],
                    error: "Price is empty.",
                  );
                }
                if (isMoneyTypeEmpty) {
                  // return false;
                  // return ValidButtonModel(isValid: false, errorStr: "Money type of $companyNameStr x $categoryStr must not be empty.");
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfString,
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                      TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                    ],
                    error: "Money type is empty.",
                  );
                }
                final double startValue = textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].startValue)!;
                final double endValue = textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].endValue)!;
                if (startValue == 0) {
                  // return false;
                  // return ValidButtonModel(isValid: false, errorStr: "Start value of $companyNameStr x $categoryStr must not value 0.");
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfNumber,
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                      TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                      TitleAndSubtitleModel(title: "Table index", subtitle: sellPriceIndex.toString()),
                      TitleAndSubtitleModel(
                        title: "Start Value (${cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType})",
                        subtitle: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].startValue.text,
                      ),
                    ],
                    error: "Start value is 0.",
                  );
                }

                if (endValue == 0) {
                  // return false;
                  // return ValidButtonModel(isValid: false, errorStr: "End value of $companyNameStr x $categoryStr must not value 0.");
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfNumber,
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                      TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                      TitleAndSubtitleModel(title: "Table index", subtitle: sellPriceIndex.toString()),
                      TitleAndSubtitleModel(
                        title: "End Value (${cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType})",
                        subtitle: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].endValue.text,
                      ),
                    ],
                    error: "End value is 0.",
                  );
                }
                if (startValue >= endValue) {
                  // return false;
                  // return ValidButtonModel(isValid: false, errorStr: "Start value of $companyNameStr x $categoryStr must be less than end value.");
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.compareNumber,
                    overwriteRule: "Start < End",
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                      TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                      TitleAndSubtitleModel(title: "Table index", subtitle: sellPriceIndex.toString()),
                      TitleAndSubtitleModel(
                        title: "Start Value (${cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType})",
                        subtitle: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].startValue.text,
                      ),
                      TitleAndSubtitleModel(
                        title: "End Value (${cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType})",
                        subtitle: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].endValue.text,
                      ),
                    ],
                    error: "Start value is larger than end value.",
                    detailList: [
                      TitleAndSubtitleModel(
                        title: "$startValue < $endValue",
                        subtitle: "Invalid compare",
                      ),
                    ],
                  );
                }
                final int limitIndex = cardTemp.categoryList[categoryIndex].limitList.indexWhere((element) => (element.moneyType == moneyTypeTemp));
                if (cardTemp.categoryList[categoryIndex].limitList[limitIndex].limit.first.text.isNotEmpty && cardTemp.categoryList[categoryIndex].limitList[limitIndex].limit.last.text.isNotEmpty) {
                  final double startNumber = textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].limitList[limitIndex].limit.first)!;
                  final String startStr = cardTemp.categoryList[categoryIndex].limitList[limitIndex].limit.first.text;
                  final double lastNumber = textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].limitList[limitIndex].limit.last)!;
                  final String lastStr = cardTemp.categoryList[categoryIndex].limitList[limitIndex].limit.last.text;
                  final String priceStr = cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].price.text;
                  final double priceNumber = textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].price)!;
                  if (!(startNumber <= priceNumber && priceNumber <= lastNumber)) {
                    // return false;
                    // return ValidButtonModel(
                    //   isValid: false,
                    //   errorStr: "Price of $companyNameStr x $categoryStr ($priceStr) must be between minimum ($startStr) and maximum ($lastStr).",
                    // );
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.compareNumber,
                      overwriteRule: "Minimum <= Price <= Maximum",
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                        TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                        TitleAndSubtitleModel(title: "Table index", subtitle: sellPriceIndex.toString()),
                        TitleAndSubtitleModel(
                          title: "Minimum (${cardTemp.categoryList[categoryIndex].limitList[limitIndex].moneyType})",
                          subtitle: cardTemp.categoryList[categoryIndex].limitList[limitIndex].limit.first.text,
                        ),
                        TitleAndSubtitleModel(
                          title: "Price (${cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType})",
                          subtitle: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].price.text,
                        ),
                        TitleAndSubtitleModel(
                          title: "Maximum (${cardTemp.categoryList[categoryIndex].limitList[limitIndex].moneyType})",
                          subtitle: cardTemp.categoryList[categoryIndex].limitList[limitIndex].limit.last.text,
                        ),
                      ],
                      error: "Price is not between minimum and maximum.",
                      detailList: [
                        TitleAndSubtitleModel(
                          title: "$startStr <= $priceStr <= $lastStr",
                          subtitle: "Invalid compare",
                        ),
                      ],
                    );
                  }
                } else {
                  // return false;
                  // return ValidButtonModel(isValid: false, errorStr: "Limit of $companyNameStr x $categoryStr must not be empty.");
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.arrayLength,
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                      TitleAndSubtitleModel(title: "Category", subtitle: cardTemp.categoryList[categoryIndex].category.text),
                      TitleAndSubtitleModel(
                        title: "Limit Length",
                        subtitle: cardTemp.categoryList[categoryIndex].limitList[limitIndex].limit.length.toString(),
                      ),
                    ],
                    error: "Limit Length is equal 0.",
                  );
                }
              }
            }

            for (int cardIndexInside = 0; cardIndexInside < cardModelListGlobal.length; cardIndexInside++) {
              final bool isNotSameCurrentEditingIndex = (cardIndex != cardIndexInside);
              if (isNotSameCurrentEditingIndex) {
                final bool isCardCompanyNameSame = (cardTemp.cardCompanyName.text == cardModelListGlobal[cardIndexInside].cardCompanyName.text);
                if (isCardCompanyNameSame) {
                  // return false;
                  // return ValidButtonModel(isValid: false, errorStr: "Card company name (${cardTemp.cardCompanyName.text}) must be unique.");
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueUnique,
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "Company Name", subtitle: cardTemp.cardCompanyName.text),
                    ],
                    error: "Company Name is same as previous save.",
                  );
                }
              }
            }

            if (isCreateNewCard) {
              //value are not null so return true
              // return true;
              // return ValidButtonModel(isValid: true, errorStr: "");
              return ValidButtonModel(isValid: true);
            } else {
              //check same value
              //note: all value never be null
              final String cardCompanyNameTemp = cardTemp.cardCompanyName.text;
              final String cardCompanyName = cardModelListGlobal[cardIndex!].cardCompanyName.text;
              final bool isCardCompanyNameNotSameValue = (cardCompanyNameTemp != cardCompanyName);
              if (isCardCompanyNameNotSameValue) {
                // return true;
                // return ValidButtonModel(isValid: true, errorStr: "");
                return ValidButtonModel(isValid: true);
              }
              // final String languageTemp = cardTemp.language;
              // final String language = cardModelListAdminGlobal[cardIndex].language;
              // final bool isLanguageNotSameValue = (languageTemp != language);
              // if (isLanguageNotSameValue) {
              //   return true;
              // }
              final int categoryListLengthTemp = cardTemp.categoryList.length;
              final int categoryListLength = cardModelListGlobal[cardIndex].categoryList.length;
              final isCategoryListLengthNotSameValue = (categoryListLengthTemp != categoryListLength);
              if (isCategoryListLengthNotSameValue) {
                // return true;
                // return ValidButtonModel(isValid: true, errorStr: "");
                return ValidButtonModel(isValid: true);
              }
              for (int categoryIndex = 0; categoryIndex < cardTemp.categoryList.length; categoryIndex++) {
                final double? categoryTemp = textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].category);
                final double? category = textEditingControllerToDouble(controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].category);
                final bool isCategoryNotSameValue = (categoryTemp != category);
                if (isCategoryNotSameValue) {
                  // return true;
                  // return ValidButtonModel(isValid: true, errorStr: "");
                  return ValidButtonModel(isValid: true);
                }

                // final int mainPriceListTemp = cardTemp.categoryList[categoryIndex].mainPriceList.length;
                // final int mainPriceList = cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList.length;
                // final bool isMainPriceListLengthNotSameValue = (mainPriceListTemp != mainPriceList);
                // if (isMainPriceListLengthNotSameValue) {
                //   return true;
                // }
                // for (int mainPriceIndex = 0; mainPriceIndex < cardTemp.categoryList[categoryIndex].mainPriceList.length; mainPriceIndex++) {
                //   final double? stockTemp = textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].stock);
                //   final double? stock =
                //       textEditingControllerToDouble(controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].stock);
                //   final bool isStockNotSameValue = (stockTemp != stock);

                //   final double? priceTemp = textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].price);
                //   final double? price =
                //       textEditingControllerToDouble(controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].price);
                //   final bool isPriceNotSameValue = (priceTemp != price);

                //   final String moneyTypeTemp = cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].moneyType!;
                //   final String moneyType = cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].moneyType!;
                //   final bool isMoneyTypeNotSameValue = (moneyTypeTemp != moneyType);

                //   if (isStockNotSameValue || isPriceNotSameValue || isMoneyTypeNotSameValue) {
                //     return true;
                //   }

                //   final int rateListTemp = cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList.length;
                //   final int rateList = cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList.length;
                //   final bool isRateListLengthNotSameValue = (rateListTemp != rateList);
                //   if (isRateListLengthNotSameValue) {
                //     return true;
                //   }
                //   for (int rateIndex = 0; rateIndex < cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList.length; rateIndex++) {
                //     final String rateTypeFirstTemp = cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList[rateIndex].rateType.first;
                //     final String rateTypeFirst =
                //         cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList[rateIndex].rateType.first;
                //     final bool isRateTypeFirstNotSameValue = (rateTypeFirstTemp != rateTypeFirst);

                //     final String rateTypeLastTemp = cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList[rateIndex].rateType.last;
                //     final String rateTypeLast =
                //         cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList[rateIndex].rateType.last;
                //     final bool isRateTypeLastNotSameValue = (rateTypeLastTemp != rateTypeLast);

                //     final double? valueTemp = textEditingControllerToDouble(
                //         controller: cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList[rateIndex].discountValue);
                //     final double? value = textEditingControllerToDouble(
                //         controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList[rateIndex].discountValue);
                //     final bool isValueNotSameValue = (valueTemp != value);

                //     final String rateIdTemp = cardTemp.categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList[rateIndex].rateId!;
                //     final String rateId = cardModelListGlobal[cardIndex].categoryList[categoryIndex].mainPriceList[mainPriceIndex].rateList[rateIndex].rateId!;
                //     final bool isRateIdNotSameValue = (rateIdTemp != rateId);
                //     if (isRateTypeFirstNotSameValue || isRateTypeLastNotSameValue || isValueNotSameValue || isRateIdNotSameValue) {
                //       return false;
                //     }
                //   }
                // }

                final bool isSellPriceListLengthNotSameValue =
                    (cardTemp.categoryList[categoryIndex].sellPriceList.length != cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList.length);
                if (isSellPriceListLengthNotSameValue) {
                  // return true;
                  // return ValidButtonModel(isValid: true, errorStr: "");
                  return ValidButtonModel(isValid: true);
                }
                for (int sellPriceIndex = 0; sellPriceIndex < cardTemp.categoryList[categoryIndex].sellPriceList.length; sellPriceIndex++) {
                  final double? startValueTemp = textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].startValue);
                  final double? startValue = textEditingControllerToDouble(controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].startValue);
                  final bool isStartValueNotSameValue = (startValueTemp != startValue);

                  final double? endValueTemp = textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].endValue);
                  final double? endValue = textEditingControllerToDouble(controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].endValue);
                  final bool isEndValueNotSameValue = (endValueTemp != endValue);

                  final double? priceTemp = textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].price);
                  final double? price = textEditingControllerToDouble(controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].price);
                  final bool isPriceValueNotSameValue = (priceTemp != price);

                  final String moneyTypeTemp = cardTemp.categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType!;
                  final String moneyType = cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].moneyType!;
                  final bool isMoneyTypeNotSameValue = (moneyTypeTemp != moneyType);

                  if (isStartValueNotSameValue || isEndValueNotSameValue || isPriceValueNotSameValue || isMoneyTypeNotSameValue) {
                    // return true;
                    // return ValidButtonModel(isValid: true, errorStr: "");
                    return ValidButtonModel(isValid: true);
                  }
                }

                final isLimitListLengthNotSameValue = (cardTemp.categoryList[categoryIndex].limitList.length != cardModelListGlobal[cardIndex].categoryList[categoryIndex].limitList.length);
                if (isLimitListLengthNotSameValue) {
                  // return true;
                  // return ValidButtonModel(isValid: true, errorStr: "");
                  return ValidButtonModel(isValid: true);
                }
                for (int limitIndex = 0; limitIndex < cardTemp.categoryList[categoryIndex].limitList.length; limitIndex++) {
                  final String moneyTypeTemp = cardTemp.categoryList[categoryIndex].limitList[limitIndex].moneyType!;
                  final String moneyType = cardModelListGlobal[cardIndex].categoryList[categoryIndex].limitList[limitIndex].moneyType!;
                  final bool isMoneyTypeNotSameValue = (moneyTypeTemp != moneyType);

                  final double? startValueTemp = textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].limitList[limitIndex].limit.first);
                  final double? startValue = textEditingControllerToDouble(controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].limitList[limitIndex].limit.first);
                  final bool isStartValueNotSameValue = (startValueTemp != startValue);

                  final double? endValueTemp = textEditingControllerToDouble(controller: cardTemp.categoryList[categoryIndex].limitList[limitIndex].limit.last);
                  final double? endValue = textEditingControllerToDouble(controller: cardModelListGlobal[cardIndex].categoryList[categoryIndex].limitList[limitIndex].limit.last);
                  final bool isEndValueNotSameValue = (endValueTemp != endValue);

                  if (isMoneyTypeNotSameValue || isStartValueNotSameValue || isEndValueNotSameValue) {
                    // return true;
                    return ValidButtonModel(isValid: true);
                  }
                }
              }
              //nothing change so return false
              // return false;
              // return ValidButtonModel(isValid: false, errorStr: "Nothing change.");
              return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.nothingChange);
            }
          }

          Function? deleteFunctionOrNull() {
            if (isCreateNewCard) {
              return null;
            } else {
              void deleteFunctionOnTap() {
                void okFunction() {
                  void callback() {
                    adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.card);
                    setState(() {});
                  }

                  //close the rate dialog
                  closeDialogGlobal(context: context);

                  deleteCardGlobal(callBack: callback, context: context, cardId: cardTemp.id!); //delete the existing card in database and local storage
                }

                void cancelFunction() {}
                confirmationDialogGlobal(
                  context: context,
                  okFunction: okFunction,
                  cancelFunction: cancelFunction,
                  titleStr: "$deleteGlobal ${cardTemp.cardCompanyName.text}",
                  subtitleStr: deleteConfirmGlobal,
                );
              }

              return deleteFunctionOnTap;
            }
          }

          ValidButtonModel validDeleteFunctionOnTap() {
            for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
              for (int categoryIndex = 0; categoryIndex < cardTemp.categoryList.length; categoryIndex++) {
                final bool isMainCardNotEmpty = cardTemp.categoryList[categoryIndex].mainPriceList.isNotEmpty;
                if (isMainCardNotEmpty) {
                  final String companyName = cardTemp.cardCompanyName.text;
                  final String category = cardTemp.categoryList[categoryIndex].category.text;
                  // return false;
                  // return ValidButtonModel(isValid: false, errorStr: "Stock of $companyName x $category must be empty");
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.arrayLength,
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "Company Name", subtitle: companyName),
                      TitleAndSubtitleModel(title: "Category", subtitle: category),
                      TitleAndSubtitleModel(title: "Main Price List Length", subtitle: cardTemp.categoryList[categoryIndex].mainPriceList.length.toString()),
                    ],
                    error: "Card Stock List is not empty.",
                  );
                }
              }
            }
            return isNoMainCardStock();
          }

          void restoreFunctionOnTap() {
            void okFunction() {
              void callBack() {
                adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.card);
                setState(() {});
                closeDialogGlobal(context: context);
              }

              restoreCardGlobal(callBack: callBack, context: context, cardId: cardTemp.id!);
            }

            void cancelFunction() {}
            confirmationDialogGlobal(
              context: context,
              okFunction: okFunction,
              cancelFunction: cancelFunction,
              titleStr: "$restoreGlobal ${cardTemp.cardCompanyName.text}",
              subtitleStr: restoreConfirmGlobal,
            );
          }

          actionDialogSetStateGlobal(
            dialogHeight: dialogSizeGlobal(level: Level.mini),
            dialogWidth: dialogSizeGlobal(level: Level.large),
            cancelFunctionOnTap: cancelFunctionOnTap,
            context: context,
            validSaveButtonFunction: () => validSaveButtonFunction(),
            saveFunctionOnTap: (deleteDateOrNull == null) ? saveFunctionOnTap : null,
            contentFunctionReturnWidget: editCardDialog,
            validDeleteFunctionOnTap: () => validDeleteFunctionOnTap(),
            deleteFunctionOnTap: (deleteDateOrNull == null) ? deleteFunctionOrNull() : null,
            restoreFunctionOnTap: (deleteDateOrNull == null) ? null : restoreFunctionOnTap,
          );
        }

        void addOnTapFunction() {
          askingForChangeDialogGlobal(
            context: context,
            allowFunction: () => setUpCardDialog(isCreateNewCard: true, cardIndex: null),
            editSettingTypeEnum: EditSettingTypeEnum.card,
          );
        }

        List<Widget> inWrapWidgetList() {
          Widget cardButtonWidget({required int cardIndex}) {
            Widget setWidthSizeBox() {
              Widget insideSizeBoxWidget() {
                Widget paddingAndColumnWidget() {
                  Widget companyNameAndCategoryListWidget() {
                    final DateTime? deleteDateOrNull = cardModelListGlobal[cardIndex].deletedDate;
                    final String companyName = cardModelListGlobal[cardIndex].cardCompanyName.text;
                    final List<CardCategoryListCardModel> categoryList = cardModelListGlobal[cardIndex].categoryList;
                    Widget companyNameTextWidget() {
                      return Text(
                        companyName,
                        style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold, color: (deleteDateOrNull == null) ? defaultTextColorGlobal : deleteTextColorGlobal),
                      );
                    }

                    Widget categoryListTextWidget() {
                      String categoryListStr() {
                        String categoryStr = emptyStrGlobal;
                        for (int mainPriceIndex = 0; mainPriceIndex < categoryList.length; mainPriceIndex++) {
                          final bool isLastIndex = (mainPriceIndex == (categoryList.length - 1));
                          final String commaOrEmptyStr = isLastIndex ? emptyStrGlobal : " | ";
                          final String categoryEach = categoryList[mainPriceIndex].category.text;
                          categoryStr = categoryStr + categoryEach + commaOrEmptyStr;
                        }
                        return categoryStr;
                      }

                      return scrollText(
                        textStr: categoryListStr(),
                        textStyle: textStyleGlobal(level: Level.normal, color: (deleteDateOrNull == null) ? defaultTextColorGlobal : deleteTextColorGlobal),
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
                      children: [companyNameTextWidget(), categoryListTextWidget(), deleteDateScrollTextWidget()],
                    );
                  }

                  return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.normal)), child: companyNameAndCategoryListWidget());
                }

                return paddingAndColumnWidget();
              }

              void onTapUnlessDisable() {
                askingForChangeDialogGlobal(
                  context: context,
                  allowFunction: () => setUpCardDialog(isCreateNewCard: false, cardIndex: cardIndex),
                  editSettingTypeEnum: EditSettingTypeEnum.card,
                );
              }

              return CustomButtonGlobal(sizeBoxWidth: sizeBoxWidthGlobal, sizeBoxHeight: sizeBoxHeightGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
            }

            return setWidthSizeBox();
          }

          Widget cardPriceCombineButtonWidget() {
            Widget setWidthSizeBox() {
              Widget insideSizeBoxWidget() {
                Widget paddingAndColumnWidget() {
                  Widget companyNameAndCategoryListWidget() {
                    Widget companyNameTextWidget() {
                      return Text(cardCombineStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold));
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [companyNameTextWidget()],
                    );
                  }

                  return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.normal)), child: companyNameAndCategoryListWidget());
                }

                return paddingAndColumnWidget();
              }

              void setUpCombineCardDialog() {
                List<CardCombineModel> cardCombineModelListTemp = cardCombineClone();
                editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.card);
                void cancelFunctionOnTap() {
                  void okFunction() {
                    adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.card);
                    closeDialogGlobal(context: context);
                  }

                  void cancelFunction() {}
                  confirmationDialogGlobal(
                      context: context, okFunction: okFunction, cancelFunction: cancelFunction, titleStr: cancelEditingSettingGlobal, subtitleStr: cancelEditingSettingConfirmGlobal);
                }

                ValidButtonModel validSubCardCombineButtonModel({required CardCombineModel cardCombineModel, required int cardCombineIndex}) {
                  if (cardCombineModel.combineName.text.isEmpty) {
                    return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "combine name is empty.", errorLocationList: [
                      TitleAndSubtitleModel(title: "Combine index", subtitle: cardCombineIndex.toString()),
                      TitleAndSubtitleModel(title: "Combine Name", subtitle: ""),
                    ]);
                  }
                  for (int subCardCombineIndex = 0; subCardCombineIndex < cardCombineModel.cardList.length; subCardCombineIndex++) {
                    final SubCardCombineModel subCardCombineModel = cardCombineModel.cardList[subCardCombineIndex];

                    if (subCardCombineModel.cardCompanyName == null) {
                      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "card company name is not selected.", detailList: [
                        TitleAndSubtitleModel(title: "Combine index", subtitle: cardCombineIndex.toString()),
                        TitleAndSubtitleModel(title: "Combine Name", subtitle: cardCombineModel.combineName.text),
                        TitleAndSubtitleModel(title: "Card Company Name", subtitle: ""),
                      ]);
                    }
                    if (subCardCombineModel.categoryId == null) {
                      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "Category is not selected.", detailList: [
                        TitleAndSubtitleModel(title: "Combine index", subtitle: cardCombineIndex.toString()),
                        TitleAndSubtitleModel(title: "Combine Name", subtitle: cardCombineModel.combineName.text),
                        TitleAndSubtitleModel(title: "Card Company Name", subtitle: subCardCombineModel.cardCompanyName ?? ""),
                        TitleAndSubtitleModel(title: "Category", subtitle: ""),
                      ]);
                    }
                    if (subCardCombineModel.sellPriceId == null) {
                      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "Sell Price is not selected.", detailList: [
                        TitleAndSubtitleModel(title: "Combine index", subtitle: cardCombineIndex.toString()),
                        TitleAndSubtitleModel(title: "Combine Name", subtitle: cardCombineModel.combineName.text),
                        TitleAndSubtitleModel(title: "Card Company Name", subtitle: subCardCombineModel.cardCompanyName ?? ""),
                        TitleAndSubtitleModel(title: "Category", subtitle: subCardCombineModel.category.toString()),
                        TitleAndSubtitleModel(title: "Sell Price", subtitle: ""),
                      ]);
                    }
                  }
                  return ValidButtonModel(isValid: true);
                }

                ValidButtonModel validCardCombineButtonModel({required List<CardCombineModel> cardCombineModelList}) {
                  for (int cardCombineIndex = 0; cardCombineIndex < cardCombineModelList.length; cardCombineIndex++) {
                    final CardCombineModel cardCombineModel = cardCombineModelList[cardCombineIndex];
                    if (cardCombineModelList[cardCombineIndex].cardList.isEmpty) {
                      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.arrayLength, error: "Card Combine is empty.", errorLocationList: [
                        TitleAndSubtitleModel(title: "Combine index", subtitle: cardCombineIndex.toString()),
                        TitleAndSubtitleModel(title: "Card Combine length", subtitle: cardCombineModelList[cardCombineIndex].cardList.length.toString()),
                      ]);
                    }
                    final ValidButtonModel validSubCardCombineButtonModelTemp = validSubCardCombineButtonModel(
                      cardCombineModel: cardCombineModel,
                      cardCombineIndex: cardCombineIndex,
                    );
                    if (!validSubCardCombineButtonModelTemp.isValid) {
                      return validSubCardCombineButtonModelTemp;
                    }
                  }
                  return ValidButtonModel(isValid: true);
                }

                Widget editCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                  Widget paddingBottomTitleWidget() {
                    Widget titleWidget() {
                      return Text(cardCombineStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold));
                    }

                    return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: titleWidget());
                  }

                  void bottomFunction() {}
                  void topFunction() {}
                  List<Widget> inWrapWidgetList() {
                    Widget cardCombineWidget({required int cardCombineIndex}) {
                      void onTapUnlessDisable() {}
                      Widget insideSizeBoxWidget() {
                        Widget subCardCombineWidget({required int subCardCombineIndex}) {
                          void onTapUnlessDisable() {}
                          Widget insideSizeBoxWidget() {
                            Widget cardCompanyNameDropdown() {
                              void onTapFunction() {}

                              void onChangedFunction({required String value, required int index}) {
                                cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].cardCompanyName = value;
                                cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].cardCompanyId = cardModelListGlobal[index].id;
                                // giveCardToMatModelTemp.language = cardModelListAdminGlobal[index].language;
                                cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].category = null;
                                cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].categoryId = null;

                                cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].sellPrice = null;
                                cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].sellPriceId = null;
                                setStateFromDialog(() {});
                              }

                              return customDropdown(
                                level: Level.mini,
                                labelStr: cardCompanyNameStrGlobal,
                                onTapFunction: onTapFunction,
                                onChangedFunction: onChangedFunction,
                                selectedStr: cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].cardCompanyName,
                                menuItemStrList: cardCompanyNameOnlyList(),
                              );
                            }

                            Widget categoryDropdown() {
                              void onTapFunction() {}

                              void onChangedFunction({required String value, required int index}) {
                                final int companyNameIndex = cardModelListGlobal
                                    .indexWhere((element) => (element.id == cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].cardCompanyId)); //never equal -1

                                cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].category =
                                    textEditingControllerToDouble(controller: cardModelListGlobal[companyNameIndex].categoryList[index].category);
                                cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].categoryId = cardModelListGlobal[companyNameIndex].categoryList[index].id;
                                cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].sellPrice = null;
                                cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].sellPriceId = null;
                                setStateFromDialog(() {});
                              }

                              return Padding(
                                padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
                                child: customDropdown(
                                  level: Level.mini,
                                  labelStr: categoryCardStrGlobal,
                                  onTapFunction: onTapFunction,
                                  onChangedFunction: onChangedFunction,
                                  selectedStr: (cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].category == null)
                                      ? null
                                      : formatAndLimitNumberTextGlobal(
                                          valueStr: cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].category.toString(),
                                          isRound: false,
                                        ),
                                  menuItemStrList: cardCategoryOnlyList(
                                    companyNameStr: cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].cardCompanyName,
                                  ),
                                ),
                              );
                            }

                            Widget sellPriceDropdown() {
                              List<String> sellPriceListStr() {
                                final int companyNameIndex = cardModelListGlobal
                                    .indexWhere((element) => (element.id == cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].cardCompanyId)); //never equal -1

                                final int categoryIndex = cardModelListGlobal[companyNameIndex]
                                    .categoryList
                                    .indexWhere((element) => (element.id == cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].categoryId)); //never equal -1

                                return cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList.map((e) => sellPriceModelToStr(cardSellPriceListCardModel: e)).toList();
                              }

                              void onTapFunction() {}

                              void onChangedFunction({required String value, required int index}) {
                                final int companyNameIndex = cardModelListGlobal
                                    .indexWhere((element) => (element.id == cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].cardCompanyId)); //never equal -1

                                final int categoryIndex = cardModelListGlobal[companyNameIndex]
                                    .categoryList
                                    .indexWhere((element) => (element.id == cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].categoryId));

                                // cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].categoryId =

                                cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].sellPriceId =
                                    cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[index].id;
                                cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].sellPrice =
                                    sellPriceModelToStr(cardSellPriceListCardModel: cardModelListGlobal[companyNameIndex].categoryList[categoryIndex].sellPriceList[index]);
                                setStateFromDialog(() {});
                              }

                              return Padding(
                                padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
                                child: customDropdown(
                                  level: Level.mini,
                                  labelStr: mainPriceCardStrGlobal,
                                  onTapFunction: onTapFunction,
                                  onChangedFunction: onChangedFunction,
                                  selectedStr: cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].sellPrice,
                                  menuItemStrList: sellPriceListStr(),
                                ),
                              );
                            }

                            return Row(children: [
                              Expanded(flex: 1, child: cardCompanyNameDropdown()),
                              (cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].cardCompanyName == null) ? Container() : Expanded(flex: 1, child: categoryDropdown()),
                              (cardCombineModelListTemp[cardCombineIndex].cardList[subCardCombineIndex].categoryId == null) ? Container() : Expanded(flex: 3, child: sellPriceDropdown()),
                            ]);
                          }

                          void onDeleteUnlessDisable() {
                            cardCombineModelListTemp[cardCombineIndex].cardList.removeAt(subCardCombineIndex);
                            setStateFromDialog(() {});
                          }

                          return CustomButtonGlobal(
                            isDisable: true,
                            onDeleteUnlessDisable: onDeleteUnlessDisable,
                            insideSizeBoxWidget: insideSizeBoxWidget(),
                            onTapUnlessDisable: onTapUnlessDisable,
                          );
                        }

                        Widget nameTextFieldWidget() {
                          void onChangeFromOutsiderFunction() {
                            setStateFromDialog(() {});
                          }

                          void onTapFromOutsiderFunction() {}
                          return Padding(
                            padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                            child: textFieldGlobal(
                              textFieldDataType: TextFieldDataType.str,
                              controller: cardCombineModelListTemp[cardCombineIndex].combineName,
                              onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                              labelText: cardCombineNameGlobal,
                              level: Level.normal,
                              onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                            ),
                          );
                        }

                        Widget addMoreSubCardCombineWidget() {
                          void onTapFunction() {
                            cardCombineModelListTemp[cardCombineIndex].cardList.add(SubCardCombineModel());
                            setStateFromDialog(() {});
                          }

                          return addButtonOrContainerWidget(
                            validModel: validSubCardCombineButtonModel(
                              cardCombineModel: cardCombineModelListTemp[cardCombineIndex],
                              cardCombineIndex: cardCombineIndex,
                            ),
                            level: Level.mini,
                            currentAddButtonQty: cardCombineModelListTemp[cardCombineIndex].cardList.length,
                            maxAddButtonLimit: cardSubCombineAddButtonLimitGlobal,
                            context: context,
                            onTapFunction: onTapFunction,
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.all(paddingSizeGlobal(level: Level.normal)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            nameTextFieldWidget(),
                            for (int subCardCombineIndex = 0; subCardCombineIndex < cardCombineModelListTemp[cardCombineIndex].cardList.length; subCardCombineIndex++)
                              subCardCombineWidget(subCardCombineIndex: subCardCombineIndex),
                            addMoreSubCardCombineWidget(),
                          ]),
                        );
                      }

                      void onDeleteUnlessDisable() {
                        cardCombineModelListTemp.removeAt(cardCombineIndex);
                        setStateFromDialog(() {});
                      }

                      return CustomButtonGlobal(
                        onDeleteUnlessDisable: onDeleteUnlessDisable,
                        insideSizeBoxWidget: insideSizeBoxWidget(),
                        onTapUnlessDisable: onTapUnlessDisable,
                      );
                    }

                    Widget addMoreCardCombineWidget() {
                      void onTapFunction() {
                        cardCombineModelListTemp.add(CardCombineModel(combineName: TextEditingController(), cardList: []));

                        setStateFromDialog(() {});
                      }

                      return addButtonOrContainerWidget(
                        level: Level.mini,
                        validModel: validCardCombineButtonModel(cardCombineModelList: cardCombineModelListTemp),
                        currentAddButtonQty: cardCombineModelListTemp.length,
                        maxAddButtonLimit: cardCombineAddButtonLimitGlobal,
                        context: context,
                        onTapFunction: onTapFunction,
                      );
                    }

                    return [
                      for (int cardCombineIndex = 0; cardCombineIndex < cardCombineModelListTemp.length; cardCombineIndex++) cardCombineWidget(cardCombineIndex: cardCombineIndex),
                      addMoreCardCombineWidget(),
                    ];
                  }

                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    paddingBottomTitleWidget(),
                    Expanded(
                      child: wrapScrollDetectWidget(
                        bottomFunction: bottomFunction,
                        topFunction: topFunction,
                        inWrapWidgetList: inWrapWidgetList(),
                        isShowSeeMoreWidget: false,
                      ),
                    ),
                  ]);
                }

                ValidButtonModel validSaveButtonFunction() {
                  if (cardCombineModelListTemp.isEmpty) {
                    return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.arrayLength, errorLocationList: [
                      TitleAndSubtitleModel(title: "Card Combine length", subtitle: cardCombineModelListTemp.length.toString()),
                    ]);
                  }
                  ValidButtonModel validButtonModel = validCardCombineButtonModel(cardCombineModelList: cardCombineModelListTemp);
                  if (!validButtonModel.isValid) {
                    return validButtonModel;
                  }
                  for (int cardIndex = 0; cardIndex < cardCombineModelListTemp.length; cardIndex++) {
                    for (int subCardIndex = (cardIndex + 1); subCardIndex < cardCombineModelListTemp.length; subCardIndex++) {
                      if (cardCombineModelListTemp[cardIndex].combineName.text == cardCombineModelListTemp[subCardIndex].combineName.text) {
                        return ValidButtonModel(
                          isValid: false,
                          errorType: ErrorTypeEnum.valueOfString,
                          error: "Combine name is duplicated.",
                          errorLocationList: [
                            TitleAndSubtitleModel(title: "Combine index", subtitle: cardIndex.toString()),
                            TitleAndSubtitleModel(title: "Combine index", subtitle: subCardIndex.toString()),
                            TitleAndSubtitleModel(title: "Combine Name", subtitle: cardCombineModelListTemp[cardIndex].combineName.text),
                          ],
                        );
                      }
                    }
                  }
                  if (cardCombineModelListTemp.length == cardCombineModelListGlobal.length) {
                    for (int cardCombineIndex = 0; cardCombineIndex < cardCombineModelListTemp.length; cardCombineIndex++) {
                      final CardCombineModel cardCombineModel = cardCombineModelListTemp[cardCombineIndex];
                      final CardCombineModel cardCombineModelGlobal = cardCombineModelListGlobal[cardCombineIndex];
                      if (cardCombineModel.combineName.text != cardCombineModelGlobal.combineName.text) {
                        return ValidButtonModel(isValid: true);
                      }
                      if (cardCombineModel.cardList.length != cardCombineModelGlobal.cardList.length) {
                        return ValidButtonModel(isValid: true);
                      }
                      for (int subCardCombineIndex = 0; subCardCombineIndex < cardCombineModel.cardList.length; subCardCombineIndex++) {
                        final SubCardCombineModel subCardCombineModel = cardCombineModel.cardList[subCardCombineIndex];
                        final SubCardCombineModel subCardCombineModelGlobal = cardCombineModelGlobal.cardList[subCardCombineIndex];
                        // if(subCardCombineModel.cardCompanyName != subCardCombineModelGlobal.cardCompanyName) {
                        //   return ValidButtonModel(isValid: true);
                        // }
                        if (subCardCombineModel.categoryId != subCardCombineModelGlobal.categoryId) {
                          return ValidButtonModel(isValid: true);
                        }
                        if (subCardCombineModel.sellPriceId != subCardCombineModelGlobal.sellPriceId) {
                          return ValidButtonModel(isValid: true);
                        }
                      }
                    }
                    return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.nothingChange);
                  }

                  return ValidButtonModel(isValid: true);
                }

                void saveFunctionOnTap() {
                  void callBack() {
                    adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.importFromExcel);
                    setState(() {});
                    closeDialogGlobal(context: context);
                  }

                  updateCardCombineAdminGlobal(cardCombineModelList: cardCombineModelListTemp, callBack: callBack, context: context);
                }

                actionDialogSetStateGlobal(
                  dialogHeight: dialogSizeGlobal(level: Level.mini),
                  dialogWidth: dialogSizeGlobal(level: Level.normal),
                  cancelFunctionOnTap: cancelFunctionOnTap,
                  context: context,
                  validSaveButtonFunction: () => validSaveButtonFunction(),
                  saveFunctionOnTap: saveFunctionOnTap,
                  contentFunctionReturnWidget: editCardDialog,
                );
              }

              void onTapUnlessDisable() {
                askingForChangeDialogGlobal(
                  context: context,
                  allowFunction: () => setUpCombineCardDialog(),
                  editSettingTypeEnum: EditSettingTypeEnum.card,
                );
              }

              return CustomButtonGlobal(sizeBoxWidth: sizeBoxWidthGlobal, sizeBoxHeight: sizeBoxHeightGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
            }

            return setWidthSizeBox();
          }

          return [
            cardPriceCombineButtonWidget(),
            for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) cardButtonWidget(cardIndex: cardIndex),
          ];
        }

        return BodyTemplateSideMenu(
          addOnTapFunction: addOnTapFunction,
          inWrapWidgetList: inWrapWidgetList(),
          title: widget.title,
          currentAddButtonQty: cardModelListGlobal.length,
          maxAddButtonLimit: cardAddButtonLimitGlobal,
        );
      }

      // return _isLoadingOnInitCard ? Container() : bodyTemplateSideMenu();
      return bodyTemplateSideMenu();
    }

    return loadingOrBody();
  }
}
