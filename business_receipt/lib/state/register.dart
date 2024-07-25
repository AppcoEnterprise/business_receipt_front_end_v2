// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/refresh_page_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/function/request_api/account_request_api_env.dart';
import 'package:business_receipt/env/function/text/text_area_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/profile_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  String name;
  String password;
  Function callbackSignInAsAdmin;
  Register({super.key, required this.callbackSignInAsAdmin, required this.name, required this.password});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProfileAdminModel profileAdminModelTemp = ProfileAdminModel(
        name: TextEditingController(text: widget.name),
        bio: TextEditingController(),
        password: TextEditingController(text: widget.password),
      );
      TextEditingController confirmPasswordController = TextEditingController();
      TextEditingController secretWordController = TextEditingController();
      Widget contentDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
        // Widget createButton() {

        //   return createButtonOrContainerWidget(
        //     level: Level.normal,
        //     isValid: getValid(),
        //     isExpanded: true,
        //     onTapFunction: onTapFunction,
        //   );
        // }

        Widget paddingBottomTextTitle({required String textStr}) {
          Text text() {
            return Text(textStr, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold));
          }

          return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)), child: text());
        }

        Widget paddingVerticalTextField({required String labelText, required TextEditingController controller}) {
          Widget textField() {
            void onTapFromOutsiderFunction() {}
            return textFieldGlobal(
              level: Level.normal,
              controller: controller,
              onChangeFromOutsiderFunction: () {
                setStateFromDialog(() {});
              },
              labelText: labelText,
              textFieldDataType: TextFieldDataType.str,
              onTapFromOutsiderFunction: onTapFromOutsiderFunction,
            );
          }

          return Padding(padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.normal)), child: textField());
        }

        Widget paddingVerticalTextArea({required String labelText, required TextEditingController controller}) {
          Widget textField() {
            void onTapFromOutsiderFunction() {}
            return textAreaGlobal(
              controller: controller,
              onChangeFromOutsiderFunction: () {
                setStateFromDialog(() {});
              },
              labelText: labelText,
              level: Level.normal,
              onTapFromOutsiderFunction: onTapFromOutsiderFunction,
            );
          }

          return Padding(padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.normal)), child: textField());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            paddingBottomTextTitle(textStr: createNewAdminStrGlobal),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    paddingVerticalTextField(labelText: adminNameStrGlobal, controller: profileAdminModelTemp.name),
                    paddingVerticalTextField(labelText: passwordStrGlobal, controller: profileAdminModelTemp.password),
                    paddingVerticalTextField(labelText: confirmPasswordStrGlobal, controller: confirmPasswordController),
                    paddingVerticalTextField(labelText: secretWordStrGlobal, controller: secretWordController),
                    paddingVerticalTextArea(labelText: bioStrGlobal, controller: profileAdminModelTemp.bio),
                  ],
                ),
              ),
            ),
            // createButton(),
          ],
        );
      }

      ValidButtonModel getValid() {
        // if (profileAdminModelTemp.name.text.isNotEmpty &&
        //     profileAdminModelTemp.password.text.isNotEmpty &&
        //     confirmPasswordController.text.isNotEmpty &&
        //     secretWordController.text.isNotEmpty) {
        //   if (profileAdminModelTemp.password.text != confirmPasswordController.text) {
        //     return ValidButtonModel(isValid: false, error: "Password and Confirm Password must be the same");
        //   }

        //   if (secretWordController.text != createAdminCodeGlobal) {
        //     return ValidButtonModel(isValid: false, error: "Secret Word is not valid");
        //   }
        //   // return true;
        //   return ValidButtonModel(isValid: true);
        // }
        // return ValidButtonModel(isValid: false, error: "Please fill all the fields");

        // if (profileAdminModelTemp.name.text.isNotEmpty &&
        //     profileAdminModelTemp.password.text.isNotEmpty &&
        //     confirmPasswordController.text.isNotEmpty &&
        //     secretWordController.text.isNotEmpty) {
        if (profileAdminModelTemp.name.text.isEmpty) {
          return ValidButtonModel(isValid: false, error: "admin name is empty", errorType: ErrorTypeEnum.valueOfString);
        }
        if (profileAdminModelTemp.password.text.isEmpty) {
          return ValidButtonModel(isValid: false, error: "password is empty", errorType: ErrorTypeEnum.valueOfString);
        }
        if (confirmPasswordController.text.isEmpty) {
          return ValidButtonModel(isValid: false, error: "confirm password is empty", errorType: ErrorTypeEnum.valueOfString);
        }
        if (secretWordController.text.isEmpty) {
          return ValidButtonModel(isValid: false, error: "secret word is empty", errorType: ErrorTypeEnum.valueOfString);
        }
        if (profileAdminModelTemp.password.text != confirmPasswordController.text) {
          return ValidButtonModel(isValid: false, error: "Password and Confirm Password must be the same");
        }

        if (secretWordController.text != createAdminCodeGlobal) {
          return ValidButtonModel(isValid: false, error: "Secret Word is not valid");
        }
        // return true;
        return ValidButtonModel(isValid: true);
      }

      void onTapFunction() {
        if (getValid().isValid) {
          LocalStorageHelper.clearAll();
          registerAdminGlobal(
            profileAdminModel: profileAdminModelTemp,
            callBack: () {
              closeDialogGlobal(context: context);
              widget.callbackSignInAsAdmin();
            },
            context: context,
          );
        }
      }

      void cancelFunctionOnTap() {
        refreshPageGlobal();
      }

      actionDialogSetStateGlobal(
        context: context,
        contentFunctionReturnWidget: contentDialog,
        dialogHeight: dialogSizeGlobal(level: Level.mini),
        dialogWidth: dialogSizeGlobal(level: Level.mini),
        saveFunctionOnTap: onTapFunction,
        validSaveButtonFunction: () => getValid(),
        cancelFunctionOnTap: cancelFunctionOnTap,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget backgroundImageAndDialog() {
      BoxDecoration backgroundImage() {
        return const BoxDecoration(image: DecorationImage(image: AssetImage(registerBackgroundImageGlobal), fit: BoxFit.cover));
      }

      return Scaffold(body: Container(margin: EdgeInsets.zero, decoration: backgroundImage()));
    }

    return backgroundImageAndDialog();
  }
}
