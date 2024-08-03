enum DateTypeEnum { day, month, year, all }

List<String> dateTypeStrList = ["Day", "Month", "Year", "All"];

enum ChartTypeEnum { profit, count, exchange, card, transfer, excel }

List<String> chartTypeStrList = ["Profit", "Count", "Exchange", "Card", "Transfer", "Excel"];

  DateTypeEnum getDateTypeEnumByIndex({required int index}) {
    switch (index) {
      case 0:
        return DateTypeEnum.day;
      case 1:
        return DateTypeEnum.month;
      case 2:
        return DateTypeEnum.year;
      default:
        return DateTypeEnum.all;
    }
  }
