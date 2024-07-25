import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/icon_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/icon_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:flutter/material.dart';

Widget buttonGlobal({
  double? sizeBoxHeight,
  double? sizeBoxWidth,
  IconData? icon,
  String? textStr,
  ValidButtonModel? validModel,
  bool isDisable = false,
  Color colorSideBox = defaultButtonColorGlobal,
  Color colorTextAndIcon = textButtonColorGlobal,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
  double elevation = elevationGlobal,
  required Level level,
  required Function onTapUnlessDisableAndValid,
  int? countReceipt,
  bool isExpandedText = false,
  required BuildContext context,
}) {
  validModel ??= ValidButtonModel(isValid: true);
  Widget inkWellWidget() {
    Widget inkWellWithColorWidget() {
      Function? onTapFunction() {
        if (!isDisable) {
          if (validModel!.isValid) {
            return onTapUnlessDisableAndValid();
          } else {
            errorDetailDialogGlobal(context: context, validModel: validModel);
          }
        }
        return null;
      }

      Widget setWidthHeightSizeBowWidget() {
        Widget cardWithShadowWidget() {
          Widget paddingInsideSizeBox() {
            Widget insideSizeBox() {
              Widget sizeBoxWidget() {
                Widget textOrContainerWidget() {
                  return (textStr == null) ? Container() : Text(textStr, style: textStyleGlobal(level: level, color: colorTextAndIcon));
                }

                Widget paddingIconOrContainerWidget() {
                  Widget paddingOrNotIconWidget() {
                    Widget iconWidget() {
                      final IconData iconOrDefaultIcon = (icon == null) ? defaultIconGlobal : icon;
                      return iconGlobal(iconData: iconOrDefaultIcon, color: colorTextAndIcon, level: level);
                    }

                    return (textStr == null) ? iconWidget() : Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: level)), child: iconWidget());
                  }

                  return (icon == null) ? Container() : paddingOrNotIconWidget();
                }

                Widget spacerReceiptCountWidget() {
                  Widget sizeBoxReceiptCount() {
                    return Container(
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(borderRadiusGlobal)), color: disableButtonColorGlobal),
                      child: Padding(
                        padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                        child: Text(
                          formatAndLimitNumberTextGlobal(valueStr: countReceipt!.toString(), isRound: false),
                          style: textStyleGlobal(level: Level.mini, fontWeight: FontWeight.bold, color: textButtonColorGlobal),
                        ),
                      ),
                    );
                  }

                  return (countReceipt == null) ? Container() : sizeBoxReceiptCount();
                }

                return Row(
                  mainAxisAlignment: mainAxisAlignment,
                  children: [
                    paddingIconOrContainerWidget(),
                    isExpandedText ? Expanded(child: textOrContainerWidget()) : textOrContainerWidget(),
                    spacerReceiptCountWidget(),
                  ],
                );
              }

              return sizeBoxWidget();
            }

            return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: level)), child: insideSizeBox());
          }

          Widget enableButtonWidget() {
            RoundedRectangleBorder nonBorder() {
              return RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusGlobal));
            }

            final Color colorWithValueCondition = validModel!.isValid ? colorSideBox : disableButtonColorGlobal;
            return Card(margin: EdgeInsets.zero, shape: nonBorder(), color: colorWithValueCondition, elevation: elevation, child: paddingInsideSizeBox());
          }

          Widget disableButtonWidget() {
            return paddingInsideSizeBox();
          }

          return isDisable ? disableButtonWidget() : enableButtonWidget();
        }

        return SizedBox(width: sizeBoxWidth, height: sizeBoxHeight, child: cardWithShadowWidget());
      }

      return InkWell(
        focusColor: hoverFocusClickButtonColorGlobal,
        highlightColor: hoverFocusClickButtonColorGlobal,
        hoverColor: hoverFocusClickButtonColorGlobal,
        splashColor: hoverFocusClickButtonColorGlobal,
        onTap: onTapFunction,
        child: setWidthHeightSizeBowWidget(),
      );
    }

    return inkWellWithColorWidget();
  }

  return inkWellWidget();
}
