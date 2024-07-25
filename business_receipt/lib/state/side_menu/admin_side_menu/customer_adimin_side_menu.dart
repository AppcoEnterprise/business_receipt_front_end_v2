// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/request_api/customer_request_api_env.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/customer_information_category.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:business_receipt/state/side_menu/set_up_customer_dialog.dart';
import 'package:flutter/material.dart';

class CustomerAdminSideMenu extends StatefulWidget {
  String title;
  CustomerAdminSideMenu({Key? key, required this.title}) : super(key: key);

  @override
  State<CustomerAdminSideMenu> createState() => _CustomerAdminSideMenuState();
}

class _CustomerAdminSideMenuState extends State<CustomerAdminSideMenu> {
  // bool _isLoadingOnGetCustomerList = true; //TODO: change this to true
  bool isShowPrevious = false;
  int customerLengthIncrease = queryLimitNumberGlobal;
  bool isShowSeeMoreWidget = true;

  @override
  void initState() {
    if (customerLengthIncrease > customerModelListGlobal.length) {
      isShowSeeMoreWidget = false;
      customerLengthIncrease = customerModelListGlobal.length;
    }
    // void getCustomerListFromDB() {
    //   bool isEmptyCustomer = customerModelListGlobal.isEmpty;
    //   if (isEmptyCustomer) {
    //     void callback() {
    //       _isLoadingOnGetCustomerList = false;
    //       setState(() {});
    //     }

    //     getCustomerWithoutBorrowOrLendingGlobal(callBack: callback, context: context);
    //   } else {
    //     _isLoadingOnGetCustomerList = false;
    //   }
    // }

    // getCustomerListFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      List<Widget> inWrapWidgetList() {
        Widget customerButtonWidget({required int customerIndex}) {
          Widget setWidthSizeBox() {
            Widget insideSizeBoxWidget() {
              final DateTime? deleteDateOrNull = customerModelListGlobal[customerIndex].deletedDate;
              String moneyTypeListText = "";
              for (int moneyTypeIndex = 0; moneyTypeIndex < customerModelListGlobal[customerIndex].totalList.length; moneyTypeIndex++) {
                final String providerStr = (moneyTypeIndex == (customerModelListGlobal[customerIndex].totalList.length - 1)) ? "" : providerStrGlobal;
                moneyTypeListText = "$moneyTypeListText ${customerModelListGlobal[customerIndex].totalList[moneyTypeIndex].moneyType} $providerStr";
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

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    customerModelListGlobal[customerIndex].name.text,
                    style: textStyleGlobal(
                        level: Level.large, fontWeight: FontWeight.bold, color: (deleteDateOrNull == null) ? defaultTextColorGlobal : deleteTextColorGlobal),
                  ),
                  scrollText(
                    textStr: moneyTypeListText,
                    textStyle: textStyleGlobal(level: Level.mini, color: (deleteDateOrNull == null) ? defaultTextColorGlobal : deleteTextColorGlobal),
                    alignment: Alignment.topCenter,
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
                allowFunction: () => setUpCustomerDialog(
                  isCreateNewCustomer: false,
                  customerIndex: customerIndex,
                  isAdminEditing: true,
                  context: context,
                  setState: setState,
                  callback: callback,
                  activeLogModelList: [],
                ),
                editSettingTypeEnum: EditSettingTypeEnum.customer,
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
                for (int categoryIndex = 0; categoryIndex < customerCategoryListGlobal.length; categoryIndex++)
                  scrollText(
                    textStr: customerCategoryListGlobal[categoryIndex].title.text,
                    textStyle: textStyleGlobal(level: Level.normal),
                    alignment: Alignment.topLeft,
                  ),
              ]),
            );
          }

          void onTapUnlessDisable() {
            void categoryDialog() {
              List<CustomerInformationCategory> customerCategoryListTemp =
                  cloneCustomerInformationCategoryList(customerInformationCategoryList: customerCategoryListGlobal);
              editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.customer);
              void cancelFunctionOnTap() {
                // if (isAdminEditing) {
                void okFunction() {
                  adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.customer);
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
                for (int categoryIndex = 0; categoryIndex < customerCategoryListTemp.length; categoryIndex++) {
                  if (customerCategoryListTemp[categoryIndex].title.text.isEmpty) {
                    // return false;
                    // return ValidButtonModel(isValid: false, errorStr: "Customer category title must not be blank");
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.valueOfString,
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "Customer category title index", subtitle: categoryIndex.toString()),
                      ],
                      error: "Customer category title is empty.",
                    );
                  }
                }
                for (int categoryIndex = 0; categoryIndex < customerCategoryListTemp.length; categoryIndex++) {
                  for (int informationSubIndex = (categoryIndex + 1); informationSubIndex < customerCategoryListTemp.length; informationSubIndex++) {
                    final bool isSameValue = (customerCategoryListTemp[categoryIndex].title.text == customerCategoryListTemp[informationSubIndex].title.text);
                    if (isSameValue) {
                      // return false;
                      // return ValidButtonModel(
                      //   isValid: false,
                      //   errorStr: "Customer category (${customerCategoryListTemp[categoryIndex].title.text}) title must be unique",
                      // );
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.valueUnique,
                        errorLocationList: [
                          TitleAndSubtitleModel(
                            title: "Customer category title (index: $categoryIndex)",
                            subtitle: customerCategoryListTemp[categoryIndex].title.text,
                          ),
                        ],
                        error: "Customer category title is same as previous save.",
                      );
                    }
                  }
                }
                bool isValid = false;
                final bool isCategoryListSameLength = (customerCategoryListTemp.length == customerCategoryListGlobal.length);
                if (isCategoryListSameLength) {
                  for (int categoryIndex = 0; categoryIndex < customerCategoryListTemp.length; categoryIndex++) {
                    if (customerCategoryListGlobal[categoryIndex].title.text != customerCategoryListTemp[categoryIndex].title.text) {
                      isValid = true;
                      break;
                    }
                  }
                } else {
                  isValid = true;
                }

                for (int categoryIndex = 0; categoryIndex < customerCategoryListTemp.length; categoryIndex++) {
                  for (int subtitleIndex = 0; subtitleIndex < customerCategoryListTemp[categoryIndex].subtitleOptionList.length; subtitleIndex++) {
                    if (customerCategoryListTemp[categoryIndex].subtitleOptionList[subtitleIndex].text.isEmpty) {
                      // return false;
                      // return ValidButtonModel(
                      //   isValid: false,
                      //   errorStr: "Customer category subtitle must not be blank",
                      // );
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.valueOfString,
                        errorLocationList: [
                          TitleAndSubtitleModel(
                            title: "Customer category title (index: $categoryIndex)",
                            subtitle: customerCategoryListTemp[categoryIndex].title.text,
                          ),
                          TitleAndSubtitleModel(
                            title: "Customer category subtitle (index: $subtitleIndex)",
                            subtitle: customerCategoryListTemp[categoryIndex].subtitleOptionList[subtitleIndex].text,
                          ),
                        ],
                        error: "Customer category subtitle is empty.",
                      );
                    }
                  }
                  for (int subtitleIndex = 0; subtitleIndex < customerCategoryListTemp[categoryIndex].subtitleOptionList.length; subtitleIndex++) {
                    for (int informationSubIndex = (subtitleIndex + 1);
                        informationSubIndex < customerCategoryListTemp[categoryIndex].subtitleOptionList.length;
                        informationSubIndex++) {
                      final bool isSameValue = customerCategoryListTemp[categoryIndex].subtitleOptionList[subtitleIndex].text ==
                          customerCategoryListTemp[categoryIndex].subtitleOptionList[informationSubIndex].text;
                      if (isSameValue) {
                        // final String categoryTitle = customerCategoryListTemp[categoryIndex].title.text;
                        // final String subtitleText = customerCategoryListTemp[categoryIndex].subtitleOptionList[subtitleIndex].text;
                        // return false;
                        // return ValidButtonModel(
                        //   isValid: false,
                        //   errorStr: "Customer category ($categoryTitle) of subtitle ($subtitleText) must be unique",
                        // );
                        return ValidButtonModel(
                          isValid: false,
                          errorType: ErrorTypeEnum.valueUnique,
                          errorLocationList: [
                            TitleAndSubtitleModel(
                              title: "Customer category title (index: $categoryIndex)",
                              subtitle: customerCategoryListTemp[categoryIndex].title.text,
                            ),
                            TitleAndSubtitleModel(
                              title: "Customer category subtitle (index: $subtitleIndex)",
                              subtitle: customerCategoryListTemp[categoryIndex].subtitleOptionList[subtitleIndex].text,
                            ),
                          ],
                          error: "Customer category subtitle is same as previous save.",
                        );
                      }
                    }
                  }

                  if (customerCategoryListGlobal.length >= customerCategoryListTemp.length) {
                    final bool isCategoryListSameLength = (customerCategoryListTemp[categoryIndex].subtitleOptionList.length ==
                        customerCategoryListGlobal[categoryIndex].subtitleOptionList.length);
                    if (isCategoryListSameLength) {
                      for (int subtitleIndex = 0; subtitleIndex < customerCategoryListTemp[categoryIndex].subtitleOptionList.length; subtitleIndex++) {
                        if (customerCategoryListTemp[categoryIndex].subtitleOptionList[subtitleIndex].text !=
                            customerCategoryListGlobal[categoryIndex].subtitleOptionList[subtitleIndex].text) {
                          isValid = true;
                          break;
                        }
                      }
                    } else {
                      isValid = true;
                    }
                  }
                }

                // return isValid;
                // return ValidButtonModel(isValid: isValid, errorStr: "Nothing change.");
                return ValidButtonModel(
                  isValid: isValid,
                  errorType: ErrorTypeEnum.nothingChange,
                  error: "Nothing change.",
                );
              }

              void saveFunctionOnTap() {
                void callBack() {
                  adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.customer);
                  setState(() {});
                  closeDialogGlobal(context: context);
                }

                updateCustomerInformationCategoryAdminGlobal(customerCategoryListTemp: customerCategoryListTemp, callBack: callBack, context: context);
              }

              Widget editCustomerDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                Widget paddingAddRateButtonWidget() {
                  Widget addRateButtonWidget() {
                    ValidButtonModel checkIsValid() {
                      for (int categoryIndex = 0; categoryIndex < customerCategoryListTemp.length; categoryIndex++) {
                        if (customerCategoryListTemp[categoryIndex].title.text.isEmpty) {
                          // return false;
                          // return ValidButtonModel(isValid: false, errorStr: "Customer category title must not be blank");
                          return ValidButtonModel(
                            isValid: false,
                            errorType: ErrorTypeEnum.valueOfString,
                            errorLocationList: [
                              TitleAndSubtitleModel(title: "Customer category title index", subtitle: categoryIndex.toString()),
                            ],
                            error: "Customer category title is empty.",
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
                        customerCategoryListTemp.add(CustomerInformationCategory(title: TextEditingController(), subtitleOptionList: []));
                        // hoverCategoryListTemp.add(false);
                        setStateFromDialog(() {});
                      },
                      currentAddButtonQty: customerCategoryListTemp.length,
                      maxAddButtonLimit: customerCategoryAddButtonLimitGlobal,
                    );
                  }

                  return Padding(padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.normal)), child: addRateButtonWidget());
                }

                Widget categoryElementWidget({required int categoryIndex}) {
                  // customHoverFunction({required bool isHovering}) {
                  //   hoverCategoryListTemp[categoryIndex] = isHovering;
                  //   setStateFromDialog(() {});
                  // }

                  void onDeleteUnlessDisable() {
                    customerCategoryListTemp.removeAt(categoryIndex);
                    // hoverCategoryListTemp.removeAt(categoryIndex);
                    setStateFromDialog(() {});
                  }

                  Widget subTitleWidget({required int subtitleIndex}) {
                    void onTapUnlessDisable() {}
                    Widget insideSizeBoxWidget() {
                      return textFieldGlobal(
                        controller: customerCategoryListTemp[categoryIndex].subtitleOptionList[subtitleIndex],
                        labelText: categorySubtitleCardStrGlobal,
                        level: Level.normal,
                        onChangeFromOutsiderFunction: () {
                          setStateFromDialog(() {});
                        },
                        textFieldDataType: TextFieldDataType.str,
                        onTapFromOutsiderFunction: () {},
                      );
                    }

                    void onDeleteUnlessDisable() {
                      customerCategoryListTemp[categoryIndex].subtitleOptionList.removeAt(subtitleIndex);
                      // hoverCategoryListTemp.removeAt(categoryIndex);
                      setStateFromDialog(() {});
                    }

                    return CustomButtonGlobal(
                      isDisable: true,
                      insideSizeBoxWidget: insideSizeBoxWidget(),
                      onTapUnlessDisable: onTapUnlessDisable,
                      onDeleteUnlessDisable: onDeleteUnlessDisable,
                    );
                  }

                  Widget paddingAddRateButtonSubWidget() {
                    Widget addRateButtonWidget() {
                      ValidButtonModel checkIsValid() {
                        for (int subtitleIndex = 0; subtitleIndex < customerCategoryListTemp[categoryIndex].subtitleOptionList.length; subtitleIndex++) {
                          if (customerCategoryListTemp[categoryIndex].subtitleOptionList[subtitleIndex].text.isEmpty) {
                            // return false;
                            // return ValidButtonModel(isValid: false, errorStr: "Customer category subtitle must not be blank");
                            return ValidButtonModel(
                              isValid: false,
                              errorType: ErrorTypeEnum.valueOfString,
                              errorLocationList: [
                                TitleAndSubtitleModel(title: "Customer category subtitle index", subtitle: subtitleIndex.toString()),
                              ],
                              error: "Customer category subtitle is empty.",
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
                          customerCategoryListTemp[categoryIndex].subtitleOptionList.add(TextEditingController());
                          // hoverCategoryListTemp.add(false);
                          setStateFromDialog(() {});
                        },
                        currentAddButtonQty: customerCategoryListTemp[categoryIndex].subtitleOptionList.length,
                        maxAddButtonLimit: customerCategoryAddButtonLimitGlobal,
                      );
                    }

                    return Padding(padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.normal)), child: addRateButtonWidget());
                  }

                  return Padding(
                    padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                    child: CustomButtonGlobal(
                      onTapUnlessDisable: () {},
                      onDeleteUnlessDisable: (categoryIndex == 0) ? null : onDeleteUnlessDisable,
                      insideSizeBoxWidget: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                              child: Column(
                                children: [
                                  textFieldGlobal(
                                    controller: customerCategoryListTemp[categoryIndex].title,
                                    labelText: categoryTitleCardStrGlobal,
                                    level: Level.normal,
                                    isEnabled: (categoryIndex != 0),
                                    onChangeFromOutsiderFunction: () {
                                      setStateFromDialog(() {});
                                    },
                                    textFieldDataType: TextFieldDataType.str,
                                    onTapFromOutsiderFunction: () {},
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.large), top: paddingSizeGlobal(level: Level.mini)),
                                    child: Column(children: [
                                      for (int subtitleIndex = 0;
                                          subtitleIndex < customerCategoryListTemp[categoryIndex].subtitleOptionList.length;
                                          subtitleIndex++)
                                        subTitleWidget(subtitleIndex: subtitleIndex),
                                      paddingAddRateButtonSubWidget(),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // printAndDeleteWidgetGlobal(
                          //   isDelete: true,
                          //   isHovering: hoverCategoryListTemp[categoryIndex],

                          //   onDeleteFunction: () {
                          //     customerCategoryListTemp.removeAt(categoryIndex);
                          //     hoverCategoryListTemp.removeAt(categoryIndex);
                          //     setStateFromDialog(() {});
                          //   },
                          //   onPrintFunction: () {},
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
                          for (int categoryIndex = 0; categoryIndex < customerCategoryListTemp.length; categoryIndex++)
                            categoryElementWidget(categoryIndex: categoryIndex),
                          // TextFormField(
                          //   controller: TextEditingController(text: customerCategoryListTemp[categoryIndex]),
                          //   onChanged: (String value) {
                          //     customerCategoryListTemp[categoryIndex] = value;
                          //     setStateFromDialog(() {});
                          //   },
                          //   style: textStyleGlobal(level: Level.normal),
                          // ),
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
                validSaveButtonFunction: () => validSaveButtonFunction(),
                saveFunctionOnTap: saveFunctionOnTap,
                contentFunctionReturnWidget: editCustomerDialog,
              );
            }

            askingForChangeDialogGlobal(context: context, allowFunction: categoryDialog, editSettingTypeEnum: EditSettingTypeEnum.customer);
          }

          return CustomButtonGlobal(sizeBoxWidth: sizeBoxWidthGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
        }

        return [
          categoryWidget(),
          for (int customerIndex = 0; customerIndex < customerModelListGlobal.length; customerIndex++) customerButtonWidget(customerIndex: customerIndex)
        ];
      }

      void addOnTapFunction() {
        void callback() {
          setState(() {});
        }

        askingForChangeDialogGlobal(
          context: context,
          allowFunction: () => setUpCustomerDialog(
            isCreateNewCustomer: true,
            customerIndex: null,
            context: context,
            isAdminEditing: true,
            setState: setState,
            callback: callback,
            activeLogModelList: [],
          ),
          editSettingTypeEnum: EditSettingTypeEnum.customer,
        );
      }

      void bottomFunction() {
        customerLengthIncrease = customerLengthIncrease + queryLimitNumberGlobal;
        if (customerLengthIncrease > customerModelListGlobal.length) {
          isShowSeeMoreWidget = false;
          customerLengthIncrease = customerModelListGlobal.length;
        }
      }

      return BodyTemplateSideMenu(
        title: widget.title,
        isShowSeeMoreWidget: isShowSeeMoreWidget,
        bottomFunction: bottomFunction,
        inWrapWidgetList: inWrapWidgetList(),
        addOnTapFunction: addOnTapFunction,
        currentAddButtonQty: customerModelListGlobal.length,
        maxAddButtonLimit: customerButtonLimitGlobal,
      );
    }

    // return _isLoadingOnGetCustomerList ? Container() : bodyTemplateSideMenu();
    return bodyTemplateSideMenu();
  }
}
