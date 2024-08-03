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
  final UpAndDownProfitChart profitList = UpAndDownProfitChart(moneyType: "USD", upAndDownProfitList: [
    UpAndDownProfitElement(
      startDate: DateTime.parse('1000-01-01 00:00:00.000'),
      endDate: DateTime.parse('1000-01-01 01:00:00.000'),
      profitMerge: -35,
      exchangeProfitList: [],
      sellCardProfitList: [],
      transferProfitList: [],
      excelProfitList: [],
    ),
    UpAndDownProfitElement(
      startDate: DateTime.parse('1000-01-01 01:00:00.000'),
      endDate: DateTime.parse('1000-01-01 02:00:00.000'),
      profitMerge: -36.13,
      exchangeProfitList: [],
      sellCardProfitList: [],
      transferProfitList: [],
      excelProfitList: [],
    ),
    UpAndDownProfitElement(
      startDate: DateTime.parse('1000-01-01 02:00:00.000'),
      endDate: DateTime.parse('1000-01-01 03:00:00.000'),
      profitMerge: -35.1,
      exchangeProfitList: [],
      sellCardProfitList: [],
      transferProfitList: [],
      excelProfitList: [],
    ),
    UpAndDownProfitElement(
      startDate: DateTime.parse('1000-01-01 03:00:00.000'),
      endDate: DateTime.parse('1000-01-01 04:00:00.000'),
      profitMerge: -35.84,
      exchangeProfitList: [],
      sellCardProfitList: [],
      transferProfitList: [],
      excelProfitList: [],
    ),
    UpAndDownProfitElement(
      startDate: DateTime.parse('1000-01-01 04:00:00.000'),
      endDate: DateTime.parse('1000-01-01 05:00:00.000'),
      profitMerge: -35.5,
      exchangeProfitList: [],
      sellCardProfitList: [],
      transferProfitList: [],
      excelProfitList: [],
    ),
    UpAndDownProfitElement(
      startDate: DateTime.parse('1000-01-01 05:00:00.000'),
      endDate: DateTime.parse('1000-01-01 06:00:00.000'),
      profitMerge: -34.75,
      exchangeProfitList: [],
      sellCardProfitList: [],
      transferProfitList: [],
      excelProfitList: [],
    ),
    UpAndDownProfitElement(
      startDate: DateTime.parse('1000-01-01 06:00:00.000'),
      endDate: DateTime.parse('1000-01-01 07:00:00.000'),
      profitMerge: 155.5,
      exchangeProfitList: [],
      sellCardProfitList: [],
      transferProfitList: [],
      excelProfitList: [],
    ),
    UpAndDownProfitElement(
      startDate: DateTime.parse('1000-01-01 08:00:00.000'),
      endDate: DateTime.parse('1000-01-01 09:00:00.000'),
      profitMerge: 1002.5,
      exchangeProfitList: [],
      sellCardProfitList: [],
      transferProfitList: [],
      excelProfitList: [],
    ),
    UpAndDownProfitElement(
      startDate: DateTime.parse('1000-01-01 09:00:00.000'),
      endDate: DateTime.parse('1000-01-01 10:00:00.000'),
      profitMerge: 200.75,
      exchangeProfitList: [],
      sellCardProfitList: [],
      transferProfitList: [],
      excelProfitList: [],
    ),
  ]);
  @override
  Widget build(BuildContext context) {
    // return Container();
    return Scaffold(body: ChartUpAndDownWall(upAndDown: profitList, dateTypeEnum: DateTypeEnum.day));
  }
}
