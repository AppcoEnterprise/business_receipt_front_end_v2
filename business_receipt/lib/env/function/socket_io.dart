
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/refresh_page_env.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_or_admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/socket_io_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/admin_or_employee_list_asking_for_change.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void connectSocketIO({required BuildContext context, required Function setStateFromOutside, required bool mounted}) {
  socketIOGlobal = IO.io(domainGlobal, <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false
  });
  socketIOGlobal!.connect();

  socketIOGlobal!.onConnect((data) {
    socketIOGlobal!.on("is_admin_editing_setting", (isAdminEditingSetting) {
      if (isAdminEditingSetting) {
        loadingDialogGlobal(context: context, loadingTitle: editingSettingStrGlobal);
      } else {
        closeDialogGlobal(context: context);
        refreshPageGlobal();
      }
    });
    socketIOGlobal!.on("is_deleting_history", (data) {
      if (data["is_deleting_history"]) {
        loadingDialogGlobal(context: context, loadingTitle: deletingHistoryStrGlobal, isDelayLogInAndAdvance: true);
      } else {
        final isEmployeeLoggedIn = (profileModelEmployeeGlobal != null);
        if (isEmployeeLoggedIn) {
          // setIsReLogInToTrueToLocalStorage();
          if (data["employee_id"] != profileModelEmployeeGlobal!.id) {
            closeDialogGlobal(context: context);
            refreshPageGlobal();
          }
        } else {
          closeDialogGlobal(context: context);
          refreshPageGlobal();
        }
      }
    });
    socketIOGlobal!.on("add_money_or_card_to_mat", (_) {
      closeDialogGlobal(context: context);
      refreshPageGlobal();
    });
    socketIOGlobal!.on("disable_all_same_authenticator_admin", (lastLoggedInDateAdmin) {
      if (DateTime.parse(lastLoggedInDateAdmin).compareTo(currentLoggedInDateAdminOrEmployee!) != 0) {
        // signOutGoogle();
        // clearEmployeeNameAndPasswordFromLocalStorage();
        LocalStorageHelper.clearAll();
        refreshPageGlobal();
      }
    });
    socketIOGlobal!.on("disable_all_same_authenticator_employee", (lastLoggedInDateEmployee) {
      if (DateTime.parse(lastLoggedInDateEmployee).compareTo(currentLoggedInDateAdminOrEmployee!) != 0) {
        // signOutFunction();
        // clearEmployeeNamePasswordAndTokenFromLocalStorage();
        // LocalStorageHelper.clearAll();
        refreshPageGlobal();
      }
    });
    socketIOGlobal!.on("asking_for_change_admin_or_employee", (data) {
      askingForChangeFromAdminGlobal = adminOrEmployeeListAskingForChangeFromJson(str: data["admin_asking_for_change"]);
      askingForChangeFromEmployeeListGlobal = adminOrEmployeeListAskingForChangeFromJsonList(str: data["employee_list_asking_for_change"]);
      // setStateFromOutside(() {});
      if (mounted) {
        setStateFromOutside(() {});
      }
      if (setStateFromOutsideToDialogGlobal != null) {
        setStateFromOutsideToDialogGlobal!(() {});
      }
    });
    socketIOGlobal!.on("overwrite_up_to_date", (upToDate) {
      upToDateGlobal = DateTime.parse(upToDate);
    });
  });
}

void logInAsAdminSocketIO() {
  currentLoggedInDateAdminOrEmployee = DateTime.now();
  socketIOGlobal!.emit("log_in_as_admin", {
    "admin_id": profileModelAdminGlobal!.id,
    "last_logged_in": currentLoggedInDateAdminOrEmployee!.toIso8601String(),
  });
}

void logInAsEmployeeSocketIO() {
  currentLoggedInDateAdminOrEmployee = DateTime.now();
  socketIOGlobal!.emit("log_in_as_employee", {
    "admin_id": profileModelAdminGlobal!.id,
    "employee_id": profileModelEmployeeGlobal!.id,
    "last_logged_in": currentLoggedInDateAdminOrEmployee!.toIso8601String(),
  });
}

void editingSettingSocketIO({required EditSettingTypeEnum editSettingTypeEnum, String? employeeId}) {
  socketIOGlobal!.emit(
    "admin_editing_setting",
    {
      "admin_id": profileModelAdminGlobal!.id,
      "employee_id": employeeId,
      "edit_setting_type": editSettingTypeStrGlobal(editSettingTypeEnum: editSettingTypeEnum),
    },
  );
}

void adminStopEditingSettingSocketIO({required EditSettingTypeEnum editSettingTypeEnum, String? employeeId}) {
  socketIOGlobal!.emit(
    "admin_stop_editing_setting",
    {
      "admin_id": profileModelAdminGlobal!.id,
      "employee_id": employeeId,
      "edit_setting_type": editSettingTypeStrGlobal(editSettingTypeEnum: editSettingTypeEnum),
    },
  );
}

void deleteHistorySocketIO() {
  socketIOGlobal!.emit("deleting_history", {"admin_id": profileModelAdminGlobal!.id, "employee_id": profileModelEmployeeGlobal!.id});
}

void stopDeleteHistorySocketIO() {
  socketIOGlobal!.emit("stop_deleting_history", {"admin_id": profileModelAdminGlobal!.id, "employee_id": profileModelEmployeeGlobal!.id});
}

void addMoneyOrCardToMatSocketIO({required String targetEmployeeId}) {
  socketIOGlobal!.emit("add_money_or_card_to_mat", targetEmployeeId);
}

void setAskingForChangeAdminOrEmployeeSocketIO({
  required bool isAskingForChange,
  required EditSettingTypeEnum? editSettingTypeEnum,
  String? targetEmployeeId,
}) {
  final bool isAdmin = (profileModelEmployeeGlobal == null);
  if (isAdmin) {
    socketIOGlobal!.emit("set_asking_for_change_admin_or_employee", {
      "admin_id": profileModelAdminGlobal!.id,
      "is_asking_for_change": isAskingForChange,
      "edit_setting_type": (editSettingTypeEnum == null) ? null : editSettingTypeStrGlobal(editSettingTypeEnum: editSettingTypeEnum),
      "target_employee_id": targetEmployeeId,
    });
  } else {
    socketIOGlobal!.emit("set_asking_for_change_admin_or_employee", {
      "admin_id": profileModelAdminGlobal!.id,
      "employee_id": profileModelEmployeeGlobal!.id,
      "is_asking_for_change": isAskingForChange,
      "edit_setting_type": (editSettingTypeEnum == null) ? null : editSettingTypeStrGlobal(editSettingTypeEnum: editSettingTypeEnum),
      "target_employee_id": targetEmployeeId,
    });
  }
}

void employeeAcceptedAdminOrEmployeeAskingForChangeSocketIO({required String adminIdOrEmployeeIdSelected}) {
  socketIOGlobal!.emit("set_accept_id_for_change", {
    "admin_id": profileModelAdminGlobal!.id,
    "employee_id": profileModelEmployeeGlobal!.id,
    "accept_id_for_change": adminIdOrEmployeeIdSelected,
  });
}
