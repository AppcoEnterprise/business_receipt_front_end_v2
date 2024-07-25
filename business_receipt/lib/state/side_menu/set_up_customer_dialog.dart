import 'package:business_receipt/env/function/active_log.dart';
import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/drop_down_and_text_field_provider.dart';
import 'package:business_receipt/env/function/excel.dart';
import 'package:business_receipt/env/function/hover_and_button.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/request_api/customer_request_api_env.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_area_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/toggle_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/active_log.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_or_admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

void setUpCustomerDialog({
  required bool isCreateNewCustomer,
  required int? customerIndex,
  required bool isAdminEditing,
  required BuildContext context,
  required Function setState,
  required Function callback,
  required List<ActiveLogModel> activeLogModelList,
}) {
  CustomerModel customerModelTemp = CustomerModel(
    name: TextEditingController(),
    remark: TextEditingController(),
    informationList: [],
    moneyList: [],
    totalList: [],
    partnerList: [],
    invoiceCount: 0,
  );
  bool isLend = true;
  bool isInitCustomerDetail = true;
  MoneyCustomerModel moneyCustomerModel = MoneyCustomerModel(activeLogModelList: [], value: TextEditingController(), remark: TextEditingController());
  int skip = 0;
  bool outOfDataQuery = false;

  if (!isCreateNewCustomer) {
    customerModelTemp = cloneCustomer(customerIndex: customerIndex!, customerModelList: customerModelListGlobal);
  }
  // if ((customerModelTemp.deletedDate == null) && (profileModelEmployeeGlobal == null)) {
  if (profileModelEmployeeGlobal == null) {
    editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.customer);
  }

  void cancelFunctionOnTap() {
    // if (isAdminEditing) {
    void okFunction() {
      if (isAdminEditing) {
        adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.customer);
      }
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

  ValidButtonModel validSaveButtonFunction({
    required bool isCreateNewCustomer,
    required int? customerIndex,
    required bool isAdminEditing,
    required CustomerModel customerModelTemp,
    required MoneyCustomerModel moneyCustomerModel,
    required bool isLend,
    required List<CustomerModel> customerModelListMain,
  }) {
    if (isAdminEditing) {
      final bool isNameEmpty = customerModelTemp.name.text.isEmpty;
      if (isNameEmpty) {
        // return false;
        return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "customer name is empty");
      }
      for (int informationIndex = 0; informationIndex < customerModelTemp.informationList.length; informationIndex++) {
        final bool isTitleEmpty = customerModelTemp.informationList[informationIndex].title.text.isEmpty;
        final bool isSubtitleEmpty = customerModelTemp.informationList[informationIndex].subtitle.text.isEmpty;
        // if (isTitleEmpty || isSubtitleEmpty) {
        //   return false;
        // }
        if (isTitleEmpty) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfString,
            error: "title is empty",
            errorLocationList: [
              TitleAndSubtitleModel(title: "information index", subtitle: informationIndex.toString()),
              TitleAndSubtitleModel(title: "title", subtitle: customerModelTemp.informationList[informationIndex].title.text),
            ],
          );
        }
        if (isSubtitleEmpty) {
          // return false;
          return ValidButtonModel(
            isValid: false,
            errorType: ErrorTypeEnum.valueOfString,
            error: "subtitle is empty",
            errorLocationList: [
              TitleAndSubtitleModel(title: "information index", subtitle: informationIndex.toString()),
              TitleAndSubtitleModel(title: "subtitle", subtitle: customerModelTemp.informationList[informationIndex].subtitle.text),
            ],
          );
        }
      }
      for (int informationIndex = 0; informationIndex < customerModelTemp.informationList.length; informationIndex++) {
        for (int informationSubIndex = (informationIndex + 1); informationSubIndex < customerModelTemp.informationList.length; informationSubIndex++) {
          final bool isSameTitle =
              (customerModelTemp.informationList[informationIndex].title.text == customerModelTemp.informationList[informationSubIndex].title.text);
          final bool isSameSubtitle =
              (customerModelTemp.informationList[informationIndex].subtitle.text == customerModelTemp.informationList[informationSubIndex].subtitle.text);

          if (isSameTitle) {
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.compareNumber,
              error: "title is same",
              errorLocationList: [
                TitleAndSubtitleModel(title: "information index", subtitle: informationIndex.toString()),
                TitleAndSubtitleModel(title: "title", subtitle: customerModelTemp.informationList[informationIndex].title.text),
              ],
            );
          }
          if (isSameSubtitle) {
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.compareNumber,
              error: "subtitle is same",
              errorLocationList: [
                TitleAndSubtitleModel(title: "information index", subtitle: informationIndex.toString()),
                TitleAndSubtitleModel(title: "subtitle", subtitle: customerModelTemp.informationList[informationIndex].subtitle.text),
              ],
            );
          }
        }
      }
      for (int customerIndexInside = 0; customerIndexInside < customerModelListMain.length; customerIndexInside++) {
        final bool isNotSameCurrentEditingIndex = (customerIndex != customerIndexInside);
        if (isNotSameCurrentEditingIndex) {
          final bool isNameSame = (customerModelTemp.name.text == customerModelListMain[customerIndexInside].name.text);
          if (isNameSame) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfString,
              error: "name is same",
              errorLocationList: [
                TitleAndSubtitleModel(title: "customer index", subtitle: customerIndexInside.toString()),
                TitleAndSubtitleModel(title: "name", subtitle: customerModelListMain[customerIndexInside].name.text),
              ],
            );
          }
          for (int informationIndexInside = 0;
              informationIndexInside < customerModelListMain[customerIndexInside].informationList.length;
              informationIndexInside++) {
            for (int informationIndex = 0; informationIndex < customerModelTemp.informationList.length; informationIndex++) {
              final bool isSameTitle = (customerModelTemp.informationList[informationIndex].title.text ==
                  customerModelListMain[customerIndexInside].informationList[informationIndexInside].title.text);
              final bool isSameSubtitle = (customerModelTemp.informationList[informationIndex].subtitle.text ==
                  customerModelListMain[customerIndexInside].informationList[informationIndexInside].subtitle.text);
              if (isSameTitle && isSameSubtitle) {
                // return false;
                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.compareNumber,
                  error: "title and subtitle is same",
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "customer index", subtitle: customerIndexInside.toString()),
                    TitleAndSubtitleModel(
                        title: "title", subtitle: customerModelListMain[customerIndexInside].informationList[informationIndexInside].title.text),
                    TitleAndSubtitleModel(
                        title: "subtitle", subtitle: customerModelListMain[customerIndexInside].informationList[informationIndexInside].subtitle.text),
                  ],
                );
              }
            }
          }
        }
      }

      if (!isCreateNewCustomer) {
        if (customerModelListMain.isEmpty) {
          // return true;
          return ValidButtonModel(isValid: true);
        }
        bool isValid = false;
        final bool isNameNotSame = (customerModelTemp.name.text != customerModelListMain[customerIndex!].name.text);
        if (isNameNotSame) {
          isValid = true;
        }
        final bool isRemarkNotSame = (customerModelTemp.remark.text != customerModelListMain[customerIndex].remark.text);
        if (isRemarkNotSame) {
          isValid = true;
        }
        final bool isInformationListSameLength = (customerModelTemp.informationList.length == customerModelListMain[customerIndex].informationList.length);
        if (isInformationListSameLength) {
          for (int informationIndex = 0; informationIndex < customerModelTemp.informationList.length; informationIndex++) {
            final String titleStr = customerModelTemp.informationList[informationIndex].title.text;
            final String titleStrInside = customerModelListMain[customerIndex].informationList[informationIndex].title.text;
            final String subtitleStr = customerModelTemp.informationList[informationIndex].subtitle.text;
            final String subtitleStrInside = customerModelListMain[customerIndex].informationList[informationIndex].subtitle.text;
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
        final bool isPartnerListSameLength = (customerModelTemp.partnerList.length == customerModelListMain[customerIndex].partnerList.length);
        if (isPartnerListSameLength) {
          for (int partnerIndex = 0; partnerIndex < customerModelTemp.partnerList.length; partnerIndex++) {
            final ValidButtonModel validButtonModel = validSaveButtonFunction(
              customerIndex: partnerIndex,
              customerModelTemp: customerModelTemp.partnerList[partnerIndex],
              isAdminEditing: isAdminEditing,
              isCreateNewCustomer: isCreateNewCustomer,
              moneyCustomerModel: moneyCustomerModel,
              isLend: isLend,
              customerModelListMain: customerModelListGlobal[customerIndex].partnerList,
            );
            if (validButtonModel.isValid) {
              isValid = true;
              break;
            }
          }
        } else {
          isValid = true;
        }
        // return isValid;
        return ValidButtonModel(isValid: isValid, errorType: ErrorTypeEnum.nothingChange);
      }
    } else {
      final bool isBorrowOrLendEmpty = moneyCustomerModel.value.text.isEmpty;
      final bool isMoneyTypeStrNull = (moneyCustomerModel.moneyType == null);
      if (isBorrowOrLendEmpty) {
        // return false;
        return ValidButtonModel(
          isValid: false,
          errorType: ErrorTypeEnum.valueOfNumber,
          error: "value is empty",
          errorLocationList: [TitleAndSubtitleModel(title: "value", subtitle: moneyCustomerModel.value.text)],
        );
      }
      if (isMoneyTypeStrNull) {
        // return false;
      }
      final bool isValueEqual0 = (textEditingControllerToDouble(controller: moneyCustomerModel.value) == 0);
      if (isValueEqual0) {
        // return false;
        return ValidButtonModel(
          isValid: false,
          errorType: ErrorTypeEnum.compareNumber,
          error: "value is 0",
          errorLocationList: [TitleAndSubtitleModel(title: "value", subtitle: moneyCustomerModel.value.text)],
        );
      }

      if (!isLend) {
        final ValidButtonModel lowerMoneyStockModel = checkLowerTheExistMoney(
          moneyNumber: textEditingControllerToDouble(controller: moneyCustomerModel.value)!,
          moneyType: moneyCustomerModel.moneyType!,
        );
        if (!lowerMoneyStockModel.isValid) {
          return lowerMoneyStockModel;
        }
      }
    }

    return ValidButtonModel(isValid: true);
  }

  void updateOtherInOrOutComeToDBOrPrint({required isPrint}) {
    closeDialogGlobal(context: context);
    setFinalEditionActiveLog(activeLogModelList: activeLogModelList);
    moneyCustomerModel.activeLogModelList = activeLogModelList;
    void callBack() {
      if (isPrint && !isAdminEditing) {
        printBorrowOrLendInvoice(context: context, borrowOrLend: borrowOrLendModelListEmployeeGlobal.first);
      }
      if (isAdminEditing) {
        adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.customer);
      }
      // setState(() {});
      callback();
    }

    if (isAdminEditing) {
      updateCustomerInformationAdminGlobal(callBack: callBack, context: context, customerModelTemp: customerModelTemp, isLend: isLend);
    } else {
      moneyCustomerModel.employeeId = profileModelEmployeeGlobal!.id;
      moneyCustomerModel.employeeName = profileModelEmployeeGlobal!.name.text;
      updateCustomerMoneyEmployeeGlobal(
          callBack: callBack, context: context, moneyCustomerModel: moneyCustomerModel, customerId: customerModelTemp.id!, isLend: isLend);
    }
  }

  void saveFunctionOnTap() {
    addActiveLogElement(
      activeLogModelList: activeLogModelList,
      activeLogModel: ActiveLogModel(idTemp: "save or save and print", activeType: ActiveLogTypeEnum.selectToggle, locationList: [
        Location(title: "customer index", subtitle: customerIndex.toString()),
        Location(title: "customer name", subtitle: customerModelTemp.name.text),
        Location(color: ColorEnum.blue, title: "button name", subtitle: "save button"),
      ]),
    );
    updateOtherInOrOutComeToDBOrPrint(isPrint: false);
  }

  Function? saveAndPrintProviderFunction() {
    void saveAndPrintFunctionOnTap() {
      addActiveLogElement(
        activeLogModelList: activeLogModelList,
        activeLogModel: ActiveLogModel(idTemp: "save or save and print", activeType: ActiveLogTypeEnum.selectToggle, locationList: [
          Location(title: "customer index", subtitle: customerIndex.toString()),
          Location(title: "customer name", subtitle: customerModelTemp.name.text),
          Location(color: ColorEnum.blue, title: "button name", subtitle: "save and print button"),
        ]),
      );
      updateOtherInOrOutComeToDBOrPrint(isPrint: true);
    }

    return isAdminEditing ? null : saveAndPrintFunctionOnTap;
  }

  ValidButtonModel validDeleteFunctionOnTap() {
    for (int moneyIndex = 0; moneyIndex < customerModelTemp.totalList.length; moneyIndex++) {
      final double valueNumber = textEditingControllerToDouble(controller: customerModelTemp.totalList[moneyIndex].amount)!;
      final bool isValueNotEqualZero = (valueNumber != 0);
      if (isValueNotEqualZero) {
        return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfNumber, error: "value is not 0", errorLocationList: [
          TitleAndSubtitleModel(title: "money type", subtitle: customerModelTemp.totalList[moneyIndex].moneyType),
          TitleAndSubtitleModel(title: "total money", subtitle: customerModelTemp.totalList[moneyIndex].amount.text)
        ]);
      }
    }
    // return true;
    return ValidButtonModel(isValid: true);
  }

  Function? deleteFunctionOrNull() {
    if (isCreateNewCustomer || !isAdminEditing || (customerModelTemp.deletedDate != null)) {
      return null;
    } else {
      void deleteFunctionOnTap() {
        void okFunction() {
          void callback() {
            adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.customer);
            setState(() {});
            closeDialogGlobal(context: context);
          }

          deleteCustomerGlobal(
              callBack: callback, context: context, customerId: customerModelTemp.id!); //delete the existing card in database and local storage
        }

        void cancelFunction() {}
        confirmationDialogGlobal(
          context: context,
          okFunction: okFunction,
          cancelFunction: cancelFunction,
          titleStr: "$deleteGlobal ${customerModelTemp.name.text}",
          subtitleStr: deleteConfirmGlobal,
        );
      }

      return deleteFunctionOnTap;
    }
  }

  Function? restoreFunctionOrNull() {
    if (isCreateNewCustomer || !isAdminEditing || (customerModelTemp.deletedDate == null)) {
      return null;
    } else {
      void restoreFunction() {
        void okFunction() {
          void callback() {
            adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.customer);
            setState(() {});
            closeDialogGlobal(context: context);
          }

          restoreCustomerGlobal(
              callBack: callback, context: context, customerId: customerModelTemp.id!); //delete the existing card in database and local storage
        }

        void cancelFunction() {}
        confirmationDialogGlobal(
          context: context,
          okFunction: okFunction,
          cancelFunction: cancelFunction,
          titleStr: "$restoreGlobal ${customerModelTemp.name.text}",
          subtitleStr: restoreConfirmGlobal,
        );
      }

      return restoreFunction;
    }
  }

  Widget editCustomerDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
    if (!isCreateNewCustomer) {
      if (isInitCustomerDetail) {
        void callBack() {
          isInitCustomerDetail = false;
          skip = queryLimitNumberGlobal;
          setStateFromDialog(() {});
        }

        getCustomerDetailGlobal(callBack: callBack, context: context, customerModelTemp: customerModelTemp, skip: skip);
      }
    } else {
      isInitCustomerDetail = false;
    }

    if (customerModelTemp.informationList.isEmpty) {
      customerModelTemp.informationList.add(
        InformationCustomerModel(
          title: TextEditingController(text: customerCategoryListGlobal.first.title.text),
          subtitle: TextEditingController(),
        ),
      );
    }
    Widget informationWidget({
      required String titleStr,
      required bool isAdminEditing,
      required CustomerModel customerModelTemp,
      required Function setStateFromDialog,
    }) {
      if (customerModelTemp.informationList.isEmpty) {
        customerModelTemp.informationList.add(
          InformationCustomerModel(
            title: TextEditingController(text: customerCategoryListGlobal.first.title.text),
            subtitle: TextEditingController(),
          ),
        );
      }
      Widget paddingVertical({required Widget widget}) {
        return Padding(padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.mini)), child: widget);
      }

      Widget nameTextFieldWidget() {
        void onTapFromOutsiderFunction() {}
        void onChangeFromOutsiderFunction() {
          setStateFromDialog(() {});
        }

        return textFieldGlobal(
          isEnabled: isAdminEditing && (customerModelTemp.deletedDate == null),
          textFieldDataType: TextFieldDataType.str,
          controller: customerModelTemp.name,
          onTapFromOutsiderFunction: onTapFromOutsiderFunction,
          onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
          labelText: customerNameStrGlobal,
          level: Level.normal,
        );
      }

      Widget informationListWidget() {
        Widget informationWidget({required int informationIndex}) {
          Widget titleAndSubtitleTextFieldWidget() {
            Widget titleTextFieldWidget() {
              void onTapFromOutsiderFunction() {}
              void onChangeFromOutsiderFunction() {
                setStateFromDialog(() {});
              }

              String selectedStr = customerModelTemp.informationList[informationIndex].title.text;
              List<String> menuItemStrList = [];
              for (int categoryIndex = 0; categoryIndex < customerCategoryListGlobal.length; categoryIndex++) {
                final String titleStr = customerCategoryListGlobal[categoryIndex].title.text;
                menuItemStrList.add(titleStr);
              }
              bool isSelectedOther = customerModelTemp.informationList[informationIndex].isSelectedTitle;
              if (customerModelTemp.informationList[informationIndex].title.text.isNotEmpty) {
                isSelectedOther = !menuItemStrList.contains(customerModelTemp.informationList[informationIndex].title.text);
              }
              void onTapFunction() {}

              void onChangedDropDrownFunction({required String value, required int index}) {
                final bool isSelectedOtherSub = (value == otherStrGlobal);
                customerModelTemp.informationList[informationIndex].isSelectedTitle = isSelectedOtherSub;
                if (isSelectedOtherSub) {
                  customerModelTemp.informationList[informationIndex].title.text = "";
                } else {
                  customerModelTemp.informationList[informationIndex].title.text = value;
                }
                customerModelTemp.informationList[informationIndex].subtitle.text = "";
                setStateFromDialog(() {});
              }

              void onDeleteFunction() {
                customerModelTemp.informationList[informationIndex].isSelectedTitle = false;
                customerModelTemp.informationList[informationIndex].title.text = "";
                customerModelTemp.informationList[informationIndex].subtitle.text = "";
                setStateFromDialog(() {});
              }

              void onChangedTextFieldFunction() {
                customerModelTemp.informationList[informationIndex].subtitle.text = "";
                setStateFromDialog(() {});
              }

              return (menuItemStrList.isNotEmpty && isAdminEditing)
                  ? DropDownAndTextFieldProviderGlobal(
                      isSort: false,
                      level: Level.mini,
                      labelStr: titleCustomerStrGlobal,
                      onTapFunction: onTapFunction,
                      onChangedDropDrownFunction: onChangedDropDrownFunction,
                      selectedStr: selectedStr.isEmpty ? null : selectedStr,
                      menuItemStrList: menuItemStrList,
                      controller: customerModelTemp.informationList[informationIndex].title,
                      textFieldDataType: TextFieldDataType.str,
                      isEnabled: isAdminEditing && (customerModelTemp.deletedDate == null) && (informationIndex != 0),
                      isShowTextField: isSelectedOther,
                      onDeleteFunction: onDeleteFunction,
                      onChangedTextFieldFunction: onChangedTextFieldFunction,
                    )
                  : textFieldGlobal(
                      isEnabled: isAdminEditing && (customerModelTemp.deletedDate == null) && (informationIndex != 0),
                      textFieldDataType: TextFieldDataType.str,
                      controller: customerModelTemp.informationList[informationIndex].title,
                      onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                      onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                      labelText: titleCustomerStrGlobal,
                      level: Level.mini,
                    );
            }

            Widget paddingLeftSubtitleTextFieldWidget() {
              Widget subtitleTextFieldWidget() {
                void onTapFromOutsiderFunction() {}
                void onChangeFromOutsiderFunction() {
                  setStateFromDialog(() {});
                }

                String selectedStr = customerModelTemp.informationList[informationIndex].subtitle.text;
                List<String> menuItemStrList = [];
                final int matchIndex =
                    customerCategoryListGlobal.indexWhere((element) => element.title.text == customerModelTemp.informationList[informationIndex].title.text);
                if (matchIndex != -1) {
                  for (int subtitleIndex = 0; subtitleIndex < customerCategoryListGlobal[matchIndex].subtitleOptionList.length; subtitleIndex++) {
                    menuItemStrList.add(customerCategoryListGlobal[matchIndex].subtitleOptionList[subtitleIndex].text);
                  }
                }

                // for (int categoryIndex = 0; categoryIndex < customerCategoryListGlobal.length; categoryIndex++) {
                //   final String subtitleStr = customerCategoryListGlobal[categoryIndex].subtitle.text;
                //   menuItemStrList.add(subtitleStr);
                // }
                bool isSelectedOther = customerModelTemp.informationList[informationIndex].isSelectedSubtitle;
                if (customerModelTemp.informationList[informationIndex].subtitle.text.isNotEmpty) {
                  isSelectedOther = !menuItemStrList.contains(customerModelTemp.informationList[informationIndex].subtitle.text);
                }
                void onTapFunction() {}

                void onChangedDropDrownFunction({required String value, required int index}) {
                  final bool isSelectedOtherRate = (value == otherStrGlobal);
                  customerModelTemp.informationList[informationIndex].isSelectedSubtitle = isSelectedOtherRate;
                  if (isSelectedOtherRate) {
                    customerModelTemp.informationList[informationIndex].subtitle.text = "";
                  } else {
                    customerModelTemp.informationList[informationIndex].subtitle.text = value;
                  }
                  setStateFromDialog(() {});
                }

                void onDeleteFunction() {
                  customerModelTemp.informationList[informationIndex].isSelectedSubtitle = false;
                  customerModelTemp.informationList[informationIndex].subtitle.text = "";
                  setStateFromDialog(() {});
                }

                void onChangedTextFieldFunction() {
                  setStateFromDialog(() {});
                }

                return (menuItemStrList.isNotEmpty && isAdminEditing)
                    ? DropDownAndTextFieldProviderGlobal(
                        isSort: false,
                        level: Level.mini,
                        labelStr: subtitleCustomerStrGlobal,
                        onTapFunction: onTapFunction,
                        onChangedDropDrownFunction: onChangedDropDrownFunction,
                        selectedStr: selectedStr.isEmpty ? null : selectedStr,
                        menuItemStrList: menuItemStrList,
                        controller: customerModelTemp.informationList[informationIndex].subtitle,
                        textFieldDataType: TextFieldDataType.str,
                        isEnabled: isAdminEditing && (customerModelTemp.deletedDate == null),
                        isShowTextField: isSelectedOther || menuItemStrList.isEmpty,
                        onDeleteFunction: onDeleteFunction,
                        onChangedTextFieldFunction: onChangedTextFieldFunction,
                      )
                    : textFieldGlobal(
                        isEnabled: isAdminEditing && (customerModelTemp.deletedDate == null),
                        textFieldDataType: TextFieldDataType.str,
                        controller: customerModelTemp.informationList[informationIndex].subtitle,
                        onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                        onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                        labelText: subtitleCustomerStrGlobal,
                        level: Level.mini,
                      );
              }

              return Padding(padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)), child: subtitleTextFieldWidget());
            }

            return Row(children: [
              Expanded(flex: flexTypeGlobal, child: titleTextFieldWidget()),
              Expanded(flex: flexValueGlobal, child: paddingLeftSubtitleTextFieldWidget())
            ]);
          }

          void onTapUnlessDisable() {
            //TODO: do something and setState
          }

          Function? onDeleteUnlessDisableProvider() {
            if (isAdminEditing && (customerModelTemp.deletedDate == null) && (informationIndex != 0)) {
              void onDeleteUnlessDisable() {
                customerModelTemp.informationList.removeAt(informationIndex);
                setStateFromDialog(() {});
              }

              return onDeleteUnlessDisable;
            } else {
              return null;
            }
          }

          return Padding(
            padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
            child: CustomButtonGlobal(
              // isDisable: true,
              onDeleteUnlessDisable: onDeleteUnlessDisableProvider(),
              insideSizeBoxWidget: titleAndSubtitleTextFieldWidget(),
              onTapUnlessDisable: onTapUnlessDisable,
            ),
          );
          // return titleAndSubtitleTextFieldWidget();
        }

        Widget paddingAddRateButtonWidget() {
          Widget addRateButtonWidget() {
            ValidButtonModel isValid() {
              for (int informationIndex = 0; informationIndex < customerModelTemp.informationList.length; informationIndex++) {
                final bool isTitleEmpty = customerModelTemp.informationList[informationIndex].title.text.isEmpty;
                final bool isSubtitleEmpty = customerModelTemp.informationList[informationIndex].subtitle.text.isEmpty;
                if (isTitleEmpty) {
                  // return false;
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfString,
                    error: "title is empty",
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "information index", subtitle: informationIndex.toString()),
                    ],
                  );
                }
                if (isSubtitleEmpty) {
                  // return false;
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfString,
                    error: "subtitle is empty",
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "information index", subtitle: informationIndex.toString()),
                    ],
                  );
                }
              }
              // return isAdminEditing && (customerModelTemp.deletedDate == null);
              if (!isAdminEditing) {
                return ValidButtonModel(isValid: false, error: "employee does not have permission to edit");
              }
              if (customerModelTemp.deletedDate != null) {
                return ValidButtonModel(isValid: false, error: "customer is deleted");
              }
              return ValidButtonModel(isValid: true);
            }

            Function onTapFunctionProvider() {
              // if (isAdminEditing) {
              void onTapFunction() {
                // if (customerModelTemp.informationList.isEmpty) {
                //   customerModelTemp.informationList.add(
                //     InformationCustomerModel(
                //       title: TextEditingController(text: customerCategoryListGlobal.first.title.text),
                //       subtitle: TextEditingController(),
                //     ),
                //   );
                // } else {
                customerModelTemp.informationList.add(InformationCustomerModel(title: TextEditingController(), subtitle: TextEditingController()));
                // }
                setStateFromDialog(() {});
              }

              return onTapFunction;
              // } else {
              //   return null;
              // }
            }

            return addButtonOrContainerWidget(
              context: context,
              level: Level.mini,
              validModel: isValid(),
              onTapFunction: onTapFunctionProvider(),
              currentAddButtonQty: customerModelTemp.informationList.length,
              maxAddButtonLimit: customerInformationAddButtonLimitGlobal,
            );
          }

          return Padding(padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.normal)), child: addRateButtonWidget());
        }

        return Column(children: [
          for (int informationIndex = 0; informationIndex < customerModelTemp.informationList.length; informationIndex++)
            informationWidget(informationIndex: informationIndex),
          paddingAddRateButtonWidget()
        ]);
      }

      Widget remarkTextFieldWidget() {
        void onTapFromOutsiderFunction() {}
        void onChangeFromOutsiderFunction() {
          setStateFromDialog(() {});
        }

        return textAreaGlobal(
          isEnabled: isAdminEditing && (customerModelTemp.deletedDate == null),
          controller: customerModelTemp.remark,
          onTapFromOutsiderFunction: onTapFromOutsiderFunction,
          onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
          labelText: remarkOptionalStrGlobal,
          level: Level.normal,
        );
      }

      Widget titleTextFieldWidget() {
        return Text(titleStr, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold));
      }

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        titleTextFieldWidget(),
        // Expanded(
        //   child: SingleChildScrollView(
        //     child:
        Padding(
          padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
          child: Column(children: [
            paddingVertical(widget: nameTextFieldWidget()),
            paddingVertical(widget: informationListWidget()),
            paddingVertical(widget: remarkTextFieldWidget()),
          ]),
        ),
        //   ),
        // ),
      ]);
    }

    Widget paddingBottomCreateCustomerWidget() {
      Widget createCustomerWidget() {
        Widget borrowOrLendingWidget() {
          Widget paddingBottomWidget({required Widget widget}) {
            return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: widget);
          }

          Widget titleTextFieldWidget() {
            return Text(borrowOrLendingStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold));
          }

          Widget borrowOrLendProviderWidget() {
            Widget borrowOrLendWidget() {
              Widget insideSizeBoxWidget() {
                Widget toggleWidget() {
                  void onToggle() {
                    isLend = !isLend;

                    addActiveLogElement(
                      activeLogModelList: activeLogModelList,
                      activeLogModel: ActiveLogModel(idTemp: "toggle button", activeType: ActiveLogTypeEnum.selectToggle, locationList: [
                        Location(title: "customer index", subtitle: customerIndex.toString()),
                        Location(title: "customer name", subtitle: customerModelListGlobal[customerIndex!].name.text),
                        Location(
                          color: isLend ? ColorEnum.green : ColorEnum.red,
                          title: "toggle button",
                          subtitle: isLend ? "Borrow to Lend" : "Lend to Borrow",
                        ),
                      ]),
                    );
                    setStateFromDialog(() {});
                  }

                  return borrowAndLendToggleWidgetGlobal(isLeftSelected: isLend, onToggle: onToggle);
                }

                Widget valueAndMoneyTypeWidget() {
                  Widget valueTextFieldWidget() {
                    void onTapFromOutsiderFunction() {}
                    final String amountTemp = moneyCustomerModel.value.text;
                    void onChangeFromOutsiderFunction() {
                      final String amountChangeTemp = moneyCustomerModel.value.text;
                      addActiveLogElement(
                        activeLogModelList: activeLogModelList,
                        activeLogModel: ActiveLogModel(idTemp: "amount textfield", activeType: ActiveLogTypeEnum.typeTextfield, locationList: [
                          Location(title: "customer index", subtitle: customerIndex.toString()),
                          Location(title: "customer name", subtitle: customerModelListGlobal[customerIndex!].name.text),
                          Location(
                            color: (amountTemp.length < amountChangeTemp.length) ? ColorEnum.green : ColorEnum.red,
                            title: "amount textfield",
                            subtitle: "${amountTemp.isEmpty ? "" : "$amountTemp to "}$amountChangeTemp",
                          ),
                        ]),
                      );
                      setStateFromDialog(() {});
                    }

                    return textFieldGlobal(
                      textFieldDataType: TextFieldDataType.double,
                      controller: moneyCustomerModel.value,
                      onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                      onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                      labelText: amountStrGlobal,
                      level: Level.normal,
                    );
                  }

                  Widget moneyTypeDropDrownWidget() {
                    void onTapFunction() {}
                    final String? moneyTypeTemp = moneyCustomerModel.moneyType;
                    void onChangedFunction({required String value, required int index}) {
                      moneyCustomerModel.moneyType = value;
                      addActiveLogElement(
                        activeLogModelList: activeLogModelList,
                        activeLogModel: ActiveLogModel(idTemp: "select money type", activeType: ActiveLogTypeEnum.typeTextfield, locationList: [
                          Location(title: "customer index", subtitle: customerIndex.toString()),
                          Location(title: "customer name", subtitle: customerModelListGlobal[customerIndex!].name.text),
                          Location(title: "select money type", subtitle: "${(moneyTypeTemp == null) ? "" : "$moneyTypeTemp to "}$value"),
                        ]),
                      );
                      setStateFromDialog(() {});
                    }

                    return customDropdown(
                      level: Level.normal,
                      labelStr: moneyTypeStrGlobal,
                      onTapFunction: onTapFunction,
                      onChangedFunction: onChangedFunction,
                      selectedStr: moneyCustomerModel.moneyType,
                      menuItemStrList: moneyTypeOnlyList(moneyTypeDefault: moneyCustomerModel.moneyType, isNotCheckDeleted: isAdminEditing),
                    );
                  }

                  Widget paddingRightWidget({required Widget widget}) {
                    return Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)), child: widget);
                  }

                  return Row(children: [
                    (moneyCustomerModel.moneyType == null)
                        ? Container()
                        : Expanded(flex: flexValueGlobal, child: paddingRightWidget(widget: valueTextFieldWidget())),
                    Expanded(flex: flexTypeGlobal, child: moneyTypeDropDrownWidget())
                  ]);
                }

                Widget detailTextFieldWidget() {
                  void onTapFromOutsiderFunction() {}
                  final String remarkTemp = moneyCustomerModel.remark.text;
                  void onChangeFromOutsiderFunction() {
                    final String remarkChangeTemp = moneyCustomerModel.remark.text;
                    addActiveLogElement(
                      activeLogModelList: activeLogModelList,
                      activeLogModel: ActiveLogModel(idTemp: "remark textfield", activeType: ActiveLogTypeEnum.typeTextfield, locationList: [
                        Location(title: "customer index", subtitle: customerIndex.toString()),
                        Location(title: "customer name", subtitle: customerModelListGlobal[customerIndex!].name.text),
                        Location(
                          color: (remarkTemp.length < remarkChangeTemp.length) ? ColorEnum.green : ColorEnum.red,
                          title: "remark textfield",
                          subtitle: "${remarkTemp.isEmpty ? "" : "$remarkTemp to "}$remarkChangeTemp",
                        ),
                      ]),
                    );
                    setStateFromDialog(() {});
                  }

                  return textAreaGlobal(
                    controller: moneyCustomerModel.remark,
                    onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                    onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                    labelText: remarkOptionalStrGlobal,
                    level: Level.normal,
                  );
                }

                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  paddingBottomWidget(widget: toggleWidget()),
                  paddingBottomWidget(widget: valueAndMoneyTypeWidget()),
                  detailTextFieldWidget(),
                ]);
              }

              void onTapUnlessDisable() {}

              return CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
            }

            return isAdminEditing ? Container() : paddingBottomWidget(widget: borrowOrLendWidget());
          }

          Widget scrollMoneyTypeListWidget() {
            Widget amountAndMoneyTypeWidget({required int totalIndex}) {
              void onTapUnlessDisable() {}

              Widget insideSizeBoxWidget() {
                final String moneyTypeStr = customerModelTemp.totalList[totalIndex].moneyType;
                final String amountStr = customerModelTemp.totalList[totalIndex].amount.text;
                return Column(
                  children: [
                    scrollText(
                        textStr: amountStr, textStyle: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold), alignment: Alignment.topCenter),
                    Text(moneyTypeStr, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                  ],
                );
              }

              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable),
              );
            }

            bool validPrintFunctionOnTap() {
              return customerModelTemp.totalList.isNotEmpty && !isAdminEditing;
            }

            void printFunctionOnTap() {
              printLoanInvoiceInvoice(context: context, customerName: customerModelTemp.name.text, totalList: customerModelTemp.totalList);
            }

            Future<void> exportToExcelFunctionOnTap() async {
              final DateTime currentDate = DateTime.now();
              DateTime? targetDate = await showDatePicker(
                context: context,
                initialDate: currentDate,
                firstDate: firstDateGlobal!,
                lastDate: currentDate,
              );
              if (targetDate == null) return;
              List<MoneyCustomerModelMoneyType> borrowOrLendModelListADay = [];
              void callBack() {
                Excel excel = Excel.createExcel();
                Sheet sheetObject = excel["borrowing and lending"];
                excel.delete("Sheet1");
                writeExcel(column: 0, row: 0, isTitle: true, value: "Total", sheetObject: sheetObject);
                writeExcel(column: 1, row: 0, isTitle: true, value: "A Day", sheetObject: sheetObject);
                writeExcel(column: 2, row: 0, isTitle: true, value: "Current", sheetObject: sheetObject);
                for (int borrowAndLendIndex = 0; borrowAndLendIndex < borrowOrLendModelListADay.length; borrowAndLendIndex++) {
                  // final int columnTotalByADay = borrowAndLendIndex * 3;
                  final String moneyTypeStr = borrowOrLendModelListADay[borrowAndLendIndex].moneyType;
                  final double amount = borrowOrLendModelListADay[borrowAndLendIndex].totalForADay;
                  final int totalIndex = customerModelTemp.totalList.indexWhere((element) => element.moneyType == moneyTypeStr);
                  final double total = textEditingControllerToDouble(controller: customerModelTemp.totalList[totalIndex].amount)!;
                  writeExcel(column: 0, row: borrowAndLendIndex + 1, isTitle: false, value: total, sheetObject: sheetObject);
                  writeExcel(column: 1, row: borrowAndLendIndex + 1, isTitle: false, value: amount, sheetObject: sheetObject);
                  writeExcel(column: 2, row: borrowAndLendIndex + 1, isTitle: false, value: moneyTypeStr, sheetObject: sheetObject);

                  int rowMoneyList = borrowOrLendModelListADay.length + 2;
                  for (int borrowAndLendSubIndex = 0; borrowAndLendSubIndex < borrowAndLendIndex; borrowAndLendSubIndex++) {
                    rowMoneyList = rowMoneyList + borrowOrLendModelListADay[borrowAndLendSubIndex].moneyList.length + 2;
                  }
                  writeExcel(column: 0, row: rowMoneyList, isTitle: true, value: "Date", sheetObject: sheetObject);
                  writeExcel(column: 1, row: rowMoneyList, isTitle: true, value: "Amount", sheetObject: sheetObject);
                  writeExcel(column: 2, row: rowMoneyList, isTitle: true, value: "Current", sheetObject: sheetObject);
                  writeExcel(column: 3, row: rowMoneyList, isTitle: true, value: "Detail", sheetObject: sheetObject);
                  for (int moneyIndex = 0; moneyIndex < borrowOrLendModelListADay[borrowAndLendIndex].moneyList.length; moneyIndex++) {
                    final String dateStr = formatFullDateToStr(date: borrowOrLendModelListADay[borrowAndLendIndex].moneyList[moneyIndex].date!);
                    final double amount = textEditingControllerToDouble(controller: borrowOrLendModelListADay[borrowAndLendIndex].moneyList[moneyIndex].value)!;
                    final String moneyTypeStr = borrowOrLendModelListADay[borrowAndLendIndex].moneyList[moneyIndex].moneyType!;
                    final String detail = borrowOrLendModelListADay[borrowAndLendIndex].moneyList[moneyIndex].remark.text;

                    writeExcel(column: 0, row: (rowMoneyList + moneyIndex + 1), isTitle: false, value: dateStr, sheetObject: sheetObject);
                    writeExcel(column: 1, row: (rowMoneyList + moneyIndex + 1), isTitle: false, value: amount, sheetObject: sheetObject);
                    writeExcel(column: 2, row: (rowMoneyList + moneyIndex + 1), isTitle: false, value: moneyTypeStr, sheetObject: sheetObject);
                    writeExcel(column: 3, row: (rowMoneyList + moneyIndex + 1), isTitle: false, value: detail, sheetObject: sheetObject);
                  }
                }
                excel.save(
                  fileName: "${customerModelTemp.name.text} and ${profileModelAdminGlobal!.name.text} at ${formatDateDateToStr(date: targetDate)}.xlsx",
                );
              }

              getBorrowOrLendListADayEmployeeGlobal(
                callBack: callBack,
                context: context,
                borrowOrLendModelListADay: borrowOrLendModelListADay,
                targetDate: targetDate,
              );
            }

            return SizedBox(
              width: moneyTypeWidthSizeBoxGlobal,
              child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                    child: Column(
                      children: [
                        for (int totalIndex = 0; totalIndex < customerModelTemp.totalList.length; totalIndex++)
                          amountAndMoneyTypeWidget(totalIndex: totalIndex),
                        Padding(
                          padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                          child: printButtonOrContainerWidget(
                            context: context,
                            level: Level.mini,
                            isExpanded: true,
                            onTapFunction: validPrintFunctionOnTap() ? printFunctionOnTap : null,
                          ),
                        ),
                        validPrintFunctionOnTap()
                            ? exportToExcelButtonOrContainerWidget(
                                context: context, level: Level.mini, isExpanded: true, onTapFunction: exportToExcelFunctionOnTap)
                            : Container(),
                      ],
                    )),
              ),
            );
          }

          Widget scrollMoneyTypeDetailListWidget() {
            List<Widget> inWrapWidgetList() {
              Widget lendOrBorrowWidget({required int moneyIndex}) {
                Widget insideSizeBoxWidget() {
                  Widget titleAndDateWidget() {
                    Widget titleTextWidget() {
                      final double lendOrBorrowNumber = textEditingControllerToDouble(controller: customerModelTemp.moneyList[moneyIndex].value)!;
                      final bool isLend = (lendOrBorrowNumber > 0);
                      return Text(isLend ? lendTitleStrGlobal : borrowTitleStrGlobal, style: textStyleGlobal(level: Level.mini, fontWeight: FontWeight.bold));
                    }

                    Widget dateTextWidget() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Text(formatFullDateToStr(date: customerModelTemp.moneyList[moneyIndex].date!), style: textStyleGlobal(level: Level.mini))],
                      );
                    }

                    return Row(children: [titleTextWidget(), Spacer(), dateTextWidget()]);
                  }

                  Widget amountTextWidget() {
                    final String lendOrBorrowStr = customerModelTemp.moneyList[moneyIndex].value.text;
                    final String lendOrBorrowMoneyTypeStr = customerModelTemp.moneyList[moneyIndex].moneyType!;
                    final double lendOrBorrowNumber = textEditingControllerToDouble(controller: customerModelTemp.moneyList[moneyIndex].value)!;
                    final bool isLend = (lendOrBorrowNumber > 0);
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.mini)),
                      child: Row(children: [
                        Text("$amountStrGlobal: ", style: textStyleGlobal(level: Level.mini)),
                        Text("$lendOrBorrowStr $lendOrBorrowMoneyTypeStr",
                            style: textStyleGlobal(level: Level.mini, color: isLend ? positiveColorGlobal : negativeColorGlobal)),
                      ]),
                    );
                  }

                  Widget invoiceIdText() {
                    final String invoiceId = customerModelTemp.moneyList[moneyIndex].id!;
                    return Text("$invoiceIdStrGlobal: $invoiceId", style: textStyleGlobal(level: Level.mini));
                  }

                  Widget remarkWidget() {
                    final String remark = customerModelTemp.moneyList[moneyIndex].remark.text;
                    return remark.isEmpty
                        ? Container()
                        : Row(
                            children: [Expanded(child: Text("$remarkStrGlobal: ${remark.replaceAll("|", "\n")}", style: textStyleGlobal(level: Level.mini)))]);
                  }

                  Widget printOrContainerWidget() {
                    // Widget printButtonWidget() {
                    //   bool isValid() {
                    //     // return !isAdminEditing;
                    //     return true;
                    //   }

                    void onTapFunction() {
                      customerModelTemp.moneyList[moneyIndex].customerName = customerModelTemp.name.text;
                      printBorrowOrLendInvoice(context: context, borrowOrLend: customerModelTemp.moneyList[moneyIndex]);
                    }

                    // return printButtonOrContainerWidget(level: Level.mini, isValid: isValid(), onTapFunction: onTapFunction);
                    // }

                    // return customerModelTemp.moneyList[moneyIndex].isHover
                    //     ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [printButtonWidget()])
                    //     : Container();
                    return !isAdminEditing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              printAndDeleteWidgetGlobal(
                                context: context,
                                isHovering: customerModelTemp.moneyList[moneyIndex].isHover,
                                onPrintFunction: onTapFunction,
                                onDeleteFunction: null,
                                isDelete: false,
                              ),
                            ],
                          )
                        : Container();
                  }

                  Widget employeeIdText() {
                    final String employeeIdStr = customerModelTemp.moneyList[moneyIndex].employeeId!;
                    final String employeeNameStr = customerModelTemp.moneyList[moneyIndex].employeeName!;
                    return Text("$employeeNameAndIdStrGlobal: $employeeNameStr | $employeeIdStr", style: textStyleGlobal(level: Level.mini));
                  }

                  Widget detailWidget() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [amountTextWidget(), invoiceIdText(), employeeIdText(), remarkWidget(), printOrContainerWidget()],
                    );
                  }

                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleAndDateWidget(), detailWidget()]);
                }

                void onTapUnlessDisable() {}
                customHoverFunction({required bool isHovering}) {
                  customerModelTemp.moneyList[moneyIndex].isHover = isHovering;
                  setStateFromDialog(() {});
                }

                return CustomButtonGlobal(
                  insideSizeBoxWidget: insideSizeBoxWidget(),
                  onTapUnlessDisable: onTapUnlessDisable,
                  customHoverFunction: customHoverFunction,
                );
              }

              return [for (int moneyIndex = 0; moneyIndex < customerModelTemp.moneyList.length; moneyIndex++) lendOrBorrowWidget(moneyIndex: moneyIndex)];
            }

            void topFunction() {}
            void bottomFunction() {
              if (!outOfDataQuery) {
                final int beforeQuery = customerModelTemp.moneyList.length;
                void callBack() {
                  final int afterQuery = customerModelTemp.moneyList.length;
                  if (beforeQuery == afterQuery) {
                    outOfDataQuery = true;
                  } else {
                    skip = skip + queryLimitNumberGlobal;
                  }
                  setStateFromDialog(() {});
                }

                getCustomerDetailGlobal(callBack: callBack, context: context, customerModelTemp: customerModelTemp, skip: skip);
              }
            }

            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: (!outOfDataQuery && customerModelTemp.moneyList.isNotEmpty),
            );
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            paddingBottomWidget(widget: titleTextFieldWidget()),
            borrowOrLendProviderWidget(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [scrollMoneyTypeListWidget(), Expanded(child: scrollMoneyTypeDetailListWidget())],
              ),
            ),
          ]);
        }

        Widget paddingLeftWidget({required Widget widget}) {
          return Padding(padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)), child: widget);
        }

        Function customerInformationEdit({
          required BuildContext context,
          required bool isAdminEditing,
          required CustomerModel customerModelTemp,
          required int partnerIndex,
        }) {
          void customerInformationEditSub() {
            final bool isCreateNewCustomerPartner = (partnerIndex == customerModelTemp.partnerList.length);
            if (isCreateNewCustomerPartner) {
              customerModelTemp.partnerList.add(CustomerModel(
                name: TextEditingController(),
                remark: TextEditingController(),
                informationList: [],
                moneyList: [],
                totalList: [],
                partnerList: [],
                invoiceCount: 0,
              ));
            }
            CustomerModel partnerModelTempSub = cloneCustomer(customerIndex: partnerIndex, customerModelList: customerModelTemp.partnerList);
            void cancelFunctionOnTap() {
              if (isAdminEditing) {
                void okFunction() {
                  if (isCreateNewCustomerPartner) {
                    customerModelTemp.partnerList.removeLast();
                    setStateFromDialog(() {});
                  }
                  closeDialogGlobal(context: context);
                }

                void cancelFunction() {}
                confirmationDialogGlobal(
                  context: context,
                  okFunction: okFunction,
                  cancelFunction: cancelFunction,
                  titleStr: cancelEditingSettingGlobal,
                  subtitleStr: cancelEditingSettingConfirmGlobal,
                );
              } else {
                closeDialogGlobal(context: context);
              }
            }

            void saveFunctionOnTap() {
              customerModelTemp.partnerList[partnerIndex] = partnerModelTempSub;
              setStateFromDialog(() {});
              closeDialogGlobal(context: context);
            }

            editCustomerDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
              return informationWidget(
                titleStr: customerPartnerInformationStrGlobal,
                customerModelTemp: partnerModelTempSub,
                isAdminEditing: isAdminEditing,
                setStateFromDialog: setStateFromDialog,
              );
            }

            ValidButtonModel validDeleteFunctionOnTap() {
              return ValidButtonModel(isValid: true);
            }

            void deleteFunctionOrNull() {
              void deleteFunctionOnTap() {
                customerModelTemp.partnerList.removeAt(partnerIndex);
                setStateFromDialog(() {});
                closeDialogGlobal(context: context);
              }

              void cancelFunction() {}
              confirmationDialogGlobal(
                context: context,
                okFunction: deleteFunctionOnTap,
                cancelFunction: cancelFunction,
                titleStr: "$deleteGlobal ${partnerModelTempSub.name.text}",
                subtitleStr: deleteConfirmGlobal,
              );
            }

            actionDialogSetStateGlobal(
              dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.05,
              dialogWidth: dialogSizeGlobal(level: Level.mini),
              cancelFunctionOnTap: cancelFunctionOnTap,
              context: context,
              validSaveButtonFunction: () => validSaveButtonFunction(
                isCreateNewCustomer: isCreateNewCustomer,
                customerIndex: partnerIndex,
                isAdminEditing: isAdminEditing,
                customerModelTemp: partnerModelTempSub,
                moneyCustomerModel: moneyCustomerModel,
                isLend: isLend,
                customerModelListMain: (customerIndex == null) ? [] : customerModelListGlobal[customerIndex].partnerList,
              ),
              saveFunctionOnTap: (partnerModelTempSub.deletedDate == null && isAdminEditing) ? saveFunctionOnTap : null,
              contentFunctionReturnWidget: editCustomerDialog,
              validDeleteFunctionOnTap: () => validDeleteFunctionOnTap(),
              deleteFunctionOnTap: (isCreateNewCustomerPartner || !isAdminEditing) ? null : deleteFunctionOrNull,
            );
          }

          return customerInformationEditSub;
        }

        Widget paddingAddRateButtonWidget() {
          Widget addRateButtonWidget() {
            return addButtonOrContainerWidget(
              context: context,
              level: Level.mini,
              validModel: ValidButtonModel(isValid: isAdminEditing, error: "employee does not have permission to edit"),
              onTapFunction: customerInformationEdit(
                context: context,
                customerModelTemp: customerModelTemp,
                isAdminEditing: isAdminEditing,
                partnerIndex: customerModelTemp.partnerList.length,
              ),
              currentAddButtonQty: customerModelTemp.partnerList.length,
              maxAddButtonLimit: customerPartnerAddButtonLimitGlobal,
            );
          }

          return Padding(padding: EdgeInsets.symmetric(horizontal: paddingSizeGlobal(level: Level.normal)), child: addRateButtonWidget());
        }

        Widget partnerWidget({required int partnerIndex}) {
          void onTapUnlessDisable() {
            customerInformationEdit(
              context: context,
              customerModelTemp: customerModelTemp,
              isAdminEditing: isAdminEditing,
              partnerIndex: partnerIndex,
            )();
          }

          Widget insideSizeBoxWidget() {
            Widget informationElementWidget({required int informationIndex}) {
              final String titleStr = customerModelTemp.partnerList[partnerIndex].informationList[informationIndex].title.text;
              final String subtitleStr = customerModelTemp.partnerList[partnerIndex].informationList[informationIndex].subtitle.text;
              return Text("$titleStr: $subtitleStr", style: textStyleGlobal(level: Level.mini));
            }

            return Padding(
              padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(customerModelTemp.partnerList[partnerIndex].name.text, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                for (int informationIndex = 0; informationIndex < customerModelTemp.partnerList[partnerIndex].informationList.length; informationIndex++)
                  informationElementWidget(informationIndex: informationIndex),
              ]),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.mini), horizontal: paddingSizeGlobal(level: Level.normal)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Expanded(child: CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable))],
            ),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  informationWidget(
                    titleStr: customerInformationStrGlobal,
                    customerModelTemp: customerModelTemp,
                    isAdminEditing: isAdminEditing,
                    setStateFromDialog: setStateFromDialog,
                  ),
                  for (int partnerIndex = 0; partnerIndex < customerModelTemp.partnerList.length; partnerIndex++) partnerWidget(partnerIndex: partnerIndex),
                  paddingAddRateButtonWidget()
                ]),
              ),
            ),
            Expanded(child: paddingLeftWidget(widget: borrowOrLendingWidget())),
          ],
        );
      }

      return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: createCustomerWidget());
    }

    return paddingBottomCreateCustomerWidget();
    // return isInitCustomerDetail ? loadingWidgetGlobal(loadingTitle: findingCustomerDetailStrGlobal) : paddingBottomCreateCustomerWidget();
  }

  actionDialogSetStateGlobal(
    dialogHeight: dialogSizeGlobal(level: Level.mini),
    dialogWidth: dialogSizeGlobal(level: Level.large),
    cancelFunctionOnTap: cancelFunctionOnTap,
    context: context,
    validSaveButtonFunction: () => validSaveButtonFunction(
      isCreateNewCustomer: isCreateNewCustomer,
      customerIndex: customerIndex,
      isAdminEditing: isAdminEditing,
      customerModelTemp: customerModelTemp,
      moneyCustomerModel: moneyCustomerModel,
      isLend: isLend,
      customerModelListMain: customerModelListGlobal,
    ),
    saveFunctionOnTap: (customerModelTemp.deletedDate == null) ? saveFunctionOnTap : null,
    contentFunctionReturnWidget: editCustomerDialog,
    validDeleteFunctionOnTap: () => validDeleteFunctionOnTap(),
    deleteFunctionOnTap: deleteFunctionOrNull(),
    saveAndPrintFunctionOnTap: saveAndPrintProviderFunction(),
    validSaveAndPrintButtonFunction: () => validSaveButtonFunction(
      isCreateNewCustomer: isCreateNewCustomer,
      customerIndex: customerIndex,
      isAdminEditing: isAdminEditing,
      customerModelTemp: customerModelTemp,
      moneyCustomerModel: moneyCustomerModel,
      isLend: isLend,
      customerModelListMain: customerModelListGlobal,
    ),
    restoreFunctionOnTap: restoreFunctionOrNull(),
  );
}
