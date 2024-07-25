// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/active_log.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/request_api/other_in_or_out_come_request_api_env.dart';
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
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/employee_model/other_in_or_out_come_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class OtherInOrOutComeEmployeeSideMenu extends StatefulWidget {
  String title;
  Function callback;
  OtherInOrOutComeEmployeeSideMenu({Key? key, required this.title, required this.callback}) : super(key: key);

  @override
  State<OtherInOrOutComeEmployeeSideMenu> createState() => _OtherInOrOutComeEmployeeSideMenuState();
}

class _OtherInOrOutComeEmployeeSideMenuState extends State<OtherInOrOutComeEmployeeSideMenu> {
  // bool isShowPrevious = false;
  bool isIncome = true;
  OtherInOrOutComeModel otherInOrOutComeModelTemp =
      OtherInOrOutComeModel(activeLogModelList: [], value: TextEditingController(), remark: TextEditingController());
  List<ActiveLogModel> activeLogModelOtherInOrOutComeList = [];
  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      ValidButtonModel isValidGiveMoneyToMat() {
        final bool selectedMoneyTypeStrNull = (otherInOrOutComeModelTemp.moneyType == null);
        final bool valueControllerEmpty = otherInOrOutComeModelTemp.value.text.isEmpty;
        if (selectedMoneyTypeStrNull) {
          return ValidButtonModel(
            isValid: false,
            // errorType: ErrorTypeEnum.valueOfString,
            error: "please select money type",
          );
        }
        if (valueControllerEmpty) {
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfString,
            error: "amount is empty",
          );
        }
        // if (selectedMoneyTypeStrNull || valueControllerEmpty) {
        //   return false;
        // } else {
        final bool isValueEqual0 = (textEditingControllerToDouble(controller: otherInOrOutComeModelTemp.value) == 0);
        if (isValueEqual0) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfNumber,
            error: "amount must not be 0",
          );
        }

        if (!isIncome) {
          final ValidButtonModel lowerMoneyStock = checkLowerTheExistMoney(
            moneyNumber: textEditingControllerToDouble(controller: otherInOrOutComeModelTemp.value)!,
            moneyType: otherInOrOutComeModelTemp.moneyType!,
          );
          if (!lowerMoneyStock.isValid) {
            // return false;
            return lowerMoneyStock;
          }
        }
        // }
        // return true;
        return ValidButtonModel(isValid: true);
      }

      void historyOnTapFunction() {
        limitHistory();

        addActiveLogElement(
          activeLogModelList: activeLogModelOtherInOrOutComeList,
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
                children: [Text(otherInOrOutComeHistoryStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))], //TODO: change this
              ),
            );
          }

          //TODO: change this function name
          Widget otherInOrOutComeHistoryListWidget() {
            List<Widget> inWrapWidgetList() {
              return [
                for (int otherInOrComeIndex = 0; otherInOrComeIndex < otherInOrOutComeModelListEmployeeGlobal.length; otherInOrComeIndex++) //TODO: change this
                  HistoryElement(
                    isForceShowNoEffect: false,
                    isAdminEditing: false,
                    index: otherInOrComeIndex,
                    otherInOrOutComeModel: otherInOrOutComeModelListEmployeeGlobal[otherInOrComeIndex], //TODO: change this
                    setStateOutsider: setStateOutsider,
                  )
              ];
            }

            void topFunction() {}
            void bottomFunction() {
              if (!outOfDataQueryOtherInOrOutComeListGlobal) {
                //TODO: change this
                final int beforeQuery = otherInOrOutComeModelListEmployeeGlobal.length; //TODO: change this
                void callBack() {
                  final int afterQuery = otherInOrOutComeModelListEmployeeGlobal.length; //TODO: change this

                  if (beforeQuery == afterQuery) {
                    outOfDataQueryOtherInOrOutComeListGlobal = true; //TODO: change this
                  } else {
                    skipOtherInOrOutComeToMatListGlobal = skipOtherInOrOutComeToMatListGlobal + queryLimitNumberGlobal; //TODO: change this
                  }
                  setStateFromDialog(() {});
                }

                getOtherInOrOutComeListEmployeeGlobal(
                  employeeId: profileModelEmployeeGlobal!.id!,
                  callBack: callBack,
                  context: context,
                  skip: skipOtherInOrOutComeToMatListGlobal,
                  targetDate: DateTime.now(),
                  otherInOrOutComeModelListEmployee: otherInOrOutComeModelListEmployeeGlobal,
                ); //TODO: change this
              }
            }

            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: !outOfDataQueryOtherInOrOutComeListGlobal,
            );
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleTextWidget(), Expanded(child: otherInOrOutComeHistoryListWidget())]);
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
            Widget inOrOutComeToggleWidget() {
              void onToggle() {
                isIncome = !isIncome;
                addActiveLogElement(
                  activeLogModelList: activeLogModelOtherInOrOutComeList,
                  activeLogModel: ActiveLogModel(idTemp: "toggle button", activeType: ActiveLogTypeEnum.selectToggle, locationList: [
                    Location(
                      color: isIncome ? ColorEnum.green : ColorEnum.red,
                      title: "toggle button",
                      subtitle: isIncome ? "Outcome to Income" : "Income to Outcome",
                    ),
                  ]),
                );
                setState(() {});
              }

              return Padding(
                  padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                  child: incomeOrOutcomeToggleWidgetGlobal(isLeftSelected: isIncome, onToggle: onToggle));
            }

            Widget valueAndMoneyTypeWidget() {
              Widget priceTextFieldWidget() {
                final String amountTemp = otherInOrOutComeModelTemp.value.text;
                void onChangeFromOutsiderFunction() {
                  final String amountChangeTemp = otherInOrOutComeModelTemp.value.text;
                  addActiveLogElement(
                    activeLogModelList: activeLogModelOtherInOrOutComeList,
                    activeLogModel: ActiveLogModel(idTemp: "amount textfield", activeType: ActiveLogTypeEnum.typeTextfield, locationList: [
                      Location(
                        color: (amountTemp.length < amountChangeTemp.length) ? ColorEnum.green : ColorEnum.red,
                        title: "amount textfield",
                        subtitle: "${amountTemp.isEmpty ? "" : "$amountTemp to "}$amountChangeTemp",
                      ),
                    ]),
                  );
                  setState(() {});
                }

                void onTapFromOutsiderFunction() {}
                return Padding(
                  padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
                  child: textFieldGlobal(
                    textFieldDataType: TextFieldDataType.double,
                    controller: otherInOrOutComeModelTemp.value,
                    onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                    labelText: amountStrGlobal,
                    level: Level.normal,
                    onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                  ),
                );
              }

              Widget moneyTypeDropDownWidget() {
                void onTapFunction() {}
                final String? moneyTypeTemp = otherInOrOutComeModelTemp.moneyType;
                void onChangedFunction({required String value, required int index}) {
                  otherInOrOutComeModelTemp.moneyType = value;
                  addActiveLogElement(
                    activeLogModelList: activeLogModelOtherInOrOutComeList,
                    activeLogModel: ActiveLogModel(idTemp: "select money type", activeType: ActiveLogTypeEnum.selectDropdown, locationList: [
                      Location(title: "select money type", subtitle: "${(moneyTypeTemp == null) ? "" : "$moneyTypeTemp to "}$value"),
                    ]),
                  );

                  setState(() {});
                }

                return customDropdown(
                  level: Level.normal,
                  labelStr: moneyTypeStrGlobal,
                  onTapFunction: onTapFunction,
                  onChangedFunction: onChangedFunction,
                  selectedStr: otherInOrOutComeModelTemp.moneyType,
                  menuItemStrList: moneyTypeOnlyList(moneyTypeDefault: otherInOrOutComeModelTemp.moneyType, isNotCheckDeleted: false),
                );
              }

              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: Row(children: [
                  (otherInOrOutComeModelTemp.moneyType == null) ? Container() : Expanded(flex: flexValueGlobal, child: priceTextFieldWidget()),
                  Expanded(flex: flexTypeGlobal, child: moneyTypeDropDownWidget())
                ]),
              );
            }

            Widget remarkTextFieldWidget() {
              void onTapFromOutsiderFunction() {}
              final String remarkTemp = otherInOrOutComeModelTemp.remark.text;
              void onChangeFromOutsiderFunction() {
                final String remarkChangeTemp = otherInOrOutComeModelTemp.remark.text;
                addActiveLogElement(
                  activeLogModelList: activeLogModelOtherInOrOutComeList,
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
                controller: otherInOrOutComeModelTemp.remark,
                onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                labelText: remarkOptionalStrGlobal,
                level: Level.normal,
              );
            }

            return Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [inOrOutComeToggleWidget(), valueAndMoneyTypeWidget(), remarkTextFieldWidget()]);
          }

          void onTapUnlessDisable() {}
          return CustomButtonGlobal(
              insideSizeBoxWidget: customButtonWidget(), onTapUnlessDisable: onTapUnlessDisable, sizeBoxWidth: dialogSizeGlobal(level: Level.mini));
        }

        return [giveToMatWidget()];
      }

      void updateOtherInOrOutComeToDBOrPrint({required isPrint}) {
        setFinalEditionActiveLog(activeLogModelList: activeLogModelOtherInOrOutComeList);
        otherInOrOutComeModelTemp.activeLogModelList = activeLogModelOtherInOrOutComeList;
        void callBack() {
          otherInOrOutComeModelTemp = OtherInOrOutComeModel(activeLogModelList: [], value: TextEditingController(), remark: TextEditingController());
          isIncome = true;
          if (isPrint) {
            printOtherInOrOutComeInvoice(otherInOrOutComeModel: otherInOrOutComeModelListEmployeeGlobal.first, context: context);
          }
          // setState(() {});
          activeLogModelOtherInOrOutComeList = [];
          widget.callback();
        }

        updateOtherInOrOutComeAdminGlobal(callBack: callBack, context: context, otherInOrOutComeModelTemp: otherInOrOutComeModelTemp, isIncome: isIncome);
      }

      void saveOnTapFunction() {
        addActiveLogElement(
          activeLogModelList: activeLogModelOtherInOrOutComeList,
          activeLogModel: ActiveLogModel(idTemp: "save or save and print button", activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "save button"),
          ]),
        );
        updateOtherInOrOutComeToDBOrPrint(isPrint: false);
        // void callBack() {
        //   otherInOrOutComeModelTemp = OtherInOrOutComeModel(value: TextEditingController(), remark: TextEditingController());
        //   isIncome = true;
        //   setState(() {});
        // }

        // updateOtherInOrOutComeAdminGlobal(callBack: callBack, context: context, otherInOrOutComeModelTemp: otherInOrOutComeModelTemp, isIncome: isIncome);
      }

      void saveAndPrintOnTapFunction() {
        addActiveLogElement(
          activeLogModelList: activeLogModelOtherInOrOutComeList,
          activeLogModel: ActiveLogModel(idTemp: "save or save and print button", activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "save and print button"),
          ]),
        );
        updateOtherInOrOutComeToDBOrPrint(isPrint: true);
      }

      // bool isValidShowPrevious() {
      //   return false;
      // }
      void clearFunction() {
        otherInOrOutComeModelTemp = OtherInOrOutComeModel(activeLogModelList: [], value: TextEditingController(), remark: TextEditingController());
        isIncome = true;
        addActiveLogElement(
          activeLogModelList: activeLogModelOtherInOrOutComeList,
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
