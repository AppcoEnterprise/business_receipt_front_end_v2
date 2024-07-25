import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/override_lib/dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

const List<double> _textLabelSizeGlobalList = [17, 12, 10];
const List<double> _positionTopGlobalList = [-9, -4, -3];
const List<double> _dropdownButtonHeightGlobalList = [65, 55, 43];
double _textLabelSize({required Level level}) {
  int indexLevel({required Level level}) {
    return level.index;
  }

  return _textLabelSizeGlobalList[indexLevel(level: level)];
}

double _positionTopLabel({required Level level}) {
  int indexLevel({required Level level}) {
    return level.index;
  }

  return _positionTopGlobalList[indexLevel(level: level)];
}

double _dropdownButtonHeight({required Level level}) {
  int indexLevel({required Level level}) {
    return level.index;
  }

  return _dropdownButtonHeightGlobalList[indexLevel(level: level)];
}

// void onChange({required String value, required int index}) {...}
Widget customDropdown({
  required Level level,
  required String labelStr,
  required Function onTapFunction,
  required Function onChangedFunction,
  required String? selectedStr,
  required List<String> menuItemStrList,
}) {
List<String> menuItemStrListTemp = [];
  for(int menuIndex = 0; menuIndex < menuItemStrList.length; menuIndex++) {
    if(!menuItemStrListTemp.contains(menuItemStrList[menuIndex])) {
      menuItemStrListTemp.add(menuItemStrList[menuIndex]);
    }
  }
  DropdownButtonHideUnderline insideDropdown() {
    BoxDecoration boxDecoration() {
      return const BoxDecoration(color: textFieldOnFooterColorGlobal, borderRadius: BorderRadius.all(Radius.circular(borderRadiusGlobal)));
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        onTap: onTapFunction,
        buttonDecoration: boxDecoration(),
        hint: Text(labelStr, style: textStyleGlobal(level: level, color: defaultTextFieldNoFucusColorGlobal)),
        items: [
          for (int menuItemStrIndex = 0; menuItemStrIndex < menuItemStrListTemp.length; menuItemStrIndex++)
            DropdownMenuItem(value: menuItemStrListTemp[menuItemStrIndex], child: Text(menuItemStrListTemp[menuItemStrIndex], style: textStyleGlobal(level: level)))
        ],
        style: textStyleGlobal(level: level),
        value: (selectedStr == emptyStrGlobal) ? null : selectedStr,
        onChanged: (value) {
          final bool isNotSameSelected = (selectedStr != value);
          if (isNotSameSelected) {
            int getIndexByStr() {
              for (int menuItemStrIndex = 0; menuItemStrIndex < menuItemStrListTemp.length; menuItemStrIndex++) {
                String menuItemStr = menuItemStrListTemp[menuItemStrIndex];
                final bool isMatchMenuItem = (menuItemStr == value);
                if (isMatchMenuItem) {
                  return menuItemStrIndex;
                }
              }
              return -1;
            }

            onChangedFunction(value: value, index: getIndexByStr());
          }
        },
      ),
    );
  }

  Widget stackLabelOnDropdown() {
    Widget setHeight() {
      Widget cardWidget() {
        ShapeBorder shape() {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusGlobal),
            side: const BorderSide(color: borderSideGlobal),
          );
        }

        Widget paddingAndInsideWidget() {
          return Padding(padding: const EdgeInsets.symmetric(horizontal: textFieldPaddingOnLeftGlobal), child: insideDropdown());
        }

        return Card(margin: EdgeInsets.zero, shape: shape(), color: textFieldOnFooterColorGlobal, child: paddingAndInsideWidget());
      }

      return SizedBox(height: _dropdownButtonHeight(level: level), child: cardWidget());
    }

    Widget overwriteOnDropdown() {
      Widget setPositionedWidget() {
        Widget setColorContainerWidget() {
          Widget paddingTextWidget() {
            Widget textWidget() {
              return Text(labelStr, style: TextStyle(fontSize: _textLabelSize(level: level), color: texFieldBorderColorGlobal));
            }

            return Padding(padding: const EdgeInsets.symmetric(horizontal: systemTextFieldPaddingGlobal), child: textWidget());
          }

          return Container(margin: EdgeInsets.zero, color: textFieldOnFooterColorGlobal, child: paddingTextWidget());
        }

        return Positioned(top: _positionTopLabel(level: level), left: textFieldPaddingOnLeftGlobal - systemTextFieldPaddingGlobal, child: setColorContainerWidget());
      }

      final bool isSelectedStrNull = (selectedStr == null);
      final bool isMenuItemStrListEmpty = menuItemStrListTemp.isEmpty;
      if (isMenuItemStrListEmpty || isSelectedStrNull) {
        return Container();
      } else {
        final bool isSelectedStrEmpty = selectedStr.isEmpty;
        if (isSelectedStrEmpty) {
          return Container();
        } else {
          return setPositionedWidget();
        }
      }

      // return menuItemStrList.isEmpty ? Container() : setPositionedWidget();
    }

    return Stack(children: <Widget>[setHeight(), overwriteOnDropdown()]);
  }

  return stackLabelOnDropdown();
}
