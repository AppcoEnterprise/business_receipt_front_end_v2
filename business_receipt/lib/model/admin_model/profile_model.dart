// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'package:flutter/material.dart';
import 'dart:convert';

ProfileAdminModel profileModelAdminFromJson({required dynamic str}) => ProfileAdminModel.fromJson(json.decode(json.encode(str)));
// ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

Map<String, dynamic> profileModelAdminToJson({required ProfileAdminModel data}) => data.toJson();

Map<String, dynamic> profileModelAdminNoCostValueToJson({required ProfileAdminModel data}) => data.noCostValueToJson();

class ProfileAdminModel {

  ProfileAdminModel({
    this.id,
    required this.name,
    required this.password,
    required this.bio,
    this.supId,
    // required this.connectionEmail,
  });

  TextEditingController name;
  TextEditingController password;
  TextEditingController bio;
  // String connectionEmail;
  String? supId; //const value
  String? id; //const value

  factory ProfileAdminModel.fromJson(Map<String, dynamic> json) => ProfileAdminModel(
        name: TextEditingController(text: json["name"]),
        bio: TextEditingController(text: json["bio"]),
        supId: json["sup_id"],
        password: TextEditingController(text: json["password"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "password": password.text,
        "name": name.text,
        "bio": bio.text,
        "sup_id": supId,
        "_id": id,
      };

  Map<String, dynamic> noCostValueToJson() => {
        "password": password.text,
        "name": name.text,
        "bio": bio.text,
        // "sup_id": supId,
        // "_id": id,
      };
}
