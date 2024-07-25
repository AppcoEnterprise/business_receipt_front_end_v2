import 'package:business_receipt/env/function/button/button_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/icon_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/icon_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:flutter/material.dart';

Widget buttonOrContainerWidget({
  Function? onTapFunction,
  IconData? icon,
  String? str,
  bool isExpanded = false,
  required Level level,
  Color colorTextAndIcon = textButtonColorGlobal,
  Color colorSideBox = defaultButtonColorGlobal,
  required ValidButtonModel validModel,
  required BuildContext context,
}) {
  final bool isHasFunction = (onTapFunction != null);
  if (isHasFunction) {
    // void onTap() {
    //   onTapFunction();
    // }

    Widget expandedOrNotWidget() {
      Widget buttonWidget() {
        return buttonGlobal(
            context: context,
            validModel: validModel,
            colorTextAndIcon: colorTextAndIcon,
            icon: icon,
            textStr: str,
            onTapUnlessDisableAndValid: onTapFunction,
            level: level,
            colorSideBox: colorSideBox);
      }

      return isExpanded ? Row(children: [Expanded(child: buttonWidget())]) : buttonWidget();
    }

    return expandedOrNotWidget();
  } else {
    return Container();
  }
}

Widget cancelButtonOrContainerWidget({
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    onTapFunction: onTapFunction,
    icon: cancelIconGlobal,
    str: cancelContentButtonStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorTextAndIcon: cancelButtonColorGlobal,
    colorSideBox: buttonIconColorGlobal,
    validModel: ValidButtonModel(isValid: true),
    context: context,
  );
}

Widget okButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
      context: context,
      validModel: validModel ?? ValidButtonModel(isValid: true),
      onTapFunction: onTapFunction,
      icon: okIconGlobal,
      str: okContentButtonStrGlobal,
      isExpanded: isExpanded,
      level: level);
}

Widget saveButtonOrContainerWidget({
  required BuildContext context,
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
}) {
  return buttonOrContainerWidget(
      context: context,
      validModel: validModel ?? ValidButtonModel(isValid: true),
      onTapFunction: onTapFunction,
      icon: saveIconGlobal,
      str: saveContentButtonStrGlobal,
      isExpanded: isExpanded,
      level: level);
}

Widget saveAndPrintButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: printIconGlobal,
    str: saveAndPrintContentButtonStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: saveAndPrintButtonColorGlobal,
  );
}

Widget calculateButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: calculateIconGlobal,
    str: calculateStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: defaultButtonColorGlobal,
  );
}

Widget advanceCalculateButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: calculateIconGlobal,
    str: advanceCalculateStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: defaultButtonColorGlobal,
  );
}

Widget historyButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
      context: context,
      validModel: validModel ?? ValidButtonModel(isValid: true),
      onTapFunction: onTapFunction,
      icon: historyIconGlobal,
      str: historyContentButtonStrGlobal,
      isExpanded: isExpanded,
      level: level);
}

Widget clearButtonOrContainerWidget({
  ValidButtonModel? validModel,
  bool isShowText = true,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    colorSideBox: clearButtonColorGlobal,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: clearIconGlobal,
    str: isShowText ? clearContentButtonStrGlobal : null,
    isExpanded: isExpanded,
    level: level,
  );
}

Widget analysisButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
      context: context,
      validModel: validModel ?? ValidButtonModel(isValid: true),
      onTapFunction: onTapFunction,
      icon: analysisIconGlobal,
      str: analysisContentButtonStrGlobal,
      isExpanded: isExpanded,
      level: level);
}

Widget addButtonOrContainerWidget({
  ValidButtonModel? validModel,
  bool isShowText = true,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required int currentAddButtonQty,
  required int maxAddButtonLimit,
  required BuildContext context,
}) {
  validModel ??= ValidButtonModel(isValid: true);
  ValidButtonModel validButtonModel() {
    if (currentAddButtonQty >= maxAddButtonLimit) {
      return ValidButtonModel(isValid: false, error: "You have reached the limit of $maxAddButtonLimit");
    } else {
      // return validModel!;
      return ValidButtonModel(
        isValid: validModel!.isValid,
        error: validModel.error,
        detailList: validModel.detailList,
        errorLocationList: validModel.errorLocationList,
      );
    }
  }

  return buttonOrContainerWidget(
    context: context,
    // validModel: ValidButtonModel(
    //   isValid: validModel.isValid && (currentAddButtonQty < maxAddButtonLimit),
    //   error: validModel.error,
    //   detailList: validModel.detailList,
    //   errorLocationList: validModel.errorLocationList,
    // ),
    validModel: validButtonModel(),
    onTapFunction: onTapFunction,
    icon: createIconGlobal,
    str: "${isShowText ? addContentButtonStrGlobal : ""} ($currentAddButtonQty/$maxAddButtonLimit)",
    isExpanded: isExpanded,
    level: level,
    colorSideBox: addButtonColorGlobal,
  );
}

Widget deleteButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: deleteIconGlobal,
    str: deleteContentButtonStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: deleteButtonColorGlobal,
  );
}

Widget forceToChangeButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: forceToChangeIconGlobal,
    str: forceToChangeContentButtonStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: defaultButtonColorGlobal,
  );
}

Widget restartButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: restartIconGlobal,
    str: restartContentButtonStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: defaultButtonColorGlobal,
  );
}

Widget restoreButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: restoreIconGlobal,
    str: restoreGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: restoreButtonColorGlobal,
  );
}

Widget closeSellingButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: closeSellingIconGlobal,
    str: closeSellingContentButtonStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: closeSellingButtonColorGlobal,
  );
}

//onTapFunction: () {}
Widget createButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: createIconGlobal,
    str: createContentButtonStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: addButtonColorGlobal,
  );
}

Widget nextButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: nextIconGlobal,
    str: nextContentButtonStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: nextButtonColorGlobal,
  );
}

Widget acceptSuggestButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: acceptSuggestIconGlobal,
    str: acceptSuggestionStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: acceptSuggestButtonColorGlobal,
  );
}

Widget printButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: printIconGlobal,
    str: printContentButtonStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: saveAndPrintButtonColorGlobal,
  );
}

Widget exportToExcelButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  // return buttonOrContainerWidget(
  //   isValid: isValid,
  //   onTapFunction: onTapFunction,
  //   icon: excelIconGlobal,
  //   str: exportToExcelContentButtonStrGlobal,
  //   isExpanded: isExpanded,
  //   level: level,
  //   colorSideBox: saveAndPrintButtonColorGlobal,
  // );

  validModel ??= ValidButtonModel(isValid: true);
  Widget setWidthHeightSizeBowWidget() {
    RoundedRectangleBorder nonBorder() {
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusGlobal));
    }

    Widget paddingInsideSizeBox() {
      Widget insideSizeBox() {
        Widget sizeBoxWidget() {
          Widget iconWidget() {
            return iconGlobal(iconData: excelIconGlobal, color: textButtonColorGlobal, level: level);
          }

          return Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: level)), child: iconWidget()),
            Text(exportToExcelContentButtonStrGlobal, style: textStyleGlobal(level: level, color: textButtonColorGlobal)),
          ]);
        }

        return sizeBoxWidget();
      }

      return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: level)), child: insideSizeBox());
    }

    final Color colorWithValueCondition = validModel!.isValid ? defaultButtonColorGlobal : disableButtonColorGlobal;
    return Card(margin: EdgeInsets.zero, shape: nonBorder(), color: colorWithValueCondition, elevation: elevationGlobal, child: paddingInsideSizeBox());
  }

  return (onTapFunction == null)
      ? Container()
      : InkWell(
          focusColor: hoverFocusClickButtonColorGlobal,
          highlightColor: hoverFocusClickButtonColorGlobal,
          hoverColor: hoverFocusClickButtonColorGlobal,
          splashColor: hoverFocusClickButtonColorGlobal,
          onTap: () {
            if (validModel!.isValid) {
              onTapFunction();
            }
          },
          child: setWidthHeightSizeBowWidget(),
        );
}

Widget refreshButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: refreshIconGlobal,
    str: refreshContentButtonStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: defaultButtonColorGlobal,
  );
}

Widget historyAsyncButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  validModel ??= ValidButtonModel(isValid: true);
  Widget setWidthHeightSizeBowWidget() {
    RoundedRectangleBorder nonBorder() {
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusGlobal));
    }

    Widget paddingInsideSizeBox() {
      Widget insideSizeBox() {
        Widget sizeBoxWidget() {
          Widget iconWidget() {
            return iconGlobal(iconData: historyIconGlobal, color: textButtonColorGlobal, level: level);
          }

          return Row(children: [
            Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: level)), child: iconWidget()),
            Text(historyContentButtonStrGlobal, style: textStyleGlobal(level: level, color: textButtonColorGlobal)),
          ]);
        }

        return sizeBoxWidget();
      }

      return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: level)), child: insideSizeBox());
    }

    final Color colorWithValueCondition = validModel!.isValid ? defaultButtonColorGlobal : disableButtonColorGlobal;
    return Card(margin: EdgeInsets.zero, shape: nonBorder(), color: colorWithValueCondition, elevation: elevationGlobal, child: paddingInsideSizeBox());
  }

  return (onTapFunction == null)
      ? Container()
      : InkWell(
          focusColor: hoverFocusClickButtonColorGlobal,
          highlightColor: hoverFocusClickButtonColorGlobal,
          hoverColor: hoverFocusClickButtonColorGlobal,
          splashColor: hoverFocusClickButtonColorGlobal,
          onTap: () {
            if (validModel!.isValid) {
              onTapFunction();
            } else {
              errorDetailDialogGlobal(context: context, validModel: validModel);
            }
          },
          child: setWidthHeightSizeBowWidget(),
        );
}

Widget totalButtonOrContainerWidget({
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  return buttonOrContainerWidget(
    context: context,
    validModel: validModel ?? ValidButtonModel(isValid: true),
    onTapFunction: onTapFunction,
    icon: totalIconGlobal,
    str: totalContentButtonStrGlobal,
    isExpanded: isExpanded,
    level: level,
    colorSideBox: saveAndPrintButtonColorGlobal,
  );
}

Widget pickDateAsyncButtonOrContainerWidget({
  required String dateStr,
  ValidButtonModel? validModel,
  Function? onTapFunction,
  bool isExpanded = false,
  required Level level,
  required BuildContext context,
}) {
  validModel ??= ValidButtonModel(isValid: true);
  Widget setWidthHeightSizeBowWidget() {
    RoundedRectangleBorder nonBorder() {
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusGlobal));
    }

    Widget paddingInsideSizeBox() {
      Widget insideSizeBox() {
        Widget sizeBoxWidget() {
          Widget iconWidget() {
            return iconGlobal(iconData: dateIconGlobal, color: defaultTextColorGlobal, level: level);
          }

          return Row(children: [
            Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: level)), child: iconWidget()),
            Text(dateStr, style: textStyleGlobal(level: level, color: defaultTextColorGlobal)),
          ]);
        }

        return sizeBoxWidget();
      }

      return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: level)), child: insideSizeBox());
    }

    final Color colorWithValueCondition = validModel!.isValid ? widgetButtonColorGlobal : disableButtonColorGlobal;
    return Card(margin: EdgeInsets.zero, shape: nonBorder(), color: colorWithValueCondition, elevation: elevationGlobal, child: paddingInsideSizeBox());
  }

  return (onTapFunction == null)
      ? Container()
      : InkWell(
          focusColor: hoverFocusClickButtonColorGlobal,
          highlightColor: hoverFocusClickButtonColorGlobal,
          hoverColor: hoverFocusClickButtonColorGlobal,
          splashColor: hoverFocusClickButtonColorGlobal,
          onTap: () {
            if (validModel!.isValid) {
              onTapFunction();
            } else {
              errorDetailDialogGlobal(context: context, validModel: validModel);
            }
          },
          child: setWidthHeightSizeBowWidget(),
        );
}
