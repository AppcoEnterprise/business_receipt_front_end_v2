import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/text_limit.dart';
import 'package:flutter/material.dart';

Widget textAreaGlobal({
  bool isEnabled = true,
  required TextEditingController controller,
  required Function onTapFromOutsiderFunction,
  required Function onChangeFromOutsiderFunction,
  required String labelText,
  int maxTextLength = defaultTextAreaLengthGlobal,
  int maxLine = maxLinesTextFormFieldGlobal,
  required Level level,
}) {
  Widget textField() {
    // Widget? onTapFunction() {
    //   final bool isHasOnTapFunction = (onTapFromOutsiderFunction != null);
    //   return isHasOnTapFunction ? onTapFromOutsiderFunction() : null;
    // }

    InputDecoration inputDecoration() {
      return InputDecoration(border: OutlineInputBorder(), labelText: labelText, hintText: labelText, alignLabelWithHint: true);
    }

    return TextFormField(
      enabled: isEnabled,
      minLines: minLinesTextFormFieldGlobal, // any number you need (It works as the rows for the textarea)
      keyboardType: TextInputType.multiline,
      maxLines: maxLine,
      controller: controller,
      onTap: onTapFromOutsiderFunction(),
      style: textStyleGlobal(level: level),
      onChanged: (_) {
        void configMaxTextLength() {
          final String limitTheTextString = configMaxTextLengthGlobal(valueStr: controller.text, maxTextLength: maxTextLength);
          controller.value = copyValueAndMoveToLastGlobal(controller: controller, value: limitTheTextString);
        }

        configMaxTextLength();
        onChangeFromOutsiderFunction();
      },
      decoration: inputDecoration(),
    );
  }

  return textField();
}
