import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/transfer_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';

int getIndexByCustomerId({required String customerId}) {
  for (int customerIndex = 0; customerIndex < customerModelListGlobal.length; customerIndex++) {
    final bool isMatchCustomerId = (customerModelListGlobal[customerIndex].id == customerId);
    if (isMatchCustomerId) {
      return customerIndex;
    }
  }
  return -1;
}

int getIndexByCustomerModelWithoutTransferListGlobalId({required String customerId}) {
  for (int customerIndex = 0; customerIndex < customerModelWithoutTransferListGlobal.length; customerIndex++) {
    final bool isMatchCustomerId = (customerModelWithoutTransferListGlobal[customerIndex].id == customerId);
    if (isMatchCustomerId) {
      return customerIndex;
    }
  }
  return -1;
}

List<String> getCustomerNameListOnly() {
  List<String> customerNameList = [];
  for (int customerIndex = 0; customerIndex < customerModelListGlobal.length; customerIndex++) {
    customerNameList.add(customerModelListGlobal[customerIndex].name.text);
  }
  return customerNameList;
}

void createCustomerWithoutTransferListOnly() {
  customerModelWithoutTransferListGlobal = [];
  if (transferModelListGlobal.length == 1) {
    for (int customerIndex = 0; customerIndex < customerModelListGlobal.length; customerIndex++) {
      customerModelWithoutTransferListGlobal.add(customerModelListGlobal[customerIndex]);
    }
  } else {
    for (int customerIndex = 0; customerIndex < customerModelListGlobal.length; customerIndex++) {
      bool isExisted = false;
      for (int transferIndex = 0; transferIndex < transferModelListGlobal.length; transferIndex++) {
        if (customerModelListGlobal[customerIndex].id == transferModelListGlobal[transferIndex].customerId) {
          isExisted = true;
          break;
        }
      }
      if (!isExisted) {
        customerModelWithoutTransferListGlobal.add(customerModelListGlobal[customerIndex]);
      }
    }
  }
  for (int customerIndex = 0; customerIndex < customerModelWithoutTransferListGlobal.length; customerIndex++) {}
}

List<String> getMoneyTypeTransferListOnly({required String? partnerId}) {
  final int transferIndex = (partnerId == null) ? 0 : transferModelListGlobal.indexWhere((element) => (element.customerId == partnerId));
  TransferModel transferModel = transferModelListGlobal[transferIndex];
  List<String> moneyList = [];
  for (int moneyIndex = 0; moneyIndex < transferModel.moneyTypeList.length; moneyIndex++) {
    moneyList.add(transferModel.moneyTypeList[moneyIndex].moneyType!);
  }
  return moneyList;
}

ValidButtonModel checkLimitAmountAndFeeTransfer({
  required String moneyType,
  required double amount,
  required double fee,
  required String? partnerId,
  required String name,
}) {
  // List<double> limitAmountList = [];
  final int transferIndex = (partnerId == null) ? 0 : transferModelListGlobal.indexWhere((element) => (element.customerId == partnerId));
  TransferModel transferModel = transferModelListGlobal[transferIndex];
  final int moneyIndex = transferModel.moneyTypeList.indexWhere((element) => (element.moneyType == moneyType));
  MoneyTypeList moneyTypeList = transferModel.moneyTypeList[moneyIndex];
  final double amountLimitFirstNumber = textEditingControllerToDouble(controller: moneyTypeList.limitValue.first)!;
  final double amountLimitLastNumber = textEditingControllerToDouble(controller: moneyTypeList.limitValue.last)!;
  if (!(amountLimitFirstNumber <= amount && amount <= amountLimitLastNumber)) {
    // return false;

    ValidButtonModel(
      isValid: false,
      errorType: ErrorTypeEnum.compareNumber,
      error: "amount is not between $amountLimitFirstNumber and $amountLimitLastNumber.",
      errorLocationList: [
        TitleAndSubtitleModel(title: "partner name", subtitle: name),
        TitleAndSubtitleModel(title: "amount", subtitle: amount.toString()),
      ],
      detailList: [TitleAndSubtitleModel(title: "$amountLimitFirstNumber <= $amount <= $amountLimitLastNumber", subtitle: "invalid compare")],
    );
  }

  List<int> startEndList = [];
  for (int moneyIndex = 0; moneyIndex < moneyTypeList.moneyList.length; moneyIndex++) {
    final double amountStartNumber = textEditingControllerToDouble(controller: moneyTypeList.moneyList[moneyIndex].startValue)!;
    final double amountEndNumber = textEditingControllerToDouble(controller: moneyTypeList.moneyList[moneyIndex].endValue)!;
    if (amountStartNumber <= amount && amount <= amountEndNumber) {
      startEndList.add(moneyIndex);
    }
  }
  if (startEndList.isEmpty) {
    // return false;
    ValidButtonModel(
      isValid: false,
      errorType: ErrorTypeEnum.compareNumber,
      error: "amount is not between $amountLimitFirstNumber and $amountLimitLastNumber.",
      errorLocationList: [
        TitleAndSubtitleModel(title: "partner name", subtitle: name),
        TitleAndSubtitleModel(title: "amount", subtitle: amount.toString()),
      ],
      detailList: [TitleAndSubtitleModel(title: "$amountLimitFirstNumber <= $amount <= $amountLimitLastNumber", subtitle: "invalid compare")],
    );
  }
  bool isFeeIn = false;
  for (int startEndIndex = 0; startEndIndex < startEndList.length; startEndIndex++) {
    final double feeLimitFirstNumber = textEditingControllerToDouble(controller: moneyTypeList.moneyList[startEndList[startEndIndex]].limitFee.first)!;
    final double feeLimitLastNumber = textEditingControllerToDouble(controller: moneyTypeList.moneyList[startEndList[startEndIndex]].limitFee.last)!;
    if (feeLimitFirstNumber <= fee && fee <= feeLimitLastNumber) {
      isFeeIn = true;
      break;
    }
  }
  // return isFeeIn;
  // if () {
  return ValidButtonModel(
    isValid: isFeeIn,
    error: "fee is invalid.",
    errorLocationList: [
      TitleAndSubtitleModel(title: "partner name", subtitle: name),
      TitleAndSubtitleModel(title: "fee", subtitle: fee.toString()),
    ],
  );
}

List<String> getFeeTransferListOnly({required String moneyType, required double amount, required String? partnerId, required bool isTransfer}) {
  List<String> feeList = [];
  final int transferIndex = (partnerId == null) ? 0 : transferModelListGlobal.indexWhere((element) => (element.customerId == partnerId));
  TransferModel transferModel = transferModelListGlobal[transferIndex];
  final int moneyTypeIndex = transferModel.moneyTypeList.indexWhere((element) => (element.moneyType == moneyType));
  MoneyTypeList moneyTypeList = transferModel.moneyTypeList[moneyTypeIndex];
  for (int moneyIndex = 0; moneyIndex < moneyTypeList.moneyList.length; moneyIndex++) {
    final double amountStartNumber = textEditingControllerToDouble(controller: moneyTypeList.moneyList[moneyIndex].startValue)!;
    final double amountEndNumber = textEditingControllerToDouble(controller: moneyTypeList.moneyList[moneyIndex].endValue)!;
    if (amountStartNumber <= amount && amount <= amountEndNumber && moneyTypeList.moneyList[moneyIndex].isTransfer == isTransfer) {
      bool isExisted = false;
      for (int feeIndex = 0; feeIndex < feeList.length; feeIndex++) {
        if (feeList[feeIndex] == moneyTypeList.moneyList[moneyIndex].fee.text) {
          isExisted = true;
          break;
        }
      }
      if (!isExisted) {
        final bool isNotDuplicate = feeList.indexWhere((element) => (element == moneyTypeList.moneyList[moneyIndex].fee.text)) == -1;
        if (isNotDuplicate) {
          feeList.add(moneyTypeList.moneyList[moneyIndex].fee.text);
        }
      }
    }
  }

  // feeList.sort((a, b) => b.compareTo(a));
  return feeList;
}

double getFeePercentageTransferListOnly({required String moneyType, required String? partnerId}) {
  final int transferIndex = (partnerId == null) ? 0 : transferModelListGlobal.indexWhere((element) => (element.customerId == partnerId));
  TransferModel transferModel = transferModelListGlobal[transferIndex];
  final int moneyTypeIndex = transferModel.moneyTypeList.indexWhere((element) => (element.moneyType == moneyType));
  MoneyTypeList moneyTypeList = transferModel.moneyTypeList[moneyTypeIndex];
  return textEditingControllerToDouble(controller: moneyTypeList.shareFeePercentage)!;
}
