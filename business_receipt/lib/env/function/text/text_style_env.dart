import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:flutter/material.dart';

TextStyle textStyleGlobal({Color color = defaultTextColorGlobal, FontWeight fontWeight = FontWeight.normal, required Level level}) {
  return TextStyle(color: color, fontSize: textSizeGlobal(level: level), fontWeight: fontWeight);
}