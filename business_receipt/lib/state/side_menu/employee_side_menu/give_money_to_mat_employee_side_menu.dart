// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/active_log.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/employee.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/request_api/give_money_to_mat_request_api_env.dart';
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
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/employee_model/give_money_to_mat_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class GiveMoneyToMatEmployeeSideMenu extends StatefulWidget {
  String title;
  Function callback;
  GiveMoneyToMatEmployeeSideMenu({Key? key, required this.title, required this.callback}) : super(key: key);

  @override
  State<GiveMoneyToMatEmployeeSideMenu> createState() => _GiveMoneyToMatEmployeeSideMenuState();
}

class _GiveMoneyToMatEmployeeSideMenuState extends State<GiveMoneyToMatEmployeeSideMenu> {
  // bool _isLoadingOnInitMoney = false; //TODO: change this to true
  // bool isShowPrevious = false;
  String? selectedEmployeeNameStr;
  bool isInit = true;
  GiveMoneyToMatModel giveMoneyToMatModelTemp = GiveMoneyToMatModel(activeLogModelList: [], value: TextEditingController(), remark: TextEditingController());

  List<ActiveLogModel> activeLogModelGiveMoneyToMatList = [];
  @override
  Widget build(BuildContext context) {
    if (isInit) {
      selectedEmployeeNameStr = null;
      giveMoneyToMatModelTemp = GiveMoneyToMatModel(activeLogModelList: [], value: TextEditingController(), remark: TextEditingController());
      isInit = false;
    }
    Widget bodyTemplateSideMenu() {
      ValidButtonModel isValidGiveMoneyToMat() {
        final bool selectedEmployeeStrNull = (selectedEmployeeNameStr == null);
        final bool selectedMoneyTypeStrNull = (giveMoneyToMatModelTemp.moneyType == null);
        final bool valueControllerEmpty = giveMoneyToMatModelTemp.value.text.isEmpty;
        // if (selectedEmployeeStrNull || selectedMoneyTypeStrNull || valueControllerEmpty) {
        //   return false;
        // }
        if (selectedEmployeeStrNull) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            error: "please select an employee",
          );
        }
        if (selectedMoneyTypeStrNull) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            error: "please select a money type",
          );
        }
        if (valueControllerEmpty) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            error: "amount money is empty",
            errorType: ErrorTypeEnum.valueOfNumber,
          );
        }
        // else {
        final bool isValueEqual0 = (textEditingControllerToDouble(controller: giveMoneyToMatModelTemp.value) == 0);
        if (isValueEqual0) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            overwriteRule: "value must not be 0",
            error: "amount money equal 0",
            errorType: ErrorTypeEnum.valueOfString,
          );
        }
        final ValidButtonModel lowerMoneyStock = checkLowerTheExistMoney(
          moneyNumber: textEditingControllerToDouble(controller: giveMoneyToMatModelTemp.value)!,
          moneyType: giveMoneyToMatModelTemp.moneyType!,
        );
        if (!lowerMoneyStock.isValid) {
          // return false;
          return lowerMoneyStock;
        }
        // }
        // return true;
        return ValidButtonModel(isValid: true);
      }

      void historyOnTapFunction() {
        limitHistory();
        addActiveLogElement(
          activeLogModelList: activeLogModelGiveMoneyToMatList,
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
                children: [Text(giveMoneyToMatHistoryStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))], //TODO: change this
              ),
            );
          }

          Widget giveMoneyToMatHistoryListWidget() {
            //TODO: change this function name
            List<Widget> inWrapWidgetList() {
              return [
                for (int giveMoneyToMatIndex = 0; giveMoneyToMatIndex < giveMoneyToMatModelListEmployeeGlobal.length; giveMoneyToMatIndex++) //TODO: change this
                  HistoryElement(
                    isForceShowNoEffect: false,
                    isAdminEditing: false,
                    index: giveMoneyToMatIndex,
                    giveMoneyToMatModel: giveMoneyToMatModelListEmployeeGlobal[giveMoneyToMatIndex], //TODO: change this
                    setStateOutsider: setStateOutsider,
                  )
              ];
            }

            void topFunction() {}
            void bottomFunction() {
              if (!outOfDataQueryGiveMoneyToMatListGlobal) {
                //TODO: change this
                final int beforeQuery = giveMoneyToMatModelListEmployeeGlobal.length; //TODO: change this
                void callBack() {
                  final int afterQuery = giveMoneyToMatModelListEmployeeGlobal.length; //TODO: change this

                  if (beforeQuery == afterQuery) {
                    outOfDataQueryGiveMoneyToMatListGlobal = true; //TODO: change this
                  } else {
                    skipGiveMoneyToMatListGlobal = skipGiveMoneyToMatListGlobal + queryLimitNumberGlobal; //TODO: change this
                  }
                  setStateFromDialog(() {});
                }

                getGiveMoneyToMatListEmployeeGlobal(
                  employeeId: profileModelEmployeeGlobal!.id!,
                  callBack: callBack,
                  context: context,
                  skip: skipGiveMoneyToMatListGlobal,
                  targetDate: DateTime.now(),
                  giveMoneyToMatModelListEmployee: giveMoneyToMatModelListEmployeeGlobal,
                ); //TODO: change this
              }
            }

            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: !outOfDataQueryGiveMoneyToMatListGlobal,
            );
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleTextWidget(), Expanded(child: giveMoneyToMatHistoryListWidget())]);
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
            Widget singleToggleWidget() {
              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: singleToggleGlobal(singleOptionStr: decreaseMoneyStrGlobal, color: negativeColorGlobal),
              );
            }

            Widget selectEmployee() {
              void onTapFunction() {}
              final String? matTemp = giveMoneyToMatModelTemp.employeeName;
              void onChangedFunction({required String value, required int index}) {
                final int employeeMatchIndex = profileEmployeeModelListAdminGlobal.indexWhere((element) => (element.name.text == value));

                // for (int employeeIndex = 0; employeeIndex < profileEmployeeModelListAdminGlobal.length; employeeIndex++) {
                //   final bool isNameStrMatch = (profileEmployeeModelListAdminGlobal[employeeIndex].name.text == value);
                //   if (isNameStrMatch) {
                //     employeeMatchIndex = employeeIndex;
                //     break;
                //   }
                // }
                giveMoneyToMatModelTemp.employeeId = profileEmployeeModelListAdminGlobal[employeeMatchIndex].id;
                giveMoneyToMatModelTemp.employeeName = profileEmployeeModelListAdminGlobal[employeeMatchIndex].name.text;
                selectedEmployeeNameStr = value;
                addActiveLogElement(
                  activeLogModelList: activeLogModelGiveMoneyToMatList,
                  activeLogModel: ActiveLogModel(idTemp: "select mat", activeType: ActiveLogTypeEnum.selectDropdown, locationList: [
                    Location(title: "select mat", subtitle: "${(matTemp == null) ? "" : "$matTemp to "}$value"),
                  ]),
                );

                setState(() {});
              }

              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: customDropdown(
                  level: Level.normal,
                  labelStr: matStrGlobal,
                  onTapFunction: onTapFunction,
                  onChangedFunction: onChangedFunction,
                  selectedStr: selectedEmployeeNameStr,
                  menuItemStrList: getEmployeeNameListOnly(),
                ),
              );
            }

            Widget valueAndMoneyTypeWidget() {
              Widget amountTextFieldWidget() {
                final String amountTemp = giveMoneyToMatModelTemp.value.text;
                void onChangeFromOutsiderFunction() {
                  final String amountChangeTemp = giveMoneyToMatModelTemp.value.text;
                  addActiveLogElement(
                    activeLogModelList: activeLogModelGiveMoneyToMatList,
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
                    controller: giveMoneyToMatModelTemp.value,
                    onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                    labelText: amountStrGlobal,
                    level: Level.normal,
                    onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                  ),
                );
              }

              Widget moneyTypeDropDownWidget() {
                void onTapFunction() {}
                final String? moneyTypeTemp = giveMoneyToMatModelTemp.moneyType;
                void onChangedFunction({required String value, required int index}) {
                  giveMoneyToMatModelTemp.moneyType = value;
                  addActiveLogElement(
                    activeLogModelList: activeLogModelGiveMoneyToMatList,
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
                  selectedStr: giveMoneyToMatModelTemp.moneyType,
                  menuItemStrList: moneyTypeOnlyList(isNotCheckDeleted: false,moneyTypeDefault: giveMoneyToMatModelTemp.moneyType),
                );
              }

              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: Row(children: [
                  (giveMoneyToMatModelTemp.moneyType == null) ? Container() : Expanded(flex: flexValueGlobal, child: amountTextFieldWidget()),
                  Expanded(flex: flexTypeGlobal, child: moneyTypeDropDownWidget())
                ]),
              );
            }

            Widget remarkTextFieldWidget() {
              void onTapFromOutsiderFunction() {}
              final String remarkTemp = giveMoneyToMatModelTemp.remark.text;
              void onChangeFromOutsiderFunction() {
                final String remarkChangeTemp = giveMoneyToMatModelTemp.remark.text;
                addActiveLogElement(
                  activeLogModelList: activeLogModelGiveMoneyToMatList,
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
                controller: giveMoneyToMatModelTemp.remark,
                onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                labelText: remarkOptionalStrGlobal,
                level: Level.normal,
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [singleToggleWidget(), selectEmployee(), valueAndMoneyTypeWidget(), remarkTextFieldWidget()],
            );
          }

          void onTapUnlessDisable() {}
          return CustomButtonGlobal(
            insideSizeBoxWidget: customButtonWidget(),
            onTapUnlessDisable: onTapUnlessDisable,
            sizeBoxWidth: dialogSizeGlobal(level: Level.mini),
          );
        }

        return [giveToMatWidget()];
      }

      void updateOtherInOrOutComeToDBOrPrint({required isPrint}) {
        setFinalEditionActiveLog(activeLogModelList: activeLogModelGiveMoneyToMatList);
        giveMoneyToMatModelTemp.activeLogModelList = activeLogModelGiveMoneyToMatList;
        void callBack() {
          addMoneyOrCardToMatSocketIO(targetEmployeeId: giveMoneyToMatModelTemp.employeeId!);
          giveMoneyToMatModelTemp = GiveMoneyToMatModel(activeLogModelList: [], value: TextEditingController(), remark: TextEditingController());
          selectedEmployeeNameStr = null;
          if (isPrint) {
            printGiveMoneyToMatInvoice(giveMoneyToMatModel: giveMoneyToMatModelListEmployeeGlobal.first, context: context);
          }
          // setState(() {});
          activeLogModelGiveMoneyToMatList = [];
          widget.callback();
        }

        updateGiveMoneyToMatAdminGlobal(callBack: callBack, context: context, giveMoneyToMatModelTemp: giveMoneyToMatModelTemp);
      }

      void saveOnTapFunction() {
        // void callBack() {
        //   giveMoneyToMatModelTemp = GiveMoneyToMatModel(value: TextEditingController(), remark: TextEditingController());
        //   selectedEmployeeNameStr = null;
        //   setState(() {});
        // }

        // updateGiveMoneyToMatAdminGlobal(callBack: callBack, context: context, giveMoneyToMatModelTemp: giveMoneyToMatModelTemp);

        addActiveLogElement(
          activeLogModelList: activeLogModelGiveMoneyToMatList,
          activeLogModel: ActiveLogModel(idTemp: "save or save and print button", activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "save button"),
          ]),
        );
        updateOtherInOrOutComeToDBOrPrint(isPrint: false);
      }

      void saveAndPrintOnTapFunction() {
        addActiveLogElement(
          activeLogModelList: activeLogModelGiveMoneyToMatList,
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
        // addMoneyOrCardToMatStockIO(targetEmployeeId: giveMoneyToMatModelTemp.employeeId!);
        giveMoneyToMatModelTemp = GiveMoneyToMatModel(activeLogModelList: [], value: TextEditingController(), remark: TextEditingController());
        selectedEmployeeNameStr = null;
        addActiveLogElement(
          activeLogModelList: activeLogModelGiveMoneyToMatList,
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
