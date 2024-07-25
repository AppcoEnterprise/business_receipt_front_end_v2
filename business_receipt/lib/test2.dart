import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:flutter/material.dart';

class Test2 extends StatefulWidget {
  const Test2({super.key});

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  String? selectedStr = "1";
  Level level = Level.normal;
  @override
  Widget build(BuildContext context) {
    Widget textFieldWidget() {
      return textFieldGlobal(
        controller: TextEditingController(),
        labelText: "labelText",
        level: level,
        onChangeFromOutsiderFunction: () {},
        onTapFromOutsiderFunction: () {},
        textFieldDataType: TextFieldDataType.str,
      );
    }

    Widget dropDownWidget() {
      return customDropdown(
        labelStr: "labelStr",
        level: level,
        menuItemStrList: ["1"],
        onChangedFunction: ({required String value, required int index}) {
          selectedStr = value;
          setState(() {});
        },
        onTapFunction: () {},
        selectedStr: selectedStr,
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(children: [
        Row(children: [Expanded(child: dropDownWidget()), Expanded(child: textFieldWidget())]),
        Row(children: [Expanded(child: textFieldWidget()), Expanded(child: textFieldWidget())])
      ]),
    );
  }
}
