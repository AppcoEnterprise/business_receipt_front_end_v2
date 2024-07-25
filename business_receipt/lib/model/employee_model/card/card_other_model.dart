import 'package:business_receipt/model/admin_model/rate_model.dart';

class CountMoneyType {
  String moneyType;
  int count;
  CountMoneyType({required this.moneyType, required this.count});
}

class BuyAndSellDiscountRate {
  List<String> rateType;
  RateForCalculateModel buy;
  RateForCalculateModel sell;
  BuyAndSellDiscountRate({required this.buy, required this.sell, required this.rateType});
}
