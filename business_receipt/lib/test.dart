import 'dart:io';
import 'dart:math';

import 'package:business_receipt/env/function/chart/chart.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/draw_line.dart';
import 'package:business_receipt/env/function/drop_zone.dart';
import 'package:business_receipt/env/function/excel.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/date.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/text_limit.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/chart_model.dart';
import 'package:business_receipt/model/employee_model/file_model.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Test extends StatefulWidget {
  Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final UpAndDownChart profitList = UpAndDownChart(moneyType: "USD", upAndDownList: [
    UpAndDownElement(startDate: DateTime.parse('1000-01-01 00:00:00.000'), endDate: DateTime.parse('1000-01-01 01:00:00.000'), value: -35),
    UpAndDownElement(startDate: DateTime.parse('1000-01-01 01:00:00.000'), endDate: DateTime.parse('1000-01-01 02:00:00.000'), value: -36.13),
    UpAndDownElement(startDate: DateTime.parse('1000-01-01 02:00:00.000'), endDate: DateTime.parse('1000-01-01 03:00:00.000'), value: -35.1),
    UpAndDownElement(startDate: DateTime.parse('1000-01-01 03:00:00.000'), endDate: DateTime.parse('1000-01-01 04:00:00.000'), value: -35.84),
    UpAndDownElement(startDate: DateTime.parse('1000-01-01 04:00:00.000'), endDate: DateTime.parse('1000-01-01 05:00:00.000'), value: -35.5),
    UpAndDownElement(startDate: DateTime.parse('1000-01-01 05:00:00.000'), endDate: DateTime.parse('1000-01-01 06:00:00.000'), value: -34.75),
    UpAndDownElement(startDate: DateTime.parse('1000-01-01 06:00:00.000'), endDate: DateTime.parse('1000-01-01 07:00:00.000'), value: 155.5),
    UpAndDownElement(startDate: DateTime.parse('1000-01-01 08:00:00.000'), endDate: DateTime.parse('1000-01-01 09:00:00.000'), value: 1002.5),
    UpAndDownElement(startDate: DateTime.parse('1000-01-01 09:00:00.000'), endDate: DateTime.parse('1000-01-01 10:00:00.000'), value: 200.75),
  ]);
  @override
  Widget build(BuildContext context) {
    // return Container();
    return Scaffold(body: ChartUpAndDown(profitList: profitList, dateTypeEnum: DateTypeEnum.day));
  }
}
