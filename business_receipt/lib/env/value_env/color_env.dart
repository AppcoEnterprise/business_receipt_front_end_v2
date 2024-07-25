import 'package:flutter/material.dart';

//--------------------------option text and icon----------------
final Color optionTextAndIconColorGlobal = Colors.grey[600]!;
final Color optionBackgroundColor = Colors.grey[200]!;
const Color optionContainerColor = Colors.white;

//------------------border side----------------
const Color borderSideGlobal = Colors.grey;

//------------------button background----------------
const Color defaultButtonColorGlobal = Colors.blue;
final Color forceToChangeButtonColorGlobal = Colors.blue[700]!;
const Color hoverFocusClickButtonColorGlobal = Colors.white;
const Color widgetButtonColorGlobal = Colors.white;
const Color disableButtonColorGlobal = Colors.grey;
const Color signOutButtonColorGlobal = Colors.red;
const Color deleteButtonColorGlobal = Colors.red;
final Color clearButtonColorGlobal = Colors.red[400]!;
const Color restoreButtonColorGlobal = Colors.blue;
const Color closeSellingButtonColorGlobal = Colors.red;
final Color cancelButtonColorGlobal = Colors.grey[600]!;
final Color saveAndPrintButtonColorGlobal = Colors.blue[700]!;
const Color addButtonColorGlobal = Colors.green;
const Color nextButtonColorGlobal = Colors.green;
final Color acceptSuggestButtonColorGlobal = Colors.yellow[800]!;

//------------------config button----------------
const Color defaultConfigButtonColorGlobal = Colors.white;

//------------------text----------------
const Color defaultTextColorGlobal = Colors.black;
const Color defaultTextFieldNoFucusColorGlobal = Colors.grey;
const Color textButtonColorGlobal = Colors.white;
const Color positiveColorGlobal = Colors.green;
const Color negativeColorGlobal = Colors.red;
final Color warningTextColorGlobal = Colors.yellow[600]!;
const Color deleteTextColorGlobal = Colors.red;

//------------------icon----------------
const Color buttonIconColorGlobal = Colors.white;

//-------------------slider---------------------------------------------
const Color leftSliderColorGlobal = Colors.red;
const Color rightSliderColorGlobal = Colors.blue;
const Color notUsedSliderChooseColorGlobal = Colors.grey;

//-------------------table---------------------------------------------
const Color headerColorGlobal = Colors.grey;
const Color bodyColorGlobal = Colors.white;
const Color footerColorGlobal = Colors.blue;

//-----------------------transparent---------------------------------
const Color transparentColorGlobal = Colors.transparent;

//-------------------spin kit-----------------------------------
const Color spinKitColorGlobal = Colors.blue;

//-------------------------textField background-------------------
const Color textFieldOnFooterColorGlobal = Colors.white;

//-------------------------textField border-------------------
const Color texFieldBorderColorGlobal = Colors.grey;

//-------------------------toggle-------------------
final Color toggleShowColorGlobal = Colors.green[800]!;
final Color toggleHideColorGlobal = Colors.red[800]!;
const Color toggleBackgroundColorGlobal = Colors.grey;
const Color toggleTextColorGlobal = Colors.white;
const Color toggleSeparateAndMergeColorGlobal = Colors.blue;
const Color toggleFormatAndAccurateColorGlobal = Colors.blue;

const Color toggleSimpleOrAdvanceSalaryColorGlobal = Colors.blue;

//-------------------done---------------------------
const Color doneTextColorGlobal = Colors.green;





List<String> _colorStrList = [
  "green",
  "blue",
  "red",
  "white",
  "black",
  "grey",
];

enum ColorEnum {
  green,
  blue,
  red,
  white,
  black,
  grey,
}


List<Color> _colorList = [
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.white,
  Colors.black,
  Colors.grey,
];

String getColorEnumToString({required ColorEnum colorEnum}) {
  int indexLevel({required ColorEnum subColorEnum}) {
    return subColorEnum.index;
  }

  return _colorStrList[indexLevel(subColorEnum: colorEnum)];
}

ColorEnum getColorStringToEnum({required String colorString}) {
  int indexLevel({required String subColorString}) {
    return _colorStrList.indexOf(subColorString);
  }

  return ColorEnum.values[indexLevel(subColorString: colorString)];
}

Color getColorEnumToColors({required ColorEnum colorEnum}) {
  int indexLevel({required ColorEnum subColorEnum}) {
    return subColorEnum.index;
  }

  return _colorList[indexLevel(subColorEnum: colorEnum)];
}
