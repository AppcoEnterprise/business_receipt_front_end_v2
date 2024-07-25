import 'dart:convert';

import 'package:business_receipt/env/function/error_from_api.dart';
import 'package:business_receipt/env/function/delay_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/request_api/dio_config_request_api_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:business_receipt/model/employee_model/salary_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> updateEmployeeGlobal({required Function callBack, required BuildContext context, required ProfileEmployeeModel profileModelEmployee}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: updatingEmployeeInformationStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;

  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}update_employee_admin',
      data: {
        'admin_id': profileModelAdminGlobal!.id,
        "employee_profile": profileModelEmployee.toJson(),
        "up_to_date": upToDateGlobal!.toIso8601String(),
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    final bool isEmployeeNameNotExist = (response.data["employee_profile_list"] != null);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
    if (isEmployeeNameNotExist) {
      profileEmployeeModelListAdminGlobal = profileModelListEmployeeFromJson(str: response.data["employee_profile_list"]);

      if (isValidQuery) {
        closeDialogGlobal(context: context);
        closeDialogGlobal(context: context);
      }
      callBack();
    } else {
      if (isValidQuery) {
        closeDialogGlobal(context: context);
      }
      void okFunction() {
        closeDialogGlobal(context: context);
      }

      okDialogGlobal(context: context, okFunction: okFunction, titleStr: signInAsEmployeeStrGlobal, subtitleStr: usernameIsAlreadyExistedStrGlobal);
    }
  }
}

Future<void> deleteEmployeeGlobal({required Function callBack, required BuildContext context, required String employeeId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingEmployeeStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}delete_employee_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "employee_id": employeeId, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    profileEmployeeModelListAdminGlobal = profileModelListEmployeeFromJson(str: response.data["employee_profile_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

Future<void> restoreEmployeeGlobal({required Function callBack, required BuildContext context, required String employeeId}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: deletingEmployeeStrGlobal);
  final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
  if (hasInternetAccess) {
    final Response response = await dioGlobal.post(
      '${endPointGlobal}restore_employee_admin',
      data: {'admin_id': profileModelAdminGlobal!.id, "employee_id": employeeId, "up_to_date": upToDateGlobal!.toIso8601String()},
      options: Options(headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
      }),
    );

    final bool isValidQuery = checkValidateResponseAdminOrEmployee(response: response, context: context);
    profileEmployeeModelListAdminGlobal = profileModelListEmployeeFromJson(str: response.data["employee_profile_list"]);
    upToDateGlobal = DateTime.parse(response.data["up_to_date"]);
    if (isValidQuery) {
      closeDialogGlobal(context: context);
    }
    callBack();
  }
}

// Future<void> getOnlineEmployeeListEmployeeGlobal({required Function callBack, required BuildContext context}) async {
//   await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
//   loadingDialogGlobal(context: context, loadingTitle: findingExchangeHistoryStrGlobal);
//   final bool hasInternetAccess = await InternetConnection().hasInternetAccess;
//   if (hasInternetAccess) {
//     final Response response = await dioGlobal.get(
//       '${endPointGlobal}get_employee_list_asking_for_change',
//       queryParameters: {
//         'admin_id': profileModelAdminGlobal!.id,
//         "up_to_date": upToDateGlobal!.toIso8601String(),
//       },
//       options: Options(headers: {
//         "Content-Type": "application/json",
//         "authorization": "Bearer ${getAdminOrEmployeeTokenFromLocalStorage()}",
//       }),
//     );
//     checkValidateResponseAdminOrEmployee(response: response, context: context);
//     askingForChangeFromEmployeeListGlobal = adminOrEmployeeListAskingForChangeFromJsonList(str: response.data["employee_list"]);
//     closeDialogGlobal(context: context);
//     callBack();
//   }
// }
