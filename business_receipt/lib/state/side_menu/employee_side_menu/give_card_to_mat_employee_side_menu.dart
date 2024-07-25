// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/active_log.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/card.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/employee.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/request_api/give_card_to_mat_request_api_env.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/function/text/text_area_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/toggle_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/active_log.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/employee_model/card/sell_card_model.dart';
import 'package:business_receipt/model/employee_model/give_card_to_mat_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class GiveCardToMatEmployeeSideMenu extends StatefulWidget {
  String title;
  Function callback;
  GiveCardToMatEmployeeSideMenu({Key? key, required this.title, required this.callback}) : super(key: key);

  @override
  State<GiveCardToMatEmployeeSideMenu> createState() => _GiveCardToMatEmployeeSideMenuState();
}

class _GiveCardToMatEmployeeSideMenuState extends State<GiveCardToMatEmployeeSideMenu> {
  // bool _isLoadingOnInitMoney = false; //TODO: change this to true
  String? selectedEmployeeNameStr;
  GiveCardToMatModel giveCardToMatModelTemp =
      GiveCardToMatModel(activeLogModelList: [], qty: TextEditingController(), mainPriceQtyList: [], remark: TextEditingController());

  List<ActiveLogModel> activeLogModelGiveCardToMatList = [];
  // bool isShowPrevious = false;
  @override
  void initState() {
    // void initCardToTempDB() {}

    // initCardToTempDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      ValidButtonModel isValidGiveMoneyToMat() {
        final bool selectedEmployeeStrNull = (selectedEmployeeNameStr == null);
        final bool companyNameStrNull = (giveCardToMatModelTemp.cardCompanyName == null);
        final bool categoryStrNull = (giveCardToMatModelTemp.category == null);
        final bool qtyControllerEmpty = giveCardToMatModelTemp.qty.text.isEmpty;
        // if (selectedEmployeeStrNull || companyNameStrNull || categoryStrNull || qtyControllerEmpty) {
        //   return false;
        // }
        if (selectedEmployeeStrNull) {
          // return false;
          return ValidButtonModel(isValid: false, error: "please select an employee");
        }
        if (companyNameStrNull) {
          // return false;
          return ValidButtonModel(isValid: false, error: "please select a card company name");
        }
        if (categoryStrNull) {
          // return false;
          return ValidButtonModel(isValid: false, error: "please select a category");
        }
        if (qtyControllerEmpty) {
          // return false;
          return ValidButtonModel(isValid: false, error: "qty is empty.", errorType: ErrorTypeEnum.valueOfString);
        }
        // else {
        final bool isQtyEqual0 = (textEditingControllerToDouble(controller: giveCardToMatModelTemp.qty) == 0);
        if (isQtyEqual0) {
          // return false;
          return ValidButtonModel(isValid: false, error: "qty is 0.", errorType: ErrorTypeEnum.valueOfNumber);
        }

        final ValidButtonModel lowerCardStockModel = checkLowerTheExistCard(
          companyNameStr: giveCardToMatModelTemp.cardCompanyName!,
          categoryNumber: giveCardToMatModelTemp.category!,
          qtyNumber: textEditingControllerToInt(controller: giveCardToMatModelTemp.qty)!,
        );
        if (!lowerCardStockModel.isValid) {
          // return false;
          return lowerCardStockModel;
        }
        // }
        // return true;
        return ValidButtonModel(isValid: true);
      }

      void historyOnTapFunction() {
        limitHistory();
        addActiveLogElement(
          activeLogModelList: activeLogModelGiveCardToMatList,
          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "history button"),
          ]),
        );
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
                children: [Text(giveCardToMatHistoryStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))], //TODO: change this
              ),
            );
          }

          //TODO: change this function name
          Widget giveCardToMatHistoryListWidget() {
            List<Widget> inWrapWidgetList() {
              return [
                for (int giveCardToMatIndex = 0; giveCardToMatIndex < giveCardToMatModelListEmployeeGlobal.length; giveCardToMatIndex++) //TODO: change this
                  HistoryElement(
                    isForceShowNoEffect: false,
                    isAdminEditing: false,
                    index: giveCardToMatIndex,
                    giveCardToMatModel: giveCardToMatModelListEmployeeGlobal[giveCardToMatIndex], //TODO: change this
                    setStateOutsider: setStateOutsider,
                  )
              ];
            }

            void topFunction() {}
            void bottomFunction() {
              if (!outOfDataQueryGiveCardToMatListGlobal) {
                //TODO: change this
                final int beforeQuery = giveCardToMatModelListEmployeeGlobal.length; //TODO: change this
                void callBack() {
                  final int afterQuery = giveCardToMatModelListEmployeeGlobal.length; //TODO: change this

                  if (beforeQuery == afterQuery) {
                    outOfDataQueryGiveCardToMatListGlobal = true; //TODO: change this
                  } else {
                    skipGiveCardToMatListGlobal = skipGiveCardToMatListGlobal + queryLimitNumberGlobal; //TODO: change this
                  }
                  setStateFromDialog(() {});
                }

                getGiveCardToMatListEmployeeGlobal(
                  employeeId: profileModelEmployeeGlobal!.id!,
                  callBack: callBack,
                  context: context,
                  skip: skipGiveCardToMatListGlobal,
                  targetDate: DateTime.now(),
                  giveCardToMatModelListEmployee: giveCardToMatModelListEmployeeGlobal,
                ); //TODO: change this
              }
            }

            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: !outOfDataQueryGiveCardToMatListGlobal,
            );
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleTextWidget(), Expanded(child: giveCardToMatHistoryListWidget())]);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini),
          dialogWidth: dialogSizeGlobal(level: Level.mini),
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      // void previousOnTapFunction() {}
      // Widget previousWidget() {
      //   return Container();
      // }

      List<Widget> inWrapWidgetList() {
        Widget giveToMatWidget() {
          Widget customButtonWidget() {
            Widget paddingBottomWidget({required Widget widget}) {
              return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: widget);
            }

            Widget singleToggleWidget() {
              return singleToggleGlobal(singleOptionStr: decreaseCardStrGlobal, color: negativeColorGlobal);
            }

            Widget selectEmployee() {
              void onTapFunction() {}
              final String? matTemp = giveCardToMatModelTemp.employeeName;
              void onChangedFunction({required String value, required int index}) {
                final int employeeMatchIndex = profileEmployeeModelListAdminGlobal.indexWhere((element) => (element.name.text == value));

                // for (int employeeIndex = 0; employeeIndex < profileEmployeeModelListAdminGlobal.length; employeeIndex++) {
                //   final bool isNameStrMatch = (profileEmployeeModelListAdminGlobal[employeeIndex].name.text == value);
                //   if (isNameStrMatch) {
                //     employeeMatchIndex = employeeIndex;
                //     break;
                //   }
                // }
                giveCardToMatModelTemp.employeeId = profileEmployeeModelListAdminGlobal[employeeMatchIndex].id;
                giveCardToMatModelTemp.employeeName = profileEmployeeModelListAdminGlobal[employeeMatchIndex].name.text;
                selectedEmployeeNameStr = value;
                addActiveLogElement(
                  activeLogModelList: activeLogModelGiveCardToMatList,
                  activeLogModel: ActiveLogModel(idTemp: "select mat", activeType: ActiveLogTypeEnum.selectDropdown, locationList: [
                    Location(title: "select mat", subtitle: "${(matTemp == null) ? "" : "$matTemp to "}$value"),
                  ]),
                );
                setState(() {});
              }

              return customDropdown(
                level: Level.normal,
                labelStr: matStrGlobal,
                onTapFunction: onTapFunction,
                onChangedFunction: onChangedFunction,
                selectedStr: selectedEmployeeNameStr,
                menuItemStrList: getEmployeeNameListOnly(),
              );
            }

            Widget cardWidget() {
              Widget companyNameWidget() {
                Widget companyNameDropDownWidget() {
                  void onTapFunction() {}
                  final String? cardCompanyNameTemp = giveCardToMatModelTemp.cardCompanyName;
                  void onChangedFunction({required String value, required int index}) {
                    giveCardToMatModelTemp.cardCompanyName = value;
                    giveCardToMatModelTemp.cardCompanyNameId = cardModelListGlobal[index].id;
                    // giveCardToMatModelTemp.language = cardModelListAdminGlobal[index].language;
                    giveCardToMatModelTemp.category = null;
                    giveCardToMatModelTemp.categoryId = null;
                    addActiveLogElement(
                      activeLogModelList: activeLogModelGiveCardToMatList,
                      activeLogModel: ActiveLogModel(idTemp: "select card company name", activeType: ActiveLogTypeEnum.selectDropdown, locationList: [
                        Location(title: "select card company name", subtitle: "${(cardCompanyNameTemp == null) ? "" : "$cardCompanyNameTemp to "}$value"),
                      ]),
                    );
                    setState(() {});
                  }

                  return customDropdown(
                    level: Level.normal,
                    labelStr: cardCompanyNameStrGlobal,
                    onTapFunction: onTapFunction,
                    onChangedFunction: onChangedFunction,
                    selectedStr: giveCardToMatModelTemp.cardCompanyName,
                    menuItemStrList: cardCompanyNameOnlyList(),
                  );
                }

                return companyNameDropDownWidget();
              }

              Widget paddingRightCategoryDropDownWidget() {
                void onTapFunction() {}
                final String? categoryTemp = (giveCardToMatModelTemp.category == null)
                    ? null
                    : formatAndLimitNumberTextGlobal(
                        valueStr: giveCardToMatModelTemp.category.toString(),
                        isRound: false,
                      );
                void onChangedFunction({required String value, required int index}) {
                  final int companyNameIndex =
                      cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == giveCardToMatModelTemp.cardCompanyName)); //never equal -1

                  giveCardToMatModelTemp.category =
                      textEditingControllerToDouble(controller: cardModelListGlobal[companyNameIndex].categoryList[index].category);
                  giveCardToMatModelTemp.categoryId = cardModelListGlobal[companyNameIndex].categoryList[index].id;

                  addActiveLogElement(
                    activeLogModelList: activeLogModelGiveCardToMatList,
                    activeLogModel: ActiveLogModel(idTemp: "select card company name", activeType: ActiveLogTypeEnum.selectDropdown, locationList: [
                      Location(title: "select card company name", subtitle: "${(categoryTemp == null) ? "" : "$categoryTemp to "}$value"),
                    ]),
                  );
                  setState(() {});
                }

                return Padding(
                  padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
                  child: customDropdown(
                    level: Level.normal,
                    labelStr: categoryCardStrGlobal,
                    onTapFunction: onTapFunction,
                    onChangedFunction: onChangedFunction,
                    selectedStr: formatAndLimitNumberTextGlobal(valueStr: giveCardToMatModelTemp.category.toString(), isRound: true, isAllowZeroAtLast: false),
                    menuItemStrList: cardCategoryOnlyList(companyNameStr: giveCardToMatModelTemp.cardCompanyName),
                  ),
                );
              }

              return Row(children: [
                Expanded(flex: flexValueGlobal, child: companyNameWidget()),
                (giveCardToMatModelTemp.cardCompanyNameId == null) ? Container() : Expanded(flex: flexTypeGlobal, child: paddingRightCategoryDropDownWidget())
              ]);
            }

            Widget qtyTextFieldWidget() {
              final String qtyTemp = giveCardToMatModelTemp.qty.text;
              void onChangeFromOutsiderFunction() {
                final String qtyChangeTemp = giveCardToMatModelTemp.qty.text;
                addActiveLogElement(
                  activeLogModelList: activeLogModelGiveCardToMatList,
                  activeLogModel: ActiveLogModel(idTemp: "qty textfield", activeType: ActiveLogTypeEnum.typeTextfield, locationList: [
                    Location(
                      color: (qtyTemp.length < qtyChangeTemp.length) ? ColorEnum.green : ColorEnum.red,
                      title: "qty textfield",
                      subtitle: "${qtyTemp.isEmpty ? "" : "$qtyTemp to "}$qtyChangeTemp",
                    ),
                  ]),
                );
                setState(() {});
              }

              void onTapFromOutsiderFunction() {}
              return textFieldGlobal(
                textFieldDataType: TextFieldDataType.int,
                controller: giveCardToMatModelTemp.qty,
                onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                labelText: qtyCardStrGlobal,
                level: Level.normal,
                onTapFromOutsiderFunction: onTapFromOutsiderFunction,
              );
            }

            Widget remarkTextFieldWidget() {
              void onTapFromOutsiderFunction() {}
              final String remarkTemp = giveCardToMatModelTemp.remark.text;
              void onChangeFromOutsiderFunction() {
                final String remarkChangeTemp = giveCardToMatModelTemp.remark.text;
                addActiveLogElement(
                  activeLogModelList: activeLogModelGiveCardToMatList,
                  activeLogModel: ActiveLogModel(idTemp: "remark textfield", activeType: ActiveLogTypeEnum.typeTextfield, locationList: [
                    Location(
                      color: (remarkTemp.length < remarkChangeTemp.length) ? ColorEnum.green : ColorEnum.red,
                      title: "remark textfield",
                      subtitle: "${remarkTemp.isEmpty ? "" : "$remarkTemp to "}$remarkChangeTemp",
                    ),
                  ]),
                );
                setState(() {});
              }

              return textAreaGlobal(
                controller: giveCardToMatModelTemp.remark,
                onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                labelText: remarkOptionalStrGlobal,
                level: Level.normal,
              );
            }

            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              paddingBottomWidget(widget: singleToggleWidget()),
              paddingBottomWidget(widget: selectEmployee()),
              paddingBottomWidget(widget: cardWidget()),
              paddingBottomWidget(widget: qtyTextFieldWidget()),
              remarkTextFieldWidget(),
            ]);
          }

          void onTapUnlessDisable() {}
          return CustomButtonGlobal(
              insideSizeBoxWidget: customButtonWidget(), onTapUnlessDisable: onTapUnlessDisable, sizeBoxWidth: dialogSizeGlobal(level: Level.mini));
        }

        return [giveToMatWidget()];
      }

      void updateGiveCardToMatToDBOrPrint({required isPrint}) {
        setFinalEditionActiveLog(activeLogModelList: activeLogModelGiveCardToMatList);
        giveCardToMatModelTemp.activeLogModelList = activeLogModelGiveCardToMatList;
        void callBack({required bool isFullInvoiceCardStock}) {
          if (isFullInvoiceCardStock) {
            void okFunction() {
              closeDialogGlobal(context: context);
            }

            okDialogGlobal(
              context: context,
              okFunction: okFunction,
              titleStr: fullInvoiceCardStockStrGlobal,
              subtitleStr:
                  "${giveCardToMatModelTemp.employeeName} Card Stock of ${giveCardToMatModelTemp.cardCompanyName} x ${giveCardToMatModelTemp.category} Reach $fullInvoiceCardStockContentStrGlobal",
            );
          }
          if (!isFullInvoiceCardStock) {
            addMoneyOrCardToMatSocketIO(targetEmployeeId: giveCardToMatModelTemp.employeeId!);
          }
          giveCardToMatModelTemp =
              GiveCardToMatModel(activeLogModelList: [], qty: TextEditingController(), mainPriceQtyList: [], remark: TextEditingController());
          selectedEmployeeNameStr = null;
          if (isPrint && !isFullInvoiceCardStock) {
            printGiveCardToMatInvoice(giveCardToMatModel: giveCardToMatModelListEmployeeGlobal.first, context: context);
          }
          // setState(() {});
          activeLogModelGiveCardToMatList = [];
          widget.callback();
        }

        final int cardCompanyNameIndex = cardModelListGlobal.indexWhere((element) => (element.cardCompanyName.text == giveCardToMatModelTemp.cardCompanyName));
        final int categoryIndex = cardModelListGlobal[cardCompanyNameIndex]
            .categoryList
            .indexWhere((element) => (element.category.text == giveCardToMatModelTemp.category.toString()));

        int qtyNumberTemp = textEditingControllerToInt(controller: giveCardToMatModelTemp.qty)!; //40
        for (int mainIndex = 0; mainIndex < cardModelListGlobal[cardCompanyNameIndex].categoryList[categoryIndex].mainPriceList.length; mainIndex++) {
          CardMainPriceListCardModel cardMainPriceListCardModel =
              cardModelListGlobal[cardCompanyNameIndex].categoryList[categoryIndex].mainPriceList[mainIndex];
          final int stockNumber = textEditingControllerToInt(controller: cardMainPriceListCardModel.stock)!; //100

          final bool isOutOfStock = ((stockNumber - qtyNumberTemp) < 0); //(100 - 40) < 0 => 60 < 0 => false
          if (isOutOfStock) {
            qtyNumberTemp = qtyNumberTemp - stockNumber;
            cardMainPriceListCardModel.stock.text = "0";
            final MainPriceQty mainPriceQty = MainPriceQty(qty: stockNumber, mainPrice: cardMainPriceListCardModel, rate: null);
            giveCardToMatModelTemp.mainPriceQtyList.add(mainPriceQty);
          } else {
            cardMainPriceListCardModel.stock.text = (stockNumber - qtyNumberTemp).toString(); //100 - 40 => 60
            final MainPriceQty mainPriceQty = MainPriceQty(qty: qtyNumberTemp, mainPrice: cardMainPriceListCardModel, rate: null); //
            giveCardToMatModelTemp.mainPriceQtyList.add(mainPriceQty);
            break;
          }
        }
        updateGiveCardToMatAdminGlobal(callBack: callBack, context: context, giveCardToMatModelTemp: giveCardToMatModelTemp);
      }

      void saveOnTapFunction() {
        // void callBack() {
        //   giveCardToMatModelTemp = GiveCardToMatModel(qty: TextEditingController(), mainPriceQtyList: [], remark: TextEditingController());
        //   selectedEmployeeNameStr = null;
        //   setState(() {});
        // }

        // final int cardCompanyNameIndex = cardModelListAdminGlobal.indexWhere((element) => (element.cardCompanyName.text == giveCardToMatModelTemp.cardCompanyName));
        // final int categoryIndex = cardModelListAdminGlobal[cardCompanyNameIndex].categoryList.indexWhere((element) => (element.category.text == giveCardToMatModelTemp.category.toString()));

        // int qtyNumberTemp = textEditingControllerToInt(controller: giveCardToMatModelTemp.qty)!; //40
        // for (int mainIndex = 0; mainIndex < cardModelListAdminGlobal[cardCompanyNameIndex].categoryList[categoryIndex].mainPriceList.length; mainIndex++) {
        //   CardMainPriceListCardModel cardMainPriceListCardModel = cardModelListAdminGlobal[cardCompanyNameIndex].categoryList[categoryIndex].mainPriceList[mainIndex];
        //   final int stockNumber = textEditingControllerToInt(controller: cardMainPriceListCardModel.stock)!; //100

        //   final bool isOutOfStock = ((stockNumber - qtyNumberTemp) < 0); //(100 - 40) < 0 => 60 < 0 => false
        //   if (isOutOfStock) {
        //     qtyNumberTemp = qtyNumberTemp - stockNumber;
        //     cardMainPriceListCardModel.stock.text = "0";
        //     final MainPriceQty mainPriceQty = MainPriceQty(qty: stockNumber, mainPrice: cardMainPriceListCardModel, rate: null);
        //     giveCardToMatModelTemp.mainPriceQtyList.add(mainPriceQty);
        //   } else {
        //     cardMainPriceListCardModel.stock.text = (stockNumber - qtyNumberTemp).toString(); //100 - 40 => 60
        //     final MainPriceQty mainPriceQty = MainPriceQty(qty: qtyNumberTemp, mainPrice: cardMainPriceListCardModel, rate: null); //
        //     giveCardToMatModelTemp.mainPriceQtyList.add(mainPriceQty);
        //     break;
        //   }
        // }
        // updateGiveCardToMatAdminGlobal(callBack: callBack, context: context, giveCardToMatModelTemp: giveCardToMatModelTemp);

        addActiveLogElement(
          activeLogModelList: activeLogModelGiveCardToMatList,
          activeLogModel: ActiveLogModel(idTemp: "save or save and print button", activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "save button"),
          ]),
        );
        updateGiveCardToMatToDBOrPrint(isPrint: false);
      }

      void saveAndPrintOnTapFunction() {
        addActiveLogElement(
          activeLogModelList: activeLogModelGiveCardToMatList,
          activeLogModel: ActiveLogModel(idTemp: "save or save and print button", activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "save and print button"),
          ]),
        );
        updateGiveCardToMatToDBOrPrint(isPrint: true);
      }

      // bool isValidShowPrevious() {
      //   return false;
      // }
      void clearFunction() {
        // addMoneyOrCardToMatStockIO(targetEmployeeId: giveCardToMatModelTemp.employeeId!);
        giveCardToMatModelTemp =
            GiveCardToMatModel(activeLogModelList: [], qty: TextEditingController(), mainPriceQtyList: [], remark: TextEditingController());
        selectedEmployeeNameStr = null;

        addActiveLogElement(
          activeLogModelList: activeLogModelGiveCardToMatList,
          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "clear button"),
          ]),
        );
        setState(() {});
      }

      return BodyTemplateSideMenu(
        title: widget.title,
        isValidSaveOnTap: isValidGiveMoneyToMat(),
        isValidSaveAndPrintOnTap: isValidGiveMoneyToMat(),
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

    // return _isLoadingOnInitMoney ? Container() : bodyTemplateSideMenu();
    return bodyTemplateSideMenu();
  }
}
