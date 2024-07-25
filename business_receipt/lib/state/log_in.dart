// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/button/button_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/request_api/account_request_api_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/text_limit.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/env/value_env/version.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogIn extends StatefulWidget {
  BuildContext providerContext;
  Function callbackSignInAsAdmin;
  Function callbackSignInAsEmployee;
  LogIn({super.key, required this.callbackSignInAsAdmin, required this.callbackSignInAsEmployee, required this.providerContext});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final TextEditingController controllerAdminName = TextEditingController(text: getAdminNameFromLocalStorage());
      final TextEditingController controllerAdminPassword = TextEditingController(text: getAdminPasswordFromLocalStorage());

      final TextEditingController controllerEmployeeName = TextEditingController(text: getEmployeeNameFromLocalStorage());
      final TextEditingController controllerEmployeePassword = TextEditingController(text: getEmployeePasswordFromLocalStorage());
      Widget contentDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
        Widget paddingTextTitle({required String textStr}) {
          Text text() {
            return Text(textStr, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold));
          }

          return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: text());
        }

        Widget paddingTextField({required String labelText, required TextEditingController controller, required int maxTextLength, required bool obscureText}) {
          Widget textField() {
            void onTapFromOutsiderFunction() {}
            return textFieldGlobal(
              isUsernameOrPassword: true,
              obscureText: obscureText,
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

          return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: textField());
        }

        Widget paddingSignInAdminButton() {
          ValidButtonModel validModel() {
            if (controllerAdminName.text.isEmpty) {
              return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "admin name is empty.");
            }
            if (controllerAdminPassword.text.isEmpty) {
              return ValidButtonModel(
                  isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "admin password is empty.");
            }
            return ValidButtonModel(isValid: true);
          }
          void onPressed() {
            if (validModel().isValid) {
              void callback({required bool isExistingAdmin}) {
                if (isExistingAdmin) {
                  //--- trigger Password Save
                  TextInput.finishAutofillContext();

                  //--- OR ----
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return Container();
                  }));
                }
                widget.callbackSignInAsAdmin(
                    adminName: controllerAdminName.text, adminPassword: controllerAdminPassword.text, isExistingAdmin: isExistingAdmin);
                closeDialogGlobal(context: context);
              }

              logInAsAdminGlobal(adminName: controllerAdminName.text, password: controllerAdminPassword.text, callBack: callback, context: context);
            }
          }

          return Padding(
            padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)),
            child: buttonGlobal(context: context,
              icon: Icons.login,
              validModel: validModel(),
              textStr: signInAsAdminStrGlobal,
              onTapUnlessDisableAndValid: onPressed,
              level: Level.normal,
            ),
          );
        }

        Widget paddingSignInEmployeeButton() {
          ValidButtonModel validModel() {
            if (controllerEmployeeName.text.isEmpty) {
              return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "employee name is empty.");
            }
            if (controllerEmployeePassword.text.isEmpty) {
              return ValidButtonModel(
                  isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "employee password is empty.");
            }
            return ValidButtonModel(isValid: true);
          }

          void onPressed() {
            if (validModel().isValid) {
              void callback() {
                //--- trigger Password Save
                TextInput.finishAutofillContext();

                //--- OR ----
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return Container();
                }));
                widget.callbackSignInAsEmployee();
                closeDialogGlobal(context: context);
              }

              logInAsEmployeeGlobal(name: controllerEmployeeName.text, password: controllerEmployeePassword.text, callBack: callback, context: context);
            }
          }

          return Padding(
            padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)),
            child: buttonGlobal(context: context,
                icon: Icons.login, validModel: validModel(), textStr: signInAsEmployeeStrGlobal, onTapUnlessDisableAndValid: onPressed, level: Level.normal),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              paddingTextTitle(textStr: signInAsAdminStrGlobal),
              AutofillGroup(
                child: Column(
                  children: [
                    paddingTextField(labelText: adminNameStrGlobal, controller: controllerAdminName, maxTextLength: nameTextLengthGlobal, obscureText: false),
                    paddingTextField(
                        labelText: passwordStrGlobal, controller: controllerAdminPassword, maxTextLength: passwordTextLengthGlobal, obscureText: true),
                  ],
                ),
              ),
              paddingSignInAdminButton(),
              paddingTextTitle(textStr: signInAsEmployeeStrGlobal),
              AutofillGroup(
                child: Column(
                  children: [
                    paddingTextField(
                        labelText: employeeNameStrGlobal, controller: controllerEmployeeName, maxTextLength: nameTextLengthGlobal, obscureText: false),
                    paddingTextField(
                        labelText: passwordStrGlobal, controller: controllerEmployeePassword, maxTextLength: passwordTextLengthGlobal, obscureText: true),
                  ],
                ),
              ),
              paddingSignInEmployeeButton(),
              Text(versionDate, style: textStyleGlobal(level: Level.mini)),
            ],
          ),
        );
      }

      actionDialogSetStateGlobal(
        context: widget.providerContext,
        contentFunctionReturnWidget: contentDialog,
        dialogHeight: dialogSizeGlobal(level: Level.mini),
        dialogWidth: dialogSizeGlobal(level: Level.mini),
      );
    });
  }

  Widget _backgroundImageAndDialog() {
    BoxDecoration backgroundImage() {
      return const BoxDecoration(image: DecorationImage(image: AssetImage(businessBackgroundImageGlobal), fit: BoxFit.cover));
    }

    return Scaffold(body: Container(margin: EdgeInsets.zero, decoration: backgroundImage()));
  }

  @override
  Widget build(BuildContext context) {
    return _backgroundImageAndDialog();
  }
}
