import 'package:flutter/material.dart';

class CalculateByAmount {
  String? moneyType;
  bool isFormat;
  List<CalculateElement> calculateElementList;
  TextEditingController remark;
  CalculateByAmount({this.moneyType, required this.calculateElementList, required this.remark, this.isFormat = true});
}

class CalculateElement {
  String operatorStr;
  String valueStr;
  TextEditingController valueController;
  // int qty;
  CalculateElement({this.valueStr = "0", this.operatorStr = "+", required this.valueController});
}
