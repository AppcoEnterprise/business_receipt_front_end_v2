import 'package:business_receipt/env/function/button/button_env.dart';
import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/customer.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/request_api/transfer_request_api_env.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/function/table_env.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/active_log.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/icon_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/transfer_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class TransferAdminSideMenu extends StatefulWidget {
  String title;
  TransferAdminSideMenu({Key? key, required this.title}) : super(key: key);

  @override
  State<TransferAdminSideMenu> createState() => _TransferAdminSideMenuState();
}

class _TransferAdminSideMenuState extends State<TransferAdminSideMenu> {
  @override
  Widget build(BuildContext context) {
    Widget loadingOrBody() {
      void setUpTransferDialog({required bool isCreateNewTransfer, required int? transferIndex}) {
        DateTime? deleteDateOrNull;
        int selectedMoneyTypeIndex = 0; //-1 mean not show category detail
        TransferModel transferTemp = TransferModel(moneyTypeList: []);
        if (!isCreateNewTransfer) {
          transferTemp = cloneTransferModel(transferIndex: transferIndex!);
          deleteDateOrNull = transferModelListGlobal[transferIndex].deletedDate;
        }
        // if (deleteDateOrNull == null) {
        editingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.transfer);
        // }

        void initUnlessCategoryControllerListIsEmpty() {
          if (transferTemp.moneyTypeList.isEmpty) {
            MoneyList moneyList = MoneyList(
              endValue: TextEditingController(),
              startValue: TextEditingController(),
              fee: TextEditingController(),
              limitFee: [TextEditingController(), TextEditingController()],
            );
            transferTemp.moneyTypeList.add(MoneyTypeList(
                shareFeePercentage: TextEditingController(),
                moneyList: [moneyList],
                moneyType: null,
                limitValue: [TextEditingController(), TextEditingController()]));
          }
        }

        initUnlessCategoryControllerListIsEmpty();

        void cancelFunctionOnTap() {
          void okFunction() {
            adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.transfer);
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

        void saveFunctionOnTap() {
          void callback() {
            adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.transfer);
            setState(() {});
          }

          //close the rate dialog
          closeDialogGlobal(context: context);

          updateTransferGlobal(callBack: callback, context: context, transferTemp: transferTemp);
        }

        ValidButtonModel validSaveButtonFunction() {
          //check null on value
          final bool isTransferNameEmpty = (transferTemp.customerId == null);
          if (isTransferNameEmpty && (transferIndex != 0)) {
            // return false;
            // return ValidButtonModel(isValid: false, errorStr: "Please select a customer.");
            return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.valueOfString, error: "customer is not selected.");
          }
          for (int moneyIndex = 0; moneyIndex < transferTemp.moneyTypeList.length; moneyIndex++) {
            final bool isMoneyTypeEmpty = (transferTemp.moneyTypeList[moneyIndex].moneyType == null || transferTemp.moneyTypeList[moneyIndex].moneyType == "");
            if (isMoneyTypeEmpty) {
              final String customerName = (transferTemp.customerId == null)
                  ? profileModelAdminGlobal!.name.text
                  : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;
              // return false;
              // return ValidButtonModel(isValid: false, errorStr: "Transfer money type index $moneyIndex cannot be empty.");
              return ValidButtonModel(
                isValid: false,
                errorType: ErrorTypeEnum.valueOfString,
                errorLocationList: [
                  TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                  TitleAndSubtitleModel(title: "money type index", subtitle: moneyIndex.toString()),
                ],
                error: "money type is not selected.",
              );
            }

            final bool isShareFeePercentageEmpty = transferTemp.moneyTypeList[moneyIndex].shareFeePercentage.text.isEmpty;
            if (isShareFeePercentageEmpty) {
              // return false;
              // return ValidButtonModel(isValid: false, errorStr: "Transfer share fee percentage index $moneyIndex cannot be empty.");
            } else {
              final TextEditingController percentageController = transferTemp.moneyTypeList[moneyIndex].shareFeePercentage;
              final double percentage = textEditingControllerToDouble(controller: percentageController)!;
              if (!((0 <= percentage) && (percentage <= 100))) {
                // return false;
                // return ValidButtonModel(
                //   isValid: false,
                //   errorStr: "Transfer share fee percentage index $moneyIndex ${percentageController.text} must be between 0 and 100.",
                // );
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.compareNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "percentage", subtitle: percentageController.text)
                  ],
                  error: "share fee percentage must be between 0 and 100.",
                );
              }
            }

            if (moneyIndex != selectedMoneyTypeIndex) {
              if (selectedMoneyTypeIndex != -1) {
                final bool isMoneyTypeDuplicate =
                    transferTemp.moneyTypeList[moneyIndex].moneyType == transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyType;
                if (isMoneyTypeDuplicate) {
                  // return false;
                }
              }
            }
            if (selectedMoneyTypeIndex != -1) {
              if (transferTemp.moneyTypeList[moneyIndex].limitValue.isEmpty) {
                // return false;
                // return ValidButtonModel(isValid: false, errorStr: "Transfer money type index $moneyIndex limit value cannot be empty.");
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.arrayLength,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "limit length", subtitle: transferTemp.moneyTypeList[moneyIndex].limitValue.length.toString()),
                  ],
                  error: "limit length equal 0.",
                );
              }

              if (transferTemp.moneyTypeList[moneyIndex].limitValue.length < 2) {
                // return false;
                // return ValidButtonModel(isValid: false, errorStr: "Transfer money type index $moneyIndex limit value must have 2 value.");
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.arrayLength,
                  overwriteRule: "limit length must be equal 2.",
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "limit length", subtitle: transferTemp.moneyTypeList[moneyIndex].limitValue.length.toString()),
                  ],
                  error: "limit length equal ${transferTemp.moneyTypeList[moneyIndex].limitValue.length.toString()}.",
                );
              }
              if (transferTemp.moneyTypeList[moneyIndex].limitValue.first.text.isEmpty) {
                // return false;
                // return ValidButtonModel(isValid: false, errorStr: "Transfer money type index $moneyIndex limit value first cannot be empty.");
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;
                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.valueOfNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "minimum value", subtitle: transferTemp.moneyTypeList[moneyIndex].limitValue.first.text),
                  ],
                  error: "minimum value is empty.",
                );
              } else {
                if (textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].limitValue.first) == 0) {
                  // return false;
                  // return ValidButtonModel(isValid: false, errorStr: "Transfer money type index $moneyIndex limit value first cannot be 0.");
                  final String customerName = (transferTemp.customerId == null)
                      ? profileModelAdminGlobal!.name.text
                      : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfNumber,
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                      TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                      TitleAndSubtitleModel(title: "minimum value", subtitle: transferTemp.moneyTypeList[moneyIndex].limitValue.first.text),
                    ],
                    error: "minimum value equal 0.",
                  );
                }
              }
              if (transferTemp.moneyTypeList[moneyIndex].limitValue.last.text.isEmpty) {
                // return false;
                // return ValidButtonModel(isValid: false, errorStr: "Transfer money type index $moneyIndex limit value last cannot be empty.");
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.valueOfNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "maximum value", subtitle: transferTemp.moneyTypeList[moneyIndex].limitValue.last.text),
                  ],
                  error: "maximum value is empty.",
                );
              } else {
                if (textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].limitValue.last) == 0) {
                  // return false;
                  // return ValidButtonModel(isValid: false, errorStr: "Transfer money type index $moneyIndex limit value last cannot be 0.");
                  final String customerName = (transferTemp.customerId == null)
                      ? profileModelAdminGlobal!.name.text
                      : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfNumber,
                    errorLocationList: [
                      TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                      TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                      TitleAndSubtitleModel(title: "maximum value", subtitle: transferTemp.moneyTypeList[moneyIndex].limitValue.last.text),
                    ],
                    error: "maximum value equal 0.",
                  );
                }
              }
              final TextEditingController minimumAmountController = transferTemp.moneyTypeList[moneyIndex].limitValue.first;

              final TextEditingController maximumAmountController = transferTemp.moneyTypeList[moneyIndex].limitValue.last;
              if (textEditingControllerToDouble(controller: minimumAmountController)! >= textEditingControllerToDouble(controller: maximumAmountController)!) {
                // return false;
                // return ValidButtonModel(
                //   isValid: false,
                //   errorStr:
                //       "Transfer money type index $moneyIndex limit value first ${minimumAmountController.text} must be less than limit value last ${maximumAmountController.text}.",
                // );
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.compareNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "minimum value", subtitle: minimumAmountController.text),
                    TitleAndSubtitleModel(title: "maximum value", subtitle: maximumAmountController.text),
                  ],
                  error: "minimum value must be less than maximum value.",
                  detailList: [
                    TitleAndSubtitleModel(
                      title: "${minimumAmountController.text} >= ${maximumAmountController.text}",
                      subtitle: "invalid compare",
                    ),
                  ],
                );
              }
            }
            final double minAmountNumber = textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].limitValue.first)!;
            final double maxAmountNumber = textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].limitValue.last)!;
            for (int moneyListIndex = 0; moneyListIndex < transferTemp.moneyTypeList[moneyIndex].moneyList.length; moneyListIndex++) {
              final bool isMoneyListFeeEmpty = transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].fee.text.isEmpty;
              final bool isMoneyListStartValueEmpty = transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].startValue.text.isEmpty;
              final bool isMoneyListEndValueEmpty = transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].endValue.text.isEmpty;
              // if (isMoneyListFeeEmpty || isMoneyListStartValueEmpty || isMoneyListEndValueEmpty) {
              //   // return false;

              // }
              if (isMoneyListFeeEmpty) {
                // return false;
                // return ValidButtonModel(
                //     isValid: false, errorStr: "Transfer money type index $moneyIndex money list index $moneyListIndex fee cannot be empty.");
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.valueOfNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "Table index", subtitle: moneyListIndex.toString()),
                    TitleAndSubtitleModel(title: "fee", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].fee.text),
                  ],
                  error: "fee is empty.",
                );
              }
              if (isMoneyListStartValueEmpty) {
                // return false;
                // return ValidButtonModel(
                //     isValid: false, errorStr: "Transfer money type index $moneyIndex money list index $moneyListIndex start value cannot be empty.");
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.valueOfNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "Table index", subtitle: moneyListIndex.toString()),
                    TitleAndSubtitleModel(title: "start value", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].startValue.text),
                  ],
                  error: "start value is empty.",
                );
              }
              if (isMoneyListEndValueEmpty) {
                // return false;
                // return ValidButtonModel(
                //     isValid: false, errorStr: "Transfer money type index $moneyIndex money list index $moneyListIndex end value cannot be empty.");
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.valueOfNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "Table index", subtitle: moneyListIndex.toString()),
                    TitleAndSubtitleModel(title: "end value", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].endValue.text),
                  ],
                  error: "end value is empty.",
                );
              }
              if (transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.isEmpty) {
                // return false;
                // return ValidButtonModel(
                //     isValid: false, errorStr: "Transfer money type index $moneyIndex money list index $moneyListIndex limit fee cannot be empty.");
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.arrayLength,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "Table index", subtitle: moneyListIndex.toString()),
                    TitleAndSubtitleModel(
                        title: "limit fee length", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.length.toString()),
                  ],
                  error: "limit fee length equal 0.",
                );
              }

              if (transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.length < 2) {
                // return false;
                // return ValidButtonModel(
                //     isValid: false, errorStr: "Transfer money type index $moneyIndex money list index $moneyListIndex limit fee must have 2 value.");
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.arrayLength,
                  overwriteRule: "limit fee length must be equal 2.",
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "Table index", subtitle: moneyListIndex.toString()),
                    TitleAndSubtitleModel(
                        title: "limit fee length", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.length.toString()),
                  ],
                  error: "limit fee length equal ${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.length.toString()}.",
                );
              }
              if (transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.first.text.isEmpty) {
                // return false;
                // return ValidButtonModel(
                //     isValid: false, errorStr: "Transfer money type index $moneyIndex money list index $moneyListIndex limit fee first cannot be empty.");
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.valueOfNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "Table index", subtitle: moneyListIndex.toString()),
                    TitleAndSubtitleModel(title: "minimum fee", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.first.text),
                  ],
                  error: "minimum fee is empty.",
                );
              }
              // else {
              //   if (textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.first) == 0) {
              //     return false;
              //   }
              // }
              if (transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.last.text.isEmpty) {
                // return false;
                // return ValidButtonModel(
                //     isValid: false, errorStr: "Transfer money type index $moneyIndex money list index $moneyListIndex limit fee last cannot be empty.");
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.valueOfNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "Table index", subtitle: moneyListIndex.toString()),
                    TitleAndSubtitleModel(title: "maximum fee", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.last.text),
                  ],
                  error: "maximum fee is empty.",
                );
              }
              // else {
              //   if (textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.last) == 0) {
              //     return false;
              //   }
              // }

              if (textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.first)! >
                  textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.last)!) {
                // return false;
                // return ValidButtonModel(
                //   isValid: false,
                //   errorStr:
                //       "Transfer money type index $moneyIndex money list index $moneyListIndex limit fee first ${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.first.text} must be less than limit fee last ${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.last.text}.",
                // );
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.compareNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "Table index", subtitle: moneyListIndex.toString()),
                    TitleAndSubtitleModel(
                      title: "minimum value",
                      subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.first.text,
                    ),
                    TitleAndSubtitleModel(
                      title: "maximum value",
                      subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.last.text,
                    ),
                  ],
                  error: "minimum fee must be less than maximum fee.",
                  detailList: [
                    TitleAndSubtitleModel(
                      title:
                          "${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.first.text} >= ${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.last.text}",
                      subtitle: "invalid compare",
                    ),
                  ],
                );
              }

              final double startValueNumber =
                  textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].startValue)!;
              final double endValueNumber =
                  textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].endValue)!;
              if (!(minAmountNumber <= startValueNumber && startValueNumber <= maxAmountNumber)) {
                // return false;
                // return ValidButtonModel(
                //   isValid: false,
                //   errorStr:
                //       "Transfer money type index $moneyIndex money list index $moneyListIndex start value ${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].startValue.text} must be between limit value first ${transferTemp.moneyTypeList[moneyIndex].limitValue.first.text} and limit value last ${transferTemp.moneyTypeList[moneyIndex].limitValue.last.text}.",
                // );
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.compareNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "Table index", subtitle: moneyListIndex.toString()),
                    TitleAndSubtitleModel(
                      title: "start value",
                      subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].startValue.text,
                    ),
                    TitleAndSubtitleModel(
                      title: "maximum value",
                      subtitle: transferTemp.moneyTypeList[moneyIndex].limitValue.first.text,
                    ),
                    TitleAndSubtitleModel(
                      title: "maximum value",
                      subtitle: transferTemp.moneyTypeList[moneyIndex].limitValue.last.text,
                    ),
                  ],
                  error: "start value must be between limit value first and limit value last.",
                  detailList: [
                    TitleAndSubtitleModel(
                      title:
                          "${transferTemp.moneyTypeList[moneyIndex].limitValue.first.text} <= ${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].startValue.text} <= ${transferTemp.moneyTypeList[moneyIndex].limitValue.last.text}",
                      subtitle: "invalid compare",
                    ),
                  ],
                );
              }
              if (!(minAmountNumber <= endValueNumber && endValueNumber <= maxAmountNumber)) {
                // return false;
                // return ValidButtonModel(
                //   isValid: false,
                //   errorStr:
                //       "Transfer money type index $moneyIndex money list index $moneyListIndex end value ${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].endValue.text} must be between limit value first ${transferTemp.moneyTypeList[moneyIndex].limitValue.first.text} and limit value last ${transferTemp.moneyTypeList[moneyIndex].limitValue.last.text}.",
                // );
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.compareNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "Table index", subtitle: moneyListIndex.toString()),
                    TitleAndSubtitleModel(
                      title: "end value",
                      subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].endValue.text,
                    ),
                    TitleAndSubtitleModel(
                      title: "maximum value",
                      subtitle: transferTemp.moneyTypeList[moneyIndex].limitValue.first.text,
                    ),
                    TitleAndSubtitleModel(
                      title: "maximum value",
                      subtitle: transferTemp.moneyTypeList[moneyIndex].limitValue.last.text,
                    ),
                  ],
                  error: "end value must be between limit value first and limit value last.",
                  detailList: [
                    TitleAndSubtitleModel(
                      title:
                          "${transferTemp.moneyTypeList[moneyIndex].limitValue.first.text} <= ${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].endValue.text} <= ${transferTemp.moneyTypeList[moneyIndex].limitValue.last.text}",
                      subtitle: "invalid compare",
                    ),
                  ],
                );
              }
              final double feeNumber = textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].fee)!;
              final double minFeeNumber =
                  textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.first)!;
              final double maxFeeNumber =
                  textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.last)!;
              if (!(minFeeNumber <= feeNumber && feeNumber <= maxFeeNumber)) {
                // return false;
                // return ValidButtonModel(
                //   isValid: false,
                //   errorStr:
                //       "Transfer money type index $moneyIndex money list index $moneyListIndex fee ${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].fee.text} must be between limit fee first ${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.first.text} and limit fee last ${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.last.text}.",
                // );
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.compareNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                    TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType!),
                    TitleAndSubtitleModel(title: "Table index", subtitle: moneyListIndex.toString()),
                    TitleAndSubtitleModel(
                      title: "fee",
                      subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].fee.text,
                    ),
                    TitleAndSubtitleModel(
                      title: "minimum fee",
                      subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.first.text,
                    ),
                    TitleAndSubtitleModel(
                      title: "maximum fee",
                      subtitle: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.last.text,
                    ),
                  ],
                  error: "fee must be between limit fee first and limit fee last.",
                  detailList: [
                    TitleAndSubtitleModel(
                      title:
                          "${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.first.text} <= ${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].fee.text} <= ${transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.last.text}",
                      subtitle: "invalid compare",
                    ),
                  ],
                );
              }
            }
          }
          for (int moneyIndexInside = 0; moneyIndexInside < transferModelListGlobal.length; moneyIndexInside++) {
            final bool isNotSameCurrentEditingIndex = moneyIndexInside != transferIndex;
            if (isNotSameCurrentEditingIndex) {
              final bool isPartnerNameDuplicate = transferTemp.customerId == transferModelListGlobal[moneyIndexInside].customerId;
              if (isPartnerNameDuplicate) {
                // return false;
                // return ValidButtonModel(isValid: false, errorStr: "Transfer partner name cannot be duplicate.");
                final String customerName = (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text;

                return ValidButtonModel(
                  isValid: false,
                  errorType: ErrorTypeEnum.valueUnique,
                  errorLocationList: [
                    TitleAndSubtitleModel(title: "transfer name", subtitle: customerName),
                  ],
                  error: "partner name is same as previous save.",
                );
              }
            }
          }

          if (isCreateNewTransfer) {
            // return true;
            // return ValidButtonModel(isValid: true, errorStr: "");
            return ValidButtonModel(isValid: true);
          } else {
            final String? partnerName = transferModelListGlobal[transferIndex!].customerId;
            final String? partnerNameTemp = transferTemp.customerId;
            final bool isPartnerNameNotChange = partnerName != partnerNameTemp;
            if (isPartnerNameNotChange) {
              // return true;
              // return ValidButtonModel(isValid: true, errorStr: "");
              return ValidButtonModel(isValid: true);
            }
            final int moneyTypeListLength = transferModelListGlobal[transferIndex].moneyTypeList.length;
            final int moneyTypeListTempLength = transferTemp.moneyTypeList.length;
            final bool isMoneyTypeListLengthNotChange = moneyTypeListLength != moneyTypeListTempLength;
            if (isMoneyTypeListLengthNotChange) {
              // return true;
              // return ValidButtonModel(isValid: true, errorStr: "");
              return ValidButtonModel(isValid: true);
            }
            for (int moneyIndex = 0; moneyIndex < transferTemp.moneyTypeList.length; moneyIndex++) {
              final String moneyType = transferModelListGlobal[transferIndex].moneyTypeList[moneyIndex].moneyType!;
              final String moneyTypeTemp = transferTemp.moneyTypeList[moneyIndex].moneyType!;
              final bool isMoneyTypeNotChange = moneyType != moneyTypeTemp;
              if (isMoneyTypeNotChange) {
                // return true;
                // return ValidButtonModel(isValid: true, errorStr: "");
                return ValidButtonModel(isValid: true);
              }
              final double? percentageTemp = textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].shareFeePercentage);
              final double? percentage =
                  textEditingControllerToDouble(controller: transferModelListGlobal[transferIndex].moneyTypeList[moneyIndex].shareFeePercentage);
              final bool isPercentageNotSameValue = (percentageTemp != percentage);
              if (isPercentageNotSameValue) {
                // return true;
                // return ValidButtonModel(isValid: true, errorStr: "");
                return ValidButtonModel(isValid: true);
              }

              final String moneyTypeSub = transferModelListGlobal[transferIndex].moneyTypeList[moneyIndex].moneyType!;
              final String moneyTypeSubTemp = transferTemp.moneyTypeList[moneyIndex].moneyType!;
              final bool isMoneyTypeSubNotChange = moneyTypeSub != moneyTypeSubTemp;
              if (isMoneyTypeSubNotChange) {
                // return true;
                // return ValidButtonModel(isValid: true, errorStr: "");
                return ValidButtonModel(isValid: true);
              }

              final int moneyListLength = transferModelListGlobal[transferIndex].moneyTypeList[moneyIndex].moneyList.length;
              final int moneyListTempLength = transferTemp.moneyTypeList[moneyIndex].moneyList.length;
              final bool isMoneyListLengthNotChange = moneyListLength != moneyListTempLength;
              if (isMoneyListLengthNotChange) {
                // return true;
                // return ValidButtonModel(isValid: true, errorStr: "");
                return ValidButtonModel(isValid: true);
              }

              final double? limitValueFirst =
                  textEditingControllerToDouble(controller: transferModelListGlobal[transferIndex].moneyTypeList[moneyIndex].limitValue.first);
              final double? limitValueFirstTemp = textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].limitValue.first);
              final bool isLimitValueFirstNotChange = limitValueFirst != limitValueFirstTemp;
              if (isLimitValueFirstNotChange) {
                // return true;
                // return ValidButtonModel(isValid: true, errorStr: "");
                return ValidButtonModel(isValid: true);
              }

              final double? limitValueLast =
                  textEditingControllerToDouble(controller: transferModelListGlobal[transferIndex].moneyTypeList[moneyIndex].limitValue.last);
              final double? limitValueLastTemp = textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].limitValue.last);
              final bool isLimitValueLastNotChange = limitValueLast != limitValueLastTemp;
              if (isLimitValueLastNotChange) {
                // return true;
                // return ValidButtonModel(isValid: true, errorStr: "");
                return ValidButtonModel(isValid: true);
              }

              for (int moneyListIndex = 0; moneyListIndex < transferTemp.moneyTypeList[moneyIndex].moneyList.length; moneyListIndex++) {
                final bool isTransfer = transferModelListGlobal[transferIndex].moneyTypeList[moneyIndex].moneyList[moneyListIndex].isTransfer;
                final bool isTransferTemp = transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].isTransfer;
                final bool isTransferNotChange = isTransfer != isTransferTemp;
                if (isTransferNotChange) {
                  // return true;
                  // return ValidButtonModel(isValid: true, errorStr: "");
                  return ValidButtonModel(isValid: true);
                }
                final double? startValue = textEditingControllerToDouble(
                    controller: transferModelListGlobal[transferIndex].moneyTypeList[moneyIndex].moneyList[moneyListIndex].startValue);
                final double? startValueTemp =
                    textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].startValue);
                final bool isStartValueNotChange = startValue != startValueTemp;
                if (isStartValueNotChange) {
                  // return true;
                  // return ValidButtonModel(isValid: true, errorStr: "");
                  return ValidButtonModel(isValid: true);
                }
                final double? endValue = textEditingControllerToDouble(
                    controller: transferModelListGlobal[transferIndex].moneyTypeList[moneyIndex].moneyList[moneyListIndex].endValue);
                final double? endValueTemp =
                    textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].endValue);
                final bool isEndValueNotChange = endValue != endValueTemp;
                if (isEndValueNotChange) {
                  // return true;
                  // return ValidButtonModel(isValid: true, errorStr: "");
                  return ValidButtonModel(isValid: true);
                }
                final double? fee =
                    textEditingControllerToDouble(controller: transferModelListGlobal[transferIndex].moneyTypeList[moneyIndex].moneyList[moneyListIndex].fee);
                final double? feeTemp = textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].fee);
                final bool isFeeNotChange = fee != feeTemp;
                if (isFeeNotChange) {
                  // return true;
                  // return ValidButtonModel(isValid: true, errorStr: "");
                  return ValidButtonModel(isValid: true);
                }
                final double? limitValueFirst = textEditingControllerToDouble(
                    controller: transferModelListGlobal[transferIndex].moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.first);
                final double? limitValueFirstTemp =
                    textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.first);
                final bool isLimitValueFirstNotChange = limitValueFirst != limitValueFirstTemp;
                if (isLimitValueFirstNotChange) {
                  // return true;
                  // return ValidButtonModel(isValid: true, errorStr: "");
                  return ValidButtonModel(isValid: true);
                }
                final double? limitValueLast = textEditingControllerToDouble(
                    controller: transferModelListGlobal[transferIndex].moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.last);
                final double? limitValueLastTemp =
                    textEditingControllerToDouble(controller: transferTemp.moneyTypeList[moneyIndex].moneyList[moneyListIndex].limitFee.last);
                final bool isLimitValueLastNotChange = limitValueLast != limitValueLastTemp;
                if (isLimitValueLastNotChange) {
                  // return true;
                  // return ValidButtonModel(isValid: true, errorStr: "");
                  return ValidButtonModel(isValid: true);
                }
              }
            }
            //nothing change so return false
            // return false;
            // return ValidButtonModel(isValid: false, errorStr: "Nothing change.");
            return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.nothingChange);
          }
        }

        Function? deleteFunctionOrNull() {
          if (isCreateNewTransfer) {
            return null;
          } else {
            void deleteFunctionOnTap() {
              void okFunction() {
                void callback() {
                  adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.transfer);
                  setState(() {});
                }

                //close the rate dialog
                closeDialogGlobal(context: context);

                deleteTransferGlobal(
                    callBack: callback, context: context, transferId: transferTemp.id!); //delete the existing card in database and local storage
              }

              void cancelFunction() {}
              confirmationDialogGlobal(
                context: context,
                okFunction: okFunction,
                cancelFunction: cancelFunction,
                titleStr: "$deleteGlobal ${customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text}",
                subtitleStr: deleteConfirmGlobal,
              );
            }

            return deleteFunctionOnTap;
          }
        }

        ValidButtonModel validDeleteFunctionOnTap() {
          // return ValidButtonModel(isValid: (transferTemp.deletedDate == null), errorStr: "This transfer has been deleted.");
          return ValidButtonModel(
            isValid: (transferTemp.deletedDate == null),
            errorType: ErrorTypeEnum.deleted,
            errorLocationList: [
              TitleAndSubtitleModel(
                title: "transfer name",
                subtitle: (transferTemp.customerId == null)
                    ? profileModelAdminGlobal!.name.text
                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text,
              ),
            ],
            error: "This transfer has been deleted.",
          );
        }

        void restoreFunctionOnTap() {
          void okFunction() {
            void callBack() {
              adminStopEditingSettingSocketIO(editSettingTypeEnum: EditSettingTypeEnum.transfer);
              setState(() {});
              closeDialogGlobal(context: context);
            }

            restoreTransferGlobal(callBack: callBack, context: context, transferId: transferTemp.id!);
          }

          void cancelFunction() {}
          confirmationDialogGlobal(
            context: context,
            okFunction: okFunction,
            cancelFunction: cancelFunction,
            titleStr: "$restoreGlobal ${customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text}",
            subtitleStr: restoreConfirmGlobal,
          );
        }

        int selectedCustomerIndex = (transferTemp.customerId == null) ? -1 : getIndexByCustomerId(customerId: transferTemp.customerId!);
        int customerLengthIncrease = queryLimitNumberGlobal;
        bool isShowSeeMoreWidget = true;
        if (customerLengthIncrease > customerModelListGlobal.length) {
          isShowSeeMoreWidget = false;
          customerLengthIncrease = customerModelListGlobal.length;
        }
        Widget editTransferDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          Widget partnerNameTextFieldAndLanguageWidget() {
            Widget moneyTypeDropDownWidget() {
              // void onTapFunction() {}
              // void onChangedFunction() {}

              ValidButtonModel validSaveButtonFunction() {
                // return ((selectedCustomerIndex != -1) && (customerModelListGlobal[selectedCustomerIndex].id != transferTemp.customerId));
                if (selectedCustomerIndex == -1) {
                  // return ValidButtonModel(isValid: false, errorStr: "Please select a customer.");
                  return ValidButtonModel(
                    isValid: false,
                    errorType: ErrorTypeEnum.valueOfNumber,
                    error: "Please select a customer.",
                  );
                }
                // return ValidButtonModel(
                //   isValid: (customerModelListGlobal[selectedCustomerIndex].id != transferTemp.customerId),
                //   errorStr: "Please select different customer.",
                // );
                return ValidButtonModel(
                  isValid: (customerModelListGlobal[selectedCustomerIndex].id != transferTemp.customerId),
                  errorType: ErrorTypeEnum.valueOfNumber,
                  errorLocationList: [
                    TitleAndSubtitleModel(
                      title: "current customer",
                      subtitle: (transferTemp.customerId == null)
                          ? profileModelAdminGlobal!.name.text
                          : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text,
                    ),
                    TitleAndSubtitleModel(
                      title: "new customer",
                      subtitle: customerModelListGlobal[selectedCustomerIndex].name.text,
                    ),
                  ],
                  error: "Please select different customer.",
                );
              }

              void saveFunctionOnTap() {
                transferTemp.customerId = customerModelListGlobal[selectedCustomerIndex].id;
                closeDialogGlobal(context: context);
                setStateFromDialog(() {});
              }

              Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                Widget titleWidget() {
                  return Padding(
                    padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                    child: Text(customerNameStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
                  );
                }

                Widget customerWidget({required int customerIndex}) {
                  void onTapUnlessDisable() {
                    if (deleteDateOrNull == null) {
                      selectedCustomerIndex = customerIndex;
                      setStateFromDialog(() {});
                    }
                  }

                  Widget insideSizeBoxWidget() {
                    final String customerNameStr = customerModelListGlobal[customerIndex].name.text;
                    final String titleStr = customerModelListGlobal[customerIndex].informationList.first.title.text;
                    final String subtitleStr = customerModelListGlobal[customerIndex].informationList.first.subtitle.text;
                    return Row(
                      children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(customerNameStr, style: textStyleGlobal(level: Level.normal)),
                            Text("$titleStr: $subtitleStr", style: textStyleGlobal(level: Level.mini)),
                          ]),
                        ),
                      ],
                    );
                  }

                  return CustomButtonGlobal(
                    isDisable: (selectedCustomerIndex == customerIndex),
                    insideSizeBoxWidget: insideSizeBoxWidget(),
                    onTapUnlessDisable: onTapUnlessDisable,
                  );
                }

                void topFunction() {}
                void bottomFunction() {
                  customerLengthIncrease = customerLengthIncrease + queryLimitNumberGlobal;
                  if (customerLengthIncrease > customerModelListGlobal.length) {
                    isShowSeeMoreWidget = false;
                    customerLengthIncrease = customerModelListGlobal.length;
                  }
                }

                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleWidget(),
                  Expanded(
                    child: wrapScrollDetectWidget(
                      inWrapWidgetList: [
                        for (int customerIndex = 0; customerIndex < customerLengthIncrease; customerIndex++) customerWidget(customerIndex: customerIndex)
                      ],
                      topFunction: topFunction,
                      bottomFunction: bottomFunction,
                      isShowSeeMoreWidget: isShowSeeMoreWidget,
                    ),
                  ),
                ]);
              }

              void cancelFunctionOnTap() {
                void okFunction() {
                  if (transferTemp.customerId == null) {
                    selectedCustomerIndex = -1;
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
              }

              void onTapUnlessDisable() {
                actionDialogSetStateGlobal(
                  dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.05,
                  dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.05,
                  cancelFunctionOnTap: cancelFunctionOnTap,
                  context: context,
                  validSaveButtonFunction: () => validSaveButtonFunction(),
                  saveFunctionOnTap: (deleteDateOrNull == null) ? saveFunctionOnTap : null,
                  contentFunctionReturnWidget: contentFunctionReturnWidget,
                );
              }

              Widget insideSizeBoxWidget() {
                if (transferTemp.customerId != null) {
                  final int customerIndex = getIndexByCustomerId(customerId: transferTemp.customerId!);
                  final String customerNameStr = customerModelListGlobal[customerIndex].name.text;
                  final String titleStr = customerModelListGlobal[customerIndex].informationList.first.title.text;
                  final String subtitleStr = customerModelListGlobal[customerIndex].informationList.first.subtitle.text;
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(customerNameStr, style: textStyleGlobal(level: Level.normal)),
                    Text("$titleStr: $subtitleStr", style: textStyleGlobal(level: Level.mini)),
                  ]);
                } else {
                  return Text("[Click To Select Customer]", style: textStyleGlobal(level: Level.normal));
                }
              }

              return (transferIndex == 0)
                  ? Padding(
                      padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                      child: Text(profileModelAdminGlobal!.name.text, style: textStyleGlobal(level: Level.normal)),
                    )
                  : CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
              // ? textFieldGlobal(
              //     isEnabled: false,
              //     textFieldDataType: TextFieldDataType.str,
              //     controller: profileModelAdminGlobal!.name,
              //     onTapFromOutsiderFunction: () {},
              //     onChangeFromOutsiderFunction: () {},
              //     labelText: customerNameStrGlobal,
              //     level: Level.normal,
              //   )
              // : customDropdown(
              //     level: Level.normal,
              //     labelStr: customerNameStrGlobal,
              //     onTapFunction: onTapFunction,
              //     onChangedFunction: onChangedFunction,
              //     selectedStr: (transferTemp.customerId == null)
              //         ? null
              //         : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text,
              //     menuItemStrList: getCustomerNameListOnly(),
              //   );
            }

            Widget textFieldCompanyNameWidget() {
              return SizedBox(width: nameTextFieldWidthGlobal, child: moneyTypeDropDownWidget());
            }

            Widget deleteDateScrollTextWidget() {
              return (deleteDateOrNull == null)
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)),
                      child: scrollText(
                        textStr: "$deleteAtStrGlobal ${formatFullDateToStr(date: deleteDateOrNull.add(const Duration(days: deleteAtDay)))}",
                        textStyle: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold, color: Colors.red),
                        alignment: Alignment.topCenter,
                      ),
                    );
            }

            return Row(children: [textFieldCompanyNameWidget(), deleteDateScrollTextWidget()]);
          }

          Widget paddingVerticalWidget() {
            Widget transferWidget() {
              Widget transferListFixSizeWidget() {
                final bool isMinWidth = (screenSizeFromDialog.width < minWithGlobal);
                Widget addButtonWidget() {
                  ValidButtonModel validateToAddMoreCategory() {
                    if (transferTemp.moneyTypeList.isNotEmpty) {
                      for (int moneyIndex = 0; moneyIndex < transferTemp.moneyTypeList.length; moneyIndex++) {
                        final bool isCategoryTextEmpty =
                            (transferTemp.moneyTypeList[moneyIndex].moneyType == "" || transferTemp.moneyTypeList[moneyIndex].moneyType == null);
                        if (isCategoryTextEmpty) {
                          // return false;
                          // return ValidButtonModel(isValid: false, errorStr: "Transfer money type index $moneyIndex cannot be empty.");
                          return ValidButtonModel(
                            isValid: false,
                            errorType: ErrorTypeEnum.valueOfString,
                            errorLocationList: [
                              TitleAndSubtitleModel(
                                title: "transfer name",
                                subtitle: (transferTemp.customerId == null)
                                    ? profileModelAdminGlobal!.name.text
                                    : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text,
                              ),
                              TitleAndSubtitleModel(title: "money type", subtitle: transferTemp.moneyTypeList[moneyIndex].moneyType.toString()),
                            ],
                            error: "transfer money type is empty.",
                          );
                        }
                      }
                    } else {
                      selectedMoneyTypeIndex = 0;
                    }
                    // return (deleteDateOrNull == null);
                    // return ValidButtonModel(
                    //     isValid: (deleteDateOrNull == null),
                    //     errorStr: "Transfer money type ($transferTemp.moneyTypeList[moneyIndex].moneyType) has been deleted.");
                    return ValidButtonModel(
                      isValid: (deleteDateOrNull == null),
                      errorType: ErrorTypeEnum.deleted,
                      errorLocationList: [
                        TitleAndSubtitleModel(
                          title: "transfer name",
                          subtitle: (transferTemp.customerId == null)
                              ? profileModelAdminGlobal!.name.text
                              : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text,
                        ),
                      ],
                      error: "Transfer has been deleted.",
                    );
                  }

                  void onTapFunction() {
                    MoneyList initTransferCategoryListModel = MoneyList(
                      endValue: TextEditingController(),
                      startValue: TextEditingController(),
                      fee: TextEditingController(),
                      limitFee: [TextEditingController(), TextEditingController()],
                    );
                    transferTemp.moneyTypeList.add(
                      MoneyTypeList(
                        shareFeePercentage: TextEditingController(),
                        moneyList: [initTransferCategoryListModel],
                        moneyType: null,
                        limitValue: [TextEditingController(), TextEditingController()],
                      ),
                    );
                    selectedMoneyTypeIndex = transferTemp.moneyTypeList.length - 1;
                    setStateFromDialog(() {});
                  }

                  Widget addButtonProvider() {
                    Widget maxAddButtonWidget() {
                      return addButtonOrContainerWidget(
                        context: context,
                        level: Level.mini,
                        onTapFunction: onTapFunction,
                        validModel: validateToAddMoreCategory(),
                        currentAddButtonQty: transferTemp.moneyTypeList.length,
                        maxAddButtonLimit: transferMoneyTypeAddButtonLimitGlobal,
                      );
                    }

                    Widget minAddButtonWidget() {
                      return buttonGlobal(
                        context: context,
                        level: Level.normal,
                        onTapUnlessDisableAndValid: onTapFunction,
                        validModel: validateToAddMoreCategory(),
                        icon: createIconGlobal,
                        colorSideBox: addButtonColorGlobal,
                      );
                    }

                    return isMinWidth ? minAddButtonWidget() : maxAddButtonWidget();
                  }

                  return addButtonProvider();
                }

                Widget paddingTopMoneyTypeButtonWidget({required String? category, required int categoryIndex}) {
                  Widget moneyTypeButtonWidget() {
                    final isTextStrNot = (category == null);
                    final String textOrEmptyStr = isTextStrNot ? emptyStrGlobal : category;
                    final bool isSelected = (categoryIndex == selectedMoneyTypeIndex);
                    void onTapUnlessDisableAndValid() {
                      selectedMoneyTypeIndex = categoryIndex;
                      setStateFromDialog(() {});
                    }

                    String? textProvider() {
                      return isMinWidth ? null : textOrEmptyStr;
                    }

                    MainAxisAlignment mainAxisAlignmentProvider() {
                      return isMinWidth ? MainAxisAlignment.center : MainAxisAlignment.start;
                    }

                    // DateTime? deleteCategoryDateOrNull = (selectedMoneyTypeIndex == -1) ? null : transferTemp.moneyTypeList[categoryIndex].deletedDate;
                    return buttonGlobal(
                      context: context,
                      mainAxisAlignment: mainAxisAlignmentProvider(),
                      level: Level.normal,
                      isDisable: isSelected,
                      onTapUnlessDisableAndValid: onTapUnlessDisableAndValid,
                      textStr: textProvider(),
                      icon: Icons.money,
                      colorSideBox: optionContainerColor,
                      colorTextAndIcon: optionTextAndIconColorGlobal,
                    );
                  }

                  return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini)), child: moneyTypeButtonWidget());
                }

                double moneyTypeLisWidthProvider() {
                  return isMinWidth ? categoryListMinWidthGlobal : categoryListMaxWidthGlobal;
                }

                return SizedBox(
                  width: moneyTypeLisWidthProvider(),
                  child: SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                      addButtonWidget(),
                      for (int moneyTypeIndex = 0; moneyTypeIndex < transferTemp.moneyTypeList.length; moneyTypeIndex++)
                        paddingTopMoneyTypeButtonWidget(category: transferTemp.moneyTypeList[moneyTypeIndex].moneyType, categoryIndex: moneyTypeIndex)
                    ]),
                  ),
                );
              }

              Widget transferDetailExpandedWidget() {
                // bool isMoneyTypeIsEmpty = ((selectedMoneyTypeIndex == -1) || transferTemp.moneyTypeList.isEmpty);
                Widget categoryDetailOrEmpty() {
                  Widget paddingColumnWidget() {
                    Widget columnWidget() {
                      Widget rowTextFieldAndDeleteButton() {
                        Widget paddingRightMoneyTypedWidget() {
                          // Widget textFieldWidget() {
                          //   void onTapFromOutsiderFunction() {}
                          //   return textFieldGlobal(
                          //     // isEnabled: ((deleteCategoryDateOrNull == null) && (deleteDateOrNull == null)),
                          //     onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                          //     textFieldWidth: cardCategoryTextFieldWidthGlobal,
                          //     controller: transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyType,
                          //     onChangeFromOutsiderFunction: () {
                          //       setStateFromDialog(() {});
                          //     },
                          //     labelText: categoryCardStrGlobal,
                          //     level: Level.normal,
                          //     textFieldDataType: TextFieldDataType.double,
                          //   );
                          // }

                          Widget moneyTypeDropDownWidget() {
                            void onTapFunction() {}
                            void onChangedFunction({required String value, required int index}) {
                              transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyType = value;
                              setStateFromDialog(() {});
                            }

                            return (deleteDateOrNull == null)
                                ? customDropdown(
                                    level: Level.normal,
                                    labelStr: moneyTypeStrGlobal,
                                    onTapFunction: onTapFunction,
                                    onChangedFunction: onChangedFunction,
                                    selectedStr: transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyType,
                                    menuItemStrList: moneyTypeOnlyList(
                                        isNotCheckDeleted: true, moneyTypeDefault: transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyType),
                                  )
                                : textFieldGlobal(
                                    isEnabled: false,
                                    textFieldDataType: TextFieldDataType.str,
                                    controller: TextEditingController(text: transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyType),
                                    onTapFromOutsiderFunction: () {},
                                    onChangeFromOutsiderFunction: () {},
                                    labelText: moneyTypeStrGlobal,
                                    level: Level.normal,
                                  );
                          }

                          return Padding(
                              padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
                              child: Container(width: nameTextFieldTextFieldWidthGlobal, child: moneyTypeDropDownWidget()));
                        }

                        Widget paddingRightTextFieldWidget() {
                          Widget textFieldWidget() {
                            void onTapFromOutsiderFunction() {}
                            if (transferIndex == 0) {
                              transferTemp.moneyTypeList[selectedMoneyTypeIndex].shareFeePercentage.text = "100";
                            }
                            return textFieldGlobal(
                              isEnabled: (deleteDateOrNull == null && transferIndex != 0),
                              onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                              textFieldWidth: nameTextFieldTextFieldWidthGlobal,
                              controller: transferTemp.moneyTypeList[selectedMoneyTypeIndex].shareFeePercentage,
                              onChangeFromOutsiderFunction: () {
                                setStateFromDialog(() {});
                              },
                              labelText: percentageStrGlobal,
                              level: Level.normal,
                              textFieldDataType: TextFieldDataType.double,
                            );
                          }

                          return Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)), child: textFieldWidget());
                        }

                        Widget deleteButtonWidget() {
                          void onTapFunction() {
                            transferTemp.moneyTypeList.removeAt(selectedMoneyTypeIndex);
                            selectedMoneyTypeIndex = -1;
                            setStateFromDialog(() {});
                          }

                          return deleteButtonOrContainerWidget(
                            context: context,
                            level: Level.normal,
                            onTapFunction: onTapFunction,
                            // validModel: ValidButtonModel(isValid: (deleteDateOrNull == null), errorStr: "This transfer has been deleted"),
                            validModel: ValidButtonModel(
                              isValid: (deleteDateOrNull == null),
                              errorType: ErrorTypeEnum.deleted,
                              errorLocationList: [
                                TitleAndSubtitleModel(
                                  title: "transfer name",
                                  subtitle: (transferTemp.customerId == null)
                                      ? profileModelAdminGlobal!.name.text
                                      : customerModelListGlobal[getIndexByCustomerId(customerId: transferTemp.customerId!)].name.text,
                                ),
                              ],
                              error: "Transfer has been deleted.",
                            ),
                          );
                        }

                        return Row(children: [paddingRightMoneyTypedWidget(), paddingRightTextFieldWidget(), deleteButtonWidget()]);
                      }

                      Widget limitPriceCardWidget() {
                        Widget limitWidget() {
                          Widget insideSizeBoxWidget() {
                            Widget moneyTypeTextWidget() {
                              return Text(
                                "$maximumStrGlobal and $minimumStrGlobal $amountTransferStrGlobal of ${transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyType}",
                                style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                              );
                            }

                            Widget textFieldWidget({required String contentStr, required TextEditingController controller}) {
                              void onTapFromOutsiderFunction() {}
                              return textFieldGlobal(
                                isEnabled: (deleteDateOrNull == null),
                                onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                                textFieldWidth: nameTextFieldTextFieldWidthGlobal,
                                controller: controller,
                                onChangeFromOutsiderFunction: () {
                                  setStateFromDialog(() {});
                                },
                                labelText: contentStr,
                                level: Level.normal,
                                textFieldDataType: TextFieldDataType.double,
                              );
                            }

                            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              moneyTypeTextWidget(),
                              Row(children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal), right: paddingSizeGlobal(level: Level.mini)),
                                    child: textFieldWidget(
                                        contentStr: minimumStrGlobal, controller: transferTemp.moneyTypeList[selectedMoneyTypeIndex].limitValue.first),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal), left: paddingSizeGlobal(level: Level.mini)),
                                    child: textFieldWidget(
                                        contentStr: maximumStrGlobal, controller: transferTemp.moneyTypeList[selectedMoneyTypeIndex].limitValue.last),
                                  ),
                                ),
                              ])
                            ]);
                          }

                          void onTapUnlessDisable() {}

                          return Padding(
                            padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini), right: paddingSizeGlobal(level: Level.mini)),
                            child: CustomButtonGlobal(
                                sizeBoxWidth: sizeBoxLimitWidthGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable),
                          );
                        }

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                            child: (transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyType == null) ? Container() : Row(children: [limitWidget()]),
                          ),
                        );
                      }

                      Widget paddingTopTableWidget() {
                        final List<TextEditingController> headerList = [
                          TextEditingController(text: startCardStrGlobal),
                          TextEditingController(text: endCardStrGlobal),
                          TextEditingController(text: feeStrGlobal),
                          TextEditingController(text: minimumStrGlobal),
                          TextEditingController(text: maximumStrGlobal),
                          TextEditingController(text: transferAdminStrGlobal),
                        ];
                        final List<int> expandedList = [1, 1, 1, 1, 1, 1];
                        final List<WidgetType> widgetTypeList = (deleteDateOrNull == null)
                            ? [
                                WidgetType.textFieldDouble,
                                WidgetType.textFieldDouble,
                                WidgetType.textFieldDouble,
                                WidgetType.textFieldDouble,
                                WidgetType.textFieldDouble,
                                WidgetType.dropDown
                              ]
                            : [WidgetType.text, WidgetType.text, WidgetType.text, WidgetType.text, WidgetType.text, WidgetType.text];

                        List<List<TextEditingController>> textFieldController2D = [];
                        List<List<List<String>>> menuItemStr3D = [];
                        List<List<bool>> isShowTextField2D = [];

                        void convertSellPriceCardModelIntoTable() {
                          for (int moneyTypeIndex = 0; moneyTypeIndex < transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyList.length; moneyTypeIndex++) {
                            List<TextEditingController> controller1D = [];
                            final TextEditingController startValue = transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyList[moneyTypeIndex].startValue;
                            controller1D.add(startValue);
                            final TextEditingController endValue = transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyList[moneyTypeIndex].endValue;
                            controller1D.add(endValue);
                            final TextEditingController fee = transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyList[moneyTypeIndex].fee;
                            controller1D.add(fee);
                            final TextEditingController limitFeeFirst =
                                transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyList[moneyTypeIndex].limitFee.first;
                            controller1D.add(limitFeeFirst);
                            final TextEditingController limitFeeLast =
                                transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyList[moneyTypeIndex].limitFee.last;
                            controller1D.add(limitFeeLast);
                            final TextEditingController transferOrReceive = TextEditingController(
                                text: transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyList[moneyTypeIndex].isTransfer
                                    ? transferAdminStrGlobal
                                    : receiveAdminStrGlobal);
                            controller1D.add(transferOrReceive);
                            textFieldController2D.add(controller1D);

                            final List<List<String>> menuItemStr2D = [
                              [],
                              [],
                              [],
                              [],
                              [],
                              [transferAdminStrGlobal, receiveAdminStrGlobal]
                            ];
                            menuItemStr3D.add(menuItemStr2D);

                            final List<bool> isShowTextFieldList = [false, false, false, false, false, false];
                            isShowTextField2D.add(isShowTextFieldList);
                          }
                        }

                        void convertTableIntoSellPriceCardModel({
                          required List<List<TextEditingController>> controller2D,
                          required List<List<bool>> isShowTextField2D,
                          required List<List<TextEditingController>> oldController2D,
                          required List<List<bool>> oldIsShowTextField2D,
                          required int horizontalIndex,
                          required int verticalIndex,
                          required ActiveLogTypeEnum activeLog,
                        }) {
                          transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyList = [];
                          for (int colIndex = 0; colIndex < controller2D.length; colIndex++) {
                            MoneyList moneyTypeListModel = MoneyList(
                              startValue: controller2D[colIndex][0],
                              endValue: controller2D[colIndex][1],
                              fee: controller2D[colIndex][2],
                              limitFee: [controller2D[colIndex][3], controller2D[colIndex][4]],
                              isTransfer: controller2D[colIndex][5].text != receiveAdminStrGlobal,
                            );
                            transferTemp.moneyTypeList[selectedMoneyTypeIndex].moneyList.add(moneyTypeListModel);
                          }

                          setStateFromDialog(() {});
                        }

                        convertSellPriceCardModelIntoTable();
                        return TableGlobalWidget(
                          isShowDeleteButton: (deleteDateOrNull == null),
                          expandedList: expandedList,
                          textFieldController2D: textFieldController2D,
                          headerList: headerList,
                          widgetTypeList: widgetTypeList,
                          menuItemStr3D: menuItemStr3D,
                          returnIsShowAndTextFieldController2DFunction: convertTableIntoSellPriceCardModel,
                          isShowTextField2D: isShowTextField2D,
                          isDisableAddMoreButton: (deleteDateOrNull != null),
                          currentAddButtonQty: textFieldController2D.length,
                          maxAddButtonLimit: transferFeeSetUpAddButtonLimitGlobal,
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [rowTextFieldAndDeleteButton(), limitPriceCardWidget(), Expanded(child: paddingTopTableWidget())],
                      );
                    }

                    return Padding(padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)), child: columnWidget());
                  }

                  final bool isHideCategoryDetail = (transferTemp.moneyTypeList.isEmpty || selectedMoneyTypeIndex == -1);
                  return isHideCategoryDetail ? Container() : paddingColumnWidget();
                }

                return Expanded(child: categoryDetailOrEmpty());
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [transferListFixSizeWidget(), transferDetailExpandedWidget()],
              );
            }

            return Expanded(child: Padding(padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.normal)), child: transferWidget()));
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [partnerNameTextFieldAndLanguageWidget(), paddingVerticalWidget()],
          );
        }

        bool isValidRestore() {
          for (int customerIndex = 0; customerIndex < customerModelListGlobal.length; customerIndex++) {
            // final DateTime? deleteDateOrNull = ;
            if (customerModelListGlobal[customerIndex].id == transferTemp.customerId && customerModelListGlobal[customerIndex].deletedDate != null) {
              return false;
            }
          }
          return true;
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.mini),
          dialogWidth: dialogSizeGlobal(level: Level.large),
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          validSaveButtonFunction: () => validSaveButtonFunction(),
          saveFunctionOnTap: (deleteDateOrNull == null) ? saveFunctionOnTap : null,
          contentFunctionReturnWidget: editTransferDialog,
          validDeleteFunctionOnTap: () => validDeleteFunctionOnTap(),
          deleteFunctionOnTap: ((deleteDateOrNull == null) && (transferIndex != 0)) ? deleteFunctionOrNull() : null,
          restoreFunctionOnTap: ((deleteDateOrNull == null) || !isValidRestore()) ? null : restoreFunctionOnTap,
        );
      }

      void addOnTapFunction() {
        askingForChangeDialogGlobal(
          context: context,
          allowFunction: () => setUpTransferDialog(isCreateNewTransfer: true, transferIndex: null),
          editSettingTypeEnum: EditSettingTypeEnum.transfer,
        );
      }

      List<Widget> inWrapWidgetList() {
        Widget transferButtonWidget({required int transferIndex}) {
          Widget setWidthSizeBox() {
            Widget insideSizeBoxWidget() {
              Widget paddingAndColumnWidget() {
                Widget companyNameAndCategoryListWidget() {
                  final DateTime? deleteDateOrNull = transferModelListGlobal[transferIndex].deletedDate;
                  final String? customerId = transferModelListGlobal[transferIndex].customerId;
                  final String partnerName = (customerId == null)
                      ? profileModelAdminGlobal!.name.text
                      : customerModelListGlobal[getIndexByCustomerId(customerId: customerId)].name.text;
                  Widget companyNameTextWidget() {
                    return Text(
                      partnerName,
                      style: textStyleGlobal(
                          level: Level.large, fontWeight: FontWeight.bold, color: (deleteDateOrNull == null) ? defaultTextColorGlobal : deleteTextColorGlobal),
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [companyNameTextWidget(), deleteDateScrollTextWidget()],
                  );
                }

                return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.normal)), child: companyNameAndCategoryListWidget());
              }

              return paddingAndColumnWidget();
            }

            void onTapUnlessDisable() {
              askingForChangeDialogGlobal(
                context: context,
                allowFunction: () => setUpTransferDialog(isCreateNewTransfer: false, transferIndex: transferIndex),
                editSettingTypeEnum: EditSettingTypeEnum.transfer,
              );
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

        return [
          for (int transferIndex = 0; transferIndex < transferModelListGlobal.length; transferIndex++) transferButtonWidget(transferIndex: transferIndex)
        ];
      }

      Widget bodyTemplateSideMenu() {
        return BodyTemplateSideMenu(
          addOnTapFunction: addOnTapFunction,
          inWrapWidgetList: inWrapWidgetList(),
          title: widget.title,
          currentAddButtonQty: transferModelListGlobal.length,
          maxAddButtonLimit: transferAddButtonLimitGlobal,
        );
      }

      // return _isLoadingOnInitCard ? Container() : bodyTemplateSideMenu();
      return bodyTemplateSideMenu();
    }

    return loadingOrBody();
  }
}
