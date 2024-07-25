import 'package:business_receipt/env/value_env/icon_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_or_admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/business_option_model.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/add_card_stock_employee_side_menu.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/exchange_employee_side_menu.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/give_card_to_mat_employee_side_menu.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/give_money_to_mat_employee_side_menu.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/history_employee_side_menu.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/import_from_excel_employee_side_menu.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/mission_employee_side_menu.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/other_in_or_out_come_employee_side_menu.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/outsider_borrowing_or_lending_employee_side_menu.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/print_other_note_employee_side_menu.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/sell_card_employee_side_menu.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/transfer_employee_side_menu.dart';
import 'package:business_receipt/state/side_menu/rate_side_menu.dart';

List<BusinessOptionModel> employeeOptionListFunctionGlobal({required Function callback}) {
  List<BusinessOptionModel> employeeOptionListGlobal = [];
  // employeeOptionListGlobal.add(
  //   //TODO: replace this to admin
  //   BusinessOptionModel(
  //     name: createCustomerAdminStrGlobal,
  //     icon: createCustomerAdminIconGlobal,
  //     optionFunction: () => CustomerAdminSideMenu(title: createCustomerAdminStrGlobal),
  //   ),
  // );
  if (profileModelEmployeeGlobal!.displayBusinessOptionModel.exchangeSetting.exchangeOption) {
    employeeOptionListGlobal.add(
      BusinessOptionModel(
        name: exchangeOptionEmployeeStrGlobal,
        icon: exchangeIconGlobal,
        countReceipt: profileModelEmployeeGlobal!.displayBusinessOptionModel.exchangeSetting.exchangeCount,
        optionFunction: () => ExchangeEmployeeSideMenu(title: exchangeOptionEmployeeStrGlobal, callback: callback),
      ),
    );
  }
  if (profileModelEmployeeGlobal!.displayBusinessOptionModel.sellCardSetting.sellCardOption) {
    employeeOptionListGlobal.add(
      BusinessOptionModel(
        name: sellCardOptionEmployeeStrGlobal,
        icon: sellCardIconGlobal,
        countReceipt: profileModelEmployeeGlobal!.displayBusinessOptionModel.sellCardSetting.sellCardCount,
        optionFunction: () => SellCardEmployeeSideMenu(title: sellCardOptionEmployeeStrGlobal, callback: callback),
      ),
    );
  }
  if (profileModelEmployeeGlobal!.displayBusinessOptionModel.transferSetting.transferOption) {
    employeeOptionListGlobal.add(
      BusinessOptionModel(
        name: transferOptionEmployeeStrGlobal,
        icon: transferIconGlobal,
        countReceipt: profileModelEmployeeGlobal!.displayBusinessOptionModel.transferSetting.transferCount,
        optionFunction: () => TransferEmployeeSideMenu(title: transferOptionEmployeeStrGlobal, callback: callback),
      ),
    );
  }
  if (profileModelEmployeeGlobal!.displayBusinessOptionModel.importFromExcelSetting.importFromExcelOption) {
    employeeOptionListGlobal.add(
      BusinessOptionModel(
        name: importFromExcelOptionEmployeeStrGlobal,
        icon: importFromExcelIconGlobal,
        countReceipt: profileModelEmployeeGlobal!.displayBusinessOptionModel.importFromExcelSetting.excelCount,
        optionFunction: () => ImportFromExcelEmployee(title: importFromExcelOptionEmployeeStrGlobal, callback: callback),
      ),
    );
  }
  if (profileModelEmployeeGlobal!.displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingOption) {
    employeeOptionListGlobal.add(
      BusinessOptionModel(
        name: outsiderBorrowingOrLendingOptionEmployeeStrGlobal,
        icon: outsiderBorrowingOrLendingIconGlobal,
        countReceipt: profileModelEmployeeGlobal!.displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingCount,
        optionFunction: () => OutsiderBorrowingEmployeeSideMenu(title: outsiderBorrowingOrLendingOptionEmployeeStrGlobal, callback: callback),
      ),
    );
  }
  if (profileModelEmployeeGlobal!.displayBusinessOptionModel.addCardStockSetting.addCardStockOption) {
    employeeOptionListGlobal.add(
      BusinessOptionModel(
        name: addCardStockOptionEmployeeStrGlobal,
        icon: addCardStockIconGlobal,
        countReceipt: profileModelEmployeeGlobal!.displayBusinessOptionModel.addCardStockSetting.addCardStockCount,
        optionFunction: () => AddCardStockEmployeeSideMenu(title: addCardStockOptionEmployeeStrGlobal, callback: callback),
      ),
    );
  }
  if (profileModelEmployeeGlobal!.displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatOption) {
    employeeOptionListGlobal.add(
      BusinessOptionModel(
        name: giveMoneyToMatOptionEmployeeStrGlobal,
        icon: giveMoneyToMatIconGlobal,
        countReceipt: profileModelEmployeeGlobal!.displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatCount,
        optionFunction: () => GiveMoneyToMatEmployeeSideMenu(title: giveMoneyToMatOptionEmployeeStrGlobal, callback: callback),
      ),
    );
  }
  if (profileModelEmployeeGlobal!.displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatOption) {
    employeeOptionListGlobal.add(
      BusinessOptionModel(
        name: giveCardToMatOptionEmployeeStrGlobal,
        icon: giveCardToMatIconGlobal,
        countReceipt: profileModelEmployeeGlobal!.displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatCount,
        optionFunction: () => GiveCardToMatEmployeeSideMenu(title: giveCardToMatOptionEmployeeStrGlobal, callback: callback),
      ),
    );
  }
  if (profileModelEmployeeGlobal!.displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeOption) {
    employeeOptionListGlobal.add(
      BusinessOptionModel(
        name: otherInOrOutComeOptionEmployeeStrGlobal,
        icon: otherInOrOutComeIconGlobal,
        countReceipt: profileModelEmployeeGlobal!.displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeCount,
        optionFunction: () => OtherInOrOutComeEmployeeSideMenu(title: otherInOrOutComeOptionEmployeeStrGlobal, callback: callback),
      ),
    );
  }
  employeeOptionListGlobal.add(
    BusinessOptionModel(
      name: historyOptionEmployeeStrGlobal,
      icon: historyIconGlobal,
      optionFunction: () => HistoryEmployeeSideMenu(
        isSelectedDateAtInit: false,
        title: historyOptionEmployeeStrGlobal,
        cashModel: cashModelGlobal,
        historyList: historyListGlobal,
        targetDate: DateTime.now(),
        isCurrentDate: true,
        employeeId: profileModelEmployeeGlobal!.id!,
        firstDate: firstDateGlobal,
        amountAndProfitModel: amountAndProfitModelGlobal,
        cardModelList: cardModelListGlobal,
        isNotViewOnly: true,
        isForceShowHistory: true,
        // salaryList: salaryListEmployeeGlobal.first.salaryHistoryList,
        salaryHistoryList: salaryListEmployeeGlobal.first.subSalaryList.first.salaryHistoryList,
        displayBusinessOptionModel: profileModelEmployeeGlobal!.displayBusinessOptionModel,
        isAdminEditing: false,
      ),
    ),
  );
  if (profileModelEmployeeGlobal!.displayBusinessOptionModel.rateSetting.rateOption) {
    employeeOptionListGlobal.add(
      BusinessOptionModel(
        name: rateOptionEmployeeStrGlobal,
        icon: rateIconGlobal,
        optionFunction: () => RateAdminSideMenu(title: rateOptionEmployeeStrGlobal),
      ),
    );
  }
  if (profileModelEmployeeGlobal!.displayBusinessOptionModel.printOtherNoteSetting.printOtherNoteOption) {
    employeeOptionListGlobal.add(
      BusinessOptionModel(
        name: printOtherNoteOptionEmployeeStrGlobal,
        icon: printIconGlobal,
        optionFunction: () => PrintOtherNoteEmployeeSideMenu(title: printOtherNoteOptionEmployeeStrGlobal),
      ),
    );
  }
  if (profileModelEmployeeGlobal!.displayBusinessOptionModel.missionSetting.missionOption) {
    employeeOptionListGlobal.add(
      BusinessOptionModel(
        name: missionOptionEmployeeStrGlobal,
        icon: missionIconGlobal,
        optionFunction: () => MissionSideEmployeeMenu(title: missionOptionEmployeeStrGlobal),
      ),
    );
  }

  return employeeOptionListGlobal;
}
