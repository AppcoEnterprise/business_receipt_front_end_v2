// To parse this JSON data, do
//
//     final printModel = printModelFromJson(jsonString);

import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

PrintModel printModelFromJson({required dynamic str}) => PrintModel.fromJson(json.decode(json.encode(str)));

class PrintModel {
  String? selectedLanguage;
  ElementPrintModel header;
  ElementPrintModel footer;
  List<ElementPrintModel> communicationList;
  List<PrintCustomizeModel> otherList;

  PrintModel({
    required this.selectedLanguage,
    required this.header,
    required this.footer,
    required this.communicationList,
    required this.otherList,
  });

  factory PrintModel.fromJson(Map<String, dynamic> json) => PrintModel(
        selectedLanguage: json["selected_language"],
        header: (json["header"] == null)
            ? ElementPrintModel(subtitle: TextEditingController(), title: TextEditingController())
            : ElementPrintModel.fromJson(json["header"]),
        footer: (json["footer"] == null)
            ? ElementPrintModel(subtitle: TextEditingController(), title: TextEditingController())
            : ElementPrintModel.fromJson(json["footer"]),
        communicationList: List<ElementPrintModel>.from(json["communication_list"].map((x) => ElementPrintModel.fromJson(x))),
        otherList: List<PrintCustomizeModel>.from(json["other_list"].map((x) => PrintCustomizeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "selected_language": selectedLanguage,
        "header": header.toJson(),
        "footer": footer.toJson(),
        "communication_list": List<dynamic>.from(communicationList.map((x) => x.toJson())),
        "other_list": List<dynamic>.from(otherList.map((x) => x.toJson())),
      };
}

class ElementPrintModel {
  TextEditingController title;
  TextEditingController subtitle;

  ElementPrintModel({required this.title, required this.subtitle});

  factory ElementPrintModel.fromJson(Map<String, dynamic> json) => ElementPrintModel(
        // title: json["title"],
        title: TextEditingController(text: json["title"]),
        subtitle: TextEditingController(text: json["subtitle"]),
        // subtitle: json["subtile"],
      );

  Map<String, dynamic> toJson() => {
        // "title": title,
        // "subtile": subtitle,
        "title": title.text,
        "subtitle": subtitle.text,
      };
}

PrintModel clonePrintModel() {
  final ElementPrintModel header = ElementPrintModel(
    title: TextEditingController(text: printModelGlobal.header.title.text),
    subtitle: TextEditingController(text: printModelGlobal.header.subtitle.text),
  );
  final ElementPrintModel footer = ElementPrintModel(
    title: TextEditingController(text: printModelGlobal.footer.title.text),
    subtitle: TextEditingController(text: printModelGlobal.footer.subtitle.text),
  );
  List<ElementPrintModel> communicationList = [];
  for (int communicationIndex = 0; communicationIndex < printModelGlobal.communicationList.length; communicationIndex++) {
    communicationList.add(ElementPrintModel(
      title: TextEditingController(text: printModelGlobal.communicationList[communicationIndex].title.text),
      subtitle: TextEditingController(text: printModelGlobal.communicationList[communicationIndex].subtitle.text),
    ));
  }
  // List<ElementPrintModel> otherList = [];
  // for (int otherIndex = 0; otherIndex < printModelGlobal.otherList.length; otherIndex++) {
  //   otherList.add(ElementPrintModel(
  //     title: TextEditingController(text: printModelGlobal.otherList[otherIndex].title.text),
  //     subtitle: TextEditingController(text: printModelGlobal.otherList[otherIndex].subtitle.text),
  //   ));
  // }
  return PrintModel(
    selectedLanguage: printModelGlobal.selectedLanguage,
    header: header,
    footer: footer,
    communicationList: communicationList,
    otherList: printModelGlobal.otherList.map((e) => clonePrintCustomizeModel(printCustomizeModel: e)).toList(),
  );
}

class TitlePrintModel {
  String language;
  String value;

  TitlePrintModel({
    required this.language,
    required this.value,
  });
}

PrintCustomizeModel printCustomizeModelFromJson({required dynamic str}) => PrintCustomizeModel.fromJson(json.decode(json.encode(str)));

Map<String, dynamic> printCustomizeModelToJson(PrintCustomizeModel data) => data.toJson();

class PrintCustomizeModel {
  String? id;
  bool isHasHeaderAndFooter;
  bool isSelectedOtherWidth;
  TextEditingController width;
  TextEditingController title;
  List<TextColumnList> textColumnList;

  PrintCustomizeModel({
    this.id,
    required this.isHasHeaderAndFooter,
    this.isSelectedOtherWidth = false,
    required this.title,
    required this.width,
    required this.textColumnList,
  });

  factory PrintCustomizeModel.fromJson(Map<String, dynamic> json) => PrintCustomizeModel(
        id: json["_id"], 
        isHasHeaderAndFooter: json["is_has_header_and_footer"],
        title: TextEditingController(text: json["title"]),
        width: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["width"].toString(), isRound: true, isAllowZeroAtLast: false)),
        textColumnList: List<TextColumnList>.from(json["text_column_list"].map((x) => TextColumnList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "is_has_header_and_footer": isHasHeaderAndFooter,
        "title": title.text,
        "width": textEditingControllerToDouble(controller: width),
        "text_column_list": List<dynamic>.from(textColumnList.map((x) => x.toJson())),
      };
}

class TextColumnList {
  bool isCenterAlign;
  bool isExpandedAlign;
  bool isLeftAlign;
  bool isRightAlign;
  List<TextRowList> textRowList;

  TextColumnList({
    required this.isCenterAlign,
    required this.isExpandedAlign,
    required this.isLeftAlign,
    required this.isRightAlign,
    required this.textRowList,
  });

  factory TextColumnList.fromJson(Map<String, dynamic> json) => TextColumnList(
        isCenterAlign: json["is_center_align"],
        isExpandedAlign: json["is_expanded_align"],
        isLeftAlign: json["is_left_align"],
        isRightAlign: json["is_right_align"],
        textRowList: List<TextRowList>.from(json["text_row_list"].map((x) => TextRowList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "is_center_align": isCenterAlign,
        "is_expanded_align": isExpandedAlign,
        "is_left_align": isLeftAlign,
        "is_right_align": isRightAlign,
        "text_row_list": List<dynamic>.from(textRowList.map((x) => x.toJson())),
      };
}

class TextRowList {
  bool isCenterAlign;
  bool isLeftAlign;
  bool isRightAlign;
  bool isBold;
  bool isText;
  bool isUnderLine;
  TextEditingController textfield;
  TextEditingController text;
  TextEditingController fontSize;
  bool isSelectedOtherFontSize;
  String fillValue;

  TextRowList({
    required this.isText,
    required this.isCenterAlign,
    required this.isLeftAlign,
    required this.isRightAlign,
    required this.isBold,
    required this.isUnderLine,
    required this.textfield,
    required this.fontSize,
    required this.fillValue,
    this.isSelectedOtherFontSize = false,
    required this.text,
  });

  factory TextRowList.fromJson(Map<String, dynamic> json) => TextRowList(
        isText: json["is_text"],
        isCenterAlign: json["is_center_align"],
        isLeftAlign: json["is_left_align"],
        isRightAlign: json["is_right_align"],
        isBold: json["is_bold"],
        isUnderLine: json["is_under_line"],
        text: TextEditingController(text: json["text"]),
        textfield: TextEditingController(text: json["textfield"]),
        fontSize: TextEditingController(text: formatAndLimitNumberTextGlobal(valueStr: json["font_size"].toString(), isRound: true, isAllowZeroAtLast: false)),
        fillValue: json["fill_value"],
      );

  Map<String, dynamic> toJson() => {
        "is_text": isText,
        "is_center_align": isCenterAlign,
        "is_left_align": isLeftAlign,
        "is_right_align": isRightAlign,
        "is_bold": isBold,
        "is_under_line": isUnderLine,
        "font_size": textEditingControllerToDouble(controller: fontSize),
        "fill_value": fillValue,
        "textfield": textfield.text,
        "text": text.text,
      };
}

PrintCustomizeModel clonePrintCustomizeModel({required PrintCustomizeModel printCustomizeModel}) {
  final List<TextColumnList> textColumnList = [];
  for (int columnListIndex = 0; columnListIndex < printCustomizeModel.textColumnList.length; columnListIndex++) {
    final List<TextRowList> textRowList = [];
    for (int rowListIndex = 0; rowListIndex < printCustomizeModel.textColumnList[columnListIndex].textRowList.length; rowListIndex++) {
      textRowList.add(TextRowList(
        isText: printCustomizeModel.textColumnList[columnListIndex].textRowList[rowListIndex].isText,
        isCenterAlign: printCustomizeModel.textColumnList[columnListIndex].textRowList[rowListIndex].isCenterAlign,
        isLeftAlign: printCustomizeModel.textColumnList[columnListIndex].textRowList[rowListIndex].isLeftAlign,
        isRightAlign: printCustomizeModel.textColumnList[columnListIndex].textRowList[rowListIndex].isRightAlign,
        isBold: printCustomizeModel.textColumnList[columnListIndex].textRowList[rowListIndex].isBold,
        isUnderLine: printCustomizeModel.textColumnList[columnListIndex].textRowList[rowListIndex].isUnderLine,
        fontSize: TextEditingController(text: printCustomizeModel.textColumnList[columnListIndex].textRowList[rowListIndex].fontSize.text),
        textfield: TextEditingController(text: printCustomizeModel.textColumnList[columnListIndex].textRowList[rowListIndex].textfield.text),
        fillValue: printCustomizeModel.textColumnList[columnListIndex].textRowList[rowListIndex].fillValue,
        text: TextEditingController(text: printCustomizeModel.textColumnList[columnListIndex].textRowList[rowListIndex].text.text),
      ));
    }
    textColumnList.add(TextColumnList(
      isCenterAlign: printCustomizeModel.textColumnList[columnListIndex].isCenterAlign,
      isExpandedAlign: printCustomizeModel.textColumnList[columnListIndex].isExpandedAlign,
      isLeftAlign: printCustomizeModel.textColumnList[columnListIndex].isLeftAlign,
      isRightAlign: printCustomizeModel.textColumnList[columnListIndex].isRightAlign,
      textRowList: textRowList,
    ));
  }
  return PrintCustomizeModel(
    id: printCustomizeModel.id,
    width: TextEditingController(text: printCustomizeModel.width.text),
    title: TextEditingController(text: printCustomizeModel.title.text),
    textColumnList: textColumnList,
    isHasHeaderAndFooter: printCustomizeModel.isHasHeaderAndFooter,
  );
}
