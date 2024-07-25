enum InvoiceEnum { allHistory, salary, rate, mission, print, exchange, transfer, sellCard, borrowOrLend, giveMoneyToMat, giveCardToMat, otherInOrOutCome, cardMainStock, importFromExcel }

const String exchangeTitleGlobal = "Exchange Money";
const String transferTitleGlobal = "Transfer Money";
const String cardMainStockTitleGlobal = "Insert Card Stock";
const String sellCardTitleGlobal = "Sell Card";
const String borrowOrLendTitleGlobal = "Outsider Borrow or Lend";
const String borrowTitleGlobal = "Outsider Borrowing";
const String lendTitleGlobal = "Outsider Lending";
const String giveMoneyToMatTitleGlobal = "Give Money to Mat";
const String getMoneyFromMatTitleGlobal = "Get Money From Mat";
const String giveCardToMatTitleGlobal = "Give Card to Mat";
const String getCardFromMatTitleGlobal = "Get Card From Mat";
const String otherInOrOutComeTitleGlobal = "Other Income or Outcome";
const String otherIncomeTitleGlobal = "Other Income";
const String otherOutcomeTitleGlobal = "Other Outcome";
const String importFromExcelTitleGlobal = "Import From Excel";
const String allHistoryTitleGlobal = "All History";
const String salaryTitleGlobal = "Salary Configuration";
const String rateTitleGlobal = "Rate";
const String missionTitleGlobal = "Mission";
const String printTitleGlobal = "Print";

//----------------------invoice type--------------------------------
const String allHistoryQueryGlobal = "all_history";
const String salaryQueryGlobal = "salary_configuration";
const String rateQueryGlobal = "rate";
const String missionQueryGlobal = "mission";
const String printQueryGlobal = "print";

const String exchangeQueryGlobal = "exchange";
const String transferQueryGlobal = "transfer";
const String cardMainStockQueryGlobal = "card_main_stock";
const String sellCardQueryGlobal = "sell_card";
const String borrowOrLendQueryGlobal = "borrow_or_lend";
const String giveMoneyToMatQueryGlobal = "give_money_to_mat";
const String giveCardToMatQueryGlobal = "give_card_to_mat";
const String otherInOrOutComeQueryGlobal = "other_in_or_out_come";
const String excelQueryGlobal = "excel";

String invoiceTypeStrGlobal({required InvoiceEnum invoiceEnum}) {
  switch (invoiceEnum) {
    case InvoiceEnum.allHistory:
      return allHistoryQueryGlobal;
    case InvoiceEnum.salary:
      return salaryQueryGlobal;
    case InvoiceEnum.rate:
      return rateQueryGlobal;
    case InvoiceEnum.mission:
      return missionQueryGlobal;
    case InvoiceEnum.print:
      return printQueryGlobal;
    case InvoiceEnum.exchange:
      return exchangeQueryGlobal;
    case InvoiceEnum.transfer:
      return transferQueryGlobal;
    case InvoiceEnum.sellCard:
      return sellCardQueryGlobal;
    case InvoiceEnum.borrowOrLend:
      return borrowOrLendQueryGlobal;
    case InvoiceEnum.giveMoneyToMat:
      return giveMoneyToMatQueryGlobal;
    case InvoiceEnum.giveCardToMat:
      return giveCardToMatQueryGlobal;
    case InvoiceEnum.otherInOrOutCome:
      return otherInOrOutComeQueryGlobal;
    case InvoiceEnum.cardMainStock:
      return cardMainStockQueryGlobal;
    case InvoiceEnum.importFromExcel:
      return excelQueryGlobal;
  }
}

String invoiceTitleStrGlobal({required InvoiceEnum invoiceEnum}) {
  switch (invoiceEnum) {
    case InvoiceEnum.allHistory:
      return allHistoryTitleGlobal;
    case InvoiceEnum.salary:
      return salaryTitleGlobal;
    case InvoiceEnum.rate:
      return rateTitleGlobal;
    case InvoiceEnum.mission:
      return missionTitleGlobal;
    case InvoiceEnum.print:
      return printTitleGlobal;
    case InvoiceEnum.exchange:
      return exchangeTitleGlobal;
    case InvoiceEnum.transfer:
      return transferTitleGlobal;
    case InvoiceEnum.sellCard:
      return sellCardTitleGlobal;
    case InvoiceEnum.borrowOrLend:
      return borrowOrLendTitleGlobal;
    case InvoiceEnum.giveMoneyToMat:
      return giveMoneyToMatTitleGlobal;
    case InvoiceEnum.giveCardToMat:
      return giveCardToMatTitleGlobal;
    case InvoiceEnum.otherInOrOutCome:
      return otherInOrOutComeTitleGlobal;
    case InvoiceEnum.cardMainStock:
      return cardMainStockTitleGlobal;
    case InvoiceEnum.importFromExcel:
      return importFromExcelTitleGlobal;
  }
}


InvoiceEnum? invoiceTypeQueryGlobal({required String invoiceStr}) {
  switch (invoiceStr) {
    case exchangeQueryGlobal:
      return InvoiceEnum.exchange;
    case transferQueryGlobal:
      return InvoiceEnum.transfer;
    case sellCardQueryGlobal:
      return InvoiceEnum.sellCard;
    case borrowOrLendQueryGlobal:
      return InvoiceEnum.borrowOrLend;
    case giveMoneyToMatQueryGlobal:
      return InvoiceEnum.giveMoneyToMat;
    case giveCardToMatQueryGlobal:
      return InvoiceEnum.giveCardToMat;
    case otherInOrOutComeQueryGlobal:
      return InvoiceEnum.otherInOrOutCome;
    case cardMainStockQueryGlobal:
      return InvoiceEnum.cardMainStock;
    case excelQueryGlobal:
      return InvoiceEnum.importFromExcel;
  }
}