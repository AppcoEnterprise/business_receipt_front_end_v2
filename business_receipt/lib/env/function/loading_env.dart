import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingWidgetGlobal({required String loadingTitle}) {
  Widget loadingTextColumn() {
    Widget spinKit() {
      return const SpinKitPouringHourGlass(color: spinKitColorGlobal, size: spinKitSizeGlobal);
    }

    Widget paddingText() {
      Widget text() {
        return Text(loadingTitle, style: textStyleGlobal(level: Level.mini));
      }

      return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)), child: text());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [spinKit(), paddingText()],
    );
  }

  return loadingTextColumn();
}
