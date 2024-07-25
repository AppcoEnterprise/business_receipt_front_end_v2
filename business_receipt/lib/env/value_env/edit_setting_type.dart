const List<String> _editSettingTypeList = [
  "rate",
  "card",
  "currency",
  "transfer",
  "import_from_excel",
  "frenchy_and_print",
  "customer",
  "mission",
  "employee",
  "delete",
];

enum EditSettingTypeEnum { rate, card, currency, transfer, importFromExcel, frenchyAndPrint, customer, mission, employee, delete }

String editSettingTypeStrGlobal({required EditSettingTypeEnum editSettingTypeEnum}) {
  int indexLevel({required EditSettingTypeEnum editSettingTypeEnum}) {
    return editSettingTypeEnum.index;
  }

  return _editSettingTypeList[indexLevel(editSettingTypeEnum: editSettingTypeEnum)];
}
