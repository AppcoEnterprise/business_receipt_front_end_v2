import 'package:flutter/material.dart';

class BusinessOptionModel {
  String name;
  IconData icon;
  Function optionFunction;
  int? countReceipt;
  BusinessOptionModel({required this.name, required this.icon, required this.optionFunction, this.countReceipt});
}
