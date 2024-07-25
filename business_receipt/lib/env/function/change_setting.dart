import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';

bool getCheckVisibleDisplayOptionEmployee({
  required String employeeId,
  required DisplayBusinessOptionProfileEmployeeModel displayBusinessOptionModel,
  required String? editSettingType,
  required String? targetEmployeeId,
}) {
  if (editSettingTypeStrGlobal(editSettingTypeEnum: EditSettingTypeEnum.rate) == editSettingType) {
    return displayBusinessOptionModel.rateSetting.rateOption ||
        displayBusinessOptionModel.exchangeSetting.exchangeOption ||
        displayBusinessOptionModel.sellCardSetting.sellCardOption ||
        displayBusinessOptionModel.addCardStockSetting.addCardStockOption;
  } else if (editSettingTypeStrGlobal(editSettingTypeEnum: EditSettingTypeEnum.card) == editSettingType) {
    return displayBusinessOptionModel.sellCardSetting.sellCardOption ||
        displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatOption ||
        displayBusinessOptionModel.addCardStockSetting.addCardStockOption;
  } else if (editSettingTypeStrGlobal(editSettingTypeEnum: EditSettingTypeEnum.currency) == editSettingType) {
    return displayBusinessOptionModel.exchangeSetting.exchangeOption ||
        displayBusinessOptionModel.transferSetting.transferOption ||
        displayBusinessOptionModel.sellCardSetting.sellCardOption ||
        displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingOption ||
        displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatOption ||
        displayBusinessOptionModel.rateSetting.rateOption ||
        displayBusinessOptionModel.addCardStockSetting.addCardStockOption ||
        displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeOption ||
        displayBusinessOptionModel.importFromExcelSetting.importFromExcelOption ||
        displayBusinessOptionModel.missionSetting.missionOption;
  } else if (editSettingTypeStrGlobal(editSettingTypeEnum: EditSettingTypeEnum.transfer) == editSettingType) {
    return displayBusinessOptionModel.transferSetting.transferOption;
  } else if (editSettingTypeStrGlobal(editSettingTypeEnum: EditSettingTypeEnum.importFromExcel) == editSettingType) {
    return displayBusinessOptionModel.importFromExcelSetting.importFromExcelOption;
  } else if (editSettingTypeStrGlobal(editSettingTypeEnum: EditSettingTypeEnum.frenchyAndPrint) == editSettingType) {
    return displayBusinessOptionModel.exchangeSetting.exchangeOption ||
        displayBusinessOptionModel.transferSetting.transferOption ||
        displayBusinessOptionModel.sellCardSetting.sellCardOption ||
        displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingOption ||
        displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatOption ||
        displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatOption ||
        displayBusinessOptionModel.addCardStockSetting.addCardStockOption ||
        displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeOption ||
        displayBusinessOptionModel.printOtherNoteSetting.printOtherNoteOption ||
        displayBusinessOptionModel.importFromExcelSetting.importFromExcelOption;
  } else if (editSettingTypeStrGlobal(editSettingTypeEnum: EditSettingTypeEnum.customer) == editSettingType) {
    return displayBusinessOptionModel.transferSetting.transferOption || displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingOption;
  } else if (editSettingTypeStrGlobal(editSettingTypeEnum: EditSettingTypeEnum.mission) == editSettingType) {
    return displayBusinessOptionModel.missionSetting.missionOption;
  } else if (editSettingTypeStrGlobal(editSettingTypeEnum: EditSettingTypeEnum.employee) == editSettingType && (targetEmployeeId != null)) {
    return (employeeId == targetEmployeeId);
  } else if (editSettingTypeStrGlobal(editSettingTypeEnum: EditSettingTypeEnum.delete) == editSettingType) {
    return true;
  }
  return false;
}
