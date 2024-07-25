import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:flutter/material.dart';

Icon iconGlobal({Color color = buttonIconColorGlobal, required IconData iconData, required Level level}) {
  return Icon(iconData, color: color, size: iconSizeGlobal(level: level));
}
