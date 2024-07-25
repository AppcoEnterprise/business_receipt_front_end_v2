// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/card.dart';
import 'package:business_receipt/env/function/cash_money.dart';
import 'package:business_receipt/env/function/custom_drop_down_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/draw_line.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/rate.dart';
import 'package:business_receipt/env/function/request_api/card_request_api_env.dart';
import 'package:business_receipt/env/function/request_api/cash_request_api_env.dart';
import 'package:business_receipt/env/function/request_api/customer_request_api_env.dart';
import 'package:business_receipt/env/function/request_api/excel_request_api_env.dart';
import 'package:business_receipt/env/function/request_api/exchange_request_api_env.dart';
import 'package:business_receipt/env/function/request_api/give_card_to_mat_request_api_env.dart';
import 'package:business_receipt/env/function/request_api/give_money_to_mat_request_api_env.dart';
import 'package:business_receipt/env/function/request_api/history_request_api_env.dart';
import 'package:business_receipt/env/function/request_api/other_in_or_out_come_request_api_env.dart';
import 'package:business_receipt/env/function/request_api/transfer_request_api_env.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/button_add_limit.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/invoice_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
// import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
// import 'package:business_receipt/env/value_env/temporary_database/employee_or_admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/card/card_main_stock_model.dart';
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
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class HistoryEmployeeSideMenu extends StatefulWidget {
  String title;
  List<HistoryModel> historyList;
  CashModel cashModel;
  DateTime targetDate;
  bool isCurrentDate;
  bool isNotViewOnly;
  bool isForceShowHistory;
  String employeeId;
  bool isAdminEditing;
  bool isSelectedDateAtInit;
  DateTime? firstDate;
  List<AmountAndProfitModel> amountAndProfitModel;
  List<CardModel> cardModelList;
  List<SalaryHistory> salaryHistoryList;
  DisplayBusinessOptionProfileEmployeeModel? displayBusinessOptionModel;
  HistoryEmployeeSideMenu({
    Key? key,
    required this.isSelectedDateAtInit,
    required this.isAdminEditing,
    required this.title,
    required this.historyList,
    required this.cashModel,
    required this.targetDate,
    required this.isCurrentDate,
    required this.isNotViewOnly,
    required this.isForceShowHistory,
    required this.employeeId,
    required this.firstDate,
    required this.amountAndProfitModel,
    required this.cardModelList,
    required this.salaryHistoryList,
    required this.displayBusinessOptionModel,
  }) : super(key: key);

  @override
  State<HistoryEmployeeSideMenu> createState() => _HistoryEmployeeSideMenuState();
}

class _HistoryEmployeeSideMenuState extends State<HistoryEmployeeSideMenu> {
  int skipHistoryList = queryLimitNumberGlobal;
  bool outOfDataQueryHistoryList = false;
  void historyAsyncOnTapFunction({required bool isNeedHistory}) async {
    final DateTime today = DateTime.now();
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime? targetDate = await showDatePicker(
      context: context,
      initialDate: widget.isAdminEditing ? today : yesterday,
      firstDate: widget.firstDate!,
      lastDate: widget.isAdminEditing ? today : yesterday,
    );
    if (targetDate == null) {
      if (widget.isAdminEditing) {
        closeDialogGlobal(context: context);
      } else {
        return;
      }
    }
    List<HistoryModel> historyList = [];
    CashModel cashModel = CashModel(cashList: []);
    List<AmountAndProfitModel> amountAndProfitModel = [];
    List<CardModel> cardModelList = [];
    List<SalaryHistory> salaryList = [];
    DisplayBusinessOptionProfileEmployeeModel displayBusinessOptionModel = DisplayBusinessOptionProfileEmployeeModel();
    List<ExchangeMoneyModel> exchangeModelListEmployee = [];
    List<TransferOrder> transferModelListEmployee = [];
    List<GiveMoneyToMatModel> giveMoneyToMatModelListEmployee = [];
    List<GiveCardToMatModel> giveCardToMatModelListEmployee = [];
    List<OtherInOrOutComeModel> otherInOrOutComeModelListEmployee = [];
    List<SellCardModel> sellCardModelListEmployee = [];
    List<InformationAndCardMainStockModel> mainCardModelListEmployee = [];
    List<MoneyCustomerModel> borrowOrLendModelListEmployee = [];
    List<ExcelDataList> excelListEmployee = [];

    void callBack({required DateTime? firstDateNew, required bool isExisted}) {
      if (isExisted) {
        widget.firstDate = firstDateNew;
        int invoiceIndex = 0;
        int totalHistory = 0;
        bool outOfDataQuery = false;
        int skip = 0;
        List<InvoiceOption> historyInvoiceList = [];
        if (displayBusinessOptionModel.exchangeSetting.exchangeOption) {
          historyInvoiceList.add(InvoiceOption(invoiceType: InvoiceEnum.exchange, title: "$exchangeTitleGlobal (${displayBusinessOptionModel.exchangeSetting.exchangeCount})"));
          totalHistory = totalHistory + displayBusinessOptionModel.exchangeSetting.exchangeCount;
        }
        if (displayBusinessOptionModel.sellCardSetting.sellCardOption) {
          historyInvoiceList.add(InvoiceOption(
            invoiceType: InvoiceEnum.sellCard,
            title: "$sellCardTitleGlobal (${displayBusinessOptionModel.sellCardSetting.sellCardCount})",
          ));
          totalHistory = totalHistory + displayBusinessOptionModel.sellCardSetting.sellCardCount;
        }
        if (displayBusinessOptionModel.transferSetting.transferOption) {
          historyInvoiceList.add(InvoiceOption(invoiceType: InvoiceEnum.transfer, title: "$transferTitleGlobal (${displayBusinessOptionModel.transferSetting.transferCount})"));
          totalHistory = totalHistory + displayBusinessOptionModel.transferSetting.transferCount;
        }
        if (displayBusinessOptionModel.importFromExcelSetting.importFromExcelOption) {
          historyInvoiceList.add(InvoiceOption(
            invoiceType: InvoiceEnum.importFromExcel,
            title: "$importFromExcelTitleGlobal  (${displayBusinessOptionModel.importFromExcelSetting.excelCount})",
          ));
          totalHistory = totalHistory + displayBusinessOptionModel.importFromExcelSetting.excelCount;
        }
        if (displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingOption) {
          historyInvoiceList.add(InvoiceOption(
            invoiceType: InvoiceEnum.borrowOrLend,
            title: "$borrowOrLendTitleGlobal (${displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingCount})",
          ));
          totalHistory = totalHistory + displayBusinessOptionModel.outsiderBorrowOrLendingSetting.outsiderBorrowOrLendingCount;
        }
        if (displayBusinessOptionModel.addCardStockSetting.addCardStockOption) {
          historyInvoiceList.add(InvoiceOption(
            invoiceType: InvoiceEnum.cardMainStock,
            title: "$cardMainStockTitleGlobal (${displayBusinessOptionModel.addCardStockSetting.addCardStockCount})",
          ));
          totalHistory = totalHistory + displayBusinessOptionModel.addCardStockSetting.addCardStockCount;
        }
        if (displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatOption) {
          historyInvoiceList.add(InvoiceOption(
            invoiceType: InvoiceEnum.giveMoneyToMat,
            title: "$giveMoneyToMatTitleGlobal (${displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatCount})",
          ));
          totalHistory = totalHistory + displayBusinessOptionModel.giveMoneyToMatSetting.giveMoneyToMatCount;
        }
        if (displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatOption) {
          historyInvoiceList.add(InvoiceOption(
            invoiceType: InvoiceEnum.giveCardToMat,
            title: "$giveCardToMatTitleGlobal (${displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatCount})",
          ));
          totalHistory = totalHistory + displayBusinessOptionModel.giveCardToMatSetting.giveCardToMatCount;
        }
        if (displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeOption) {
          historyInvoiceList.add(InvoiceOption(
            invoiceType: InvoiceEnum.otherInOrOutCome,
            title: "$otherInOrOutComeTitleGlobal (${displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeCount})",
          ));
          totalHistory = totalHistory + displayBusinessOptionModel.otherInOrOutComeSetting.otherInOrOutComeCount;
        }
        historyInvoiceList.insert(0, InvoiceOption(invoiceType: InvoiceEnum.allHistory, title: "$allHistoryTitleGlobal  ($totalHistory)"));

        void cancelFunctionOnTap() {
          closeDialogGlobal(context: context);
          if (widget.isAdminEditing) {
            closeDialogGlobal(context: context);
          }
          // setState(() {});
        }

        Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
          void setStateOutsider() {
            setStateFromDialog(() {});
          }

          Widget historyDropDown() {
            void onTapFunction() {}
            void onChangedFunction({required String value, required int index}) {
              invoiceIndex = index;
              outOfDataQuery = false;
              skip = queryLimitNumberGlobal;
              setStateFromDialog(() {});
            }

            return customDropdown(
              level: Level.normal,
              labelStr: historyContentButtonStrGlobal,
              onTapFunction: onTapFunction,
              onChangedFunction: onChangedFunction,
              selectedStr: historyInvoiceList[invoiceIndex].title,
              menuItemStrList: historyInvoiceList.map((e) => e.title).toList(),
            );
          }

          // print("salaryList.length => ${salaryList.length}");
          Widget historyWidget() {
            if (InvoiceEnum.allHistory == historyInvoiceList[invoiceIndex].invoiceType) {
              return HistoryEmployeeSideMenu(
                isSelectedDateAtInit: false,
                isAdminEditing: widget.isAdminEditing,
                title: historyOptionEmployeeStrGlobal,
                cashModel: cashModel,
                historyList: historyList,
                targetDate: targetDate!,
                isCurrentDate: false,
                employeeId: widget.employeeId,
                firstDate: widget.firstDate,
                amountAndProfitModel: amountAndProfitModel,
                cardModelList: cardModelList,
                isNotViewOnly: widget.isNotViewOnly,
                isForceShowHistory: false,
                salaryHistoryList: salaryList,
                displayBusinessOptionModel: displayBusinessOptionModel,
              );
            } else if (InvoiceEnum.exchange == historyInvoiceList[invoiceIndex].invoiceType) {
              List<Widget> inWrapWidgetList() {
                return [
                  for (int exchangeIndex = 0; exchangeIndex < exchangeModelListEmployee.length; exchangeIndex++)
                    HistoryElement(
                      isForceShowNoEffect: false,
                      isCurrentDate: false,
                      isAdminEditing: widget.isAdminEditing,
                      index: exchangeIndex,
                      exchangeMoneyModel: exchangeModelListEmployee[exchangeIndex],
                      setStateOutsider: setStateOutsider,
                    )
                ];
              }

              void topFunction() {}
              void bottomFunction() {
                if (!outOfDataQuery) {
                  final int beforeQuery = exchangeModelListEmployee.length;
                  void callBack() {
                    final int afterQuery = exchangeModelListEmployee.length;

                    if (beforeQuery == afterQuery) {
                      outOfDataQuery = true;
                    } else {
                      skip = skip + queryLimitNumberGlobal;
                    }
                    setStateFromDialog(() {});
                  }

                  getExchangeListEmployeeGlobal(
                    employeeId: widget.employeeId,
                    callBack: callBack,
                    context: context,
                    skip: skip,
                    targetDate: targetDate!,
                    exchangeModelListEmployee: exchangeModelListEmployee,
                  );
                }
              }

              return wrapScrollDetectWidget(
                inWrapWidgetList: inWrapWidgetList(),
                topFunction: topFunction,
                bottomFunction: bottomFunction,
                isShowSeeMoreWidget: !outOfDataQuery,
              );
            } else if (InvoiceEnum.sellCard == historyInvoiceList[invoiceIndex].invoiceType) {
              //TODO: change this function name
              List<Widget> inWrapWidgetList() {
                return [
                  for (int cardSellIndex = 0; cardSellIndex < sellCardModelListEmployee.length; cardSellIndex++) //TODO: change this
                    HistoryElement(
                      isForceShowNoEffect: false,
                      isCurrentDate: false,
                      isAdminEditing: widget.isAdminEditing,
                      index: cardSellIndex,
                      sellCardModel: sellCardModelListEmployee[cardSellIndex], //TODO: change this
                      setStateOutsider: setStateOutsider,
                    )
                ];
              }

              void topFunction() {}
              void bottomFunction() {
                if (!outOfDataQuery) {
                  //TODO: change this
                  final int beforeQuery = sellCardModelListEmployee.length; //TODO: change this
                  void callBack() {
                    final int afterQuery = sellCardModelListEmployee.length; //TODO: change this

                    if (beforeQuery == afterQuery) {
                      outOfDataQuery = true; //TODO: change this
                    } else {
                      skip = skip + queryLimitNumberGlobal; //TODO: change this
                    }
                    setStateFromDialog(() {});
                  }

                  getSellCardListEmployeeGlobal(
                    employeeId: widget.employeeId,
                    callBack: callBack,
                    context: context,
                    skip: skip,
                    targetDate: targetDate!,
                    sellCardModelListEmployee: sellCardModelListEmployee,
                  ); //TODO: change this
                }
              }

              return wrapScrollDetectWidget(
                inWrapWidgetList: inWrapWidgetList(),
                topFunction: topFunction,
                bottomFunction: bottomFunction,
                isShowSeeMoreWidget: !outOfDataQuery,
              );
            } else if (InvoiceEnum.transfer == historyInvoiceList[invoiceIndex].invoiceType) {
              List<Widget> inWrapWidgetList() {
                return [
                  for (int transferIndex = 0; transferIndex < transferModelListEmployee.length; transferIndex++)
                    HistoryElement(
                      isForceShowNoEffect: false,
                      isAdminEditing: widget.isAdminEditing,
                      index: transferIndex,
                      transferMoneyModel: transferModelListEmployee[transferIndex],
                      setStateOutsider: setStateOutsider,
                    )
                ];
              }

              void topFunction() {}
              void bottomFunction() {
                if (!outOfDataQuery) {
                  final int beforeQuery = transferModelListEmployee.length;
                  void callBack() {
                    final int afterQuery = transferModelListEmployee.length;

                    if (beforeQuery == afterQuery) {
                      outOfDataQuery = true;
                    } else {
                      skip = skip + queryLimitNumberGlobal;
                    }
                    setStateFromDialog(() {});
                  }

                  getTransferListEmployeeGlobal(
                    employeeId: widget.employeeId,
                    callBack: callBack,
                    context: context,
                    skip: skip,
                    targetDate: targetDate!,
                    transferModelListEmployee: transferModelListEmployee,
                  );
                }
              }

              return wrapScrollDetectWidget(
                inWrapWidgetList: inWrapWidgetList(),
                topFunction: topFunction,
                bottomFunction: bottomFunction,
                isShowSeeMoreWidget: !outOfDataQuery,
              );
            } else if (InvoiceEnum.importFromExcel == historyInvoiceList[invoiceIndex].invoiceType) {
              List<Widget> inWrapWidgetList() {
                return [
                  for (int excelIndex = 0; excelIndex < excelListEmployee.length; excelIndex++) //TODO: change this
                    HistoryElement(
                      isForceShowNoEffect: true,
                      isAdminEditing: widget.isAdminEditing,
                      index: excelIndex,
                      excelData: excelListEmployee[excelIndex], //TODO: change this
                      setStateOutsider: setStateOutsider,
                    )
                ];
              }

              void topFunction() {}
              void bottomFunction() {
                if (!outOfDataQuery) {
                  //TODO: change this
                  final int beforeQuery = excelListEmployee.length; //TODO: change this
                  void callBack() {
                    final int afterQuery = excelListEmployee.length; //TODO: change this
                    if (beforeQuery == afterQuery) {
                      outOfDataQuery = true; //TODO: change this
                    } else {
                      skip = skip + queryLimitNumberGlobal; //TODO: change this
                    }
                    setStateFromDialog(() {});
                    // setState(() {});
                  }

                  getExcelHistoryListEmployeeGlobal(
                    employeeId: widget.employeeId,
                    callBack: callBack,
                    context: context,
                    skip: skip,
                    targetDate: targetDate!,
                    excelListEmployee: excelListEmployee,
                  ); //TODO: change this
                }
              }

              return wrapScrollDetectWidget(
                inWrapWidgetList: inWrapWidgetList(),
                topFunction: topFunction,
                bottomFunction: bottomFunction,
                isShowSeeMoreWidget: !outOfDataQuery,
              );
            } else if (InvoiceEnum.borrowOrLend == historyInvoiceList[invoiceIndex].invoiceType) {
              //TODO: change this function name
              List<Widget> inWrapWidgetList() {
                return [
                  for (int borrowAndLendIndex = 0; borrowAndLendIndex < borrowOrLendModelListEmployee.length; borrowAndLendIndex++) //TODO: change this
                    HistoryElement(
                      isForceShowNoEffect: false,
                      isAdminEditing: widget.isAdminEditing,
                      index: borrowAndLendIndex,
                      borrowingOrLending: borrowOrLendModelListEmployee[borrowAndLendIndex], //TODO: change this
                      setStateOutsider: setStateOutsider,
                    )
                ];
              }

              void topFunction() {}
              void bottomFunction() {
                if (!outOfDataQuery) {
                  //TODO: change this
                  final int beforeQuery = borrowOrLendModelListEmployee.length; //TODO: change this
                  void callBack() {
                    final int afterQuery = borrowOrLendModelListEmployee.length; //TODO: change this

                    if (beforeQuery == afterQuery) {
                      outOfDataQuery = true; //TODO: change this
                    } else {
                      skip = skip + queryLimitNumberGlobal; //TODO: change this
                    }
                    setStateFromDialog(() {});
                  }

                  getBorrowOrLendListEmployeeGlobal(
                    employeeId: widget.employeeId,
                    callBack: callBack,
                    context: context,
                    skip: skip,
                    targetDate: targetDate!,
                    borrowOrLendModelListEmployee: borrowOrLendModelListEmployee,
                  ); //TODO: change this
                }
              }

              return wrapScrollDetectWidget(
                inWrapWidgetList: inWrapWidgetList(),
                topFunction: topFunction,
                bottomFunction: bottomFunction,
                isShowSeeMoreWidget: !outOfDataQuery,
              );
            } else if (InvoiceEnum.cardMainStock == historyInvoiceList[invoiceIndex].invoiceType) {
              List<Widget> inWrapWidgetList() {
                return [
                  for (int addStockIndex = 0; addStockIndex < mainCardModelListEmployee.length; addStockIndex++) //TODO: change this
                    HistoryElement(
                      isForceShowNoEffect: false,
                      isAdminEditing: widget.isAdminEditing,
                      index: addStockIndex,
                      informationAndCardMainStockModel: mainCardModelListEmployee[addStockIndex], //TODO: change this
                      setStateOutsider: setStateOutsider,
                    )
                ];
              }

              void topFunction() {}
              void bottomFunction() {
                if (!outOfDataQuery) {
                  //TODO: change this
                  final int beforeQuery = mainCardModelListEmployee.length; //TODO: change this
                  void callBack() {
                    final int afterQuery = mainCardModelListEmployee.length; //TODO: change this

                    if (beforeQuery == afterQuery) {
                      outOfDataQuery = true; //TODO: change this
                    } else {
                      skip = skip + queryLimitNumberGlobal; //TODO: change this
                    }
                    setStateFromDialog(() {});
                  }

                  getAddCardStockListEmployeeGlobal(
                    employeeId: widget.employeeId,
                    callBack: callBack,
                    context: context,
                    skip: skip,
                    targetDate: targetDate!,
                    mainCardModelListEmployee: mainCardModelListEmployee,
                  ); //TODO: change this
                }
              }

              return wrapScrollDetectWidget(
                inWrapWidgetList: inWrapWidgetList(),
                topFunction: topFunction,
                bottomFunction: bottomFunction,
                isShowSeeMoreWidget: !outOfDataQuery,
              );
            } else if (InvoiceEnum.giveMoneyToMat == historyInvoiceList[invoiceIndex].invoiceType) {
              //TODO: change this function name
              List<Widget> inWrapWidgetList() {
                return [
                  for (int giveMoneyToMatIndex = 0; giveMoneyToMatIndex < giveMoneyToMatModelListEmployee.length; giveMoneyToMatIndex++) //TODO: change this
                    HistoryElement(
                      isForceShowNoEffect: false,
                      isAdminEditing: widget.isAdminEditing,
                      index: giveMoneyToMatIndex,
                      giveMoneyToMatModel: giveMoneyToMatModelListEmployee[giveMoneyToMatIndex], //TODO: change this
                      setStateOutsider: setStateOutsider,
                    )
                ];
              }

              void topFunction() {}
              void bottomFunction() {
                if (!outOfDataQuery) {
                  //TODO: change this
                  final int beforeQuery = giveMoneyToMatModelListEmployee.length; //TODO: change this
                  void callBack() {
                    final int afterQuery = giveMoneyToMatModelListEmployee.length; //TODO: change this

                    if (beforeQuery == afterQuery) {
                      outOfDataQuery = true; //TODO: change this
                    } else {
                      skip = skip + queryLimitNumberGlobal; //TODO: change this
                    }
                    setStateFromDialog(() {});
                  }

                  getGiveMoneyToMatListEmployeeGlobal(
                    employeeId: widget.employeeId,
                    callBack: callBack,
                    context: context,
                    skip: skip,
                    targetDate: targetDate!,
                    giveMoneyToMatModelListEmployee: giveMoneyToMatModelListEmployee,
                  ); //TODO: change this
                }
              }

              return wrapScrollDetectWidget(
                inWrapWidgetList: inWrapWidgetList(),
                topFunction: topFunction,
                bottomFunction: bottomFunction,
                isShowSeeMoreWidget: !outOfDataQuery,
              );
            } else if (InvoiceEnum.giveCardToMat == historyInvoiceList[invoiceIndex].invoiceType) {
              List<Widget> inWrapWidgetList() {
                return [
                  for (int giveCardToMatIndex = 0; giveCardToMatIndex < giveCardToMatModelListEmployee.length; giveCardToMatIndex++) //TODO: change this
                    HistoryElement(
                      isForceShowNoEffect: false,
                      isAdminEditing: widget.isAdminEditing,
                      index: giveCardToMatIndex,
                      giveCardToMatModel: giveCardToMatModelListEmployee[giveCardToMatIndex], //TODO: change this
                      setStateOutsider: setStateOutsider,
                    )
                ];
              }

              void topFunction() {}
              void bottomFunction() {
                if (!outOfDataQuery) {
                  //TODO: change this
                  final int beforeQuery = giveCardToMatModelListEmployee.length; //TODO: change this
                  void callBack() {
                    final int afterQuery = giveCardToMatModelListEmployee.length; //TODO: change this

                    if (beforeQuery == afterQuery) {
                      outOfDataQuery = true; //TODO: change this
                    } else {
                      skip = skip + queryLimitNumberGlobal; //TODO: change this
                    }
                    setStateFromDialog(() {});
                  }

                  getGiveCardToMatListEmployeeGlobal(
                    employeeId: widget.employeeId,
                    callBack: callBack,
                    context: context,
                    skip: skip,
                    targetDate: targetDate!,
                    giveCardToMatModelListEmployee: giveCardToMatModelListEmployee,
                  ); //TODO: change this
                }
              }

              return wrapScrollDetectWidget(
                inWrapWidgetList: inWrapWidgetList(),
                topFunction: topFunction,
                bottomFunction: bottomFunction,
                isShowSeeMoreWidget: !outOfDataQuery,
              );
            } else if (InvoiceEnum.otherInOrOutCome == historyInvoiceList[invoiceIndex].invoiceType) {
              List<Widget> inWrapWidgetList() {
                return [
                  for (int otherInOrComeIndex = 0; otherInOrComeIndex < otherInOrOutComeModelListEmployee.length; otherInOrComeIndex++) //TODO: change this
                    HistoryElement(
                      isForceShowNoEffect: false,
                      isAdminEditing: widget.isAdminEditing,
                      index: otherInOrComeIndex,
                      otherInOrOutComeModel: otherInOrOutComeModelListEmployee[otherInOrComeIndex], //TODO: change this
                      setStateOutsider: setStateOutsider,
                    )
                ];
              }

              void topFunction() {}
              void bottomFunction() {
                if (!outOfDataQuery) {
                  //TODO: change this
                  final int beforeQuery = otherInOrOutComeModelListEmployee.length; //TODO: change this
                  void callBack() {
                    final int afterQuery = otherInOrOutComeModelListEmployee.length; //TODO: change this

                    if (beforeQuery == afterQuery) {
                      outOfDataQuery = true; //TODO: change this
                    } else {
                      skip = skip + queryLimitNumberGlobal; //TODO: change this
                    }
                    setStateFromDialog(() {});
                  }

                  getOtherInOrOutComeListEmployeeGlobal(
                    employeeId: widget.employeeId,
                    callBack: callBack,
                    context: context,
                    skip: skip,
                    targetDate: targetDate!,
                    otherInOrOutComeModelListEmployee: otherInOrOutComeModelListEmployee,
                  ); //TODO: change this
                }
              }

              return wrapScrollDetectWidget(
                inWrapWidgetList: inWrapWidgetList(),
                topFunction: topFunction,
                bottomFunction: bottomFunction,
                isShowSeeMoreWidget: !outOfDataQuery,
              );
            }

            return Text("out of widget");
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [historyDropDown(), Expanded(child: historyWidget())]);
        }

        actionDialogSetStateGlobal(
          dialogHeight: dialogSizeGlobal(level: Level.normal) / ((widget.isNotViewOnly || widget.isAdminEditing) ? 1 : 1.25),
          dialogWidth: dialogSizeGlobal(level: Level.large) / ((widget.isNotViewOnly || widget.isAdminEditing) ? 1 : 1.15),
          cancelFunctionOnTap: cancelFunctionOnTap,
          context: context,
          contentFunctionReturnWidget: contentFunctionReturnWidget,
        );
      } else {
        void okFunction() {
          closeDialogGlobal(context: context);
        }

        okDialogGlobal(
          context: context,
          okFunction: okFunction,
          titleStr: noHistoryStrGlobal,
          subtitleStr: "$noHistoryContentStrGlobal ${formatDateDateToStr(date: targetDate!)}",
        );
      }
    }

    getHistoryByDateEmployeeGlobal(
      callBack: callBack,
      isNeedHistory: isNeedHistory,
      context: context,
      employeeId: widget.employeeId,
      historyList: historyList,
      targetDate: targetDate!,
      cashModel: cashModel,
      amountAndProfitModel: amountAndProfitModel,
      cardModelList: cardModelList,
      salaryList: salaryList,
      displayBusinessOptionModel: displayBusinessOptionModel,
      exchangeModelListEmployee: exchangeModelListEmployee,
      transferModelListEmployee: transferModelListEmployee,
      giveMoneyToMatModelListEmployee: giveMoneyToMatModelListEmployee,
      giveCardToMatModelListEmployee: giveCardToMatModelListEmployee,
      otherInOrOutComeModelListEmployee: otherInOrOutComeModelListEmployee,
      sellCardModelListEmployee: sellCardModelListEmployee,
      mainCardModelListEmployee: mainCardModelListEmployee,
      borrowOrLendModelListEmployee: borrowOrLendModelListEmployee,
      excelListEmployee: excelListEmployee,
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.isSelectedDateAtInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        historyAsyncOnTapFunction(isNeedHistory: false);
      });
    }

    // cashModelGlobal.mergeBy = moneyTypeOnlyList().isNotEmpty ? moneyTypeOnlyList().first : languageDefaultStr;
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      List<Widget> inWrapWidgetList() {
        void setStateOutsider() {
          setState(() {});
        }

        return [
          for (int invoiceIndex = 0; invoiceIndex < widget.historyList.length; invoiceIndex++)
            HistoryElement(
              isForceShowNoEffect: true,
              index: invoiceIndex,
              historyModel: widget.historyList[invoiceIndex],
              exchangeMoneyModel: widget.historyList[invoiceIndex].exchangeMoneyModel,
              transferMoneyModel: widget.historyList[invoiceIndex].transferMoneyModel,
              informationAndCardMainStockModel: widget.historyList[invoiceIndex].informationAndCardMainStockModel,
              sellCardModel: widget.historyList[invoiceIndex].sellCardModel,
              borrowingOrLending: widget.historyList[invoiceIndex].borrowingOrLending,
              giveMoneyToMatModel: widget.historyList[invoiceIndex].giveMoneyToMatModel,
              giveCardToMatModel: widget.historyList[invoiceIndex].giveCardToMatModel,
              otherInOrOutComeModel: widget.historyList[invoiceIndex].otherInOrOutComeModel,
              excelData: widget.historyList[invoiceIndex].excelData,
              setStateOutsider: setStateOutsider,
              isCurrentDate: widget.isCurrentDate && widget.isNotViewOnly,
              isAdminEditing: widget.isAdminEditing,
            )
        ];
      }

      Widget? customRowBetweenHeaderAndBodyWidget() {
        Widget customTotalListWidget({required String titleStr, required List<Widget> totalListWidget}) {
          Widget titleTextWidget() {
            return Padding(
              padding: EdgeInsets.only(
                  left: paddingSizeGlobal(level: Level.mini), top: paddingSizeGlobal(level: Level.large), bottom: paddingSizeGlobal(level: Level.mini)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text(titleStr, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold))],
              ),
            );
          }

          Widget paddingTotalListWidget() {
            return Column(children: [
              for (int totalIndex = 0; totalIndex < totalListWidget.length; totalIndex++)
                Padding(
                  padding: EdgeInsets.only(
                      bottom: paddingSizeGlobal(level: Level.mini), left: paddingSizeGlobal(level: Level.mini), right: paddingSizeGlobal(level: Level.mini)),
                  child: totalListWidget[totalIndex],
                ),
            ]);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleTextWidget(), paddingTotalListWidget()]);
        }

        Widget totalAndProfitListWidget() {
          Widget amountTextWidget({required int amountAndProfitIndex}) {
            final String moneyTypeStr = widget.amountAndProfitModel[amountAndProfitIndex].moneyType;
            Widget insideSizeBoxWidget() {
              Widget moneyTypeTextWidget() {
                return Padding(
                  padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                  child: Text(moneyTypeStr, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                );
              }

              Widget scrollTextAmountWidget() {
                final String moneyTypeStr = widget.amountAndProfitModel[amountAndProfitIndex].moneyType;
                final int place = findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!;
                final String amountStr = formatAndLimitNumberTextGlobal(
                  valueStr: widget.amountAndProfitModel[amountAndProfitIndex].amount.toString(),
                  isRound: false,
                  isAllowZeroAtLast: false,
                  places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                );
                return scrollText(
                    textStr: "$totalsStrGlobal $amountStr $moneyTypeStr", textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.topCenter);
              }

              Widget scrollTextAmountInUsedWidget() {
                final String moneyTypeStr = widget.amountAndProfitModel[amountAndProfitIndex].moneyType;
                final int place = findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!;
                final String amountStr = formatAndLimitNumberTextGlobal(
                  valueStr: widget.amountAndProfitModel[amountAndProfitIndex].amountInUsed.toString(),
                  isRound: false,
                  isAllowZeroAtLast: false,
                  places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                );
                return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("$usedStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                      Text("$amountStr $moneyTypeStr", style: textStyleGlobal(level: Level.normal, color: defaultTextFieldNoFucusColorGlobal)),
                    ]));
              }

              Widget scrollTextProfitWidget() {
                final String moneyTypeStr = widget.amountAndProfitModel[amountAndProfitIndex].moneyType;
                final Color colorProvider = (widget.amountAndProfitModel[amountAndProfitIndex].profit >= 0) ? positiveColorGlobal : negativeColorGlobal;
                final int place = findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!;
                final String profitStr = formatAndLimitNumberTextGlobal(
                  valueStr: widget.amountAndProfitModel[amountAndProfitIndex].profit.toString(),
                  isRound: false,
                  isAllowZeroAtLast: false,
                  places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                );
                return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("$profitIsStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                      Text("$profitStr $moneyTypeStr", style: textStyleGlobal(level: Level.normal, color: colorProvider)),
                    ]));
              }

              return Column(children: [moneyTypeTextWidget(), scrollTextAmountWidget(), scrollTextAmountInUsedWidget(), scrollTextProfitWidget()]);
            }

            void onTapUnlessDisable() {
              Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                Widget titleTextWidget() {
                  return Padding(
                    padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                    child: Text("$totalOfStrGlobal $moneyTypeStr", style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
                  );
                }

                Widget amountInUsedAndProfitWidget({required AmountInUsedAndProfitModel? amountInUsedAndProfitModel, required String title}) {
                  return (amountInUsedAndProfitModel == null)
                      ? Container()
                      : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(title, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)),
                            child: Row(children: [
                              Text("amount in used: ", style: textStyleGlobal(level: Level.normal)),
                              Text(
                                "${formatAndLimitNumberTextGlobal(valueStr: amountInUsedAndProfitModel.amountInUsed.toString(), isRound: false)} $moneyTypeStr",
                                style: textStyleGlobal(level: Level.normal, color: Colors.grey),
                              ),
                            ]),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal), bottom: paddingSizeGlobal(level: Level.normal)),
                            child: Row(children: [
                              Text("profit: ", style: textStyleGlobal(level: Level.normal)),
                              Text(
                                "${formatAndLimitNumberTextGlobal(valueStr: amountInUsedAndProfitModel.profit.toString(), isRound: false)} $moneyTypeStr",
                                style: textStyleGlobal(
                                  level: Level.normal,
                                  color: (amountInUsedAndProfitModel.profit >= 0) ? positiveColorGlobal : negativeColorGlobal,
                                ),
                              ),
                            ]),
                          ),
                        ]);
                }

                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleTextWidget(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                        child: Column(children: [
                          amountInUsedAndProfitWidget(
                            amountInUsedAndProfitModel: widget.amountAndProfitModel[amountAndProfitIndex].exchange,
                            title: "Exchange",
                          ),
                          amountInUsedAndProfitWidget(
                            amountInUsedAndProfitModel: widget.amountAndProfitModel[amountAndProfitIndex].sellCard,
                            title: "Sell Card",
                          ),
                          amountInUsedAndProfitWidget(
                            amountInUsedAndProfitModel: widget.amountAndProfitModel[amountAndProfitIndex].transfer,
                            title: "Transfer",
                          ),
                          amountInUsedAndProfitWidget(
                            amountInUsedAndProfitModel: widget.amountAndProfitModel[amountAndProfitIndex].excel,
                            title: "Excel",
                          ),
                        ]),
                      ),
                    ),
                  )
                ]);
              }

              void cancelFunctionOnTap() {
                closeDialogGlobal(context: context);
              }

              actionDialogSetStateGlobal(
                dialogHeight: dialogSizeGlobal(level: Level.mini),
                dialogWidth: dialogSizeGlobal(level: Level.mini),
                cancelFunctionOnTap: cancelFunctionOnTap,
                context: context,
                contentFunctionReturnWidget: contentFunctionReturnWidget,
              );
            }

            return CustomButtonGlobal(sizeBoxWidth: sizeBoxWidthGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
          }

          return (widget.amountAndProfitModel.isEmpty)
              ? Container()
              : customTotalListWidget(
                  titleStr: amountAndProfitStrGlobal,
                  totalListWidget: [
                    for (int amountAndProfitIndex = 0; amountAndProfitIndex < widget.amountAndProfitModel.length; amountAndProfitIndex++)
                      amountTextWidget(amountAndProfitIndex: amountAndProfitIndex)
                  ],
                );
        }

        bool isShowCard() {
          for (int companyIndex = 0; companyIndex < widget.cardModelList.length; companyIndex++) {
            for (int categoryIndex = 0; categoryIndex < widget.cardModelList[companyIndex].categoryList.length; categoryIndex++) {
              for (int mainIndexIndex = 0;
                  mainIndexIndex < widget.cardModelList[companyIndex].categoryList[categoryIndex].mainPriceList.length;
                  mainIndexIndex++) {
                if (widget.cardModelList[companyIndex].categoryList[categoryIndex].mainPriceList[mainIndexIndex].maxStock != 0) {
                  return true;
                }
              }
            }
          }
          return false;
        }

        Widget cardStockListWidget() {
          Widget cardWidget({required int cardIndex}) {
            Widget companyNameTextWidget() {
              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: Text(widget.cardModelList[cardIndex].cardCompanyName.text, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
              );
            }

            Widget categoryListWidget() {
              Widget categoryWidget({required int categoryIndex}) {
                final String categoryStr = widget.cardModelList[cardIndex].categoryList[categoryIndex].category.text;
                int stockNumber = widget.cardModelList[cardIndex].categoryList[categoryIndex].totalStock;
                // for (int mainStockIndex = 0;
                //     mainStockIndex < cardModelTemp.categoryList[categoryIndex].mainPriceList.length;
                //     mainStockIndex++) {
                //   stockNumber = stockNumber +
                // textEditingControllerToInt(controller: cardModelTemp.categoryList[categoryIndex].mainPriceList[mainStockIndex].stock)!;
                // }
                final String stockStr = formatAndLimitNumberTextGlobal(valueStr: stockNumber.toString(), isRound: false, isAllowZeroAtLast: false);
                return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text(categoryStr, style: textStyleGlobal(level: Level.normal))])),
                  Expanded(child: Text(": $stockStr", style: textStyleGlobal(level: Level.normal))),
                ]);
              }

              return Column(children: [
                for (int categoryIndex = 0; categoryIndex < widget.cardModelList[cardIndex].categoryList.length; categoryIndex++)
                  categoryWidget(categoryIndex: categoryIndex)
              ]);
            }

            void onTapUnlessDisable() {
              int categorySelectedIndex = 0;

              final CardModel cardModelTemp = cloneCardModel(cardIndex: cardIndex, cardModelList: widget.cardModelList);

              cardModelTemp.categoryList[categorySelectedIndex].skipCardMainStockList = queryLimitNumberGlobal;
              cardModelTemp.categoryList[categorySelectedIndex].outOfDataQueryCardMainStockList = false;
              for (int categoryIndex = 0; categoryIndex < widget.cardModelList[cardIndex].categoryList.length; categoryIndex++) {
                limitMainStockList(categoryCardModel: cardModelTemp.categoryList[categoryIndex]);
              }
              Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                Widget titleTextWidget() {
                  Widget dropDownCategoryWidget() {
                    void onTapFunction() {}
                    void onChangedFunction({required String value, required int index}) {
                      categorySelectedIndex = index;

                      limitMainStockList(categoryCardModel: cardModelTemp.categoryList[categorySelectedIndex]);
                      setStateFromDialog(() {});
                    }

                    return customDropdown(
                      level: Level.mini,
                      labelStr: categoryCardStrGlobal,
                      onTapFunction: onTapFunction,
                      onChangedFunction: onChangedFunction,
                      selectedStr: cardModelTemp.categoryList.isEmpty ? null : cardModelTemp.categoryList[categorySelectedIndex].category.text,
                      menuItemStrList: cardModelTemp.categoryList.map((e) => e.category.text).toList(),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                    child: Row(
                      children: [
                        Text(
                          "${cardModelTemp.cardCompanyName.text} x ",
                          style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: dropDownCategoryWidget()),
                        Text(
                          " | available: ${cardModelTemp.categoryList[categorySelectedIndex].totalStock}",
                          style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " | ordered: ${cardModelTemp.categoryList[categorySelectedIndex].ordered}",
                          style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " | Invoice: ${cardModelTemp.categoryList[categorySelectedIndex].count}/$maxInsertStockGlobal",
                          style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold),
                        ),
                      ], //TODO: change this
                    ),
                  );
                }

                Widget categoryListWidget({required int mainIndex}) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("${mainIndex + 1}. ", style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                    cardStockWidget(
                      companyIdStr: cardModelTemp.id!,
                      companyStr: cardModelTemp.cardCompanyName.text,
                      categoryIdStr: cardModelTemp.categoryList[categorySelectedIndex].id!,
                      categoryStr: cardModelTemp.categoryList[categorySelectedIndex].category.text,
                      mainPriceModel: cardModelTemp.categoryList[categorySelectedIndex].mainPriceList[mainIndex],
                    ),
                    drawLineGlobal(),
                  ]);
                }

                void bottomFunction() {
                  // if (!cardModelTemp.categoryList[categorySelectedIndex].outOfDataQueryCardMainStockList) {
                  //   //TODO: change this
                  //   final int beforeQuery = cardModelTemp.categoryList[categorySelectedIndex].mainPriceList.length; //TODO: change this
                  //   void callBack() {
                  //     final int afterQuery = cardModelTemp.categoryList[categorySelectedIndex].mainPriceList.length; //TODO: change this

                  //     if (beforeQuery == afterQuery) {
                  //       cardModelTemp.categoryList[categorySelectedIndex].outOfDataQueryCardMainStockList = true; //TODO: change this
                  //     } else {
                  //       cardModelTemp.categoryList[categorySelectedIndex].skipCardMainStockList += queryLimitNumberGlobal; //TODO: change this
                  //     }
                  //     setStateFromDialog(() {});
                  //   }

                  //   getMainCardListEmployeeGlobal(
                  //     callBack: callBack,
                  //     cardCompanyNameId: cardModelTemp.id!,
                  //     categoryId: cardModelTemp.categoryList[categorySelectedIndex].id!,
                  //     context: context,
                  //     skip: cardModelTemp.categoryList[categorySelectedIndex].skipCardMainStockList,
                  //     cardMainPriceListCardModelList: cardModelTemp.categoryList[categorySelectedIndex].mainPriceList,
                  //   ); //TODO: change this
                  // }
                  getMoreMainStockWithCondition(
                    targetDate: widget.isAdminEditing ? DateTime.now() : widget.targetDate,
                    cardCompanyNameId: cardModelTemp.id!,
                    categoryId: cardModelTemp.categoryList[categorySelectedIndex].id!,
                    categoryCardModel: cardModelTemp.categoryList[categorySelectedIndex],
                    context: context,
                    setStateFromDialog: setStateFromDialog,
                    isAdminQuery: widget.isAdminEditing,
                  );
                }

                void topFunction() {}

                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleTextWidget(),
                  Expanded(
                    child: wrapScrollDetectWidget(
                      inWrapWidgetList: [
                        for (int mainIndex = 0; mainIndex < cardModelTemp.categoryList[categorySelectedIndex].mainPriceList.length; mainIndex++)
                          categoryListWidget(mainIndex: mainIndex)
                      ],
                      bottomFunction: bottomFunction,
                      topFunction: topFunction,
                      isShowSeeMoreWidget: !cardModelTemp.categoryList[categorySelectedIndex].outOfDataQueryCardMainStockList,
                    ),
                  )
                ]);
              }

              void cancelFunctionOnTap() {
                limitMainStockList(categoryCardModel: cardModelTemp.categoryList[categorySelectedIndex]);
                closeDialogGlobal(context: context);
              }

              actionDialogSetStateGlobal(
                dialogHeight: dialogSizeGlobal(level: Level.mini),
                dialogWidth: dialogSizeGlobal(level: Level.mini) * 1.2,
                cancelFunctionOnTap: cancelFunctionOnTap,
                context: context,
                contentFunctionReturnWidget: contentFunctionReturnWidget,
              );
            }

            return CustomButtonGlobal(
                sizeBoxWidth: sizeBoxWidthGlobal,
                insideSizeBoxWidget: Column(children: [companyNameTextWidget(), categoryListWidget()]),
                onTapUnlessDisable: onTapUnlessDisable);
          }

          return isShowCard()
              ? customTotalListWidget(
                  titleStr: cardStockStrGlobal,
                  totalListWidget: [for (int cardIndex = 0; cardIndex < widget.cardModelList.length; cardIndex++) cardWidget(cardIndex: cardIndex)],
                )
              : Container();
        }

        Widget printMoneyAndCard() {
          void printFunction() {
            final DateTime currentDate = DateTime.now();
            printTotalHistoryInvoice(
              context: context,
              date: currentDate,
              remark: "history of ${formatDateDateToStr(date: widget.targetDate)}",
              cashModel: widget.cashModel,
              cardModelList: widget.cardModelList,
              amountAndProfitModel: widget.amountAndProfitModel,
              salaryList: widget.salaryHistoryList,
              displayBusinessOptionModel: widget.displayBusinessOptionModel!,
            );
          }

          return widget.isAdminEditing
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.normal)),
                  child: Container(
                    width: sizeBoxWidthGlobal,
                    child: printButtonOrContainerWidget(context: context, level: Level.mini, onTapFunction: printFunction, isExpanded: true),
                  ),
                );
        }

        Widget estimateWidget() {
          Widget insideSizeBoxWidget() {
            // Widget moneyTypeDropDownWidget() {
            //   void onTapFunction() {}
            //   void onChangedFunction({required String value, required int index}) {
            //     estimateMoneyType = value;
            //     setState(() {});
            //   }

            //   return Padding(
            //     padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
            //     child: Container(
            //       width: moneyTypeWidthSizeBoxGlobal,
            //       child: customDropdown(
            //         level: Level.mini,
            //         labelStr: moneyTypeStrGlobal,
            //         onTapFunction: onTapFunction,
            //         onChangedFunction: onChangedFunction,
            //         selectedStr: estimateMoneyType,
            //         menuItemStrList: moneyTypeOnlyList(),
            //       ),
            //     ),
            //   );
            // }

            Widget moneyTypeTextWidget() {
              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: Text(widget.cashModel.mergeBy!, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
              );
            }

            Widget scrollTextAmountWidget() {
              final String mergeStr = totalEstimateNumberToStr(
                totalNumber: totalEstimateStr(cashModel: widget.cashModel, amountAndProfitModel: widget.amountAndProfitModel),
                cashModel: widget.cashModel,
              );
              return scrollText(
                textStr: "$mergeIsStrGlobal $mergeStr ${widget.cashModel.mergeBy}",
                textStyle: textStyleGlobal(level: Level.normal),
                alignment: Alignment.topCenter,
              );
            }

            Widget scrollTextProfitWidget() {
              final double balanceNumber = totalEstimateCashMoneyStr(cashModel: widget.cashModel) -
                  totalEstimateStr(cashModel: widget.cashModel, amountAndProfitModel: widget.amountAndProfitModel);
              final Color colorProvider = (balanceNumber >= 0) ? positiveColorGlobal : negativeColorGlobal;
              return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("$balanceIsStrGlobal ", style: textStyleGlobal(level: Level.normal)),
                    Text(
                      "${totalEstimateNumberToStr(totalNumber: balanceNumber, cashModel: widget.cashModel)} ${widget.cashModel.mergeBy} ",
                      style: textStyleGlobal(level: Level.normal, color: colorProvider),
                    ),
                  ]));
            }

            return Column(children: [moneyTypeTextWidget(), scrollTextAmountWidget(), scrollTextProfitWidget()]);
          }

          void onTapUnlessDisable() {
            CashModel cashModelTemp = cloneCashModel(cashModel: widget.cashModel);
            void cancelButtonFunction() {
              if (widget.isCurrentDate && widget.isNotViewOnly) {
                void okFunction() {
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

            void saveButtonFunction() {
              void callBack() {
                closeDialogGlobal(context: context);
                setState(() {});
              }

              updateCashGlobal(callBack: callBack, context: context, cashModel: cashModelTemp);
            }

            String? moneyTypeElement = (cashModelTemp.cashList.isEmpty) ? null : cashModelTemp.cashList.first.moneyType;

            ValidButtonModel validToSaveRate() {
              if (cashModelTemp.cashList.isEmpty) {
                // return false;
              } else {
                bool isAllEmpty = true;
                for (int cashIndex = 0; cashIndex < cashModelTemp.cashList.length; cashIndex++) {
                  if (cashModelTemp.cashList[cashIndex].moneyList.isNotEmpty) {
                    isAllEmpty = false;
                  }
                }
                if (isAllEmpty) {
                  // return false;
                }
              }
              for (int cashIndex = 0; cashIndex < cashModelTemp.cashList.length; cashIndex++) {
                // if (cashModelTemp.mergeBy != cashModelTemp.cashList[cashIndex].moneyType) {}
                for (int moneyIndex = 0; moneyIndex < cashModelTemp.cashList[cashIndex].moneyList.length; moneyIndex++) {
                  if (cashModelTemp.cashList[cashIndex].moneyList[moneyIndex].text.isEmpty) {
                    // return false;
                    return ValidButtonModel(
                      isValid: false,
                      errorType: ErrorTypeEnum.valueOfNumber,
                      error: "money is empty",
                      errorLocationList: [
                        TitleAndSubtitleModel(title: "money type", subtitle: cashModelTemp.cashList[cashIndex].moneyType),
                        TitleAndSubtitleModel(title: "money index", subtitle: moneyIndex.toString()),
                        TitleAndSubtitleModel(title: "money", subtitle: cashModelTemp.cashList[cashIndex].moneyList[moneyIndex].text),
                      ],
                    );
                  } else {
                    if (textEditingControllerToDouble(controller: cashModelTemp.cashList[cashIndex].moneyList[moneyIndex]) == 0) {
                      // return false;
                      return ValidButtonModel(
                        isValid: false,
                        errorType: ErrorTypeEnum.valueOfNumber,
                        error: "money equal 0",
                        errorLocationList: [
                          TitleAndSubtitleModel(title: "money type", subtitle: cashModelTemp.cashList[cashIndex].moneyType),
                          TitleAndSubtitleModel(title: "money index", subtitle: moneyIndex.toString()),
                          TitleAndSubtitleModel(title: "money", subtitle: cashModelTemp.cashList[cashIndex].moneyList[moneyIndex].text),
                        ],
                      );
                    }
                  }
                }
                if (cashModelTemp.mergeBy != cashModelTemp.cashList[cashIndex].moneyType) {
                  RateModel rateModel = getRateModel(rateTypeFirst: cashModelTemp.mergeBy!, rateTypeLast: cashModelTemp.cashList[cashIndex].moneyType)!;
                  final double limitFirstNumber = textEditingControllerToDouble(controller: rateModel.limit.first)!;
                  final double limitLastNumber = textEditingControllerToDouble(controller: rateModel.limit.last)!;
                  final double averageRateTemp = textEditingControllerToDouble(controller: cashModelTemp.cashList[cashIndex].averageRate)!;
                  final bool isValidateBetweenLimit = (limitFirstNumber <= averageRateTemp && averageRateTemp <= limitLastNumber);
                  if (!isValidateBetweenLimit) {
                    // return false;
                    return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.compareNumber, error: "rate not between limit", errorLocationList: [
                      TitleAndSubtitleModel(title: "money type", subtitle: cashModelTemp.cashList[cashIndex].moneyType),
                      // TitleAndSubtitleModel(title: "rate type first", subtitle: rateModel.rateType.first),
                      // TitleAndSubtitleModel(title: "rate type last", subtitle: rateModel.rateType.last),
                      TitleAndSubtitleModel(title: "rate limit first", subtitle: rateModel.limit.first.text),
                      TitleAndSubtitleModel(title: "rate limit last", subtitle: rateModel.limit.last.text),
                      TitleAndSubtitleModel(title: "rate average", subtitle: cashModelTemp.cashList[cashIndex].averageRate.text),
                    ], detailList: [
                      TitleAndSubtitleModel(
                        title: "${rateModel.limit.first.text} <= ${cashModelTemp.cashList[cashIndex].averageRate} <= ${rateModel.limit.last}",
                        subtitle: "invalid compare",
                      ),
                    ]);
                  }
                }
              }

              //check same value
              //note: all value never be null
              final String? mergeByTemp = cashModelTemp.mergeBy;
              final String? mergeBy = widget.cashModel.mergeBy;
              final bool isMergeByNotSameValue = (mergeByTemp != mergeBy);
              if (isMergeByNotSameValue) {
                // return true;
                return ValidButtonModel(isValid: true);
              }
              final int cashListLengthTemp = cashModelTemp.cashList.length;
              final int cashListLength = widget.cashModel.cashList.length;
              final isCashListLengthNotSameValue = (cashListLengthTemp != cashListLength);
              if (isCashListLengthNotSameValue) {
                // return true;
                return ValidButtonModel(isValid: true);
              }
              for (int cashElementIndex = 0; cashElementIndex < cashModelTemp.cashList.length; cashElementIndex++) {
                final String moneyTypeTemp = cashModelTemp.cashList[cashElementIndex].moneyType;
                final String moneyType = widget.cashModel.cashList[cashElementIndex].moneyType;
                final bool isMoneyTempNotSameValue = (moneyTypeTemp != moneyType);

                final bool isBuyRateTemp = cashModelTemp.cashList[cashElementIndex].isBuyRate;
                final bool isBuyRate = widget.cashModel.cashList[cashElementIndex].isBuyRate;
                final bool isBuyRateTempNotSameValue = (isBuyRateTemp != isBuyRate);

                final double averageRateTemp = textEditingControllerToDouble(controller: cashModelTemp.cashList[cashElementIndex].averageRate)!;
                final double averageRate = textEditingControllerToDouble(controller: widget.cashModel.cashList[cashElementIndex].averageRate)!;
                final bool isAverageRateTempNotSameValue = (averageRateTemp != averageRate);

                if (isMoneyTempNotSameValue || isBuyRateTempNotSameValue || isAverageRateTempNotSameValue) {
                  // return true;
                  return ValidButtonModel(isValid: true);
                }

                final isMoneyListLengthNotSameValue =
                    (cashModelTemp.cashList[cashElementIndex].moneyList.length != widget.cashModel.cashList[cashElementIndex].moneyList.length);
                if (isMoneyListLengthNotSameValue) {
                  // return true;
                  return ValidButtonModel(isValid: true);
                }
                for (int moneyIndex = 0; moneyIndex < cashModelTemp.cashList[cashElementIndex].moneyList.length; moneyIndex++) {
                  final double moneyValueTemp = textEditingControllerToDouble(controller: cashModelTemp.cashList[cashElementIndex].moneyList[moneyIndex])!;
                  final double moneyValue = textEditingControllerToDouble(controller: widget.cashModel.cashList[cashElementIndex].moneyList[moneyIndex])!;
                  final bool isMoneyTypeNotSameValue = (moneyValueTemp != moneyValue);
                  if (isMoneyTypeNotSameValue) {
                    // return true;
                    return ValidButtonModel(isValid: true);
                  }
                }
              }

              //nothing change so return false
              // return false;
              return ValidButtonModel(isValid: false, errorType: ErrorTypeEnum.nothingChange);
            }

            Widget contentDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
              int matchIndex = findMoneyTypeIndexByMoneyType(moneyType: moneyTypeElement, cashModel: cashModelTemp);

              Widget scrollTextProfitWidget() {
                Widget moneyTypeDropDownWidget() {
                  void onTapFunction() {}
                  void onChangedFunction({required String value, required int index}) {
                    void okFunction() {
                      cashModelTemp.mergeBy = value;
                      cashModelTemp.cashList = [];
                      moneyTypeElement = null;
                      setStateFromDialog(() {});
                    }

                    void cancelFunction() {}
                    confirmationDialogGlobal(
                      context: context,
                      okFunction: okFunction,
                      cancelFunction: cancelFunction,
                      titleStr: changeMoneyTypeStrGlobal,
                      subtitleStr: changeMoneyTypeConfirmGlobal,
                    );
                  }

                  return SizedBox(
                    width: moneyTypeWidthSizeBoxGlobal,
                    child: (widget.isCurrentDate && widget.isNotViewOnly)
                        ? customDropdown(
                            level: Level.normal,
                            labelStr: moneyTypeStrGlobal,
                            onTapFunction: onTapFunction,
                            onChangedFunction: onChangedFunction,
                            selectedStr: cashModelTemp.mergeBy!,
                            menuItemStrList: moneyTypeOnlyList(moneyTypeDefault: cashModelTemp.mergeBy, isNotCheckDeleted: widget.isAdminEditing),
                          )
                        : textFieldGlobal(
                            isEnabled: false,
                            controller: TextEditingController(text: cashModelTemp.mergeBy!),
                            onChangeFromOutsiderFunction: () {},
                            labelText: moneyTypeStrGlobal,
                            level: Level.normal,
                            textFieldDataType: TextFieldDataType.str,
                            onTapFromOutsiderFunction: () {},
                          ),
                  );
                }

                final double balanceNumber = totalEstimateCashMoneyStr(cashModel: cashModelTemp) -
                    totalEstimateStr(cashModel: cashModelTemp, amountAndProfitModel: widget.amountAndProfitModel);
                final Color colorProvider = (balanceNumber >= 0) ? positiveColorGlobal : negativeColorGlobal;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("$balanceIsStrGlobal ", style: textStyleGlobal(level: Level.large)),
                    Text("${totalEstimateNumberToStr(totalNumber: balanceNumber, cashModel: cashModelTemp)} ",
                        style: textStyleGlobal(level: Level.large, color: colorProvider)),
                    moneyTypeDropDownWidget(),
                    // TextButton(
                    //     onPressed: () {
                    //       for (int amountAndProfitIndex = 0; amountAndProfitIndex < widget.amountAndProfitModel.length; amountAndProfitIndex++) {
                    //         final int moneyTypeIndex = cashModelTemp.cashList
                    //             .indexWhere((element) => (element.moneyType == widget.amountAndProfitModel[amountAndProfitIndex].moneyType)); //never equal -1

                    //         final int place = findMoneyModelByMoneyType(moneyType: widget.amountAndProfitModel[amountAndProfitIndex].moneyType).decimalPlace!;
                    //         cashModelTemp.cashList[moneyTypeIndex].moneyList = [
                    //           TextEditingController(
                    //             text: formatAndLimitNumberTextGlobal(
                    //               valueStr: widget.amountAndProfitModel[amountAndProfitIndex].amount.toString(),
                    //               isRound: false,
                    //               isAllowZeroAtLast: false,
                    //               places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
                    //             ),
                    //           )
                    //         ];
                    //       }
                    //       setStateFromDialog(() {});
                    //     },
                    //     child: Text("merge")),
                  ]),
                );
              }

              Widget moneyTypeByMoneyTypeWidget() {
                final int castIndex = cashModelTemp.cashList.indexWhere((element) => (element.moneyType == moneyTypeElement)); //never equal -1
                double totalNumber = 0;
                String totalStr = "0";
                if (castIndex != -1 && moneyTypeElement != null) {
                  for (int moneyIndex = 0; moneyIndex < cashModelTemp.cashList[castIndex].moneyList.length; moneyIndex++) {
                    if (cashModelTemp.cashList[castIndex].moneyList[moneyIndex].text.isEmpty) {
                      totalNumber = 0;
                      break;
                    } else {
                      totalNumber = totalNumber + textEditingControllerToDouble(controller: cashModelTemp.cashList[castIndex].moneyList[moneyIndex])!;
                    }
                  }
                  totalStr = formatAndLimitNumberTextGlobal(valueStr: totalNumber.toString(), isRound: false);
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("$totalsStrGlobal ", style: textStyleGlobal(level: Level.large)),
                    Text("$totalStr ${moneyTypeElement ?? ""}", style: textStyleGlobal(level: Level.large)),
                  ]),
                );
              }

              Widget rateAndMoneyTypeWidget() {
                Widget valueAndMoneyTypeWidget() {
                  Widget amountTextFieldWidget() {
                    void onChangeFromOutsiderFunction() {
                      setStateFromDialog(() {});
                    }

                    void onTapFromOutsiderFunction() {}
                    return Padding(
                      padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
                      child: textFieldGlobal(
                        isEnabled: (widget.isCurrentDate && widget.isNotViewOnly),
                        textFieldDataType: TextFieldDataType.double,
                        controller: cashModelTemp.cashList[matchIndex].averageRate,
                        onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                        labelText: amountStrGlobal,
                        level: Level.normal,
                        onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                      ),
                    );
                  }

                  Widget moneyTypeDropDownWidget() {
                    void onTapFunction() {}
                    void onChangedFunction({required String value, required int index}) {
                      moneyTypeElement = value;
                      if (findMoneyTypeIndexByMoneyType(moneyType: moneyTypeElement, cashModel: cashModelTemp) == -1) {
                        RateModel? rateModel = getRateModel(rateTypeFirst: moneyTypeElement!, rateTypeLast: cashModelTemp.mergeBy!);
                        double averageRateNumber = 1;
                        bool isMulti = true;
                        if (rateModel != null) {
                          if (rateModel.buy != null && rateModel.sell != null) {
                            isMulti = moneyTypeElement == rateModel.rateType.first;
                            averageRateNumber = (textEditingControllerToDouble(controller: rateModel.buy!.value)! +
                                    textEditingControllerToDouble(controller: rateModel.sell!.value)!) /
                                2;
                          }
                        }
                        cashModelTemp.cashList.add(CashList(
                          isBuyRate: isMulti,
                          moneyType: moneyTypeElement!,
                          moneyList: [],
                          averageRate: TextEditingController(
                              text: formatAndLimitNumberTextGlobal(valueStr: averageRateNumber.toString(), isRound: true, isAllowZeroAtLast: false)),
                        ));
                      }
                      setStateFromDialog(() {});
                    }

                    return
                        // (widget.isCurrentDate && widget.isNotViewOnly)
                        //     ?
                        customDropdown(
                      level: Level.normal,
                      labelStr: moneyTypeStrGlobal,
                      onTapFunction: onTapFunction,
                      onChangedFunction: onChangedFunction,
                      selectedStr: moneyTypeElement,
                      menuItemStrList: moneyTypeOnlyList(moneyTypeDefault: moneyTypeElement, isNotCheckDeleted: widget.isAdminEditing),
                    )
                        // : textFieldGlobal(
                        //     isEnabled: false,
                        //     controller: TextEditingController(text: moneyTypeElement),
                        //     onChangeFromOutsiderFunction: () {},
                        //     labelText: moneyTypeStrGlobal,
                        //     level: Level.normal,
                        //     textFieldDataType: TextFieldDataType.str,
                        //     onTapFromOutsiderFunction: () {},
                        //   )
                        ;
                  }

                  return Padding(
                    padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                    child: Row(children: [
                      ((moneyTypeElement == null) || (moneyTypeElement == cashModelTemp.mergeBy))
                          ? Container()
                          : Expanded(flex: flexValueGlobal, child: amountTextFieldWidget()),
                      Expanded(flex: flexTypeGlobal, child: moneyTypeDropDownWidget())
                    ]),
                  );
                }

                return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)), child: valueAndMoneyTypeWidget());
              }

              Widget valueAndMoneyTypeListWidget() {
                Widget textFieldMoneyTypeAndDeleteWidget({required int moneyIndex}) {
                  void onTapUnlessDisable() {}
                  void onDeleteUnlessDisable() {
                    cashModelTemp.cashList[matchIndex].moneyList.removeAt(moneyIndex);
                    setStateFromDialog(() {});
                  }

                  Widget insideSizeBoxWidget() {
                    void onChangeFromOutsiderFunction() {
                      setStateFromDialog(() {});
                    }

                    void onTapFromOutsiderFunction() {}
                    return textFieldGlobal(
                      isEnabled: (widget.isCurrentDate && widget.isNotViewOnly),
                      labelText: amountStrGlobal,
                      level: Level.mini,
                      controller: cashModelTemp.cashList[matchIndex].moneyList[moneyIndex],
                      onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                      textFieldDataType: TextFieldDataType.double,
                      onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                    );
                  }

                  return CustomButtonGlobal(
                    level: Level.mini,
                    isDisable: true,
                    insideSizeBoxWidget: insideSizeBoxWidget(),
                    onTapUnlessDisable: onTapUnlessDisable,
                    onDeleteUnlessDisable: (widget.isCurrentDate && widget.isNotViewOnly) ? onDeleteUnlessDisable : null,
                  );
                }

                Widget paddingBottomAddButtonWidget() {
                  Widget addButtonWidget() {
                    void onTapFunction() {
                      cashModelTemp.cashList[matchIndex].moneyList.add(TextEditingController());
                      setStateFromDialog(() {});
                    }

                    ValidButtonModel checkDiscountOptionFunction() {
                      // if (moneyTypeElement == null) {
                      //   return false;
                      // }
                      if (matchIndex != -1) {
                        for (int moneyIndex = 0; moneyIndex < cashModelTemp.cashList[matchIndex].moneyList.length; moneyIndex++) {
                          if (cashModelTemp.cashList[matchIndex].moneyList[moneyIndex].text.isEmpty) {
                            // return false;
                            return ValidButtonModel(
                              isValid: false,
                              errorType: ErrorTypeEnum.valueOfNumber,
                              error: "money is empty.",
                              errorLocationList: [
                                TitleAndSubtitleModel(title: "money type", subtitle: cashModelTemp.cashList[matchIndex].moneyType),
                                TitleAndSubtitleModel(title: "money index", subtitle: moneyIndex.toString()),
                                TitleAndSubtitleModel(title: "money", subtitle: cashModelTemp.cashList[matchIndex].moneyList[moneyIndex].text),
                              ],
                            );
                          } else {
                            if (textEditingControllerToDouble(controller: cashModelTemp.cashList[matchIndex].moneyList[moneyIndex]) == 0) {
                              // return false;
                              return ValidButtonModel(
                                isValid: false,
                                errorType: ErrorTypeEnum.valueOfNumber,
                                error: "money equal 0.",
                                errorLocationList: [
                                  TitleAndSubtitleModel(title: "money type", subtitle: cashModelTemp.cashList[matchIndex].moneyType),
                                  TitleAndSubtitleModel(title: "money index", subtitle: moneyIndex.toString()),
                                  TitleAndSubtitleModel(title: "money", subtitle: cashModelTemp.cashList[matchIndex].moneyList[moneyIndex].text),
                                ],
                              );
                            }
                          }
                        }
                      }
                      // return true;
                      if (!widget.isCurrentDate) {
                        return ValidButtonModel(isValid: false, error: "Date is not current date.");
                      }
                      if (!widget.isNotViewOnly) {
                        return ValidButtonModel(isValid: false, error: "View only mode.");
                      }

                      if(widget.isAdminEditing) {
                        return ValidButtonModel(isValid: false, error: "Admin editing mode.");    
                      }

                      return ValidButtonModel(isValid: true);
                    }

                    return addButtonOrContainerWidget(
                      context: context,
                      validModel: checkDiscountOptionFunction(),
                      level: Level.mini,
                      isExpanded: true,
                      onTapFunction: onTapFunction,
                      currentAddButtonQty: cashModelTemp.cashList[matchIndex].moneyList.length,
                      maxAddButtonLimit: cashMoneyAddButtonLimitGlobal,
                    );
                  }

                  return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)), child: addButtonWidget());
                }

                Widget moneyListWidget() {
                  return Column(children: [
                    for (int moneyIndex = 0; moneyIndex < cashModelTemp.cashList[matchIndex].moneyList.length; moneyIndex++)
                      textFieldMoneyTypeAndDeleteWidget(moneyIndex: moneyIndex),
                  ]);
                }

                return (matchIndex == -1)
                    ? Container()
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                              padding: EdgeInsets.all(paddingSizeGlobal(level: Level.normal)),
                              child: Column(children: [moneyListWidget(), paddingBottomAddButtonWidget()])),
                        ),
                      );
              }

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [scrollTextProfitWidget(), moneyTypeByMoneyTypeWidget(), rateAndMoneyTypeWidget(), valueAndMoneyTypeListWidget()]);
            }

            actionDialogSetStateGlobal(
              dialogHeight: dialogSizeGlobal(level: Level.mini),
              dialogWidth: dialogSizeGlobal(level: Level.mini),
              context: context,
              contentFunctionReturnWidget: contentDialog,
              cancelFunctionOnTap: cancelButtonFunction,
              validSaveButtonFunction: () => validToSaveRate(),
              saveFunctionOnTap: (widget.isCurrentDate && widget.isNotViewOnly) ? saveButtonFunction : null,
            );
          }

          return (widget.amountAndProfitModel.isEmpty)
              ? Container()
              : customTotalListWidget(
                  titleStr: estimateStrGlobal,
                  totalListWidget: [
                    CustomButtonGlobal(sizeBoxWidth: sizeBoxWidthGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable)
                  ],
                );
        }

        final bool isShowTotalList = (isShowCard() || widget.amountAndProfitModel.isNotEmpty);

        return isShowTotalList
            ? SingleChildScrollView(child: Column(children: [estimateWidget(), totalAndProfitListWidget(), cardStockListWidget(), printMoneyAndCard()]))
            : null;
      }

      void topFunction() {}

      void bottomFunction() {
        if (!outOfDataQueryHistoryList) {
          final int beforeQuery = widget.historyList.length;
          void callBack() {
            final int afterQuery = widget.historyList.length;

            if (beforeQuery == afterQuery) {
              outOfDataQueryHistoryList = true;
            } else {
              skipHistoryList = skipHistoryList + queryLimitNumberGlobal;
            }
            setState(() {});
          }

          getHistoryTodayEmployeeGlobal(
            callBack: callBack,
            context: context,
            skip: skipHistoryList,
            employeeId: widget.employeeId,
            historyList: widget.historyList,
            targetDate: widget.targetDate,
          );
        }
      }

      ValidButtonModel isValidHistoryAsyncOnTap() {
        if (widget.firstDate != null) {
          final DateTime today = DateTime.now();
          if (widget.firstDate!.year == today.year && widget.firstDate!.month == today.month && widget.firstDate!.day == today.day) {
            // return false;
            return ValidButtonModel(isValid: false, error: "First date is today.");
          }

          // return true;
          return ValidButtonModel(isValid: true);
        }
        // return false;
        return ValidButtonModel(isValid: false, error: "First date is null.");
      }

      return BodyTemplateSideMenu(
        title: formatDateDateToStr(date: widget.targetDate),
        inWrapWidgetList: inWrapWidgetList(),
        customRowBetweenHeaderAndBodyWidget: customRowBetweenHeaderAndBodyWidget(),
        topFunction: topFunction,
        bottomFunction: bottomFunction,
        historyAsyncOnTapFunction:
            ((widget.isCurrentDate || !widget.isNotViewOnly) && widget.isForceShowHistory) ? () => historyAsyncOnTapFunction(isNeedHistory: true) : null,
        isValidHistoryAsyncOnTap: isValidHistoryAsyncOnTap(),
        isShowSeeMoreWidget: !outOfDataQueryHistoryList,
      );
    }

    return bodyTemplateSideMenu();
  }
}

class InvoiceOption {
  InvoiceEnum invoiceType;
  String title;

  InvoiceOption({required this.invoiceType, required this.title});
}
