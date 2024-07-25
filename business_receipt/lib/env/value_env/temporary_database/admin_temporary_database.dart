import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/model/admin_model/card/card_combine_model.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/admin_model/currency_model.dart';
import 'package:business_receipt/model/admin_model/customer_information_category.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/admin_model/excel_admin_model.dart';
import 'package:business_receipt/model/admin_model/mission_model.dart';
import 'package:business_receipt/model/admin_model/print_model.dart';
import 'package:business_receipt/model/admin_model/profile_model.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/admin_model/transfer_model.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:business_receipt/override_lib/currency_lib/currency.dart';
import 'package:flutter/material.dart';

//---------------------profile---------------------------
ProfileAdminModel? profileModelAdminGlobal; //will not null when logged in or registered

//---------------------amount and profit--------------------
List<AmountAndProfitModel> amountAndProfitModelGlobal = [];

//--------------------rate------------------------
List<RateModel> rateModelListAdminGlobal = []; //length > 1 when click on rate in business option

//------------------------currency  list --------------------
List<CurrencyModel> currencyModelListAdminGlobal = []; //length > 1 when click on currency  in business option
List<Currency> currenciesOptionGlobal = [];

//------------------------card  list --------------------
List<CardModel> cardModelListGlobal = []; //length > 1 when click on card
List<CardCombineModel> cardCombineModelListGlobal = [];
//------------------------employee list --------------------
//TODO: create employee model
List<ProfileEmployeeModel> profileEmployeeModelListAdminGlobal = []; //length > 1 when click on card

//-----------------customer list --------------------
List<CustomerInformationCategory> customerCategoryListGlobal = [];
List<CustomerModel> customerModelListGlobal = [];
List<CustomerModel> customerModelWithoutTransferListGlobal = [];

//-----------------excel list --------------------
List<ExcelAdminModel> excelAdminModelListGlobal = [];
List<TextEditingController> excelCategoryListGlobal = [];

//----------------print-----------------------------
PrintModel printModelGlobal = PrintModel(
  communicationList: [],
  footer: ElementPrintModel(title: TextEditingController(), subtitle: TextEditingController()),
  header: ElementPrintModel(title: TextEditingController(), subtitle: TextEditingController()),
  selectedLanguage: languageDefaultStr, otherList: [],
);

//--------------------------mission--------------------------------------------------
MissionModel missionModelGlobal = MissionModel(closeSellingDate: [], totalService: 0);

//-----------------transfer list --------------------
List<TransferModel> transferModelListGlobal = [];

//---------------------up to date---------------------------
DateTime? upToDateGlobal;
// bool isCheckingUpToDateGlobal = false;