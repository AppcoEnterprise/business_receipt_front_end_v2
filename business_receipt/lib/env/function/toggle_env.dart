import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

Widget _customToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
  required double minWidth,
  required double minHeight,
  required Color firstColor,
  required Color lastColor,
  required String firstStr,
  required String lastStr,
}) {
  return ToggleSwitch(
    minWidth: minWidth,
    minHeight: minHeight,
    cornerRadius: borderRadiusGlobal,
    activeBgColors: [
      [firstColor],
      [lastColor]
    ],
    activeFgColor: toggleTextColorGlobal,
    inactiveBgColor: toggleBackgroundColorGlobal,
    inactiveFgColor: toggleTextColorGlobal,
    initialLabelIndex: isLeftSelected ? 0 : 1,
    totalSwitches: 2,
    labels: [firstStr, lastStr],
    radiusStyle: true,
    onToggle: (_) {
      onToggle();
    },
  );
}

Widget showAndHideToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  // return ToggleSwitch(
  //   minWidth: 55,
  //   minHeight: 25,
  //   cornerRadius: borderRadiusGlobal,
  //   activeBgColors: [
  //     [toggleFirstColorGlobal],
  //     [toggleLastColorGlobal]
  //   ],
  //   activeFgColor: toggleTextColorGlobal,
  //   inactiveBgColor: toggleBackgroundColorGlobal,
  //   inactiveFgColor: toggleTextColorGlobal,
  //   initialLabelIndex: isShow ? 0 : 1,
  //   totalSwitches: 2,
  //   labels: const [showStr, hideStr],
  //   radiusStyle: true,
  //   onToggle: (_) {
  //     onToggle();
  //   },
  // );
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: toggleHeightGlobal,
    minWidth: toggleShowAndHideWidthGlobal,
    onToggle: onToggle,
    firstColor: toggleShowColorGlobal,
    lastColor: toggleHideColorGlobal,
    firstStr: showStrGlobal,
    lastStr: hideStrGlobal,
  );
}

Widget separateAndMergeToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  // return ToggleSwitch(
  //   minWidth: 55,
  //   minHeight: 25,
  //   cornerRadius: borderRadiusGlobal,
  //   activeBgColors: [
  //     [toggleFirstColorGlobal],
  //     [toggleLastColorGlobal]
  //   ],
  //   activeFgColor: toggleTextColorGlobal,
  //   inactiveBgColor: toggleBackgroundColorGlobal,
  //   inactiveFgColor: toggleTextColorGlobal,
  //   initialLabelIndex: isShow ? 0 : 1,
  //   totalSwitches: 2,
  //   labels: const [showStr, hideStr],
  //   radiusStyle: true,
  //   onToggle: (_) {
  //     onToggle();
  //   },
  // );
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: toggleHeightGlobal,
    minWidth: toggleSeparateAndMergeWidthGlobal,
    onToggle: onToggle,
    firstColor: toggleSeparateAndMergeColorGlobal,
    lastColor: toggleSeparateAndMergeColorGlobal,
    firstStr: separateStrGlobal,
    lastStr: mergeStrGlobal,
  );
}

Widget borrowAndLendToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: toggleHeightGlobal,
    minWidth: toggleBorrowAndLendWidthGlobal,
    onToggle: onToggle,
    firstColor: positiveColorGlobal,
    lastColor: negativeColorGlobal,
    firstStr: lendStrGlobal,
    lastStr: borrowStrGlobal,
  );
}

Widget incomeOrOutcomeToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: toggleHeightGlobal,
    minWidth: toggleInOrOutComeWidthGlobal,
    onToggle: onToggle,
    firstColor: positiveColorGlobal,
    lastColor: negativeColorGlobal,
    firstStr: incomeStrGlobal,
    lastStr: outcomeStrGlobal,
  );
}

Widget transferOrReceiveToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: toggleHeightGlobal,
    minWidth: transferOrReceiveWidthGlobal,
    onToggle: onToggle,
    firstColor: positiveColorGlobal,
    lastColor: negativeColorGlobal,
    firstStr: transferStrGlobal,
    lastStr: receiveStrGlobal,
  );
}

Widget bankOrCashToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: toggleHeightGlobal,
    minWidth: bankOrCashWidthGlobal,
    onToggle: onToggle,
    firstColor: toggleSeparateAndMergeColorGlobal,
    lastColor: toggleSeparateAndMergeColorGlobal,
    firstStr: bankStrGlobal,
    lastStr: cashStrGlobal,
  );
}

Widget ownOrOtherBankToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: toggleHeightGlobal,
    minWidth: ownOrOtherBankWidthGlobal,
    onToggle: onToggle,
    firstColor: toggleSeparateAndMergeColorGlobal,
    lastColor: toggleSeparateAndMergeColorGlobal,
    firstStr: otherBankStrGlobal,
    lastStr: ownBankStrGlobal,
  );
  // return Container();
}

Widget singleToggleGlobal({required String singleOptionStr, required Color color}) {
  // return ToggleSwitch(
  //   minWidth: toggleSingleOptionWidthGlobal,
  //   minHeight: toggleHeightGlobal,
  //   cornerRadius: borderRadiusGlobal,
  //   activeBgColors: [
  //     [color],
  //   ],
  //   activeFgColor: toggleTextColorGlobal,
  //   inactiveBgColor: toggleBackgroundColorGlobal,
  //   inactiveFgColor: toggleTextColorGlobal,
  //   // initialLabelIndex: 0,
  //   totalSwitches: 1,
  //   labels: [singleOptionStr, ""],
  //   radiusStyle: true,
  //   onToggle: (_) {},
  // );
  Widget insideSizeBoxWidget() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      child: Text(singleOptionStr, style: textStyleGlobal(level: Level.mini, color: Colors.white)),
    );
  }

  return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadiusGlobal), color: color) , child: insideSizeBoxWidget());
}

Widget operatorToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  // return ToggleSwitch(
  //   minWidth: 55,
  //   minHeight: 25,
  //   cornerRadius: borderRadiusGlobal,
  //   activeBgColors: [
  //     [toggleFirstColorGlobal],
  //     [toggleLastColorGlobal]
  //   ],
  //   activeFgColor: toggleTextColorGlobal,
  //   inactiveBgColor: toggleBackgroundColorGlobal,
  //   inactiveFgColor: toggleTextColorGlobal,
  //   initialLabelIndex: isShow ? 0 : 1,
  //   totalSwitches: 2,
  //   labels: const [showStr, hideStr],
  //   radiusStyle: true,
  //   onToggle: (_) {
  //     onToggle();
  //   },
  // );
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: toggleHeightGlobal,
    minWidth: toggleOperatorWidthGlobal,
    onToggle: onToggle,
    firstColor: toggleShowColorGlobal,
    lastColor: toggleHideColorGlobal,
    firstStr: plusNumberStrGlobal,
    lastStr: minusNumberStrGlobal,
  );
}

Widget roundToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  // return ToggleSwitch(
  //   minWidth: 55,
  //   minHeight: 25,
  //   cornerRadius: borderRadiusGlobal,
  //   activeBgColors: [
  //     [toggleFirstColorGlobal],
  //     [toggleLastColorGlobal]
  //   ],
  //   activeFgColor: toggleTextColorGlobal,
  //   inactiveBgColor: toggleBackgroundColorGlobal,
  //   inactiveFgColor: toggleTextColorGlobal,
  //   initialLabelIndex: isShow ? 0 : 1,
  //   totalSwitches: 2,
  //   labels: const [showStr, hideStr],
  //   radiusStyle: true,
  //   onToggle: (_) {
  //     onToggle();
  //   },
  // );
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: toggleHeightGlobal,
    minWidth: toggleRoundAndShortWidthGlobal,
    onToggle: onToggle,
    firstColor: toggleShowColorGlobal,
    lastColor: toggleHideColorGlobal,
    firstStr: roundStrGlobal,
    lastStr: shortStrGlobal,
  );
}

Widget formatOrAccurateToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: formatOrAccurateHeightGlobal,
    minWidth: formatOrAccurateWidthGlobal,
    onToggle: onToggle,
    firstColor: toggleFormatAndAccurateColorGlobal,
    lastColor: toggleFormatAndAccurateColorGlobal,
    firstStr: formatStrGlobal,
    lastStr: accurateStrGlobal,
  );
}

Widget normalOrBoldToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: toggleHeightGlobal,
    minWidth: bankOrCashWidthGlobal,
    onToggle: onToggle,
    firstColor: toggleSeparateAndMergeColorGlobal,
    lastColor: toggleSeparateAndMergeColorGlobal,
    firstStr: normalStrGlobal,
    lastStr: boldStrGlobal,
  );
}

Widget normalOrUnderlineToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: toggleHeightGlobal,
    minWidth: bankOrCashWidthGlobal,
    onToggle: onToggle,
    firstColor: toggleSeparateAndMergeColorGlobal,
    lastColor: toggleSeparateAndMergeColorGlobal,
    firstStr: normalStrGlobal,
    lastStr: underlineStrGlobal,
  );
}

Widget textOrTextfieldToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: toggleHeightGlobal,
    minWidth: bankOrCashWidthGlobal,
    onToggle: onToggle,
    firstColor: toggleSeparateAndMergeColorGlobal,
    lastColor: toggleSeparateAndMergeColorGlobal,
    firstStr: textStrGlobal,
    lastStr: textfieldStrGlobal,
  );
}

Widget simpleOrAdvanceSalaryToggleWidgetGlobal({
  required bool isLeftSelected,
  required Function onToggle,
}) {
  return _customToggleWidgetGlobal(
    isLeftSelected: isLeftSelected,
    minHeight: simpleOrAdvanceSalaryHeightGlobal,
    minWidth: simpleOrAdvanceSalaryWidthGlobal,
    onToggle: onToggle,
    firstColor: toggleSimpleOrAdvanceSalaryColorGlobal,
    lastColor: toggleSimpleOrAdvanceSalaryColorGlobal,
    firstStr: simpleStrGlobal,
    lastStr: advanceStrGlobal,
  );
}
