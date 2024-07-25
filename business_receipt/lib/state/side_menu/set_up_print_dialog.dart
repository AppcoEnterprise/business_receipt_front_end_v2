import 'dart:js';

import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/drop_down_and_text_field_provider.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/request_api/print_request_api_env.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/toggle_env.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/print_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:flutter/material.dart';

void setUpOtherPrint({required int? otherIndex, required bool isCreateNewOtherPrint, required BuildContext context, required Function setState}) {
  final bool isAdminEditing = (profileModelEmployeeGlobal == null);
  List<String> widthListGlobal = ["80", "58"];
  PrintModel printModelTemp = clonePrintModel();
  if (isCreateNewOtherPrint) {
    printModelTemp.otherList.add(PrintCustomizeModel(
      isHasHeaderAndFooter: true,
      title: TextEditingController(),
      textColumnList: [],
      width: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: widthListGlobal.first, isRound: false)),
    ));
    otherIndex = printModelTemp.otherList.length - 1;
  }
  printModelTemp.otherList[otherIndex!].isSelectedOtherWidth = (widthListGlobal.indexWhere((element) => element == printModelTemp.otherList[otherIndex!].width.text) == -1);
  if (isAdminEditing) {
    editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.frenchyAndPrint);
  }
  void saveFunctionOnTap({required PrintModel printModelTemp}) {
    void callback() {
      adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.frenchyAndPrint);
      setState(() {});
    }

    //close the rate dialog
    closeDialogGlobal(context: context);
    updatePrintInformationGlobal(callBack: callback, context: context, printModel: printModelTemp);
  }

  void cancelFunctionOnTap() {
    void okFunction() {
      if (isAdminEditing) {
        adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.frenchyAndPrint);
      }
      closeDialogGlobal(context: context);
    }

    void cancelFunction() {}
    confirmationDialogGlobal(context: context, okFunction: okFunction, cancelFunction: cancelFunction, titleStr: cancelEditingSettingGlobal, subtitleStr: cancelEditingSettingConfirmGlobal);
  }

  Widget editCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
    Widget titleAndShowHeaderAndFooterWidget() {
      Widget titleWidget() {
        return Padding(
          padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)),
          child: Text(otherStrPrintGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
        );
      }

      Widget showHeaderAndFooterWidget() {
        return showAndHideToggleWidgetGlobal(
          isLeftSelected: printModelTemp.otherList[otherIndex!].isHasHeaderAndFooter,
          onToggle: () {
            printModelTemp.otherList[otherIndex!].isHasHeaderAndFooter = !printModelTemp.otherList[otherIndex].isHasHeaderAndFooter;
            setStateFromDialog(() {});
          },
        );
      }

      Widget titleSubWidget() {
        return Padding(
          padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)),
          child: Text(headerAndFooterStrPrintGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
        );
      }

      return Row(children: [titleWidget(), showHeaderAndFooterWidget(), titleSubWidget()]);
    }

    Widget textFieldWidget({required TextEditingController controller, required String labelText}) {
      Widget employeeNameTextFieldWidget() {
        void onChangeFromOutsiderFunction() {
          setStateFromDialog(() {});
        }

        void onTapFromOutsiderFunction() {}
        return textFieldGlobal(
          onTapFromOutsiderFunction: onTapFromOutsiderFunction,
          controller: controller,
          onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
          labelText: labelText,
          level: Level.normal,
          textFieldDataType: TextFieldDataType.str,
        );
      }

      return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)), child: employeeNameTextFieldWidget());
    }

    Widget widthWidget() {
      void onDeleteFunction() {
        printModelTemp.otherList[otherIndex!].width.text = "";
        printModelTemp.otherList[otherIndex].isSelectedOtherWidth = false;
        setStateFromDialog(() {});
      }

      void onTapFunction() {}

      void onChangedTextFieldFunction() {
        setStateFromDialog(() {});
      }

      void onChangedDropDrownFunction({required String value, required int index}) {
        final bool isSelectedOtherWidth = (value == otherStrGlobal);
        printModelTemp.otherList[otherIndex!].isSelectedOtherWidth = isSelectedOtherWidth;
        if (!isSelectedOtherWidth) {
          printModelTemp.otherList[otherIndex].width.text = value;
        }
        setStateFromDialog(() {});
      }

      return DropDownAndTextFieldProviderGlobal(
        level: Level.normal,
        labelStr: widthStrGlobal,
        menuItemStrList: widthListGlobal,
        selectedStr: printModelTemp.otherList[otherIndex!].width.text.isEmpty ? null : printModelTemp.otherList[otherIndex].width.text,
        onChangedDropDrownFunction: onChangedDropDrownFunction,
        controller: printModelTemp.otherList[otherIndex].width,
        isShowTextField: printModelTemp.otherList[otherIndex].isSelectedOtherWidth,
        textFieldDataType: TextFieldDataType.int,
        onDeleteFunction: onDeleteFunction,
        onTapFunction: onTapFunction,
        onChangedTextFieldFunction: onChangedTextFieldFunction,
      );
    }

    Widget textWithFormatWidget({required TextRowList textRowElement}) {
      Color colorBackground = Colors.white;
      Color colorText = Colors.black;
      if (textRowElement.fillValue == "normal") {
        colorBackground = Colors.grey;
      } else if (textRowElement.fillValue == "large") {
        colorBackground = Colors.black;
        colorText = Colors.white;
      }
      Alignment alignment = Alignment.centerLeft;
      if (textRowElement.isRightAlign) {
        alignment = Alignment.centerRight;
      } else if (textRowElement.isCenterAlign) {
        alignment = Alignment.center;
      }
      return Container(
        color: colorBackground,
        alignment: alignment,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            textRowElement.text.text.isEmpty ? "[${textRowElement.textfield.text}]" : textRowElement.text.text,
            style: TextStyle(
              fontSize: (textEditingControllerToDouble(controller: textRowElement.fontSize) ?? 20) * (1 + (5 / 9)),
              color: colorText,
              fontWeight: textRowElement.isBold ? FontWeight.bold : FontWeight.normal,
              decoration: textRowElement.isUnderLine ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ),
      );
      // return
      // // isExpanded ? Row(children: [Expanded(child: textWidget)]) :
      // textWidget;
    }

    void setUpRowDialog({required int textColumnIndex, required int? rowIndex, required bool isCreateNewRowText, required bool isCreateNewColumnText}) {
      List<String> fontSizeListGlobal = ["13", "17", "25"];
      List<String> fillValueListGlobal = ["mini", "normal", "large"];
      TextRowList textRowElement = TextRowList(
        isCenterAlign: false,
        isLeftAlign: true,
        isRightAlign: false,
        isBold: false,
        isUnderLine: false,
        fontSize: TextEditingController(text: fontSizeListGlobal[1]),
        fillValue: fillValueListGlobal.first,
        text: TextEditingController(),
        isText: true,
        textfield: TextEditingController(),
      );
      if (rowIndex == null) {
        printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].textRowList.add(textRowElement);
        rowIndex = printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList.length - 1;
      } else {
        textRowElement.isText = printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].textRowList[rowIndex].isText;
        textRowElement.isCenterAlign = printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList[rowIndex].isCenterAlign;
        textRowElement.isLeftAlign = printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList[rowIndex].isLeftAlign;
        textRowElement.isRightAlign = printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList[rowIndex].isRightAlign;
        textRowElement.isBold = printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList[rowIndex].isBold;
        textRowElement.isUnderLine = printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList[rowIndex].isUnderLine;
        textRowElement.fontSize.text = printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList[rowIndex].fontSize.text;
        textRowElement.fillValue = printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList[rowIndex].fillValue;
        textRowElement.text.text = printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList[rowIndex].text.text;
        textRowElement.textfield.text = printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList[rowIndex].textfield.text;
      }
      textRowElement.isSelectedOtherFontSize = (fontSizeListGlobal.indexWhere((element) => element == textRowElement.fontSize.text) == -1);
      Function deleteFunctionOrNull() {
        void deleteFunction() {
          void okFunction() {
            printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].textRowList.removeAt(rowIndex!);
            closeDialogGlobal(context: context);
          }

          void cancelFunctionOnTap() {
            closeDialogGlobal(context: context);
          }

          confirmationDialogGlobal(
            context: context,
            okFunction: okFunction,
            cancelFunction: cancelFunctionOnTap,
            titleStr: "$deleteGlobal ${textRowElement.text.text}",
            subtitleStr: deleteConfirmGlobal,
          );
        }

        return deleteFunction;
      }

      Widget editCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
        if (textRowElement.isText) {
          textRowElement.textfield.text = "";
        }
        Widget titleWidget() {
          return Padding(
            padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)),
            child: Text(textElementStrPrintGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
          );
        }

        Widget textFieldWidget({required TextEditingController controller, required String labelText}) {
          Widget employeeNameTextFieldWidget() {
            void onChangeFromOutsiderFunction() {
              setStateFromDialog(() {});
            }

            void onTapFromOutsiderFunction() {}
            return textFieldGlobal(
              onTapFromOutsiderFunction: onTapFromOutsiderFunction,
              controller: controller,
              onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
              labelText: labelText,
              level: Level.normal,
              textFieldDataType: TextFieldDataType.str,
            );
          }

          return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)), child: employeeNameTextFieldWidget());
        }

        Widget toggleNormalOrBoldWidget() {
          void onToggle() {
            textRowElement.isBold = !textRowElement.isBold;
            setStateFromDialog(() {});
          }

          return normalOrBoldToggleWidgetGlobal(isLeftSelected: !textRowElement.isBold, onToggle: onToggle);
        }

        Widget toggleNormalOrUnderlineWidget() {
          void onToggle() {
            textRowElement.isUnderLine = !textRowElement.isUnderLine;
            setStateFromDialog(() {});
          }

          return Padding(
            padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
            child: normalOrUnderlineToggleWidgetGlobal(isLeftSelected: !textRowElement.isUnderLine, onToggle: onToggle),
          );
        }

        Widget toggleTextOrTextfieldWidget() {
          void onToggle() {
            textRowElement.isText = !textRowElement.isText;
            setStateFromDialog(() {});
          }

          return Padding(
            padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
            child: textOrTextfieldToggleWidgetGlobal(isLeftSelected: textRowElement.isText, onToggle: onToggle),
          );
        }

        Widget fontSizeWidget() {
          void onDeleteFunction() {
            textRowElement.fontSize.text = "";
            textRowElement.isSelectedOtherFontSize = false;
            setStateFromDialog(() {});
          }

          void onTapFunction() {}

          void onChangedTextFieldFunction() {
            setStateFromDialog(() {});
          }

          void onChangedDropDrownFunction({required String value, required int index}) {
            final bool isSelectedOther = (value == otherStrGlobal);
            textRowElement.isSelectedOtherFontSize = isSelectedOther;
            if (!isSelectedOther) {
              textRowElement.fontSize.text = value;
            }
            setStateFromDialog(() {});
          }

          return DropDownAndTextFieldProviderGlobal(
            level: Level.normal,
            labelStr: fontSizeStrGlobal,
            menuItemStrList: fontSizeListGlobal,
            selectedStr: textRowElement.fontSize.text.isEmpty ? null : textRowElement.fontSize.text,
            onChangedDropDrownFunction: onChangedDropDrownFunction,
            controller: textRowElement.fontSize,
            isShowTextField: textRowElement.isSelectedOtherFontSize,
            // ||
            //     (fontSizeListGlobal.indexWhere((element) => element == textRowElement.fontSize.text) == -1)),
            textFieldDataType: TextFieldDataType.int,
            onDeleteFunction: onDeleteFunction,
            onTapFunction: onTapFunction,
            onChangedTextFieldFunction: onChangedTextFieldFunction,
          );
        }

        Widget fillValueWidget() {
          void onTapFunction() {}

          void onChangedFunction({required String value, required int index}) {
            textRowElement.fillValue = value;
            setStateFromDialog(() {});
          }

          return Padding(
            padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini), right: paddingSizeGlobal(level: Level.mini)),
            child: customDropdown(
              level: Level.normal,
              labelStr: fillValueStrGlobal,
              menuItemStrList: fillValueListGlobal,
              selectedStr: textRowElement.fillValue,
              onTapFunction: onTapFunction,
              onChangedFunction: onChangedFunction,
            ),
          );
        }

        Widget alignWidget() {
          return PopupMenuButton(
            tooltip: "",
            onSelected: (value) {
              if (value == 1) {
                textRowElement.isLeftAlign = true;
                textRowElement.isRightAlign = false;
                textRowElement.isCenterAlign = false;
                setStateFromDialog(() {});
              } else if (value == 2) {
                textRowElement.isLeftAlign = false;
                textRowElement.isRightAlign = true;
                textRowElement.isCenterAlign = false;
                setStateFromDialog(() {});
              } else if (value == 3) {
                textRowElement.isLeftAlign = false;
                textRowElement.isRightAlign = false;
                textRowElement.isCenterAlign = true;
                setStateFromDialog(() {});
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(value: 1, child: Text("Left", style: textStyleGlobal(level: Level.mini))),
              PopupMenuItem(value: 2, child: Text("Right", style: textStyleGlobal(level: Level.mini))),
              PopupMenuItem(value: 3, child: Text("Center", style: textStyleGlobal(level: Level.mini))),
            ],
          );
        }

        Widget textWidget() {
          Widget insideSizeBoxWidget() {
            return textWithFormatWidget(
              textRowElement: textRowElement,
              // isExpanded: printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].isExpandedAlign,
            );
          }

          void onTapUnlessDisable() {}
          return CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
        }

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          titleWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [toggleTextOrTextfieldWidget(), Spacer(), toggleNormalOrBoldWidget(), Spacer(), toggleNormalOrUnderlineWidget()]),
                Row(children: [Expanded(child: fontSizeWidget()), Expanded(child: fillValueWidget())]),
                textRowElement.isText ? Container() : textFieldWidget(controller: textRowElement.textfield, labelText: textFieldTitleStrPrintGlobal),
                textFieldWidget(controller: textRowElement.text, labelText: textRowElement.isText ? textFieldStrPrintGlobal : initTextFieldStrPrintGlobal),
                textRowElement.text.text.isNotEmpty ? Row(children: [alignWidget(), Expanded(child: textWidget())]) : Container(),
              ]),
            ),
          ),
        ]);
      }

      ValidButtonModel validOkButtonFunction() {
        // return textRowElement.fontSize.text.isNotEmpty &&
        //     (textRowElement.isText ? textRowElement.text.text.isNotEmpty : true) &&
        //     (textRowElement.isText ? true : textRowElement.textfield.text.isNotEmpty);
        if (textRowElement.fontSize.text.isEmpty) {
          return ValidButtonModel(isValid: false, error: "font size is empty", errorType: ErrorTypeEnum.valueOfNumber);
        }

        if (textEditingControllerToDouble(controller: textRowElement.fontSize)! == 0) {
          return ValidButtonModel(isValid: false, error: "font size equal 0.", errorType: ErrorTypeEnum.valueOfNumber);
        }

        if (textRowElement.isText) {
          return ValidButtonModel(isValid: textRowElement.text.text.isNotEmpty, error: "text is empty", errorType: ErrorTypeEnum.valueOfString);
        }
        if (!textRowElement.isText) {
          return ValidButtonModel(isValid: textRowElement.textfield.text.isNotEmpty, error: "text field is empty", errorType: ErrorTypeEnum.valueOfString);
        }
        return ValidButtonModel(isValid: true);
      }

      void okFunctionOnTap() {
        printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].textRowList[rowIndex!] = textRowElement;
        closeDialogGlobal(context: context);
      }

      ValidButtonModel validDeleteFunctionOnTap() {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      void cancelFunctionOnTap() {
        void okFunction() {
          if (isCreateNewRowText) {
            printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].textRowList.removeAt(rowIndex!);
          }
          if (isCreateNewColumnText) {
            printModelTemp.otherList[otherIndex!].textColumnList.removeAt(textColumnIndex);
          }
          closeDialogGlobal(context: context);
        }

        void cancelFunction() {}
        confirmationDialogGlobal(context: context, okFunction: okFunction, cancelFunction: cancelFunction, titleStr: cancelEditingSettingGlobal, subtitleStr: cancelEditingSettingConfirmGlobal);
      }

      actionDialogSetStateGlobal(
        dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.25,
        dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.25,
        context: context,
        deleteFunctionOnTap: isCreateNewRowText ? null : deleteFunctionOrNull(),
        validOkButtonFunction: () => validOkButtonFunction(),
        okFunctionOnTap: () => okFunctionOnTap(),
        contentFunctionReturnWidget: editCardDialog,
        validDeleteFunctionOnTap: () => validDeleteFunctionOnTap(),
        cancelFunctionOnTap: cancelFunctionOnTap,
      ).then((value) => setStateFromDialog(() {}));
    }

    Widget textColumnWidget({required int textColumnIndex}) {
      // void onTapUnlessDisable() {}
      // Widget insideSizeBoxWidget() {
      Widget textRowWidget({required int rowIndex}) {
        void onTapUnlessDisable() {
          setUpRowDialog(rowIndex: rowIndex, isCreateNewRowText: false, textColumnIndex: textColumnIndex, isCreateNewColumnText: false);
        }

        Widget insideSizeBoxWidget() {
          return textWithFormatWidget(
            textRowElement: printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].textRowList[rowIndex],
            // isExpanded: printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isExpandedAlign,
          );
        }

        return Padding(
          padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
          child: CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable),
        );
      }

      Widget alignOrAddOrDeleteWidget() {
        final int addCount = printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].textRowList.length;

        bool checkAddRow() {
          for (int rowIndex = 0; rowIndex < printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].textRowList.length; rowIndex++) {
            final bool isTextEmpty = printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList[rowIndex].text.text.isEmpty;
            if (isTextEmpty) {
              return false;
            }
          }
          return (addCount < printRowCustomizeButtonLimitGlobal);
        }

        return printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList.isNotEmpty
            ? PopupMenuButton(
                tooltip: "",
                onSelected: (value) {
                  if (value == 1) {
                    printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].isLeftAlign = true;
                    printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isCenterAlign = false;
                    printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isRightAlign = false;
                    printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isExpandedAlign = false;
                    setStateFromDialog(() {});
                  } else if (value == 2) {
                    printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].isLeftAlign = false;
                    printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isCenterAlign = false;
                    printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isRightAlign = true;
                    printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isExpandedAlign = false;
                    setStateFromDialog(() {});
                  } else if (value == 3) {
                    printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].isLeftAlign = false;
                    printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isCenterAlign = true;
                    printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isRightAlign = false;
                    printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isExpandedAlign = false;
                    setStateFromDialog(() {});
                  } else if (value == 4) {
                    printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].isLeftAlign = false;
                    printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isCenterAlign = false;
                    printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isRightAlign = false;
                    printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isExpandedAlign = true;
                    setStateFromDialog(() {});
                  } else if (value == 5) {
                    printModelTemp.otherList[otherIndex!].textColumnList.removeAt(textColumnIndex);
                    setStateFromDialog(() {});
                  } else if (value == 6) {
                    if (checkAddRow()) {
                      setUpRowDialog(rowIndex: null, isCreateNewRowText: true, textColumnIndex: textColumnIndex, isCreateNewColumnText: false);
                    }
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(value: 1, child: Text("Left", style: textStyleGlobal(level: Level.mini))),
                  PopupMenuItem(value: 2, child: Text("Right", style: textStyleGlobal(level: Level.mini))),
                  PopupMenuItem(value: 3, child: Text("Center", style: textStyleGlobal(level: Level.mini))),
                  PopupMenuItem(value: 4, child: Text("Expanded", style: textStyleGlobal(level: Level.mini))),
                  PopupMenuItem(value: 5, child: Text("Delete", style: textStyleGlobal(level: Level.mini, color: Colors.red))),
                  PopupMenuItem(
                    value: 6,
                    child: Text(
                      "Add ($addCount/$printRowCustomizeButtonLimitGlobal)",
                      style: textStyleGlobal(level: Level.mini, color: checkAddRow() ? Colors.green : Colors.grey),
                    ),
                  ),
                ],
              )
            : PopupMenuButton(
                tooltip: "",
                onSelected: (value) {
                  if (value == 1) {
                    printModelTemp.otherList[otherIndex!].textColumnList.removeAt(textColumnIndex);
                    setStateFromDialog(() {});
                  } else if (value == 2) {
                    if (checkAddRow()) {
                      setUpRowDialog(rowIndex: null, isCreateNewRowText: true, textColumnIndex: textColumnIndex, isCreateNewColumnText: false);
                    }
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(value: 1, child: Text("Delete", style: textStyleGlobal(level: Level.mini, color: Colors.red))),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      "Add ($addCount/$printRowCustomizeButtonLimitGlobal)",
                      style: textStyleGlobal(level: Level.mini, color: checkAddRow() ? Colors.green : Colors.grey),
                    ),
                  ),
                ],
              );
      }

      Alignment alignment = Alignment.centerLeft;
      if (printModelTemp.otherList[otherIndex!].textColumnList[textColumnIndex].isCenterAlign) {
        alignment = Alignment.center;
      } else if (printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isRightAlign) {
        alignment = Alignment.centerRight;
      }
      bool checkShowColumn() {
        if (printModelTemp.otherList[otherIndex!].width.text.isEmpty) {
          return false;
        }
        final double widthNumber = textEditingControllerToDouble(controller: printModelTemp.otherList[otherIndex].width)!;
        if (!(30 <= widthNumber && widthNumber <= 90)) {
          return false;
        }
        return true;
      }

      return checkShowColumn()
          ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              alignOrAddOrDeleteWidget(),
              Container(
                alignment: alignment,
                // color: Colors.blue,
                width: textEditingControllerToDouble(controller: printModelTemp.otherList[otherIndex].width)! * 6.299,
                child: printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].isExpandedAlign
                    ? Padding(
                        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          for (int rowIndex = 0; rowIndex < printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList.length; rowIndex++)
                            Expanded(child: textRowWidget(rowIndex: rowIndex)),
                        ]),
                      )
                    : Padding(
                        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                            for (int rowIndex = 0; rowIndex < printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList.length; rowIndex++) textRowWidget(rowIndex: rowIndex),
                          ]),
                        ),
                      ),
              ),
              Padding(
                padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal), bottom: paddingSizeGlobal(level: Level.mini)),
                child: Text("|", style: textStyleGlobal(level: Level.large)),
              ),
            ])
          : Container();
      // }

      // return CustomButtonGlobal(isDisable: true, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
    }

    void onTapFunction() {
      printModelTemp.otherList[otherIndex!].textColumnList.add(TextColumnList(
        textRowList: [],
        isCenterAlign: false,
        isExpandedAlign: false,
        isLeftAlign: true,
        isRightAlign: false,
      ));
      setStateFromDialog(() {});

      setUpRowDialog(
        textColumnIndex: (printModelTemp.otherList[otherIndex].textColumnList.length - 1),
        rowIndex: null,
        isCreateNewRowText: true,
        isCreateNewColumnText: true,
      );
    }

    ValidButtonModel checkAddColumn() {
      for (int textColumnIndex = 0; textColumnIndex < printModelTemp.otherList[otherIndex!].textColumnList.length; textColumnIndex++) {
        final bool isRowEmpty = printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList.isEmpty;
        if (isRowEmpty) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            error: "row is empty",
            errorType: ErrorTypeEnum.arrayLength,
            errorLocationList: [
              TitleAndSubtitleModel(title: "column index", subtitle: textColumnIndex.toString()),
              TitleAndSubtitleModel(
                title: "row length",
                subtitle: printModelTemp.otherList[otherIndex].textColumnList[textColumnIndex].textRowList.length.toString(),
              ),
            ],
          );
        }
      }
      // return true;
      return ValidButtonModel(isValid: true);
    }

    Widget informationWidget() {
      // return Column(children: [
      //   for (int textColumnIndex = 0; textColumnIndex < printModelTemp.otherList[otherIndex!].textColumnList.length; textColumnIndex++) textColumnWidget(textColumnIndex: textColumnIndex),
      //   addButtonOrContainerWidget(
      //     context: context,
      //     level: Level.mini,
      //     currentAddButtonQty: printModelTemp.otherList[otherIndex].textColumnList.length,
      //     maxAddButtonLimit: printColumnCustomizeButtonLimitGlobal,
      //     onTapFunction: onTapFunction,
      //     validModel: checkAddColumn(),
      //   ),
      // ]);

      return Padding(
        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
        child: CustomButtonGlobal(
          insideSizeBoxWidget: Column(children: [
            for (int textColumnIndex = 0; textColumnIndex < printModelTemp.otherList[otherIndex!].textColumnList.length; textColumnIndex++) textColumnWidget(textColumnIndex: textColumnIndex),
            addButtonOrContainerWidget(
              context: context,
              level: Level.mini,
              currentAddButtonQty: printModelTemp.otherList[otherIndex].textColumnList.length,
              maxAddButtonLimit: printColumnCustomizeButtonLimitGlobal,
              onTapFunction: onTapFunction,
              validModel: checkAddColumn(),
            ),
          ]),
          onTapUnlessDisable: () {},
        ),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      titleAndShowHeaderAndFooterWidget(),
      Expanded(
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            textFieldWidget(controller: printModelTemp.otherList[otherIndex!].title, labelText: titlePrintStrGlobal),
            widthWidget(),
            // for (int textColumnIndex = 0; textColumnIndex < printModelTemp.otherList[otherIndex].textColumnList.length; textColumnIndex++) textColumnWidget(textColumnIndex: textColumnIndex),
            // addButtonOrContainerWidget(
            //   context: context,
            //   level: Level.mini,
            //   currentAddButtonQty: printModelTemp.otherList[otherIndex].textColumnList.length,
            //   maxAddButtonLimit: printColumnCustomizeButtonLimitGlobal,
            //   onTapFunction: onTapFunction,
            //   validModel: checkAddColumn(),
            // ),
            informationWidget(),
          ]),
        ),
      ),
    ]);
  }

  Function deleteFunctionOrNull() {
    void deleteFunctionOnTap() {
      void okFunction() {
        printModelTemp.otherList.removeAt(otherIndex!);
        saveFunctionOnTap(printModelTemp: printModelTemp);
      }

      confirmationDialogGlobal(
        context: context,
        okFunction: okFunction,
        cancelFunction: cancelFunctionOnTap,
        titleStr: "$deleteGlobal ${printModelTemp.otherList[otherIndex!].title.text}",
        subtitleStr: deleteConfirmGlobal,
      );
    }

    return deleteFunctionOnTap;
  }

  ValidButtonModel validSaveButtonFunction() {
    final bool isTitleEmpty = printModelTemp.otherList[otherIndex!].title.text.isEmpty;
    final bool isWidthEmpty = printModelTemp.otherList[otherIndex].width.text.isEmpty;
    // if (isTitleEmpty || isWidthEmpty) {
    //   return false;
    // }
    if (isTitleEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, error: "title is empty", errorType: ErrorTypeEnum.valueOfString);
    }
    if (isWidthEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, error: "width is empty", errorType: ErrorTypeEnum.valueOfNumber);
    }

    if (!isCreateNewOtherPrint) {
      bool isValid = false;
      final bool isTitleNotSame = (printModelTemp.otherList[otherIndex].title.text != printModelGlobal.otherList[otherIndex].title.text);
      if (isTitleNotSame) {
        isValid = true;
      }
      final bool isWidthNotSame = (printModelTemp.otherList[otherIndex].width.text != printModelGlobal.otherList[otherIndex].width.text);
      if (isWidthNotSame) {
        isValid = true;
      }
      final bool isHasHeaderAndFooterNotSame = (printModelTemp.otherList[otherIndex].isHasHeaderAndFooter != printModelGlobal.otherList[otherIndex].isHasHeaderAndFooter);
      if (isHasHeaderAndFooterNotSame) {
        isValid = true;
      }
      final isColumnNotSame = (printModelTemp.otherList[otherIndex].textColumnList.length != printModelGlobal.otherList[otherIndex].textColumnList.length);
      if (isColumnNotSame) {
        isValid = true;
      } else {
        for (int columnIndex = 0; columnIndex < printModelTemp.otherList[otherIndex].textColumnList.length; columnIndex++) {
          final bool isRowNotSame =
              (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList.length != printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].textRowList.length);
          final bool isExpandedAlignNotSame =
              (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].isExpandedAlign != printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].isExpandedAlign);
          if (isExpandedAlignNotSame) {
            isValid = true;
          }
          final bool isLeftAlignNotSame =
              (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].isLeftAlign != printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].isLeftAlign);
          if (isLeftAlignNotSame) {
            isValid = true;
          }
          final bool isRightAlignNotSame =
              (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].isRightAlign != printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].isRightAlign);
          if (isRightAlignNotSame) {
            isValid = true;
          }
          final bool isCenterAlignNotSame =
              (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].isCenterAlign != printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].isCenterAlign);
          if (isCenterAlignNotSame) {
            isValid = true;
          }

          if (isRowNotSame) {
            isValid = true;
          } else {
            for (int rowIndex = 0; rowIndex < printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList.length; rowIndex++) {
              // final bool isTitleEmpty = printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].text.text.isEmpty;
              // final bool isFontSizeEmpty = printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].fontSize.text.isEmpty;
              // if (isTitleEmpty || isFontSizeEmpty) {
              //   return false;
              // }

              final bool isTitleNotSame = (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].text.text !=
                  printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].text.text);
              if (isTitleNotSame) {
                isValid = true;
              }
              final bool isFillValueNotSame = (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].fillValue !=
                  printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].fillValue);
              if (isFillValueNotSame) {
                isValid = true;
              }
              final bool isFontSizeNotSame = (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].fontSize.text !=
                  printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].fontSize.text);
              if (isFontSizeNotSame) {
                isValid = true;
              }
              final bool isLeftAlignNotSame = (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].isLeftAlign !=
                  printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].isLeftAlign);
              if (isLeftAlignNotSame) {
                isValid = true;
              }
              final bool isRightAlignNotSame = (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].isRightAlign !=
                  printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].isRightAlign);
              if (isRightAlignNotSame) {
                isValid = true;
              }
              final bool isBoldNotSame = (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].isBold !=
                  printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].isBold);
              if (isBoldNotSame) {
                isValid = true;
              }
              final bool isUnderLineNotSame = (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].isUnderLine !=
                  printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].isUnderLine);
              if (isUnderLineNotSame) {
                isValid = true;
              }
              final bool isCenterAlignNotSame = (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].isCenterAlign !=
                  printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].isCenterAlign);
              if (isCenterAlignNotSame) {
                isValid = true;
              }
              final bool isTextNotSame = (printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].isText !=
                  printModelGlobal.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].isText);
              if (isTextNotSame) {
                isValid = true;
              }
            }
          }
        }
      }
      // return isValid;
      return ValidButtonModel(isValid: isValid, errorType: ErrorTypeEnum.nothingChange);
    }
    // for (int columnIndex = 0; columnIndex < printModelTemp.otherList[otherIndex].textColumnList.length; columnIndex++) {
    // for (int rowIndex = 0; rowIndex < printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList .length; rowIndex++) {
    //   final bool isTitleEmpty = printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].text.text.isEmpty;
    //   final bool isFontSizeEmpty = printModelTemp.otherList[otherIndex].textColumnList[columnIndex].textRowList[rowIndex].fontSize.text.isEmpty;
    //   if (isTitleEmpty || isFontSizeEmpty) {
    //     return false;
    //   }
    // }}

    // return true;
    return ValidButtonModel(isValid: true);
  }

  ValidButtonModel validPrintButtonFunction() {
    final bool isTitleEmpty = printModelTemp.otherList[otherIndex!].title.text.isEmpty;
    final bool isWidthEmpty = printModelTemp.otherList[otherIndex].width.text.isEmpty;
    // if (isTitleEmpty || isWidthEmpty) {
    //   return false;
    // }
    if (isTitleEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, error: "title is empty", errorType: ErrorTypeEnum.valueOfString);
    }
    if (isWidthEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, error: "width is empty", errorType: ErrorTypeEnum.valueOfNumber);
    }
    // return true;
    return ValidButtonModel(isValid: true);
  }

  void printFunctionOnTap() {
    printOtherInvoice(context: context, printCustomize: printModelTemp.otherList[otherIndex!]);
  }

  actionDialogSetStateGlobal(
    dialogHeight: dialogSizeGlobal(level: Level.mini),
    dialogWidth: dialogSizeGlobal(level: Level.mini),
    cancelFunctionOnTap: cancelFunctionOnTap,
    context: context,
    deleteFunctionOnTap: (isCreateNewOtherPrint || !isAdminEditing) ? null : deleteFunctionOrNull(),
    validSaveButtonFunction: () => (!isAdminEditing ? ValidButtonModel(isValid: false) : validSaveButtonFunction()),
    saveFunctionOnTap: isAdminEditing ? () => saveFunctionOnTap(printModelTemp: printModelTemp) : null,
    contentFunctionReturnWidget: editCardDialog,
    printFunctionOnTap: printFunctionOnTap,
    validPrintFunctionOnTap: () => validPrintButtonFunction(),
  );
}
