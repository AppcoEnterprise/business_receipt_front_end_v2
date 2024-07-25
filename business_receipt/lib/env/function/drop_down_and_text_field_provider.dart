// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/sort.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:flutter/material.dart';

//sometime selectedStr can equal "Other"
class DropDownAndTextFieldProviderGlobal extends StatefulWidget {
  Level level;
  String labelStr;
  Function onTapFunction;
  Function onChangedDropDrownFunction;
  Function onDeleteFunction;
  String? selectedStr;
  List<String> menuItemStrList;
  String? suffixText;
  FocusNode? focusNode;
  bool isEnabled;
  bool isSort;
  TextFieldDataType textFieldDataType;
  TextEditingController? controller;
  double? textFieldWidth;
  bool isShowTextField;
  Function onChangedTextFieldFunction;
  DropDownAndTextFieldProviderGlobal({
    Key? key,
    required this.onDeleteFunction,
    required this.onTapFunction,
    required this.onChangedTextFieldFunction,
    required this.onChangedDropDrownFunction,
    required this.level,
    required this.labelStr,
     this.isSort = true,
    required this.selectedStr,
    required this.menuItemStrList,
    this.suffixText,
    this.focusNode,
    this.isEnabled = true,
    required this.textFieldDataType,
    this.controller,
    this.textFieldWidth,
    this.isShowTextField = false,
  }) : super(key: key);

  @override
  State<DropDownAndTextFieldProviderGlobal> createState() => _DropDownAndTextFieldProviderGlobalState();
}

class _DropDownAndTextFieldProviderGlobalState extends State<DropDownAndTextFieldProviderGlobal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> menuItemStrListTemp = [];
    menuItemStrListTemp.addAll(widget.menuItemStrList);
    if (widget.isSort) {
      menuItemStrListTemp = sortStrListToStrListGlobal(strList: menuItemStrListTemp);
    }
    if (widget.isEnabled) {
      menuItemStrListTemp.add(otherStrGlobal);
    }

    Widget dropDownAndTextFieldProvider() {
      Widget insideSizeBoxWidget() {
        Widget setUpTextFieldWidget() {
          final bool isControllerNotNull = (widget.controller != null);
          TextEditingController controllerProvider() {
            return isControllerNotNull ? widget.controller! : TextEditingController();
          }

          return textFieldGlobal(
            textFieldDataType: widget.textFieldDataType,
            controller: controllerProvider(),
            isEnabled: (isControllerNotNull && widget.isEnabled),
            onChangeFromOutsiderFunction: widget.onChangedTextFieldFunction,
            labelText: widget.labelStr,
            level: widget.level,
            onTapFromOutsiderFunction: widget.onTapFunction,
          );
        }

        Widget setUpCustomDropWidget() {
          return customDropdown(
            level: widget.level,
            labelStr: widget.labelStr,
            onTapFunction: widget.onTapFunction,
            onChangedFunction: widget.onChangedDropDrownFunction,
            selectedStr: widget.selectedStr,
            menuItemStrList: menuItemStrListTemp,
          );
        }

        return widget.isShowTextField ? setUpTextFieldWidget() : setUpCustomDropWidget();
      }

      Function? deleteButtonProvideFunction() {
        return (widget.isShowTextField && widget.isEnabled) ? widget.onDeleteFunction : null;
      }

      return CustomButtonGlobal(
        insideSizeBoxWidget: insideSizeBoxWidget(),
        onTapUnlessDisable: widget.onTapFunction,
        isDisable: true,
        isHasSubOnTap: true,
        level: widget.level,
        onDeleteUnlessDisable: deleteButtonProvideFunction(),
      );
    }

    return dropDownAndTextFieldProvider();
  }
}
