// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/model/employee_model/salary_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<ProfileEmployeeModel> profileModelListEmployeeFromJson({required dynamic str}) =>
    List<ProfileEmployeeModel>.from(json.decode(json.encode(str)).map((x) => ProfileEmployeeModel.fromJson(x)));

ProfileEmployeeModel profileModelEmployeeFromJson({required dynamic str}) => ProfileEmployeeModel.fromJson(json.decode(json.encode(str)));

class ProfileEmployeeModel {
  ProfileEmployeeModel({
    this.id,
    required this.name,
    // this.language = "USD",
    required this.bio,
    this.supId,
    required this.password,
    required this.displayBusinessOptionModel,
    required this.salaryCalculationModel,
    required this.salaryList,
    // this.firstDate,
    this.deletedDate,
  });
  DateTime? deletedDate;
  SalaryCalculation salaryCalculationModel;
  String? id; //const value
  DateTime? firstDate;
  TextEditingController name;
  TextEditingController bio;
  String? supId; //const value
  TextEditingController password;
  DisplayBusinessOptionProfileEmployeeModel displayBusinessOptionModel;
  // List<SubSalaryModel> salaryList;
  List<SalaryMergeByMonthModel> salaryList;

  factory ProfileEmployeeModel.fromJson(Map<String, dynamic> json_) {
    return ProfileEmployeeModel(
      name: TextEditingController(text: json_["name"]),
      bio: TextEditingController(text: json_["bio"]),
      supId: json_["sup_id"],
      password: TextEditingController(text: json_["password"]),
      displayBusinessOptionModel: DisplayBusinessOptionProfileEmployeeModel.fromJson(json_["display_business_option"]),
      salaryCalculationModel: (json_["salary_calculation"] == null)
          ? SalaryCalculation(
              earningForHour: TextEditingController(),
              startDate: defaultDate(hour: 7, minute: 30, second: 0),
              endDate: defaultDate(hour: 17, minute: 30, second: 0),
              maxPayAmount: TextEditingController(),
              earningForInvoice: SalaryCalculationEarningForInvoice(payAmount: TextEditingController(), combineMoneyInUsed: []),
              earningForMoneyInUsed: SalaryCalculationEarningForMoneyInUsed(payAmount: TextEditingController(), moneyList: []),
              salaryAdvanceList: [],
            )
          : SalaryCalculation.fromJson(json_["salary_calculation"]),
      id: json_["_id"],
      deletedDate: (json_["deleted_date"] == null) ? null : DateTime.parse(json_["deleted_date"]),
      salaryList: (json_["salary_list"] == null) ? [] : salaryMergeByMonthModelFromJson(str: json_["salary_list"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name.text,
      "_id": id,
      "bio": bio.text,
      "sup_id": supId,
      "password": password.text,
      "display_business_option": displayBusinessOptionModel.toJson(),
      "salary_calculation": salaryCalculationModel.toJson(),
      "deleted_date": (deletedDate == null) ? null : deletedDate!.toIso8601String(),
      // "salary_list": salaryMergeByMonthModelToJson(salaryList),
    };
  }

  Map<String, dynamic> noCostValueToJson() => {
        "name": name.text,
        // "language": language,
        // "_id": id,
        "bio": bio.text,
        // "sup_id": supId,
        "password": password.text,
        "display_business_option": displayBusinessOptionModel.toJson(),
        "salary_calculation": salaryCalculationModel.toJson(),
        "deleted_date": (deletedDate == null) ? null : deletedDate!.toIso8601String(),
        // "salary_list": salaryMergeByMonthModelToJson(salaryList),
      };
}

class ExchangeSetting {
  ExchangeSetting({
    this.exchangeOption = false,
    this.exchangeCount = 0,
    this.exchangePercentage = 0,
  });

  bool exchangeOption;
  int exchangeCount;
  double exchangePercentage;

  factory ExchangeSetting.fromJson(Map<String, dynamic> json) {
    return ExchangeSetting(
      exchangeOption: json["exchange_option"],
      exchangeCount: json["exchange_count"] ?? 0,
      exchangePercentage: json["exchange_percentage_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "exchange_option": exchangeOption,
        "exchange_count": exchangeCount,
      };
}

class SellCardSetting {
  SellCardSetting({
    this.sellCardOption = false,
    this.sellCardCount = 0,
    this.sellCardPercentage = 0,
  });

  bool sellCardOption;
  int sellCardCount;
  double sellCardPercentage;

  factory SellCardSetting.fromJson(Map<String, dynamic> json) {
    return SellCardSetting(
      sellCardOption: json["sell_card_option"],
      sellCardCount: json["sell_card_count"] ?? 0,
      sellCardPercentage: json["sell_card_percentage_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "sell_card_option": sellCardOption,
        "sell_card_count": sellCardCount,
      };
}

class OutsiderBorrowOrLendingSetting {
  OutsiderBorrowOrLendingSetting({
    this.outsiderBorrowOrLendingOption = false,
    this.outsiderBorrowOrLendingCount = 0,
    this.outsiderBorrowOrLendingPercentage = 0,
  });

  bool outsiderBorrowOrLendingOption;
  int outsiderBorrowOrLendingCount;
  double outsiderBorrowOrLendingPercentage;

  factory OutsiderBorrowOrLendingSetting.fromJson(Map<String, dynamic> json) {
    return OutsiderBorrowOrLendingSetting(
      outsiderBorrowOrLendingOption: json["outsider_borrowing_or_lending_option"],
      outsiderBorrowOrLendingCount: json["outsider_borrowing_or_lending_count"] ?? 0,
      outsiderBorrowOrLendingPercentage: json["outsider_borrowing_or_lending_percentage_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "outsider_borrowing_or_lending_option": outsiderBorrowOrLendingOption,
        "outsider_borrowing_or_lending_count": outsiderBorrowOrLendingCount,
      };
}

class GiveMoneyToMatSetting {
  GiveMoneyToMatSetting({
    this.giveMoneyToMatOption = false,
    this.giveMoneyToMatCount = 0,
    this.giveMoneyToMatPercentage = 0,
  });

  bool giveMoneyToMatOption;
  int giveMoneyToMatCount;
  double giveMoneyToMatPercentage;

  factory GiveMoneyToMatSetting.fromJson(Map<String, dynamic> json) {
    return GiveMoneyToMatSetting(
      giveMoneyToMatOption: json["give_money_to_mat_option"],
      giveMoneyToMatCount: json["give_money_to_mat_count"] ?? 0,
      giveMoneyToMatPercentage: json["give_money_to_mat_percentage_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "give_money_to_mat_option": giveMoneyToMatOption,
        "give_money_to_mat_count": giveMoneyToMatCount,
      };
}

class GiveCardToMatSetting {
  GiveCardToMatSetting({
    this.giveCardToMatOption = false,
    this.giveCardToMatCount = 0,
    this.giveCardToMatPercentage = 0,
  });

  bool giveCardToMatOption;
  int giveCardToMatCount;
  double giveCardToMatPercentage;

  factory GiveCardToMatSetting.fromJson(Map<String, dynamic> json) {
    return GiveCardToMatSetting(
      giveCardToMatOption: json["give_card_to_mat_option"],
      giveCardToMatCount: json["give_card_to_mat_count"] ?? 0,
      giveCardToMatPercentage: json["give_card_to_mat_percentage_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "give_card_to_mat_option": giveCardToMatOption,
        "give_card_to_mat_count": giveCardToMatCount,
      };
}

class RateSetting {
  RateSetting({
    this.rateOption = false,
  });

  bool rateOption;

  factory RateSetting.fromJson(Map<String, dynamic> json) {
    return RateSetting(
      rateOption: json["rate_option"],
    );
  }

  Map<String, dynamic> toJson() => {
        "rate_option": rateOption,
      };
}

class AddCardStockSetting {
  AddCardStockSetting({
    this.addCardStockOption = false,
    this.addCardStockCount = 0,
    this.addCardStockPercentage = 0,
  });

  bool addCardStockOption;
  int addCardStockCount;
  double addCardStockPercentage;

  factory AddCardStockSetting.fromJson(Map<String, dynamic> json) {
    return AddCardStockSetting(
      addCardStockOption: json["add_card_stock_option"],
      addCardStockCount: json["add_card_stock_count"] ?? 0,
      addCardStockPercentage: json["add_card_stock_percentage_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "add_card_stock_option": addCardStockOption,
        "add_card_stock_count": addCardStockCount,
      };
}

class OtherInOrOutComeSetting {
  OtherInOrOutComeSetting({
    this.otherInOrOutComeOption = false,
    this.otherInOrOutComeCount = 0,
    this.otherInOrOutComePercentage = 0,
  });

  bool otherInOrOutComeOption;
  int otherInOrOutComeCount;
  double otherInOrOutComePercentage;

  factory OtherInOrOutComeSetting.fromJson(Map<String, dynamic> json) {
    return OtherInOrOutComeSetting(
      otherInOrOutComeOption: json["other_in_or_out_come_option"],
      otherInOrOutComeCount: json["other_in_or_out_come_count"] ?? 0,
      otherInOrOutComePercentage: json["other_in_or_out_come_percentage_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "other_in_or_out_come_option": otherInOrOutComeOption,
        "other_in_or_out_come_count": otherInOrOutComeCount,
      };
}

class ImportFromExcelSetting {
  ImportFromExcelSetting({
    this.importFromExcelOption = false,
    this.excelCount = 0,
    this.excelPercentage = 0,
  });

  bool importFromExcelOption;
  int excelCount;
  double excelPercentage;

  factory ImportFromExcelSetting.fromJson(Map<String, dynamic> json) {
    return ImportFromExcelSetting(
      importFromExcelOption: json["import_from_excel_option"],
      excelCount: json["excel_count"] ?? 0,
      excelPercentage: json["excel_percentage_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "import_from_excel_option": importFromExcelOption,
        "excel_count": excelCount,
      };
}

class MissionSetting {
  MissionSetting({
    this.missionOption = false,
  });

  bool missionOption;

  factory MissionSetting.fromJson(Map<String, dynamic> json) {
    return MissionSetting(
      missionOption: json["mission_option"],
    );
  }

  Map<String, dynamic> toJson() => {
        "mission_option": missionOption,
      };
}

class PrintOtherNoteSetting {
  PrintOtherNoteSetting({
    this.printOtherNoteOption = false,
  });

  bool printOtherNoteOption;

  factory PrintOtherNoteSetting.fromJson(Map<String, dynamic> json) {
    return PrintOtherNoteSetting(
      printOtherNoteOption: json["print_other_note_option"],
    );
  }

  Map<String, dynamic> toJson() => {
        "print_other_note_option": printOtherNoteOption,
      };
}

class TransferSetting {
  TransferSetting({
    this.transferOption = false,
    this.transferCount = 0,
    this.transferPercentage = 0,
  });

  bool transferOption;
  int transferCount;
  double transferPercentage;

  factory TransferSetting.fromJson(Map<String, dynamic> json) {
    return TransferSetting(
      transferOption: json["transfer_option"],
      transferCount: json["transfer_count"] ?? 0,
      transferPercentage: json["transfer_percentage_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "transfer_option": transferOption,
        "transfer_count": transferCount,
      };
}

class DisplayBusinessOptionProfileEmployeeModel {
  late ExchangeSetting exchangeSetting;
  late SellCardSetting sellCardSetting;
  late OutsiderBorrowOrLendingSetting outsiderBorrowOrLendingSetting;
  late GiveMoneyToMatSetting giveMoneyToMatSetting;
  late GiveCardToMatSetting giveCardToMatSetting;
  late RateSetting rateSetting;
  late AddCardStockSetting addCardStockSetting;
  late OtherInOrOutComeSetting otherInOrOutComeSetting;
  late ImportFromExcelSetting importFromExcelSetting;
  late MissionSetting missionSetting;
  late PrintOtherNoteSetting printOtherNoteSetting;
  late TransferSetting transferSetting;

  DisplayBusinessOptionProfileEmployeeModel({
    ExchangeSetting? exchangeSetting,
    SellCardSetting? sellCardSetting,
    OutsiderBorrowOrLendingSetting? outsiderBorrowOrLendingSetting,
    GiveMoneyToMatSetting? giveMoneyToMatSetting,
    GiveCardToMatSetting? giveCardToMatSetting,
    RateSetting? rateSetting,
    AddCardStockSetting? addCardStockSetting,
    OtherInOrOutComeSetting? otherInOrOutComeSetting,
    ImportFromExcelSetting? importFromExcelSetting,
    MissionSetting? missionSetting,
    PrintOtherNoteSetting? printOtherNoteSetting,
    TransferSetting? transferSetting,
  }) {
    this.exchangeSetting = exchangeSetting ?? ExchangeSetting();
    this.sellCardSetting = sellCardSetting ?? SellCardSetting();
    this.outsiderBorrowOrLendingSetting = outsiderBorrowOrLendingSetting ?? OutsiderBorrowOrLendingSetting();
    this.giveMoneyToMatSetting = giveMoneyToMatSetting ?? GiveMoneyToMatSetting();
    this.giveCardToMatSetting = giveCardToMatSetting ?? GiveCardToMatSetting();
    this.rateSetting = rateSetting ?? RateSetting();
    this.addCardStockSetting = addCardStockSetting ?? AddCardStockSetting();
    this.otherInOrOutComeSetting = otherInOrOutComeSetting ?? OtherInOrOutComeSetting();
    this.importFromExcelSetting = importFromExcelSetting ?? ImportFromExcelSetting();
    this.missionSetting = missionSetting ?? MissionSetting();
    this.printOtherNoteSetting = printOtherNoteSetting ?? PrintOtherNoteSetting();
    this.transferSetting = transferSetting ?? TransferSetting();
  }

  factory DisplayBusinessOptionProfileEmployeeModel.fromJson(Map<String, dynamic> json_) {
    return DisplayBusinessOptionProfileEmployeeModel(
      exchangeSetting: ExchangeSetting.fromJson(json_["exchange_setting"]),
      sellCardSetting: SellCardSetting.fromJson(json_["sell_card_setting"]),
      outsiderBorrowOrLendingSetting: OutsiderBorrowOrLendingSetting.fromJson(json_["outsider_borrowing_or_lending_setting"]),
      giveMoneyToMatSetting: GiveMoneyToMatSetting.fromJson(json_["give_money_to_mat_setting"]),
      giveCardToMatSetting: GiveCardToMatSetting.fromJson(json_["give_card_to_mat_setting"]),
      rateSetting: RateSetting.fromJson(json_["rate_setting"]),
      addCardStockSetting: AddCardStockSetting.fromJson(json_["add_card_stock_setting"]),
      otherInOrOutComeSetting: OtherInOrOutComeSetting.fromJson(json_["other_in_or_out_come_setting"]),
      importFromExcelSetting: ImportFromExcelSetting.fromJson(json_["import_from_excel_setting"]),
      missionSetting: MissionSetting.fromJson(json_["mission_setting"]),
      printOtherNoteSetting: PrintOtherNoteSetting.fromJson(json_["print_other_note_setting"]),
      transferSetting: TransferSetting.fromJson(json_["transfer_setting"]),
    );
  }
  Map<String, dynamic> toJson() => {
        "exchange_setting": exchangeSetting.toJson(),
        "sell_card_setting": sellCardSetting.toJson(),
        "outsider_borrowing_or_lending_setting": outsiderBorrowOrLendingSetting.toJson(),
        "give_money_to_mat_setting": giveMoneyToMatSetting.toJson(),
        "give_card_to_mat_setting": giveCardToMatSetting.toJson(),
        "rate_setting": rateSetting.toJson(),
        "add_card_stock_setting": addCardStockSetting.toJson(),
        "other_in_or_out_come_setting": otherInOrOutComeSetting.toJson(),
        "import_from_excel_setting": importFromExcelSetting.toJson(),
        "mission_setting": missionSetting.toJson(),
        "print_other_note_setting": printOtherNoteSetting.toJson(),
        "transfer_setting": transferSetting.toJson(),
      };
}

ProfileEmployeeModel profileEmployeeModelClone({required ProfileEmployeeModel profileEmployeeModel}) {
  final DateTime? deletedDate = profileEmployeeModel.deletedDate;
  final String? id = profileEmployeeModel.id;
  final TextEditingController name = TextEditingController(text: profileEmployeeModel.name.text);
  final TextEditingController bio = TextEditingController(text: profileEmployeeModel.bio.text);
  final String? supId = profileEmployeeModel.supId;
  final TextEditingController password = TextEditingController(text: profileEmployeeModel.password.text);
  final DisplayBusinessOptionProfileEmployeeModel displayBusinessOptionModel = DisplayBusinessOptionProfileEmployeeModel(
    exchangeSetting: ExchangeSetting(
      exchangeOption: profileEmployeeModel.displayBusinessOptionModel.exchangeSetting.exchangeOption,
      exchangeCount: profileEmployeeModel.displayBusinessOptionModel.exchangeSetting.exchangeCount,
    ),
    sellCardSetting: SellCardSetting(
      sellCardOption: profileEmployeeModel.displayBusinessOptionModel.sellCardSetting.sellCardOption,
      sellCardCount: profileEmployeeModel.displayBusinessOptionModel.sellCardSetting.sellCardCount,
    ),
    outsiderBorrowOrLendingSetting: OutsiderBorrowOrLendingSetting(
      outsiderBorrowOrLendingOption: profileEmployeeModel.displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingOption,
      outsiderBorrowOrLendingCount: profileEmployeeModel.displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingCount,
    ),
    giveMoneyToMatSetting: GiveMoneyToMatSetting(
      giveMoneyToMatOption: profileEmployeeModel.displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatOption,
      giveMoneyToMatCount: profileEmployeeModel.displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatCount,
    ),
    giveCardToMatSetting: GiveCardToMatSetting(
      giveCardToMatOption: profileEmployeeModel.displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatOption,
      giveCardToMatCount: profileEmployeeModel.displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatCount,
    ),
    rateSetting: RateSetting(
      rateOption: profileEmployeeModel.displayBusinessOptionModel.rateSetting.rateOption,
    ),
    addCardStockSetting: AddCardStockSetting(
      addCardStockOption: profileEmployeeModel.displayBusinessOptionModel.addCardStockSetting.addCardStockOption,
      addCardStockCount: profileEmployeeModel.displayBusinessOptionModel.addCardStockSetting.addCardStockCount,
    ),
    otherInOrOutComeSetting: OtherInOrOutComeSetting(
      otherInOrOutComeOption: profileEmployeeModel.displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeOption,
      otherInOrOutComeCount: profileEmployeeModel.displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeCount,
    ),
    importFromExcelSetting: ImportFromExcelSetting(
      importFromExcelOption: profileEmployeeModel.displayBusinessOptionModel.importFromExcelSetting.importFromExcelOption,
      excelCount: profileEmployeeModel.displayBusinessOptionModel.importFromExcelSetting.excelCount,
    ),
    missionSetting: MissionSetting(
      missionOption: profileEmployeeModel.displayBusinessOptionModel.missionSetting.missionOption,
    ),
    printOtherNoteSetting: PrintOtherNoteSetting(
      printOtherNoteOption: profileEmployeeModel.displayBusinessOptionModel.printOtherNoteSetting.printOtherNoteOption,
    ),
    transferSetting: TransferSetting(
      transferOption: profileEmployeeModel.displayBusinessOptionModel.transferSetting.transferOption,
      transferCount: profileEmployeeModel.displayBusinessOptionModel.transferSetting.transferCount,
    ),
  );
  // final String? moneyType = profileEmployeeModel.salaryCalculationModel.moneyType;
  // final TextEditingController earningForSecond = TextEditingController(text: profileEmployeeModel.salaryCalculationModel.earningForSecond.text);
  // final TextEditingController earningForInvoice = TextEditingController(text: profileEmployeeModel.salaryCalculationModel.earningForInvoice.text);
  // final TextEditingController earningForMoneyInUsed = TextEditingController(text: profileEmployeeModel.salaryCalculationModel.earningForMoneyInUsed.text);
  // final DateTime startDateTemp = profileEmployeeModel.salaryCalculationModel.startDate;
  // final DateTime endDateTemp = profileEmployeeModel.salaryCalculationModel.endDate;
  // final DateTime startDate = DateTime(startDateTemp.year, startDateTemp.month, startDateTemp.day, startDateTemp.hour, startDateTemp.minute,
  //     startDateTemp.second, startDateTemp.millisecond, startDateTemp.microsecond);
  // final DateTime endDate = DateTime(endDateTemp.year, endDateTemp.month, endDateTemp.day, endDateTemp.hour, endDateTemp.minute, endDateTemp.second,
  //     endDateTemp.millisecond, endDateTemp.microsecond);
  // final SalaryCalculation salaryCalculationModel = SalaryCalculation(
  //   moneyType: moneyType,
  //   earningForSecond: earningForSecond,
  //   startDate: startDate,
  //   endDate: endDate,
  //   earningForInvoice: earningForInvoice,
  //   earningForMoneyInUsed: earningForMoneyInUsed,
  // );
  final DateTime startDateTemp = profileEmployeeModel.salaryCalculationModel.startDate;
  final DateTime startDate = DateTime(startDateTemp.year, startDateTemp.month, startDateTemp.day, startDateTemp.hour, startDateTemp.minute, 0, 0, 0);
  final DateTime endDateTemp = profileEmployeeModel.salaryCalculationModel.endDate;
  final DateTime endDate = DateTime(endDateTemp.year, endDateTemp.month, endDateTemp.day, endDateTemp.hour, endDateTemp.minute, 0, 0, 0);
  final String moneyType = profileEmployeeModel.salaryCalculationModel.moneyType!;
  final TextEditingController earningForHour = TextEditingController(text: profileEmployeeModel.salaryCalculationModel.earningForHour.text);
  final TextEditingController maxPayAmount = TextEditingController(text: profileEmployeeModel.salaryCalculationModel.maxPayAmount.text);
  bool isSimpleSalary = profileEmployeeModel.salaryCalculationModel.salaryAdvanceList.isEmpty;
  SalaryCalculationEarningForInvoice? earningForInvoice;
  SalaryCalculationEarningForMoneyInUsed? earningForMoneyInUsed;
  final List<SalaryAdvance> salaryAdvanceList = [];
  if (isSimpleSalary) {
    final List<CombineMoneyInUsed> combineMoneyInUsedList = [];
    for (final CombineMoneyInUsed combineMoneyInUsed in profileEmployeeModel.salaryCalculationModel.earningForInvoice!.combineMoneyInUsed) {
      final CombineMoneyInUsed combineMoneyInUsedTemp = CombineMoneyInUsed(
        moneyType: combineMoneyInUsed.moneyType,
        moneyAmount: TextEditingController(text: combineMoneyInUsed.moneyAmount.text),
      );
      combineMoneyInUsedList.add(combineMoneyInUsedTemp);
    }
    earningForInvoice = SalaryCalculationEarningForInvoice(
      payAmount: TextEditingController(text: profileEmployeeModel.salaryCalculationModel.earningForInvoice!.payAmount.text),
      combineMoneyInUsed: combineMoneyInUsedList,
    );
    List<CombineMoneyInUsed> moneyList = [];
    for (final CombineMoneyInUsed combineMoneyInUsed in profileEmployeeModel.salaryCalculationModel.earningForMoneyInUsed!.moneyList) {
      final CombineMoneyInUsed combineMoneyInUsedTemp = CombineMoneyInUsed(
        moneyType: combineMoneyInUsed.moneyType,
        moneyAmount: TextEditingController(text: combineMoneyInUsed.moneyAmount.text),
      );
      moneyList.add(combineMoneyInUsedTemp);
    }

    earningForMoneyInUsed = SalaryCalculationEarningForMoneyInUsed(
      payAmount: TextEditingController(text: profileEmployeeModel.salaryCalculationModel.earningForMoneyInUsed!.payAmount.text),
      moneyList: profileEmployeeModel.salaryCalculationModel.earningForMoneyInUsed!.moneyList,
    );
  } else {
    for (final SalaryAdvance salaryAdvance in profileEmployeeModel.salaryCalculationModel.salaryAdvanceList) {
      final List<CombineMoneyInUsed> combineMoneyInUsed = [];
      for (final CombineMoneyInUsed combineMoneyInUsedTemp in salaryAdvance.earningForInvoice.combineMoneyInUsed) {
        final CombineMoneyInUsed combineMoneyInUsedTempTemp = CombineMoneyInUsed(
          moneyType: combineMoneyInUsedTemp.moneyType,
          moneyAmount: TextEditingController(text: combineMoneyInUsedTemp.moneyAmount.text),
        );
        combineMoneyInUsed.add(combineMoneyInUsedTempTemp);
      }
      final SalaryCalculationEarningForInvoice earningForInvoice = SalaryCalculationEarningForInvoice(
        payAmount: TextEditingController(text: salaryAdvance.earningForInvoice.payAmount.text),
        combineMoneyInUsed: combineMoneyInUsed,
      );
      final SalaryCalculationEarningForMoneyInUsed earningForMoneyInUsed = SalaryCalculationEarningForMoneyInUsed(
        payAmount: TextEditingController(text: salaryAdvance.earningForMoneyInUsed.payAmount.text),
        moneyList: salaryAdvance.earningForMoneyInUsed.moneyList,
      );
      final SalaryAdvance salaryAdvanceTemp = SalaryAdvance(
        invoiceType: salaryAdvance.invoiceType,
        earningForInvoice: earningForInvoice,
        earningForMoneyInUsed: earningForMoneyInUsed,
      );
      salaryAdvanceList.add(salaryAdvanceTemp);
    }
  }

  final SalaryCalculation salaryCalculationModel = SalaryCalculation(
    isSimpleSalary: isSimpleSalary,
    startDate: startDate,
    endDate: endDate,
    moneyType: moneyType,
    earningForHour: earningForHour,
    maxPayAmount: maxPayAmount,
    earningForInvoice: earningForInvoice,
    earningForMoneyInUsed: earningForMoneyInUsed,
    salaryAdvanceList: salaryAdvanceList,
  );

  final List<SalaryMergeByMonthModel> salaryList = profileEmployeeModel.salaryList;
  return ProfileEmployeeModel(
    deletedDate: deletedDate,
    id: id,
    name: name,
    bio: bio,
    supId: supId,
    password: password,
    displayBusinessOptionModel: displayBusinessOptionModel,
    salaryCalculationModel: salaryCalculationModel,
    salaryList: salaryList,
  );
}
