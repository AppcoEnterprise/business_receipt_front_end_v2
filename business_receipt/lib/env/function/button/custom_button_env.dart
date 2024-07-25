// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/button/button_env.dart';
import 'package:business_receipt/env/function/icon_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/icon_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:flutter/material.dart';

// customHoverFunction({required bool isHovering}) {}
class CustomButtonGlobal extends StatefulWidget {
  double? sizeBoxHeight;
  double? sizeBoxWidth;
  // bool isValid;
  bool isDisable;
  bool isHasSubOnTap;
  bool isHasBorder;
  double elevation;
  Color colorSideBox;
  Level level;
  Widget insideSizeBoxWidget;
  Function onTapUnlessDisable;
  Function? onDeleteUnlessDisable;
  Function? customHoverFunction;
  bool isPaddingInside;
  CustomButtonGlobal({
    Key? key,
    this.isPaddingInside = true,
    this.sizeBoxHeight,
    this.sizeBoxWidth,
    // this.isValid = true,
    this.isDisable = false,
    this.isHasSubOnTap = false,
    this.isHasBorder = false,
    this.elevation = elevationGlobal,
    this.colorSideBox = defaultConfigButtonColorGlobal,
    this.level = Level.normal,
    this.onDeleteUnlessDisable,
    this.customHoverFunction,
    required this.insideSizeBoxWidget,
    required this.onTapUnlessDisable,
  }) : super(key: key);

  @override
  State<CustomButtonGlobal> createState() => _CustomButtonGlobalState();
}

class _CustomButtonGlobalState extends State<CustomButtonGlobal> {
  bool isHover = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isNotShowDeleteButton = false;
    isNotShowDeleteButton = (widget.onDeleteUnlessDisable == null);
    Widget paddingDeleteWidget() {
      Widget deleteButtonWidget() {
        final bool isFunctionNull = (widget.onDeleteUnlessDisable == null);
        if (isFunctionNull || !isHover) {
          if (isFunctionNull) {
            return Container();
          } else {
            Widget deleteIcon = iconGlobal(iconData: deleteIconGlobal, color: deleteButtonColorGlobal, level: Level.mini);
            Widget deleteText = Text(deleteGlobal, style: textStyleGlobal(level: Level.mini, color: deleteButtonColorGlobal));
            return PopupMenuButton(
              tooltip: "",
              onSelected: (value) {
                widget.onDeleteUnlessDisable!();
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(value: 1, child: Row(children: [deleteIcon, deleteText]))
              ],
            );
          }
        } else {
          return buttonGlobal(
            context: context,
            level: Level.mini,
            onTapUnlessDisableAndValid: widget.onDeleteUnlessDisable!,
            icon: deleteIconGlobal,
            colorSideBox: deleteButtonColorGlobal,
            colorTextAndIcon: widgetButtonColorGlobal,
          );
        }
      }

      return Padding(
        padding:  EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
        child: deleteButtonWidget()
      );
    }

    Widget inkWellWithColorWidget() {
      Function? onTapFunction() {
        if (!widget.isDisable || widget.isHasSubOnTap) {
          return widget.onTapUnlessDisable();
        } else {
          return null;
        }
      }

      void onHoverFunction({required bool isHovering}) {
        final bool isCustomHoverFunctionNotNull = (widget.customHoverFunction != null);
        if (isCustomHoverFunctionNotNull) {
          widget.customHoverFunction!(isHovering: isHovering);
        }
        if (!isNotShowDeleteButton) {
          isHover = isHovering;
          if (mounted) {
            setState(() {});
          }
        }
      }

      Widget customWidgetAndDeleteButtonWidgetProvider() {
        Widget setWidthHeightSizeBowWidget() {
          Widget cardWithShadowWidget() {
            Widget paddingInsideSizeBoxProvider() {
              return widget.isPaddingInside ? Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: widget.level)), child: widget.insideSizeBoxWidget) : widget.insideSizeBoxWidget;
            }

            Widget enableButtonWidget() {
              RoundedRectangleBorder nonBorder() {
                return RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusGlobal));
              }

              RoundedRectangleBorder border() {
                return RoundedRectangleBorder(side: const BorderSide(color: borderSideGlobal), borderRadius: BorderRadius.circular(borderRadiusGlobal));
              }

              return Card(margin: EdgeInsets.zero, shape: widget.isHasBorder ? border() : nonBorder(), color: widget.colorSideBox, elevation: widget.elevation, child: paddingInsideSizeBoxProvider());
            }

            Widget disableButtonWidget() {
              return paddingInsideSizeBoxProvider();
            }

            return widget.isDisable ? disableButtonWidget() : enableButtonWidget();
          }

          return SizedBox(width: widget.sizeBoxWidth, height: widget.sizeBoxHeight, child: cardWithShadowWidget());
        }

        return isNotShowDeleteButton
            ? setWidthHeightSizeBowWidget()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Expanded(child: setWidthHeightSizeBowWidget()), paddingDeleteWidget()],
              );
      }

      return InkWell(
        focusColor: hoverFocusClickButtonColorGlobal,
        highlightColor: hoverFocusClickButtonColorGlobal,
        hoverColor: hoverFocusClickButtonColorGlobal,
        splashColor: hoverFocusClickButtonColorGlobal,
        onHover: (isHover) {
          onHoverFunction(isHovering: isHover);
        },
        onTap: onTapFunction,
        child: customWidgetAndDeleteButtonWidgetProvider(),
      );
    }

    return inkWellWithColorWidget();
  }
}
