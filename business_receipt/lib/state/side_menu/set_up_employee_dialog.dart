import 'dart:convert';

import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/request_api/employee_request_api_env.dart';
import 'package:business_receipt/env/function/request_api/salary_request_api_env.dart';
import 'package:business_receipt/env/function/salary.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_area_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/toggle_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/invoice_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:business_receipt/model/employee_model/salary_model.dart';
import 'package:business_receipt/model/money_type_and_value_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/employee_side_menu/history_employee_side_menu.dart';
import 'package:flutter/material.dart';

void setUpEmployeeDialog({
  required bool isCreateNewEmployee,
  required ProfileEmployeeModel? profileEmployeeModel,
  required BuildContext context,
  required Function setState,
  required bool isAdminEditing,
  Function? signOutFunction,
  required List<SalaryMergeByMonthModel> salaryListEmployee,
}) {
  int invoiceIndex = 0;
  limitHistory();
  List<SalaryAdvance> salaryAdvanceDefaultList() {
    return [
      SalaryAdvance(
        earningForInvoice: SalaryCalculationEarningForInvoice(combineMoneyInUsed: [], payAmount: TextEditingController()),
        invoiceType: InvoiceEnum.exchange,
        earningForMoneyInUsed: SalaryCalculationEarningForMoneyInUsed(moneyList: [], payAmount: TextEditingController()),
      ),
      SalaryAdvance(
        earningForInvoice: SalaryCalculationEarningForInvoice(combineMoneyInUsed: [], payAmount: TextEditingController()),
        invoiceType: InvoiceEnum.sellCard,
        earningForMoneyInUsed: SalaryCalculationEarningForMoneyInUsed(moneyList: [], payAmount: TextEditingController()),
      ),
      SalaryAdvance(
        earningForInvoice: SalaryCalculationEarningForInvoice(combineMoneyInUsed: [], payAmount: TextEditingController()),
        invoiceType: InvoiceEnum.transfer,
        earningForMoneyInUsed: SalaryCalculationEarningForMoneyInUsed(moneyList: [], payAmount: TextEditingController()),
      ),
      SalaryAdvance(
        earningForInvoice: SalaryCalculationEarningForInvoice(combineMoneyInUsed: [], payAmount: TextEditingController()),
        invoiceType: InvoiceEnum.importFromExcel,
        earningForMoneyInUsed: SalaryCalculationEarningForMoneyInUsed(moneyList: [], payAmount: TextEditingController()),
      )
    ];
  }

  ProfileEmployeeModel profileModelEmployeeTemp = ProfileEmployeeModel(
    name: TextEditingController(),
    bio: TextEditingController(),
    password: TextEditingController(),
    displayBusinessOptionModel: DisplayBusinessOptionProfileEmployeeModel(),
    salaryCalculationModel: SalaryCalculation(
      earningForHour: TextEditingController(),
      startDate: defaultDate(hour: 7, minute: 30, second: 0),
      endDate: defaultDate(hour: 17, minute: 30, second: 0),
      maxPayAmount: TextEditingController(),
      earningForInvoice: SalaryCalculationEarningForInvoice(payAmount: TextEditingController(), combineMoneyInUsed: []),
      earningForMoneyInUsed: SalaryCalculationEarningForMoneyInUsed(payAmount: TextEditingController(), moneyList: []),
      salaryAdvanceList: salaryAdvanceDefaultList(),
    ),
    salaryList: salaryListEmployee,
  );

  if (!isCreateNewEmployee) {
    profileModelEmployeeTemp = profileEmployeeModelClone(profileEmployeeModel: profileEmployeeModel!);
  }

  if (profileModelEmployeeGlobal == null) {
    editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.employee, employeeId: profileModelEmployeeTemp.id);
  }
  void cancelFunctionOnTap() {
    if (isAdminEditing) {
      void okFunction() {
        adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.employee, employeeId: profileModelEmployeeTemp.id);
        closeDialogGlobal(context: context);
      }

      void cancelFunction() {}
      confirmationDialogGlobal(context: context, okFunction: okFunction, cancelFunction: cancelFunction, titleStr: cancelEditingSettingGlobal, subtitleStr: cancelEditingSettingConfirmGlobal);
    } else {
      closeDialogGlobal(context: context);
    }
  }

  ValidButtonModel validSaveButtonFunction() {
    final bool isNameEmpty = profileModelEmployeeTemp.name.text.isEmpty;
    final bool isPasswordEmpty = profileModelEmployeeTemp.password.text.isEmpty;
    final bool isMaxPayAmountEmpty = profileModelEmployeeTemp.salaryCalculationModel.maxPayAmount.text.isEmpty;
    final bool isEarningForHourEmpty = profileModelEmployeeTemp.salaryCalculationModel.earningForHour.text.isEmpty;
    final bool isMoneyTypeEmpty = profileModelEmployeeTemp.salaryCalculationModel.moneyType == null;
    // final bool isEarningForInvoiceEmpty = profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice.text.isEmpty;
    // final bool isEarningForMoneyInUsedEmpty = profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed.text.isEmpty;
    // final bool isEarningForSecondMoneyTypeNull = (profileModelEmployeeTemp.salaryCalculationModel.moneyType == null);
    // if (isNameEmpty ||
    //     isPasswordEmpty ||
    //     isEarningForSecondEmpty ||
    //     isEarningForSecondMoneyTypeNull ||
    //     isEarningForInvoiceEmpty ||
    //     isEarningForMoneyInUsedEmpty) {
    //   return false;
    // }

    if (isNameEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "employee name is empty.");
    }
    if (isPasswordEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "employee password is empty.");
    }

    if (isMaxPayAmountEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfNumber, error: "max pay amount is empty.");
    }

    if (isEarningForHourEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfNumber, error: "earning for hour is empty.");
    }

    if (isMoneyTypeEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "please select money type.");
    }

    if (profileModelEmployeeTemp.salaryCalculationModel.isSimpleSalary) {
      final bool isEarningForInvoiceEmpty = profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.payAmount.text.isEmpty;
      final bool isEarningForMoneyInUsedEmpty = profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.payAmount.text.isEmpty;
      if (isEarningForInvoiceEmpty) {
        // return false;
        return ValidButtonModel(
          isValid: false,
          errorType: ErrorTypeEnum.valueOfNumber,
          error: "pay amount is empty.",
          errorLocationList: [
            TitleAndSubtitleModel(title: "salary", subtitle: "merge all invoice"),
            TitleAndSubtitleModel(title: "pay amount of earning for invoice", subtitle: ""),
          ],
        );
      }
      if (isEarningForMoneyInUsedEmpty) {
        // return false;
        return ValidButtonModel(
          isValid: false,
          errorType: ErrorTypeEnum.valueOfNumber,
          error: "pay amount is empty.",
          errorLocationList: [
            TitleAndSubtitleModel(title: "salary", subtitle: "merge all invoice"),
            TitleAndSubtitleModel(title: "pay amount of earning for money in used", subtitle: ""),
          ],
        );
      }
      for (int i = 0; i < profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed.length; i++) {
        final bool isEarningForInvoiceEmpty = profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed[i].moneyAmount.text.isEmpty;
        final bool isMoneyTypeNull = profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed[i].moneyType == null;
        if (isEarningForInvoiceEmpty) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfNumber,
            error: "money is empty.",
            errorLocationList: [
              TitleAndSubtitleModel(title: "salary", subtitle: "merge all invoice"),
              TitleAndSubtitleModel(title: "index", subtitle: i.toString()),
              TitleAndSubtitleModel(title: "amount of maximum for invoice", subtitle: ""),
            ],
          );
        }
        if (isMoneyTypeNull) {
          // return false;
          // return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "please select money type in earning for invoice.");
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfString,
            error: "please select money type.",
            errorLocationList: [
              TitleAndSubtitleModel(title: "salary", subtitle: "merge all invoice"),
              TitleAndSubtitleModel(title: "index", subtitle: i.toString()),
              TitleAndSubtitleModel(title: "money type of maximum for invoice", subtitle: ""),
            ],
          );
        }
      }
      for (int i = 0; i < profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.moneyList.length; i++) {
        final bool isEarningForMoneyInUsedEmpty = profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.moneyList[i].moneyAmount.text.isEmpty;
        final bool isMoneyTypeNull = profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.moneyList[i].moneyType == null;
        if (isEarningForMoneyInUsedEmpty) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfNumber,
            error: "money is empty.",
            errorLocationList: [
              TitleAndSubtitleModel(title: "salary", subtitle: "merge all invoice"),
              TitleAndSubtitleModel(title: "index", subtitle: i.toString()),
              TitleAndSubtitleModel(title: "amount of maximum for money in used", subtitle: ""),
            ],
          );
        }
        if (isMoneyTypeNull) {
          // return false;

          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfString,
            error: "please select money type.",
            errorLocationList: [
              TitleAndSubtitleModel(title: "salary", subtitle: "merge all invoice"),
              TitleAndSubtitleModel(title: "index", subtitle: i.toString()),
              TitleAndSubtitleModel(title: "money type of maximum for money in used", subtitle: ""),
            ],
          );
        }
      }
    } else {
      for (int i = 0; i < profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList.length; i++) {
        final SalaryAdvance salaryAdvance = profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList[i];
        final bool isEarningForInvoiceEmpty = salaryAdvance.earningForInvoice.payAmount.text.isEmpty;
        final bool isEarningForMoneyInUsedEmpty = salaryAdvance.earningForMoneyInUsed.payAmount.text.isEmpty;
        if (isEarningForInvoiceEmpty) {
          // return false;
          // return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfNumber, error: "earning for invoice is empty.");
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfNumber,
            error: "pay amount is empty.",
            errorLocationList: [
              TitleAndSubtitleModel(title: "salary", subtitle: invoiceTitleStrGlobal(invoiceEnum: salaryAdvance.invoiceType)),
              TitleAndSubtitleModel(title: "pay amount of earning for invoice", subtitle: ""),
            ],
          );
        }
        if (isEarningForMoneyInUsedEmpty) {
          // return false;
          // return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfNumber, error: "earning for money in used is empty.");
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfNumber,
            error: "pay amount is empty.",
            errorLocationList: [
              TitleAndSubtitleModel(title: "salary", subtitle: invoiceTitleStrGlobal(invoiceEnum: salaryAdvance.invoiceType)),
              TitleAndSubtitleModel(title: "pay amount of earning for money in used", subtitle: ""),
            ],
          );
        }
        for (int j = 0; j < salaryAdvance.earningForInvoice.combineMoneyInUsed.length; j++) {
          final bool isEarningForInvoiceEmpty = salaryAdvance.earningForInvoice.combineMoneyInUsed[j].moneyAmount.text.isEmpty;
          final bool isMoneyTypeNull = salaryAdvance.earningForInvoice.combineMoneyInUsed[j].moneyType == null;
          if (isEarningForInvoiceEmpty) {
            // return false;
            // return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfNumber, error: "earning for invoice is empty.");
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              error: "money is empty.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "salary", subtitle: invoiceTitleStrGlobal(invoiceEnum: salaryAdvance.invoiceType)),
                TitleAndSubtitleModel(title: "index", subtitle: j.toString()),
                TitleAndSubtitleModel(title: "amount of maximum for invoice", subtitle: ""),
              ],
            );
          }
          if (isMoneyTypeNull) {
            // return false;
            // return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "please select money type in earning for invoice.");
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfString,
              error: "please select money type.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "salary", subtitle: invoiceTitleStrGlobal(invoiceEnum: salaryAdvance.invoiceType)),
                TitleAndSubtitleModel(title: "index", subtitle: j.toString()),
                TitleAndSubtitleModel(title: "money type of maximum for invoice", subtitle: ""),
              ],
            );
          }
        }

        for (int j = 0; j < salaryAdvance.earningForMoneyInUsed.moneyList.length; j++) {
          final bool isEarningForMoneyInUsedEmpty = salaryAdvance.earningForMoneyInUsed.moneyList[j].moneyAmount.text.isEmpty;
          final bool isMoneyTypeNull = salaryAdvance.earningForMoneyInUsed.moneyList[j].moneyType == null;
          if (isEarningForMoneyInUsedEmpty) {
            // return false;
            // return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfNumber, error: "earning for money in used is empty.");
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              error: "money is empty.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "salary", subtitle: invoiceTitleStrGlobal(invoiceEnum: salaryAdvance.invoiceType)),
                TitleAndSubtitleModel(title: "index", subtitle: j.toString()),
                TitleAndSubtitleModel(title: "amount of maximum for money in used", subtitle: ""),
              ],
            );
          }
          if (isMoneyTypeNull) {
            // return false;
            // return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "please select money type in earning for money in used.");
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfString,
              error: "please select money type.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "salary", subtitle: invoiceTitleStrGlobal(invoiceEnum: salaryAdvance.invoiceType)),
                TitleAndSubtitleModel(title: "index", subtitle: j.toString()),
                TitleAndSubtitleModel(title: "money type of maximum for money in used", subtitle: ""),
              ],
            );
          }
        }
      }
    }

    // if (isEarningForSecondEmpty) {
    //   // return false;
    //   return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfNumber, error: "earning for second is empty.");
    // }
    // if (isEarningForSecondMoneyTypeNull) {
    //   // return false;
    //   return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "please select money type.");
    // }
    // if (isEarningForInvoiceEmpty) {
    //   // return false;
    //   return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfNumber, error: "earning for invoice is empty.");
    // }
    // if (isEarningForMoneyInUsedEmpty) {
    //   // return false;
    //   return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfNumber, error: "earning for money in used is empty.");
    // }
    if (profileModelEmployeeTemp.salaryCalculationModel.isSimpleSalary) {
      for (int combineIndex = 0; combineIndex < profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed.length; combineIndex++) {
        for (int subCombineIndex = (combineIndex + 1); subCombineIndex < profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed.length; subCombineIndex++) {
          if (profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed[combineIndex].moneyType ==
              profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed[subCombineIndex].moneyType) {
            return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueUnique, error: "money type is not unique.", errorLocationList: [
              TitleAndSubtitleModel(title: "salary", subtitle: "merge all invoice"),
              TitleAndSubtitleModel(title: "index", subtitle: combineIndex.toString()),
              TitleAndSubtitleModel(
                title: "money type of maximum for money in used",
                subtitle: profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed[combineIndex].moneyType!,
              ),
            ]);
          }
        }
      }
      for (int combineIndex = 0; combineIndex < profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.moneyList.length; combineIndex++) {
        for (int subCombineIndex = (combineIndex + 1); subCombineIndex < profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.moneyList.length; subCombineIndex++) {
          if (profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.moneyList[combineIndex].moneyType ==
              profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.moneyList[subCombineIndex].moneyType) {
            return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueUnique, error: "money type is not unique.", errorLocationList: [
              TitleAndSubtitleModel(title: "salary", subtitle: "merge all invoice"),
              TitleAndSubtitleModel(title: "index", subtitle: combineIndex.toString()),
              TitleAndSubtitleModel(
                title: "money type of amount of one unit for money in used",
                subtitle: profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.moneyList[combineIndex].moneyType!,
              ),
            ]);
          }
        }
      }
    } else {
      for (int i = 0; i < profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList.length; i++) {
        final SalaryAdvance salaryAdvance = profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList[i];
        for (int combineIndex = 0; combineIndex < salaryAdvance.earningForInvoice.combineMoneyInUsed.length; combineIndex++) {
          for (int subCombineIndex = (combineIndex + 1); subCombineIndex < salaryAdvance.earningForInvoice.combineMoneyInUsed.length; subCombineIndex++) {
            if (salaryAdvance.earningForInvoice.combineMoneyInUsed[combineIndex].moneyType == salaryAdvance.earningForInvoice.combineMoneyInUsed[subCombineIndex].moneyType) {
              return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueUnique, error: "money type is not unique.", errorLocationList: [
                TitleAndSubtitleModel(title: "salary", subtitle: "merge all invoice"),
                TitleAndSubtitleModel(title: "index", subtitle: combineIndex.toString()),
                TitleAndSubtitleModel(
                  title: "money type of maximum for money in used",
                  subtitle: salaryAdvance.earningForInvoice.combineMoneyInUsed[combineIndex].moneyType!,
                ),
              ]);
            }
          }
        }

        for (int combineIndex = 0; combineIndex < salaryAdvance.earningForMoneyInUsed.moneyList.length; combineIndex++) {
          for (int subCombineIndex = (combineIndex + 1); subCombineIndex < salaryAdvance.earningForMoneyInUsed.moneyList.length; subCombineIndex++) {
            if (salaryAdvance.earningForMoneyInUsed.moneyList[combineIndex].moneyType == salaryAdvance.earningForMoneyInUsed.moneyList[subCombineIndex].moneyType) {
              return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueUnique, error: "money type is not unique.", errorLocationList: [
                TitleAndSubtitleModel(title: "salary", subtitle: "merge all invoice"),
                TitleAndSubtitleModel(title: "index", subtitle: combineIndex.toString()),
                TitleAndSubtitleModel(
                  title: "money type of amount of one unit for money in used",
                  subtitle: salaryAdvance.earningForMoneyInUsed.moneyList[combineIndex].moneyType!,
                ),
              ]);
            }
          }
        }
      }
    }
    if (isCreateNewEmployee) {
      //value are not null so return true
      // return true;
      return ValidButtonModel(isValid: true);
    } else {
      //check same value
      //note: all value never be null
      final String nameTemp = profileModelEmployeeTemp.name.text;
      final String name = profileEmployeeModel!.name.text;
      final bool isNameNotSame = (nameTemp != name);
      if (isNameNotSame) {
        for (int profitIndexInside = 0; profitIndexInside < profileEmployeeModelListAdminGlobal.length; profitIndexInside++) {
          if (profileEmployeeModelListAdminGlobal[profitIndexInside].name.text == profileModelEmployeeTemp.name.text) {
            // return false;
            return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueUnique, error: "employee name is not unique.");
          }
        }

        for (int customerIndexInside = 0; customerIndexInside < customerModelListGlobal.length; customerIndexInside++) {
          if (customerModelListGlobal[customerIndexInside].name.text == profileModelEmployeeTemp.name.text) {
            // return false;
            return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueUnique, error: "employee name is not unique.");
          }
        }
      }
      // final String languageTemp = profileModelEmployeeTemp.language;
      // final String language = profileEmployeeModelListAdminGlobal[employeeIndex].language;
      // final bool isLanguageNotSame = (languageTemp != language);
      // if (isLanguageNotSame) {
      //   return true;
      // }

      final String isPasswordTemp = profileModelEmployeeTemp.password.text;
      final String isPassword = profileEmployeeModel.password.text;
      final bool isPasswordNotSame = (isPasswordTemp != isPassword);
      if (isPasswordNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      // final String earningForSecondTemp = profileModelEmployeeTemp.salaryCalculationModel.earningForSecond.text;
      // final String earningForSecond = profileEmployeeModel.salaryCalculationModel.earningForSecond.text;
      // final bool isEarningForSecondNotSame = (earningForSecondTemp != earningForSecond);
      // if (isEarningForSecondNotSame) {
      //   // return true;
      //   return ValidButtonModel(isValid: true);
      // }

      // final String earningForInvoiceTemp = profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice.text;
      // final String earningForInvoice = profileEmployeeModel.salaryCalculationModel.earningForInvoice.text;
      // final bool isEarningForInvoiceNotSame = (earningForInvoiceTemp != earningForInvoice);
      // if (isEarningForInvoiceNotSame) {
      // return true;
      // return ValidButtonModel(isValid: true);
      // }

      // final String earningForMoneyInUsedTemp = profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed.text;
      // final String earningForMoneyInUsed = profileEmployeeModel.salaryCalculationModel.earningForMoneyInUsed.text;
      // final bool isEarningForMoneyInUsedNotSame = (earningForMoneyInUsedTemp != earningForMoneyInUsed);
      // if (isEarningForMoneyInUsedNotSame) {
      //   // return true;
      //   return ValidButtonModel(isValid: true);
      // }

      final DateTime startDateTemp = profileModelEmployeeTemp.salaryCalculationModel.startDate;
      final DateTime startDate = removeUAndTDate(date: profileEmployeeModel.salaryCalculationModel.startDate);
      final bool isStartDateNotSame = (startDateTemp.compareTo(startDate) != 0);

      final DateTime endDateTemp = profileModelEmployeeTemp.salaryCalculationModel.endDate;
      final DateTime endDate = removeUAndTDate(date: profileEmployeeModel.salaryCalculationModel.endDate);
      final bool isEndDateNotSame = (endDateTemp.compareTo(endDate) != 0);

      final bool isStartDateLessThanEndDate = (startDateTemp.compareTo(endDateTemp) >= 0);

      if (isStartDateLessThanEndDate) {
        // return false;
        return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.compareNumber, error: "start date must be less than end date.");
      }

      if (isEndDateNotSame || isStartDateNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      final String? earningForSecondMoneyTypeTemp = profileModelEmployeeTemp.salaryCalculationModel.moneyType;
      final String? earningForSecondMoneyType = profileEmployeeModel.salaryCalculationModel.moneyType;
      final bool isEarningForSecondMoneyTypeNotSame = (earningForSecondMoneyTypeTemp != earningForSecondMoneyType);
      final bool isEarningForSecondMoneyTypeNotNullTemp = (earningForSecondMoneyTypeTemp != null);
      if (isEarningForSecondMoneyTypeNotSame && isEarningForSecondMoneyTypeNotNullTemp) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      final bool isExchangeOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.exchangeSetting.exchangeOption;
      final bool isExchangeOption = profileEmployeeModel.displayBusinessOptionModel.exchangeSetting.exchangeOption;
      final bool isExchangeNotSame = (isExchangeOptionTemp != isExchangeOption);
      if (isExchangeNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      final bool isTransferOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.transferSetting.transferOption;
      final bool isTransferOption = profileEmployeeModel.displayBusinessOptionModel.transferSetting.transferOption;
      final bool isTransferNotSame = (isTransferOptionTemp != isTransferOption);
      if (isTransferNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      final bool isSellCardOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.sellCardSetting.sellCardOption;
      final bool isSellCardOption = profileEmployeeModel.displayBusinessOptionModel.sellCardSetting.sellCardOption;
      final bool isSellCardNotSame = (isSellCardOptionTemp != isSellCardOption);
      if (isSellCardNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      final bool isOutsiderBorrowingOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingOption;
      final bool isOutsiderBorrowingOptionOption = profileEmployeeModel.displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingOption;
      final bool isOutsiderBorrowingOptionOptionNotSame = (isOutsiderBorrowingOptionTemp != isOutsiderBorrowingOptionOption);
      if (isOutsiderBorrowingOptionOptionNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      final bool isOutsiderLendingOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeOption;
      final bool isOutsiderLendingOption = profileEmployeeModel.displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeOption;
      final bool isOutsiderLendingOptionNotSame = (isOutsiderLendingOptionTemp != isOutsiderLendingOption);
      if (isOutsiderLendingOptionNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      final bool isGiveMoneyToMatOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatOption;
      final bool isGiveMoneyToMatOption = profileEmployeeModel.displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatOption;
      final bool isGiveMoneyToMatOptionNotSame = (isGiveMoneyToMatOptionTemp != isGiveMoneyToMatOption);
      if (isGiveMoneyToMatOptionNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      final bool isGiveCardToMatOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatOption;
      final bool isGiveCardToMatOption = profileEmployeeModel.displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatOption;
      final bool isGiveCardToMatOptionNotSame = (isGiveCardToMatOptionTemp != isGiveCardToMatOption);
      if (isGiveCardToMatOptionNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      final bool isRateOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.rateSetting.rateOption;
      final bool isRateOption = profileEmployeeModel.displayBusinessOptionModel.rateSetting.rateOption;
      final bool isRateNotSame = (isRateOptionTemp != isRateOption);
      if (isRateNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      final bool isAddCardStockOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.addCardStockSetting.addCardStockOption;
      final bool isAddCardStockOption = profileEmployeeModel.displayBusinessOptionModel.addCardStockSetting.addCardStockOption;
      final bool isAddCardStockOptionNotSame = (isAddCardStockOptionTemp != isAddCardStockOption);
      if (isAddCardStockOptionNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      final bool isOtherInOrOutComeOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeOption;
      final bool isOtherInOrOutComeOption = profileEmployeeModel.displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeOption;
      final bool isOtherInOrOutComeOptionNotSame = (isOtherInOrOutComeOptionTemp != isOtherInOrOutComeOption);
      if (isOtherInOrOutComeOptionNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      // final bool isOtherOutcomeOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.otherInOrOutComeOption;
      // final bool isOtherOutcomeOption = profileEmployeeModel.displayBusinessOptionModel.otherInOrOutComeOption;
      // final bool isOtherOutcomeOptionNotSame = (isOtherOutcomeOptionTemp != isOtherOutcomeOption);
      // if (isOtherOutcomeOptionNotSame) {
      //   return true;
      // }

      final bool isPrintOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.printOtherNoteSetting.printOtherNoteOption;
      final bool isPrintOption = profileEmployeeModel.displayBusinessOptionModel.printOtherNoteSetting.printOtherNoteOption;
      final bool isPrintOptionNotSame = (isPrintOptionTemp != isPrintOption);
      if (isPrintOptionNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }
      final bool isImportFromExcelOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.importFromExcelSetting.importFromExcelOption;
      final bool isImportFromExcelOption = profileEmployeeModel.displayBusinessOptionModel.importFromExcelSetting.importFromExcelOption;
      final bool isImportFromExcelNotSame = (isImportFromExcelOptionTemp != isImportFromExcelOption);
      if (isImportFromExcelNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }
      final bool isMissionOptionTemp = profileModelEmployeeTemp.displayBusinessOptionModel.missionSetting.missionOption;
      final bool isMissionOption = profileEmployeeModel.displayBusinessOptionModel.missionSetting.missionOption;
      final bool isMissionOptionNotSame = (isMissionOptionTemp != isMissionOption);
      if (isMissionOptionNotSame) {
        // return true;
        return ValidButtonModel(isValid: true);
      }

      //nothing change so return false
      // return false;

      if (profileModelEmployeeTemp.salaryCalculationModel.isSimpleSalary) {
        final bool isEarningForInvoiceNotSame =
            (profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.payAmount.text != profileEmployeeModel.salaryCalculationModel.earningForInvoice!.payAmount.text);
        final bool isEarningForMoneyInUsedNotSame =
            (profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.payAmount.text != profileEmployeeModel.salaryCalculationModel.earningForMoneyInUsed!.payAmount.text);
        if (isEarningForInvoiceNotSame || isEarningForMoneyInUsedNotSame) {
          return ValidButtonModel(isValid: true);
        }
        if (profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed.length == profileEmployeeModel.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed.length) {
          for (int i = 0; i < profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed.length; i++) {
            final bool isEarningForInvoiceNotSame = (profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed[i].moneyAmount.text !=
                profileEmployeeModel.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed[i].moneyAmount.text);
            final bool isMoneyTypeNotSame = (profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed[i].moneyType !=
                profileEmployeeModel.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed[i].moneyType);
            if (isEarningForInvoiceNotSame || isMoneyTypeNotSame) {
              return ValidButtonModel(isValid: true);
            }
          }
        } else {
          return ValidButtonModel(isValid: true);
        }
        if (profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.moneyList.length == profileEmployeeModel.salaryCalculationModel.earningForMoneyInUsed!.moneyList.length) {
          for (int i = 0; i < profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.moneyList.length; i++) {
            final bool isEarningForMoneyInUsedNotSame = (profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.moneyList[i].moneyAmount.text !=
                profileEmployeeModel.salaryCalculationModel.earningForMoneyInUsed!.moneyList[i].moneyAmount.text);
            final bool isMoneyTypeNotSame = (profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!.moneyList[i].moneyType !=
                profileEmployeeModel.salaryCalculationModel.earningForMoneyInUsed!.moneyList[i].moneyType);
            if (isEarningForMoneyInUsedNotSame || isMoneyTypeNotSame) {
              return ValidButtonModel(isValid: true);
            }
          }
        } else {
          return ValidButtonModel(isValid: true);
        }
      } else {
        if (profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList.length == profileEmployeeModel.salaryCalculationModel.salaryAdvanceList.length) {
          for (int i = 0; i < profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList.length; i++) {
            final SalaryAdvance salaryAdvance = profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList[i];

            final bool isEarningForInvoiceNotSame =
                (salaryAdvance.earningForInvoice.payAmount.text != profileEmployeeModel.salaryCalculationModel.salaryAdvanceList[i].earningForInvoice.payAmount.text);
            final bool isEarningForMoneyInUsedNotSame =
                (salaryAdvance.earningForMoneyInUsed.payAmount.text != profileEmployeeModel.salaryCalculationModel.salaryAdvanceList[i].earningForMoneyInUsed.payAmount.text);
            if (isEarningForInvoiceNotSame || isEarningForMoneyInUsedNotSame) {
              return ValidButtonModel(isValid: true);
            }
            if (salaryAdvance.earningForInvoice.combineMoneyInUsed.length == profileEmployeeModel.salaryCalculationModel.salaryAdvanceList[i].earningForInvoice.combineMoneyInUsed.length) {
              for (int j = 0; j < salaryAdvance.earningForInvoice.combineMoneyInUsed.length; j++) {
                final bool isEarningForInvoiceNotSame = (salaryAdvance.earningForInvoice.combineMoneyInUsed[j].moneyAmount.text !=
                    profileEmployeeModel.salaryCalculationModel.salaryAdvanceList[i].earningForInvoice.combineMoneyInUsed[j].moneyAmount.text);
                final bool isMoneyTypeNotSame = (salaryAdvance.earningForInvoice.combineMoneyInUsed[j].moneyType !=
                    profileEmployeeModel.salaryCalculationModel.salaryAdvanceList[i].earningForInvoice.combineMoneyInUsed[j].moneyType);
                if (isEarningForInvoiceNotSame || isMoneyTypeNotSame) {
                  return ValidButtonModel(isValid: true);
                }
              }
            } else {
              return ValidButtonModel(isValid: true);
            }
            if (salaryAdvance.earningForMoneyInUsed.moneyList.length == profileEmployeeModel.salaryCalculationModel.salaryAdvanceList[i].earningForMoneyInUsed.moneyList.length) {
              for (int j = 0; j < salaryAdvance.earningForMoneyInUsed.moneyList.length; j++) {
                final bool isEarningForMoneyInUsedNotSame = (salaryAdvance.earningForMoneyInUsed.moneyList[j].moneyAmount.text !=
                    profileEmployeeModel.salaryCalculationModel.salaryAdvanceList[i].earningForMoneyInUsed.moneyList[j].moneyAmount.text);
                final bool isMoneyTypeNotSame =
                    (salaryAdvance.earningForMoneyInUsed.moneyList[j].moneyType != profileEmployeeModel.salaryCalculationModel.salaryAdvanceList[i].earningForMoneyInUsed.moneyList[j].moneyType);
                if (isEarningForMoneyInUsedNotSame || isMoneyTypeNotSame) {
                  return ValidButtonModel(isValid: true);
                }
              }
            } else {
              return ValidButtonModel(isValid: true);
            }
          }
        } else {
          return ValidButtonModel(isValid: true);
        }
      }

      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.nothingChange);
    }
  }

  Function? saveFunctionOnTapOrNull() {
    void saveFunction() {
      adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.employee, employeeId: profileModelEmployeeTemp.id);
      updateEmployeeGlobal(callBack: setState, context: context, profileModelEmployee: profileModelEmployeeTemp);
      // print(profileModelEmployeeTemp.toJson());
    }

    return isAdminEditing && (profileModelEmployeeTemp.deletedDate == null) ? saveFunction : null;
  }

  Widget editEmployeeDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
    List<InvoiceOption> historyInvoiceList = [];
    historyInvoiceList.add(InvoiceOption(invoiceType: InvoiceEnum.salary, title: salaryTitleGlobal));
    historyInvoiceList.add(InvoiceOption(
      invoiceType: InvoiceEnum.exchange,
      title: "$exchangeTitleGlobal  (${profileModelEmployeeTemp.displayBusinessOptionModel.exchangeSetting.exchangeOption ? "show" : "hide"})",
    ));
    historyInvoiceList.add(InvoiceOption(
      invoiceType: InvoiceEnum.sellCard,
      title: "$sellCardTitleGlobal  (${profileModelEmployeeTemp.displayBusinessOptionModel.sellCardSetting.sellCardOption ? "show" : "hide"})",
    ));
    historyInvoiceList.add(InvoiceOption(
      invoiceType: InvoiceEnum.transfer,
      title: "$transferTitleGlobal  (${profileModelEmployeeTemp.displayBusinessOptionModel.transferSetting.transferOption ? "show" : "hide"})",
    ));
    historyInvoiceList.add(InvoiceOption(
      invoiceType: InvoiceEnum.borrowOrLend,
      title: "$borrowOrLendTitleGlobal  (${profileModelEmployeeTemp.displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingOption ? "show" : "hide"})",
    ));
    historyInvoiceList.add(InvoiceOption(
      invoiceType: InvoiceEnum.giveMoneyToMat,
      title: "$giveMoneyToMatTitleGlobal  (${profileModelEmployeeTemp.displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatOption ? "show" : "hide"})",
    ));
    historyInvoiceList.add(InvoiceOption(
      invoiceType: InvoiceEnum.giveCardToMat,
      title: "$giveCardToMatTitleGlobal  (${profileModelEmployeeTemp.displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatOption ? "show" : "hide"})",
    ));
    historyInvoiceList.add(InvoiceOption(
      invoiceType: InvoiceEnum.rate,
      title: "$rateTitleGlobal  (${profileModelEmployeeTemp.displayBusinessOptionModel.rateSetting.rateOption ? "show" : "hide"})",
    ));
    historyInvoiceList.add(InvoiceOption(
      invoiceType: InvoiceEnum.cardMainStock,
      title: "$cardMainStockTitleGlobal  (${profileModelEmployeeTemp.displayBusinessOptionModel.addCardStockSetting.addCardStockOption ? "show" : "hide"})",
    ));
    historyInvoiceList.add(InvoiceOption(
      invoiceType: InvoiceEnum.otherInOrOutCome,
      title: "$otherInOrOutComeTitleGlobal  (${profileModelEmployeeTemp.displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeOption ? "show" : "hide"})",
    ));
    historyInvoiceList.add(InvoiceOption(
      invoiceType: InvoiceEnum.importFromExcel,
      title: "$importFromExcelTitleGlobal  (${profileModelEmployeeTemp.displayBusinessOptionModel.importFromExcelSetting.importFromExcelOption ? "show" : "hide"})",
    ));
    historyInvoiceList.add(InvoiceOption(
      invoiceType: InvoiceEnum.mission,
      title: "$missionTitleGlobal  (${profileModelEmployeeTemp.displayBusinessOptionModel.missionSetting.missionOption ? "show" : "hide"})",
    ));
    historyInvoiceList.add(InvoiceOption(
      invoiceType: InvoiceEnum.print,
      title: "$printTitleGlobal  (${profileModelEmployeeTemp.displayBusinessOptionModel.printOtherNoteSetting.printOtherNoteOption ? "show" : "hide"})",
    ));

    Widget employeeSettingWidget() {
      Widget paddingBottomTitleWidget() {
        Widget titleWidget() {
          return Text(employeeInformationStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold));
        }

        return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: titleWidget());
      }

      Widget paddingTopWidget({required Widget widget}) {
        return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: widget);
      }

      Widget employeeNameWidget() {
        Widget employeeNameTextFieldWidget() {
          void onChangeFromOutsiderFunction() {
            setStateFromDialog(() {});
          }

          void onTapFromOutsiderFunction() {}
          return textFieldGlobal(
            isEnabled: isAdminEditing && (profileModelEmployeeTemp.deletedDate == null),
            onTapFromOutsiderFunction: onTapFromOutsiderFunction,
            controller: profileModelEmployeeTemp.name,
            onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
            labelText: employeeNameStrGlobal,
            level: Level.normal,
            textFieldDataType: TextFieldDataType.str,
          );
        }

        // Widget languageListWidget() {
        //   void onTapFunction() {}
        //   void onChangedFunction({required String value, required int index}) {
        //     profileModelEmployeeTemp.language = value;
        //     setStateFromDialog(() {});
        //   }

        //   return customDropdown(
        //     level: Level.normal,
        //     labelStr: moneyTypeStrGlobal,
        //     onTapFunction: onTapFunction,
        //     onChangedFunction: onChangedFunction,
        //     selectedStr: profileModelEmployeeTemp.language,
        //     menuItemStrList: moneyTypeOnlyList(),
        //   );
        // }

        // return Row(children: [Expanded(flex: flexValueGlobal, child: employeeNameTextFieldWidget()), Expanded(flex: flexTypeGlobal, child: languageListWidget())]);

        return employeeNameTextFieldWidget();
      }

      Widget passwordTextFieldWidget() {
        void onChangeFromOutsiderFunction() {
          setStateFromDialog(() {});
        }

        void onTapFromOutsiderFunction() {}
        return textFieldGlobal(
          isEnabled: isAdminEditing && (profileModelEmployeeTemp.deletedDate == null),
          controller: profileModelEmployeeTemp.password,
          onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
          labelText: passwordStrGlobal,
          level: Level.normal,
          textFieldDataType: TextFieldDataType.str,
          onTapFromOutsiderFunction: onTapFromOutsiderFunction,
        );
      }

      Widget bioFieldWidget() {
        void onChangeFromOutsiderFunction() {
          setStateFromDialog(() {});
        }

        void onTapFromOutsiderFunction() {}
        return textAreaGlobal(
          isEnabled: isAdminEditing && (profileModelEmployeeTemp.deletedDate == null),
          controller: profileModelEmployeeTemp.bio,
          onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
          labelText: bioStrGlobal,
          level: Level.normal,
          onTapFromOutsiderFunction: onTapFromOutsiderFunction,
        );
      }

      Widget salaryDetailWidget() {
        Widget insideSizeBoxWidget() {
          return scrollText(textStr: salaryDetailStrGlobal, textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.topLeft);
        }

        void onTapUnlessDisable() {
          if (salaryListEmployee.isNotEmpty) {
            salaryListEmployee.first.subSalaryList = [];
            int selectMonthIndex = 0;
            void callBack() {
              salaryListEmployee.first.skipSalaryList = queryLimitNumberGlobal;
              void cancelFunctionOnTap() {
                if (salaryListEmployee[selectMonthIndex].subSalaryList.length > queryLimitNumberGlobal) {
                  List<SubSalaryModel> subSalaryListTemp = [];
                  for (int index = 0; index < queryLimitNumberGlobal; index++) {
                    subSalaryListTemp.add(salaryListEmployee[selectMonthIndex].subSalaryList[index]);
                  }
                  salaryListEmployee[selectMonthIndex].subSalaryList = subSalaryListTemp;
                }
                salaryListEmployee[selectMonthIndex].outOfDataQuerySalaryList = false;
                salaryListEmployee[selectMonthIndex].skipSalaryList = 0;

                closeDialogGlobal(context: context);
              }

              Widget editEmployeeDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                Widget getTotalSalaryStr({required List<MoneyTypeAndValueModel> totalList, required bool isRow}) {
                  //   if (salaryListEmployee[selectMonthIndex].subSalaryList.isNotEmpty) {
                  // final DateTime now = DateTime.now();
                  // if (removeUAndTDate(date: salaryListEmployee[selectMonthIndex].subSalaryList.first.date!).compareTo(DateTime(now.year, now.month, now.day)) == 0) {
                  //   int matchIndex = -1;
                  //   for (int i = 0; i < totalList.length; i++) {
                  //     if (totalList[i].moneyType == salaryListEmployee[selectMonthIndex].subSalaryList.first.salaryHistoryList.last.salaryCalculation.moneyType!) {
                  //       matchIndex = i;
                  //       break;
                  //     }
                  //   }

                  //   final MoneyTypeAndValueModel moneyTypeAndValueModel = calculateSalaryModel(subSalaryIndex: 0, salaryIndex: 0, salaryListEmployee: salaryListEmployee);
                  //   if (matchIndex != -1) {
                  //     totalList[matchIndex].value += moneyTypeAndValueModel.value;
                  //   } else {
                  //     totalList.add(MoneyTypeAndValueModel(
                  //       moneyType: salaryListEmployee[selectMonthIndex].subSalaryList.first.salaryHistoryList.last.salaryCalculation.moneyType!,
                  //       value: moneyTypeAndValueModel.value,
                  //     ));
                  //   }
                  // }}
                  if (isRow) {
                    Widget totalWidget({required int i}) {
                      final String moneyTypeStr = totalList[i].moneyType;
                      final String subTotalSalaryStr = formatAndLimitNumberTextGlobal(
                        valueStr: totalList[i].value.toString(),
                        isRound: false,
                      );
                      return Text("$subTotalSalaryStr $moneyTypeStr", style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal));
                    }

                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [for (int i = 0; i < totalList.length; i++) totalWidget(i: i)]);
                  } else {
                    String str = "";
                    for (int i = 0; i < totalList.length; i++) {
                      final String moneyTypeStr = totalList[i].moneyType;
                      final String subTotalSalaryStr = formatAndLimitNumberTextGlobal(
                        valueStr: totalList[i].value.toString(),
                        isRound: false,
                      );
                      str = "$str $subTotalSalaryStr $moneyTypeStr ${(i == totalList.length - 1) ? "" : "|"}";
                    }
                    return scrollText(textStr: str, alignment: Alignment.topLeft, textStyle: textStyleGlobal(level: Level.normal, color: positiveColorGlobal));
                  }
                  // return str;
                }

                Widget salaryDetailWidget() {
                  Widget paddingBottomTitleWidget() {
                    Widget titleWidget() {
                      return Text(salaryDetailStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold));
                    }

                    return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: titleWidget());
                  }

                  Widget monthlyWidget() {
                    List<Widget> inWrapWidgetList() {
                      Widget monthWidget({required int monthIndex}) {
                        Widget insideSizeBoxWidget() {
                          // if (salaryListEmployee[monthIndex].subSalaryList.isEmpty) {
                          //   return Container();
                          // } else {
                          // final String moneyTypeStr = salaryListEmployee[monthIndex].subSalaryList.last.salaryHistoryList.last.salaryCalculation.moneyType!;
                          // final String subTotalSalaryStr = formatAndLimitNumberTextGlobal(
                          //   valueStr: salaryListEmployee[monthIndex].totalCalculate.toString(),
                          //   isRound: false,
                          // );
                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(formatDateYMToStr(date: salaryListEmployee[monthIndex].date), style: textStyleGlobal(level: Level.normal)),
                            getTotalSalaryStr(totalList: salaryListEmployee[monthIndex].totalList, isRow: false),
                          ]);
                          // }
                        }

                        return CustomButtonGlobal(
                          isDisable: (monthIndex == selectMonthIndex),
                          insideSizeBoxWidget: insideSizeBoxWidget(),
                          onTapUnlessDisable: () {
                            selectMonthIndex = monthIndex;
                            setStateFromDialog(() {});
                          },
                        );
                        // return Container();
                      }

                      return [for (int monthIndex = 0; monthIndex < salaryListEmployee.length; monthIndex++) monthWidget(monthIndex: monthIndex)];
                    }

                    void topFunction() {}
                    void bottomFunction() {}
                    return wrapScrollDetectWidget(
                      inWrapWidgetList: inWrapWidgetList(),
                      topFunction: topFunction,
                      bottomFunction: bottomFunction,
                      isShowSeeMoreWidget: false,
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      paddingBottomTitleWidget(),
                      Expanded(child: monthlyWidget()),
                    ]),
                  );
                }

                Widget subSalaryDetailWidget() {
                  void topFunction() {}
                  void bottomFunction() {
                    if (!salaryListEmployee[selectMonthIndex].outOfDataQuerySalaryList) {
                      final int beforeQuery = salaryListEmployee.length;
                      void subCallBack() {
                        final int afterQuery = salaryListEmployee.length;

                        if (beforeQuery == afterQuery) {
                          salaryListEmployee[selectMonthIndex].outOfDataQuerySalaryList = true;
                        } else {
                          salaryListEmployee[selectMonthIndex].skipSalaryList = salaryListEmployee[selectMonthIndex].skipSalaryList + queryLimitNumberGlobal;
                        }
                        setStateFromDialog(() {});
                      }

                      getSalaryListEmployeeGlobal(
                        targetDate: salaryListEmployee[selectMonthIndex].date,
                        callBack: subCallBack,
                        context: context,
                        skip: salaryListEmployee[selectMonthIndex].skipSalaryList,
                        salaryListEmployee: salaryListEmployee[selectMonthIndex].subSalaryList,
                        employeeId: profileModelEmployeeTemp.id!,
                      );
                    }
                  }

                  Widget salaryWidget() {
                    // final String moneyTypeStr = salaryListEmployee[selectMonthIndex].subSalaryList.last.salaryHistoryList.last.salaryCalculation.moneyType!;
                    final String dateStr = formatDateYMToStr(date: salaryListEmployee[selectMonthIndex].date);
                    // final String subTotalSalaryStr = formatAndLimitNumberTextGlobal(
                    //   valueStr: salaryListEmployee[selectMonthIndex].totalCalculate.toString(),
                    //   isRound: false,
                    // );
                    return Padding(
                      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)),
                      child: Row(children: [
                        Text("$dateStr (", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
                        getTotalSalaryStr(totalList: salaryListEmployee[selectMonthIndex].totalList, isRow: true),
                        Text(")", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
                      ]),
                    );
                  }

                  List<Widget> inWrapWidgetList() {
                    Widget employeeButtonWidget({required int subSalaryIndex}) {
                      Widget setWidthSizeBox() {
                        Widget insideSizeBoxWidget() {
                          return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  salaryListEmployee[selectMonthIndex].subSalaryList[subSalaryIndex].dateYMDStr,
                                  style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                                ),
                                SalaryLoading(
                                  subSalaryIndex: subSalaryIndex,
                                  level: Level.normal,
                                  salaryIndex: selectMonthIndex,
                                  alignment: Alignment.topCenter,
                                  salaryListEmployee: salaryListEmployee,
                                ),
                              ],
                            ),
                          );
                        }

                        void onTapUnlessDisable() {
                          Widget editEmployeeDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                            // double salaryTotal = 0;
                            Widget salaryInvoiceCountWidget({
                              required SubSalaryModel subSalaryModel,
                              required InvoiceEnum invoiceType,
                            }) {
                              final String moneyType = subSalaryModel.salaryHistoryList.last.salaryCalculation.moneyType!;
                              double countPercentage = 0;
                              late TextEditingController earningController;
                              final bool isSimpleSalary = subSalaryModel.salaryHistoryList.last.salaryCalculation.salaryAdvanceList.isEmpty;
                              if (isSimpleSalary) {
                                earningController = subSalaryModel.salaryHistoryList.last.salaryCalculation.earningForInvoice!.payAmount;
                              } else {
                                for (int advanceIndex = 0; advanceIndex < subSalaryModel.salaryHistoryList.last.salaryCalculation.salaryAdvanceList.length; advanceIndex++) {
                                  if (subSalaryModel.salaryHistoryList.last.salaryCalculation.salaryAdvanceList[advanceIndex].invoiceType == invoiceType) {
                                    earningController = subSalaryModel.salaryHistoryList.last.salaryCalculation.salaryAdvanceList[advanceIndex].earningForInvoice.payAmount;
                                    break;
                                  }
                                }
                              }
                              if (invoiceType == InvoiceEnum.exchange) {
                                countPercentage = subSalaryModel.displayBusinessOptionModel.exchangeSetting.exchangePercentage;
                              } else if (invoiceType == InvoiceEnum.sellCard) {
                                countPercentage = subSalaryModel.displayBusinessOptionModel.sellCardSetting.sellCardPercentage;
                              } else if (invoiceType == InvoiceEnum.transfer) {
                                countPercentage = subSalaryModel.displayBusinessOptionModel.transferSetting.transferPercentage;
                              } else if (invoiceType == InvoiceEnum.importFromExcel) {
                                countPercentage = subSalaryModel.displayBusinessOptionModel.importFromExcelSetting.excelPercentage;
                              }
                              final String countPercentageStr = formatAndLimitNumberTextGlobal(valueStr: countPercentage.toString(), isRound: false);
                              final double earning = textEditingControllerToDouble(controller: earningController)!;
                              final String countPercentageXEarningStr = formatAndLimitNumberTextGlobal(
                                valueStr: (countPercentage * earning).toString(),
                                isRound: false,
                              );
                              Widget insideSizeBoxWidget() {
                                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(children: [
                                        Text(
                                          "${invoiceTitleStrGlobal(invoiceEnum: invoiceType)} (Per Invoice)",
                                          style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                    ),
                                  ]),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(children: [
                                      Text("$earningStrGlobal: ", style: textStyleGlobal(level: Level.normal)),
                                      Text("$countPercentageStr x ${earningController.text} = ", style: textStyleGlobal(level: Level.normal)),
                                      Text(
                                        "$countPercentageXEarningStr $moneyType",
                                        style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal, fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                  ),
                                ]);
                              }

                              void onTapUnlessDisable() {}
                              return Padding(
                                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                                child: CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable),
                              );
                            }

                            Widget salaryMoneyInUsedWidget({
                              required SubSalaryModel subSalaryModel,
                              required InvoiceEnum invoiceType,
                            }) {
                              final String moneyType = subSalaryModel.salaryHistoryList.last.salaryCalculation.moneyType!;
                              late SalaryCalculationEarningForMoneyInUsed earningForMoneyInUsed;

                              final bool isSimpleSalary = subSalaryModel.salaryHistoryList.last.salaryCalculation.salaryAdvanceList.isEmpty;
                              if (isSimpleSalary) {
                                earningForMoneyInUsed = subSalaryModel.salaryHistoryList.last.salaryCalculation.earningForMoneyInUsed!;
                              } else {
                                for (int advanceIndex = 0; advanceIndex < subSalaryModel.salaryHistoryList.last.salaryCalculation.salaryAdvanceList.length; advanceIndex++) {
                                  if (subSalaryModel.salaryHistoryList.last.salaryCalculation.salaryAdvanceList[advanceIndex].invoiceType == invoiceType) {
                                    earningForMoneyInUsed = subSalaryModel.salaryHistoryList.last.salaryCalculation.salaryAdvanceList[advanceIndex].earningForMoneyInUsed;
                                    break;
                                  }
                                }
                              }
                              final double earning = textEditingControllerToDouble(controller: earningForMoneyInUsed.payAmount)!;
                              Widget earnElementWidget({required int earnIndex}) {
                                final double target = textEditingControllerToDouble(
                                  controller: earningForMoneyInUsed.moneyList[earnIndex].moneyAmount,
                                )!;
                                double moneyInUsedNumber = 0;
                                for (int moneyTypeIndex = 0; moneyTypeIndex < subSalaryModel.amountAndProfitModel.length; moneyTypeIndex++) {
                                  if (earningForMoneyInUsed.moneyList[earnIndex].moneyType == subSalaryModel.amountAndProfitModel[moneyTypeIndex].moneyType) {
                                    moneyInUsedNumber = subSalaryModel.amountAndProfitModel[moneyTypeIndex].amountInUsed;
                                  }
                                }
                                final String moneyInUsedStr = formatAndLimitNumberTextGlobal(valueStr: moneyInUsedNumber.toString(), isRound: false);
                                final String moneyInUsedXEarningStr = formatAndLimitNumberTextGlobal(
                                  valueStr: (moneyInUsedNumber * earning / target).toString(),
                                  isRound: false,
                                );
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(children: [
                                    Text("$earningStrGlobal: ", style: textStyleGlobal(level: Level.normal)),
                                    Text(
                                      "$moneyInUsedStr x ${earningForMoneyInUsed.payAmount.text} / ${earningForMoneyInUsed.moneyList[earnIndex].moneyAmount.text} ${earningForMoneyInUsed.moneyList[earnIndex].moneyType} = ",
                                      style: textStyleGlobal(level: Level.normal),
                                    ),
                                    Text(
                                      "$moneyInUsedXEarningStr $moneyType",
                                      style: textStyleGlobal(level: Level.normal, color: positiveColorGlobal, fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                                );
                              }

                              Widget insideSizeBoxWidget() {
                                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(children: [
                                        Text(
                                          "${invoiceTitleStrGlobal(invoiceEnum: invoiceType)} (Money In Used)",
                                          style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                    ),
                                  ]),
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    for (int earnIndex = 0; earnIndex < earningForMoneyInUsed.moneyList.length; earnIndex++) earnElementWidget(earnIndex: earnIndex),
                                  ]),
                                ]);
                              }

                              void onTapUnlessDisable() {}
                              return Padding(
                                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                                child: CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(children: [
                                      Text(
                                        "${salaryListEmployee[selectMonthIndex].subSalaryList[subSalaryIndex].dateYMDStr} (",
                                        style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold),
                                      ),
                                      SalaryLoading(
                                        subSalaryIndex: subSalaryIndex,
                                        level: Level.large,
                                        salaryIndex: selectMonthIndex,
                                        alignment: Alignment.topCenter,
                                        salaryListEmployee: salaryListEmployee,
                                      ),
                                      Text(")", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
                                    ]),
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                                      child: Column(children: [
                                        for (int salaryHistoryIndex = (salaryListEmployee[selectMonthIndex].subSalaryList[subSalaryIndex].salaryHistoryList.length - 1);
                                            salaryHistoryIndex >= 0;
                                            salaryHistoryIndex--)
                                          SalaryElementLoading(
                                            dateIndex: selectMonthIndex,
                                            salaryIndex: subSalaryIndex,
                                            salaryHistoryIndex: salaryHistoryIndex,
                                            salaryListEmployee: salaryListEmployee,
                                          ),
                                        salaryInvoiceCountWidget(
                                          subSalaryModel: salaryListEmployee[selectMonthIndex].subSalaryList[subSalaryIndex],
                                          invoiceType: InvoiceEnum.exchange,
                                        ),
                                        salaryMoneyInUsedWidget(
                                          subSalaryModel: salaryListEmployee[selectMonthIndex].subSalaryList[subSalaryIndex],
                                          invoiceType: InvoiceEnum.exchange,
                                        ),
                                        salaryInvoiceCountWidget(
                                          subSalaryModel: salaryListEmployee[selectMonthIndex].subSalaryList[subSalaryIndex],
                                          invoiceType: InvoiceEnum.sellCard,
                                        ),
                                        salaryMoneyInUsedWidget(
                                          subSalaryModel: salaryListEmployee[selectMonthIndex].subSalaryList[subSalaryIndex],
                                          invoiceType: InvoiceEnum.sellCard,
                                        ),
                                        salaryInvoiceCountWidget(
                                          subSalaryModel: salaryListEmployee[selectMonthIndex].subSalaryList[subSalaryIndex],
                                          invoiceType: InvoiceEnum.transfer,
                                        ),
                                        salaryMoneyInUsedWidget(
                                          subSalaryModel: salaryListEmployee[selectMonthIndex].subSalaryList[subSalaryIndex],
                                          invoiceType: InvoiceEnum.transfer,
                                        ),
                                        salaryInvoiceCountWidget(
                                          subSalaryModel: salaryListEmployee[selectMonthIndex].subSalaryList[subSalaryIndex],
                                          invoiceType: InvoiceEnum.importFromExcel,
                                        ),
                                        salaryMoneyInUsedWidget(
                                          subSalaryModel: salaryListEmployee[selectMonthIndex].subSalaryList[subSalaryIndex],
                                          invoiceType: InvoiceEnum.importFromExcel,
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          void cancelFunctionOnTap() {
                            closeDialogGlobal(context: context);
                          }

                          actionDialogSetStateGlobal(
                            dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.2,
                            dialogWidth: dialogSizeGlobal(level: Level.mini),
                            cancelFunctionOnTap: cancelFunctionOnTap,
                            context: context,
                            contentFunctionReturnWidget: editEmployeeDialog,
                          );
                        }

                        return CustomButtonGlobal(
                          sizeBoxWidth: sizeBoxWidthGlobal,
                          sizeBoxHeight: sizeBoxHeightGlobal,
                          insideSizeBoxWidget: insideSizeBoxWidget(),
                          onTapUnlessDisable: onTapUnlessDisable,
                        );
                      }

                      return setWidthSizeBox();
                    }

                    return [for (int dateIndex = 0; dateIndex < salaryListEmployee[selectMonthIndex].subSalaryList.length; dateIndex++) employeeButtonWidget(subSalaryIndex: dateIndex)];
                  }

                  return Padding(
                    padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.large)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        salaryWidget(),
                        Expanded(
                          child: isCreateNewEmployee
                              ? Container()
                              : wrapScrollDetectWidget(
                                  inWrapWidgetList: inWrapWidgetList(),
                                  topFunction: topFunction,
                                  bottomFunction: bottomFunction,
                                  isShowSeeMoreWidget: !salaryListEmployee[selectMonthIndex].outOfDataQuerySalaryList,
                                ),
                        )
                      ],
                    ),
                  );
                }

                return Row(children: [
                  Expanded(flex: 2, child: salaryDetailWidget()),
                  Expanded(flex: flexValueGlobal, child: subSalaryDetailWidget()),
                ]);
              }

              actionDialogSetStateGlobal(
                dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.05,
                dialogWidth: dialogSizeGlobal(level: Level.large) / 1.2,
                cancelFunctionOnTap: cancelFunctionOnTap,
                context: context,
                contentFunctionReturnWidget: editEmployeeDialog,
              );
            }

            getSalaryListEmployeeGlobal(
              targetDate: salaryListEmployee.first.date,
              skip: 0,
              callBack: callBack,
              context: context,
              salaryListEmployee: salaryListEmployee.first.subSalaryList,
              employeeId: profileModelEmployeeTemp.id!,
            );
          }
        }

        return CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
      }

      Widget employeeInformationWidget() {
        return Padding(
          padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
          child: CustomButtonGlobal(
            insideSizeBoxWidget: Column(children: [
              paddingTopWidget(widget: employeeNameWidget()),
              paddingTopWidget(widget: passwordTextFieldWidget()),
              paddingTopWidget(widget: bioFieldWidget()),
            ]),
            onTapUnlessDisable: () {},
          ),
        );
      }

      return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
        paddingBottomTitleWidget(),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
              child: Column(children: [
                // paddingTopWidget(widget: employeeNameWidget()),
                // paddingTopWidget(widget: passwordTextFieldWidget()),
                // paddingTopWidget(widget: bioFieldWidget()),
                employeeInformationWidget(),
                isCreateNewEmployee ? Container() : paddingTopWidget(widget: salaryDetailWidget()),
              ]),
            ),
          ),
        ),
      ]);
    }

    Widget employeeDetailWidget() {
      Widget historyDropDown() {
        void onTapFunction() {}
        void onChangedFunction({required String value, required int index}) {
          invoiceIndex = index;
          setStateFromDialog(() {});
        }

        return Padding(
          padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.large), bottom: paddingSizeGlobal(level: Level.normal)),
          child: customDropdown(
            level: Level.normal,
            labelStr: historyContentButtonStrGlobal,
            onTapFunction: onTapFunction,
            onChangedFunction: onChangedFunction,
            selectedStr: historyInvoiceList[invoiceIndex].title,
            menuItemStrList: historyInvoiceList.map((e) => e.title).toList(),
          ),
        );
      }

      Widget historyDetailWidget() {
        Widget toggleWidget({required String titleStr, required Function callback, required bool isShow, required bool isEnable}) {
          Widget insideSizeBoxWidget() {
            Widget text() {
              return Text(titleStr, style: textStyleGlobal(level: Level.normal));
            }

            Widget toggle() {
              void doNothing() {
                setStateFromDialog(() {});
              }

              return showAndHideToggleWidgetGlobal(isLeftSelected: isShow, onToggle: isEnable ? callback : doNothing);
            }

            return Row(children: [Expanded(child: text()), toggle()]);
          }

          return CustomButtonGlobal(sizeBoxWidth: dialogSizeGlobal(level: Level.mini), insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: () {});
        }

        Widget salaryOrOptionWidget() {
          if (historyInvoiceList[invoiceIndex].invoiceType == InvoiceEnum.salary) {
            // Widget salaryWidget() {
            List<Widget> inWrapWidgetList() {
              Widget textfieldWidget({required String labelText, required TextEditingController controller, required Level? paddingLevel, Level textfieldLevel = Level.normal}) {
                void onChangeFromOutsiderFunction() {
                  setStateFromDialog(() {});
                }

                void onTapFromOutsiderFunction() {}
                return Padding(
                  padding: EdgeInsets.only(bottom: (paddingLevel == null) ? 0 : paddingSizeGlobal(level: Level.normal)),
                  child: textFieldGlobal(
                    isEnabled: isAdminEditing && (profileModelEmployeeTemp.deletedDate == null),
                    controller: controller,
                    onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                    labelText: labelText,
                    level: textfieldLevel,
                    textFieldDataType: TextFieldDataType.double,
                    onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                  ),
                );
              }

              Widget salaryConfigurationWidget() {
                void onTapUnlessDisable() {}
                Widget insideSizeBoxWidget() {
                  Widget moneyTypeDropDownWidget() {
                    void onTapFunction() {}
                    void onChangedFunction({required String value, required int index}) {
                      profileModelEmployeeTemp.salaryCalculationModel.moneyType = value;
                      profileModelEmployeeTemp.salaryCalculationModel.isSimpleSalary = true;
                      profileModelEmployeeTemp.salaryCalculationModel.maxPayAmount.text = "";
                      profileModelEmployeeTemp.salaryCalculationModel.earningForHour.text = "";

                      profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice = SalaryCalculationEarningForInvoice(
                        payAmount: TextEditingController(),
                        combineMoneyInUsed: [],
                      );
                      profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed = SalaryCalculationEarningForMoneyInUsed(
                        payAmount: TextEditingController(),
                        moneyList: [],
                      );
                      profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList = [];
                      setStateFromDialog(() {});
                    }

                    return Padding(
                      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                      child: (isAdminEditing && (profileModelEmployeeTemp.deletedDate == null))
                          ? customDropdown(
                              level: Level.normal,
                              labelStr: moneyTypeStrGlobal,
                              onTapFunction: onTapFunction,
                              onChangedFunction: onChangedFunction,
                              selectedStr: profileModelEmployeeTemp.salaryCalculationModel.moneyType,
                              menuItemStrList: moneyTypeOnlyList(
                                moneyTypeDefault: profileModelEmployeeTemp.salaryCalculationModel.moneyType,
                                isNotCheckDeleted: false,
                              ),
                            )
                          : textFieldGlobal(
                              isEnabled: isAdminEditing,
                              controller: TextEditingController(text: profileModelEmployeeTemp.salaryCalculationModel.moneyType!),
                              onChangeFromOutsiderFunction: () {},
                              labelText: moneyTypeStrGlobal,
                              level: Level.normal,
                              textFieldDataType: TextFieldDataType.str,
                              onTapFromOutsiderFunction: () {},
                            ),
                    );
                  }

                  Widget dateSelectWidget() {
                    ValidButtonModel validModel() {
                      if (!isAdminEditing) {
                        return ValidButtonModel(isValid: false, error: "employee does not have permission to edit.");
                      }
                      if (profileModelEmployeeTemp.deletedDate != null) {
                        return ValidButtonModel(isValid: false, error: "employee is deleted.");
                      }
                      return ValidButtonModel(isValid: true);
                    }

                    Widget startWidget() {
                      void callback({required DateTime dateTime}) {
                        profileModelEmployeeTemp.salaryCalculationModel.startDate = defaultDate(hour: dateTime.hour, minute: dateTime.minute, second: dateTime.second);
                        setStateFromDialog(() {});
                      }

                      return pickTime(
                        callback: callback,
                        context: context,
                        dateTimeOutsider: profileModelEmployeeTemp.salaryCalculationModel.startDate,
                        level: Level.normal,
                        // validModel: isAdminEditing && (profileModelEmployeeTemp.deletedDate == null),
                        validModel: validModel(),
                      );
                    }

                    Widget endWidget() {
                      void callback({required DateTime dateTime}) {
                        profileModelEmployeeTemp.salaryCalculationModel.endDate = defaultDate(hour: dateTime.hour, minute: dateTime.minute, second: dateTime.second);
                        setStateFromDialog(() {});
                      }

                      return pickTime(
                        callback: callback,
                        context: context,
                        dateTimeOutsider: profileModelEmployeeTemp.salaryCalculationModel.endDate!,
                        level: Level.normal,
                        // enable: isAdminEditing && (profileModelEmployeeTemp.deletedDate == null),
                        validModel: validModel(),
                      );
                    }

                    return Padding(
                      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                      child: Row(children: [Expanded(child: startWidget()), Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini))), Expanded(child: endWidget())]),
                    );
                  }

                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    dateSelectWidget(),
                    moneyTypeDropDownWidget(),
                    textfieldWidget(
                      controller: profileModelEmployeeTemp.salaryCalculationModel.maxPayAmount,
                      labelText: maxPayAmountStrGlobal,
                      paddingLevel: Level.normal,
                    ),
                    textfieldWidget(
                      controller: profileModelEmployeeTemp.salaryCalculationModel.earningForHour,
                      labelText: payingForHourStrGlobal,
                      paddingLevel: Level.normal,
                    ),
                    // simpleOrAdvanceSalaryConfigurationWidget(),
                  ]);
                }

                return CustomButtonGlobal(
                  sizeBoxWidth: dialogSizeGlobal(level: Level.mini),
                  insideSizeBoxWidget: insideSizeBoxWidget(),
                  onTapUnlessDisable: onTapUnlessDisable,
                );
              }

              Widget simpleOrAdvanceWidget() {
                void onTapUnlessDisable() {}
                Widget insideSizeBoxWidget() {
                  Widget toggleSimpleOrAdvanceSalaryWidget() {
                    return simpleOrAdvanceSalaryToggleWidgetGlobal(
                      isLeftSelected: profileModelEmployeeTemp.salaryCalculationModel.isSimpleSalary,
                      onToggle: () {
                        if (isAdminEditing) {
                          profileModelEmployeeTemp.salaryCalculationModel.isSimpleSalary = !profileModelEmployeeTemp.salaryCalculationModel.isSimpleSalary;
                          if (profileModelEmployeeTemp.salaryCalculationModel.isSimpleSalary) {
                            profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice = SalaryCalculationEarningForInvoice(
                              payAmount: TextEditingController(),
                              combineMoneyInUsed: [],
                            );
                            profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed = SalaryCalculationEarningForMoneyInUsed(
                              payAmount: TextEditingController(),
                              moneyList: [],
                            );
                            profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList = [];
                          } else {
                            profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice = null;
                            profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed = null;
                            profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList = salaryAdvanceDefaultList();
                          }
                        }
                        setStateFromDialog(() {});
                      },
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                      child: Row(children: [
                        Text("Set Up ", style: textStyleGlobal(level: Level.normal)),
                        toggleSimpleOrAdvanceSalaryWidget(),
                        Text(" Salary", style: textStyleGlobal(level: Level.normal)),
                      ]),
                    ),
                  );
                }

                return CustomButtonGlobal(
                  sizeBoxWidth: dialogSizeGlobal(level: Level.mini),
                  insideSizeBoxWidget: insideSizeBoxWidget(),
                  onTapUnlessDisable: onTapUnlessDisable,
                );
              }

              Widget simpleOrAdvanceSalaryConfigurationWidget({
                required bool isShowToggle,
                InvoiceEnum? invoiceType,
                required SalaryCalculationEarningForMoneyInUsed earningForMoneyInUsed,
                required SalaryCalculationEarningForInvoice earningForInvoice,
              }) {
                void onTapUnlessDisable() {}
                Widget insideSizeBoxWidget() {
                  Widget earningForInvoiceOrMoneyInUsedWidget({
                    required TextEditingController payAmount,
                    required List<CombineMoneyInUsed> combineMoneyInUsedList,
                    required String titleStr,
                    required String subtitleStr,
                  }) {
                    Widget amountAndMoneyTypeWidget({required int combineIndex}) {
                      Widget insideSizeBoxWidget() {
                        Widget moneyTypeDropDownWidget() {
                          void onTapFunction() {}
                          void onChangedFunction({required String value, required int index}) {
                            combineMoneyInUsedList[combineIndex].moneyType = value;
                            setStateFromDialog(() {});
                          }

                          return isAdminEditing
                              ? customDropdown(
                                  level: Level.mini,
                                  labelStr: moneyTypeStrGlobal,
                                  onTapFunction: onTapFunction,
                                  onChangedFunction: onChangedFunction,
                                  selectedStr: combineMoneyInUsedList[combineIndex].moneyType,
                                  menuItemStrList: moneyTypeOnlyList(
                                    isNotCheckDeleted: false,
                                    moneyTypeDefault: combineMoneyInUsedList[combineIndex].moneyType,
                                  ),
                                )
                              : textFieldGlobal(
                                  isEnabled: isAdminEditing,
                                  controller: TextEditingController(text: combineMoneyInUsedList[combineIndex].moneyType!),
                                  onChangeFromOutsiderFunction: () {},
                                  labelText: moneyTypeStrGlobal,
                                  level: Level.mini,
                                  textFieldDataType: TextFieldDataType.str,
                                  onTapFromOutsiderFunction: () {},
                                );
                        }

                        return Row(children: [
                          Expanded(
                            flex: flexValueGlobal,
                            child: textfieldWidget(
                              controller: combineMoneyInUsedList[combineIndex].moneyAmount,
                              labelText: "$amountStrGlobal of $subtitleStr",
                              paddingLevel: null,
                              textfieldLevel: Level.mini,
                            ),
                          ),
                          Expanded(
                              flex: flexTypeGlobal,
                              child: Padding(
                                padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)),
                                child: moneyTypeDropDownWidget(),
                              ))
                        ]);
                      }

                      void onTapUnlessDisable() {}
                      void onDeleteUnlessDisable() {
                        combineMoneyInUsedList.removeAt(combineIndex);
                        setStateFromDialog(() {});
                      }

                      return CustomButtonGlobal(
                        isDisable: true,
                        onDeleteUnlessDisable: isAdminEditing ? onDeleteUnlessDisable : null,
                        insideSizeBoxWidget: insideSizeBoxWidget(),
                        onTapUnlessDisable: onTapUnlessDisable,
                      );
                    }

                    Widget addButtonWidget() {
                      ValidButtonModel validModel() {
                        if (!isAdminEditing) {
                          return ValidButtonModel(isValid: false, error: "employee does not have permission to edit.");
                        }
                        if (profileModelEmployeeTemp.deletedDate != null) {
                          return ValidButtonModel(isValid: false, error: "employee is deleted.");
                        }

                        for (int combineIndex = 0; combineIndex < combineMoneyInUsedList.length; combineIndex++) {
                          if (combineMoneyInUsedList[combineIndex].moneyAmount.text.isEmpty) {
                            return ValidButtonModel(isValid: false, error: "amount is empty.");
                          }
                          if (combineMoneyInUsedList[combineIndex].moneyType == null) {
                            return ValidButtonModel(isValid: false, error: "money type is not selected.");
                          }
                        }

                        return ValidButtonModel(isValid: true);
                      }

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.mini)),
                        child: addButtonOrContainerWidget(
                          level: Level.mini,
                          validModel: validModel(),
                          currentAddButtonQty: combineMoneyInUsedList.length,
                          maxAddButtonLimit: currencyAddButtonLimitGlobal,
                          context: context,
                          onTapFunction: () {
                            combineMoneyInUsedList.add(CombineMoneyInUsed(moneyAmount: TextEditingController()));
                            setStateFromDialog(() {});
                          },
                        ),
                      );
                    }

                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      textfieldWidget(controller: payAmount, labelText: "$payAmountStrGlobal of $titleStr", paddingLevel: Level.normal),
                      for (int combineIndex = 0; combineIndex < combineMoneyInUsedList.length; combineIndex++) amountAndMoneyTypeWidget(combineIndex: combineIndex),
                      addButtonWidget(),
                    ]);
                  }

                  // if (profileModelEmployeeTemp.salaryCalculationModel.isSimpleSalary) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      (invoiceType == null) ? mergeAllInvoiceStrGlobal : invoiceTitleStrGlobal(invoiceEnum: invoiceType),
                      style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large), top: paddingSizeGlobal(level: Level.normal)),
                      child: earningForInvoiceOrMoneyInUsedWidget(
                        titleStr: earningForInvoiceStrGlobal,
                        subtitleStr: maximumForInvoiceStrGlobal,
                        payAmount: earningForInvoice.payAmount,
                        combineMoneyInUsedList: earningForInvoice.combineMoneyInUsed,
                      ),
                    ),
                    earningForInvoiceOrMoneyInUsedWidget(
                      titleStr: earningForMoneyInUsedStrGlobal,
                      subtitleStr: oneUnitStrGlobal,
                      payAmount: earningForMoneyInUsed.payAmount,
                      combineMoneyInUsedList: earningForMoneyInUsed.moneyList,
                    ),
                  ]);
                }

                return CustomButtonGlobal(
                  sizeBoxWidth: dialogSizeGlobal(level: Level.mini),
                  insideSizeBoxWidget: insideSizeBoxWidget(),
                  onTapUnlessDisable: onTapUnlessDisable,
                );
              }

              List<Widget> advanceSalaryWidgetList() {
                // profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList = ;
                return [
                  for (int advanceIndex = 0; advanceIndex < profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList.length; advanceIndex++)
                    simpleOrAdvanceSalaryConfigurationWidget(
                      isShowToggle: false,
                      invoiceType: profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList[advanceIndex].invoiceType,
                      earningForInvoice: profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList[advanceIndex].earningForInvoice,
                      earningForMoneyInUsed: profileModelEmployeeTemp.salaryCalculationModel.salaryAdvanceList[advanceIndex].earningForMoneyInUsed,
                    ),
                ];
              }

              // return [
              //   salaryConfigurationWidget(),
              //   simpleOrAdvanceWidget(),
              //   profileModelEmployeeTemp.salaryCalculationModel.isSimpleSalary
              //       ? simpleOrAdvanceSalaryConfigurationWidget(
              //           isShowToggle: false,
              //           titleInvoice: mergeAllInvoiceStrGlobal,
              //           earningForInvoice: profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice,
              //           earningForMoneyInUsed: profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed,
              //         )
              //       : advanceSalaryWidgetList(),
              // ];
              List<Widget> widgetList = [salaryConfigurationWidget(), simpleOrAdvanceWidget()];
              if (profileModelEmployeeTemp.salaryCalculationModel.isSimpleSalary) {
                widgetList.add(simpleOrAdvanceSalaryConfigurationWidget(
                  isShowToggle: false,
                  earningForInvoice: profileModelEmployeeTemp.salaryCalculationModel.earningForInvoice!,
                  earningForMoneyInUsed: profileModelEmployeeTemp.salaryCalculationModel.earningForMoneyInUsed!,
                ));
              } else {
                widgetList.addAll(advanceSalaryWidgetList());
              }
              return widgetList;
            }

            void topFunction() {}
            void bottomFunction() {}
            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: false,
            );

            // }ddd

            // return isCreateNewEmployee ? Container() : salaryWidget();
          } else if (historyInvoiceList[invoiceIndex].invoiceType == InvoiceEnum.exchange) {
            List<Widget> inWrapWidgetList() {
              return [
                toggleWidget(
                  isEnable: true,
                  titleStr: exchangeOptionSettingStrGlobal,
                  callback: () {
                    if (isAdminEditing) {
                      profileModelEmployeeTemp.displayBusinessOptionModel.exchangeSetting.exchangeOption = !profileModelEmployeeTemp.displayBusinessOptionModel.exchangeSetting.exchangeOption;
                    }
                    setStateFromDialog(() {});
                  },
                  isShow: profileModelEmployeeTemp.displayBusinessOptionModel.exchangeSetting.exchangeOption,
                )
              ];
            }

            void topFunction() {}
            void bottomFunction() {}
            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: false,
            );
          } else if (historyInvoiceList[invoiceIndex].invoiceType == InvoiceEnum.sellCard) {
            List<Widget> inWrapWidgetList() {
              return [
                toggleWidget(
                  isEnable: true,
                  titleStr: sellCardOptionSettingStrGlobal,
                  callback: () {
                    if (isAdminEditing) {
                      profileModelEmployeeTemp.displayBusinessOptionModel.sellCardSetting.sellCardOption = !profileModelEmployeeTemp.displayBusinessOptionModel.sellCardSetting.sellCardOption;
                    }
                    setStateFromDialog(() {});
                  },
                  isShow: profileModelEmployeeTemp.displayBusinessOptionModel.sellCardSetting.sellCardOption,
                )
              ];
            }

            void topFunction() {}
            void bottomFunction() {}
            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: false,
            );
          } else if (historyInvoiceList[invoiceIndex].invoiceType == InvoiceEnum.borrowOrLend) {
            List<Widget> inWrapWidgetList() {
              return [
                toggleWidget(
                  isEnable: true,
                  titleStr: outsiderBorrowingOrLendingOptionSettingStrGlobal,
                  callback: () {
                    if (isAdminEditing) {
                      profileModelEmployeeTemp.displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingOption =
                          !profileModelEmployeeTemp.displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingOption;
                    }
                    setStateFromDialog(() {});
                  },
                  isShow: profileModelEmployeeTemp.displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingOption,
                )
              ];
            }

            void topFunction() {}
            void bottomFunction() {}
            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: false,
            );
          } else if (historyInvoiceList[invoiceIndex].invoiceType == InvoiceEnum.giveMoneyToMat) {
            List<Widget> inWrapWidgetList() {
              return [
                toggleWidget(
                  isEnable: true,
                  titleStr: giveMoneyToMatOptionSettingStrGlobal,
                  callback: () {
                    if (isAdminEditing) {
                      profileModelEmployeeTemp.displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatOption =
                          !profileModelEmployeeTemp.displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatOption;
                    }
                    setStateFromDialog(() {});
                  },
                  isShow: profileModelEmployeeTemp.displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatOption,
                )
              ];
            }

            void topFunction() {}
            void bottomFunction() {}
            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: false,
            );
          } else if (historyInvoiceList[invoiceIndex].invoiceType == InvoiceEnum.giveCardToMat) {
            List<Widget> inWrapWidgetList() {
              return [
                toggleWidget(
                  isEnable: true,
                  titleStr: giveCardToMatOptionSettingStrGlobal,
                  callback: () {
                    if (isAdminEditing) {
                      profileModelEmployeeTemp.displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatOption =
                          !profileModelEmployeeTemp.displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatOption;
                    }
                    setStateFromDialog(() {});
                  },
                  isShow: profileModelEmployeeTemp.displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatOption,
                )
              ];
            }

            void topFunction() {}
            void bottomFunction() {}
            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: false,
            );
          } else if (historyInvoiceList[invoiceIndex].invoiceType == InvoiceEnum.rate) {
            List<Widget> inWrapWidgetList() {
              return [
                toggleWidget(
                  isEnable: true,
                  titleStr: rateOptionSettingStrGlobal,
                  callback: () {
                    if (isAdminEditing) {
                      profileModelEmployeeTemp.displayBusinessOptionModel.rateSetting.rateOption = !profileModelEmployeeTemp.displayBusinessOptionModel.rateSetting.rateOption;
                    }
                    setStateFromDialog(() {});
                  },
                  isShow: profileModelEmployeeTemp.displayBusinessOptionModel.rateSetting.rateOption,
                )
              ];
            }

            void topFunction() {}
            void bottomFunction() {}
            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: false,
            );
          } else if (historyInvoiceList[invoiceIndex].invoiceType == InvoiceEnum.cardMainStock) {
            List<Widget> inWrapWidgetList() {
              return [
                toggleWidget(
                  isEnable: true,
                  titleStr: addCardStockOptionSettingStrGlobal,
                  callback: () {
                    if (isAdminEditing) {
                      profileModelEmployeeTemp.displayBusinessOptionModel.addCardStockSetting.addCardStockOption =
                          !profileModelEmployeeTemp.displayBusinessOptionModel.addCardStockSetting.addCardStockOption;
                    }
                    setStateFromDialog(() {});
                  },
                  isShow: profileModelEmployeeTemp.displayBusinessOptionModel.addCardStockSetting.addCardStockOption,
                )
              ];
            }

            void topFunction() {}
            void bottomFunction() {}
            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: false,
            );
          } else if (historyInvoiceList[invoiceIndex].invoiceType == InvoiceEnum.otherInOrOutCome) {
            List<Widget> inWrapWidgetList() {
              return [
                toggleWidget(
                  isEnable: true,
                  titleStr: otherIncomeOrOutcomeOptionSettingStrGlobal,
                  callback: () {
                    if (isAdminEditing) {
                      profileModelEmployeeTemp.displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeOption =
                          !profileModelEmployeeTemp.displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeOption;
                    }
                    setStateFromDialog(() {});
                  },
                  isShow: profileModelEmployeeTemp.displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeOption,
                )
              ];
            }

            void topFunction() {}
            void bottomFunction() {}
            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: false,
            );
          } else if (historyInvoiceList[invoiceIndex].invoiceType == InvoiceEnum.importFromExcel) {
            List<Widget> inWrapWidgetList() {
              return [
                toggleWidget(
                  isEnable: true,
                  titleStr: importFromExcelOptionSettingStrGlobal,
                  callback: () {
                    if (isAdminEditing) {
                      profileModelEmployeeTemp.displayBusinessOptionModel.importFromExcelSetting.importFromExcelOption =
                          !profileModelEmployeeTemp.displayBusinessOptionModel.importFromExcelSetting.importFromExcelOption;
                    }
                    setStateFromDialog(() {});
                  },
                  isShow: profileModelEmployeeTemp.displayBusinessOptionModel.importFromExcelSetting.importFromExcelOption,
                )
              ];
            }

            void topFunction() {}
            void bottomFunction() {}
            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: false,
            );
          } else if (historyInvoiceList[invoiceIndex].invoiceType == InvoiceEnum.mission) {
            List<Widget> inWrapWidgetList() {
              return [
                toggleWidget(
                  isEnable: true,
                  titleStr: missionOptionSettingStrGlobal,
                  callback: () {
                    if (isAdminEditing) {
                      profileModelEmployeeTemp.displayBusinessOptionModel.missionSetting.missionOption = !profileModelEmployeeTemp.displayBusinessOptionModel.missionSetting.missionOption;
                    }
                    setStateFromDialog(() {});
                  },
                  isShow: profileModelEmployeeTemp.displayBusinessOptionModel.missionSetting.missionOption,
                )
              ];
            }

            void topFunction() {}
            void bottomFunction() {}
            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: false,
            );
          } else if (historyInvoiceList[invoiceIndex].invoiceType == InvoiceEnum.print) {
            List<Widget> inWrapWidgetList() {
              return [
                toggleWidget(
                  isEnable: true,
                  titleStr: printOtherNoteOptionSettingStrGlobal,
                  callback: () {
                    if (isAdminEditing) {
                      profileModelEmployeeTemp.displayBusinessOptionModel.printOtherNoteSetting.printOtherNoteOption =
                          !profileModelEmployeeTemp.displayBusinessOptionModel.printOtherNoteSetting.printOtherNoteOption;
                    }
                    setStateFromDialog(() {});
                  },
                  isShow: profileModelEmployeeTemp.displayBusinessOptionModel.printOtherNoteSetting.printOtherNoteOption,
                )
              ];
            }

            void topFunction() {}
            void bottomFunction() {}
            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: false,
            );
          } else if (historyInvoiceList[invoiceIndex].invoiceType == InvoiceEnum.transfer) {
            List<Widget> inWrapWidgetList() {
              return [
                toggleWidget(
                  isEnable: true,
                  titleStr: transferOptionSettingStrGlobal,
                  callback: () {
                    if (isAdminEditing) {
                      profileModelEmployeeTemp.displayBusinessOptionModel.transferSetting.transferOption = !profileModelEmployeeTemp.displayBusinessOptionModel.transferSetting.transferOption;
                    }
                    setStateFromDialog(() {});
                  },
                  isShow: profileModelEmployeeTemp.displayBusinessOptionModel.transferSetting.transferOption,
                )
              ];
            }

            void topFunction() {}
            void bottomFunction() {}
            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: false,
            );
          }
          return Text("out of option");
        }

        // return Padding(
        //   padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini)),
        // child:
        return salaryOrOptionWidget();
        // );
      }

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [historyDropDown(), Expanded(child: historyDetailWidget())]);
    }

    return Row(children: [
      Expanded(flex: flexTypeGlobal, child: employeeSettingWidget()),
      Expanded(flex: flexValueGlobal, child: employeeDetailWidget()),

      // Expanded(flex: flexValueGlobal, child: salaryWidget()),
    ]);
  }

  Function? deleteFunctionOrNull() {
    if (isCreateNewEmployee || !isAdminEditing || (profileModelEmployeeTemp.deletedDate != null)) {
      return null;
    } else {
      // void deleteFunctionOnTap() {
      //   //close the rate dialog
      //   closeDialogGlobal(context: context);
      //   deleteEmployeeGlobal(callBack: setState, context: context, employeeId: profileEmployeeModel!.id!); //delete the existing employee in database and local storage
      // }

      // return deleteFunctionOnTap;

      void deleteFunctionOnTap() {
        void okFunction() {
          adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.employee, employeeId: profileModelEmployeeTemp.id);
          // void callback() {
          //   setState(() {});
          // }

          closeDialogGlobal(context: context);
          deleteEmployeeGlobal(callBack: setState, context: context, employeeId: profileEmployeeModel!.id!); //delete the existing employee in database and local storage
        }

        void cancelFunction() {}
        confirmationDialogGlobal(
          context: context,
          okFunction: okFunction,
          cancelFunction: cancelFunction,
          titleStr: "$deleteGlobal ${profileEmployeeModel!.name.text}",
          subtitleStr: deleteConfirmGlobal,
        );
      }

      return deleteFunctionOnTap;
    }
  }

  Function? closeSellingFunctionOnTapOrNull() {
    void closeSellingFunctionOnTap() {
      TextEditingController remarkController = TextEditingController();
      void okFunction() {
        updateSalaryEmployeeGlobal(context: context, remark: remarkController.text, signOutFunction: signOutFunction!);
      }

      void cancelFunction() {}

      confirmationWithTextFieldDialogGlobal(
        subtitleStr: closeSellingConfirmGlobal,
        context: context,
        titleStr: closeSellingAndPrintStrGlobal,
        remarkController: remarkController,
        okFunction: okFunction,
        cancelFunction: cancelFunction,
        init: "",
        // printFunction: printFunction,
      );
    }

    return isAdminEditing ? null : closeSellingFunctionOnTap;
  }

  ValidButtonModel validCloseSellingFunctionOnTap() {
    if (isAdminEditing) {
      // return false;
      return ValidButtonModel(isValid: false);
    } else {
      DateTime nowDate = DateTime.now();

      final DateTime dateFormal = removeUAndTDate(date: nowDate);
      final DateTime startDateTarget = removeUAndTDate(date: profileModelEmployeeGlobal!.salaryCalculationModel.startDate);
      final DateTime endDateTarget = removeUAndTDate(date: profileModelEmployeeGlobal!.salaryCalculationModel.endDate!);
      final DateTime defaultDateFormal = defaultDate(hour: dateFormal.hour, minute: dateFormal.minute, second: dateFormal.second);
      final bool isLargerStartDate = (defaultDateFormal.compareTo(startDateTarget) >= 0);
      final bool isSmallerEndDate = (defaultDateFormal.compareTo(endDateTarget) <= 0);
      if (isLargerStartDate && isSmallerEndDate) {
        // return true;
        return ValidButtonModel(isValid: true);
      }
      // return false;
      return ValidButtonModel(isValid: false, error: "Not in the salary period");
    }
  }

  ValidButtonModel validDeleteFunctionOnTap() {
    // return true;
    return ValidButtonModel(isValid: true);
  }

  Function? restoreFunctionOnTap() {
    if (isCreateNewEmployee || !isAdminEditing || (profileModelEmployeeTemp.deletedDate == null)) {
      return null;
    } else {
      // void restoreFunctionOnTap() {
      //   //close the rate dialog
      //   closeDialogGlobal(context: context);
      //   restoreEmployeeGlobal(callBack: setState, context: context, employeeId: profileEmployeeModel!.id!); //delete the existing employee in database and local storage
      // }

      // return restoreFunctionOnTap;
      void restoreFunction() {
        void okFunction() {
          adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.employee, employeeId: profileModelEmployeeTemp.id);
          // void callback() {
          //   setState(() {});
          // }
          closeDialogGlobal(context: context);

          restoreEmployeeGlobal(callBack: setState, context: context, employeeId: profileEmployeeModel!.id!); //delete the existing employee in database and local storage
        }

        void cancelFunction() {}
        confirmationDialogGlobal(
          context: context,
          okFunction: okFunction,
          cancelFunction: cancelFunction,
          titleStr: "$restoreGlobal ${profileEmployeeModel!.name.text}",
          subtitleStr: restoreConfirmGlobal,
        );
      }

      return restoreFunction;
    }
  }

  actionDialogSetStateGlobal(
    dialogHeight: dialogSizeGlobal(level: Level.mini),
    dialogWidth: dialogSizeGlobal(level: Level.large),
    cancelFunctionOnTap: cancelFunctionOnTap,
    context: context,
    validSaveButtonFunction: () => validSaveButtonFunction(),
    validCloseSellingFunctionOnTap: () => validCloseSellingFunctionOnTap(),
    closeSellingFunctionOnTap: closeSellingFunctionOnTapOrNull(),
    saveFunctionOnTap: saveFunctionOnTapOrNull(),
    contentFunctionReturnWidget: editEmployeeDialog,
    deleteFunctionOnTap: deleteFunctionOrNull(),
    validDeleteFunctionOnTap: () => validDeleteFunctionOnTap(),
    restoreFunctionOnTap: restoreFunctionOnTap(),
  );
}
