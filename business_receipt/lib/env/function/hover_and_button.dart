import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/icon_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/icon_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:flutter/material.dart';

Widget printAndDeleteWidgetGlobal({
  required Function? onDeleteFunction,
  required Function? onPrintFunction,
  required bool isHovering,
  required bool isDelete,
  required BuildContext context,
}) {
  Widget printWidget() {
    return Padding(
      padding: EdgeInsets.only(right: ((onDeleteFunction == null) ? 0 : paddingSizeGlobal(level: Level.mini))),
      child: printButtonOrContainerWidget(
        level: Level.mini,
        onTapFunction: onPrintFunction,
        context: context,
      ),
    );
  }

  Widget deleteWidget() {
    return deleteButtonOrContainerWidget(level: Level.mini, onTapFunction: onDeleteFunction, context: context);
  }

  Widget popupMenuButtonWidget() {
    PopupMenuItem printPopupMenuItem() {
      Widget printIcon = iconGlobal(iconData: printIconGlobal, color: saveAndPrintButtonColorGlobal, level: Level.mini);
      Widget printText = Text(printContentButtonStrGlobal, style: textStyleGlobal(level: Level.mini, color: saveAndPrintButtonColorGlobal));

      return PopupMenuItem(
          value: 1, child: Row(children: [printIcon, Padding(padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)), child: printText)]));
    }

    PopupMenuItem deletePopupMenuItem() {
      Widget deleteIcon = iconGlobal(iconData: deleteIconGlobal, color: deleteButtonColorGlobal, level: Level.mini);
      Widget deleteText = Text(deleteGlobal, style: textStyleGlobal(level: Level.mini, color: deleteButtonColorGlobal));
      return PopupMenuItem(value: 2, child: Row(children: [deleteIcon, deleteText]));
    }

    return PopupMenuButton(
      tooltip: "",
      onSelected: (value) {
        if (value == 1) {
          if (onPrintFunction != null) {
            onPrintFunction();
          }
        } else if (value == 2) {
          if (onDeleteFunction != null) {
            onDeleteFunction();
          }
        }
      },
      itemBuilder: (ctx) => (onDeleteFunction == null) ? [printPopupMenuItem()] : [printPopupMenuItem(), deletePopupMenuItem()],
    );
  }

  return (isHovering && !isDelete)
      ? Padding(
          padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [printWidget(), deleteWidget()]))
      : !isDelete
          ? (onPrintFunction == null)
              ? Container()
              : popupMenuButtonWidget()
          : Container();
}
