
import 'package:flutter/material.dart';

Widget scrollText({required String textStr, required TextStyle textStyle, double? width, required Alignment alignment}) {
  return Align(alignment: alignment,child: SizedBox(width: width, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(textStr, style: textStyle))));
}