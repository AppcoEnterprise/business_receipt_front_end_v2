// To parse this JSON data, do
//
//     final adminOrEmployeeListAskingForChange = adminOrEmployeeListAskingForChangeFromJson(jsonString);

import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'dart:convert';

List<AdminOrEmployeeListAskingForChange> adminOrEmployeeListAskingForChangeFromJsonList({required dynamic str}) =>
    List<AdminOrEmployeeListAskingForChange>.from(json.decode(json.encode(str)).map((x) => AdminOrEmployeeListAskingForChange.fromJson(x)));

String adminOrEmployeeListAskingForChangeToJsonList(List<AdminOrEmployeeListAskingForChange> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

AdminOrEmployeeListAskingForChange adminOrEmployeeListAskingForChangeFromJson({required dynamic str}) =>
    AdminOrEmployeeListAskingForChange.fromJson(json.decode(json.encode(str)));

String adminOrEmployeeListAskingForChangeToJson(AdminOrEmployeeListAskingForChange data) => json.encode(data.toJson());

class AdminOrEmployeeListAskingForChange {
  String id;
  bool isOnline;
  String name;
  bool isAskingForChange;
  String? acceptIdForChange;
  String? editSettingType;
  String? targetEmployeeId;
  DisplayBusinessOptionProfileEmployeeModel? displayBusinessOptionModel;

  AdminOrEmployeeListAskingForChange({
    required this.id,
    required this.isOnline,
    required this.name,
    required this.isAskingForChange,
    required this.acceptIdForChange,
    required this.editSettingType,
    required this.targetEmployeeId,
    required this.displayBusinessOptionModel,
  });

  factory AdminOrEmployeeListAskingForChange.fromJson(Map<String, dynamic> json) => AdminOrEmployeeListAskingForChange(
        id: json["_id"],
        isOnline: json["is_online"],
        name: json["name"],
        isAskingForChange: json["is_asking_for_change"],
        acceptIdForChange: json["accept_id_for_change"],
        editSettingType: json["edit_setting_type"],
        targetEmployeeId: json["target_employee_id"],
        displayBusinessOptionModel:
            (json["display_business_option"] == null) ? null : DisplayBusinessOptionProfileEmployeeModel.fromJson(json["display_business_option"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "is_online": isOnline,
        "name": name,
        "is_asking_for_change": isAskingForChange,
        "accept_id_for_change": acceptIdForChange,
        "edit_setting_type": editSettingType,
        "target_employee_id": targetEmployeeId,
        "display_business_option": (displayBusinessOptionModel == null)? null : displayBusinessOptionModel!.toJson(),
      };
}
