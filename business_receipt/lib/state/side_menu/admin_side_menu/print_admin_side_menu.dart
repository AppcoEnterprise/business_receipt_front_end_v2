// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/request_api/print_request_api_env.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/print_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:business_receipt/state/side_menu/set_up_print_dialog.dart';
import 'package:flutter/material.dart';

class PrintAdminSideMenu extends StatefulWidget {
  String title;
  PrintAdminSideMenu({Key? key, required this.title}) : super(key: key);

  @override
  State<PrintAdminSideMenu> createState() => _PrintAdminSideMenuState();
}

class _PrintAdminSideMenuState extends State<PrintAdminSideMenu> {
  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      void cancelFunctionOnTap() {
        void okFunction() {
          adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.frenchyAndPrint);
          closeDialogGlobal(context: context);
        }

        void cancelFunction() {}
        confirmationDialogGlobal(context: context, okFunction: okFunction, cancelFunction: cancelFunction, titleStr: cancelEditingSettingGlobal, subtitleStr: cancelEditingSettingConfirmGlobal);
      }

      ValidButtonModel validSaveButtonFunction({required PrintModel printModelTemp, required bool isOtherPrint}) {
        //check null on value
        if (!isOtherPrint) {
          final bool isTitleEmpty = printModelTemp.header.title.text.isEmpty;
          if (isTitleEmpty) {
            // return false;
            // return ValidButtonModel(isValid: false, errorStr: "Header title textfield must not be blank");
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfString,
              error: "Header title value is empty",
            );
          }
          for (int communicationIndex = 0; communicationIndex < printModelTemp.communicationList.length; communicationIndex++) {
            final bool isTitleEmpty = printModelTemp.communicationList[communicationIndex].title.text.isEmpty;
            final bool isSubtitleEmpty = printModelTemp.communicationList[communicationIndex].subtitle.text.isEmpty;
            // if (isTitleEmpty || isSubtitleEmpty) {
            //   return false;
            // }
            if (isTitleEmpty) {
              // return false;
              // return ValidButtonModel(isValid: false, errorStr: "Title textfield index $communicationIndex must not be blank");
              return ValidButtonModel(
                isValid: false,
                errorType: ErrorTypeEnum.valueOfString,
                errorLocationList: [
                  TitleAndSubtitleModel(title: "communication index", subtitle: communicationIndex.toString()),
                ],
                error: "communication title is empty",
              );
            }
            if (isSubtitleEmpty) {
              // return false;
              // return ValidButtonModel(isValid: false, errorStr: "Subtitle textfield index $communicationIndex must not be blank");
              return ValidButtonModel(
                isValid: false,
                errorType: ErrorTypeEnum.valueOfString,
                errorLocationList: [
                  TitleAndSubtitleModel(title: "communication index", subtitle: communicationIndex.toString()),
                ],
                error: "communication subtitle is empty",
              );
            }
          }
        }

        for (int otherIndex = 0; otherIndex < printModelTemp.otherList.length; otherIndex++) {
          final bool isTitleEmpty = printModelTemp.otherList[otherIndex].title.text.isEmpty;
          // final bool isSubtitleEmpty = printModelTemp.otherList[otherIndex].subtitle.text.isEmpty;
          if (isTitleEmpty) {
            // return false;
            // return ValidButtonModel(isValid: false, errorStr: "Print title textfield index $otherIndex must not be blank");
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfString,
              errorLocationList: [
                TitleAndSubtitleModel(title: "print index", subtitle: otherIndex.toString()),
              ],
              error: "print title is empty",
            );
          }
        }

        // for (int communicationIndexInside = 0; communicationIndexInside < printModelGlobal.communicationList.length; communicationIndexInside++) {
        //   for (int communicationIndex = 0; communicationIndex < printModelTemp.communicationList.length; communicationIndex++) {
        //     final bool isSameTitle = (printModelTemp.communicationList[communicationIndex].title.text == printModelGlobal.communicationList[communicationIndexInside].title.text);
        //     final bool isSameSubtitle = (printModelTemp.communicationList[communicationIndex].subtitle.text == printModelGlobal.communicationList[communicationIndexInside].subtitle.text);
        //     if (isSameTitle && isSameSubtitle) {
        //   print("isSameTitle && isSameSubtitle");
        //       return false;
        //     }
        //   }
        // }

        bool isValid = false;
        if (!isOtherPrint) {
          final bool isHeaderTitleNotSame = (printModelTemp.header.title.text != printModelGlobal.header.title.text);
          if (isHeaderTitleNotSame) {
            isValid = true;
          }
          final bool isHeaderSubtitleNotSame = (printModelTemp.header.subtitle.text != printModelGlobal.header.subtitle.text);
          if (isHeaderSubtitleNotSame) {
            isValid = true;
          }

          final bool isFooterTitleNotSame = (printModelTemp.footer.title.text != printModelGlobal.footer.title.text);
          if (isFooterTitleNotSame) {
            isValid = true;
          }
          final bool isFooterSubtitleNotSame = (printModelTemp.footer.subtitle.text != printModelGlobal.footer.subtitle.text);
          if (isFooterSubtitleNotSame) {
            isValid = true;
          }

          final bool isCommunicationListSameLength = (printModelTemp.communicationList.length == printModelGlobal.communicationList.length);
          if (isCommunicationListSameLength) {
            for (int communicationListIndex = 0; communicationListIndex < printModelTemp.communicationList.length; communicationListIndex++) {
              final String titleStr = printModelTemp.communicationList[communicationListIndex].title.text;
              final String titleStrInside = printModelGlobal.communicationList[communicationListIndex].title.text;
              final String subtitleStr = printModelTemp.communicationList[communicationListIndex].subtitle.text;
              final String subtitleStrInside = printModelGlobal.communicationList[communicationListIndex].subtitle.text;
              final bool isTitleNotSame = (titleStrInside != titleStr);
              final bool isSubtitleNotSame = (subtitleStr != subtitleStrInside);
              if (isTitleNotSame || isSubtitleNotSame) {
                isValid = true;
                break;
              }
            }
          } else {
            isValid = true;
          }
        }
        final bool isOtherListSameLength = (printModelTemp.otherList.length == printModelGlobal.otherList.length);
        if (isOtherListSameLength) {
          for (int otherIndex = 0; otherIndex < printModelTemp.otherList.length; otherIndex++) {
            final String titleStr = printModelTemp.otherList[otherIndex].title.text;
            final String titleStrInside = printModelGlobal.otherList[otherIndex].title.text;
            // final String subtitleStr = printModelTemp.otherList[otherIndex].subtitle.text;
            // final String subtitleStrInside = printModelGlobal.otherList[otherIndex].subtitle.text;
            final bool isTitleNotSame = (titleStrInside != titleStr);
            // final bool isSubtitleNotSame = (subtitleStr != subtitleStrInside);
            if (isTitleNotSame) {
              isValid = true;
              break;
            }
          }
        } else {
          isValid = true;
        }
        // return isValid;
        // return ValidButtonModel(isValid: isValid, errorStr: "");
        return ValidButtonModel(isValid: isValid, errorType: ErrorTypeEnum.nothingChange);
      }

      void saveFunctionOnTap({required PrintModel printModelTemp}) {
        void callback() {
          adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.frenchyAndPrint);
          setState(() {});
        }

        //close the rate dialog
        closeDialogGlobal(context: context);
        updatePrintInformationGlobal(callBack: callback, context: context, printModel: printModelTemp);
      }

      Widget headerAndFooterDialog() {
        Widget insideSizeBoxWidget() {
          return scrollText(textStr: headerAndFooterStrPrintGlobal, textStyle: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold), alignment: Alignment.center);
        }

        void onTapUnlessDisable() {
          askingForChangeDialogGlobal(
            context: context,
            allowFunction: () {
              PrintModel printModelTemp = clonePrintModel();
              editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.frenchyAndPrint);
              Widget editCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                Widget titleWidget() {
                  return Text(headerAndFooterStrPrintGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold));
                }

                Widget textFieldWidget({required TextEditingController controller, required String labelText}) {
                  Widget employeeNameTextFieldWidget() {
                    void onChangeFromOutsiderFunction() {
                      setStateFromDialog(() {});
                    }

                    void onTapFromOutsiderFunction() {}
                    return textFieldGlobal(
                      onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                      controller: controller,
                      onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                      labelText: labelText,
                      level: Level.normal,
                      textFieldDataType: TextFieldDataType.str,
                    );
                  }

                  return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)), child: employeeNameTextFieldWidget());
                }

                Widget communicationListWidget() {
                  Widget communicationWidget({required int communicationIndex}) {
                    Widget titleAndSubtitleTextFieldWidget() {
                      Widget titleTextFieldWidget() {
                        void onTapFromOutsiderFunction() {}
                        void onChangeFromOutsiderFunction() {
                          setStateFromDialog(() {});
                        }

                        return textFieldGlobal(
                          textFieldDataType: TextFieldDataType.str,
                          controller: printModelTemp.communicationList[communicationIndex].title,
                          onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                          onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                          labelText: titleCommunicationStrGlobal,
                          level: Level.mini,
                        );
                      }

                      Widget paddingLeftSubtitleTextFieldWidget() {
                        Widget subtitleTextFieldWidget() {
                          void onTapFromOutsiderFunction() {}
                          void onChangeFromOutsiderFunction() {
                            setStateFromDialog(() {});
                          }

                          return textFieldGlobal(
                            textFieldDataType: TextFieldDataType.str,
                            controller: printModelTemp.communicationList[communicationIndex].subtitle,
                            onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                            onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                            labelText: subtitleCommunicationStrGlobal,
                            level: Level.mini,
                          );
                        }

                        return Padding(padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)), child: subtitleTextFieldWidget());
                      }

                      return Row(children: [Expanded(flex: flexTypeGlobal, child: titleTextFieldWidget()), Expanded(flex: flexValueGlobal, child: paddingLeftSubtitleTextFieldWidget())]);
                    }

                    void onTapUnlessDisable() {
                      //TODO: do something and setState
                    }

                    Function? onDeleteUnlessDisableProvider() {
                      void onDeleteUnlessDisable() {
                        printModelTemp.communicationList.removeAt(communicationIndex);
                        setStateFromDialog(() {});
                      }

                      return onDeleteUnlessDisable;
                    }

                    return CustomButtonGlobal(
                      isDisable: true,
                      onDeleteUnlessDisable: onDeleteUnlessDisableProvider(),
                      insideSizeBoxWidget: titleAndSubtitleTextFieldWidget(),
                      onTapUnlessDisable: onTapUnlessDisable,
                    );
                    // return titleAndSubtitleTextFieldWidget();
                  }

                  Widget paddingCommunicationWidget() {
                    Widget addRateButtonWidget() {
                      ValidButtonModel isValid() {
                        for (int communicationIndex = 0; communicationIndex < printModelTemp.communicationList.length; communicationIndex++) {
                          final bool isTitleEmpty = printModelTemp.communicationList[communicationIndex].title.text.isEmpty;
                          final bool isSubtitleEmpty = printModelTemp.communicationList[communicationIndex].subtitle.text.isEmpty;
                          // if (isTitleEmpty || isSubtitleEmpty) {
                          //   return false;
                          // }
                          if (isTitleEmpty) {
                            // return false;
                            // return ValidButtonModel(isValid: false, errorStr: "Title textfield index $communicationIndex must not be blank");
                            return ValidButtonModel(
                              isValid: false,
                              errorType: ErrorTypeEnum.valueOfString,
                              errorLocationList: [
                                TitleAndSubtitleModel(title: "communication index", subtitle: communicationIndex.toString()),
                              ],
                              error: "communication title is empty",
                            );
                          }
                          if (isSubtitleEmpty) {
                            // return false;
                            // return ValidButtonModel(isValid: false, errorStr: "Subtitle textfield index $communicationIndex must not be blank");
                            return ValidButtonModel(
                              isValid: false,
                              errorType: ErrorTypeEnum.valueOfString,
                              errorLocationList: [
                                TitleAndSubtitleModel(title: "communication index", subtitle: communicationIndex.toString()),
                              ],
                              error: "communication subtitle is empty",
                            );
                          }
                        }
                        // return true;
                        return ValidButtonModel(isValid: true);
                      }

                      Function? onTapFunctionProvider() {
                        void onTapFunction() {
                          printModelTemp.communicationList.add(ElementPrintModel(title: TextEditingController(), subtitle: TextEditingController()));
                          setStateFromDialog(() {});
                        }

                        return onTapFunction;
                      }

                      return addButtonOrContainerWidget(
                        context: context,
                        level: Level.mini,
                        validModel: isValid(),
                        onTapFunction: onTapFunctionProvider(),
                        currentAddButtonQty: printModelTemp.communicationList.length,
                        maxAddButtonLimit: printCommunicationAddButtonLimitGlobal,
                      );
                    }

                    return Padding(padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.normal)), child: addRateButtonWidget());
                  }

                  // return ;

                  // return Column(children: [
                  //   for (int communicationIndex = 0; communicationIndex < printModelTemp.communicationList.length; communicationIndex++)
                  //     communicationWidget(communicationIndex: communicationIndex),
                  //   paddingCommunicationWidget()
                  // ]);

                  return Padding(
                    padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)),
                    child: CustomButtonGlobal(
                      insideSizeBoxWidget: Column(children: [
                        for (int communicationIndex = 0; communicationIndex < printModelTemp.communicationList.length; communicationIndex++)
                          communicationWidget(communicationIndex: communicationIndex),
                        paddingCommunicationWidget()
                      ]),
                      onTapUnlessDisable: () {},
                    ),
                  );
                }

                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleWidget(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        textFieldWidget(controller: printModelTemp.header.title, labelText: headerTitlePrintGlobal),
                        textFieldWidget(controller: printModelTemp.header.subtitle, labelText: headerSubtitlePrintGlobal),
                        textFieldWidget(controller: printModelTemp.footer.title, labelText: footerTitlePrintGlobal),
                        textFieldWidget(controller: printModelTemp.footer.subtitle, labelText: footerSubtitlePrintGlobal),
                        communicationListWidget(),
                      ]),
                    ),
                  ),
                ]);
              }

              actionDialogSetStateGlobal(
                dialogHeight: dialogSizeGlobal(level: Level.mini),
                dialogWidth: dialogSizeGlobal(level: Level.mini),
                cancelFunctionOnTap: cancelFunctionOnTap,
                context: context,
                validSaveButtonFunction: () => validSaveButtonFunction(printModelTemp: printModelTemp, isOtherPrint: false),
                saveFunctionOnTap: () => saveFunctionOnTap(printModelTemp: printModelTemp),
                contentFunctionReturnWidget: editCardDialog,
              );
            },
            editSettingTypeEnum: EditSettingTypeEnum.frenchyAndPrint,
          );
        }

        return CustomButtonGlobal(
          sizeBoxWidth: sizeBoxWidthGlobal,
          sizeBoxHeight: sizeBoxHeightGlobal,
          insideSizeBoxWidget: insideSizeBoxWidget(),
          onTapUnlessDisable: onTapUnlessDisable,
        );
      }

      void addOnTapFunction() {
        askingForChangeDialogGlobal(
          context: context,
          allowFunction: () => setUpOtherPrint(
            isCreateNewOtherPrint: true,
            otherIndex: null,
            context: context,
            setState: setState,
          ),
          editSettingTypeEnum: EditSettingTypeEnum.frenchyAndPrint,
        );
      }

      Widget otherListDialog({required int otherIndex}) {
        Widget insideSizeBoxWidget() {
          return scrollText(
            textStr: printModelGlobal.otherList[otherIndex].title.text,
            textStyle: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold),
            alignment: Alignment.center,
          );
        }

        void onTapUnlessDisable() {
          askingForChangeDialogGlobal(
            context: context,
            allowFunction: () => setUpOtherPrint(
              isCreateNewOtherPrint: false,
              otherIndex: otherIndex,
              context: context,
              setState: setState,
            ),
            editSettingTypeEnum: EditSettingTypeEnum.frenchyAndPrint,
          );
        }

        return CustomButtonGlobal(
          sizeBoxWidth: sizeBoxWidthGlobal,
          sizeBoxHeight: sizeBoxHeightGlobal,
          insideSizeBoxWidget: insideSizeBoxWidget(),
          onTapUnlessDisable: onTapUnlessDisable,
        );
      }

      return BodyTemplateSideMenu(
        inWrapWidgetList: [headerAndFooterDialog(), for (int otherIndex = 0; otherIndex < printModelGlobal.otherList.length; otherIndex++) otherListDialog(otherIndex: otherIndex)],
        title: widget.title,
        addOnTapFunction: addOnTapFunction,
        currentAddButtonQty: printModelGlobal.otherList.length,
        maxAddButtonLimit: printAddButtonLimitGlobal,
      );
    }

    // return _isLoadingOnGetLastRate ? Container() : bodyTemplateSideMenu();
    return bodyTemplateSideMenu();
  }
}
