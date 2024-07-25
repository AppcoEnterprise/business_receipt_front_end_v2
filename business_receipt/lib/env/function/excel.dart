import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:excel/excel.dart';

void writeExcel({required int row, required int column, required dynamic value, required bool isTitle, required Sheet sheetObject}) {
  CellStyle cellTitle = CellStyle(
    backgroundColorHex: "#F6FF69",
    bold: true,
    fontSize: textSizeGlobal(level: Level.normal) ~/ 2,
    leftBorder: Border(borderStyle: BorderStyle.Medium),
    rightBorder: Border(borderStyle: BorderStyle.Medium),
    topBorder: Border(borderStyle: BorderStyle.Medium),
    bottomBorder: Border(borderStyle: BorderStyle.Medium),
  );
  CellStyle cellSubtitle = CellStyle(
    fontSize: textSizeGlobal(level: Level.normal) ~/ 2,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );
  Data cellDate = sheetObject.cell(CellIndex.indexByString("${indexToLetters(index: column + 1)}${row + 1}"));
  cellDate.value = value; // dynamic values support provided;
  cellDate.cellStyle = isTitle ? cellTitle : cellSubtitle;
}
