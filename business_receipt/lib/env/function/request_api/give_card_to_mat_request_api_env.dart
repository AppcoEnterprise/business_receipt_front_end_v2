import 'package:business_receipt/env/function/error_from_api.dart';
import 'package:business_receipt/env/function/delay_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/request_api/dio_config_request_api_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/employee_model/give_card_to_mat_model.dart';
import 'package:business_receipt/model/employee_model/history_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> updateGiveCardToMatAdminGlobal(
    {required Function callBack, required BuildContext context, required GiveCardToMatModel giveCardToMatModelTemp}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updateGiveCardToMatStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_give_card_to_mat_employee',
      data: {
        "admin_id": profileModelAdminGlobal!.id,
        'employee_id': profileModelEmployeeGlobal!.id,
        "give_card_to_mat": giveCardToMatModelTemp.constValueToJson(),
        "employee_name": profileModelEmployeeGlobal!.name.text,
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context)   ;
    if(!response.data["is_full_invoice_card_stock"]) {

    historyListGlobal.insert(0, historyModelFromJson(str: response.data["total_per_invoice_last"]));
    cardModelListGlobal = cardModelListFromJson(str: response.data["card_list"]);
    profileModelEmployeeGlobal = profileModelEmployeeFromJson(str: response.data["profile_employee"]);
    giveCardToMatModelListEmployeeGlobal.insert(0, giveCardToMatModelFromJson(str: response.data["total_per_invoice_last"]["give_card_to_mat"]));
    }
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack(isFullInvoiceCardStock: response.data["is_full_invoice_card_stock"]);
  }
}

Future<void> getGiveCardToMatListEmployeeGlobal({
  required String employeeId,
  required Function callBack,
  required BuildContext context,
  required int skip,
  required DateTime targetDate,
  required List<GiveCardToMatModel> giveCardToMatModelListEmployee,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.get(
      '${endPointGlobal}get_give_card_to_mat_list_employee',
      queryParameters: {
        'admin_id': profileModelAdminGlobal!.id,
        'employee_id': employeeId,
        "skip": skip,
        "target_date": targetDate.toIso8601String(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final List<GiveCardToMatModel> giveCardToMatModelTemp = giveCardToMatModelListFromJson(str: response.data["give_card_to_mat_list"]);
    if (giveCardToMatModelListEmployee.isNotEmpty && giveCardToMatModelTemp.isNotEmpty) {
      final DateTime dateLast = giveCardToMatModelListEmployee.last.date!;
      final DateTime dateFirstTemp = giveCardToMatModelTemp.first.date!;
      bool isGiveCardToMatModelDateAfter = dateFirstTemp.isAfter(dateLast) || (dateFirstTemp.compareTo(dateLast) == 0);
      if (isGiveCardToMatModelDateAfter) {
        closeDialogGlobal(context: context);
        return;
      }
    }

    
final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context)   ;

    giveCardToMatModelListEmployee.addAll(giveCardToMatModelTemp);

    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}
