// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:business_receipt/env/function/active_log.dart';
import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/customer.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/drop_down_and_text_field_provider.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/request_api/transfer_request_api_env.dart';
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
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/employee_model/transfer_order_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class TransferEmployeeSideMenu extends StatefulWidget {
  String title;
  Function callback;
  TransferEmployeeSideMenu({Key? key, required this.title, required this.callback}) : super(key: key);

  @override
  State<TransferEmployeeSideMenu> createState() => _TransferEmployeeSideMenuState();
}

class _TransferEmployeeSideMenuState extends State<TransferEmployeeSideMenu> {
  bool isTransfer = true;
  bool iSeparateFee = true;
  bool isUseBank = true;
  bool isOtherBank = true;
  List<ActiveLogModel> activeLogModelTransferList = [];
  String? customerIdSelected;
  int selectedMoneyAndDateIndex = -1;
  final DateTime currentDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
    0,
  );
  TransferOrder transferOrderTemp = TransferOrder(
    activeLogModelList: [],
    sender: PartnerAndSenderAndReceiver(informationList: [], name: TextEditingController()),
    partner: PartnerAndSenderAndReceiver(informationList: [], name: TextEditingController()),
    moneyList: [],
    remark: TextEditingController(),
    receiver: PartnerAndSenderAndReceiver(informationList: [], name: TextEditingController()),
    isOtherBank: true,
    isTransfer: true,
    isUseBank: true,
    mergeMoneyList: [],
  );
  void initTransferModel() {
    transferOrderTemp = TransferOrder(
      activeLogModelList: [],
      sender: (isTransfer && isOtherBank)
          ? PartnerAndSenderAndReceiver(
              informationList: [
                InformationCustomerModel(
                  title: TextEditingController(text: customerCategoryListGlobal.first.title.text),
                  subtitle: TextEditingController(),
                ),
              ],
              name: TextEditingController(),
            )
          : null,
      partner: PartnerAndSenderAndReceiver(
        informationList: [
          InformationCustomerModel(
            title: TextEditingController(text: customerCategoryListGlobal.first.title.text),
            subtitle: TextEditingController(),
          ),
        ],
        name: TextEditingController(),
      ),
      moneyList: [],
      remark: TextEditingController(),
      receiver: PartnerAndSenderAndReceiver(
        informationList: [
          InformationCustomerModel(
            title: TextEditingController(text: customerCategoryListGlobal.first.title.text),
            subtitle: TextEditingController(),
          ),
        ],
        name: TextEditingController(),
      ),
      isTransfer: isTransfer,
      isUseBank: isUseBank,
      isOtherBank: isOtherBank,
      mergeMoneyList: [],
    );
  }

  @override
  void initState() {
    initTransferModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      void historyOnTapFunction() {
        limitHistory();
        addActiveLogElement(
          activeLogModelList: activeLogModelTransferList,
          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "history button"),
          ]),
        );
        void cancelFunctionOnTap() {
          closeDialogGlobal(context: context);
          // setState(() {});
        }

        Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          void setStateOutsider() {
            setStateFromDialog(() {});
          }

          Widget titleTextWidget() {
            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text(transferHistoryStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))],
              ),
            );
          }

          Widget transferHistoryListWidget() {
            List<Widget> inWrapWidgetList() {
              return [
                for (int transferIndex = 0; transferIndex < transferModelListEmployeeGlobal.length; transferIndex++)
                  HistoryElement(
                    isForceShowNoEffect: false,
                    isAdminEditing: false,
                    index: transferIndex,
                    transferMoneyModel: transferModelListEmployeeGlobal[transferIndex],
                    setStateOutsider: setStateOutsider,
                  )
              ];
            }

            void topFunction() {}
            void bottomFunction() {
              if (!outOfDataQueryTransferListGlobal) {
                final int beforeQuery = transferModelListEmployeeGlobal.length;
                void callBack() {
                  final int afterQuery = transferModelListEmployeeGlobal.length;

                  if (beforeQuery == afterQuery) {
                    outOfDataQueryTransferListGlobal = true;
                  } else {
                    skipTransferListGlobal = skipTransferListGlobal + queryLimitNumberGlobal;
                  }
                  setStateFromDialog(() {});
                }

                getTransferListEmployeeGlobal(
                  employeeId: profileModelEmployeeGlobal!.id!,
                  callBack: callBack,
                  context: context,
                  skip: skipTransferListGlobal,
                  targetDate: DateTime.now(),
                  transferModelListEmployee: transferModelListEmployeeGlobal,
                );
              }
            }

            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: !outOfDataQueryTransferListGlobal,
            );
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleTextWidget(), Expanded(child: transferHistoryListWidget())]);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini),
          dialogWidth: dialogSizeGlobal(level: Level.mini),
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      }

      void clearFunction() {
        isTransfer = true;
        isUseBank = true;
        isOtherBank = true;
        iSeparateFee = true;
        customerIdSelected = null;
        selectedMoneyAndDateIndex = -1;
        initTransferModel();
        addActiveLogElement(
          activeLogModelList: activeLogModelTransferList,
          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.red, title: "button name", subtitle: "clear button"),
          ]),
        );
        setState(() {});
      }

      ValidButtonModel isValidAddOnTap({required List<MoneyListTransfer> moneyListTransfer}) {
        if (transferOrderTemp.partner.name.text.isEmpty) {
          // return false;
          return ValidButtonModel(isValid: false, error: "please select partner.");
        }
        for (int moneyIndex = 0; moneyIndex < moneyListTransfer.length; moneyIndex++) {
          if (moneyListTransfer[moneyIndex].moneyType == null) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              error: "please select money type.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "money index", subtitle: moneyIndex.toString()),
                TitleAndSubtitleModel(title: "money type", subtitle: ""),
              ],
            );
          }
          if (moneyListTransfer[moneyIndex].value.text.isEmpty) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              error: "amount is empty.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "money index", subtitle: moneyIndex.toString()),
                TitleAndSubtitleModel(title: "amount", subtitle: moneyListTransfer[moneyIndex].value.text),
              ],
            );
          }
          final double valueNumber = textEditingControllerToDouble(controller: moneyListTransfer[moneyIndex].value)!;
          if (valueNumber == 0) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              error: "amount equal 0.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "money index", subtitle: moneyIndex.toString()),
                TitleAndSubtitleModel(title: "amount", subtitle: moneyListTransfer[moneyIndex].value.text),
              ],
            );
          }
          if (moneyListTransfer[moneyIndex].discountFee.text.isEmpty) {
            // return false;
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfNumber,
              error: "discount fee is empty.",
              errorLocationList: [
                TitleAndSubtitleModel(title: "money index", subtitle: moneyIndex.toString()),
                TitleAndSubtitleModel(title: "discount fee", subtitle: moneyListTransfer[moneyIndex].discountFee.text),
              ],
            );
          }
          // final double discountFeeNumber = textEditingControllerToDouble(controller: moneyListTransfer[moneyIndex].discountFee)!;
          // if (discountFeeNumber == 0) {
          //   print("discountFeeNumber == 0");
          //   return false;
          // }
          final ValidButtonModel checkLimitAmountAndFeeTransferModel = checkLimitAmountAndFeeTransfer(
            moneyType: moneyListTransfer[moneyIndex].moneyType!,
            amount: textEditingControllerToDouble(controller: moneyListTransfer[moneyIndex].value)!,
            fee: textEditingControllerToDouble(controller: moneyListTransfer[moneyIndex].discountFee)!,
            partnerId: transferOrderTemp.partner.nameAndInformationId,
            name: transferOrderTemp.partner.name.text,
          );
          if (!checkLimitAmountAndFeeTransferModel.isValid) {
            return checkLimitAmountAndFeeTransferModel;
          }
        }
        // return true;
        return ValidButtonModel(isValid: true);
      }

      ValidButtonModel isValidSave() {
        if (!iSeparateFee) {
          final ValidButtonModel isValidAddOnTapModel = isValidAddOnTap(moneyListTransfer: transferOrderTemp.mergeMoneyList);
          if (!isValidAddOnTapModel.isValid) {
            // return false;
            return isValidAddOnTapModel;
          }
        }
        final ValidButtonModel isValidAddOnTapModel = isValidAddOnTap(moneyListTransfer: transferOrderTemp.moneyList);
        if (!isValidAddOnTapModel.isValid) {
          // return false;
          return isValidAddOnTapModel;
        }
        if (transferOrderTemp.moneyList.isEmpty) {
          return ValidButtonModel(isValid: false, error: "please add money.");
        }
        if (transferOrderTemp.partner.name.text.isEmpty) {
          // return false;
          return ValidButtonModel(isValid: false, error: "please select partner.");
        }
        if (isTransfer && isOtherBank) {
          if (transferOrderTemp.sender!.informationList.isNotEmpty) {
            if (transferOrderTemp.sender!.informationList.first.subtitle.text.isEmpty) {
              // return false;
              return ValidButtonModel(isValid: false, error: "please select sender.");
            }
          } else {
            if (transferOrderTemp.sender!.nameAndInformationId == null) {
              // return false;
              return ValidButtonModel(isValid: false, error: "please select sender.");
            }
          }
        }
        if (transferOrderTemp.receiver.informationList.isNotEmpty) {
          if (transferOrderTemp.receiver.informationList.first.subtitle.text.isEmpty) {
            // return false;
            return ValidButtonModel(isValid: false, error: "please select receiver.");
          }
        } else {
          if (transferOrderTemp.receiver.nameAndInformationId == null) {
            // return false;
            return ValidButtonModel(isValid: false, error: "please select receiver.");
          }
        }
        if (!isTransfer && transferOrderTemp.partner.nameAndInformationId != null) {
          for (int moneyIndex = 0; moneyIndex < transferOrderTemp.mergeMoneyList.length; moneyIndex++) {
            final String moneyType = transferOrderTemp.mergeMoneyList[moneyIndex].moneyType!;
            final double valueNumber = textEditingControllerToDouble(controller: transferOrderTemp.mergeMoneyList[moneyIndex].value)!;
            final double discountFeeNumber =
                transferOrderTemp.mergeMoneyList[moneyIndex].discountFee.text.isEmpty ? 0 : textEditingControllerToDouble(controller: transferOrderTemp.mergeMoneyList[moneyIndex].discountFee)!;
            final double amountTotalNumber = valueNumber + discountFeeNumber;
            final ValidButtonModel lowerMoneyStockModel = checkLowerTheExistMoney(moneyNumber: amountTotalNumber, moneyType: moneyType);
            if (!lowerMoneyStockModel.isValid) {
              // return false;
              return lowerMoneyStockModel;
            }
          }
        }
        // return true;
        return ValidButtonModel(isValid: true);
      }

      List<Widget> inWrapWidgetList() {
        Widget partnerAndSenderAndReceiverWidget() {
          Widget customButtonWidget() {
            Widget toggleWidget() {
              Widget transferOrReceiveToggleWidget() {
                void onToggle() {
                  isTransfer = !isTransfer;
                  isOtherBank = true;
                  initTransferModel();
                  addActiveLogElement(
                    activeLogModelList: activeLogModelTransferList,
                    activeLogModel: ActiveLogModel(idTemp: "transfer or receive", activeType: ActiveLogTypeEnum.selectToggle, locationList: [
                      Location(
                        color: isTransfer ? ColorEnum.green : ColorEnum.red,
                        title: "toggle button name",
                        subtitle: isTransfer ? "Receive to Transfer" : "Transfer to Receive",
                      ),
                    ]),
                  );
                  setState(() {});
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal), right: paddingSizeGlobal(level: Level.normal)),
                  child: transferOrReceiveToggleWidgetGlobal(isLeftSelected: isTransfer, onToggle: onToggle),
                );
              }

              Widget bankOrCashToggleWidget() {
                void onToggle() {
                  isUseBank = !isUseBank;
                  // if (isUseBank) {
                  isOtherBank = true;
                  // }
                  initTransferModel();
                  addActiveLogElement(
                    activeLogModelList: activeLogModelTransferList,
                    activeLogModel: ActiveLogModel(idTemp: "bank or cash", activeType: ActiveLogTypeEnum.selectToggle, locationList: [
                      Location(
                        color: ColorEnum.blue,
                        title: "toggle button name",
                        subtitle: isUseBank ? "Cash to Bank" : "Bank to Cash",
                      ),
                    ]),
                  );
                  setState(() {});
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal), right: paddingSizeGlobal(level: Level.normal)),
                  child: bankOrCashToggleWidgetGlobal(isLeftSelected: isUseBank, onToggle: onToggle),
                );
              }

              Widget ownOrOtherBankToggleWidget() {
                void onToggle() {
                  isOtherBank = !isOtherBank;
                  addActiveLogElement(
                    activeLogModelList: activeLogModelTransferList,
                    activeLogModel: ActiveLogModel(idTemp: "other bank or own bank", activeType: ActiveLogTypeEnum.selectToggle, locationList: [
                      Location(
                        color: ColorEnum.blue,
                        title: "toggle button name",
                        subtitle: isOtherBank ? "Own Bank to Other Bank " : "Other Bank to Own Bank",
                      ),
                    ]),
                  );
                  setState(() {});
                }

                return isUseBank
                    ? Padding(
                        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal), right: paddingSizeGlobal(level: Level.normal)),
                        child: isTransfer
                            ? ownOrOtherBankToggleWidgetGlobal(isLeftSelected: isOtherBank, onToggle: onToggle)
                            : singleToggleGlobal(singleOptionStr: otherBankStrGlobal, color: toggleSeparateAndMergeColorGlobal),
                      )
                    : Container();
              }

              return Row(children: [transferOrReceiveToggleWidget(), bankOrCashToggleWidget(), ownOrOtherBankToggleWidget()]);
            }

            Widget nameAndInformationWidget({
              required bool isHasSend,
              required bool isHasReceive,
              required bool isPartner,
              required PartnerAndSenderAndReceiver partnerAndSenderAndReceiver,
              required String title,
            }) {
              final String partnerOrCustomerStr = isPartner
                  ? "partner"
                  : ((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank))
                      ? "sender"
                      : "receiver";
              String? getIdString({required int index}) {
                return isPartner
                    ? (index == 0)
                        ? null
                        : customerModelListGlobal[getIndexByCustomerId(customerId: transferModelListGlobal[index].customerId!)].id!
                    : ((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank))
                        ? customerModelWithoutTransferListGlobal[index].id!
                        : customerModelWithoutTransferListGlobal[getIndexByCustomerModelWithoutTransferListGlobalId(customerId: customerIdSelected!)].partnerList[index].id;
              }

              String getNameString({required int index}) {
                return isPartner
                    ? (index == 0)
                        ? profileModelAdminGlobal!.name.text
                        : customerModelListGlobal[getIndexByCustomerId(customerId: transferModelListGlobal[index].customerId!)].name.text
                    : ((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank))
                        ? customerModelWithoutTransferListGlobal[index].name.text
                        : customerModelWithoutTransferListGlobal[getIndexByCustomerModelWithoutTransferListGlobalId(customerId: customerIdSelected!)].partnerList[index].name.text;
              }

              int? getCustomerCount({required int index}) {
                return isPartner
                    ? null
                    : ((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank))
                        ? customerModelWithoutTransferListGlobal[index].invoiceCount
                        : null;
              }

              CustomerModel? getCustomerModel({required String phoneNumberStr}) {
                final bool isSender = (((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank)) && !isPartner);
                if (isSender) {
                  int customerMatchIndex = -1;
                  for (int customerIndex = 0; customerIndex < customerModelWithoutTransferListGlobal.length; customerIndex++) {
                    for (int infoIndex = 0; infoIndex < customerModelWithoutTransferListGlobal[customerIndex].informationList.length; infoIndex++) {
                      if (customerModelWithoutTransferListGlobal[customerIndex].informationList[infoIndex].title.text == customerCategoryListGlobal.first.title.text &&
                          customerModelWithoutTransferListGlobal[customerIndex].informationList[infoIndex].subtitle.text == phoneNumberStr) {
                        customerMatchIndex = customerIndex;
                        break;
                      }
                    }
                  }
                  if (customerMatchIndex != -1) {
                    return customerModelWithoutTransferListGlobal[customerMatchIndex];
                  }
                }
                return null;
              }

              void setSenderId({required int indexSelected}) {
                if (((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank)) && !isPartner) {
                  customerIdSelected = (indexSelected == -1) ? null : customerModelWithoutTransferListGlobal[indexSelected].id;
                }
              }

              List<InformationCustomerModel> getInformationList({required int index}) {
                return isPartner
                    ? (index == 0)
                        ? [
                            InformationCustomerModel(
                              title: TextEditingController(text: "please note"),
                              subtitle: TextEditingController(text: "no money increase or decrease"),
                              isSelectedSubtitle: false,
                              isSelectedTitle: false,
                            )
                          ]
                        : customerModelListGlobal[getIndexByCustomerId(customerId: transferModelListGlobal[index].customerId!)].informationList
                    : ((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank))
                        ? customerModelWithoutTransferListGlobal[index].informationList
                        : customerModelWithoutTransferListGlobal[getIndexByCustomerModelWithoutTransferListGlobalId(customerId: customerIdSelected!)].partnerList[index].informationList;
              }

              int getCustomerLength() {
                return isPartner
                    ? transferModelListGlobal.length
                    : ((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank))
                        ? customerModelWithoutTransferListGlobal.length
                        : customerModelWithoutTransferListGlobal[getIndexByCustomerModelWithoutTransferListGlobalId(customerId: customerIdSelected!)].partnerList.length;
              }

              Widget insideSizeBoxWidget() {
                Widget titleTextWidget() {
                  String customerCountStr = "";
                  if (partnerAndSenderAndReceiver.invoiceCount != null) {
                    customerCountStr = "(${formatAndLimitNumberTextGlobal(valueStr: partnerAndSenderAndReceiver.invoiceCount.toString(), isRound: false)})";
                  }
                  return Padding(
                    padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal), bottom: paddingSizeGlobal(level: Level.normal)),
                    child: Text("$title: ${partnerAndSenderAndReceiver.name.text} $customerCountStr", style: textStyleGlobal(level: Level.normal)),
                  );
                }

                Widget informationTextFieldWidget() {
                  Widget companyNameTextFieldWidget() {
                    void onChangeFromOutsiderFunction() {
                      if (partnerAndSenderAndReceiver.informationList.first.subtitle.text.isNotEmpty) {
                        final CustomerModel? customerModel = getCustomerModel(phoneNumberStr: partnerAndSenderAndReceiver.informationList.first.subtitle.text);

                        if (customerModel != null) {
                          partnerAndSenderAndReceiver.invoiceCount = customerModel.invoiceCount;
                          partnerAndSenderAndReceiver.informationList = customerModel.informationList;
                          partnerAndSenderAndReceiver.name = customerModel.name;
                          partnerAndSenderAndReceiver.nameAndInformationId = customerModel.id;
                        }
                      }
                      setState(() {});
                    }

                    void onTapFromOutsiderFunction() {}
                    return (isPartner || partnerAndSenderAndReceiver.name.text.isNotEmpty)
                        ? (partnerAndSenderAndReceiver.nameAndInformationId == null && partnerAndSenderAndReceiver.name.text.isNotEmpty && !isHasReceive)
                            ? Text(
                                "please note: no money increase or decrease",
                                style: textStyleGlobal(level: Level.mini, color: acceptSuggestButtonColorGlobal),
                              )
                            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                for (int informationIndex = 0; informationIndex < partnerAndSenderAndReceiver.informationList.length; informationIndex++)
                                  partnerAndSenderAndReceiver.informationList[informationIndex].subtitle.text.isEmpty
                                      ? Container()
                                      : Text(
                                          "${partnerAndSenderAndReceiver.informationList[informationIndex].title.text}: ${partnerAndSenderAndReceiver.informationList[informationIndex].subtitle.text}",
                                          style: textStyleGlobal(level: Level.normal),
                                        ),
                              ])
                        : textFieldGlobal(
                            controller: partnerAndSenderAndReceiver.informationList.first.subtitle,
                            onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                            labelText: customerCategoryListGlobal.first.title.text,
                            level: Level.normal,
                            textFieldDataType: TextFieldDataType.str,
                            onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                          );
                  }

                  return SizedBox(width: nameTextFieldWidthGlobal, child: companyNameTextFieldWidget());
                }

                return Padding(
                  padding: EdgeInsets.all(paddingSizeGlobal(level: Level.normal)),
                  child: Row(children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleTextWidget(), informationTextFieldWidget()])
                  ]),
                );
              }

              void onTapFunction() {
                // int selectedPartnerIndex = -1;

                void cancelFunctionOnTap() {
                  void okFunction() {
                    addActiveLogElement(
                      activeLogModelList: activeLogModelTransferList,
                      activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
                        Location(title: "$partnerOrCustomerStr name", subtitle: partnerAndSenderAndReceiver.name.text),
                        Location(title: "button name", subtitle: "cancel button"),
                      ]),
                    );
                    closeDialogGlobal(context: context);
                  }

                  void cancelFunction() {}
                  confirmationDialogGlobal(
                      context: context, okFunction: okFunction, cancelFunction: cancelFunction, titleStr: cancelEditingSettingGlobal, subtitleStr: cancelEditingSettingConfirmGlobal);
                }

                late Function setStateFromDialogSub;
                int customerLengthIncrease = queryLimitNumberGlobal;
                bool isShowSeeMoreWidget = true;
                if (customerLengthIncrease > getCustomerLength()) {
                  isShowSeeMoreWidget = false;
                  customerLengthIncrease = getCustomerLength();
                }
                Widget editCustomerDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                  setStateFromDialogSub = setStateFromDialog;
                  Widget paddingBottomCreateCustomerWidget() {
                    Widget createCustomerWidget() {
                      Widget informationWidget() {
                        Widget titleTextFieldWidget() {
                          return Text("$title $informationStrGlobal", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold));
                        }

                        Widget partnerOrCustomerWidget({required int index}) {
                          Widget insideSizeBoxWidget() {
                            Widget nameWidget() {
                              // final String partnerName = isPartner
                              //     ? customerModelListGlobal[getIndexByCustomerId(customerId: transferModelListGlobal[index].customerId!)].name.text
                              //     : ((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank))
                              //         ? customerModelListGlobal[index].name.text
                              //         : customerModelListGlobal[getIndexByCustomerId(customerId: customerIdSelected!)].partnerList[index].name.text;
                              final int? customerCount = getCustomerCount(index: index);
                              String customerCountStr = "";
                              if (customerCount != null) {
                                customerCountStr = "(${formatAndLimitNumberTextGlobal(valueStr: customerCount.toString(), isRound: false)})";
                              }
                              return Text(
                                (index == 0 && isPartner) ? profileModelAdminGlobal!.name.text : "${getNameString(index: index)} $customerCountStr",
                                style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                              );
                            }

                            Widget detailWidget() {
                              final List<InformationCustomerModel> informationList = getInformationList(index: index);
                              // isPartner
                              //     ? customerModelListGlobal[getIndexByCustomerId(customerId: transferModelListGlobal[index].customerId!)].informationList
                              //     : ((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank))
                              //         ? customerModelListGlobal[index].informationList
                              //         : customerModelListGlobal[getIndexByCustomerId(customerId: customerIdSelected!)].partnerList[index].informationList;
                              if (informationList.isEmpty) {
                                return Container();
                              }
                              final String firstInformationTitle = informationList.first.title.text;
                              final String firstInformationSubtitle = informationList.first.subtitle.text;
                              return scrollText(
                                textStr: "$firstInformationTitle: $firstInformationSubtitle",
                                textStyle: textStyleGlobal(
                                  level: Level.mini,
                                  color: (index == 0 && isPartner) ? acceptSuggestButtonColorGlobal : defaultTextColorGlobal,
                                ),
                                alignment: Alignment.centerLeft,
                              );
                            }

                            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [nameWidget(), detailWidget()]);
                          }

                          final String nameTemp = partnerAndSenderAndReceiver.name.text.isEmpty ? profileModelAdminGlobal!.name.text : partnerAndSenderAndReceiver.name.text;
                          void onTapUnlessDisable() {
                            if (partnerAndSenderAndReceiver.selectedIndex != index) {
                              partnerAndSenderAndReceiver.selectedIndex = index;
                              for (int partnerAndSenderAndReceiverIndex = 0;
                                  partnerAndSenderAndReceiverIndex < getCustomerLength();
                                  // (isPartner
                                  //     ? transferModelListGlobal.length
                                  //     : ((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank))
                                  //         ? customerModelListGlobal.length
                                  //         : customerModelListGlobal[getIndexByCustomerId(customerId: customerIdSelected!)].partnerList.length);
                                  partnerAndSenderAndReceiverIndex++) {
                                final List<InformationCustomerModel> informationList = getInformationList(index: partnerAndSenderAndReceiverIndex);
                                // isPartner
                                //     ? customerModelListGlobal[getIndexByCustomerId(customerId: transferModelListGlobal[partnerAndSenderAndReceiverIndex].customerId!)]
                                //         .informationList
                                //     : ((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank))
                                //         ? customerModelListGlobal[partnerAndSenderAndReceiverIndex].informationList
                                //         : customerModelListGlobal[getIndexByCustomerId(customerId: customerIdSelected!)]
                                //             .partnerList[partnerAndSenderAndReceiverIndex]
                                //             .informationList;
                                for (int informationIndex = 0; informationIndex < informationList.length; informationIndex++) {
                                  informationList[informationIndex].isSelectedTitle = false;
                                }
                                if (informationList.isNotEmpty) {
                                  informationList.first.isSelectedTitle = true;
                                }
                              }
                              final String nameChangeTemp = partnerAndSenderAndReceiver.name.text.isEmpty ? profileModelAdminGlobal!.name.text : partnerAndSenderAndReceiver.name.text;
                              addActiveLogElement(
                                activeLogModelList: activeLogModelTransferList,
                                activeLogModel: ActiveLogModel(idTemp: "$partnerOrCustomerStr selection", activeType: ActiveLogTypeEnum.clickButton, locationList: [
                                  Location(title: "$partnerOrCustomerStr selection", subtitle: "$nameTemp to $nameChangeTemp"),
                                ]),
                              );

                              setStateFromDialog(() {});
                            }
                          }

                          return Row(children: [
                            Expanded(
                              child: CustomButtonGlobal(
                                isDisable: (partnerAndSenderAndReceiver.selectedIndex == index),
                                insideSizeBoxWidget: insideSizeBoxWidget(),
                                onTapUnlessDisable: onTapUnlessDisable,
                              ),
                            )
                          ]);
                        }

                        void topFunction() {}
                        void bottomFunction() {
                          customerLengthIncrease = customerLengthIncrease + queryLimitNumberGlobal;
                          if (customerLengthIncrease > getCustomerLength()) {
                            isShowSeeMoreWidget = false;
                            customerLengthIncrease = getCustomerLength();
                          }
                        }

                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          titleTextFieldWidget(),
                          Expanded(
                            child: wrapScrollDetectWidget(
                              inWrapWidgetList: [for (int index = 0; index < customerLengthIncrease; index++) partnerOrCustomerWidget(index: index)],
                              topFunction: topFunction,
                              bottomFunction: bottomFunction,
                              isShowSeeMoreWidget: isShowSeeMoreWidget,
                            ),
                            // child: SingleChildScrollView(
                            //   child: Padding(
                            //     padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                            //     child: Column(children: [for (int index = 0; index < getCustomerLength(); index++) partnerOrCustomerWidget(index: index)]),
                            //   ),
                            // ),
                          ),
                        ]);
                      }

                      Widget informationDetailWidget() {
                        Widget paddingBottomWidget({required Widget widget}) {
                          return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: widget);
                        }

                        Widget titleTextFieldWidget() {
                          return Text(informationDetailStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold));
                        }

                        Widget toggleWidget({required String titleStr, required Function callback, required bool isShow, required bool isEnable}) {
                          Widget insideSizeBoxWidget() {
                            Widget text() {
                              return Text(titleStr, style: textStyleGlobal(level: Level.normal));
                            }

                            Widget toggle() {
                              void doNothing() {
                                setStateFromDialog(() {});
                              }

                              return showAndHideToggleWidgetGlobal(isLeftSelected: isShow, onToggle: isEnable ? callback : doNothing);
                            }

                            return Row(children: [Expanded(child: text()), toggle()]);
                          }

                          return CustomButtonGlobal(
                            sizeBoxWidth: sizeBoxDetailInformationWidthGlobal,
                            insideSizeBoxWidget: insideSizeBoxWidget(),
                            onTapUnlessDisable: () {},
                          );
                        }

                        // final String firstInformationTitle = informationList.first.title.text;
                        // final String firstInformationSubtitle = informationList.first.subtitle.text;
                        // return scrollText(
                        //   textStr: "$firstInformationTitle: $firstInformationSubtitle",
                        //   textStyle: textStyleGlobal(level: Level.mini),
                        //   alignment: Alignment.centerLeft,
                        // );
                        List<Widget> inWrapWidgetList() {
                          Widget toggleElementWidget({required InformationCustomerModel information}) {
                            // print("information.title.text: ${information.title.text}");
                            return toggleWidget(
                              titleStr: "${information.title.text}: ${information.subtitle.text}",
                              isShow: information.isSelectedTitle,
                              isEnable: true,
                              callback: () {
                                information.isSelectedTitle = !information.isSelectedTitle;

                                addActiveLogElement(
                                  activeLogModelList: activeLogModelTransferList,
                                  activeLogModel: ActiveLogModel(
                                    idTemp: "$partnerOrCustomerStr name, toggle button",
                                    activeType: ActiveLogTypeEnum.selectToggle,
                                    locationList: [
                                      Location(title: "$partnerOrCustomerStr name", subtitle: partnerAndSenderAndReceiver.name.text),
                                      Location(title: information.title.text, subtitle: information.subtitle.text),
                                      Location(title: information.title.text, subtitle: information.subtitle.text),
                                      Location(
                                        color: information.isSelectedTitle ? ColorEnum.green : ColorEnum.red,
                                        title: "toggle button name",
                                        subtitle: information.isSelectedTitle ? "hide to show" : "show to hide",
                                      ),
                                    ],
                                  ),
                                );

                                setStateFromDialog(() {});
                              },
                            );
                          }

                          // List<InformationCustomerModel> informationListMatch() {
                          //   return isPartner
                          //       ? customerModelListGlobal[getIndexByCustomerId(customerId: transferModelListGlobal[selectedPartnerIndex].customerId!)].informationList
                          //       : ((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank))
                          //           ? customerModelListGlobal[selectedPartnerIndex].informationList
                          //           : customerModelListGlobal[getIndexByCustomerId(customerId: customerIdSelected!)].partnerList[selectedPartnerIndex].informationList;
                          //   // return customerModelListGlobal[getIndexByCustomerId(customerId: transferModelListGlobal[selectedPartnerIndex].customerId!)].informationList;
                          // }

                          return (partnerAndSenderAndReceiver.selectedIndex == -1 || (partnerAndSenderAndReceiver.selectedIndex == 0 && isPartner))
                              ? []
                              : [
                                  for (int informationIndex = 0; informationIndex < getInformationList(index: partnerAndSenderAndReceiver.selectedIndex).length; informationIndex++)
                                    toggleElementWidget(information: getInformationList(index: partnerAndSenderAndReceiver.selectedIndex)[informationIndex]),
                                ];
                        }

                        void topFunction() {}
                        void bottomFunction() {}
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          paddingBottomWidget(widget: titleTextFieldWidget()),
                          Expanded(
                            child: wrapScrollDetectWidget(
                              inWrapWidgetList: inWrapWidgetList(),
                              topFunction: topFunction,
                              bottomFunction: bottomFunction,
                              isShowSeeMoreWidget: false,
                            ),
                          ),
                        ]);
                      }

                      Widget paddingLeftWidget({required Widget widget}) {
                        return Padding(padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)), child: widget);
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: flexTypeGlobal, child: informationWidget()),
                          Expanded(flex: flexValueGlobal, child: paddingLeftWidget(widget: informationDetailWidget())),
                        ],
                      );
                    }

                    return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: createCustomerWidget());
                  }

                  return paddingBottomCreateCustomerWidget();
                }

                void okFunctionOnTap() {
                  setSenderId(indexSelected: partnerAndSenderAndReceiver.selectedIndex);
                  final TextEditingController nameController = TextEditingController(
                    text: (partnerAndSenderAndReceiver.selectedIndex != -1)
                        ? getNameString(index: partnerAndSenderAndReceiver.selectedIndex)
                        : (partnerAndSenderAndReceiver.selectedIndex == 0 && isPartner)
                            ? profileModelAdminGlobal!.name.text
                            : "",
                  );
                  final int? invoiceCount = (partnerAndSenderAndReceiver.selectedIndex != -1) ? getCustomerCount(index: partnerAndSenderAndReceiver.selectedIndex) : null;
                  final String? id = (partnerAndSenderAndReceiver.selectedIndex != -1) ? getIdString(index: partnerAndSenderAndReceiver.selectedIndex) : null;
                  List<InformationCustomerModel> informationList = [];

                  if (partnerAndSenderAndReceiver.selectedIndex != -1) {
                    for (int informationIndex = 0; informationIndex < getInformationList(index: partnerAndSenderAndReceiver.selectedIndex).length; informationIndex++) {
                      InformationCustomerModel informationCustomerModel = getInformationList(index: partnerAndSenderAndReceiver.selectedIndex)[informationIndex];
                      if (informationCustomerModel.isSelectedTitle) {
                        informationList.add(InformationCustomerModel(
                          title: TextEditingController(text: informationCustomerModel.title.text),
                          subtitle: TextEditingController(text: informationCustomerModel.subtitle.text),
                        ));
                      }
                    }
                    if (isPartner) {
                      transferOrderTemp.moneyList = [];
                      transferOrderTemp.moneyList.add(MoneyListTransfer(
                        discountFee: TextEditingController(),
                        value: TextEditingController(),
                        transferDate: DateTime(currentDate.year, currentDate.month, currentDate.day, currentDate.hour, currentDate.minute, currentDate.second),
                      ));
                    } else if ((isHasSend && !isHasReceive) && !(isTransfer && isOtherBank)) {
                      transferOrderTemp.receiver = PartnerAndSenderAndReceiver(
                        informationList: [
                          InformationCustomerModel(
                            title: TextEditingController(text: customerCategoryListGlobal.first.title.text),
                            subtitle: TextEditingController(),
                          ),
                        ],
                        name: TextEditingController(),
                      );
                    }
                  } else {
                    if (isPartner) {
                      transferOrderTemp.moneyList = [];
                    }
                    informationList.add(
                      InformationCustomerModel(
                        title: TextEditingController(text: customerCategoryListGlobal.first.title.text),
                        subtitle: TextEditingController(),
                      ),
                    );
                  }
                  partnerAndSenderAndReceiver.invoiceCount = invoiceCount;
                  partnerAndSenderAndReceiver.informationList = informationList;
                  partnerAndSenderAndReceiver.name = nameController;
                  partnerAndSenderAndReceiver.nameAndInformationId = id;
                  selectedMoneyAndDateIndex = 0;
                  addActiveLogElement(
                    activeLogModelList: activeLogModelTransferList,
                    activeLogModel: ActiveLogModel(idTemp: "$partnerOrCustomerStr name, ok button", activeType: ActiveLogTypeEnum.clickButton, locationList: [
                      Location(title: "$partnerOrCustomerStr name", subtitle: partnerAndSenderAndReceiver.name.text),
                      Location(color: ColorEnum.blue, title: "button name", subtitle: "ok button"),
                    ]),
                  );
                  setState(() {});
                  closeDialogGlobal(context: context);
                }

                ValidButtonModel validOkButtonFunction() {
                  // return true;
                  return ValidButtonModel(isValid: true);
                  // return (selectedPartnerIndex != -1);
                }

                void clearFunctionOnTap() {
                  partnerAndSenderAndReceiver.selectedIndex = -1;
                  addActiveLogElement(
                    activeLogModelList: activeLogModelTransferList,
                    activeLogModel: ActiveLogModel(idTemp: "$partnerOrCustomerStr name, clear button", activeType: ActiveLogTypeEnum.clickButton, locationList: [
                      Location(title: "$partnerOrCustomerStr name", subtitle: partnerAndSenderAndReceiver.name.text),
                      Location(title: "button name", subtitle: "clear button"),
                    ]),
                  );
                  setStateFromDialogSub(() {});
                }

                actionDialogSetStateGlobal(
                  clearFunctionOnTap: clearFunctionOnTap,
                  dialogHeight: dialogSizeGlobal(level: Level.mini),
                  dialogWidth: dialogSizeGlobal(level: Level.normal),
                  cancelFunctionOnTap: cancelFunctionOnTap,
                  context: context,
                  okFunctionOnTap: okFunctionOnTap,
                  validOkButtonFunction: () => validOkButtonFunction(),
                  contentFunctionReturnWidget: editCustomerDialog,
                );
              }

              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: CustomButtonGlobal(
                  insideSizeBoxWidget: insideSizeBoxWidget(),
                  onTapUnlessDisable: onTapFunction,
                  isDisable: !((isHasSend && !isHasReceive) || !(isTransfer && isOtherBank) || (customerIdSelected != null) || isPartner),
                ),
              );
            }

            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              toggleWidget(),
              nameAndInformationWidget(partnerAndSenderAndReceiver: transferOrderTemp.partner, title: "Partner", isPartner: true, isHasSend: false, isHasReceive: false),
              (isTransfer && isOtherBank)
                  ? nameAndInformationWidget(
                      partnerAndSenderAndReceiver: transferOrderTemp.sender!,
                      title: "Sender",
                      isPartner: false,
                      isHasSend: true,
                      isHasReceive: false,
                    )
                  : Container(),
              nameAndInformationWidget(
                partnerAndSenderAndReceiver: transferOrderTemp.receiver,
                title: "Receiver",
                isPartner: false,
                isHasSend: (isTransfer && isOtherBank),
                isHasReceive: true,
              ),
            ]);
          }

          void onTapUnlessDisable() {}
          return CustomButtonGlobal(
            insideSizeBoxWidget: customButtonWidget(),
            onTapUnlessDisable: onTapUnlessDisable,
            sizeBoxWidth: dialogSizeGlobal(level: Level.mini),
          );
        }

        Widget remarkTextFieldWidget() {
          void onTapFromOutsiderFunction() {}
          final String remarkTemp = transferOrderTemp.remark.text;
          void onChangeFromOutsiderFunction() {
            final String remarkChangeTemp = transferOrderTemp.remark.text;
            addActiveLogElement(
              activeLogModelList: activeLogModelTransferList,
              activeLogModel: ActiveLogModel(idTemp: "remark textfield", activeType: ActiveLogTypeEnum.typeTextfield, locationList: [
                Location(
                  color: (remarkTemp.length < remarkChangeTemp.length) ? ColorEnum.green : ColorEnum.red,
                  title: "remark textfield",
                  subtitle: "${remarkTemp.isEmpty ? "" : "$remarkTemp to "}$remarkChangeTemp",
                ),
              ]),
            );

            setState(() {});
          }

          return Padding(
            padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini), bottom: paddingSizeGlobal(level: Level.normal)),
            child: CustomButtonGlobal(
              sizeBoxWidth: dialogSizeGlobal(level: Level.mini),
              insideSizeBoxWidget: Padding(
                padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)),
                child: textAreaGlobal(
                  controller: transferOrderTemp.remark,
                  onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                  onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                  labelText: remarkOptionalStrGlobal,
                  level: Level.normal,
                ),
              ),
              onTapUnlessDisable: onTapFromOutsiderFunction,
            ),
          );

          // return
        }

        void setFee({required bool isSetEditFeeFalse, required MoneyListTransfer moneyListTransfer, required bool isSetFeeFirst}) {
          print("$selectedMoneyAndDateIndex != -1 => ${selectedMoneyAndDateIndex != -1}");
          if (selectedMoneyAndDateIndex != -1) {
            if (moneyListTransfer.value.text.isNotEmpty && (moneyListTransfer.moneyType != null)) {
              if (isSetEditFeeFalse) {
                moneyListTransfer.isEditFee = false;
              }
              final List<String> feeList = getFeeTransferListOnly(
                partnerId: transferOrderTemp.partner.nameAndInformationId,
                amount: textEditingControllerToDouble(controller: moneyListTransfer.value)!,
                moneyType: moneyListTransfer.moneyType!,
                isTransfer: isTransfer,
              );
              print("feeList.isNotEmpty => ${feeList.isNotEmpty}");
              if (feeList.isNotEmpty) {
                if (!moneyListTransfer.isEditFee && isSetFeeFirst) {
                  moneyListTransfer.discountFee.text = feeList.first;
                }
                moneyListTransfer.fee = double.parse(formatAndLimitNumberTextGlobal(valueStr: feeList.first, isRound: false));
                final double percentage = getFeePercentageTransferListOnly(
                  moneyType: moneyListTransfer.moneyType!,
                  partnerId: transferOrderTemp.partner.nameAndInformationId,
                );
                print("moneyListTransfer.discountFee.text.isNotEmpty => ${moneyListTransfer.discountFee.text.isNotEmpty}");
                if (moneyListTransfer.discountFee.text.isNotEmpty) {
                  final double discountFee = textEditingControllerToDouble(controller: moneyListTransfer.discountFee)!;
                  moneyListTransfer.profit = discountFee - (moneyListTransfer.fee! * (1 - (percentage / 100)));
                  print("$discountFee - (${moneyListTransfer.fee} * (1 - ($percentage / 100))) = ${discountFee - (moneyListTransfer.fee! * (1 - (percentage / 100)))}");
                }
                print("moneyListTransfer.profit: ${moneyListTransfer.profit}");
                print("===========================================");
              }
            }
          }
        }

        void setMergeMoneyList() {
          transferOrderTemp.mergeMoneyList = [];
          for (int moneyIndex = 0; moneyIndex < transferOrderTemp.moneyList.length; moneyIndex++) {
            final MoneyListTransfer moneyListTransfer = transferOrderTemp.moneyList[moneyIndex];
            // moneyListTransfer.discountFee.text = (moneyListTransfer.fee == null) ? "" : moneyListTransfer.discountFee.text;
            final matchMoneyTypeIndex = transferOrderTemp.mergeMoneyList.indexWhere((element) => (element.moneyType == moneyListTransfer.moneyType));
            if (matchMoneyTypeIndex == -1) {
              transferOrderTemp.mergeMoneyList.add(MoneyListTransfer(
                moneyType: moneyListTransfer.moneyType,
                fee: moneyListTransfer.fee,
                discountFee: TextEditingController(text: moneyListTransfer.discountFee.text),
                value: TextEditingController(text: moneyListTransfer.value.text),
                transferDate: DateTime.now(),
              ));
            } else {
              final MoneyListTransfer mergeMoney = transferOrderTemp.mergeMoneyList[matchMoneyTypeIndex];
              mergeMoney.fee = mergeMoney.fee! + moneyListTransfer.fee!;
              mergeMoney.discountFee.text = mergeMoney.fee.toString();
              final double moneyValue = textEditingControllerToDouble(controller: moneyListTransfer.value)!;
              final double mergeMoneyValue = textEditingControllerToDouble(controller: mergeMoney.value)!;
              mergeMoney.value.text = (mergeMoneyValue + moneyValue).toString();
            }
          }
          if (!iSeparateFee) {
            for (int mergeIndex = 0; mergeIndex < transferOrderTemp.mergeMoneyList.length; mergeIndex++) {
              setFee(isSetEditFeeFalse: false, moneyListTransfer: transferOrderTemp.mergeMoneyList[mergeIndex], isSetFeeFirst: true);
            }
          }
        }

        Widget moneyWidget({required int moneyIndex}) {
          Widget valueAndMoneyTypeWidget() {
            Widget amountTextFieldWidget() {
              final String amountTemp = transferOrderTemp.moneyList[selectedMoneyAndDateIndex].value.text;
              void onChangeFromOutsiderFunction() {
                if (transferOrderTemp.moneyList[selectedMoneyAndDateIndex].value.text.isNotEmpty) {
                  setFee(isSetEditFeeFalse: true, moneyListTransfer: transferOrderTemp.moneyList[selectedMoneyAndDateIndex], isSetFeeFirst: true);
                  if (isValidAddOnTap(moneyListTransfer: transferOrderTemp.moneyList).isValid) {
                    setMergeMoneyList();
                  }
                }

                final String amountChangedTemp = transferOrderTemp.moneyList[selectedMoneyAndDateIndex].value.text;
                addActiveLogElement(
                  activeLogModelList: activeLogModelTransferList,
                  activeLogModel: ActiveLogModel(
                    idTemp: "amount textfield, ${moneyIndex.toString()}",
                    activeType: ActiveLogTypeEnum.typeTextfield,
                    locationList: [
                      Location(title: "money index", subtitle: moneyIndex.toString()),
                      Location(
                        color: (amountTemp.length < amountChangedTemp.length) ? ColorEnum.green : ColorEnum.red,
                        title: "amount textfield",
                        subtitle: "${amountTemp.isEmpty ? "" : "$amountTemp to "}$amountChangedTemp",
                      ),
                    ],
                  ),
                );

                setState(() {});
              }

              void onTapFromOutsiderFunction() {
                selectedMoneyAndDateIndex = moneyIndex;
                setState(() {});
              }

              return Padding(
                padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)),
                child: textFieldGlobal(
                  textFieldDataType: TextFieldDataType.double,
                  controller: transferOrderTemp.moneyList[moneyIndex].value,
                  onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                  labelText: amountStrGlobal,
                  level: Level.normal,
                  onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                ),
              );
            }

            Widget feeTextFieldWidget() {
              // List<String> menuItemStrList = [];
              // String? selectedStr;
              final String feeTemp = transferOrderTemp.moneyList[selectedMoneyAndDateIndex].discountFee.text;
              void onChangeFromOutsiderFunction() {
                setFee(isSetEditFeeFalse: false, moneyListTransfer: transferOrderTemp.moneyList[selectedMoneyAndDateIndex], isSetFeeFirst: true);
                if (isValidAddOnTap(moneyListTransfer: transferOrderTemp.moneyList).isValid) {
                  setMergeMoneyList();
                }
                final String feeChangedTemp = transferOrderTemp.moneyList[selectedMoneyAndDateIndex].discountFee.text;
                addActiveLogElement(
                  activeLogModelList: activeLogModelTransferList,
                  activeLogModel: ActiveLogModel(
                    idTemp: "fee dropdown or textfield, ${moneyIndex.toString()}",
                    activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                    locationList: [
                      Location(title: "money index", subtitle: moneyIndex.toString()),
                      Location(
                        color: (feeTemp.length < feeChangedTemp.length) ? ColorEnum.green : ColorEnum.red,
                        title: "fee textfield",
                        subtitle: "${feeTemp.isEmpty ? "" : "$feeTemp to "}$feeChangedTemp",
                      ),
                    ],
                  ),
                );

                setState(() {});
              }

              void onTapFromOutsiderFunction() {
                selectedMoneyAndDateIndex = moneyIndex;
                setState(() {});
              }

              void onChangedDropDrownFunction({required String value, required int index}) {
                final bool isSelectedOtherRate = (value == otherStrGlobal);
                transferOrderTemp.moneyList[moneyIndex].isEditFee = isSelectedOtherRate;
                if (!isSelectedOtherRate) {
                  transferOrderTemp.moneyList[moneyIndex].discountFee.text = value;
                }
                setFee(isSetEditFeeFalse: false, moneyListTransfer: transferOrderTemp.moneyList[selectedMoneyAndDateIndex], isSetFeeFirst: false);
                if (isValidAddOnTap(moneyListTransfer: transferOrderTemp.moneyList).isValid) {
                  setMergeMoneyList();
                }
                final String feeChangedTemp = transferOrderTemp.moneyList[selectedMoneyAndDateIndex].discountFee.text;
                addActiveLogElement(
                  activeLogModelList: activeLogModelTransferList,
                  activeLogModel: ActiveLogModel(
                    idTemp: "fee dropdown or textfield, ${moneyIndex.toString()}",
                    activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                    locationList: [
                      Location(title: "money index", subtitle: moneyIndex.toString()),
                      Location(title: "fee dropdown", subtitle: "${feeTemp.isEmpty ? "" : "$feeTemp to "}$feeChangedTemp"),
                    ],
                  ),
                );

                setState(() {});
              }

              void onDeleteFunction() {
                transferOrderTemp.moneyList[moneyIndex].isEditFee = false;
                transferOrderTemp.moneyList[moneyIndex].discountFee.text = "";

                addActiveLogElement(
                  activeLogModelList: activeLogModelTransferList,
                  activeLogModel: ActiveLogModel(
                    idTemp: "fee dropdown or textfield, ${moneyIndex.toString()}",
                    activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                    locationList: [
                      Location(title: "money index", subtitle: moneyIndex.toString()),
                      Location(color: ColorEnum.red, title: "fee button name", subtitle: "delete button"),
                    ],
                  ),
                );

                setState(() {});
              }

              return DropDownAndTextFieldProviderGlobal(
                level: Level.normal,
                labelStr: feeStrGlobal,
                onTapFunction: onTapFromOutsiderFunction,
                onChangedDropDrownFunction: onChangedDropDrownFunction,
                selectedStr: transferOrderTemp.moneyList[moneyIndex].discountFee.text,
                menuItemStrList: getFeeTransferListOnly(
                  partnerId: transferOrderTemp.partner.nameAndInformationId,
                  amount: textEditingControllerToDouble(controller: transferOrderTemp.moneyList[moneyIndex].value)!,
                  moneyType: transferOrderTemp.moneyList[moneyIndex].moneyType!,
                  isTransfer: isTransfer,
                ),
                controller: transferOrderTemp.moneyList[moneyIndex].discountFee,
                textFieldDataType: TextFieldDataType.double,
                isEnabled: true,
                isShowTextField: transferOrderTemp.moneyList[moneyIndex].isEditFee,
                onDeleteFunction: onDeleteFunction,
                onChangedTextFieldFunction: onChangeFromOutsiderFunction,
              );
            }

            Widget moneyTypeDropDownWidget() {
              void onTapFunction() {
                selectedMoneyAndDateIndex = moneyIndex;
                setState(() {});
              }

              final String moneyTypeTemp = transferOrderTemp.moneyList[selectedMoneyAndDateIndex].moneyType ?? "";
              void onChangedFunction({required String value, required int index}) {
                transferOrderTemp.moneyList[moneyIndex].moneyType = value;
                // transferOrderTemp.moneyList[moneyIndex].isEditFee = false;
                setFee(isSetEditFeeFalse: true, moneyListTransfer: transferOrderTemp.moneyList[selectedMoneyAndDateIndex], isSetFeeFirst: true);
                if (isValidAddOnTap(moneyListTransfer: transferOrderTemp.moneyList).isValid) {
                  setMergeMoneyList();
                }
                final String moneyTypeChangeTemp = transferOrderTemp.moneyList[selectedMoneyAndDateIndex].moneyType!;
                addActiveLogElement(
                  activeLogModelList: activeLogModelTransferList,
                  activeLogModel: ActiveLogModel(
                    idTemp: "dropdown money type, ${moneyIndex.toString()}",
                    activeType: ActiveLogTypeEnum.selectDropdown,
                    locationList: [
                      Location(title: "money index", subtitle: moneyIndex.toString()),
                      Location(title: "dropdown money type", subtitle: "$moneyTypeTemp to $moneyTypeChangeTemp"),
                    ],
                  ),
                );

                setState(() {});
              }

              return customDropdown(
                level: Level.normal,
                labelStr: moneyTypeStrGlobal,
                onTapFunction: onTapFunction,
                onChangedFunction: onChangedFunction,
                selectedStr: transferOrderTemp.moneyList[moneyIndex].moneyType,
                menuItemStrList: getMoneyTypeTransferListOnly(partnerId: transferOrderTemp.partner.nameAndInformationId),
              );
            }

            Widget dateSelectedWidget() {
              DateTime? dateSelected;
              final DateTime dateTimeTemp = transferOrderTemp.moneyList[moneyIndex].transferDate!;
              void onTapUnlessDisableAndValid() async {
                dateSelected = await showDatePicker(
                  // barrierDismissible: false,

                  context: context,
                  initialDate: transferOrderTemp.moneyList[moneyIndex].transferDate!,
                  firstDate: defaultDate(hour: 0, minute: 0, second: 0),
                  lastDate: currentDate,
                  // barrierDismissible: false,
                );
                // dateSelected ??= currentDate;
                if (dateSelected != null) {
                  transferOrderTemp.moneyList[moneyIndex].transferDate = DateTime(
                    dateSelected!.year,
                    dateSelected!.month,
                    dateSelected!.day,
                    transferOrderTemp.moneyList[moneyIndex].transferDate!.hour,
                    transferOrderTemp.moneyList[moneyIndex].transferDate!.minute,
                    0,
                  );
                  final DateTime dateTimeChangeTemp = transferOrderTemp.moneyList[moneyIndex].transferDate!;
                  addActiveLogElement(
                    activeLogModelList: activeLogModelTransferList,
                    activeLogModel: ActiveLogModel(
                      idTemp: "select date, ${moneyIndex.toString()}",
                      activeType: ActiveLogTypeEnum.clickButton,
                      locationList: [
                        Location(title: "money index", subtitle: moneyIndex.toString()),
                        Location(
                          title: "select date",
                          subtitle: "${formatDateDateToStr(date: dateTimeTemp)} to ${formatDateDateToStr(date: dateTimeChangeTemp)}",
                        ),
                      ],
                    ),
                  );
                }
                selectedMoneyAndDateIndex = moneyIndex;
                setState(() {});
              }

              return Padding(
                padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.large), bottom: paddingSizeGlobal(level: Level.normal)),
                child: pickDateAsyncButtonOrContainerWidget(
                  context: context,
                  level: Level.normal,
                  dateStr: formatDateDateToStr(date: transferOrderTemp.moneyList[moneyIndex].transferDate!),
                  onTapFunction: onTapUnlessDisableAndValid,
                ),
              );
            }

            Widget timeWidget() {
              final DateTime dateTimeTemp = transferOrderTemp.moneyList[moneyIndex].transferDate!;
              void callback({required DateTime dateTime}) {
                transferOrderTemp.moneyList[moneyIndex].transferDate = DateTime(
                  transferOrderTemp.moneyList[moneyIndex].transferDate!.year,
                  transferOrderTemp.moneyList[moneyIndex].transferDate!.month,
                  transferOrderTemp.moneyList[moneyIndex].transferDate!.day,
                  dateTime.hour,
                  dateTime.minute,
                  0,
                );
                selectedMoneyAndDateIndex = moneyIndex;
                final DateTime dateTimeChangeTemp = transferOrderTemp.moneyList[moneyIndex].transferDate!;
                addActiveLogElement(
                  activeLogModelList: activeLogModelTransferList,
                  activeLogModel: ActiveLogModel(
                    idTemp: "select time, ${moneyIndex.toString()}",
                    activeType: ActiveLogTypeEnum.clickButton,
                    locationList: [
                      Location(title: "money index", subtitle: moneyIndex.toString()),
                      Location(
                        title: "select time",
                        subtitle: "${formatDateHourToStr(date: dateTimeTemp)} to ${formatDateHourToStr(date: dateTimeChangeTemp)}",
                      ),
                    ],
                  ),
                );

                setState(() {});
              }

              return Padding(
                padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini), bottom: paddingSizeGlobal(level: Level.normal)),
                child: pickTime(
                  callback: callback,
                  context: context,
                  dateTimeOutsider: transferOrderTemp.moneyList[moneyIndex].transferDate!,
                  level: Level.normal,
                  validModel: ValidButtonModel(isValid: true),
                ),
              );
            }

            Widget deleteButtonWidget() {
              void onTapFunction() {
                selectedMoneyAndDateIndex = 0;
                transferOrderTemp.moneyList.removeAt(moneyIndex);
                addActiveLogElement(
                  activeLogModelList: activeLogModelTransferList,
                  activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
                    Location(title: "money index", subtitle: moneyIndex.toString()),
                    Location(color: ColorEnum.red, title: "button name", subtitle: "delete button"),
                  ]),
                );

                setState(() {});
              }

              return Padding(
                padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini), bottom: paddingSizeGlobal(level: Level.normal)),
                child: deleteButtonOrContainerWidget(
                  context: context,
                  onTapFunction: onTapFunction,
                  level: Level.mini,
                  validModel: ValidButtonModel(isValid: (transferOrderTemp.moneyList.length > 1), error: "add money."),
                ),
              );
            }

            bool isShowFee() {
              if (transferOrderTemp.moneyList[moneyIndex].moneyType == null || transferOrderTemp.moneyList[moneyIndex].value.text.isEmpty) {
                return false;
              } else {
                if (textEditingControllerToDouble(controller: transferOrderTemp.moneyList[moneyIndex].value) == 0) {
                  return false;
                }
              }
              final List<String> feeList = getFeeTransferListOnly(
                partnerId: transferOrderTemp.partner.nameAndInformationId,
                amount: textEditingControllerToDouble(controller: transferOrderTemp.moneyList[moneyIndex].value)!,
                moneyType: transferOrderTemp.moneyList[moneyIndex].moneyType!,
                isTransfer: isTransfer,
              );
              if (feeList.isEmpty) {
                return false;
              }
              return iSeparateFee;
            }

            return Column(
              children: [
                Row(children: [
                  timeWidget(),
                  dateSelectedWidget(),
                  deleteButtonWidget(),
                ]),
                Row(children: [
                  Expanded(child: moneyTypeDropDownWidget()),
                  (transferOrderTemp.moneyList[moneyIndex].moneyType == null) ? Container() : Expanded(child: amountTextFieldWidget()),
                  isShowFee() ? Expanded(child: feeTextFieldWidget()) : Container(),
                ]),
              ],
            );
          }

          void onTapUnlessDisable() {
            selectedMoneyAndDateIndex = moneyIndex;
            setState(() {});
          }

          return Padding(
            padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini), bottom: paddingSizeGlobal(level: Level.mini)),
            child: CustomButtonGlobal(
              sizeBoxWidth: dialogSizeGlobal(level: Level.mini),
              insideSizeBoxWidget: Padding(
                padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)),
                child: valueAndMoneyTypeWidget(),
              ),
              onTapUnlessDisable: onTapUnlessDisable,
              isDisable: (selectedMoneyAndDateIndex == moneyIndex),
            ),
          );
        }

        Widget mergeAmountWidget() {
          Widget toggleWidget() {
            void onToggle() {
              iSeparateFee = !iSeparateFee;
              if (isValidAddOnTap(moneyListTransfer: transferOrderTemp.moneyList).isValid) {
                setMergeMoneyList();
              }
              addActiveLogElement(
                activeLogModelList: activeLogModelTransferList,
                activeLogModel: ActiveLogModel(idTemp: "separate or merge", activeType: ActiveLogTypeEnum.clickButton, locationList: [
                  Location(title: "toggle merge money button", subtitle: iSeparateFee ? "merge to separate" : "separate to merge"),
                ]),
              );
              setState(() {});
            }

            return Padding(
              padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large), right: paddingSizeGlobal(level: Level.normal)),
              child: separateAndMergeToggleWidgetGlobal(isLeftSelected: iSeparateFee, onToggle: onToggle),
            );
          }

          Widget totalAmountAndFee({required int moneyIndex}) {
            Widget amountTextFieldWidget() {
              final String moneyType = transferOrderTemp.mergeMoneyList[moneyIndex].moneyType!;
              // double amountTotalNumber = transferOrderTemp.mergeMoneyList[moneyIndex].discountFee.text.isEmpty? 0: ;
              // if () {
              final double valueNumber = textEditingControllerToDouble(controller: transferOrderTemp.mergeMoneyList[moneyIndex].value)!;
              final double discountFeeNumber =
                  transferOrderTemp.mergeMoneyList[moneyIndex].discountFee.text.isEmpty ? 0 : textEditingControllerToDouble(controller: transferOrderTemp.mergeMoneyList[moneyIndex].discountFee)!;
              final double amountTotalNumber = ((isTransfer ? 1 : -1) * valueNumber) + discountFeeNumber;
              // }
              final String amountTotalStr = formatAndLimitNumberTextGlobal(
                valueStr: amountTotalNumber.toString(),
                isRound: false,
                places: findMoneyModelByMoneyType(moneyType: moneyType).decimalPlace!,
              );
              return Text(
                "$amountTotalStr $moneyType",
                style: textStyleGlobal(
                  level: Level.large,
                  // fontWeight: FontWeight.bold,
                  color: ((amountTotalNumber >= 0) ? positiveColorGlobal : negativeColorGlobal),
                ),
              );
            }

            Widget feeTextFieldWidget() {
              final String feeTemp = transferOrderTemp.mergeMoneyList[moneyIndex].discountFee.text;
              // List<String> menuItemStrList = [];
              // String? selectedStr;
              void onChangeFromOutsiderFunction() {
                setFee(isSetEditFeeFalse: false, moneyListTransfer: transferOrderTemp.mergeMoneyList[moneyIndex], isSetFeeFirst: true);
                // if (isValidAddOnTap()) {
                //   setMergeMoneyList();
                // }

                final String feeChangedTemp = transferOrderTemp.mergeMoneyList[moneyIndex].discountFee.text;
                addActiveLogElement(
                  activeLogModelList: activeLogModelTransferList,
                  activeLogModel: ActiveLogModel(
                    idTemp: "merge fee dropdown or textfield, ${moneyIndex.toString()}",
                    activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                    locationList: [
                      Location(title: "money index", subtitle: moneyIndex.toString()),
                      Location(
                        color: (feeTemp.length < feeChangedTemp.length) ? ColorEnum.green : ColorEnum.red,
                        title: "fee textfield",
                        subtitle: "${feeTemp.isEmpty ? "" : "$feeTemp to "}$feeChangedTemp",
                      ),
                    ],
                  ),
                );

                setState(() {});
              }

              void onTapFromOutsiderFunction() {}

              void onChangedDropDrownFunction({required String value, required int index}) {
                // final bool isSelectedOtherRate = (value == otherStrGlobal);
                // transferOrderTemp.moneyList[moneyIndex].isEditFee = isSelectedOtherRate;
                // if (!isSelectedOtherRate) {
                //   transferOrderTemp.moneyList[moneyIndex].discountFee.text = value;
                // }
                final bool isSelectedOtherRate = (value == otherStrGlobal);
                transferOrderTemp.mergeMoneyList[moneyIndex].isEditFee = isSelectedOtherRate;
                if (!isSelectedOtherRate) {
                  transferOrderTemp.mergeMoneyList[moneyIndex].discountFee.text = value;
                }
                setFee(isSetEditFeeFalse: false, moneyListTransfer: transferOrderTemp.mergeMoneyList[moneyIndex], isSetFeeFirst: false);
                // if (isValidAddOnTap()) {
                //   setMergeMoneyList();
                // }

                final String feeChangedTemp = transferOrderTemp.mergeMoneyList[moneyIndex].discountFee.text;
                addActiveLogElement(
                  activeLogModelList: activeLogModelTransferList,
                  activeLogModel: ActiveLogModel(
                    idTemp: "merge fee dropdown or textfield, ${moneyIndex.toString()}",
                    activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                    locationList: [
                      Location(title: "money index", subtitle: moneyIndex.toString()),
                      Location(title: "fee textfield", subtitle: "${feeTemp.isEmpty ? "" : "$feeTemp to "}$feeChangedTemp"),
                    ],
                  ),
                );

                setState(() {});
              }

              void onDeleteFunction() {
                transferOrderTemp.mergeMoneyList[moneyIndex].isEditFee = false;
                transferOrderTemp.mergeMoneyList[moneyIndex].discountFee.text = "";

                addActiveLogElement(
                  activeLogModelList: activeLogModelTransferList,
                  activeLogModel: ActiveLogModel(
                    idTemp: "merge fee dropdown or textfield, ${moneyIndex.toString()}",
                    activeType: ActiveLogTypeEnum.changeBetweenDropdownAndTextfield,
                    locationList: [
                      Location(title: "merge money index", subtitle: moneyIndex.toString()),
                      Location(title: "merge money type", subtitle: transferOrderTemp.mergeMoneyList[moneyIndex].moneyType!),
                      Location(color: ColorEnum.red, title: "merge fee button name", subtitle: "delete button"),
                    ],
                  ),
                );

                setState(() {});
              }

              return DropDownAndTextFieldProviderGlobal(
                level: Level.normal,
                labelStr: feeStrGlobal,
                onTapFunction: onTapFromOutsiderFunction,
                onChangedDropDrownFunction: onChangedDropDrownFunction,
                selectedStr: transferOrderTemp.mergeMoneyList[moneyIndex].discountFee.text,
                menuItemStrList: getFeeTransferListOnly(
                  partnerId: transferOrderTemp.partner.nameAndInformationId,
                  amount: textEditingControllerToDouble(controller: transferOrderTemp.mergeMoneyList[moneyIndex].value)!,
                  moneyType: transferOrderTemp.mergeMoneyList[moneyIndex].moneyType!,
                  isTransfer: isTransfer,
                ),
                controller: transferOrderTemp.mergeMoneyList[moneyIndex].discountFee,
                textFieldDataType: TextFieldDataType.double,
                isEnabled: true,
                isShowTextField: transferOrderTemp.mergeMoneyList[moneyIndex].isEditFee,
                onDeleteFunction: onDeleteFunction,
                onChangedTextFieldFunction: onChangeFromOutsiderFunction,
              );
            }

            return Row(children: [
              Text("${isTransfer ? "" : "- "}Amount + Fee = ", style: textStyleGlobal(level: Level.normal)),
              Expanded(flex: flexValueGlobal, child: amountTextFieldWidget()),
              iSeparateFee ? Container() : Expanded(flex: flexTypeGlobal, child: feeTextFieldWidget()),
            ]);
          }

          void onTapFromOutsiderFunction() {}
          bool isShowTotal() {
            for (int mergeIndex = 0; mergeIndex < transferOrderTemp.mergeMoneyList.length; mergeIndex++) {
              if (transferOrderTemp.mergeMoneyList[mergeIndex].value.text.isEmpty) {
                return false;
              }
              if (transferOrderTemp.mergeMoneyList[mergeIndex].moneyType == null) {
                return false;
              }
              if (transferOrderTemp.mergeMoneyList[mergeIndex].fee == null) {
                return false;
              }
              // if (transferOrderTemp.mergeMoneyList[mergeIndex].discountFee.text.isEmpty) {
              //   return false;
              // }
              final List<String> feeTransferList = getFeeTransferListOnly(
                partnerId: transferOrderTemp.partner.nameAndInformationId,
                amount: textEditingControllerToDouble(controller: transferOrderTemp.mergeMoneyList[mergeIndex].value)!,
                moneyType: transferOrderTemp.mergeMoneyList[mergeIndex].moneyType!,
                isTransfer: isTransfer,
              );
              if (feeTransferList.isEmpty) {
                return false;
              }
            }
            return true;
          }

          return (isShowTotal() && isValidAddOnTap(moneyListTransfer: transferOrderTemp.moneyList).isValid)
              ? Padding(
                  padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini), bottom: paddingSizeGlobal(level: Level.normal)),
                  child: CustomButtonGlobal(
                    sizeBoxWidth: dialogSizeGlobal(level: Level.mini),
                    insideSizeBoxWidget: Padding(
                      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        toggleWidget(),
                        for (int rateIndex = 0; rateIndex < transferOrderTemp.mergeMoneyList.length; rateIndex++) totalAmountAndFee(moneyIndex: rateIndex),
                      ]),
                    ),
                    onTapUnlessDisable: onTapFromOutsiderFunction,
                  ),
                )
              : Container();
        }

        return [
          partnerAndSenderAndReceiverWidget(),
          for (int rateIndex = 0; rateIndex < transferOrderTemp.moneyList.length; rateIndex++) moneyWidget(moneyIndex: rateIndex),
          mergeAmountWidget(),
          remarkTextFieldWidget(),
        ];
      }

      void addOnTapFunction() {
        final int moneyLengthTemp = transferOrderTemp.moneyList.length;
        transferOrderTemp.moneyList.add(MoneyListTransfer(
          discountFee: TextEditingController(),
          value: TextEditingController(),
          transferDate: DateTime(currentDate.year, currentDate.month, currentDate.day, currentDate.hour, currentDate.minute, currentDate.second),
        ));
        selectedMoneyAndDateIndex = transferOrderTemp.moneyList.length - 1;
        final int moneyLengthChangeTemp = transferOrderTemp.moneyList.length;
        addActiveLogElement(
          activeLogModelList: activeLogModelTransferList,
          activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(title: "money length", subtitle: "$moneyLengthTemp to $moneyLengthChangeTemp"),
            Location(color: ColorEnum.green, title: "button name", subtitle: "add button"),
          ]),
        );
        setState(() {});
      }

      void updateTransferToDBOrPrint({required bool isPrint}) {
        transferCheckForFinalEdition(
          activeLogModelList: activeLogModelTransferList,
          moneyList: transferOrderTemp.moneyList,
          mergeMoneyList: transferOrderTemp.mergeMoneyList,
        );
        setFinalEditionActiveLog(activeLogModelList: activeLogModelTransferList);
        transferOrderTemp.activeLogModelList = activeLogModelTransferList;
        TransferOrder transferOrderClone = cloneTransferOrder(transferOrder: transferOrderTemp);
        if (transferOrderClone.sender != null) {
          if (transferOrderClone.sender!.name.text.isEmpty && transferOrderClone.sender!.informationList.first.subtitle.text.isEmpty) {
            transferOrderClone.sender = null;
          }
        }
        selectedMoneyAndDateIndex = -1;
        transferOrderClone.isTransfer = isTransfer;
        transferOrderClone.isUseBank = isUseBank;
        transferOrderClone.isOtherBank = isOtherBank;
        for (int moneyIndex = 0; moneyIndex < transferOrderClone.moneyList.length; moneyIndex++) {
          // transferOrderClone.moneyList[moneyIndex].fee = -1 * transferOrderClone.moneyList[moneyIndex].fee!;
          // transferOrderClone.moneyList[moneyIndex].discountFee.text = "-${transferOrderClone.moneyList[moneyIndex].discountFee.text}";
          if (!isTransfer) {
            transferOrderClone.moneyList[moneyIndex].value.text = "-${transferOrderClone.moneyList[moneyIndex].value.text}";
          }
        }
        if (iSeparateFee) {
          transferOrderClone.mergeMoneyList = [];
        }
        void callBack({required bool isMatchTransfer, required List<MatchTransferList> transferOrderMatchList}) {
          if (isMatchTransfer) {
            void cancelFunctionOnTap() {
              closeDialogGlobal(context: context);
            }

            Widget editCustomerDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
              Widget paddingBottomWidget({required Widget widget}) {
                return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: widget);
              }

              Widget titleTextFieldWidget() {
                return Text(duplicateStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold));
              }

              Widget matchTransferElementWidget({required int matchTransferIndex}) {
                Widget currentOrPastTransfer({required List<TransferOrder> transferList, required String titleStr}) {
                  Widget detailWidget({required int matchTransferSubIndex}) {
                    final String dateStr = formatFullWithoutSSDateToStr(date: transferList[matchTransferSubIndex].date ?? DateTime.now());
                    final String moneyType = transferList[matchTransferSubIndex].moneyList.first.moneyType!;
                    final double valueNumber = textEditingControllerToDouble(controller: transferList[matchTransferSubIndex].moneyList.first.value)!;
                    double feeNumber = textEditingControllerToDouble(controller: transferList[matchTransferSubIndex].moneyList.first.discountFee)!;
                    final bool isMergeMoney = transferList[matchTransferSubIndex].mergeMoneyList.isNotEmpty;
                    if (isMergeMoney) {
                      final int moneyTypeMergeIndex = transferList[matchTransferSubIndex].mergeMoneyList.indexWhere((element) => element.moneyType == moneyType);
                      final double valueMergeNumber = textEditingControllerToDouble(controller: transferList[matchTransferSubIndex].mergeMoneyList[moneyTypeMergeIndex].value)!;
                      final double feeMergeNumber = textEditingControllerToDouble(controller: transferList[matchTransferSubIndex].mergeMoneyList[moneyTypeMergeIndex].discountFee)!;
                      feeNumber = feeMergeNumber * valueNumber / valueMergeNumber;
                    }
                    final String amountStr = formatAndLimitNumberTextGlobal(
                      valueStr: valueNumber.toString(),
                      isRound: false,
                      places: findMoneyModelByMoneyType(moneyType: moneyType).decimalPlace!,
                    );

                    final String feeStr = formatAndLimitNumberTextGlobal(
                      valueStr: (feeNumber.abs()).toString(),
                      isRound: false,
                      places: findMoneyModelByMoneyType(moneyType: moneyType).decimalPlace!,
                    );

                    final String dateTransferStr = formatFullWithoutSSDateToStr(date: transferList[matchTransferSubIndex].moneyList.first.transferDate!);
                    final bool isTransfer = transferList[matchTransferSubIndex].isTransfer;

                    Widget transferInformationWidget({required PartnerAndSenderAndReceiver? partnerAndSenderAndReceiver, required String titleStr}) {
                      return (partnerAndSenderAndReceiver == null)
                          ? Container()
                          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text("$titleStr name: ${partnerAndSenderAndReceiver.name.text}", style: textStyleGlobal(level: Level.mini)),
                              for (int informationIndex = 0; informationIndex < partnerAndSenderAndReceiver.informationList.length; informationIndex++)
                                Text(
                                  "$titleStr ${partnerAndSenderAndReceiver.informationList[informationIndex].title.text}: ${partnerAndSenderAndReceiver.informationList[informationIndex].subtitle.text}",
                                  style: textStyleGlobal(level: Level.mini),
                                ),
                            ]);
                    }

                    final String remakeStr = transferList[matchTransferSubIndex].remark.text;
                    return Padding(
                      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text("invoice date: $dateStr", style: textStyleGlobal(level: Level.mini, fontWeight: FontWeight.bold)),
                        Text("invoice id: ${transferList[matchTransferSubIndex].id ?? "not save yet"}", style: textStyleGlobal(level: Level.mini)),
                        Text("is transfer: $isTransfer", style: textStyleGlobal(level: Level.mini)),
                        Text("is use bank: ${transferList[matchTransferSubIndex].isUseBank}", style: textStyleGlobal(level: Level.mini)),
                        Text("is other bank: ${transferList[matchTransferSubIndex].isOtherBank}", style: textStyleGlobal(level: Level.mini)),
                        transferInformationWidget(partnerAndSenderAndReceiver: transferList[matchTransferSubIndex].partner, titleStr: "partner"),
                        transferInformationWidget(partnerAndSenderAndReceiver: transferList[matchTransferSubIndex].sender, titleStr: "sender"),
                        transferInformationWidget(partnerAndSenderAndReceiver: transferList[matchTransferSubIndex].receiver, titleStr: "receiver"),
                        Text("${isTransfer ? "transfer" : "receive"} date: $dateTransferStr", style: textStyleGlobal(level: Level.mini)),
                        Text("amount: $amountStr $moneyType", style: textStyleGlobal(level: Level.mini)),
                        Text("fee: $feeStr $moneyType", style: textStyleGlobal(level: Level.mini)),
                        remakeStr.isEmpty ? Container() : Text("remark: $remakeStr", style: textStyleGlobal(level: Level.mini)),
                      ]),
                    );
                  }

                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                      child: Text(titleStr, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                    ),
                    for (int matchTransferSubIndex = 0; matchTransferSubIndex < transferList.length; matchTransferSubIndex++) detailWidget(matchTransferSubIndex: matchTransferSubIndex)
                  ]);
                }

                Widget insideSizeBoxWidget() {
                  return Padding(
                    padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(
                        child: currentOrPastTransfer(
                          transferList: transferOrderMatchList[matchTransferIndex].currentList,
                          titleStr: "Current ${transferOrderMatchList[matchTransferIndex].currentList.first.isTransfer ? "Transfer" : "Receive"}",
                        ),
                      ),
                      Container(width: paddingSizeGlobal(level: Level.normal)),
                      Expanded(
                        child: currentOrPastTransfer(
                          transferList: transferOrderMatchList[matchTransferIndex].pastList,
                          titleStr: "Past ${transferOrderMatchList[matchTransferIndex].pastList.first.isTransfer ? "Transfer" : "Receive"}",
                        ),
                      ),
                    ]),
                  );
                }

                void onTapUnlessDisable() {}
                return Padding(
                  padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                  child: CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable),
                );
              }

              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                paddingBottomWidget(widget: titleTextFieldWidget()),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(paddingSizeGlobal(level: Level.large)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        for (int matchTransferIndex = 0; matchTransferIndex < transferOrderMatchList.length; matchTransferIndex++) matchTransferElementWidget(matchTransferIndex: matchTransferIndex)
                      ]),
                    ),
                  ),
                ),
              ]);
            }

            void okFunctionOnTap() {
              void callBack({required bool isMatchTransfer, required List<MatchTransferList> transferOrderMatchList}) {
                if (isPrint) {
                  printTransferInvoice(transferOrder: transferModelListEmployeeGlobal.first, context: context);
                }
                clearFunction();
                activeLogModelTransferList = [];
                widget.callback();
              }

              updateTransferEmployeeGlobal(callBack: callBack, context: context, transferOrderTemp: transferOrderClone, isForceUpdate: true);
            }

            actionDialogSetStateGlobal(
              dialogHeight: dialogSizeGlobal(level: Level.mini),
              dialogWidth: dialogSizeGlobal(level: Level.mini),
              cancelFunctionOnTap: cancelFunctionOnTap,
              context: context,
              contentFunctionReturnWidget: editCustomerDialog,
              okFunctionOnTap: okFunctionOnTap,
            );
          } else {
            if (isPrint) {
              printTransferInvoice(transferOrder: transferModelListEmployeeGlobal.first, context: context);
            }
            clearFunction();
            setState(() {});
            activeLogModelTransferList = [];
            widget.callback();
          }
        }

        updateTransferEmployeeGlobal(callBack: callBack, context: context, transferOrderTemp: transferOrderClone, isForceUpdate: false);
      }

      void saveOnTapFunction() {
        addActiveLogElement(
          activeLogModelList: activeLogModelTransferList,
          activeLogModel: ActiveLogModel(idTemp: "save or save and print button", activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "save button"),
          ]),
        );
        print("transferOrderClone: ${json.encode(transferOrderTemp.toJson())}");
        updateTransferToDBOrPrint(isPrint: false);
      }

      void saveAndPrintOnTapFunction() {
        addActiveLogElement(
          activeLogModelList: activeLogModelTransferList,
          activeLogModel: ActiveLogModel(idTemp: "save or save and print button", activeType: ActiveLogTypeEnum.clickButton, locationList: [
            Location(color: ColorEnum.blue, title: "button name", subtitle: "save and print button"),
          ]),
        );

        updateTransferToDBOrPrint(isPrint: true);
      }

      return BodyTemplateSideMenu(
        title: widget.title,
        isValidSaveOnTap: isValidSave(),
        isValidSaveAndPrintOnTap: isValidSave(),
        inWrapWidgetList: inWrapWidgetList(),
        historyOnTapFunction: historyOnTapFunction,
        saveOnTapFunction: saveOnTapFunction,
        saveAndPrintOnTapFunction: saveAndPrintOnTapFunction,
        clearFunction: clearFunction,
        addOnTapFunction: addOnTapFunction,
        isValidAddOnTap: isValidAddOnTap(moneyListTransfer: transferOrderTemp.moneyList),
        currentAddButtonQty: transferOrderTemp.moneyList.length,
        maxAddButtonLimit: transferInvoiceAddButtonLimitGlobal,
      );
    }

    return bodyTemplateSideMenu();
  }
}
