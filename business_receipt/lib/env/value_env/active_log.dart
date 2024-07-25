import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';

List<String> _activeLogTypeList = [
  "clicked button",
  "typed in textfield",
  "selected dropdown",
  "changed between dropdown and textfield", 
  "selected radio button",
  "selected toggle",
  "selected time",
  "selected date",
  "imported file from excel",
];

enum ActiveLogTypeEnum {
  clickButton,
  typeTextfield,
  selectDropdown,
  changeBetweenDropdownAndTextfield,
  selectRadioButton,
  selectToggle,
  selectTime,
  selectDate,
  importFileFromExcel,
}

String getActiveLogEnumToString({required ActiveLogTypeEnum activeLogTypeEnum}) {
  int indexLevel({required ActiveLogTypeEnum subErrorTypeEnum}) {
    return subErrorTypeEnum.index;
  }

  return _activeLogTypeList[indexLevel(subErrorTypeEnum: activeLogTypeEnum)];
}

ActiveLogTypeEnum getActiveLogStringToEnum({required String activeLogTypeString}) {
  int indexLevel({required String subErrorTypeString}) {
    return _activeLogTypeList.indexOf(subErrorTypeString);
  }

  return ActiveLogTypeEnum.values[indexLevel(subErrorTypeString: activeLogTypeString)];
}
