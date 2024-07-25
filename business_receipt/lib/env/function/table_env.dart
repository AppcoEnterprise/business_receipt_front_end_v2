// ignore_for_file: unused_field

import 'package:business_receipt/env/function/button/button_env.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/drop_down_and_text_field_provider.dart';
import 'package:business_receipt/env/function/icon_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/active_log.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/icon_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:flutter/material.dart';

enum _TableType { header, body, footer }

enum WidgetType { hiddenText, text, textFieldDouble, textFieldInt, dropDown, dropDownOrTextField, numberText }

// ignore: must_be_immutable
class _RowTableWithHoverClass extends StatefulWidget {
  bool isAllowedHover;
  Color backgroundColor;
  _TableType tableType;

  List<int> expandedList;
  List<TextEditingController> headerList;
  List<List<TextEditingController>> textFieldController2D;
  List<List<bool>> isShowTextField2D;
  List<List<List<String>>> menuItemStr3D;
  List<WidgetType> widgetTypeList;
  int verticalIndex;
  int? setValueAfterDeleteOnDropDownAndTextFieldProviderIndex;
  Function returnIsShowAndTextFieldController2DFunction;
  bool isShowDeleteButton;
  bool isNumberInputOnDropDownAndTextField;

  _RowTableWithHoverClass({
    required this.verticalIndex,
    required this.expandedList,
    required this.headerList,
    required this.textFieldController2D,
    required this.isShowTextField2D,
    required this.menuItemStr3D,
    required this.widgetTypeList,
    required this.backgroundColor,
    this.isAllowedHover = true,
    required this.setValueAfterDeleteOnDropDownAndTextFieldProviderIndex,
    required this.tableType,
    required this.returnIsShowAndTextFieldController2DFunction,
    required this.isShowDeleteButton,
    required this.isNumberInputOnDropDownAndTextField,
  });

  @override
  State<_RowTableWithHoverClass> createState() => _RowTableWithHoverStateClass();
}

class _RowTableWithHoverStateClass extends State<_RowTableWithHoverClass> {
  bool isHover = false;
  double sliderValue = 0;
  @override
  Widget build(BuildContext context) {
    Widget paddingRightAndBottomWidget({required Widget widget}) {
      return Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal), top: paddingSizeGlobal(level: Level.mini)), child: widget);
    }

    Widget widgetTypeWidget({
      required WidgetType widgetType,
      required String label,
      required TextEditingController controller,
      required List<String> menuItemStrList,
      required int verticalIndex,
      required int horizontalIndex,
      required bool isShowTextField,
    }) {
      String str = controller.text;
      if (widget.tableType == _TableType.header) {
        return Text(str, style: textStyleGlobal(level: Level.normal));
      }

      void onChangeTextFieldFunction() {
        widget.returnIsShowAndTextFieldController2DFunction(
          oldController2D: widget.textFieldController2D,
          controller2D: widget.textFieldController2D,
          isShowTextField2D: widget.isShowTextField2D,
          oldIsShowTextField2D: widget.isShowTextField2D,
          verticalIndex: verticalIndex,
          horizontalIndex: horizontalIndex,
          activeLog: ActiveLogTypeEnum.typeTextfield,
        );
      }

      void onChangedDropDownFunction({required String value, required int index}) {
        List<List<TextEditingController>> oldTextFieldController2D = cloneTextFieldController2D(textFieldController2D: widget.textFieldController2D);
        List<List<bool>> oldIsShowTextField2D = cloneIsShowTextField2D(isShowTextField2D: widget.isShowTextField2D);
        final bool isSelectedOtherRate = (value == otherStrGlobal);
        widget.isShowTextField2D[verticalIndex][horizontalIndex] = isSelectedOtherRate;
        if (!isSelectedOtherRate) {
          widget.textFieldController2D[verticalIndex][horizontalIndex].text = value;
        }
        widget.returnIsShowAndTextFieldController2DFunction(
          controller2D: widget.textFieldController2D,
          oldController2D: oldTextFieldController2D,
          isShowTextField2D: widget.isShowTextField2D,
          oldIsShowTextField2D: oldIsShowTextField2D,
          verticalIndex: verticalIndex,
          horizontalIndex: horizontalIndex,
          activeLog: ActiveLogTypeEnum.selectDropdown,
        );
      }

      void onTapFunction() {}

      Widget textFieldWidget({required TextFieldDataType textFieldDataType}) {
        void onTapFromOutsiderFunction() {}
        return textFieldGlobal(
          onChangeFromOutsiderFunction: onChangeTextFieldFunction,
          labelText: label,
          level: Level.mini,
          controller: controller,
          textFieldDataType: textFieldDataType,
          onTapFromOutsiderFunction: onTapFromOutsiderFunction,
        );
      }

      Widget dropDownWidget() {
        TextEditingController controller = widget.textFieldController2D[verticalIndex][horizontalIndex];
        String? selectedStr = controller.text.isEmpty ? null : controller.text;
        return customDropdown(
          labelStr: label,
          level: Level.mini,
          menuItemStrList: menuItemStrList,
          onChangedFunction: onChangedDropDownFunction,
          onTapFunction: onTapFunction,
          selectedStr: selectedStr,
        );
      }

      Widget textWidget() {
        return Text(str, style: textStyleGlobal(level: Level.normal));
      }

      Widget dropDownAndTextFieldProviderWidget() {
        final bool isNumberInputOnDropDownAndTextField = widget.isNumberInputOnDropDownAndTextField;
        final bool isShowTextField = widget.isShowTextField2D[verticalIndex][horizontalIndex];
        if (isNumberInputOnDropDownAndTextField && isShowTextField) {
          widget.textFieldController2D[verticalIndex][horizontalIndex].value = copyValueAndMoveToLastGlobal(
              controller: widget.textFieldController2D[verticalIndex][horizontalIndex],
              value: formatAndLimitNumberTextGlobal(
                  valueStr: widget.textFieldController2D[verticalIndex][horizontalIndex].text, isRound: false, isAllowZeroAtLast: true));
        }
        void onDeleteFunction() {
          List<List<TextEditingController>> oldTextFieldController2D = cloneTextFieldController2D(textFieldController2D: widget.textFieldController2D);
          List<List<bool>> oldIsShowTextField2D = cloneIsShowTextField2D(isShowTextField2D: widget.isShowTextField2D);
          widget.isShowTextField2D[verticalIndex][horizontalIndex] = !widget.isShowTextField2D[verticalIndex][horizontalIndex];
          final bool isNullIndex = (widget.setValueAfterDeleteOnDropDownAndTextFieldProviderIndex == null);
          if (isNullIndex) {
            widget.textFieldController2D[verticalIndex][horizontalIndex].text = "";
          } else {
            widget.textFieldController2D[verticalIndex][horizontalIndex].text =
                widget.textFieldController2D[verticalIndex][widget.setValueAfterDeleteOnDropDownAndTextFieldProviderIndex!].text;
          }
          widget.returnIsShowAndTextFieldController2DFunction(
            oldController2D: oldTextFieldController2D,
            controller2D: widget.textFieldController2D,
            isShowTextField2D: widget.isShowTextField2D,
            oldIsShowTextField2D: oldIsShowTextField2D,
            verticalIndex: verticalIndex,
            horizontalIndex: horizontalIndex,
            activeLog: ActiveLogTypeEnum.clickButton,
          );
        }

        return DropDownAndTextFieldProviderGlobal(
          labelStr: label,
          level: Level.mini,
          menuItemStrList: menuItemStrList,
          onChangedDropDrownFunction: onChangedDropDownFunction,
          onChangedTextFieldFunction: onChangeTextFieldFunction,
          onDeleteFunction: onDeleteFunction,
          onTapFunction: onTapFunction,
          selectedStr: widget.textFieldController2D[verticalIndex][horizontalIndex].text,
          textFieldDataType: TextFieldDataType.double,
          isShowTextField: isShowTextField,
          controller: widget.textFieldController2D[verticalIndex][horizontalIndex],
        );
      }

      Widget numberTextWidget() {
        final String formatStr = formatTextToNumberStrGlobal(valueStr: str);
        final double strNumber = formatStr.isEmpty ? 0 : double.parse(formatStr);
        final bool isNumberPositive = (strNumber >= 0);
        return Text(str, style: textStyleGlobal(level: Level.normal, color: isNumberPositive ? positiveColorGlobal : negativeColorGlobal));
      }

      switch (widgetType) {
        case WidgetType.hiddenText:
          return Container();
        case WidgetType.text:
          return paddingRightAndBottomWidget(widget: textWidget());
        case WidgetType.textFieldDouble:
          return paddingRightAndBottomWidget(widget: textFieldWidget(textFieldDataType: TextFieldDataType.double));
        case WidgetType.dropDown:
          return paddingRightAndBottomWidget(widget: dropDownWidget());
        case WidgetType.textFieldInt:
          return paddingRightAndBottomWidget(widget: textFieldWidget(textFieldDataType: TextFieldDataType.int));
        case WidgetType.dropDownOrTextField:
          return paddingRightAndBottomWidget(widget: dropDownAndTextFieldProviderWidget());
        case WidgetType.numberText:
          return paddingRightAndBottomWidget(widget: numberTextWidget());
      }
    }

    Widget rowContentWidget() {
      Widget setBackgroundColor() {
        void onTapFunction() {}

        void onHoverFunction({required bool isHovering}) {
          if (widget.isAllowedHover) {
            isHover = isHovering;
            setState(() {});
          }
        }

        Widget paddingRowContentWidget() {
          final List<EdgeInsets> tableTypePaddingList = [
            EdgeInsets.only(
                left: paddingSizeGlobal(level: Level.normal), right: paddingSizeGlobal(level: Level.normal), top: paddingSizeGlobal(level: Level.normal)),
            EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal), right: paddingSizeGlobal(level: Level.normal)),
            EdgeInsets.zero,
          ];

          EdgeInsets tablePadding({required _TableType tableType}) {
            int indexLevel({required _TableType tableType}) {
              return tableType.index;
            }

            return tableTypePaddingList[indexLevel(tableType: tableType)];
          }

          Widget rowContentListWidget() {
            Widget deleteOrContainerWidget() {
              void onTapUnlessDisableAndValid() {
                List<List<TextEditingController>> oldTextFieldController2D = cloneTextFieldController2D(textFieldController2D: widget.textFieldController2D);
                List<List<bool>> oldIsShowTextField2D = cloneIsShowTextField2D(isShowTextField2D: widget.isShowTextField2D);
                widget.textFieldController2D.removeAt(widget.verticalIndex);
                widget.returnIsShowAndTextFieldController2DFunction(
                  oldController2D: oldTextFieldController2D,
                  controller2D: widget.textFieldController2D,
                  isShowTextField2D: widget.isShowTextField2D,
                  oldIsShowTextField2D: oldIsShowTextField2D,
                  verticalIndex: 0,
                  horizontalIndex: 0,
                  activeLog: ActiveLogTypeEnum.clickButton,
                );
              }

              Widget deleteWidget() {
                return buttonGlobal(
                  context: context,
                  colorTextAndIcon: buttonIconColorGlobal,
                  level: Level.mini,
                  onTapUnlessDisableAndValid: onTapUnlessDisableAndValid,
                  icon: deleteIconGlobal,
                  colorSideBox: deleteButtonColorGlobal,
                  elevation: 0,
                );
              }

              PopupMenuItem deletePopupMenuItem() {
                Widget deleteIcon = iconGlobal(iconData: deleteIconGlobal, color: deleteButtonColorGlobal, level: Level.mini);
                Widget deleteText = Text(deleteGlobal, style: textStyleGlobal(level: Level.mini, color: deleteButtonColorGlobal));
                return PopupMenuItem(
                    value: 2,
                    child: Row(children: [
                      deleteIcon,
                      Padding(
                        padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
                        child: deleteText,
                      )
                    ]));
              }

              return (isHover && widget.isAllowedHover)
                  ? deleteWidget()
                  : widget.isAllowedHover
                      ? PopupMenuButton(
                          tooltip: "",
                          onSelected: (value) {
                            onTapUnlessDisableAndValid();
                          },
                          itemBuilder: (ctx) => [deletePopupMenuItem()],
                        )
                      : Container();
            }

            Widget deleteWidget() {
              return (widget.isAllowedHover)
                  ? (widget.isShowDeleteButton && (widget.textFieldController2D.length != 1))
                      ? paddingRightAndBottomWidget(widget: deleteOrContainerWidget())
                      : Container(width: 50)
                  : Container(width: 50);
            }

            return (widget.textFieldController2D.isEmpty)
                ? Container()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (int contentHorizontalIndex = 0;
                          contentHorizontalIndex < widget.textFieldController2D[widget.verticalIndex].length;
                          contentHorizontalIndex++)
                        Expanded(
                          flex: widget.expandedList[contentHorizontalIndex],
                          child: widgetTypeWidget(
                            controller: widget.textFieldController2D[widget.verticalIndex][contentHorizontalIndex],
                            widgetType: widget.widgetTypeList[contentHorizontalIndex],
                            label: widget.headerList[contentHorizontalIndex].text,
                            menuItemStrList: widget.menuItemStr3D[widget.verticalIndex][contentHorizontalIndex],
                            verticalIndex: widget.verticalIndex,
                            horizontalIndex: contentHorizontalIndex,
                            isShowTextField: widget.isShowTextField2D[widget.verticalIndex][contentHorizontalIndex],
                          ),
                        ),
                      deleteWidget(),
                    ],
                  );
          }

          return Padding(padding: tablePadding(tableType: widget.tableType), child: rowContentListWidget());
        }

        BoxDecoration decorationHeaderOrBody() {
          final bool isBody = (_TableType.body == widget.tableType);
          if (isBody) {
            return BoxDecoration(color: widget.backgroundColor);
          } else {
            return BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(borderRadiusGlobal),
                topRight: Radius.circular(borderRadiusGlobal),
              ),
            );
          }
        }

        return Container(
          margin: EdgeInsets.zero,
          decoration: decorationHeaderOrBody(),
          child: InkWell(
            focusColor: widget.backgroundColor,
            highlightColor: widget.backgroundColor,
            hoverColor: widget.backgroundColor,
            splashColor: widget.backgroundColor,
            onTap: onTapFunction,
            onHover: (isHovering) {
              onHoverFunction(isHovering: isHovering);
            },
            child: paddingRowContentWidget(),
          ),
        );
      }

      return setBackgroundColor();
    }

    return rowContentWidget();
  }
}

// ignore: must_be_immutable
class TableGlobalWidget extends StatefulWidget {
  // List<List<Function>> callbackList;
  List<int> expandedList;
  List<TextEditingController> headerList;
  List<List<TextEditingController>> textFieldController2D;
  List<List<bool>> isShowTextField2D;
  List<List<List<String>>> menuItemStr3D;
  List<WidgetType> widgetTypeList; //table row length is based on widgetTypeList
  Function returnIsShowAndTextFieldController2DFunction; //returnTextFieldController2DFunction({required List<List<TextEditingController>> controller2D}) {...}
  int? setValueAfterDeleteOnDropDownAndTextFieldProviderIndex;
  bool isShowDeleteButton;
  bool isShowAddMoreButton;
  bool isDisableAddMoreButton;
  bool isNumberInputOnDropDownAndTextField;
  int currentAddButtonQty;
  int maxAddButtonLimit;
  TableGlobalWidget({
    super.key,
    this.currentAddButtonQty = 0,
    this.maxAddButtonLimit = 0,
    // required this.callbackList,
    required this.expandedList,
    required this.headerList,
    required this.textFieldController2D,
    required this.isShowTextField2D,
    required this.menuItemStr3D,
    required this.widgetTypeList,
    required this.returnIsShowAndTextFieldController2DFunction,
    this.setValueAfterDeleteOnDropDownAndTextFieldProviderIndex,
    this.isShowDeleteButton = true,
    this.isShowAddMoreButton = true,
    this.isDisableAddMoreButton = true,
    this.isNumberInputOnDropDownAndTextField = false,
  });

  @override
  State<TableGlobalWidget> createState() => _TableGlobalWidgetState();
}

class _TableGlobalWidgetState extends State<TableGlobalWidget> {
  get maxAddButtonLimit => null;

  void addRowTextFieldValueAndController2DIsEmpty() {
    List<TextEditingController> rowControllerList = [];
    for (int widgetTypeIndex = 0; widgetTypeIndex < widget.widgetTypeList.length; widgetTypeIndex++) {
      rowControllerList.add(TextEditingController());
    }

    widget.textFieldController2D.add(rowControllerList);
  }

  @override
  void initState() {
    // void initForEmptyTextFieldController2D() {
    //   if (widget.textFieldController2D.isEmpty) {
    //     addRowTextFieldValueAndController2DIsEmpty();
    //   }
    // }

    void initMenuItem() {
      //textFieldValueAndController2D: [
      //  ["1", "2", "3", "4", "5"],
      //  ["11", "22", "33", "44", "55"],
      //  ["111", "222", "333", "444", "555"],
      //]

      //[...],
      //[...],
      //[...]
      for (int verticalIndex = 0; verticalIndex < widget.textFieldController2D.length; verticalIndex++) {
        // horizontal of first index ["1", "2", "3", "4", "5"]
        for (int horizontalIndex = 0; horizontalIndex < widget.textFieldController2D[verticalIndex].length; horizontalIndex++) {
          final String valueStr = widget.textFieldController2D[verticalIndex][horizontalIndex].text;
          final bool isDropDown = (widget.widgetTypeList[horizontalIndex] == WidgetType.dropDown);
          //widgetTypeList: [WidgetType.text, WidgetType.dropDown, WidgetType.textField, WidgetType.text, WidgetType.slider]
          if (isDropDown) {
            //check existing in menuItemStr2D
            bool allowToAdd = true;
            for (int widgetTypeIndex = 0; widgetTypeIndex < widget.menuItemStr3D[verticalIndex][horizontalIndex].length; widgetTypeIndex++) {
              final String menuItemStr = widget.menuItemStr3D[verticalIndex][horizontalIndex][widgetTypeIndex];
              final bool isExist = (menuItemStr == valueStr);
              if (isExist) {
                allowToAdd = false;
                break;
              }
            }
            //menuItemStr2D is not existed
            if (allowToAdd) {
              widget.menuItemStr3D[verticalIndex][horizontalIndex].add(valueStr);
            }
          }
        }
      }
    }

    initMenuItem();
    // initForEmptyTextFieldController2D();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget setBorder() {
      Widget tableWidget() {
        ValidButtonModel isAllowToAddRowOnMain() {
          for (int contentVerticalIndex = 0; contentVerticalIndex < widget.textFieldController2D.length; contentVerticalIndex++) {
            for (int contentHorizontalIndex = 0; contentHorizontalIndex < widget.textFieldController2D[contentVerticalIndex].length; contentHorizontalIndex++) {
              final TextEditingController controller = widget.textFieldController2D[contentVerticalIndex][contentHorizontalIndex];
              final bool isTextFieldEmpty = (controller.text.isEmpty || (controller.text == emptyStrGlobal));
              if (isTextFieldEmpty) {
                // return false;
                if (widget.widgetTypeList[contentHorizontalIndex] == WidgetType.textFieldDouble ||
                    widget.widgetTypeList[contentHorizontalIndex] == WidgetType.textFieldInt) {
                  return ValidButtonModel(
                    isValid: widget.widgetTypeList[contentHorizontalIndex] == WidgetType.hiddenText,
                    errorType: ErrorTypeEnum.valueOfNumber,
                    error: "${widget.headerList[contentHorizontalIndex].text} is empty",
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "Row index", subtitle: "$contentVerticalIndex"),
                      TitleAndSubtitleModel(title: "Column index", subtitle: "$contentHorizontalIndex"),
                    ],
                  );
                }
                return ValidButtonModel(
                  isValid: widget.widgetTypeList[contentHorizontalIndex] == WidgetType.hiddenText,
                  errorType: ErrorTypeEnum.valueOfString,
                  error: "${widget.headerList[contentHorizontalIndex].text} is empty",
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "Row index", subtitle: "$contentVerticalIndex"),
                    TitleAndSubtitleModel(title: "Column index", subtitle: "$contentHorizontalIndex"),
                  ],
                );
              }
            }
          }
          // return true;
          return ValidButtonModel(isValid: true);
        }

        Widget headerWidget() {
          return _RowTableWithHoverClass(
            expandedList: widget.expandedList,
            backgroundColor: headerColorGlobal,
            isAllowedHover: false,
            tableType: _TableType.header,
            headerList: widget.headerList,
            textFieldController2D: [widget.headerList],
            menuItemStr3D: widget.menuItemStr3D,
            widgetTypeList: widget.widgetTypeList,
            verticalIndex: 0,
            returnIsShowAndTextFieldController2DFunction: widget.returnIsShowAndTextFieldController2DFunction,
            isShowTextField2D: widget.isShowTextField2D,
            setValueAfterDeleteOnDropDownAndTextFieldProviderIndex: widget.setValueAfterDeleteOnDropDownAndTextFieldProviderIndex,
            isShowDeleteButton: widget.isShowDeleteButton,
            isNumberInputOnDropDownAndTextField: widget.isNumberInputOnDropDownAndTextField,
          );
        }

        Widget bodyScrollWidget() {
          return Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                for (int contentVerticalIndex = 0; contentVerticalIndex < widget.textFieldController2D.length; contentVerticalIndex++)
                  _RowTableWithHoverClass(
                    expandedList: widget.expandedList,
                    backgroundColor: bodyColorGlobal,
                    tableType: _TableType.body,
                    headerList: widget.headerList,
                    textFieldController2D: widget.textFieldController2D,
                    menuItemStr3D: widget.menuItemStr3D,
                    widgetTypeList: widget.widgetTypeList,
                    verticalIndex: contentVerticalIndex,
                    returnIsShowAndTextFieldController2DFunction: widget.returnIsShowAndTextFieldController2DFunction,
                    isShowTextField2D: widget.isShowTextField2D,
                    setValueAfterDeleteOnDropDownAndTextFieldProviderIndex: widget.setValueAfterDeleteOnDropDownAndTextFieldProviderIndex,
                    isShowDeleteButton: widget.isShowDeleteButton,
                    isNumberInputOnDropDownAndTextField: widget.isNumberInputOnDropDownAndTextField,
                  ),
              ]),
            ),
          );
        }

        Widget footerButtonProviderWidget() {
          Widget footerWidget() {
            // ValidButtonModel allowToAddRowModel =
            //     isAllowToAddRowOnMain() && widget.isDisableAddMoreButton && (widget.currentAddButtonQty < widget.maxAddButtonLimit);
            ValidButtonModel allowToAddRowModel() {
              if (widget.isDisableAddMoreButton) {
                return ValidButtonModel(isValid: false, error: "Add more button is disabled");
              }
              if (widget.currentAddButtonQty >= widget.maxAddButtonLimit) {
                return ValidButtonModel(isValid: false, error: "You have reached the limit of $maxAddButtonLimit");
              }

              return isAllowToAddRowOnMain();
            }

            Color buttonColor = allowToAddRowModel().isValid ? addButtonColorGlobal : disableButtonColorGlobal;
            Widget borderWidget() {
              BoxDecoration decoration() {
                return BoxDecoration(
                  color: buttonColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(borderRadiusGlobal),
                    bottomRight: Radius.circular(borderRadiusGlobal),
                  ),
                );
              }

              Widget paddingAddRowWidget() {
                Widget buttonAddRowWidget() {
                  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "$addContentButtonStrGlobal (${widget.currentAddButtonQty}/${widget.maxAddButtonLimit})",
                      style: textStyleGlobal(level: Level.normal, color: textButtonColorGlobal),
                    ),
                  ]);
                }

                return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.normal)), child: buttonAddRowWidget());
              }

              return Container(margin: EdgeInsets.zero, decoration: decoration(), child: paddingAddRowWidget());
            }

            void onTapFunction() {
              if (allowToAddRowModel().isValid) {
                List<List<TextEditingController>> oldTextFieldController2D = cloneTextFieldController2D(textFieldController2D: widget.textFieldController2D);
                List<List<bool>> oldIsShowTextField2D = cloneIsShowTextField2D(isShowTextField2D: widget.isShowTextField2D);
                addRowTextFieldValueAndController2DIsEmpty();
                widget.returnIsShowAndTextFieldController2DFunction(
                  oldController2D: oldTextFieldController2D,
                  controller2D: widget.textFieldController2D,
                  isShowTextField2D: widget.isShowTextField2D,
                  oldIsShowTextField2D: oldIsShowTextField2D,
                  verticalIndex: 0,
                  horizontalIndex: 0,
                  activeLog: ActiveLogTypeEnum.clickButton,
                  // required int verticalIndex,
                  // required int horizontalIndex,
                  // required ActiveLogTypeEnum activeLog,
                );
              } else {
                errorDetailDialogGlobal(context: context, validModel: allowToAddRowModel());
              }
            }

            return InkWell(
              focusColor: buttonColor,
              highlightColor: buttonColor,
              hoverColor: buttonColor,
              splashColor: buttonColor,
              onTap: onTapFunction,
              child: borderWidget(),
            );
          }

          return widget.isShowAddMoreButton ? footerWidget() : Container();
        }

        return Column(children: [
          Expanded(child: Column(children: [headerWidget(), bodyScrollWidget()])),
          footerButtonProviderWidget()
        ]);
      }

      return Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusGlobal), side: const BorderSide(color: borderSideGlobal)),
        child: tableWidget(),
      );
    }

    return setBorder();
  }
}

List<List<TextEditingController>> cloneTextFieldController2D({required List<List<TextEditingController>> textFieldController2D}) {
  List<List<TextEditingController>> newTextFieldController2D = [];
  for (int verticalIndex = 0; verticalIndex < textFieldController2D.length; verticalIndex++) {
    List<TextEditingController> newTextFieldControllerList = [];
    for (int horizontalIndex = 0; horizontalIndex < textFieldController2D[verticalIndex].length; horizontalIndex++) {
      newTextFieldControllerList.add(TextEditingController(text: textFieldController2D[verticalIndex][horizontalIndex].text));
    }
    newTextFieldController2D.add(newTextFieldControllerList);
  }
  return newTextFieldController2D;
}

List<List<bool>> cloneIsShowTextField2D({required List<List<bool>> isShowTextField2D}) {
  List<List<bool>> newIsShowTextField2D = [];
  for (int verticalIndex = 0; verticalIndex < isShowTextField2D.length; verticalIndex++) {
    List<bool> newIsShowTextFieldList = [];
    for (int horizontalIndex = 0; horizontalIndex < isShowTextField2D[verticalIndex].length; horizontalIndex++) {
      newIsShowTextFieldList.add(isShowTextField2D[verticalIndex][horizontalIndex]);
    }
    newIsShowTextField2D.add(newIsShowTextFieldList);
  }
  return newIsShowTextField2D;
}
