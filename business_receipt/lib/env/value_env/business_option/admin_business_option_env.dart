import 'package:business_receipt/env/value_env/icon_env.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/business_option_model.dart';
import 'package:business_receipt/state/side_menu/admin_side_menu/card_admin_side_menu.dart';
import 'package:business_receipt/state/side_menu/admin_side_menu/chart_admin_side_menu.dart';
import 'package:business_receipt/state/side_menu/admin_side_menu/customer_adimin_side_menu.dart';
import 'package:business_receipt/state/side_menu/admin_side_menu/employee_admin_side_menu.dart';
import 'package:business_receipt/state/side_menu/admin_side_menu/currency_admin_side_menu.dart';
import 'package:business_receipt/state/side_menu/admin_side_menu/history_admin_side_menu.dart';
import 'package:business_receipt/state/side_menu/admin_side_menu/import_from_excel_admin_side_menu.dart';
import 'package:business_receipt/state/side_menu/admin_side_menu/mission_admin_side_menu.dart';
import 'package:business_receipt/state/side_menu/admin_side_menu/print_admin_side_menu.dart';
import 'package:business_receipt/state/side_menu/admin_side_menu/transfer_admin_side_menu.dart';
import 'package:business_receipt/state/side_menu/rate_side_menu.dart';

List<BusinessOptionModel> adminOptionListGlobal = [
  BusinessOptionModel(name: rateOptionAdminStrGlobal, icon: rateIconGlobal, optionFunction: () => RateAdminSideMenu(title: rateOptionAdminStrGlobal)),
  BusinessOptionModel(name: currencyOptionAdminStrGlobal, icon: currencySettingIconGlobal, optionFunction: () => CurrencyAdminSideMenu(title: currencyOptionAdminStrGlobal)),
  BusinessOptionModel(name: cardOptionAdminStrGlobal, icon: cardSettingIconGlobal, optionFunction: () => CardAdminSideMenu(title: cardOptionAdminStrGlobal)),
  BusinessOptionModel(name: transferOptionAdminStrGlobal, icon: transferSettingIconGlobal, optionFunction: () => TransferAdminSideMenu(title: transferOptionAdminStrGlobal)),
  BusinessOptionModel(name: importFromExcelAdminStrGlobal, icon: importFromExcelIconGlobal, optionFunction: () => ImportFromExcelAdmin(title: importFromExcelAdminStrGlobal)),
  BusinessOptionModel(name: frenchyOptionAdminStrGlobal, icon: printSettingIconGlobal, optionFunction: () => PrintAdminSideMenu(title: frenchyOptionAdminStrGlobal)),
  BusinessOptionModel(name: customerOptionAdminStrGlobal, icon: customerSettingIconGlobal, optionFunction: () => CustomerAdminSideMenu(title: customerOptionAdminStrGlobal)),
  BusinessOptionModel(name: missionOptionAdminStrGlobal, icon: missionIconGlobal, optionFunction: () => MissionAdminSideMenu(title: missionOptionAdminStrGlobal)),
  BusinessOptionModel(name: employeeOptionAdminStrGlobal, icon: employeeSettingIconGlobal, optionFunction: () => EmployeeAdminSideMenu(title: employeeOptionAdminStrGlobal)),
  BusinessOptionModel(name: chartOptionAdminStrGlobal, icon: chartSettingIconGlobal, optionFunction: () => ChartAdminSideMenu(title: chartOptionAdminStrGlobal)),
  BusinessOptionModel(name: historyOptionAdminStrGlobal, icon: historyIconGlobal, optionFunction: () => HistoryAdminSideMenu(title: historyOptionAdminStrGlobal)),
];
