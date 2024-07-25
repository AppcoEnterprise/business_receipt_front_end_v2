import 'package:business_receipt/env/value_env/valid_button_env.dart';

class ValidButtonModel {
  String? test;
  bool isValid;
  ErrorTypeEnum? errorType;
  String? overwriteRule;
  List<TitleAndSubtitleModel> errorLocationList;
  String? error;
  List<TitleAndSubtitleModel> detailList;
  ValidButtonModel({
    // required this.test,
    required this.isValid,
    this.overwriteRule,
    this.errorType,
    this.errorLocationList = const [],
    this.error,
    this.detailList = const [],
  });
}

class ContentAndTitleListModel {
  String content;
  TitleAndSubtitleModel? subContent;
  ContentAndTitleListModel({required this.content, this.subContent});
}

class TitleAndSubtitleModel {
  String title;
  String subtitle;
  TitleAndSubtitleModel({required this.title, required this.subtitle});
}
