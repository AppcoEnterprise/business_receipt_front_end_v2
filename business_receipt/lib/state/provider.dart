// import 'package:business_receipt/env/function/account.dart';
// import 'package:business_receipt/env/function/local_storage.dart';
// import 'package:business_receipt/env/function/socket_io.dart';
// import 'package:business_receipt/env/value_env/business_option/admin_business_option_env.dart';
// import 'package:business_receipt/env/value_env/business_option/employee_business_option_env.dart';
// import 'package:business_receipt/env/function/dialog_env.dart';
// import 'package:business_receipt/env/function/loading_env.dart';
// import 'package:business_receipt/env/function/refresh_page_env.dart';
// import 'package:business_receipt/env/function/request_api/account_request_api_env.dart';
// import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
// import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
// import 'package:business_receipt/env/value_env/title_env.dart';
// import 'package:business_receipt/state/log_in.dart';
// import 'package:business_receipt/state/register.dart';
// import 'package:business_receipt/state/side_menu/side_menu.dart';
// import 'package:flutter/material.dart';

// class Provider extends StatefulWidget {
//   const Provider({Key? key}) : super(key: key);

//   @override
//   State createState() => ProviderState();
// }

// class ProviderState extends State<Provider> {
//   // GoogleSignInAccount? _currentUser;
//   // bool _isLoadingOnGetUserIdByEmail = true;

//   @override
//   void initState() {
//     super.initState();

//     final String? employeeName = getEmployeeNameFromLocalStorage();
//     final String? employeePassword = getEmployeePasswordFromLocalStorage();
//     final bool isNotNullEmployeeNameAndPassword = (employeeName != null && employeePassword != null);
//     final bool isNotLoggedInAsAdmin = (_currentUser == null);
//     if (isNotNullEmployeeNameAndPassword && isNotLoggedInAsAdmin) {
//       final bool isNotEmptyEmployeeNameAndPassword = (employeeName.isNotEmpty && employeePassword.isNotEmpty);
//       if (isNotEmptyEmployeeNameAndPassword) {
//         logInAsEmployeeGlobal(
//           employeeName: employeeName,
//           password: employeePassword,
//           callBack: () {
//             _isLoadingOnGetUserIdByEmail = true;
//             closeDialogGlobal(context: context);
//             setState(() {});
//           },
//           context: context,
//         );
//       }
//     }

//     connectSocketIO(context: context);

//     // googleGlobal.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
//     //   setState(() {
//     //     _currentUser = account;
//     //     closeDialogGlobal(context: context);
//     //   });
//     // });
//     // googleGlobal.signInSilently();
//   }

//   Widget _buildBody() {
//     final bool isLoggedInAsAdminOrEmployee = ((_currentUser != null) || (profileModelEmployeeGlobal != null));
//     if (isLoggedInAsAdminOrEmployee) {
//       Widget homePageProvider() {
//         final bool isLoggedInAsAdmin = (_currentUser != null);
//         if (isLoggedInAsAdmin) {
//           final String email = _currentUser!.email;
//           final String emailName = _currentUser!.displayName ?? emptyStrGlobal;
//           Widget loadingOrAdminHomePage() {
//             final bool isAllowGetUserIdByEmail = _isLoadingOnGetUserIdByEmail && (profileModelAdminGlobal == null);
//             if (isAllowGetUserIdByEmail) {
//               void callBack() {
//                 _isLoadingOnGetUserIdByEmail = false;
//                 setState(() {});
//               }

//               logInAsAdminGlobal(email: email, callBack: callBack);
//             }
//             Widget loadingOrAdminPage() {
//               Widget oldOrNewAdmin() {
//                 Widget registerClassSetUp() {
//                   return Register(
//                     email: email,
//                     emailName: emailName,
//                     callbackSignInAsAdmin: () {
//                       setState(() {});
//                     },
//                   );
//                 }

//                 Widget oldAdmin() {
//                   void signOutFunction() {
//                     // signOutGoogle();
//                     LocalStorageHelper.clearAll();
//                     refreshPageGlobal();
//                   }

//                   return SideMenu(
//                     signOutFunction: signOutFunction,
//                     businessOptionList: adminOptionListGlobal,
//                     profileTitle: profileModelAdminGlobal!.name.text,
//                     profileSubtitle: profileModelAdminGlobal!.connectionEmail,
//                     isShowSalary: false,
//                   );
//                 }

//                 final bool isNewAdmin = (profileModelAdminGlobal == null);
//                 return isNewAdmin ? registerClassSetUp() : oldAdmin();
//               }

//               return _isLoadingOnGetUserIdByEmail ? loadingWidgetGlobal(loadingTitle: findingAdminStrGlobal) : oldOrNewAdmin();
//             }

//             return loadingOrAdminPage();
//           }

//           return loadingOrAdminHomePage();
//         } else {
//           Widget sideMenuEmployee() {
//             void signOutFunction() {
//               refreshPageGlobal();
//             }

//             return SideMenu(
//               profileTitle: profileModelEmployeeGlobal!.name.text,
//               // profileSubtitle: profileModelEmployeeGlobal!.password.text,
//               signOutFunction: signOutFunction,
//               businessOptionList: employeeOptionListFunctionGlobal(),
//               isShowSalary: true,
//             );
//           }

//           return sideMenuEmployee();
//         }
//       }

//       return homePageProvider();
//     } else {
//       void callbackSignInAsAdmin() {
//         signInGoogle();
//       }

//       void callbackSignInAsEmployee() {
//         setState(() {});
//       }

//       return LogIn(callbackSignInAsAdmin: callbackSignInAsAdmin, callbackSignInAsEmployee: callbackSignInAsEmployee, providerContext: context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildBody();
//   }
// }


import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/value_env/business_option/admin_business_option_env.dart';
import 'package:business_receipt/env/value_env/business_option/employee_business_option_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/refresh_page_env.dart';
import 'package:business_receipt/env/function/request_api/account_request_api_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/state/log_in.dart';
import 'package:business_receipt/state/register.dart';
import 'package:business_receipt/state/side_menu/side_menu.dart';
import 'package:flutter/material.dart';

class Provider extends StatefulWidget {
  const Provider({Key? key}) : super(key: key);

  @override
  State createState() => ProviderState();
}

class ProviderState extends State<Provider> {
  // GoogleSignInAccount? _currentUser;

  bool _isClickLogInAdmin = false;
  bool _isExistingAdmin = false;
  String _adminName = "";
  String _adminPassword = "";
  @override
  void initState() {
    super.initState();
    connectSocketIO(context: context, setStateFromOutside: setState, mounted: mounted);

    final String? adminName = getAdminNameFromLocalStorage();
    final String? adminPassword = getAdminPasswordFromLocalStorage();
    final bool isNotNullAdminNameAndPassword = (adminName != null && adminPassword != null);
    if (isNotNullAdminNameAndPassword) {
      final bool isNotEmptyEmployeeNameAndPassword = (adminName.isNotEmpty && adminPassword.isNotEmpty);
      if (isNotEmptyEmployeeNameAndPassword) {
        logInAsAdminGlobal(
          adminName: adminName,
          password: adminPassword,
          callBack: ({required bool isExistingAdmin}) {
            _isExistingAdmin = isExistingAdmin;
            // clearIsReLogIn();
            closeDialogGlobal(context: context);
            setState(() {});
          },
          context: context,
        );
      }
    }
    
    // // final bool isReLogIn = (getIsReLogInFromLocalStorage() != null);
    // // if (isReLogIn) {
    //   final String? employeeName = getEmployeeNameFromLocalStorage();
    //   final String? employeePassword = getEmployeePasswordFromLocalStorage();
    //   final bool isNotNullEmployeeNameAndPassword = (employeeName != null && employeePassword != null);
    //   if (isNotNullEmployeeNameAndPassword) {
    //     final bool isNotEmptyEmployeeNameAndPassword = (employeeName.isNotEmpty && employeePassword.isNotEmpty);
    //     if (isNotEmptyEmployeeNameAndPassword) {
    //       logInAsEmployeeGlobal(
    //         name: employeeName,
    //         password: employeePassword,
    //         callBack: () {
    //           // clearIsReLogIn();
    //           closeDialogGlobal(context: context);
    //           setState(() {});
    //         },
    //         context: context,
    //       );
    //     }
    //   // }
    // }
  }

  Widget _buildBody() {
    bool isExistAdminWithoutClickSignIn() {
      if (getAdminNameFromLocalStorage() != null) {
        if (getAdminNameFromLocalStorage()!.isNotEmpty) {
          return true;
        }
      }
      return false || _isClickLogInAdmin || _isExistingAdmin;
    }

    final bool isLoggedInAsAdminOrEmployee = (isExistAdminWithoutClickSignIn() || (profileModelEmployeeGlobal != null));
    if (isLoggedInAsAdminOrEmployee) {
      Widget homePageProvider() {
        if (isExistAdminWithoutClickSignIn()) {
          Widget loadingOrAdminHomePage() {
            Widget loadingOrAdminPage() {
              Widget oldOrNewAdmin() {
                Widget registerClassSetUp() {
                  return Register(
                    name: _adminName,
                    password: _adminPassword,
                    callbackSignInAsAdmin: () {
                      setState(() {});
                    },
                  );
                }

                Widget oldAdmin() {
                  void signOutFunction() {
                    // signOutGoogle();
                    LocalStorageHelper.clearAll();
                    refreshPageGlobal();
                  }

                  return SideMenu(
                    signOutFunction: signOutFunction,
                    businessOptionList: adminOptionListGlobal,
                    profileTitle: profileModelAdminGlobal!.name.text,
                    // profileSubtitle: profileModelAdminGlobal!.connectionEmail,
                    isShowSalary: false,
                  );
                }

                final bool isNewAdmin = (profileModelAdminGlobal == null);
                return isNewAdmin ? registerClassSetUp() : oldAdmin();
              }

              return oldOrNewAdmin();
            }

            return loadingOrAdminPage();
          }

          return loadingOrAdminHomePage();
        } else {
          Widget sideMenuEmployee() {
            void signOutFunction() {
              refreshPageGlobal();
            }

            void callback() {
              setState(() {});
            }

            return SideMenu(
              profileTitle: profileModelEmployeeGlobal!.name.text,
              signOutFunction: signOutFunction,
              businessOptionList: employeeOptionListFunctionGlobal(callback: callback),
              isShowSalary: true,
            );
          }

          return sideMenuEmployee();
        }
      }

      return homePageProvider();
    } else {
      void callbackSignInAsAdmin({required String adminName, required String adminPassword, required bool isExistingAdmin}) {
        _isClickLogInAdmin = true;
        _adminName = adminName;
        _adminPassword = adminPassword;
        setState(() {});
      }

      void callbackSignInAsEmployee() {
        setState(() {});
      }

      return LogIn(callbackSignInAsAdmin: callbackSignInAsAdmin, callbackSignInAsEmployee: callbackSignInAsEmployee, providerContext: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
