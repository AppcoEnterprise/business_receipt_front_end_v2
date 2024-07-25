// To parse this JSON data, do
//
//     final cardMainStockModel = cardMainStockModelFromJson(jsonString);

import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'dart:convert';

List<InformationAndCardMainStockModel> informationAndCardMainStockModelListFromJson({required dynamic str}) =>
    List<InformationAndCardMainStockModel>.from(json.decode(json.encode(str)).map((x) => InformationAndCardMainStockModel.fromJson(x)));
InformationAndCardMainStockModel informationAndCardMainStockModelFromJson({required dynamic str}) => InformationAndCardMainStockModel.fromJson(json.decode(json.encode(str)));

List<dynamic> informationAndCardMainStockModelToJson({required List<InformationAndCardMainStockModel> data}) => List<dynamic>.from(data.map((x) => x.toJson()));

class InformationAndCardMainStockModel {
  String cardCompanyNameId;
  String categoryId;
  CardMainPriceListCardModel mainPrice;
  String cardCompanyName;
  // String language;
  double category;

  InformationAndCardMainStockModel({
    required this.cardCompanyNameId,
    required this.categoryId,
    required this.mainPrice,
    required this.cardCompanyName,
    // required this.language,
    required this.category,
  });

  factory InformationAndCardMainStockModel.fromJson(Map<String, dynamic> json) {
    // print("json => $json");
    return InformationAndCardMainStockModel(
      cardCompanyNameId: json["card_company_name_id"],
      categoryId: json["category_id"],
      mainPrice: CardMainPriceListCardModel.fromJson(json["main_price"]),
      cardCompanyName: json["card_company_name"],
      // language: json["language"],
      category: json["category"],
    );
  }

  Map<String, dynamic> toJson() => {
        "card_company_name_id": cardCompanyNameId,
        "category_id": categoryId,
        "main_price": mainPrice.toJson(),
        "card_company_name": cardCompanyName,
        // "language": language,
        "category": category,
      };
}

// class CardMainStockModel {
//   bool isDelete;
//   TextEditingController remark;
//   String id;
//   String employeeIdAddStock;
//   String moneyType;
//   int maxStock;
//   double price;
//   int stock;
//   List<RateForCalculateModel> rateList;
//   DateTime date;
//   DateTime? dateOld;
//   String? overwriteOnId;

//   CardMainStockModel({
//     required this.remark,
//     this.dateOld,
//     required this.isDelete,
//     required this.employeeIdAddStock,
//     required this.id,
//     required this.moneyType,
//     required this.maxStock,
//     required this.price,
//     required this.stock,
//     required this.rateList,
//     required this.date,
//     this.overwriteOnId,
//   });

//   factory CardMainStockModel.fromJson(Map<String, dynamic> json) {
//     return CardMainStockModel(
//       remark: TextEditingController(text: json["remark"]),
//       overwriteOnId: (json["overwrite_on_id"] == null) ? null : json["overwrite_on_id"],
//       isDelete: (json["is_delete"] == null) ? false : json["is_delete"],
//       id: json["_id"],
//       employeeIdAddStock: json["employee_id_add_stock"],
//       moneyType: json["money_type"],
//       maxStock: json["max_stock"],
//       price: json["price"],
//       stock: json["stock"],
//       rateList: List<RateForCalculateModel>.from(json["rate_list"].map((x) => RateForCalculateModel.fromJson(x))),
//       date: DateTime.parse(json["date"]),
//       dateOld: (json["date_old"] == null) ? null : DateTime.parse(json["date_old"]),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "remark": remark.text,
//         "is_delete": isDelete,
//         "_id": id,
//         "employee_id_add_stock": employeeIdAddStock,
//         "money_type": moneyType,
//         "max_stock": maxStock,
//         "price": price,
//         "stock": stock,
//         "rate_list": List<dynamic>.from(rateList.map((x) => x.toJson())),
//         "date_old": (dateOld == null) ? null : dateOld!.toIso8601String(),
//         "date": date.toIso8601String(),
//       };
// }
