import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:flutter/material.dart';

List<String> sortStrListToStrListGlobal({required List<String> strList, bool isAscending = false}) {
  int sortComparison(String a, String b) {
    final double propertyA = double.parse(formatAndLimitNumberTextGlobal(isAddComma: false, isRound: false, valueStr: isAscending ? b : a, isAllowZeroAtLast: false));
    final double propertyB = double.parse(formatAndLimitNumberTextGlobal(isAddComma: false, isRound: false, valueStr: isAscending ? a : b, isAllowZeroAtLast: false));
    if (propertyA < propertyB) {
      return -1;
    } else if (propertyA > propertyB) {
      return 1;
    } else {
      return 0;
    }
  }

  strList.sort(sortComparison);
  return strList;
}

List<String> sortControllerListToStrListGlobal({required List<TextEditingController> controllerList, bool isAscending = false}) {
  List<String> strList = [];
  strList.addAll(List<String>.from(controllerList.map((x) => x.text)));
  return sortStrListToStrListGlobal(strList: strList, isAscending: isAscending);
}
