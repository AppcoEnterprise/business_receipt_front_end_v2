import 'package:business_receipt/env/function/table_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/admin_or_employee_list_asking_for_change.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/employee_model/card/card_main_stock_model.dart';
import 'package:business_receipt/model/employee_model/card/card_other_model.dart';
import 'package:business_receipt/model/employee_model/card/sell_card_model.dart';
import 'package:business_receipt/model/employee_model/cash_model.dart';
import 'package:business_receipt/model/employee_model/excel_employee_model.dart';
import 'package:business_receipt/model/employee_model/exchange_money_model.dart';
import 'package:business_receipt/model/employee_model/give_card_to_mat_model.dart';
import 'package:business_receipt/model/employee_model/give_money_to_mat_model.dart';
import 'package:business_receipt/model/employee_model/history_model.dart';
import 'package:business_receipt/model/employee_model/other_in_or_out_come_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:business_receipt/model/employee_model/salary_model.dart';
import 'package:business_receipt/model/employee_model/transfer_order_model.dart';
import 'package:flutter/material.dart';

//---------------------profile---------------------------
ProfileEmployeeModel? profileModelEmployeeGlobal; //will not null when logged in or registered

//--------------------admin is editing------------------------------------
bool adminIsEditingGlobal = false;
AdminOrEmployeeListAskingForChange? askingForChangeFromAdminGlobal;
List<AdminOrEmployeeListAskingForChange> askingForChangeFromEmployeeListGlobal = [];

// //----------------------cash money--------------------------------------------
CashModel cashModelGlobal = CashModel(cashList: []);

// //---------------------history list--------------------
// int skipHistoryListGlobal = queryLimitNumberGlobal;
// bool outOfDataQueryHistoryListGlobal = false;
List<HistoryModel> historyListGlobal = [];

//-----------------------transfer list-----------------------------
int skipTransferListGlobal = queryLimitNumberGlobal;
bool outOfDataQueryTransferListGlobal = false;
List<TransferOrder> transferModelListEmployeeGlobal = []; //will not empty when you save the TransferOrder

//-----------------------exchange list-----------------------------
int skipExchangeListGlobal = queryLimitNumberGlobal;
bool outOfDataQueryExchangeListGlobal = false;
List<ExchangeMoneyModel> exchangeModelListEmployeeGlobal = []; //will not empty when you save the exchange

//-----------------------sell card list-----------------------------
int skipSellCardListGlobal = queryLimitNumberGlobal;
bool outOfDataQuerySellCardListGlobal = false;
List<SellCardModel> sellCardModelListEmployeeGlobal = []; //will not empty when you save the exchange

//-----------------------main card list-----------------------------
int skipMainCardListGlobal = queryLimitNumberGlobal;
bool outOfDataQueryMainCardListGlobal = false;
List<InformationAndCardMainStockModel> mainCardModelListEmployeeGlobal = []; //will not empty when you save the exchange

//-----------------------borrow or lend list-----------------------------
int skipBorrowOrLendListGlobal = queryLimitNumberGlobal;
bool outOfDataQueryBorrowOrLendListGlobal = false;
List<MoneyCustomerModel> borrowOrLendModelListEmployeeGlobal = []; //will not empty when you save the exchange

//-----------------------give money to mat list-----------------------------
int skipGiveMoneyToMatListGlobal = queryLimitNumberGlobal;
bool outOfDataQueryGiveMoneyToMatListGlobal = false;
List<GiveMoneyToMatModel> giveMoneyToMatModelListEmployeeGlobal = []; //will not empty when you save the exchange

//-----------------------give money to mat list-----------------------------
int skipGiveCardToMatListGlobal = queryLimitNumberGlobal;
bool outOfDataQueryGiveCardToMatListGlobal = false;
List<GiveCardToMatModel> giveCardToMatModelListEmployeeGlobal = []; //will not empty when you save the exchange

//-----------------------other income or outcome list-----------------------------
int skipOtherInOrOutComeToMatListGlobal = queryLimitNumberGlobal;
bool outOfDataQueryOtherInOrOutComeListGlobal = false;
List<OtherInOrOutComeModel> otherInOrOutComeModelListEmployeeGlobal = []; //will not empty when you save the exchange

//-----------------------excel list-----------------------------
int skipExcelListGlobal = queryLimitNumberGlobal;
bool outOfDataQueryExcelListGlobal = false;
List<ExcelEmployeeModel> excelListEmployeeGlobal = []; //will not empty when you save the exchange

//-----------------------excel history list-----------------------------
int skipExcelHistoryListGlobal = queryLimitNumberGlobal;
bool outOfDataQueryExcelHistoryListGlobal = false;
List<ExcelDataList> excelHistoryListEmployeeGlobal = []; //will not empty when you save the exchange

//-----------------------other income or outcome list-----------------------------
List<SalaryMergeByMonthModel> salaryListEmployeeGlobal = []; //will not empty when you save the exchange

//------------------------exchange---------------------------------------
int onSelectExchangeSideMenuIndexGlobal = 0;

ExchangeMoneyModel exchangeTempSideMenuGlobal = ExchangeMoneyModel(
  activeLogModelList: [],
  remark: TextEditingController(),
  exchangeList: [
    ExchangeListExchangeMoneyModel(
      getMoney: TextEditingController(),
      getMoneyFocusNode: FocusNode(),
      giveMoney: TextEditingController(),
      giveMoneyFocusNode: FocusNode(),
    ),
  ],
);
List<ActiveLogModel> activeLogModelExchangeList = [];
List<AdditionMoneyModel> additionMoneyModelListGlobal = [];

List<SellCardModel> sellCardModelTempSideMenuListGlobal = [];

List<ActiveLogModel> activeLogModelSellCardList = [];
SellCardModel sellCardAdvanceModelTempSellCardGlobal = SellCardModel(activeLogModelList: [], moneyTypeList: [], remark: TextEditingController());
ExchangeMoneyModel exchangeAnalysisCardSellCardGlobal = ExchangeMoneyModel(activeLogModelList: [], exchangeList: [], remark: TextEditingController());
List<List<TextEditingController>> textFieldController2DSellCardGlobal = [];
List<List<List<String>>> menuItemStr3DSellCardGlobal = [];
List<List<bool>> isShowTextField2DSellCardGlobal = [];

List<BuyAndSellDiscountRate> buyAndSellDiscountRateListSellCardGlobal = [];
