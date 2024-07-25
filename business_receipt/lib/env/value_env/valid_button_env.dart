import 'package:business_receipt/model/valid_button_model.dart';

List<ContentAndTitleListModel> _errorTypeList = [
  ContentAndTitleListModel(
    content: "Invalid Textfield Number",
    subContent: TitleAndSubtitleModel(title: "Rule", subtitle: "value must not be empty and must not be 0."),
  ),
  ContentAndTitleListModel(
    content: "Invalid Value Unique",
    subContent: TitleAndSubtitleModel(title: "Rule", subtitle: "Value must unique."),
  ),
  ContentAndTitleListModel(
    content: "Invalid Textfield Letter",
    subContent: TitleAndSubtitleModel(title: "Rule", subtitle: "value must not be empty."),
  ),
  ContentAndTitleListModel(
    content: "Invalid Element Length",
    subContent: TitleAndSubtitleModel(title: "Rule", subtitle: "Element length must be equal 0."),
  ),
  ContentAndTitleListModel(content: "Invalid Compare"),
  ContentAndTitleListModel(
    content: "Do Nothing",
    subContent: TitleAndSubtitleModel(title: "Rule", subtitle: "You must change something"),
  ),
  ContentAndTitleListModel(
    content: "Waiting for acceptation",
    subContent: TitleAndSubtitleModel(title: "Rule", subtitle: "All Employee (online and relate) must accept"),
  ),
  ContentAndTitleListModel(
    content: "Invalid Deleting",
    subContent: TitleAndSubtitleModel(title: "Rule", subtitle: "Model must not deleted"),
  ),
];

enum ErrorTypeEnum {
  valueOfNumber,
  valueUnique,
  valueOfString,
  arrayLength,
  compareNumber,
  nothingChange,
  waitAllEmployeeAccept,
  deleted,
}

ContentAndTitleListModel getContentAndTitleListModel({ErrorTypeEnum? errorTypeEnum}) {
  if (errorTypeEnum != null) {
    int indexLevel({required ErrorTypeEnum subErrorTypeEnum}) {
      return subErrorTypeEnum.index;
    }

    return _errorTypeList[indexLevel(subErrorTypeEnum: errorTypeEnum)];
  } else {
    return ContentAndTitleListModel(content: "Error");
  }
}
