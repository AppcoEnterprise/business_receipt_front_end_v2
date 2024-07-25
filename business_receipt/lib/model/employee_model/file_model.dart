import 'dart:typed_data';

import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/excel_admin_model.dart';
import 'package:business_receipt/model/employee_model/excel_employee_model.dart';
import 'package:business_receipt/model/money_type_and_value_model.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExcelFileModel {
  final String name;
  final String mime;
  final int bytes;
  final Uint8List data;

  ExcelFileModel({required this.data, required this.name, required this.mime, required this.bytes});

  String get size {
    final kb = bytes / 1024;
    final mb = kb / 1024;
    return mb > 1 ? "${mb.toStringAsFixed(2)} MB" : "${kb.toStringAsFixed(2)} KB";
  }

  ExcelEmployeeModel? getExcelEmployeeModel({required int excelAdminIndex, required BuildContext context}) {
    Excel excel = Excel.decodeBytes(data);
    for (var key in excel.tables.keys) {
      // print(table); //sheet Name
      // print(excel.tables[table]!.maxCols);
      // print(excel.tables[table]!.maxRows);
      // print(excel.tables[key]!.rows[1][0]!.value);//[column][row]
      List<ExcelDataList> dataList = [];
      final Sheet table = excel.tables[key]!;
      final int maxCols = table.maxCols;
      final int maxRows = table.maxRows;
      final bool isVertical = axisListGlobal.first == excelAdminModelListGlobal[excelAdminIndex].axis;
      bool checkNotNullOnExcel({required TableColumnAndRow tableColumnAndRow}) {
        final int rowIndex = lettersToIndex(letters: tableColumnAndRow.row.text) - 1;
        final int columnIndex = textEditingControllerToInt(controller: tableColumnAndRow.column)! - 1;
        if (isVertical) {
          for (int dataIndex = 0; dataIndex < (maxRows - columnIndex); dataIndex++) {
            if (table.rows[columnIndex + dataIndex][rowIndex] == null) {
              return false;
            }
          }
        } else {
          for (int dataIndex = 0; dataIndex < (maxCols - rowIndex); dataIndex++) {
            if (table.rows[columnIndex][rowIndex + dataIndex] == null) {
              return false;
            }
          }
        }
        return true;
      }

      List<String> getValueStrFromExcel({required TableColumnAndRow tableColumnAndRow}) {
        List<String> valueList = [];
        final int rowIndex = lettersToIndex(letters: tableColumnAndRow.row.text) - 1;
        final int columnIndex = textEditingControllerToInt(controller: tableColumnAndRow.column)! - 1;
        if (isVertical) {
          for (int dataIndex = 0; dataIndex < (maxRows - columnIndex); dataIndex++) {
            valueList.add(table.rows[columnIndex + dataIndex][rowIndex]!.value.toString());
            // print("table.rows[${columnIndex + dataIndex}][$rowIndex]!.value (${table.rows[columnIndex + dataIndex][rowIndex]!.value.runtimeType}) => ${table.rows[columnIndex + dataIndex][rowIndex]!.value}");
          }
        } else {
          for (int dataIndex = 0; dataIndex < (maxCols - rowIndex); dataIndex++) {
            valueList.add(table.rows[columnIndex][rowIndex + dataIndex]!.value.toString());
            // if (table.rows[columnIndex][rowIndex + dataIndex] == null) {
            //   return false;
            // }
          }
        }
        return valueList;
      }

      final bool isAmountNotNull = checkNotNullOnExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].amount);
      final bool isIsDRNotNull = checkNotNullOnExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].dROrCR);
      final bool isMoneyTypeNotNull = checkNotNullOnExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].moneyType);
      final bool isDateNotNull = checkNotNullOnExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].date);
      final bool isTxnIDNotNull = checkNotNullOnExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].txnID);
      final bool isPrintTypeNameNotNull = checkNotNullOnExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].printTypeName);
      final bool isProfitNotNull = checkNotNullOnExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].profit);
      final bool isStatusNotNull = checkNotNullOnExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].status);
      if (!(isAmountNotNull &&
          isIsDRNotNull &&
          isMoneyTypeNotNull &&
          isDateNotNull &&
          isTxnIDNotNull &&
          isProfitNotNull &&
          isStatusNotNull &&
          isPrintTypeNameNotNull)) {
        return null;
      } else {
        for (int nameIndex = 0; nameIndex < excelAdminModelListGlobal[excelAdminIndex].nameList.length; nameIndex++) {
          final bool isNameNotNull = checkNotNullOnExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].nameList[nameIndex]);
          if (!isNameNotNull) {
            return null;
          }
        }
      }

      final List<String> amountStrList = getValueStrFromExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].amount);
      final List<String> isDRStrList = getValueStrFromExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].dROrCR);
      final List<String> moneyTypeStrList = getValueStrFromExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].moneyType);
      final List<String> dateStrList = getValueStrFromExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].date);
      final List<String> txnIDStrList = getValueStrFromExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].txnID);
      final List<String> printTypeNameStrList = getValueStrFromExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].printTypeName);
      final List<String> profitStrList = getValueStrFromExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].profit);
      final List<String> statusStrList = getValueStrFromExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].status);
      final List<List<String>> nameStrList = [];
      for (int nameIndex = 0; nameIndex < excelAdminModelListGlobal[excelAdminIndex].nameList.length; nameIndex++) {
        nameStrList.add(getValueStrFromExcel(tableColumnAndRow: excelAdminModelListGlobal[excelAdminIndex].nameList[nameIndex]));
      }
      final DateTime currentDate = DateTime.now();
      final String currentDateFormatStr = formatDateDateToStr(date: currentDate);

      for (int index = 0; index < amountStrList.length; index++) {
        try {
          bool? isDR;
          for (int drIndex = 0; drIndex < excelAdminModelListGlobal[excelAdminIndex].dROrCR.dRKeywordList.length; drIndex++) {
            if (isDRStrList[index] == excelAdminModelListGlobal[excelAdminIndex].dROrCR.dRKeywordList[drIndex].text) {
              isDR = true;
              break;
            }
          }
          for (int crIndex = 0; crIndex < excelAdminModelListGlobal[excelAdminIndex].dROrCR.cRKeywordList.length; crIndex++) {
            if (isDRStrList[index] == excelAdminModelListGlobal[excelAdminIndex].dROrCR.cRKeywordList[crIndex].text) {
              isDR = false;
              break;
            }
          }
          if (isDR == null) {
            void okFunction() {
              closeDialogGlobal(context: context);
              closeDialogGlobal(context: context);
            }

            okDialogGlobal(context: context, okFunction: okFunction, titleStr: errorStrGlobal, subtitleStr: drOrCRNotMatchStrGlobal);
            break;
          } else {
            final double amount = (isDR ? 1 : -1) * double.parse(formatTextToNumberStrGlobal(valueStr: amountStrList[index]));
            final String moneyType = moneyTypeStrList[index];
            final double profit = double.parse(formatTextToNumberStrGlobal(valueStr: profitStrList[index]));
            final DateTime date = DateFormat(excelAdminModelListGlobal[excelAdminIndex].dateFormat.text).parse(dateStrList[index]);

            final String dateFormatStr = formatDateDateToStr(date: date);
            if (currentDateFormatStr != dateFormatStr) {
              void okFunction() {
                closeDialogGlobal(context: context);
                closeDialogGlobal(context: context);
              }

              okDialogGlobal(context: context, okFunction: okFunction, titleStr: errorStrGlobal, subtitleStr: dateMustCurrentStrGlobal);
              break;
            }
            final String status = statusStrList[index];
            final String txnId = txnIDStrList[index];
            final String printTypeName = printTypeNameStrList[index];
            String name = nameStrList[0][index];
            for (int nameIndex = 1; nameIndex < nameStrList.length; nameIndex++) {
              name = "$name | ${nameStrList[nameIndex][index]}";
            }
            dataList.add(ExcelDataList(
              amount: (amount + profit),
              moneyType: moneyType,
              profit: profit,
              date: date,
              status: status,
              txnID: txnId,
              name: name,
              printTypeName: printTypeName,
              activeLogModelList: [],
              remark: TextEditingController(),
            ));
          }
        } catch (e) {
          void okFunction() {
            closeDialogGlobal(context: context);
            closeDialogGlobal(context: context);
          }

          okDialogGlobal(context: context, okFunction: okFunction, titleStr: errorStrGlobal, subtitleStr: castingErrorStrGlobal);
          break;
        }
      }
      List<MoneyTypeAndValueModel> profitList = [];
      for (int dataIndex = 0; dataIndex < dataList.length; dataIndex++) {
        bool isExistProfitMoneyType = false;
        for (int profitIndex = 0; profitIndex < profitList.length; profitIndex++) {
          if (dataList[dataIndex].moneyType == profitList[profitIndex].moneyType) {
            profitList[profitIndex].value = profitList[profitIndex].value + dataList[dataIndex].profit;
            isExistProfitMoneyType = true;
            break;
          }
        }
        if (!isExistProfitMoneyType) {
          profitList.add(MoneyTypeAndValueModel(value: dataList[dataIndex].profit, moneyType: dataList[dataIndex].moneyType));
        }
      }
      return ExcelEmployeeModel(
        dataList: dataList,
        excelName: excelAdminModelListGlobal[excelAdminIndex].excelName.text,
        remark: TextEditingController(text: excelAdminModelListGlobal[excelAdminIndex].remark.text),
        excelConfigId: excelAdminModelListGlobal[excelAdminIndex].id,
        countData: dataList.length,
        profitList: profitList,
        activeLogModelList: [],
      );
    }
    return null;
  }
}
