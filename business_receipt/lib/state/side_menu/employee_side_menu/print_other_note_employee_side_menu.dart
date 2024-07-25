// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/customer.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/draw_line.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/text/text_area_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/toggle_env.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/currency_model.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/employee_model/calculate_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:business_receipt/state/side_menu/set_up_print_dialog.dart';
import 'package:flutter/material.dart';

class PrintOtherNoteEmployeeSideMenu extends StatefulWidget {
  String title;
  PrintOtherNoteEmployeeSideMenu({Key? key, required this.title}) : super(key: key);

  @override
  State<PrintOtherNoteEmployeeSideMenu> createState() => _PrintOtherNoteEmployeeSideMenuState();
}

class _PrintOtherNoteEmployeeSideMenuState extends State<PrintOtherNoteEmployeeSideMenu> {
  @override
  Widget build(BuildContext context) {
    void cancelFunctionOnTap() {
      // if (isAdminEditing) {
      void okFunction() {
        closeDialogGlobal(context: context);
      }

      void cancelFunction() {}
      confirmationDialogGlobal(
          context: context,
          okFunction: okFunction,
          cancelFunction: cancelFunction,
          titleStr: cancelEditingSettingGlobal,
          subtitleStr: cancelEditingSettingConfirmGlobal);
      // } else {
      // closeDialogGlobal(context: context);
      // }
    }

    Widget calculateByOperatorDialog() {
      Widget insideSizeBoxWidget() {
        // return scrollText(textStr: calculateOperatorStrPrintGlobal, textStyle: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold), alignment: Alignment.center);
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(calculateOperatorStrPrintGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
            Text("($createBySystemStrGlobal)", style: textStyleGlobal(level: Level.mini)),
          ],
        ));
      }

      void onTapUnlessDisable() {
        CalculateByAmount calculateTemp =
            CalculateByAmount(calculateElementList: [CalculateElement(valueController: TextEditingController())], remark: TextEditingController());

        ValidButtonModel checkCalculateOptionFunction() {
          for (int discountOptionIndex = 0; discountOptionIndex < calculateTemp.calculateElementList.length; discountOptionIndex++) {
            if (calculateTemp.calculateElementList[discountOptionIndex].valueController.text.isEmpty) {
              // return false;
              return ValidButtonModel(
                isValid: false,
                errorType: ErrorTypeEnum.valueOfNumber,
                error: "value is empty",
                errorLocationList: [
                  TitleAndSubtitleModel(title: "calculate index", subtitle: discountOptionIndex.toString()),
                  TitleAndSubtitleModel(title: "value", subtitle: calculateTemp.calculateElementList[discountOptionIndex].valueController.text),
                ],
              );
            } else {
              if (textEditingControllerToDouble(controller: calculateTemp.calculateElementList[discountOptionIndex].valueController)! == 0) {
                // return false;
                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.valueOfNumber,
                  error: "value equal 0",
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "calculate index", subtitle: discountOptionIndex.toString()),
                    TitleAndSubtitleModel(title: "value", subtitle: calculateTemp.calculateElementList[discountOptionIndex].valueController.text),
                  ],
                );
              }
            }
          }
          // return true;
          return ValidButtonModel(isValid: true);
        }

        Widget editCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleWidget() {
            String calculateTotal() {
              double totalNumber = 0;
              if (checkCalculateOptionFunction().isValid) {
                for (int calculateIndex = 0; calculateIndex < calculateTemp.calculateElementList.length; calculateIndex++) {
                  if (calculateTemp.calculateElementList[calculateIndex].valueController.text.isNotEmpty) {
                    double valueNumber = textEditingControllerToDouble(controller: calculateTemp.calculateElementList[calculateIndex].valueController)!;
                    bool isSum = (calculateTemp.calculateElementList[calculateIndex].operatorStr == "+");
                    totalNumber = totalNumber + ((isSum ? 1 : -1) * valueNumber);
                  }
                }
              }
              return formatAndLimitNumberTextGlobal(valueStr: totalNumber.toString(), isRound: calculateTemp.isFormat);
            }

            Widget moneyTypeDropDownWidget() {
              void onTapFunction() {}
              void onChangedFunction({required String value, required int index}) {
                calculateTemp.moneyType = value;
                setStateFromDialog(() {});
              }

              return customDropdown(
                level: Level.mini,
                labelStr: moneyTypeStrGlobal,
                onTapFunction: onTapFunction,
                onChangedFunction: onChangedFunction,
                selectedStr: calculateTemp.moneyType,
                menuItemStrList: moneyTypeOnlyList(moneyTypeDefault: calculateTemp.moneyType, isNotCheckDeleted: false),
              );
            }

            Widget toggleWidget() {
              void onToggle() {
                calculateTemp.isFormat = !calculateTemp.isFormat;
                setStateFromDialog(() {});
              }

              return Padding(
                padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
                child: roundToggleWidgetGlobal(isLeftSelected: calculateTemp.isFormat, onToggle: onToggle),
              );
            }

            Widget totalTextWidget() {
              return Padding(
                padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
                child: Text("$totalStrGlobal: ${calculateTotal()}", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
              );
            }

            return Row(children: [totalTextWidget(), Expanded(child: moneyTypeDropDownWidget()), toggleWidget()]);
          }

          Widget calculateListWidget() {
            Widget textFieldAndDeleteWidget({required int calculateIndex}) {
              void onTapUnlessDisable() {
                //TODO: do something
              }
              void onDeleteUnlessDisable() {
                calculateTemp.calculateElementList.removeAt(calculateIndex);
                setStateFromDialog(() {});
              }

              Widget insideSizeBoxWidget() {
                Widget textFieldAndDeleteWidget() {
                  void onChangeFromOutsiderFunction() {
                    setStateFromDialog(() {});
                  }

                  void onTapFromOutsiderFunction() {}
                  return textFieldGlobal(
                    labelText: calculateElementStrGlobal,
                    level: Level.mini,
                    controller: calculateTemp.calculateElementList[calculateIndex].valueController,
                    onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                    textFieldDataType: TextFieldDataType.double,
                    onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                  );
                }

                Widget toggleWidget() {
                  void onToggle() {
                    bool isSum = (calculateTemp.calculateElementList[calculateIndex].operatorStr == "+");
                    if (isSum) {
                      calculateTemp.calculateElementList[calculateIndex].operatorStr = "-";
                    } else {
                      calculateTemp.calculateElementList[calculateIndex].operatorStr = "+";
                    }
                    setStateFromDialog(() {});
                  }

                  return Padding(
                    padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
                    child:
                        operatorToggleWidgetGlobal(isLeftSelected: (calculateTemp.calculateElementList[calculateIndex].operatorStr == "+"), onToggle: onToggle),
                  );
                }

                return Row(children: [toggleWidget(), Expanded(child: textFieldAndDeleteWidget())]);
              }

              return CustomButtonGlobal(
                level: Level.mini,
                isDisable: true,
                insideSizeBoxWidget: insideSizeBoxWidget(),
                onTapUnlessDisable: onTapUnlessDisable,
                onDeleteUnlessDisable: (calculateTemp.calculateElementList.length == 1) ? null : onDeleteUnlessDisable,
              );
            }

            Widget paddingBottomAddButtonWidget() {
              Widget addButtonWidget() {
                void onTapFunction() {
                  calculateTemp.calculateElementList.add(CalculateElement(valueController: TextEditingController()));
                  setStateFromDialog(() {});
                }

                return addButtonOrContainerWidget(
                    context: context,
                    validModel: checkCalculateOptionFunction(),
                    level: Level.mini,
                    isExpanded: true,
                    onTapFunction: onTapFunction,
                    currentAddButtonQty: calculateTemp.calculateElementList.length,
                    maxAddButtonLimit: printCalculateAddButtonLimitGlobal);
              }

              return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)), child: addButtonWidget());
            }

            Widget remarkTextFieldWidget() {
              void onTapFromOutsiderFunction() {}
              void onChangeFromOutsiderFunction() {
                setStateFromDialog(() {});
              }

              return textAreaGlobal(
                controller: calculateTemp.remark,
                onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                labelText: remarkOptionalStrGlobal,
                level: Level.normal,
              );
            }

            return Column(children: [
              for (int discountOptionIndex = 0; discountOptionIndex < calculateTemp.calculateElementList.length; discountOptionIndex++)
                textFieldAndDeleteWidget(calculateIndex: discountOptionIndex),
              paddingBottomAddButtonWidget(),
              remarkTextFieldWidget(),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleWidget(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: paddingSizeGlobal(level: Level.mini), right: paddingSizeGlobal(level: Level.mini), top: paddingSizeGlobal(level: Level.normal)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [calculateListWidget()]),
                ),
              ),
            ),
          ]);
        }

        void printFunctionOnTap() {
          printCalculateByOperatorInvoice(calculate: calculateTemp, context: context);
          calculateTemp = CalculateByAmount(calculateElementList: [], remark: TextEditingController());
          closeDialogGlobal(context: context);
        }

        ValidButtonModel validPrintFunctionOnTap() {
          if (calculateTemp.moneyType == null) {
            return ValidButtonModel(isValid: false, error: "please select money type");
          }
          if (calculateTemp.calculateElementList.isEmpty) {
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              error: "calculate element is empty",
              errorLocationList: [TitleAndSubtitleModel(title: "calculate length", subtitle: calculateTemp.calculateElementList.length.toString())],
            );
          }
          return checkCalculateOptionFunction();
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini),
          dialogWidth: dialogSizeGlobal(level: Level.mini),
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          printFunctionOnTap: printFunctionOnTap,
          validPrintFunctionOnTap: () => validPrintFunctionOnTap(),
          // validPrintFunctionOnTap: () {
          //   return (checkCalculateOptionFunction() && (calculateTemp.moneyType != null) && calculateTemp.calculateElementList.isNotEmpty);
          // },
          contentFunctionReturnWidget: editCardDialog,
        );
      }

      return CustomButtonGlobal(
          sizeBoxWidth: sizeBoxWidthGlobal,
          sizeBoxHeight: sizeBoxHeightGlobal,
          insideSizeBoxWidget: insideSizeBoxWidget(),
          onTapUnlessDisable: onTapUnlessDisable);
    }

    Widget calculateByValueListDialog() {
      Widget insideSizeBoxWidget() {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(calculateValueStrPrintGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
            Text("($createBySystemStrGlobal)", style: textStyleGlobal(level: Level.mini)),
          ],
        ));
      }

      void onTapUnlessDisable() {
        CalculateByAmount calculateTemp = CalculateByAmount(
          calculateElementList: [
            for (int moneyIndex = 0; moneyIndex > currencyModelListAdminGlobal.length; moneyIndex++) CalculateElement(valueController: TextEditingController()),
          ],
          remark: TextEditingController(),
        );

        ValidButtonModel checkCalculateOptionFunction() {
          bool isValid = false;
          for (int discountOptionIndex = 0; discountOptionIndex < calculateTemp.calculateElementList.length; discountOptionIndex++) {
            if (calculateTemp.calculateElementList[discountOptionIndex].valueController.text.isNotEmpty) {
              if (textEditingControllerToDouble(controller: calculateTemp.calculateElementList[discountOptionIndex].valueController)! != 0) {
                isValid = true;
              }
            }
          }
          // return isValid;
          return ValidButtonModel(
            isValid: isValid,
            errorType: ErrorTypeEnum.valueOfNumber,
            error: "value equal 0",
            errorLocationList: [
              TitleAndSubtitleModel(title: "calculate length", subtitle: calculateTemp.calculateElementList.length.toString()),
            ],
          );
        }

        Widget editCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleWidget() {
            String calculateTotal() {
              double totalNumber = 0;
              if (checkCalculateOptionFunction().isValid) {
                for (int calculateIndex = 0; calculateIndex < calculateTemp.calculateElementList.length; calculateIndex++) {
                  if (calculateTemp.calculateElementList[calculateIndex].valueController.text.isNotEmpty) {
                    // double valueNumber = 0;
                    // textEditingControllerToDouble(controller: calculateTemp.calculateElementList[calculateIndex].valueController)!;
                    // final bool isQtyCalculate = (calculateTemp.calculateElementList[calculateIndex].valueStr != "0");
                    // double valueNumber = 0;
                    // if (isQtyCalculate) {
                    final double qtyNumber = textEditingControllerToDouble(controller: calculateTemp.calculateElementList[calculateIndex].valueController)!;
                    final double valueTypeNumber = double.parse(formatAndLimitNumberTextGlobal(
                        valueStr: calculateTemp.calculateElementList[calculateIndex].valueStr, isRound: false, isAddComma: false));
                    final double valueNumber = (qtyNumber * valueTypeNumber);
                    // } else {
                    //   valueNumber = textEditingControllerToDouble(controller: calculateTemp.calculateElementList[calculateIndex].valueController)!;
                    // }
                    bool isSum = (calculateTemp.calculateElementList[calculateIndex].operatorStr == "+");
                    totalNumber = totalNumber + ((isSum ? 1 : -1) * valueNumber);
                  }
                }
              }
              return formatAndLimitNumberTextGlobal(valueStr: totalNumber.toString(), isRound: calculateTemp.isFormat);
            }

            Widget moneyTypeDropDownWidget() {
              void onTapFunction() {}
              void onChangedFunction({required String value, required int index}) {
                calculateTemp.moneyType = value;
                final CurrencyModel currencyModel = findMoneyModelByMoneyType(moneyType: calculateTemp.moneyType!);
                List<CalculateElement> calculateElementList = [];
                // for (int calculationIndex = 0; calculationIndex < currencyModel.valueList.length; calculationIndex++) {
                //   calculateTemp.calculateElementList.removeAt(calculationIndex);
                // }
                for (int moneyIndex = 0; moneyIndex < currencyModel.valueList.length; moneyIndex++) {
                  calculateElementList.add(CalculateElement(
                    valueController: TextEditingController(),
                    valueStr: formatAndLimitNumberTextGlobal(valueStr: currencyModel.valueList[moneyIndex].toString(), isRound: false),
                  ));
                }
                calculateTemp.calculateElementList = calculateElementList;
                setStateFromDialog(() {});
              }

              return customDropdown(
                level: Level.mini,
                labelStr: moneyTypeStrGlobal,
                onTapFunction: onTapFunction,
                onChangedFunction: onChangedFunction,
                selectedStr: calculateTemp.moneyType,
                menuItemStrList: moneyTypeOnlyList(moneyTypeDefault: calculateTemp.moneyType, isNotCheckDeleted: false),
              );
            }

            Widget toggleWidget() {
              void onToggle() {
                calculateTemp.isFormat = !calculateTemp.isFormat;
                setStateFromDialog(() {});
              }

              return Padding(
                padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
                child: roundToggleWidgetGlobal(isLeftSelected: calculateTemp.isFormat, onToggle: onToggle),
              );
            }

            Widget totalTextWidget() {
              return Padding(
                padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
                child: Text("$totalStrGlobal: ${calculateTotal()}", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
              );
            }

            return Row(children: [totalTextWidget(), Expanded(child: moneyTypeDropDownWidget()), toggleWidget()]);
          }

          Widget calculateListWidget() {
            Widget textFieldAndDeleteWidget({required int calculateIndex}) {
              void onTapUnlessDisable() {
                //TODO: do something
              }
              // void onDeleteUnlessDisable() {
              //   calculateTemp.calculateElementList.removeAt(calculateIndex);
              //   setStateFromDialog(() {});
              // }

              Widget insideSizeBoxWidget() {
                Widget textFieldAndDeleteWidget() {
                  void onChangeFromOutsiderFunction() {
                    setStateFromDialog(() {});
                  }

                  void onTapFromOutsiderFunction() {}
                  return textFieldGlobal(
                    labelText: "$qtyCardStrGlobal (${calculateTemp.calculateElementList[calculateIndex].valueStr} ${calculateTemp.moneyType})",
                    level: Level.mini,
                    controller: calculateTemp.calculateElementList[calculateIndex].valueController,
                    onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                    textFieldDataType: TextFieldDataType.double,
                    onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                  );
                }

                Widget toggleWidget() {
                  void onToggle() {
                    bool isSum = (calculateTemp.calculateElementList[calculateIndex].operatorStr == "+");
                    if (isSum) {
                      calculateTemp.calculateElementList[calculateIndex].operatorStr = "-";
                    } else {
                      calculateTemp.calculateElementList[calculateIndex].operatorStr = "+";
                    }
                    setStateFromDialog(() {});
                  }

                  return Padding(
                    padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
                    child:
                        operatorToggleWidgetGlobal(isLeftSelected: (calculateTemp.calculateElementList[calculateIndex].operatorStr == "+"), onToggle: onToggle),
                  );
                }

                return Row(children: [toggleWidget(), Expanded(child: textFieldAndDeleteWidget())]);
              }

              return CustomButtonGlobal(
                level: Level.mini,
                isDisable: true,
                insideSizeBoxWidget: insideSizeBoxWidget(),
                onTapUnlessDisable: onTapUnlessDisable,
                // onDeleteUnlessDisable: onDeleteUnlessDisable,
              );
            }

            Widget remarkTextFieldWidget() {
              void onTapFromOutsiderFunction() {}
              void onChangeFromOutsiderFunction() {
                setStateFromDialog(() {});
              }

              return textAreaGlobal(
                controller: calculateTemp.remark,
                onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                labelText: remarkOptionalStrGlobal,
                level: Level.normal,
              );
            }

            return Column(children: [
              for (int discountOptionIndex = 0; discountOptionIndex < calculateTemp.calculateElementList.length; discountOptionIndex++)
                textFieldAndDeleteWidget(calculateIndex: discountOptionIndex),
              remarkTextFieldWidget(),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleWidget(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: paddingSizeGlobal(level: Level.mini), right: paddingSizeGlobal(level: Level.mini), top: paddingSizeGlobal(level: Level.normal)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [calculateListWidget()]),
                ),
              ),
            ),
          ]);
        }

        void printFunctionOnTap() {
          printCalculateByOperatorInvoice(calculate: calculateTemp, context: context);
          calculateTemp =
              CalculateByAmount(calculateElementList: [CalculateElement(valueController: TextEditingController())], remark: TextEditingController());
          closeDialogGlobal(context: context);
        }

        ValidButtonModel validPrintFunctionOnTap() {
          for (int calculateIndex = 0; calculateIndex < calculateTemp.calculateElementList.length; calculateIndex++) {
            if (calculateTemp.calculateElementList[calculateIndex].valueController.text.isNotEmpty) {
              if (textEditingControllerToDouble(controller: calculateTemp.calculateElementList[calculateIndex].valueController)! == 0) {
                // return false;
                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.valueOfNumber,
                  error: "value equal 0",
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "calculate index", subtitle: calculateIndex.toString()),
                    TitleAndSubtitleModel(title: "value", subtitle: calculateTemp.calculateElementList[calculateIndex].valueController.text),
                  ],
                );
              }
            }
          }
          // return (checkCalculateOptionFunction() && (calculateTemp.moneyType != null) && calculateTemp.calculateElementList.isNotEmpty);
          if (calculateTemp.moneyType == null) {
            return ValidButtonModel(isValid: false, error: "please select money type");
          }
          if (calculateTemp.calculateElementList.isEmpty) {
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              error: "calculate element is empty",
              errorLocationList: [TitleAndSubtitleModel(title: "calculate length", subtitle: calculateTemp.calculateElementList.length.toString())],
            );
          }
          return checkCalculateOptionFunction();
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini),
          dialogWidth: dialogSizeGlobal(level: Level.mini),
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          printFunctionOnTap: printFunctionOnTap,
          validPrintFunctionOnTap: () => validPrintFunctionOnTap(),
          contentFunctionReturnWidget: editCardDialog,
        );
      }

      return CustomButtonGlobal(
          sizeBoxWidth: sizeBoxWidthGlobal,
          sizeBoxHeight: sizeBoxHeightGlobal,
          insideSizeBoxWidget: insideSizeBoxWidget(),
          onTapUnlessDisable: onTapUnlessDisable);
    }

    Widget cardDialog() {
      Widget insideSizeBoxWidget() {
        // return scrollText(textStr: calculateOperatorStrPrintGlobal, textStyle: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold), alignment: Alignment.center);
        return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(cardStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
            Text("($createBySystemStrGlobal)", style: textStyleGlobal(level: Level.mini)),
          ]),
        );
      }

      void onTapUnlessDisable() {
        TextEditingController remarkController = TextEditingController();

        for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
          for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++) {
            cardModelListGlobal[cardIndex].categoryList[categoryIndex].isSelectedPrint = false;
            for (int sellPriceIndex = 0; sellPriceIndex < cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList.length; sellPriceIndex++) {
              cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].isSelectedPrint = true;
            }
          }
        }

        ValidButtonModel checkCalculateOptionFunction() {
          for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++) {
            for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++) {
              if (cardModelListGlobal[cardIndex].categoryList[categoryIndex].isSelectedPrint) {
                for (int sellPriceIndex = 0;
                    sellPriceIndex < cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList.length;
                    sellPriceIndex++) {
                  if (cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].isSelectedPrint) {
                    // return true;
                    return ValidButtonModel(isValid: true);
                  }
                }
              }
            }
          }
          for (int cardCombineIndex = 0; cardCombineIndex < cardCombineModelListGlobal.length; cardCombineIndex++) {
            if (cardCombineModelListGlobal[cardCombineIndex].isSelectedPrint) {
              // return true;
              return ValidButtonModel(isValid: true);
            }
          }
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfNumber,
            error: "no selected",
          );
        }

        Widget editCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleWidget() {
            return Padding(
              padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
              child: Text(selectCardStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
            );
          }

          Widget calculateListWidget() {
            Widget textFieldAndDeleteWidget({required int cardIndex, required int categoryIndex}) {
              void onTapUnlessDisable() {
                //TODO: do something
              }

              final String companyStr = cardModelListGlobal[cardIndex].cardCompanyName.text;
              final String categoryStr = cardModelListGlobal[cardIndex].categoryList[categoryIndex].category.text;

              Widget toggleWidget() {
                void onToggle() {
                  cardModelListGlobal[cardIndex].categoryList[categoryIndex].isSelectedPrint =
                      !cardModelListGlobal[cardIndex].categoryList[categoryIndex].isSelectedPrint;
                  if (cardModelListGlobal[cardIndex].categoryList[categoryIndex].isSelectedPrint) {
                    for (int sellPriceIndex = 0;
                        sellPriceIndex < cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList.length;
                        sellPriceIndex++) {
                      cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].isSelectedPrint = true;
                    }
                  }
                  setStateFromDialog(() {});
                }

                return showAndHideToggleWidgetGlobal(
                  isLeftSelected: cardModelListGlobal[cardIndex].categoryList[categoryIndex].isSelectedPrint,
                  onToggle: onToggle,
                );
              }

              Widget sellPriceWidget({required int sellIndex}) {
                final String startPriceStr = cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellIndex].startValue.text;
                final String endPriceStr = cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellIndex].endValue.text;
                final String priceStr = cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellIndex].price.text;
                final String moneyType = cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellIndex].moneyType!;
                Widget subToggleWidget() {
                  void onToggle() {
                    cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellIndex].isSelectedPrint =
                        !cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellIndex].isSelectedPrint;
                    bool isAllHide = true;
                    for (int subSellIndex = 0; subSellIndex < cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList.length; subSellIndex++) {
                      if (cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[subSellIndex].isSelectedPrint) {
                        isAllHide = false;
                        break;
                      }
                    }
                    if (isAllHide) {
                      cardModelListGlobal[cardIndex].categoryList[categoryIndex].isSelectedPrint = false;
                    }
                    setStateFromDialog(() {});
                  }

                  return showAndHideToggleWidgetGlobal(
                    isLeftSelected: cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellIndex].isSelectedPrint,
                    onToggle: onToggle,
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.large)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text("$startPriceStr <= x <= $endPriceStr ($priceStr $moneyType)", style: textStyleGlobal(level: Level.normal))),
                      subToggleWidget(),
                    ]),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.mini)),
                      child: drawLineGlobal(),
                    ),
                  ]),
                );
              }

              Widget insideSizeBoxWidget() {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Expanded(child: Text("$companyStr x $categoryStr", style: textStyleGlobal(level: Level.normal))), toggleWidget()]),
                  cardModelListGlobal[cardIndex].categoryList[categoryIndex].isSelectedPrint
                      ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.mini)),
                            child: drawLineGlobal(),
                          ),
                          for (int sellPriceIndex = 0;
                              sellPriceIndex < cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList.length;
                              sellPriceIndex++)
                            sellPriceWidget(sellIndex: sellPriceIndex)
                        ])
                      : Container(),
                ]);
              }

              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: CustomButtonGlobal(
                  level: Level.mini,
                  insideSizeBoxWidget: insideSizeBoxWidget(),
                  onTapUnlessDisable: onTapUnlessDisable,
                ),
              );
            }

            Widget textCombineWidget({required int cardCombineIndex}) {
              void onTapUnlessDisable() {}

              Widget insideSizeBoxWidget() {
                Widget toggleWidget() {
                  void onToggle() {
                    cardCombineModelListGlobal[cardCombineIndex].isSelectedPrint = !cardCombineModelListGlobal[cardCombineIndex].isSelectedPrint;
                    setStateFromDialog(() {});
                  }

                  return showAndHideToggleWidgetGlobal(
                    isLeftSelected: cardCombineModelListGlobal[cardCombineIndex].isSelectedPrint,
                    onToggle: onToggle,
                  );
                }

                Widget subCardCombineWidget({required int subCardCombineIndex}) {
                  final String companyStr = cardCombineModelListGlobal[cardCombineIndex].cardList[subCardCombineIndex].cardCompanyName!;
                  final String categoryStr = formatAndLimitNumberTextGlobal(
                    valueStr: cardCombineModelListGlobal[cardCombineIndex].cardList[subCardCombineIndex].category!.toString(),
                    isRound: false,
                  );
                  final String priceStr = cardCombineModelListGlobal[cardCombineIndex].cardList[subCardCombineIndex].sellPrice!;
                  return Text("$companyStr x $categoryStr: $priceStr", style: textStyleGlobal(level: Level.normal));
                }

                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(cardCombineModelListGlobal[cardCombineIndex].combineName.text, style: textStyleGlobal(level: Level.normal))),
                    toggleWidget(),
                  ]),
                  cardCombineModelListGlobal[cardCombineIndex].isSelectedPrint
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.mini)),
                          child: drawLineGlobal(),
                        )
                      : Container(),
                  cardCombineModelListGlobal[cardCombineIndex].isSelectedPrint
                      ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          for (int subCardCombineIndex = 0;
                              subCardCombineIndex < cardCombineModelListGlobal[cardCombineIndex].cardList.length;
                              subCardCombineIndex++)
                            subCardCombineWidget(subCardCombineIndex: subCardCombineIndex)
                        ])
                      : Container(),
                ]);
              }

              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: CustomButtonGlobal(
                  level: Level.mini,
                  insideSizeBoxWidget: insideSizeBoxWidget(),
                  onTapUnlessDisable: onTapUnlessDisable,
                ),
              );
            }

            Widget remarkTextFieldWidget() {
              void onTapFromOutsiderFunction() {}
              void onChangeFromOutsiderFunction() {
                setStateFromDialog(() {});
              }

              return textAreaGlobal(
                controller: remarkController,
                onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                labelText: remarkOptionalStrGlobal,
                level: Level.normal,
              );
            }

            return Column(children: [
              for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++)
                for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++)
                  textFieldAndDeleteWidget(cardIndex: cardIndex, categoryIndex: categoryIndex),
              for (int cardCombineIndex = 0; cardCombineIndex < cardCombineModelListGlobal.length; cardCombineIndex++)
                textCombineWidget(cardCombineIndex: cardCombineIndex),
              remarkTextFieldWidget(),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleWidget(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: paddingSizeGlobal(level: Level.mini),
                  right: paddingSizeGlobal(level: Level.mini),
                  top: paddingSizeGlobal(level: Level.normal),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [calculateListWidget()]),
                  ),
                ),
              ),
            ),
          ]);
        }

        void printFunctionOnTap() {
          cardPriceInvoiceInvoice(remark: remarkController, context: context);
          closeDialogGlobal(context: context);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini),
          dialogWidth: dialogSizeGlobal(level: Level.mini),
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          printFunctionOnTap: printFunctionOnTap,
          validPrintFunctionOnTap: () => checkCalculateOptionFunction(),
          contentFunctionReturnWidget: editCardDialog,
        );
      }

      return CustomButtonGlobal(
        sizeBoxWidth: sizeBoxWidthGlobal,
        sizeBoxHeight: sizeBoxHeightGlobal,
        insideSizeBoxWidget: insideSizeBoxWidget(),
        onTapUnlessDisable: onTapUnlessDisable,
      );
    }

    Widget rateDialog() {
      Widget insideSizeBoxWidget() {
        // return scrollText(textStr: calculateOperatorStrPrintGlobal, textStyle: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold), alignment: Alignment.center);
        return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(rateStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
            Text("($createBySystemStrGlobal)", style: textStyleGlobal(level: Level.mini)),
          ]),
        );
      }

      void onTapUnlessDisable() {
        TextEditingController remarkController = TextEditingController();

        for (int rateIndex = 0; rateIndex < rateModelListAdminGlobal.length; rateIndex++) {
          RateModel rateModel = rateModelListAdminGlobal[rateIndex];
          if (rateModel.buy != null) {
            if (rateModel.buy!.isSelectedPrint) {
              rateModel.buy!.isSelectedPrint = false;
            }
          }
          if (rateModel.sell != null) {
            if (rateModel.sell!.isSelectedPrint) {
              rateModel.sell!.isSelectedPrint = false;
            }
          }
        }

        ValidButtonModel checkCalculateOptionFunction() {
          for (int rateIndex = 0; rateIndex < rateModelListAdminGlobal.length; rateIndex++) {
            RateModel rateModel = rateModelListAdminGlobal[rateIndex];
            if (rateModel.buy != null) {
              if (rateModel.buy!.isSelectedPrint) {
                // return true;
                return ValidButtonModel(isValid: true);
              }
            }
            if (rateModel.sell != null) {
              if (rateModel.sell!.isSelectedPrint) {
                // return true;
                return ValidButtonModel(isValid: true);
              }
            }
          }
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfNumber,
            error: "no selected",
          );
        }

        Widget editCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleWidget() {
            return Padding(
              padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
              child: Text(selectRateStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
            );
          }

          Widget calculateListWidget() {
            Widget textFieldAndDeleteWidget({required rateIndex}) {
              void onTapUnlessDisable() {
                //TODO: do something
              }

              Widget toggleWidget({required BuyOrSellRateModel buyOrSellRateModel}) {
                void onToggle() {
                  buyOrSellRateModel.isSelectedPrint = !buyOrSellRateModel.isSelectedPrint;
                  setStateFromDialog(() {});
                }

                return showAndHideToggleWidgetGlobal(
                  isLeftSelected: buyOrSellRateModel.isSelectedPrint,
                  onToggle: onToggle,
                );
              }

              Widget insideSizeBoxWidget() {
                final String rateTypeFirstStr = rateModelListAdminGlobal[rateIndex].rateType.first;
                final String rateTypeLastStr = rateModelListAdminGlobal[rateIndex].rateType.last;
                // final String rateTypeFirstLanguageStr = findMoneyModelByMoneyType(moneyType: rateTypeFirstStr).moneyTypeLanguagePrint!;
                // final String rateTypeLastLanguageStr = findMoneyModelByMoneyType(moneyType: rateTypeLastStr).moneyTypeLanguagePrint!;
                Widget rateWidget({required BuyOrSellRateModel buyOrSellRateModel, required bool isBuy}) {
                  final String rateTypeStr = isBuy ? "$rateTypeFirstStr -> $rateTypeLastStr" : "$rateTypeLastStr -> $rateTypeFirstStr";
                  final String valueStr = buyOrSellRateModel.value.text;
                  return Row(children: [
                    Expanded(child: Text("$rateTypeStr: $valueStr", style: textStyleGlobal(level: Level.normal))),
                    toggleWidget(buyOrSellRateModel: buyOrSellRateModel)
                  ]);
                }

                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  (rateModelListAdminGlobal[rateIndex].buy == null)
                      ? Container()
                      : rateWidget(buyOrSellRateModel: rateModelListAdminGlobal[rateIndex].buy!, isBuy: true),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.mini)),
                    child: drawLineGlobal(),
                  ),
                  (rateModelListAdminGlobal[rateIndex].sell == null)
                      ? Container()
                      : rateWidget(buyOrSellRateModel: rateModelListAdminGlobal[rateIndex].sell!, isBuy: false),
                ]);
              }

              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: CustomButtonGlobal(
                  level: Level.mini,
                  insideSizeBoxWidget: insideSizeBoxWidget(),
                  onTapUnlessDisable: onTapUnlessDisable,
                ),
              );
            }

            Widget remarkTextFieldWidget() {
              void onTapFromOutsiderFunction() {}
              void onChangeFromOutsiderFunction() {
                setStateFromDialog(() {});
              }

              return textAreaGlobal(
                controller: remarkController,
                onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                labelText: remarkOptionalStrGlobal,
                level: Level.normal,
              );
            }

            return Column(children: [
              for (int rateIndex = 0; rateIndex < rateModelListAdminGlobal.length; rateIndex++) textFieldAndDeleteWidget(rateIndex: rateIndex),
              remarkTextFieldWidget(),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleWidget(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: paddingSizeGlobal(level: Level.mini),
                  right: paddingSizeGlobal(level: Level.mini),
                  top: paddingSizeGlobal(level: Level.normal),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [calculateListWidget()]),
                  ),
                ),
              ),
            ),
          ]);
        }

        void printFunctionOnTap() {
          ratePriceInvoiceInvoice(remark: remarkController, context: context);
          closeDialogGlobal(context: context);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini),
          dialogWidth: dialogSizeGlobal(level: Level.mini),
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          printFunctionOnTap: printFunctionOnTap,
          validPrintFunctionOnTap: () => checkCalculateOptionFunction(),
          contentFunctionReturnWidget: editCardDialog,
        );
      }

      return CustomButtonGlobal(
        sizeBoxWidth: sizeBoxWidthGlobal,
        sizeBoxHeight: sizeBoxHeightGlobal,
        insideSizeBoxWidget: insideSizeBoxWidget(),
        onTapUnlessDisable: onTapUnlessDisable,
      );
    }

    Widget transferDialog() {
      Widget insideSizeBoxWidget() {
        // return scrollText(textStr: calculateOperatorStrPrintGlobal, textStyle: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold), alignment: Alignment.center);
        return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(transferAdminStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
            Text("($createBySystemStrGlobal)", style: textStyleGlobal(level: Level.mini)),
          ]),
        );
      }

      void onTapUnlessDisable() {
        TextEditingController remarkController = TextEditingController();

        for (int transferIndex = 0; transferIndex < transferModelListGlobal.length; transferIndex++) {
          for (int moneyTypeIndex = 0; moneyTypeIndex < transferModelListGlobal[transferIndex].moneyTypeList.length; moneyTypeIndex++) {
            transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isTransferSelectedPrint = false;
            transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isReceiverSelectedPrint = false;
            for (int moneyIndex = 0; moneyIndex < transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList.length; moneyIndex++) {
              transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyIndex].isSelectedPrint = false;
            }
          }
        }

        ValidButtonModel checkCalculateOptionFunction() {
          for (int transferIndex = 0; transferIndex < transferModelListGlobal.length; transferIndex++) {
            for (int moneyTypeIndex = 0; moneyTypeIndex < transferModelListGlobal[transferIndex].moneyTypeList.length; moneyTypeIndex++) {
              if (transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isTransferSelectedPrint ||
                  transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isReceiverSelectedPrint) {
                for (int sellPriceIndex = 0;
                    sellPriceIndex < transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList.length;
                    sellPriceIndex++) {
                  if (transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[sellPriceIndex].isSelectedPrint) {
                    // return true;
                    return ValidButtonModel(isValid: true);
                  }
                }
              }
            }
          }
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfNumber,
            error: "no selected",
          );
        }

        Widget editCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget titleWidget() {
            return Padding(
              padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
              child: Text(selectTransferStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
            );
          }

          Widget calculateListWidget() {
            Widget textFieldAndDeleteWidget({required int transferIndex, required int moneyTypeIndex}) {
              void onTapUnlessDisable() {
                //TODO: do something
              }

              final int customerIndex = (transferModelListGlobal[transferIndex].customerId == null)
                  ? -1
                  : getIndexByCustomerId(customerId: transferModelListGlobal[transferIndex].customerId!);
              final String customerNameStr = (customerIndex == -1) ? profileModelAdminGlobal!.name.text : customerModelListGlobal[customerIndex].name.text;
              final String moneyTypeStr = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyType!;

              Widget transferToggleWidget() {
                void onToggle() {
                  transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isTransferSelectedPrint =
                      !transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isTransferSelectedPrint;
                  // if (transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isTransferSelectedPrint) {
                  for (int sellPriceIndex = 0;
                      sellPriceIndex < transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList.length;
                      sellPriceIndex++) {
                    if (transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[sellPriceIndex].isTransfer) {
                      transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[sellPriceIndex].isSelectedPrint =
                          transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isTransferSelectedPrint;
                    }
                  }
                  // }
                  setStateFromDialog(() {});
                }

                return showAndHideToggleWidgetGlobal(
                  isLeftSelected: transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isTransferSelectedPrint,
                  onToggle: onToggle,
                );
              }

              Widget receiverToggleWidget() {
                void onToggle() {
                  transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isReceiverSelectedPrint =
                      !transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isReceiverSelectedPrint;
                  // if (transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isReceiverSelectedPrint) {
                  for (int sellPriceIndex = 0;
                      sellPriceIndex < transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList.length;
                      sellPriceIndex++) {
                    if (!transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[sellPriceIndex].isTransfer) {
                      transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[sellPriceIndex].isSelectedPrint =
                          transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isReceiverSelectedPrint;
                    }
                  }
                  // }
                  setStateFromDialog(() {});
                }

                return showAndHideToggleWidgetGlobal(
                  isLeftSelected: transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isReceiverSelectedPrint,
                  onToggle: onToggle,
                );
              }

              Widget sellPriceWidget({required int moneyIndex}) {
                final String startPriceStr = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyIndex].startValue.text;
                final String endPriceStr = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyIndex].endValue.text;
                final String priceStr = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyIndex].fee.text;
                final String transferOrReceiveStr = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyIndex].isTransfer
                    ? transferStrGlobal
                    : receiveStrGlobal;
                Widget subToggleWidget() {
                  void onToggle() {
                    transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyIndex].isSelectedPrint =
                        !transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyIndex].isSelectedPrint;
                    bool isTransferAllHide = true;
                    for (int subMoneyIndex = 0;
                        subMoneyIndex < transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList.length;
                        subMoneyIndex++) {
                      if (transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[subMoneyIndex].isSelectedPrint) {
                        if (transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[subMoneyIndex].isTransfer) {
                          isTransferAllHide = false;
                          break;
                        }
                      }
                    }
                    transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isTransferSelectedPrint = !isTransferAllHide;
                    // if (isTransferAllHide) {
                    //    = false;
                    // }
                    bool isReceiverAllHide = true;
                    for (int subMoneyIndex = 0;
                        subMoneyIndex < transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList.length;
                        subMoneyIndex++) {
                      if (transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[subMoneyIndex].isSelectedPrint) {
                        if (!transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[subMoneyIndex].isTransfer) {
                          isReceiverAllHide = false;
                          break;
                        }
                      }
                    }
                    transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isReceiverSelectedPrint = !isReceiverAllHide;
                    // if (isReceiverAllHide) {
                    //   transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isReceiverSelectedPrint = false;
                    // }
                    setStateFromDialog(() {});
                  }

                  return showAndHideToggleWidgetGlobal(
                    isLeftSelected: transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyIndex].isSelectedPrint,
                    onToggle: onToggle,
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.large)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(
                        child: Text(
                          "$transferOrReceiveStr | $startPriceStr <= x <= $endPriceStr ($priceStr $moneyTypeStr)",
                          style: textStyleGlobal(level: Level.normal),
                        ),
                      ),
                      subToggleWidget(),
                    ]),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.mini)),
                      child: drawLineGlobal(),
                    ),
                  ]),
                );
              }

              bool checkShowTransfer() {
                for (int moneyIndex = 0; moneyIndex < transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList.length; moneyIndex++) {
                  if (transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyIndex].isTransfer) {
                    return true;
                  }
                }
                return false;
              }

              bool checkShowReceiver() {
                for (int moneyIndex = 0; moneyIndex < transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList.length; moneyIndex++) {
                  if (!transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[moneyIndex].isTransfer) {
                    return true;
                  }
                }
                return false;
              }

              Widget insideSizeBoxWidget() {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text("$moneyTypeStr | $customerNameStr", style: textStyleGlobal(level: Level.normal))),
                    checkShowTransfer()
                        ? Column(children: [Text(transferStrGlobal, style: textStyleGlobal(level: Level.mini)), transferToggleWidget()])
                        : Container(),
                    Container(width: (checkShowTransfer() && checkShowReceiver()) ? paddingSizeGlobal(level: Level.mini) : 0),
                    checkShowReceiver()
                        ? Column(children: [Text(receiveStrGlobal, style: textStyleGlobal(level: Level.mini)), receiverToggleWidget()])
                        : Container(),
                  ]),
                  (transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isTransferSelectedPrint ||
                          transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isReceiverSelectedPrint)
                      ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.mini)),
                            child: drawLineGlobal(),
                          ),
                          for (int moneyIndex = 0;
                              moneyIndex < transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList.length;
                              moneyIndex++)
                            sellPriceWidget(moneyIndex: moneyIndex)
                        ])
                      : Container(),
                ]);
              }

              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: CustomButtonGlobal(
                  level: Level.mini,
                  insideSizeBoxWidget: insideSizeBoxWidget(),
                  onTapUnlessDisable: onTapUnlessDisable,
                ),
              );
            }

            Widget remarkTextFieldWidget() {
              void onTapFromOutsiderFunction() {}
              void onChangeFromOutsiderFunction() {
                setStateFromDialog(() {});
              }

              return textAreaGlobal(
                controller: remarkController,
                onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                labelText: remarkOptionalStrGlobal,
                level: Level.normal,
              );
            }

            return Column(children: [
              for (int transferIndex = 0; transferIndex < transferModelListGlobal.length; transferIndex++)
                for (int moneyTypeIndex = 0; moneyTypeIndex < transferModelListGlobal[transferIndex].moneyTypeList.length; moneyTypeIndex++)
                  textFieldAndDeleteWidget(transferIndex: transferIndex, moneyTypeIndex: moneyTypeIndex),
              remarkTextFieldWidget(),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleWidget(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: paddingSizeGlobal(level: Level.mini),
                  right: paddingSizeGlobal(level: Level.mini),
                  top: paddingSizeGlobal(level: Level.normal),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [calculateListWidget()]),
                  ),
                ),
              ),
            ),
          ]);
        }

        void printFunctionOnTap() {
          transferFeeInvoiceInvoice(remark: remarkController, context: context);
          closeDialogGlobal(context: context);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini),
          dialogWidth: dialogSizeGlobal(level: Level.mini),
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          printFunctionOnTap: printFunctionOnTap,
          validPrintFunctionOnTap: () => checkCalculateOptionFunction(),
          contentFunctionReturnWidget: editCardDialog,
        );
      }

      return CustomButtonGlobal(
        sizeBoxWidth: sizeBoxWidthGlobal,
        sizeBoxHeight: sizeBoxHeightGlobal,
        insideSizeBoxWidget: insideSizeBoxWidget(),
        onTapUnlessDisable: onTapUnlessDisable,
      );
    }

    // Widget calculateByMoneyTypeDialog() {
    //   Widget insideSizeBoxWidget() {
    //     return Center(child: Text(countMoneyInvoiceStrPrintGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)));
    //   }

    //   void onTapUnlessDisable() {
    //     printCountInvoiceInvoice(context: context);
    //   }

    //   return CustomButtonGlobal(
    //       sizeBoxWidth: sizeBoxWidthGlobal,
    //       sizeBoxHeight: sizeBoxHeightGlobal,
    //       insideSizeBoxWidget: insideSizeBoxWidget(),
    //       onTapUnlessDisable: onTapUnlessDisable);
    // }

    Widget customizePrintDialog() {
      Widget insideSizeBoxWidget() {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(customizePrintStrPrintGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
            Text("($createBySystemStrGlobal)", style: textStyleGlobal(level: Level.mini)),
          ],
        ));
      }

      void onTapUnlessDisable() {
        setUpOtherPrint(isCreateNewOtherPrint: true, otherIndex: null, context: context, setState: setState);
      }

      return CustomButtonGlobal(
        sizeBoxWidth: sizeBoxWidthGlobal,
        sizeBoxHeight: sizeBoxHeightGlobal,
        insideSizeBoxWidget: insideSizeBoxWidget(),
        onTapUnlessDisable: onTapUnlessDisable,
      );
    }

    Widget otherPrintElement({required int otherIndex}) {
      Widget insideSizeBoxWidget() {
        return Center(child: Text(printModelGlobal.otherList[otherIndex].title.text, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)));
      }

      void onTapUnlessDisable() {
        printOtherInvoice(context: context, printCustomize: printModelGlobal.otherList[otherIndex]);
      }

      return CustomButtonGlobal(
          sizeBoxWidth: sizeBoxWidthGlobal,
          sizeBoxHeight: sizeBoxHeightGlobal,
          insideSizeBoxWidget: insideSizeBoxWidget(),
          onTapUnlessDisable: onTapUnlessDisable);
    }

    Widget bodyTemplateSideMenu() {
      return BodyTemplateSideMenu(
        inWrapWidgetList: [
          calculateByOperatorDialog(),
          calculateByValueListDialog(),
          // calculateByMoneyTypeDialog(),
          customizePrintDialog(),
          cardModelListGlobal.isNotEmpty ? cardDialog() : Container(),
          transferModelListGlobal.isNotEmpty ? transferDialog() : Container(),
          rateModelListAdminGlobal.isNotEmpty ? rateDialog() : Container(),
          for (int otherIndex = 0; otherIndex < printModelGlobal.otherList.length; otherIndex++) otherPrintElement(otherIndex: otherIndex)
        ],
        title: widget.title,
      );
    }

    // return _isLoadingOnGetLastRate ? Container() : bodyTemplateSideMenu();
    return bodyTemplateSideMenu();
  }
}
