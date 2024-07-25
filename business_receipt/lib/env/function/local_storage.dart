import 'package:business_receipt/env/value_env/local_storage.dart';
import 'package:universal_html/html.dart';

class LocalStorageHelper {
  static Storage localStorage = window.localStorage;

  //to save a data in local storage
  static void saveValue({required String key, required String value}) {
    localStorage[key] = value;
  }

  //get a data
  static String? getValue({required String key}) {
    return localStorage[key];
  }

  //remove a data
  static void removeValue({required String key}) {
    localStorage.remove(key);
  }

  //clear all data
  static void clearAll() {
    localStorage.clear();
  }
}

String? getAdminNameFromLocalStorage() {
  return LocalStorageHelper.getValue(key: adminNameKey);
}

String? getAdminPasswordFromLocalStorage() {
  return LocalStorageHelper.getValue(key: adminPasswordKey);
}

String? getEmployeeNameFromLocalStorage() {
  return LocalStorageHelper.getValue(key: employeeNameKey);
}

String? getEmployeePasswordFromLocalStorage() {
  return LocalStorageHelper.getValue(key: employeePasswordKey);
}

String? getAdminOrEmployeeTokenFromLocalStorage() {
  return LocalStorageHelper.getValue(key: tokenKey);
}

// String? getIsReLogInFromLocalStorage() {
//   return LocalStorageHelper.getValue(key: isReLogInKey);
// }

void setEmployeeNamePasswordAndTokenToLocalStorage({required String nameStr, required String passwordStr, required String token}) {
  LocalStorageHelper.saveValue(key: employeeNameKey, value: nameStr);
  LocalStorageHelper.saveValue(key: employeePasswordKey, value: passwordStr);
  LocalStorageHelper.saveValue(key: tokenKey, value: token);
}

void setAdminTokenToLocalStorage({required String nameStr, required String passwordStr, required String token}) {
  LocalStorageHelper.saveValue(key: adminNameKey, value: nameStr);
  LocalStorageHelper.saveValue(key: adminPasswordKey, value: passwordStr);
  LocalStorageHelper.saveValue(key: tokenKey, value: token);
}

// void setIsReLogInToTrueToLocalStorage() {
//   LocalStorageHelper.saveValue(key: isReLogInKey, value: "true");
// }

// void clearIsReLogIn() {
//    LocalStorageHelper.removeValue(key: isReLogInKey);
// }
