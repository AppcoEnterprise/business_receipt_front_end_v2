// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/request_api/salary_request_api_env.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:business_receipt/state/side_menu/set_up_employee_dialog.dart';
import 'package:flutter/material.dart';

class EmployeeAdminSideMenu extends StatefulWidget {
  String title;
  EmployeeAdminSideMenu({Key? key, required this.title}) : super(key: key);

  @override
  State<EmployeeAdminSideMenu> createState() => _EmployeeAdminSideMenuState();
}

class _EmployeeAdminSideMenuState extends State<EmployeeAdminSideMenu> {
  // bool _isLoadingOnGetEmployee = true;
  @override
  void initState() {
    // void initEmployeeToTempDB() {
    //   bool isEmptyEmployee = profileEmployeeModelListAdminGlobal.isEmpty;
    //   if (isEmptyEmployee) {
    //     void callback() {
    //       _isLoadingOnGetEmployee = false;
    //       setState(() {});
    //     }

    //     getEmployeeGlobal(callBack: callback, context: context); //TODO: just comma this
    //   } else {
    //     _isLoadingOnGetEmployee = false;
    //   }
    // }

    // initEmployeeToTempDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void callback() {
      if (mounted) {
        setState(() {});
      }
      // setState(() {});
    }

    Widget loadingOrBody() {
      Widget bodyTemplateSideMenu() {
        void addOnTapFunction() {
          askingForChangeDialogGlobal(
            context: context,
            allowFunction: () => setUpEmployeeDialog(
              isCreateNewEmployee: true,
              profileEmployeeModel: null,
              context: context,
              setState: callback,
              isAdminEditing: true,
              salaryListEmployee: [],
            ),
            editSettingTypeEnum: EditSettingTypeEnum.employee,
          );
        }

        List<Widget> inWrapWidgetList() {
          Widget employeeButtonWidget({required int employeeIndex}) {
            Widget setWidthSizeBox() {
              Widget insideSizeBoxWidget() {
                final DateTime? deleteDateOrNull = profileEmployeeModelListAdminGlobal[employeeIndex].deletedDate;
                Widget employeeNameWidget() {
                  final String employeeName = profileEmployeeModelListAdminGlobal[employeeIndex].name.text;
                  return scrollText(
                    textStr: employeeName,
                    textStyle: textStyleGlobal(
                        level: Level.large, fontWeight: FontWeight.bold, color: (deleteDateOrNull == null) ? defaultTextColorGlobal : deleteTextColorGlobal),
                    alignment: Alignment.center,
                  );
                }

                Widget deleteDateScrollTextWidget() {
                  return (deleteDateOrNull == null)
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)),
                          child: scrollText(
                            textStr: "$deleteAtStrGlobal ${formatFullDateToStr(date: deleteDateOrNull.add(const Duration(days: deleteAtDay)))}",
                            textStyle: textStyleGlobal(level: Level.mini, fontWeight: FontWeight.bold, color: Colors.red),
                            alignment: Alignment.topCenter,
                          ),
                        );
                }

                return Column(mainAxisAlignment: MainAxisAlignment.center, children: [employeeNameWidget(), deleteDateScrollTextWidget()]);
              }

              void onTapUnlessDisable() {
                askingForChangeDialogGlobal(
                  context: context,
                  allowFunction: () {
                    limitHistory();
                    ProfileEmployeeModel profileEmployeeCloneModel =
                        profileEmployeeModelClone(profileEmployeeModel: profileEmployeeModelListAdminGlobal[employeeIndex]);
                    // profileEmployeeCloneModel.salaryList = [];
                    // void callBack() {
                      setUpEmployeeDialog(
                        isCreateNewEmployee: false,
                        profileEmployeeModel: profileEmployeeCloneModel,
                        context: context,
                        setState: callback,
                        isAdminEditing: true,
                        salaryListEmployee: profileEmployeeCloneModel.salaryList,
                      );
                    // }

                    // getSalaryListEmployeeGlobal(
                    //   targetDate: DateTime.now(),
                    //   callBack: callBack,
                    //   context: context,
                    //   employeeId: profileEmployeeCloneModel.id!,
                    //   // salaryListEmployee: profileEmployeeCloneModel.salaryList,
                    //   salaryListEmployee: profileEmployeeCloneModel.salaryList.first.subSalaryList,
                    //   skip: 0,
                    // );
                  },
                  editSettingTypeEnum: EditSettingTypeEnum.employee,
                  employeeId: profileEmployeeModelListAdminGlobal[employeeIndex].id,
                );
              }

              return CustomButtonGlobal(
                  sizeBoxWidth: sizeBoxWidthGlobal,
                  sizeBoxHeight: sizeBoxHeightGlobal,
                  insideSizeBoxWidget: insideSizeBoxWidget(),
                  onTapUnlessDisable: onTapUnlessDisable);
            }

            return setWidthSizeBox();
          }

          return [
            for (int profileEmployeeListIndex = 0; profileEmployeeListIndex < profileEmployeeModelListAdminGlobal.length; profileEmployeeListIndex++)
              employeeButtonWidget(employeeIndex: profileEmployeeListIndex)
          ];
        }

        return BodyTemplateSideMenu(
          addOnTapFunction: addOnTapFunction,
          inWrapWidgetList: inWrapWidgetList(),
          title: widget.title,
          currentAddButtonQty: profileEmployeeModelListAdminGlobal.length,
          maxAddButtonLimit: employeeAddButtonLimitGlobal,
        );
      }

      return bodyTemplateSideMenu();
    }

    return loadingOrBody();
  }
}
