import 'dart:math';

import 'package:business_receipt/env/value_env/text_limit.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:flutter/material.dart';

//---------------------calculate and format---------------------------------
// double calculateAndFormatDoubleGlobal({required double firstNumber, required double secondNumber, int places = maxPlaceNumberGlobal, required String operatorStr, bool isShowDetail = false}) {
//   double resultNumber = 0;
//   if (operatorStr == "+") {
//     resultNumber = firstNumber + secondNumber;
//   } else if (operatorStr == "-") {
//     resultNumber = firstNumber - secondNumber;
//   } else if (operatorStr == "*") {
//     resultNumber = firstNumber * secondNumber;
//   } else if (operatorStr == "/") {
//     resultNumber = firstNumber / secondNumber;
//   }
//   int targetPlace = places;
//   if (isShowDetail) {
//     targetPlace = (places >= 0) ? (places * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0;
//   }
//   return double.parse(formatAndLimitNumberTextGlobal(valueStr: resultNumber.toString(), isRound: false, isAddComma: false, places: targetPlace));
// }

//------------configuration max text----------------
String configMaxTextLengthGlobal({required String valueStr, required int maxTextLength}) {
  if (valueStr.length > maxTextLength) {
    valueStr = _handleWithEPlusOrEMinusStr(str: valueStr).substring(0, maxTextLength);
  }
  return valueStr;
}

//------------------text copy value and move to the last position---------------
// controller.value = copyValueAndMoveToLastGlobal(...);
TextEditingValue copyValueAndMoveToLastGlobal({required TextEditingController controller, String? value}) {
  final String v = (value == null) ? emptyStrGlobal : value.toString();
  return controller.value.copyWith(text: v, selection: TextSelection.collapsed(offset: v.length));
}

//---------------------handle with 3.14e-5 => 0.0000314-------------------------------------------
String _handleWithEPlusOrEMinusStr({required String str}) {
  //check e in str
  final int eIndex = str.indexOf(eNumberStrGlobal);
  final bool isHasEIndexInStr = (eIndex != -1);
  if (isHasEIndexInStr) {
    //check . in str
    final int dotIndex = str.indexOf(dotNumberStrGlobal);
    final bool isHasDotIndexInStr = (dotIndex != -1);
    if (isHasDotIndexInStr) {
      //remove dot from str
      //example: 3.14e-15 to 314e-15
      str = str.substring(0, dotIndex) + str.substring(dotIndex + 1);
    }

    //re-check e in str
    final int reEIndex = str.indexOf(eNumberStrGlobal);

    // example: 314e-15 => numAfterEMinusOrEPositive = -15
    final int numAfterEMinusOrEPositive = int.parse(str.substring(reEIndex + 1));

    //check e with negative or positive
    final bool isNegativeNumAfterEMinus = (numAfterEMinusOrEPositive < 0);
    if (isNegativeNumAfterEMinus) {
      //example: "314e-15" for this hold condition

      //zeroDotStr = "0.000000000000"
      String zeroDotStr = "0$dotNumberStrGlobal";
      final int add0Size = numAfterEMinusOrEPositive.abs() - dotIndex;
      for (int numAfterEMinusIndex = 0; numAfterEMinusIndex < add0Size; numAfterEMinusIndex++) {
        zeroDotStr = "${zeroDotStr}0";
      }

      //example: 314e-15 to 314
      final int cutEToEndIndex = reEIndex;
      str = str.substring(0, cutEToEndIndex);

      //"0.000000000" + "314" => "0.000000000314"
      str = zeroDotStr + str;
    } else {
      //example: "314e+5" for this hold condition
      String dotUntilEStr = emptyStrGlobal;
      if (isHasDotIndexInStr) {
        //afterDotStr = 14e+5
        final String afterDotStr = str.substring(dotIndex);

        //dotToEStr = 14
        final int eOfAfterDotIndex = afterDotStr.indexOf(eNumberStrGlobal);
        dotUntilEStr = afterDotStr.substring(0, eOfAfterDotIndex);
      }
      //check e value vs after dot length
      final bool isEValueLargerThanAfterDot = (numAfterEMinusOrEPositive > dotUntilEStr.length);
      if (isEValueLargerThanAfterDot) {
        //str = "314"
        str = str.substring(0, reEIndex);

        //add0Size = 5 - 2 = 3
        final int add0Size = numAfterEMinusOrEPositive - dotUntilEStr.length;

        //add 0 to 314 = 314000
        for (int add0Index = 0; add0Index < add0Size; add0Index++) {
          str = "${str}0";
        }
      } else {
        //example: "314e+1" for this hold condition

        //beforeOfDotUntilEStr = "1"
        final String beforeOfDotUntilEStr = dotUntilEStr.substring(0, numAfterEMinusOrEPositive);

        //afterOfDotUntilEStr = "4"
        final String afterOfDotUntilEStr = dotUntilEStr.substring(numAfterEMinusOrEPositive);

        //addDotToDotUntilEStr = "1.4"
        final String addDotToDotUntilEStr = "$beforeOfDotUntilEStr.$afterOfDotUntilEStr";

        //beforeDotStr = 3
        final String beforeDotStr = str.substring(0, dotIndex);

        //str = "3" + "1.4" = "31.4"
        str = beforeDotStr + addDotToDotUntilEStr;
      }
    }
  }

  return str;
}

bool isInteger(num value) => value is int || value == value.roundToDouble();

//-----------------remove comma from number and return string---------------------
//"-a123,567d8.90a" => "-1235678.90"
String formatTextToNumberStrGlobal({required String? valueStr, bool isAllowMinus = true}) {
  bool isNotNullValueStr = (valueStr != null && valueStr != "");
  if (isNotNullValueStr) {
    final RegExp numberReg = RegExp(r"[^\d.]+");
    String formattedValueStr = _handleWithEPlusOrEMinusStr(str: valueStr).replaceAll(numberReg, emptyStrGlobal);
    String minusOrNotStr() {
      if (isAllowMinus) {
        final bool isNegative = (_handleWithEPlusOrEMinusStr(str: valueStr)[0] == minusNumberStrGlobal);

        return (isNegative ? minusNumberStrGlobal : emptyStrGlobal);
      } else {
        return emptyStrGlobal;
      }
    }

    if (formattedValueStr.isNotEmpty) {
      if (formattedValueStr[0] == ".") {
        return "0$formattedValueStr";
      }
      bool isHasOnly0InIt = true;
      for (int formattedValueStrIndex = 0; formattedValueStrIndex < formattedValueStr.length; formattedValueStrIndex++) {
        if (formattedValueStr[formattedValueStrIndex] != "0") {
          isHasOnly0InIt = false;
          break;
        }
      }
      if (isHasOnly0InIt) {
        return "0";
      } else {
        if (formattedValueStr.length >= 2) {
          int firstStrIndexZeroCount = 0;
          for (int formattedValueStrIndex = 0; formattedValueStrIndex < formattedValueStr.length; formattedValueStrIndex++) {
            if (formattedValueStr[formattedValueStrIndex] != "0") {
              firstStrIndexZeroCount = formattedValueStrIndex;
              break;
            }
          }
          if (formattedValueStr[0] == "0" && formattedValueStr[1] != ".") {
            formattedValueStr = formattedValueStr.substring(firstStrIndexZeroCount, formattedValueStr.length);
          }
        }
      }
    }

    int firstDotIndex = -1;
    for (int i = 0; i < formattedValueStr.length; i++) {
      if (formattedValueStr[i] == ".") {
        firstDotIndex = i;
        break;
      }
    }
    if (firstDotIndex != -1) {
      final String afterDotStr = formattedValueStr.substring(0, firstDotIndex);
      final String beforeDotStr = formattedValueStr.substring(firstDotIndex + 1, formattedValueStr.length).replaceAll(".", "");
      formattedValueStr = "$afterDotStr.$beforeDotStr";
    }
    return minusOrNotStr() + formattedValueStr;
  } else {
    return emptyStrGlobal;
  }
}

//-----------------decimal format---------------------
//Note: return "", not return null
String formatAndLimitNumberTextGlobal({
  required String? valueStr,
  int places = maxPlaceNumberGlobal,
  bool isAddComma = true,
  bool isAllowZeroAtLast = false,
  required bool isRound,
  bool isAllowMinus = true,
  int? configPlace,
}) {
  if (places > maxPlaceNumberGlobal) {
    places = maxPlaceNumberGlobal;
  }
  if (valueStr != null) {
    //handle minus symbol
    String minusOrEmptyStr = "";
    if (isAllowMinus) {
      final bool isHasMinus = (_handleWithEPlusOrEMinusStr(str: valueStr).indexOf(minusNumberStrGlobal) == 0);
      if (isHasMinus) {
        valueStr = valueStr.substring(1); //example -123 => 123
        minusOrEmptyStr = "-";
      }
    }

    valueStr = formatTextToNumberStrGlobal(valueStr: valueStr, isAllowMinus: false);
    if (valueStr.isNotEmpty) {
      //limit the valueStr
      final bool isLongerThanLimit = (_handleWithEPlusOrEMinusStr(str: valueStr.toString()).length > numberTextLengthGlobal);
      if (isLongerThanLimit) {
        valueStr = _handleWithEPlusOrEMinusStr(str: valueStr.toString()).substring(0, numberTextLengthGlobal);
      }
      if (!isAllowZeroAtLast) {
        final int dotIndex = valueStr.indexOf(".");
        final bool isHasDot = (dotIndex != -1);
        if (isHasDot) {
          final int afterDotLength = valueStr.length - dotIndex;
          final bool isDetectRound = (afterDotLength >= check9And0ForXTimesGlobal);
          if (isDetectRound) {
            for (int afterDotIndex = (dotIndex + 1); afterDotIndex < (valueStr!.length - check9And0ForXTimesGlobal); afterDotIndex++) {
              bool isMatch9 = true;
              for (int check9Index = 0; check9Index < check9And0ForXTimesGlobal; check9Index++) {
                final bool isNotMatch9 = (valueStr[afterDotIndex + check9Index] != "9");
                if (isNotMatch9) {
                  isMatch9 = false;
                  break;
                }
              }
              if (isMatch9) {
                final sumPow = pow(10, -1 * (afterDotIndex - dotIndex + check9And0ForXTimesGlobal - 1));
                valueStr = _handleWithEPlusOrEMinusStr(str: (double.parse(valueStr) + sumPow).toString());
                break;
              }
            }
            for (int afterDotIndex = (dotIndex + 1); afterDotIndex < (valueStr!.length - check9And0ForXTimesGlobal); afterDotIndex++) {
              bool isMatch0 = true;
              for (int check0Index = 0; check0Index < check9And0ForXTimesGlobal; check0Index++) {
                final bool isNotMatch0 = (valueStr[afterDotIndex + check0Index] != "0");
                if (isNotMatch0) {
                  isMatch0 = false;
                  break;
                }
              }
              if (isMatch0) {
                valueStr = valueStr.substring(0, afterDotIndex);
                break;
              }
            }
          }
        }

        final bool isPlacesPositive = (places >= 0);
        if (isPlacesPositive) {
          if (isRound) {
            final int dotIndex = valueStr.indexOf(".");
            final bool isHasDot = (dotIndex != -1);
            if (isHasDot) {
              final bool isAllowRound = (valueStr.length > (dotIndex + 1 + places));
              if (isAllowRound) {
                final num sumPow = pow(10, -1 * places);
                final String beforePlaceValue = valueStr.substring(0, dotIndex + places + 1);
                valueStr = _handleWithEPlusOrEMinusStr(str: (double.parse(beforePlaceValue) + sumPow).toString());
                final bool isAllowSub = (valueStr.length > (dotIndex + 1 + places));
                if (isAllowSub) {
                  valueStr = valueStr.substring(0, dotIndex + places + 1);
                }
              }
            }
          } else {
            final int dotIndex = valueStr.indexOf(".");
            final bool isHasDot = (dotIndex != -1);
            if (isHasDot) {
              final bool isAllowSub = (valueStr.length > (dotIndex + 1 + places));
              if (isAllowSub) {
                valueStr = valueStr.substring(0, dotIndex + places + 1);
              }
            }
          }
        } else {
          final int dotIndex = valueStr.indexOf(".");
          final bool isHasDot = (dotIndex != -1);
          if (isHasDot) {
            valueStr = valueStr.substring(0, dotIndex);
          }
          final bool isAllowSub = (valueStr.length > (-1 * places));
          if (isAllowSub) {
            final String beforePlace = valueStr.substring(0, (valueStr.length - (-1 * places)));
            final String afterPlace = valueStr.substring((valueStr.length - (-1 * places)), valueStr.length);
            final isNotEqual0 = double.parse(afterPlace) != 0;
            if (isHasDot || isNotEqual0) {
              final num multiPow = pow(10, -1 * places);
              valueStr = ((double.parse(beforePlace) + (isRound ? 1 : 0)) * multiPow).toString();
            }
          } else {
            valueStr = "0";
          }
        }

        final int dotIndexSub = valueStr.indexOf(".");
        final bool isHasDotSub = (dotIndexSub != -1);
        if (isHasDotSub) {
          valueStr = double.parse(valueStr).toString();
        }

        final bool isHasConfigPlace = (configPlace != null);
        if (isHasConfigPlace) {
          final int dotIndexFullComma = valueStr.toString().indexOf(".");
          if (dotIndexFullComma != -1) {
            //2 < 4
            if ((valueStr.length - 1) < configPlace) {
              final addZeroTime = configPlace - valueStr.length + 1; //4 - 3 + 1 = 2;
              for (int leftIndex = 0; leftIndex < addZeroTime; leftIndex++) {
                valueStr = "${valueStr}0";
              }
            }
          } else {
            //2 < 4
            if (valueStr.length < configPlace) {
              valueStr = "$valueStr."; //30. //length = 3
              final addZeroTime = configPlace - valueStr.length + 1;
              for (int leftIndex = 0; leftIndex < addZeroTime; leftIndex++) {
                valueStr = "${valueStr}0";
              }
            }
          }
        }
      }
      if (isAddComma) {
        final int dotIndex = valueStr!.indexOf(dotNumberStrGlobal);
        final bool isHasDot = (dotIndex != -1);
        String beforeDotStr = "";
        String afterDotStr = "";
        if (isHasDot) {
          beforeDotStr = valueStr.substring(0, dotIndex);
          afterDotStr = valueStr.substring(dotIndex, valueStr.length);
        } else {
          beforeDotStr = valueStr;
        }
        final RegExp reg = RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"); //regExp add ',' to each 3 length
        valueStr = beforeDotStr.replaceAllMapped(reg, (Match match) => "${match[1]}$commaNumberStrGlobal") + afterDotStr;
      }
      return "$minusOrEmptyStr$valueStr";
    }
  }
  return "";
}

//TODO: create emun for textEditingControllerToDouble and textEditingControllerToInt, then merge them become one
//----------------------TextEditingController to double----------------------
double? textEditingControllerToDouble({required TextEditingController controller}) {
  final bool isStrEmpty = controller.text.isEmpty;
  if (isStrEmpty) {
    return null;
  } else {
    final numberStr = formatTextToNumberStrGlobal(valueStr: controller.text);
    return double.parse(numberStr);
  }
}

//----------------------TextEditingController to int----------------------
int? textEditingControllerToInt({required TextEditingController controller}) {
  final bool isStrEmpty = controller.text.isEmpty;
  if (isStrEmpty) {
    return null;
  } else {
    final numberStr = formatTextToNumberStrGlobal(valueStr: controller.text);
    return int.parse(numberStr);
  }
}

//-------------------------find text size---------------------------------------

Size findTextSize({required String text, required TextStyle style}) {
  final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

// //-----------------------------format date-----------------------------
// String formatDateStr({required DateTime date}) {
//   return dateFullFormat.format(date);
// }

//--------------------------excel------------------------------------------
int lettersToIndex({required String letters}) {
  var result = 0;
  for (var i = 0; i < letters.length; i++) {
    result = result * 26 + (letters.codeUnitAt(i) & 0x1f);
  }
  return result;
}


String indexToLetters({required int index}) {
  if (index <= 0) throw RangeError.range(index, 1, null, "index");
  const _letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  if (index < 27) return _letters[index - 1];
  var letters = <String>[];
  do {
    index -= 1;
    letters.add(_letters[index.remainder(26)]);
    index ~/= 26;
  } while (index > 0);
  return letters.reversed.join("");  
}