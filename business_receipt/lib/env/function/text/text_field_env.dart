import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/text_limit.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:flutter/material.dart';

enum TextFieldDataType { str, double, int }

Widget textFieldGlobal({
  String? suffixText,
  FocusNode? focusNode,
  bool isEnabled = true,
  required TextFieldDataType textFieldDataType,
  required TextEditingController controller,
  required Function onTapFromOutsiderFunction,
  required Function onChangeFromOutsiderFunction,
  required String labelText,
  required Level level,
  double? textFieldWidth,
  Color? textFieldColor,
  bool obscureText = false,
  bool isUsernameOrPassword = false,
}) {
  Widget setSize() {
    Widget textField() {
      InputDecoration inputDecoration() {
        return InputDecoration(
          labelStyle: TextStyle(color: textFieldColor),
          hintStyle: TextStyle(color: textFieldColor),
          enabledBorder: (textFieldColor == null) ? null : OutlineInputBorder(borderSide: BorderSide(color: textFieldColor)),
          focusedBorder: (textFieldColor == null) ? null : OutlineInputBorder(borderSide: BorderSide(color: textFieldColor)),
          border: const OutlineInputBorder(),
          suffixText: suffixText,
          suffixStyle: textStyleGlobal(level: level, fontWeight: FontWeight.bold, color: (textFieldColor == null) ? defaultTextColorGlobal : textFieldColor),
          labelText: labelText,
          hintText: labelText,
          isDense: true,
          contentPadding: const EdgeInsets.all(textFieldPaddingOnLeftGlobal),
        );
      }

      void onChange() {
        void configMaxTextLength() {
          String limitTheTextString = configMaxTextLengthGlobal(valueStr: controller.text, maxTextLength: nameTextLengthGlobal);
          controller.value = copyValueAndMoveToLastGlobal(controller: controller, value: limitTheTextString);
        }

        void configMaxTextNumberLength() {
          final bool isNotEmpty = controller.text.isNotEmpty;
          if (isNotEmpty) {
            final String formatTextNumberString = formatAndLimitNumberTextGlobal(valueStr: controller.text, isRound: false, isAllowMinus: false, isAllowZeroAtLast: true);
            controller.value = copyValueAndMoveToLastGlobal(controller: controller, value: formatTextNumberString);
          }
        }

        void configMaxTextNumberWithPlace0Length() {
          final bool isNotEmpty = controller.text.isNotEmpty;
          if (isNotEmpty) {
            final String formatTextNumberWithPlace0String = formatAndLimitNumberTextGlobal(valueStr: controller.text, isRound: false, places: 0, isAllowZeroAtLast: false, isAllowMinus: false);
            final String removeDotStr = formatTextNumberWithPlace0String.replaceAll(dotNumberStrGlobal, emptyStrGlobal);
            controller.value = copyValueAndMoveToLastGlobal(controller: controller, value: removeDotStr);
          }
        }

        switch (textFieldDataType) {
          case TextFieldDataType.str:
            configMaxTextLength();
            break;
          case TextFieldDataType.double:
            configMaxTextNumberLength();
            break;
          case TextFieldDataType.int:
            configMaxTextNumberWithPlace0Length();
            break;
        }
        configMaxTextLength();
        onChangeFromOutsiderFunction();
      }

      return TextField(
        autofillHints: isUsernameOrPassword ? [obscureText ? AutofillHints.password : AutofillHints.username] : null,
        obscureText: obscureText,
        focusNode: focusNode,
        enabled: isEnabled,
        controller: controller,
        onTap: () {
          onTapFromOutsiderFunction();
        },
        style: textStyleGlobal(level: level, color: (textFieldColor == null) ? defaultTextColorGlobal : textFieldColor),
        decoration: inputDecoration(),
        onChanged: (_) {
          onChange();
        },
      );
    }

    return SizedBox(width: textFieldWidth, child: textField());
  }

  return setSize();
}
