// To parse this JSON data, do
//
//     final customerInformationCategoryList = customerInformationCategoryListFromJson(jsonString);

import 'package:flutter/material.dart';
import 'dart:convert';

List<CustomerInformationCategory> customerInformationCategoryListFromJson({required dynamic str}) =>
    List<CustomerInformationCategory>.from(json.decode(json.encode(str)).map((x) => CustomerInformationCategory.fromJson(x)));

List<dynamic> customerInformationCategoryListToJson(List<CustomerInformationCategory> data) => List<dynamic>.from(data.map((x) => x.toJson()));

class CustomerInformationCategory {
  TextEditingController title;
  List<TextEditingController> subtitleOptionList;

  CustomerInformationCategory({
    required this.title,
    required this.subtitleOptionList,
  });

  factory CustomerInformationCategory.fromJson(Map<String, dynamic> json) => CustomerInformationCategory(
        title: TextEditingController(text: json["title"]),
        subtitleOptionList: List<TextEditingController>.from(json["subtitle_option_list"].map((x) => TextEditingController(text: x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title.text,
        "subtitle_option_list": List<dynamic>.from(subtitleOptionList.map((x) => x.text)),
      };
}

List<CustomerInformationCategory> cloneCustomerInformationCategoryList({required List<CustomerInformationCategory> customerInformationCategoryList}) {
  List<CustomerInformationCategory> customerInformationCategoryListTemp = [];
  for (int categoryIndex = 0; categoryIndex < customerInformationCategoryList.length; categoryIndex++) {
    List<TextEditingController> subtitleOptionList = [];
    for (int subtitleIndex = 0; subtitleIndex < customerInformationCategoryList[categoryIndex].subtitleOptionList.length; subtitleIndex++) {
      subtitleOptionList.add(TextEditingController(text: customerInformationCategoryList[categoryIndex].subtitleOptionList[subtitleIndex].text));
    }
    customerInformationCategoryListTemp.add(CustomerInformationCategory(
      title: TextEditingController(text: customerInformationCategoryList[categoryIndex].title.text),
      subtitleOptionList: subtitleOptionList,
    ));
  }
  return customerInformationCategoryListTemp;
}
