import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/request_api/excel_request_api_env.dart';
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
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/excel_admin_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:flutter/material.dart';

void setUpExcelDialog({
  required bool isCreateNewCustomer,
  required int? excelIndexMain,
  required bool isAdminEditing,
  required BuildContext context,
  required Function setState,
  required Function callback,
}) {
  ExcelAdminModel excelAdminModelTemp = ExcelAdminModel(
    nameList: [TableColumnAndRow(column: TextEditingController(), row: TextEditingController(), dRKeywordList: [], cRKeywordList: [])],
    axis: axisListGlobal.first,
    excelName: TextEditingController(),
    remark: TextEditingController(),
    amount: TableColumnAndRow(column: TextEditingController(), row: TextEditingController(), dRKeywordList: [], cRKeywordList: []),
    moneyType: TableColumnAndRow(column: TextEditingController(), row: TextEditingController(), dRKeywordList: [], cRKeywordList: []),
    profit: TableColumnAndRow(column: TextEditingController(), row: TextEditingController(), dRKeywordList: [], cRKeywordList: []),
    status: TableColumnAndRow(column: TextEditingController(), row: TextEditingController(), dRKeywordList: [], cRKeywordList: []),
    txnID: TableColumnAndRow(column: TextEditingController(), row: TextEditingController(), dRKeywordList: [], cRKeywordList: []),
    printTypeName: TableColumnAndRow(column: TextEditingController(), row: TextEditingController(), dRKeywordList: [], cRKeywordList: []),
    date: TableColumnAndRow(column: TextEditingController(), row: TextEditingController(), dRKeywordList: [], cRKeywordList: []),
    dROrCR: TableColumnAndRow(column: TextEditingController(), row: TextEditingController(), dRKeywordList: [], cRKeywordList: []),
    dateFormat: TextEditingController(),
  );

  if (!isCreateNewCustomer) {
    excelAdminModelTemp = cloneExcelAdmin(excelIndex: excelIndexMain!);
  }
  // if ((excelAdminModelTemp.deletedDate == null)) {
  editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.importFromExcel);
  // }
  void cancelFunctionOnTap() {
    if (isAdminEditing) {
      void okFunction() {
        adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.importFromExcel);
        closeDialogGlobal(context: context);
      }

      void cancelFunction() {}
      confirmationDialogGlobal(context: context, okFunction: okFunction, cancelFunction: cancelFunction, titleStr: cancelEditingSettingGlobal, subtitleStr: cancelEditingSettingConfirmGlobal);
    } else {
      closeDialogGlobal(context: context);
    }
  }

  ValidButtonModel validSaveButtonFunction() {
    final bool isNameEmpty = excelAdminModelTemp.excelName.text.isEmpty;
    if (isNameEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "excel name is empty");
    }
    final bool isDateFormatEmpty = excelAdminModelTemp.dateFormat.text.isEmpty;
    if (isDateFormatEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "date format is empty");
    }
    final bool isAmountColumnEmpty = excelAdminModelTemp.amount.column.text.isEmpty;
    final bool isAmountRowEmpty = excelAdminModelTemp.amount.row.text.isEmpty;
    // if (isAmountColumnEmpty || isAmountRowEmpty) {
    //   // return false;
    // }
    if (isAmountColumnEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "amount column is empty");
    }
    if (isAmountRowEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "amount row is empty");
    }
    final bool isDRColumnEmpty = excelAdminModelTemp.dROrCR.column.text.isEmpty;
    final bool isDRRowEmpty = excelAdminModelTemp.dROrCR.row.text.isEmpty;
    // if (isDRColumnEmpty || isDRRowEmpty) {
    //   return false;
    // }
    if (isDRColumnEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "DR column is empty");
    }
    if (isDRRowEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "DR row is empty");
    }
    final bool isMoneyTypeColumnEmpty = excelAdminModelTemp.moneyType.column.text.isEmpty;
    final bool isMoneyTypeRowEmpty = excelAdminModelTemp.moneyType.row.text.isEmpty;
    // if (isMoneyTypeColumnEmpty || isMoneyTypeRowEmpty) {
    //   return false;
    // }
    if (isMoneyTypeColumnEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "money type column is empty");
    }
    if (isMoneyTypeRowEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "money type row is empty");
    }
    final bool isProfitColumnEmpty = excelAdminModelTemp.profit.column.text.isEmpty;
    final bool isProfitRowEmpty = excelAdminModelTemp.profit.row.text.isEmpty;
    // if (isProfitColumnEmpty || isProfitRowEmpty) {
    //   return false;
    // }
    if (isProfitColumnEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "profit column is empty");
    }
    if (isProfitRowEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "profit row is empty");
    }

    final bool isStatusColumnEmpty = excelAdminModelTemp.status.column.text.isEmpty;
    final bool isStatusRowEmpty = excelAdminModelTemp.status.row.text.isEmpty;
    // if (isStatusColumnEmpty || isStatusRowEmpty) {
    //   return false;
    // }
    if (isStatusColumnEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "status column is empty");
    }
    if (isStatusRowEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "status row is empty");
    }

    final bool isTxnIdColumnEmpty = excelAdminModelTemp.txnID.column.text.isEmpty;
    final bool isTxnIdRowEmpty = excelAdminModelTemp.txnID.row.text.isEmpty;
    // if (isTxnIdColumnEmpty || isTxnIdRowEmpty) {
    //   return false;
    // }
    if (isTxnIdColumnEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "txn id column is empty");
    }
    if (isTxnIdRowEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "txn id row is empty");
    }

    final bool isPrintTypeNameColumnEmpty = excelAdminModelTemp.printTypeName.column.text.isEmpty;
    final bool isPrintTypeNameRowEmpty = excelAdminModelTemp.printTypeName.row.text.isEmpty;
    // if (isPrintTypeNameColumnEmpty || isPrintTypeNameRowEmpty) {
    //   return false;
    // }
    if (isPrintTypeNameRowEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "print type name row is empty");
    }
    if (isPrintTypeNameColumnEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "print type name column is empty");
    }

    final bool isDateColumnEmpty = excelAdminModelTemp.date.column.text.isEmpty;
    final bool isDateRowEmpty = excelAdminModelTemp.date.row.text.isEmpty;
    // if (isDateColumnEmpty || isDateRowEmpty) {
    //   return false;
    // }
    if (isDateColumnEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "date column is empty");
    }
    if (isDateRowEmpty) {
      // return false;
      return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "date row is empty");
    }
    for (int nameIndex = 0; nameIndex < excelAdminModelTemp.nameList.length; nameIndex++) {
      final bool isColumnEmpty = excelAdminModelTemp.nameList[nameIndex].column.text.isEmpty;
      final bool isRowEmpty = excelAdminModelTemp.nameList[nameIndex].row.text.isEmpty;
      // if (isColumnEmpty || isRowEmpty) {
      //   return false;
      // }
      if (isColumnEmpty) {
        // return false;
        return ValidButtonModel(
          isValid: false,
          errorType: ErrorTypeEnum.valueOfString,
          error: "name column is empty",
          errorLocationList: [TitleAndSubtitleModel(title: "name index", subtitle: nameIndex.toString())],
        );
      }
      if (isRowEmpty) {
        // return false;
        // return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "name row is empty");
        return ValidButtonModel(
          isValid: false,
          errorType: ErrorTypeEnum.valueOfString,
          error: "name row is empty",
          errorLocationList: [TitleAndSubtitleModel(title: "name index", subtitle: nameIndex.toString())],
        );
      }
    }
    for (int dRIndex = 0; dRIndex < excelAdminModelTemp.dROrCR.dRKeywordList.length; dRIndex++) {
      final bool isColumnEmpty = excelAdminModelTemp.dROrCR.dRKeywordList[dRIndex].text.isEmpty;
      if (isColumnEmpty) {
        // return false;
        return ValidButtonModel(
          isValid: false,
          errorType: ErrorTypeEnum.valueOfString,
          error: "DR column is empty",
          errorLocationList: [TitleAndSubtitleModel(title: "DR index", subtitle: dRIndex.toString())],
        );
      }
    }
    for (int cRIndex = 0; cRIndex < excelAdminModelTemp.dROrCR.cRKeywordList.length; cRIndex++) {
      final bool isColumnEmpty = excelAdminModelTemp.dROrCR.cRKeywordList[cRIndex].text.isEmpty;
      if (isColumnEmpty) {
        // return false;
        return ValidButtonModel(
          isValid: false,
          errorType: ErrorTypeEnum.valueOfString,
          error: "CR column is empty",
          errorLocationList: [TitleAndSubtitleModel(title: "CR index", subtitle: cRIndex.toString())],
        );
      }
    }
    for (int excelAdminIndexInside = 0; excelAdminIndexInside < excelAdminModelListGlobal.length; excelAdminIndexInside++) {
      final bool isNotSameCurrentEditingIndex = (excelIndexMain != excelAdminIndexInside);
      if (isNotSameCurrentEditingIndex) {
        final bool isExcelNameSame = (excelAdminModelTemp.excelName.text == excelAdminModelListGlobal[excelAdminIndexInside].excelName.text);
        if (isExcelNameSame) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueUnique,
            error: "excel name is same",
          );
        }
        // for (int excelIndexInside = 0; excelIndexInside < excelAdminModelListGlobal[excelAdminIndexInside].nameList.length; excelIndexInside++) {
        //   for (int excelIndex = 0; excelIndex < excelAdminModelTemp.nameList.length; excelIndex++) {
        //     final String isMergeRowColumn = "${excelAdminModelTemp.nameList[excelIndex].row.text}${excelAdminModelTemp.nameList[excelIndex].column.text}";
        //     final String isMergeRowColumnTemp =
        //         "${excelAdminModelListGlobal[excelAdminIndexInside].nameList[excelIndexInside].row.text}${excelAdminModelListGlobal[excelAdminIndexInside].nameList[excelIndexInside].column.text}";
        //     print("$isMergeRowColumn != $isMergeRowColumnTemp  => ${isMergeRowColumn != isMergeRowColumnTemp}");
        //     if (isMergeRowColumn != isMergeRowColumnTemp) {
        //       return false;
        //     }
        //   }
        // }
      }
    }

    if (!isCreateNewCustomer) {
      bool isValid = false;
      final bool isExcelNameNotSame = (excelAdminModelTemp.excelName.text != excelAdminModelListGlobal[excelIndexMain!].excelName.text);
      if (isExcelNameNotSame) {
        isValid = true;
      }
      final bool isDateFormatNotSame = (excelAdminModelTemp.dateFormat.text != excelAdminModelListGlobal[excelIndexMain].dateFormat.text);
      if (isDateFormatNotSame) {
        isValid = true;
      }
      final bool isAxisNameNotSame = (excelAdminModelTemp.axis != excelAdminModelListGlobal[excelIndexMain].axis);
      if (isAxisNameNotSame) {
        isValid = true;
      }

      final String rowAmountStr = excelAdminModelTemp.amount.row.text;
      final String rowAmountStrInside = excelAdminModelListGlobal[excelIndexMain].amount.row.text;
      final String columnAmountStr = excelAdminModelTemp.amount.column.text;
      final String columnAmountStrInside = excelAdminModelListGlobal[excelIndexMain].amount.column.text;
      final String columnIsDRStr = excelAdminModelTemp.dROrCR.column.text;
      final String columnIsDRStrInside = excelAdminModelListGlobal[excelIndexMain].dROrCR.column.text;
      final bool isRowAmountNotSame = (rowAmountStrInside != rowAmountStr);
      final bool isColumnAmountNotSame = (columnAmountStr != columnAmountStrInside);
      final bool isColumnIsDRNotSame = (columnIsDRStr != columnIsDRStrInside);
      if (isRowAmountNotSame || isColumnAmountNotSame || isColumnIsDRNotSame) {
        isValid = true;
      }

      final String rowMoneyTypeStr = excelAdminModelTemp.moneyType.row.text;
      final String rowMoneyTypeStrInside = excelAdminModelListGlobal[excelIndexMain].moneyType.row.text;
      final String columnMoneyTypeStr = excelAdminModelTemp.moneyType.column.text;
      final String columnMoneyTypeStrInside = excelAdminModelListGlobal[excelIndexMain].moneyType.column.text;
      final bool isRowMoneyTypeNotSame = (rowMoneyTypeStrInside != rowMoneyTypeStr);
      final bool isColumnMoneyTypeNotSame = (columnMoneyTypeStr != columnMoneyTypeStrInside);
      if (isRowMoneyTypeNotSame || isColumnMoneyTypeNotSame) {
        isValid = true;
      }

      final String rowProfitStr = excelAdminModelTemp.profit.row.text;
      final String rowProfitStrInside = excelAdminModelListGlobal[excelIndexMain].profit.row.text;
      final String columnProfitStr = excelAdminModelTemp.profit.column.text;
      final String columnProfitStrInside = excelAdminModelListGlobal[excelIndexMain].profit.column.text;
      final bool isRowProfitNotSame = (rowProfitStrInside != rowProfitStr);
      final bool isColumnProfitNotSame = (columnProfitStr != columnProfitStrInside);
      if (isRowProfitNotSame || isColumnProfitNotSame) {
        isValid = true;
      }

      final String rowStatusStr = excelAdminModelTemp.status.row.text;
      final String rowStatusStrInside = excelAdminModelListGlobal[excelIndexMain].status.row.text;
      final String columnStatusStr = excelAdminModelTemp.status.column.text;
      final String columnStatusStrInside = excelAdminModelListGlobal[excelIndexMain].status.column.text;
      final bool isRowStatusNotSame = (rowStatusStrInside != rowStatusStr);
      final bool isColumnStatusNotSame = (columnStatusStr != columnStatusStrInside);
      if (isRowStatusNotSame || isColumnStatusNotSame) {
        isValid = true;
      }

      final String rowTxnIdStr = excelAdminModelTemp.txnID.row.text;
      final String rowTxnIdStrInside = excelAdminModelListGlobal[excelIndexMain].txnID.row.text;
      final String columnTxnIdStr = excelAdminModelTemp.txnID.column.text;
      final String columnTxnIdStrInside = excelAdminModelListGlobal[excelIndexMain].txnID.column.text;
      final bool isRowTxnIdNotSame = (rowTxnIdStrInside != rowTxnIdStr);
      final bool isColumnTxnIdNotSame = (columnTxnIdStr != columnTxnIdStrInside);
      if (isRowTxnIdNotSame || isColumnTxnIdNotSame) {
        isValid = true;
      }

      final String rowPrintTypeNameStr = excelAdminModelTemp.printTypeName.row.text;
      final String rowPrintTypeNameStrInside = excelAdminModelListGlobal[excelIndexMain].printTypeName.row.text;
      final String columnPrintTypeNameStr = excelAdminModelTemp.printTypeName.column.text;
      final String columnPrintTypeNameStrInside = excelAdminModelListGlobal[excelIndexMain].printTypeName.column.text;
      final bool isRowPrintTypeNameNotSame = (rowPrintTypeNameStrInside != rowPrintTypeNameStr);
      final bool isColumnPrintTypeNameNotSame = (columnPrintTypeNameStr != columnPrintTypeNameStrInside);
      if (isRowPrintTypeNameNotSame || isColumnPrintTypeNameNotSame) {
        isValid = true;
      }

      final String rowDateStr = excelAdminModelTemp.date.row.text;
      final String rowDateStrInside = excelAdminModelListGlobal[excelIndexMain].date.row.text;
      final String columnDateStr = excelAdminModelTemp.date.column.text;
      final String columnDateStrInside = excelAdminModelListGlobal[excelIndexMain].date.column.text;
      final bool isRowDateNotSame = (rowDateStrInside != rowDateStr);
      final bool isColumnDateNotSame = (columnDateStr != columnDateStrInside);
      if (isRowDateNotSame || isColumnDateNotSame) {
        isValid = true;
      }

      final bool isRemarkNotSame = (excelAdminModelTemp.remark.text != excelAdminModelListGlobal[excelIndexMain].remark.text);
      if (isRemarkNotSame) {
        isValid = true;
      }
      final bool isInformationListSameLength = (excelAdminModelTemp.nameList.length == excelAdminModelListGlobal[excelIndexMain].nameList.length);
      if (isInformationListSameLength) {
        for (int informationIndex = 0; informationIndex < excelAdminModelTemp.nameList.length; informationIndex++) {
          final String rowStr = excelAdminModelTemp.nameList[informationIndex].row.text;
          final String rowStrInside = excelAdminModelListGlobal[excelIndexMain].nameList[informationIndex].row.text;
          final String columnStr = excelAdminModelTemp.nameList[informationIndex].column.text;
          final String columnStrInside = excelAdminModelListGlobal[excelIndexMain].nameList[informationIndex].column.text;
          final bool isRowNotSame = (rowStrInside != rowStr);
          final bool isColumnNotSame = (columnStr != columnStrInside);
          if (isRowNotSame || isColumnNotSame) {
            isValid = true;
            break;
          }
        }
      } else {
        isValid = true;
      }

      final bool isDRListSameLength = (excelAdminModelTemp.dROrCR.dRKeywordList.length == excelAdminModelListGlobal[excelIndexMain].dROrCR.dRKeywordList.length);
      if (isDRListSameLength) {
        for (int informationIndex = 0; informationIndex < excelAdminModelTemp.dROrCR.dRKeywordList.length; informationIndex++) {
          final String rowStr = excelAdminModelTemp.dROrCR.dRKeywordList[informationIndex].text;
          final String rowStrInside = excelAdminModelListGlobal[excelIndexMain].dROrCR.dRKeywordList[informationIndex].text;
          final bool isRowNotSame = (rowStrInside != rowStr);
          if (isRowNotSame) {
            isValid = true;
            break;
          }
        }
      } else {
        isValid = true;
      }
      final bool isCRListSameLength = (excelAdminModelTemp.dROrCR.cRKeywordList.length == excelAdminModelListGlobal[excelIndexMain].dROrCR.cRKeywordList.length);
      if (isCRListSameLength) {
        for (int informationIndex = 0; informationIndex < excelAdminModelTemp.dROrCR.cRKeywordList.length; informationIndex++) {
          final String rowStr = excelAdminModelTemp.dROrCR.cRKeywordList[informationIndex].text;
          final String rowStrInside = excelAdminModelListGlobal[excelIndexMain].dROrCR.cRKeywordList[informationIndex].text;
          final bool isRowNotSame = (rowStrInside != rowStr);
          if (isRowNotSame) {
            isValid = true;
            break;
          }
        }
      } else {
        isValid = true;
      }
      // return isValid;
      return ValidButtonModel(isValid: isValid, errorType: ErrorTypeEnum.nothingChange);
    }
    // return true;
    return ValidButtonModel(isValid: true);
  }

  void saveFunctionOnTap() {
    closeDialogGlobal(context: context);
    void callBack() {
      adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.importFromExcel);
      setState(() {});
    }

    updateExcelAdminGlobal(callBack: callBack, context: context, excelAdminModelTemp: excelAdminModelTemp);
  }

  Function? deleteFunctionOrNull() {
    if (isCreateNewCustomer || !isAdminEditing || (excelAdminModelTemp.deletedDate != null)) {
      return null;
    } else {
      void deleteFunctionOnTap() {
        void okFunction() {
          void callback() {
            adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.importFromExcel);
            setState(() {});
            closeDialogGlobal(context: context);
          }

          deleteExcelAdminGlobal(callBack: callback, context: context, excelAdminId: excelAdminModelTemp.id!); //delete the existing card in database and local storage
        }

        void cancelFunction() {}
        confirmationDialogGlobal(
          context: context,
          okFunction: okFunction,
          cancelFunction: cancelFunction,
          titleStr: "$deleteGlobal ${excelAdminModelTemp.excelName.text}",
          subtitleStr: deleteConfirmGlobal,
        );
      }

      return deleteFunctionOnTap;
    }
  }

  Function? restoreFunctionOrNull() {
    if (isCreateNewCustomer || !isAdminEditing || (excelAdminModelTemp.deletedDate == null)) {
      return null;
    } else {
      void restoreFunction() {
        void okFunction() {
          void callback() {
            adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.importFromExcel);
            setState(() {});
            closeDialogGlobal(context: context);
          }

          restoreExcelAdminGlobal(callBack: callback, context: context, excelAdminId: excelAdminModelTemp.id!); //delete the existing card in database and local storage
        }

        void cancelFunction() {}
        confirmationDialogGlobal(
          context: context,
          okFunction: okFunction,
          cancelFunction: cancelFunction,
          titleStr: "$restoreGlobal ${excelAdminModelTemp.excelName.text}",
          subtitleStr: restoreConfirmGlobal,
        );
      }

      return restoreFunction;
    }
  }

  Widget editCustomerDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
    Widget paddingBottomCreateCustomerWidget() {
      Widget createCustomerWidget() {
        Widget informationWidget() {
          Widget paddingVertical({required Widget widget}) {
            return Padding(padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.mini)), child: widget);
          }

          Widget nameTextFieldWidget() {
            void onTapFromOutsiderFunction() {}
            void onChangeFromOutsiderFunction() {
              setStateFromDialog(() {});
            }

            return textFieldGlobal(
              isEnabled: isAdminEditing && (excelAdminModelTemp.deletedDate == null),
              textFieldDataType: TextFieldDataType.str,
              controller: excelAdminModelTemp.excelName,
              onTapFromOutsiderFunction: onTapFromOutsiderFunction,
              onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
              labelText: excelNameStrGlobal,
              level: Level.normal,
            );
          }

          Widget dateFormatTextFieldWidget() {
            void onTapFromOutsiderFunction() {}
            void onChangeFromOutsiderFunction() {
              setStateFromDialog(() {});
            }

            return textFieldGlobal(
              isEnabled: isAdminEditing && (excelAdminModelTemp.deletedDate == null),
              textFieldDataType: TextFieldDataType.str,
              controller: excelAdminModelTemp.dateFormat,
              onTapFromOutsiderFunction: onTapFromOutsiderFunction,
              onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
              labelText: dateFormatStrGlobal,
              level: Level.normal,
            );
          }

          Widget rowAndColumnTextFieldWidget({required TableColumnAndRow tableColumnAndRow, required String titleStr, required Level level}) {
            Widget titleTextFieldWidget() {
              void onTapFromOutsiderFunction() {}
              void onChangeFromOutsiderFunction() {
                setStateFromDialog(() {});
              }

              return textFieldGlobal(
                isEnabled: isAdminEditing && (excelAdminModelTemp.deletedDate == null),
                textFieldDataType: TextFieldDataType.str,
                // controller: excelAdminModelTemp.nameList[nameIndex].row,
                controller: tableColumnAndRow.row,
                onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                labelText: "$rowOfStrGlobal $titleStr",
                level: level,
              );
            }

            Widget paddingLeftSubtitleTextFieldWidget() {
              Widget subtitleTextFieldWidget() {
                void onTapFromOutsiderFunction() {}
                void onChangeFromOutsiderFunction() {
                  setStateFromDialog(() {});
                }

                return textFieldGlobal(
                  isEnabled: isAdminEditing && (excelAdminModelTemp.deletedDate == null),
                  textFieldDataType: TextFieldDataType.int,
                  controller: tableColumnAndRow.column,
                  onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                  onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                  labelText: "$columnOfStrGlobal $titleStr",
                  level: level,
                );
              }

              return Padding(padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)), child: subtitleTextFieldWidget());
            }

            return Row(children: [Expanded(child: titleTextFieldWidget()), Expanded(child: paddingLeftSubtitleTextFieldWidget())]);
          }

          Widget informationListWidget() {
            Widget informationWidget({required int nameIndex}) {
              void onTapUnlessDisable() {
                //TODO: do something and setState
              }

              Function? onDeleteUnlessDisableProvider() {
                if (isAdminEditing && (excelAdminModelTemp.deletedDate == null) && (excelAdminModelTemp.nameList.length > 1)) {
                  void onDeleteUnlessDisable() {
                    excelAdminModelTemp.nameList.removeAt(nameIndex);
                    setStateFromDialog(() {});
                  }

                  return onDeleteUnlessDisable;
                } else {
                  return null;
                }
              }

              return CustomButtonGlobal(
                isDisable: true,
                onDeleteUnlessDisable: onDeleteUnlessDisableProvider(),
                insideSizeBoxWidget: rowAndColumnTextFieldWidget(tableColumnAndRow: excelAdminModelTemp.nameList[nameIndex], titleStr: excelServiceNameAndIdStrGlobal, level: Level.mini),
                onTapUnlessDisable: onTapUnlessDisable,
              );
              // return titleAndSubtitleTextFieldWidget();
            }

            Widget paddingAddRateButtonWidget() {
              Widget addRateButtonWidget() {
                ValidButtonModel isValid() {
                  for (int nameIndex = 0; nameIndex < excelAdminModelTemp.nameList.length; nameIndex++) {
                    final bool isTitleEmpty = excelAdminModelTemp.nameList[nameIndex].row.text.isEmpty;
                    final bool isSubtitleEmpty = excelAdminModelTemp.nameList[nameIndex].column.text.isEmpty;
                    // if (isTitleEmpty || isSubtitleEmpty) {
                    //   return false;
                    // }
                    if (isTitleEmpty) {
                      // return false;
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.valueOfString,
                        error: "name row is empty",
                        errorLocationList: [TitleAndSubtitleModel(title: "name index", subtitle: nameIndex.toString())],
                      );
                    }
                    if (isSubtitleEmpty) {
                      // return false;
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.valueOfString,
                        error: "name column is empty",
                        errorLocationList: [TitleAndSubtitleModel(title: "name index", subtitle: nameIndex.toString())],
                      );
                    }
                  }
                  // return isAdminEditing && (excelAdminModelTemp.deletedDate == null);
                  if (!isAdminEditing) {
                    return ValidButtonModel(isValid: false, error: "employee does not have permission to edit");
                  }
                  if (excelAdminModelTemp.deletedDate != null) {
                    return ValidButtonModel(isValid: false, error: "excel has been deleted");
                  }
                  return ValidButtonModel(isValid: true);
                }

                Function onTapFunctionProvider() {
                  // if (isAdminEditing) {
                  void onTapFunction() {
                    excelAdminModelTemp.nameList.add(TableColumnAndRow(
                      row: TextEditingController(),
                      column: TextEditingController(),
                      dRKeywordList: [],
                      cRKeywordList: [],
                    ));
                    setStateFromDialog(() {});
                  }

                  return onTapFunction;
                  // } else {
                  //   return null;
                  // }
                }

                return addButtonOrContainerWidget(
                  context: context,
                  level: Level.mini,
                  validModel: isValid(),
                  onTapFunction: onTapFunctionProvider(),
                  currentAddButtonQty: excelAdminModelTemp.nameList.length,
                  maxAddButtonLimit: excelNameAddButtonLimitGlobal,
                );
              }

              return Padding(padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.normal)), child: addRateButtonWidget());
            }

            // return Column(children: [for (int nameIndex = 0; nameIndex < excelAdminModelTemp.nameList.length; nameIndex++) informationWidget(nameIndex: nameIndex), paddingAddRateButtonWidget()]);

            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
              child: CustomButtonGlobal(
                insideSizeBoxWidget: Column(children: [
                  for (int nameIndex = 0; nameIndex < excelAdminModelTemp.nameList.length; nameIndex++) informationWidget(nameIndex: nameIndex),
                  paddingAddRateButtonWidget(),
                ]),
                onTapUnlessDisable: () {},
              ),
            );
          }

          Widget dROrCRWidget() {
            Widget dRListWidget({required List<TextEditingController> keywordList, required String titleStr}) {
              Widget informationWidget({required int dROrCRIndex}) {
                void onTapUnlessDisable() {
                  //TODO: do something and setState
                }

                Function? onDeleteUnlessDisableProvider() {
                  if (isAdminEditing && (excelAdminModelTemp.deletedDate == null) && (keywordList.length > 1)) {
                    void onDeleteUnlessDisable() {
                      keywordList.removeAt(dROrCRIndex);
                      setStateFromDialog(() {});
                    }

                    return onDeleteUnlessDisable;
                  } else {
                    return null;
                  }
                }

                void onTapFromOutsiderFunction() {}

                void onChangeFromOutsiderFunction() {
                  setStateFromDialog(() {});
                }

                return CustomButtonGlobal(
                  isDisable: true,
                  onDeleteUnlessDisable: onDeleteUnlessDisableProvider(),
                  insideSizeBoxWidget: textFieldGlobal(
                    textFieldDataType: TextFieldDataType.str,
                    controller: keywordList[dROrCRIndex],
                    onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                    onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                    labelText: titleStr,
                    level: Level.mini,
                  ),
                  onTapUnlessDisable: onTapUnlessDisable,
                );
                // return titleAndSubtitleTextFieldWidget();
              }

              Widget paddingAddRateButtonWidget() {
                Widget addRateButtonWidget() {
                  ValidButtonModel isValid() {
                    for (int nameIndex = 0; nameIndex < keywordList.length; nameIndex++) {
                      final bool isTitleEmpty = keywordList[nameIndex].text.isEmpty;
                      if (isTitleEmpty) {
                        // return false;
                        return ValidButtonModel(
                          isValid: false,
                          errorType: ErrorTypeEnum.valueOfString,
                          error: "name is empty",
                          errorLocationList: [TitleAndSubtitleModel(title: "name index", subtitle: nameIndex.toString())],
                        );
                      }
                    }
                    // return isAdminEditing && (excelAdminModelTemp.deletedDate == null);
                    if (!isAdminEditing) {
                      return ValidButtonModel(isValid: false, error: "employee does not have permission to edit");
                    }
                    if (excelAdminModelTemp.deletedDate != null) {
                      return ValidButtonModel(isValid: false, error: "excel has been deleted");
                    }
                    return ValidButtonModel(isValid: true);
                  }

                  Function onTapFunctionProvider() {
                    // if (isAdminEditing) {
                    void onTapFunction() {
                      keywordList.add(TextEditingController());
                      setStateFromDialog(() {});
                    }

                    return onTapFunction;
                    // } else {
                    //   return null;
                    // }
                  }

                  return addButtonOrContainerWidget(
                    context: context,
                    level: Level.mini,
                    validModel: isValid(),
                    onTapFunction: onTapFunctionProvider(),
                    currentAddButtonQty: keywordList.length,
                    maxAddButtonLimit: excelNameAddButtonLimitGlobal,
                  );
                }

                return Padding(padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.normal)), child: addRateButtonWidget());
              }

              return Column(children: [for (int nameIndex = 0; nameIndex < keywordList.length; nameIndex++) informationWidget(dROrCRIndex: nameIndex), paddingAddRateButtonWidget()]);
            }

            // return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //   Expanded(child: dRListWidget(keywordList: excelAdminModelTemp.dROrCR.dRKeywordList, titleStr: dRNegativeStrGlobal)),
            //   Expanded(child: dRListWidget(keywordList: excelAdminModelTemp.dROrCR.cRKeywordList, titleStr: cRPositiveStrGlobal)),
            // ]);
            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
              child: CustomButtonGlobal(
                insideSizeBoxWidget: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: dRListWidget(keywordList: excelAdminModelTemp.dROrCR.dRKeywordList, titleStr: dRNegativeStrGlobal)),
                  Expanded(child: dRListWidget(keywordList: excelAdminModelTemp.dROrCR.cRKeywordList, titleStr: cRPositiveStrGlobal)),
                ]),
                onTapUnlessDisable: () {},
              ),
            );
          }

          Widget remarkTextFieldWidget() {
            void onTapFromOutsiderFunction() {}
            void onChangeFromOutsiderFunction() {
              setStateFromDialog(() {});
            }

            return textAreaGlobal(
              isEnabled: isAdminEditing && (excelAdminModelTemp.deletedDate == null),
              controller: excelAdminModelTemp.remark,
              onTapFromOutsiderFunction: onTapFromOutsiderFunction,
              onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
              labelText: remarkOptionalStrGlobal,
              level: Level.normal,
            );
          }

          Widget titleTextFieldWidget() {
            return Text(excelInformationStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold));
          }

          Widget excelDropDownWidget() {
            void onTapFunction() {}
            void onChangedFunction({required String value, required int index}) {
              excelAdminModelTemp.axis = value;
              setStateFromDialog(() {});
            }

            return (isAdminEditing && (excelAdminModelTemp.deletedDate == null))
                ? customDropdown(
                    level: Level.normal,
                    labelStr: axisStrGlobal,
                    onTapFunction: onTapFunction,
                    onChangedFunction: onChangedFunction,
                    selectedStr: excelAdminModelTemp.axis,
                    menuItemStrList: axisListGlobal,
                  )
                : textFieldGlobal(
                    isEnabled: false,
                    controller: TextEditingController(text: excelAdminModelTemp.axis),
                    onChangeFromOutsiderFunction: () {},
                    labelText: axisStrGlobal,
                    level: Level.normal,
                    textFieldDataType: TextFieldDataType.str,
                    onTapFromOutsiderFunction: () {},
                  );
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleTextFieldWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                  child: Column(
                    children: [
                      paddingVertical(widget: nameTextFieldWidget()),
                      paddingVertical(widget: dateFormatTextFieldWidget()),
                      paddingVertical(widget: excelDropDownWidget()),
                      paddingVertical(
                        widget: rowAndColumnTextFieldWidget(
                          tableColumnAndRow: excelAdminModelTemp.amount,
                          titleStr: amountStrGlobal,
                          level: Level.normal,
                        ),
                      ),
                      paddingVertical(
                        widget: rowAndColumnTextFieldWidget(
                          tableColumnAndRow: excelAdminModelTemp.dROrCR,
                          titleStr: isDRStrGlobal,
                          level: Level.normal,
                        ),
                      ),
                      paddingVertical(widget: dROrCRWidget()),
                      paddingVertical(
                        widget: rowAndColumnTextFieldWidget(
                          tableColumnAndRow: excelAdminModelTemp.moneyType,
                          titleStr: moneyTypeStrGlobal,
                          level: Level.normal,
                        ),
                      ),
                      paddingVertical(
                        widget: rowAndColumnTextFieldWidget(
                          tableColumnAndRow: excelAdminModelTemp.profit,
                          titleStr: profitStrGlobal,
                          level: Level.normal,
                        ),
                      ),
                      paddingVertical(
                        widget: rowAndColumnTextFieldWidget(
                          tableColumnAndRow: excelAdminModelTemp.status,
                          titleStr: statusStrGlobal,
                          level: Level.normal,
                        ),
                      ),
                      paddingVertical(
                        widget: rowAndColumnTextFieldWidget(
                          tableColumnAndRow: excelAdminModelTemp.txnID,
                          titleStr: idStrPrintGlobal,
                          level: Level.normal,
                        ),
                      ),
                      paddingVertical(
                        widget: rowAndColumnTextFieldWidget(
                          tableColumnAndRow: excelAdminModelTemp.printTypeName,
                          titleStr: printTypeNameStrPrintGlobal,
                          level: Level.normal,
                        ),
                      ),
                      paddingVertical(
                        widget: rowAndColumnTextFieldWidget(
                          tableColumnAndRow: excelAdminModelTemp.date,
                          titleStr: dateStrPrintGlobal,
                          level: Level.normal,
                        ),
                      ),
                      informationListWidget(),
                      paddingVertical(widget: remarkTextFieldWidget()),
                    ],
                  ),
                ),
              ),
            ),
          ]);
        }

        return informationWidget();
      }

      return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: createCustomerWidget());
    }

    return paddingBottomCreateCustomerWidget();
  }

  actionDialogSetStateGlobal(
    dialogHeight: dialogSizeGlobal(level: Level.mini),
    dialogWidth: dialogSizeGlobal(level: Level.mini),
    cancelFunctionOnTap: cancelFunctionOnTap,
    context: context,
    validSaveButtonFunction: () => validSaveButtonFunction(),
    saveFunctionOnTap: (excelAdminModelTemp.deletedDate == null) ? saveFunctionOnTap : null,
    contentFunctionReturnWidget: editCustomerDialog,
    deleteFunctionOnTap: deleteFunctionOrNull(),
    restoreFunctionOnTap: restoreFunctionOrNull(),
  );
}
