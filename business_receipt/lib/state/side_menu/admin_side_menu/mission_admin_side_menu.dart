import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/request_api/mission_request_api_env.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/mission_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class MissionAdminSideMenu extends StatefulWidget {
  final String title;
  const MissionAdminSideMenu({super.key, required this.title});
  @override
  State<MissionAdminSideMenu> createState() => _MissionAdminSideMenuState();
}

class _MissionAdminSideMenuState extends State<MissionAdminSideMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      List<Widget> inWrapWidgetList() {
        Widget customerButtonWidget() {
          Widget setWidthSizeBox() {
            Widget insideSizeBoxWidget() {
              return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(closeSellingDateStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
              ]);
            }

            void onTapUnlessDisable() {
              void missionDialog() {
                MissionModel missionModelTemp = cloneMissionAdmin();
                editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.mission);
                void cancelFunctionOnTap() {
                  void okFunction() {
                    adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.mission);
                    closeDialogGlobal(context: context);
                  }

                  void cancelFunction() {}
                  confirmationDialogGlobal(
                      context: context,
                      okFunction: okFunction,
                      cancelFunction: cancelFunction,
                      titleStr: cancelEditingSettingGlobal,
                      subtitleStr: cancelEditingSettingConfirmGlobal);
                }

                ValidButtonModel validSaveButtonFunction() {
                  for (int closeSellingIndex = 0; closeSellingIndex < missionModelTemp.closeSellingDate.length; closeSellingIndex++) {
                    final bool isCountEmpty = missionModelTemp.closeSellingDate[closeSellingIndex].count.text.isEmpty;
                    if (isCountEmpty) {
                      // return false;
                      // return ValidButtonModel(isValid: false, errorStr: "Please fill field index ($closeSellingIndex)");

                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.valueOfNumber,
                        errorLocationList: [TitleAndSubtitleModel(title: "Count index", subtitle: closeSellingIndex.toString())],
                        error: "count is empty",
                      );
                    }
                  }
                  for (int closeSellingIndex = 0; closeSellingIndex < missionModelTemp.closeSellingDate.length; closeSellingIndex++) {
                    for (int closeSellingSubIndex = (closeSellingIndex + 1);
                        closeSellingSubIndex < missionModelTemp.closeSellingDate.length;
                        closeSellingSubIndex++) {
                      final bool isSameCount = (missionModelTemp.closeSellingDate[closeSellingIndex].count.text ==
                          missionModelTemp.closeSellingDate[closeSellingSubIndex].count.text);
                      final bool isSameTargetDate = (missionModelTemp.closeSellingDate[closeSellingIndex].targetDate
                              .compareTo(missionModelTemp.closeSellingDate[closeSellingSubIndex].targetDate) ==
                          0);
                      // if (isSameCount || isSameTargetDate) {
                      //   // return false;
                      // }
                      if (isSameCount) {
                        // return false;
                        // return ValidButtonModel(
                        //     isValid: false,
                        //     errorStr:
                        //         "Count index ($closeSellingIndex) and index ($closeSellingSubIndex) is same ${missionModelTemp.closeSellingDate[closeSellingSubIndex].count.text}");
                        return ValidButtonModel(
                          isValid: false,
                          errorType: ErrorTypeEnum.valueUnique,
                          errorLocationList: [
                            TitleAndSubtitleModel(
                              title: "count (index: $closeSellingIndex)",
                              subtitle: missionModelTemp.closeSellingDate[closeSellingSubIndex].count.text,
                            ),
                          ],
                          error: "count is same as previous save.",
                        );
                      }
                      if (isSameTargetDate) {
                        // return false;
                        // return ValidButtonModel(
                        //     isValid: false,
                        //     errorStr:
                        //         "Date index ($closeSellingIndex) and index ($closeSellingSubIndex) is same ${formatFullDateToStr(date: missionModelTemp.closeSellingDate[closeSellingSubIndex].targetDate)}");
                        return ValidButtonModel(
                          isValid: false,
                          errorType: ErrorTypeEnum.valueUnique,
                          errorLocationList: [
                            TitleAndSubtitleModel(
                              title: "date (index: $closeSellingIndex)",
                              subtitle: formatFullDateToStr(date: missionModelTemp.closeSellingDate[closeSellingSubIndex].targetDate),
                            ),
                          ],
                          error: "date is same as previous save.",
                        );
                      }
                    }
                  }
                  // for (int closeSellingIndexInside = 0; closeSellingIndexInside < missionModelGlobal.closeSellingDate.length; closeSellingIndexInside++) {
                  //   for (int closeSellingIndex = 0; closeSellingIndex < missionModelTemp.closeSellingDate.length; closeSellingIndex++) {
                  //     final bool isSameCount = (missionModelTemp.closeSellingDate[closeSellingIndex].count.text == missionModelGlobal.closeSellingDate[closeSellingIndexInside].count.text);
                  //     final bool isSameTargetDate =
                  //         (missionModelGlobal.closeSellingDate[closeSellingIndex].targetDate.compareTo(missionModelGlobal.closeSellingDate[closeSellingIndexInside].targetDate) == 0);
                  //     if (isSameCount && isSameTargetDate) {
                  //     print("isSameCount && isSameTargetDate 2");
                  //       return false;
                  //     }
                  //   }
                  // }
                  bool isValid = false;
                  final bool isInformationListSameLength = (missionModelTemp.closeSellingDate.length == missionModelGlobal.closeSellingDate.length);
                  if (isInformationListSameLength) {
                    for (int informationIndex = 0; informationIndex < missionModelTemp.closeSellingDate.length; informationIndex++) {
                      final String countStr = missionModelTemp.closeSellingDate[informationIndex].count.text;
                      final String countStrInside = missionModelGlobal.closeSellingDate[informationIndex].count.text;
                      final DateTime targetDate = missionModelGlobal.closeSellingDate[informationIndex].targetDate;
                      final DateTime targetDateInside = missionModelGlobal.closeSellingDate[informationIndex].targetDate;
                      final bool isCountNotSame = (countStr != countStrInside);
                      final bool isTargetDateNotSame = (targetDate.compareTo(targetDateInside) != 0);
                      if (isCountNotSame || isTargetDateNotSame) {
                        isValid = true;
                        break;
                      }
                    }
                  } else {
                    isValid = true;
                  }
                  // return isValid;
                  // return ValidButtonModel(isValid: isValid, errorStr: "Nothing change.");
                  return ValidButtonModel(isValid: isValid, errorType: ErrorTypeEnum.nothingChange);
                }

                void saveFunctionOnTap() {
                  void callBack() {
                    adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.mission);
                    closeDialogGlobal(context: context);
                  }

                  updateMissionAdminGlobal(callBack: callBack, context: context, missionModelTemp: missionModelTemp);
                }

                Widget editCustomerDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                  Widget titleTextFieldWidget() {
                    return Text(missionInformationStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold));
                  }

                  Widget informationListWidget() {
                    Widget informationWidget({required int closeSellingIndex}) {
                      void onTapUnlessDisable() {
                        //TODO: do something and setState
                      }

                      void onDeleteUnlessDisable() {
                        missionModelTemp.closeSellingDate.removeAt(closeSellingIndex);
                        setStateFromDialog(() {});
                      }

                      Widget insideSizeBoxWidget() {
                        Widget countTextFieldWidget() {
                          void onTapFromOutsiderFunction() {}
                          void onChangeFromOutsiderFunction() {
                            setStateFromDialog(() {});
                          }

                          return textFieldGlobal(
                            textFieldDataType: TextFieldDataType.int,
                            controller: missionModelTemp.closeSellingDate[closeSellingIndex].count,
                            onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                            onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                            labelText: countServiceStrGlobal,
                            level: Level.normal,
                          );
                        }

                        Widget dateWidget() {
                          void callback({required DateTime dateTime}) {
                            missionModelTemp.closeSellingDate[closeSellingIndex].targetDate =
                                defaultDate(hour: dateTime.hour, minute: dateTime.minute, second: dateTime.second);
                            setStateFromDialog(() {});
                          }

                          return pickTime(
                            callback: callback,
                            context: context,
                            dateTimeOutsider: missionModelTemp.closeSellingDate[closeSellingIndex].targetDate,
                            level: Level.normal,
                            // validModel: true,
                            validModel: ValidButtonModel(isValid: true),
                            // enable: (missionModelTemp.closeSellingDate[closeSellingIndex].targetDate == null),
                          );
                        }

                        return Row(children: [
                          Expanded(child: countTextFieldWidget()),
                          SizedBox(width: paddingSizeGlobal(level: Level.normal)),
                          Expanded(child: dateWidget())
                        ]);
                      }

                      return CustomButtonGlobal(
                        isDisable: true,
                        onDeleteUnlessDisable: onDeleteUnlessDisable,
                        insideSizeBoxWidget: insideSizeBoxWidget(),
                        onTapUnlessDisable: onTapUnlessDisable,
                      );
                    }

                    Widget paddingAddRateButtonWidget() {
                      Widget addRateButtonWidget() {
                        ValidButtonModel isValid() {
                          if (missionModelTemp.closeSellingDate.isEmpty) {
                            // return true;
                            // return ValidButtonModel(isValid: true, errorStr: "");
                            return ValidButtonModel(isValid: true);
                          }
                          for (int closeSellingIndex = 0; closeSellingIndex < missionModelTemp.closeSellingDate.length; closeSellingIndex++) {
                            final bool isCountEmpty = missionModelTemp.closeSellingDate[closeSellingIndex].count.text.isEmpty;
                            if (isCountEmpty) {
                              // return false;
                              // return ValidButtonModel(isValid: false, errorStr: "Please fill field index ($closeSellingIndex)");
                              return ValidButtonModel(
                                isValid: false,
                                errorType: ErrorTypeEnum.valueOfNumber,
                                errorLocationList: [TitleAndSubtitleModel(title: "Count index", subtitle: closeSellingIndex.toString())],
                                error: "count is empty",
                              );
                            }
                          }
                          // return true;
                          // return ValidButtonModel(isValid: true, errorStr: "");
                          return ValidButtonModel(isValid: true);
                          // for (int closeSellingIndex = 0; closeSellingIndex < missionModelTemp.closeSellingDate.length; closeSellingIndex++) {
                          //   for (int closeSellingSubIndex = (closeSellingIndex + 1); closeSellingSubIndex < missionModelTemp.closeSellingDate.length; closeSellingSubIndex++) {
                          //     final bool isSameCount = (missionModelTemp.closeSellingDate[closeSellingIndex].count.text == missionModelTemp.closeSellingDate[closeSellingSubIndex].count.text);
                          //     final bool isSameTargetDate =
                          //         (missionModelTemp.closeSellingDate[closeSellingIndex].targetDate.compareTo(missionModelTemp.closeSellingDate[closeSellingSubIndex].targetDate) == 0);
                          //     if (isSameCount && isSameTargetDate) {
                          //       return false;
                          //     }
                          //   }
                          // }
                          // for (int closeSellingIndexInside = 0; closeSellingIndexInside < missionModelGlobal.closeSellingDate.length; closeSellingIndexInside++) {
                          //   for (int closeSellingIndex = 0; closeSellingIndex < missionModelTemp.closeSellingDate.length; closeSellingIndex++) {
                          //     final bool isSameCount = (missionModelTemp.closeSellingDate[closeSellingIndex].count.text == missionModelGlobal.closeSellingDate[closeSellingIndexInside].count.text);
                          //     final bool isSameTargetDate =
                          //         (missionModelGlobal.closeSellingDate[closeSellingIndex].targetDate.compareTo(missionModelGlobal.closeSellingDate[closeSellingIndexInside].targetDate) == 0);
                          //     if (isSameCount && isSameTargetDate) {
                          //       return false;
                          //     }
                          //   }
                          // }
                          // bool isValid = false;
                          // final bool isInformationListSameLength = (missionModelTemp.closeSellingDate.length == missionModelGlobal.closeSellingDate.length);
                          // if (isInformationListSameLength) {
                          //   for (int informationIndex = 0; informationIndex < missionModelTemp.closeSellingDate.length; informationIndex++) {
                          //     final String countStr = missionModelTemp.closeSellingDate[informationIndex].count.text;
                          //     final String countStrInside = missionModelGlobal.closeSellingDate[informationIndex].count.text;
                          //     final DateTime targetDate = missionModelGlobal.closeSellingDate[informationIndex].targetDate;
                          //     final DateTime targetDateInside = missionModelGlobal.closeSellingDate[informationIndex].targetDate;
                          //     final bool isCountNotSame = (countStr != countStrInside);
                          //     final bool isTargetDateNotSame = (targetDate.compareTo(targetDateInside) != 0);
                          //     if (isCountNotSame || isTargetDateNotSame) {
                          //       isValid = true;
                          //       break;
                          //     }
                          //   }
                          // } else {
                          //   isValid = true;
                          // }
                          // return isValid;
                        }

                        Function onTapFunctionProvider() {
                          void onTapFunction() {
                            missionModelTemp.closeSellingDate
                                .add(CloseSellingDate(count: TextEditingController(), targetDate: defaultDate(hour: 0, minute: 0, second: 0)));
                            setStateFromDialog(() {});
                          }

                          return onTapFunction;
                        }

                        return addButtonOrContainerWidget(context: context,
                          level: Level.mini,
                          validModel: isValid(),
                          onTapFunction: onTapFunctionProvider(),
                          currentAddButtonQty: missionModelTemp.closeSellingDate.length,
                          maxAddButtonLimit: missionInformationAddButtonLimitGlobal,
                        );
                      }

                      return Padding(padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.normal)), child: addRateButtonWidget());
                    }

                    return Column(children: [
                      for (int closeSellingIndex = 0; closeSellingIndex < missionModelTemp.closeSellingDate.length; closeSellingIndex++)
                        informationWidget(closeSellingIndex: closeSellingIndex),
                      paddingAddRateButtonWidget(),
                    ]);
                  }

                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    titleTextFieldWidget(),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)), child: Column(children: [informationListWidget()])))),
                  ]);
                }

                actionDialogSetStateGlobal(
                  dialogHeight: dialogSizeGlobal(level: Level.mini),
                  dialogWidth: dialogSizeGlobal(level: Level.mini),
                  cancelFunctionOnTap: cancelFunctionOnTap,
                  context: context,
                  validSaveButtonFunction: () => validSaveButtonFunction(),
                  saveFunctionOnTap: saveFunctionOnTap,
                  contentFunctionReturnWidget: editCustomerDialog,
                );
              }

              askingForChangeDialogGlobal(context: context, allowFunction: missionDialog, editSettingTypeEnum: EditSettingTypeEnum.mission);
            }

            return CustomButtonGlobal(
              sizeBoxWidth: sizeBoxWidthGlobal,
              sizeBoxHeight: sizeBoxHeightGlobal,
              insideSizeBoxWidget: insideSizeBoxWidget(),
              onTapUnlessDisable: onTapUnlessDisable,
            );
          }

          return setWidthSizeBox();
        }

        return [customerButtonWidget()];
      }

      return BodyTemplateSideMenu(title: widget.title, inWrapWidgetList: inWrapWidgetList());
    }

    return bodyTemplateSideMenu();
  }
}
