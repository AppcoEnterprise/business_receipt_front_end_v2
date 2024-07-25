import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/refresh_page_env.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// Future<void> signInGoogle() async {
//   try {
//     await googleGlobal.signIn().then((_) {
//       refreshPageGlobal();
//     });
//   } catch (error) {
//     refreshPageGlobal();
//   }
// }

// Future<void> signOutGoogle() => googleGlobal.disconnect();

bool checkValidateResponseAdminOrEmployee({required BuildContext context, required Response<dynamic> response}) {
  final bool isFreshPage = response.data["is_refresh_page"] ?? false;
  if (isFreshPage) {
    void okFunction() {
      refreshPageGlobal();
    }

    restartDialogGlobal(context: context, okFunction: okFunction, titleStr: errorStrGlobal, subtitleStr: needToRefreshStrGlobal);
    return false;
  }
  final bool isNotMatchStock = response.data["is_not_match_stock"] ?? false;
  if (isNotMatchStock) {
    void okFunction() {
      // closeDialogGlobal(context: context);
      // closeDialogGlobal(context: context);
      refreshPageGlobal();
    }

    okDialogGlobal(context: context, okFunction: okFunction, titleStr: errorStrGlobal, subtitleStr: notMatchStockStrGlobal);
    return false;
  }

  final bool isNotMatchAmount = response.data["is_not_match_amount"] ?? false;
  if (isNotMatchAmount) {
    void okFunction() {
      // closeDialogGlobal(context: context);
      // closeDialogGlobal(context: context);
      refreshPageGlobal();
    }

    okDialogGlobal(context: context, okFunction: okFunction, titleStr: errorStrGlobal, subtitleStr: notMatchAmountStrGlobal);
    return false;
  }

  final bool isNotAuthenticated = !(response.data["is_authenticated"] ?? true);
  if (isNotAuthenticated) {
    // clearEmployeeNamePasswordAndTokenFromLocalStorage();
    // profileModelAdminGlobal = null;
    // profileModelEmployeeGlobal = null;
    // signOutGoogle();

    void okFunction() {
      LocalStorageHelper.clearAll();
      refreshPageGlobal();
    }

    restartDialogGlobal(context: context, okFunction: okFunction, titleStr: errorStrGlobal, subtitleStr: notAuthenticatedStrGlobal);
    return false;
  }
  return true;
}
