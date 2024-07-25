import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/request_api/excel_request_api_env.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_area_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:business_receipt/state/side_menu/set_up_excel_dialog.dart';
import 'package:flutter/material.dart';

class ImportFromExcelAdmin extends StatefulWidget {
  final String title;
  const ImportFromExcelAdmin({super.key, required this.title});

  @override
  State<ImportFromExcelAdmin> createState() => _ImportFromExcelAdminState();
}

class _ImportFromExcelAdminState extends State<ImportFromExcelAdmin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      List<Widget> inWrapWidgetList() {
        Widget customerButtonWidget({required int excelIndex}) {
          Widget setWidthSizeBox() {
            Widget insideSizeBoxWidget() {
              final DateTime? deleteDateOrNull = excelAdminModelListGlobal[excelIndex].deletedDate;

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

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    excelAdminModelListGlobal[excelIndex].excelName.text,
                    style: textStyleGlobal(
                        level: Level.large, fontWeight: FontWeight.bold, color: (deleteDateOrNull == null) ? defaultTextColorGlobal : deleteTextColorGlobal),
                  ),
                  deleteDateScrollTextWidget(),
                ],
              );
            }

            void onTapUnlessDisable() {
              void callback() {
                setState(() {});
              }

              askingForChangeDialogGlobal(
                context: context,
                allowFunction: () => setUpExcelDialog(
                  isCreateNewCustomer: false,
                  excelIndexMain: excelIndex,
                  isAdminEditing: true,
                  context: context,
                  setState: setState,
                  callback: callback,
                ),
                editSettingTypeEnum: EditSettingTypeEnum.importFromExcel,
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

        Widget categoryWidget() {
          Widget insideSizeBoxWidget() {
            return Padding(
              padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(categoryCardStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                for (int categoryIndex = 0; categoryIndex < excelCategoryListGlobal.length; categoryIndex++)
                  scrollText(
                    textStr: excelCategoryListGlobal[categoryIndex].text,
                    textStyle: textStyleGlobal(level: Level.normal),
                    alignment: Alignment.topLeft,
                  ),
              ]),
            );
          }

          void onTapUnlessDisable() {
            void categoryDialog() {
              List<TextEditingController> excelCategoryListTemp = excelCategoryListGlobal.map((e) => (TextEditingController(text: e.text))).toList();
              editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.importFromExcel);
              void cancelFunctionOnTap() {
                // if (isAdminEditing) {
                void okFunction() {
                  adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.importFromExcel);
                  closeDialogGlobal(context: context);
                }

                void cancelFunction() {}
                confirmationDialogGlobal(
                    context: context,
                    okFunction: okFunction,
                    cancelFunction: cancelFunction,
                    titleStr: cancelEditingSettingGlobal,
                    subtitleStr: cancelEditingSettingConfirmGlobal);
                // } else {
                // closeDialogGlobal(context: context);
                // }
              }

              ValidButtonModel validSaveButtonFunction() {
                for (int categoryIndex = 0; categoryIndex < excelCategoryListTemp.length; categoryIndex++) {
                  if (excelCategoryListTemp[categoryIndex].text.isEmpty) {
                    // return false;
                    // return ValidButtonModel(isValid: false, errorStr: "Excel category index of $categoryIndex cannot be blank");
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.valueOfString,
                      errorLocationList: [TitleAndSubtitleModel(title: "Excel category index", subtitle: categoryIndex.toString())],
                      error: "Excel category is empty.",
                    );
                  }
                }
                for (int categoryIndex = 0; categoryIndex < excelCategoryListTemp.length; categoryIndex++) {
                  for (int informationSubIndex = (categoryIndex + 1); informationSubIndex < excelCategoryListTemp.length; informationSubIndex++) {
                    final bool isSameValue = (excelCategoryListTemp[categoryIndex].text == excelCategoryListTemp[informationSubIndex].text);
                    if (isSameValue) {
                      // return false;
                      // return ValidButtonModel(
                      //   isValid: false,
                      //   errorStr:
                      //       "Excel category index of $categoryIndex and $informationSubIndex (${excelCategoryListTemp[categoryIndex].text}) cannot be the same",
                      // );
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.valueUnique,
                        errorLocationList: [
                          TitleAndSubtitleModel(title: "Excel category (index: $categoryIndex)", subtitle: excelCategoryListTemp[categoryIndex].text),
                        ],
                        error: "Excel category is not unique.",
                      );
                    }
                  }
                }
                bool isValid = false;
                final bool isCategoryListSameLength = (excelCategoryListTemp.length == excelCategoryListGlobal.length);
                if (isCategoryListSameLength) {
                  for (int categoryIndex = 0; categoryIndex < excelCategoryListTemp.length; categoryIndex++) {
                    if (excelCategoryListGlobal[categoryIndex].text != excelCategoryListTemp[categoryIndex].text) {
                      isValid = true;
                      break;
                    }
                  }
                } else {
                  isValid = true;
                }

                // return isValid;
                // return ValidButtonModel(isValid: isValid, errorStr: "Nothing Change");
                return ValidButtonModel(isValid: isValid, errorType: ErrorTypeEnum.nothingChange);
              }

              void saveFunctionOnTap() {
                void callBack() {
                  adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.importFromExcel);
                  setState(() {});
                  closeDialogGlobal(context: context);
                }

                updateExcelCategoryAdminGlobal(excelCategoryListTemp: excelCategoryListTemp, callBack: callBack, context: context);
              }

              Widget editCustomerDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                Widget paddingAddRateButtonWidget() {
                  Widget addRateButtonWidget() {
                    ValidButtonModel checkIsValid() {
                      for (int categoryIndex = 0; categoryIndex < excelCategoryListTemp.length; categoryIndex++) {
                        if (excelCategoryListTemp[categoryIndex].text.isEmpty) {
                          // return false;
                          // return ValidButtonModel(isValid: false, errorStr: "Excel category index of $categoryIndex cannot be blank");
                          return ValidButtonModel(
                            isValid: false,
                            errorType: ErrorTypeEnum.valueOfString,
                            errorLocationList: [TitleAndSubtitleModel(title: "Excel category index", subtitle: categoryIndex.toString())],
                            error: "Excel category is empty.",
                          );
                        }
                      }
                      // return true;
                      // return ValidButtonModel(isValid: true, errorStr: "");
                      return ValidButtonModel(isValid: true);
                    }

                    return addButtonOrContainerWidget(context: context,
                      level: Level.mini,
                      validModel: checkIsValid(),
                      onTapFunction: () {
                        excelCategoryListTemp.add(TextEditingController());
                        // hoverCategoryListTemp.add(false);
                        setStateFromDialog(() {});
                      },
                      currentAddButtonQty: excelCategoryListTemp.length,
                      maxAddButtonLimit: excelCategoryAddButtonLimitGlobal,
                    );
                  }

                  return Padding(padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.normal)), child: addRateButtonWidget());
                }

                Widget categoryElementWidget({required int categoryIndex}) {
                  void onDeleteUnlessDisable() {
                    excelCategoryListTemp.removeAt(categoryIndex);
                    // hoverCategoryListTemp.removeAt(categoryIndex);
                    setStateFromDialog(() {});
                  }

                  return Padding(
                    padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                    child: CustomButtonGlobal(
                      onTapUnlessDisable: () {},
                      onDeleteUnlessDisable: onDeleteUnlessDisable,
                      insideSizeBoxWidget: Row(
                        children: [
                          Expanded(
                            // child: Padding(
                            //   padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                            child: Column(
                              children: [
                                textAreaGlobal(
                                  controller: excelCategoryListTemp[categoryIndex],
                                  labelText: categoryElementCardStrGlobal,
                                  level: Level.normal,
                                  onChangeFromOutsiderFunction: () {
                                    setStateFromDialog(() {});
                                  },
                                  onTapFromOutsiderFunction: () {},
                                ),
                              ],
                            ),
                          ),
                          // ),
                        ],
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.all(paddingSizeGlobal(level: Level.normal)),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                            child: Text(editCategoryStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                          ),
                          for (int categoryIndex = 0; categoryIndex < excelCategoryListTemp.length; categoryIndex++)
                            categoryElementWidget(categoryIndex: categoryIndex),
                          paddingAddRateButtonWidget()
                        ],
                      ),
                    ),
                  ),
                );
              }

              actionDialogSetStateGlobal(
                dialogHeight: dialogSizeGlobal(level: Level.mini),
                dialogWidth: dialogSizeGlobal(level: Level.mini),
                cancelFunctionOnTap: cancelFunctionOnTap,
                context: context,
                validSaveButtonFunction:() =>  validSaveButtonFunction(),
                saveFunctionOnTap: saveFunctionOnTap,
                contentFunctionReturnWidget: editCustomerDialog,
              );
            }

            askingForChangeDialogGlobal(context: context, allowFunction: categoryDialog, editSettingTypeEnum: EditSettingTypeEnum.importFromExcel);
          }

          return CustomButtonGlobal(sizeBoxWidth: sizeBoxWidthGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
        }

        return [
          categoryWidget(),
          for (int excelIndex = 0; excelIndex < excelAdminModelListGlobal.length; excelIndex++) customerButtonWidget(excelIndex: excelIndex)
        ];
      }

      void addOnTapFunction() {
        void callback() {
          setState(() {});
        }

        askingForChangeDialogGlobal(
          context: context,
          allowFunction: () => setUpExcelDialog(
            isCreateNewCustomer: true,
            excelIndexMain: null,
            context: context,
            isAdminEditing: true,
            setState: setState,
            callback: callback,
          ),
          editSettingTypeEnum: EditSettingTypeEnum.importFromExcel,
        );
      }

      return BodyTemplateSideMenu(
        title: widget.title,
        inWrapWidgetList: inWrapWidgetList(),
        addOnTapFunction: addOnTapFunction,
        currentAddButtonQty: excelAdminModelListGlobal.length,
        maxAddButtonLimit: excelAddButtonLimitGlobal,
      );
    }

    return bodyTemplateSideMenu();
  }
}
