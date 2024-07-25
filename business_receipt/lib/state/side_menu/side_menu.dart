// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/change_setting.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/icon_env.dart';
import 'package:business_receipt/env/function/local_storage.dart';
import 'package:business_receipt/env/function/refresh_page_env.dart';
import 'package:business_receipt/env/function/request_api/salary_request_api_env.dart';
import 'package:business_receipt/env/function/request_api/up_to_date_and_online_request_api_env.dart';
import 'package:business_receipt/env/function/salary.dart';
// import 'package:business_receipt/env/function/salary.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_or_admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_or_employee_list_asking_for_change.dart';
import 'package:business_receipt/model/business_option_model.dart';
import 'package:business_receipt/env/function/button/button_env.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/set_up_employee_dialog.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  Function signOutFunction;
  List<BusinessOptionModel> businessOptionList;
  String profileTitle;
  String? profileSubtitle;
  bool isShowSalary;
  SideMenu(
      {Key? key, required this.signOutFunction, required this.businessOptionList, required this.profileTitle, this.profileSubtitle, required this.isShowSalary})
      : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  int count = 0;
  bool isAllowAcceptAskingForChange = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: loadingSalaryMinuteNumber), (timer) {
      final DateTime currentFullDateTime = DateTime.now();
      final DateTime currentDateTime = DateTime(1000, 1, 1, currentFullDateTime.hour, currentFullDateTime.minute, currentFullDateTime.second);
      final DateTime targetDateTime = DateTime(1000, 1, 1, 23, 59, 59);
      if (currentDateTime == targetDateTime) {
        refreshPageGlobal();
      }
    });
    if (!deletingHistoryGlobal) {
      Timer.periodic(const Duration(seconds: checkingUpToDateSecondNumber), (timer) {
        getUpToDateAdminGlobal(context: context, setStateFromOutside: setState, mounted: mounted);
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (adminIsEditingGlobal) {
        loadingDialogGlobal(context: context, loadingTitle: editingSettingStrGlobal);
      }
      if (deletingHistoryGlobal) {
        loadingDialogGlobal(context: context, loadingTitle: deletingHistoryStrGlobal, isDelayLogInAndAdvance: true);
      }
    });
  }

  Widget _sideMenuWidget() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isBigScreen = (screenWidth > minWithGlobal);
    Widget sideMenuProviderWidget() {
      final double businessOptionWidth = isBigScreen ? maxBusinessOptionWidthGlobal : minBusinessOptionWidthGlobal;
      Widget optionAndProfileWidget() {
        Widget paddingProfileAndSetWidth() {
          Widget paddingShowName() {
            Widget profileButtonWidget() {
              Widget profileProviderWidget() {
                final bool isAdmin = (profileModelEmployeeGlobal == null);
                String imagePath = isAdmin ? administratorIconImageGlobal : accountingIconImageGlobal;
                Widget maxProfileWidget() {
                  return Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)),
                        child: Image.asset(imagePath, width: maxImageBusinessOptionWidthGlobal),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          scrollText(
                            textStr: widget.profileTitle,
                            textStyle: textStyleGlobal(level: Level.normal),
                            width: profileContentBusinessOptionWidthGlobal,
                            alignment: Alignment.topLeft,
                          ),
                          (widget.profileSubtitle == null)
                              ? Container()
                              : scrollText(
                                  textStr: widget.profileSubtitle!,
                                  textStyle: textStyleGlobal(level: Level.mini),
                                  width: profileContentBusinessOptionWidthGlobal,
                                  alignment: Alignment.topLeft,
                                ),
                          widget.isShowSalary
                              ? SalaryLoading(
                                  salaryIndex: 0,
                                  subSalaryIndex: 0,
                                  level: Level.mini,
                                  alignment: Alignment.topLeft,
                                  width: profileContentBusinessOptionWidthGlobal,
                                  salaryListEmployee: salaryListEmployeeGlobal,
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  );
                }

                Widget minProfileWidget() {
                  return Center(child: Image.asset(imagePath, width: miniImageBusinessOptionWidthGlobal));
                }

                return isBigScreen ? maxProfileWidget() : minProfileWidget();
              }

              return CustomButtonGlobal(
                  insideSizeBoxWidget: profileProviderWidget(),
                  onTapUnlessDisable: () {
                    final bool isAdmin = (profileModelEmployeeGlobal == null);
                    if (!isAdmin) {
                      // void callBack() {
                      void callback() {
                        if (mounted) {
                          setState(() {});
                        }
                      }

                      setUpEmployeeDialog(
                        context: context,
                        isAdminEditing: false,
                        isCreateNewEmployee: false,
                        setState: callback,
                        profileEmployeeModel: profileModelEmployeeGlobal,
                        signOutFunction: widget.signOutFunction,
                        salaryListEmployee: salaryListEmployeeGlobal,
                      );
                      // }

                      // salaryListEmployeeGlobal = [];
                      // getSalaryListEmployeeGlobal(
                      //   callBack: callBack,
                      //   context: context,
                      //   employeeId: profileModelEmployeeGlobal!.id!,
                      //   skip: 0,
                      //   salaryListEmployee: salaryListEmployeeGlobal,
                      // );
                    }
                  });
            }

            return SizedBox(
              width: businessOptionWidth,
              child: Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.normal)), child: profileButtonWidget()),
            );
          }

          return paddingShowName();
        }

        Widget expandedOptionList() {
          Widget setSizeBoxWidthWidget() {
            Widget optionList() {
              Widget businessOptionWidget({required int index}) {
                Widget paddingTopAndVerticalWidth() {
                  Widget buttonWith() {
                    final String? textStr = isBigScreen ? widget.businessOptionList[index].name : null;
                    final int? countReceipt = isBigScreen ? widget.businessOptionList[index].countReceipt : null;
                    final bool isDisable = (_selectedIndex == index);
                    final MainAxisAlignment mainAxisAlignment = isBigScreen ? MainAxisAlignment.start : MainAxisAlignment.center;
                    return buttonGlobal(
                      context: context,
                      onTapUnlessDisableAndValid: () {
                        limitHistory();
                        _selectedIndex = index;
                        setState(() {});
                        _pageController.jumpToPage(index);
                      },
                      colorTextAndIcon: optionTextAndIconColorGlobal,
                      textStr: textStr,
                      countReceipt: countReceipt,
                      colorSideBox: widgetButtonColorGlobal,
                      icon: widget.businessOptionList[index].icon,
                      isDisable: isDisable,
                      mainAxisAlignment: mainAxisAlignment,
                      level: Level.normal,
                      isExpandedText: true,
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                      left: paddingSizeGlobal(level: Level.normal),
                      right: paddingSizeGlobal(level: Level.normal),
                      bottom: paddingSizeGlobal(level: Level.mini),
                    ),
                    child: buttonWith(),
                  );
                }

                return paddingTopAndVerticalWidth();
              }

              Widget paddingAskingForChangeWidth({
                required AdminOrEmployeeListAskingForChange askingForChangeModel,
                required Function okOnClick,
                required bool isAdmin,
              }) {
                Widget paddingAskingForChange({required int askingIndex}) {
                  Widget profileProviderWidget() {
                    // final bool isAdmin = (profileModelEmployeeGlobal == null);
                    // String imagePath = isAdmin ? administratorIconImageGlobal : accountingIconImageGlobal;
                    Widget maxProfileWidget() {
                      Widget insideSizeBoxWidget() {
                        int maxEmployeeAcceptedCount = 0;
                        int employeeAcceptedCount = 0;
                        for (int askingEmployeeIndex = 0; askingEmployeeIndex < askingForChangeFromEmployeeListGlobal.length; askingEmployeeIndex++) {
                          final bool isVisibleDisplayOption = getCheckVisibleDisplayOptionEmployee(
                            employeeId: askingForChangeFromEmployeeListGlobal[askingEmployeeIndex].id,
                            displayBusinessOptionModel: askingForChangeFromEmployeeListGlobal[askingEmployeeIndex].displayBusinessOptionModel!,
                            editSettingType: askingForChangeModel.editSettingType,
                            targetEmployeeId: askingForChangeModel.targetEmployeeId,
                          );
                          if (askingForChangeFromEmployeeListGlobal[askingEmployeeIndex].isOnline && isVisibleDisplayOption) {
                            if (!askingForChangeFromEmployeeListGlobal[askingEmployeeIndex].isAskingForChange) {
                              maxEmployeeAcceptedCount++;
                            }
                            if (askingForChangeFromEmployeeListGlobal[askingEmployeeIndex].acceptIdForChange != null) {
                              if (askingForChangeFromEmployeeListGlobal[askingEmployeeIndex].acceptIdForChange == askingForChangeModel.id) {
                                employeeAcceptedCount++;
                              }
                            }
                          }
                        }
                        void onTapFunction() {
                          isAllowAcceptAskingForChange = false;
                          Future.delayed(const Duration(seconds: delayApiRequestSecond), () {
                            isAllowAcceptAskingForChange = true;
                            if (mounted) {
                              setState(() {});
                            }
                          });
                          okOnClick();
                        }

                        bool checkAccepted() {
                          final selfIndex = askingForChangeFromEmployeeListGlobal.indexWhere((element) => element.id == profileModelEmployeeGlobal!.id);
                          if (askingForChangeFromEmployeeListGlobal[selfIndex].acceptIdForChange != null) {
                            if (askingForChangeFromEmployeeListGlobal[selfIndex].acceptIdForChange == askingForChangeModel.id) {
                              return true;
                            }
                          }
                          return false;
                        }

                        Widget askingEmployeeAcceptedWidget({required int askingEmployeeIndex}) {
                          final bool isAcceptedThisElement =
                              askingForChangeFromEmployeeListGlobal[askingEmployeeIndex].acceptIdForChange == askingForChangeModel.id;
                          return isAcceptedThisElement
                              ? Row(children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.mini)),
                                    child: iconGlobal(iconData: Icons.check, level: Level.mini, color: Colors.green),
                                  ),
                                  Expanded(
                                    child: Text(
                                      askingForChangeFromEmployeeListGlobal[askingEmployeeIndex].name,
                                      style: textStyleGlobal(level: Level.mini, color: Colors.green),
                                    ),
                                  ),
                                ])
                              : Container();
                        }

                        return Column(
                          children: [
                            Row(children: [
                              Padding(
                                padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)),
                                child: iconGlobal(iconData: Icons.rebase_edit, level: Level.normal, color: acceptSuggestButtonColorGlobal),
                              ),
                              Expanded(
                                child: Text(
                                  "${askingForChangeModel.name} request changing. ($employeeAcceptedCount/$maxEmployeeAcceptedCount)",
                                  style: textStyleGlobal(level: Level.normal, color: acceptSuggestButtonColorGlobal),
                                ),
                              ),
                            ]),
                            Padding(
                              padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)),
                              child: Column(children: [
                                for (int askingEmployeeIndex = 0; askingEmployeeIndex < askingForChangeFromEmployeeListGlobal.length; askingEmployeeIndex++)
                                  askingEmployeeAcceptedWidget(askingEmployeeIndex: askingEmployeeIndex)
                              ]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)),
                              child: checkAccepted()
                                  ? Text("Accepted", style: textStyleGlobal(level: Level.mini, color: optionTextAndIconColorGlobal))
                                  : acceptSuggestButtonOrContainerWidget(
                                      context: context,
                                      level: Level.mini,
                                      onTapFunction: onTapFunction,
                                      // validModel: isAllowAcceptAskingForChange,
                                      validModel: ValidButtonModel(isValid: isAllowAcceptAskingForChange, errorType: ErrorTypeEnum.waitAllEmployeeAccept),
                                    ),
                            ),
                          ],
                        );
                      }

                      return CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: () {});
                    }

                    Widget minProfileWidget() {
                      return Container();
                    }

                    return isBigScreen ? maxProfileWidget() : minProfileWidget();
                  }

                  bool isVisibleDisplayOption = (askingForChangeFromEmployeeListGlobal[askingIndex].displayBusinessOptionModel == null)
                      ? false
                      : getCheckVisibleDisplayOptionEmployee(
                          employeeId: askingForChangeFromEmployeeListGlobal[askingIndex].id,
                          displayBusinessOptionModel: askingForChangeFromEmployeeListGlobal[askingIndex].displayBusinessOptionModel!,
                          editSettingType: askingForChangeModel.editSettingType,
                          targetEmployeeId: askingForChangeModel.targetEmployeeId,
                        );
                  return isVisibleDisplayOption
                      ? SizedBox(
                          width: businessOptionWidth,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: paddingSizeGlobal(level: Level.normal),
                              right: paddingSizeGlobal(level: Level.normal),
                              bottom: paddingSizeGlobal(level: Level.mini),
                            ),
                            child: profileProviderWidget(),
                          ),
                        )
                      : Container();
                }

                final int employeeAskingSelfIndex = askingForChangeFromEmployeeListGlobal.indexWhere((element) => element.id == profileModelEmployeeGlobal!.id);
                return askingForChangeFromEmployeeListGlobal[employeeAskingSelfIndex].isAskingForChange
                    ? Container()
                    : paddingAskingForChange(askingIndex: employeeAskingSelfIndex);
              }

              Widget paddingAskingForChangeFromAdmin() {
                void okOnClick() {
                  employeeAcceptedAdminOrEmployeeAskingForChangeSocketIO(adminIdOrEmployeeIdSelected: askingForChangeFromAdminGlobal!.id);
                }

                if (askingForChangeFromAdminGlobal == null) {
                  return Container();
                }
                final bool isAdmin = (profileModelEmployeeGlobal == null);
                return (askingForChangeFromAdminGlobal!.isAskingForChange && !isAdmin)
                    ? paddingAskingForChangeWidth(okOnClick: okOnClick, askingForChangeModel: askingForChangeFromAdminGlobal!, isAdmin: true)
                    : Container();
              }

              Widget paddingAskingForChangeFromEmployee({required int askingIndex}) {
                void okOnClick() {
                  employeeAcceptedAdminOrEmployeeAskingForChangeSocketIO(adminIdOrEmployeeIdSelected: askingForChangeFromEmployeeListGlobal[askingIndex].id);

                  // final selfIndex = askingForChangeFromEmployeeListGlobal.indexWhere((element) => element.id == profileModelEmployeeGlobal!.id);
                  // askingForChangeFromEmployeeListGlobal[selfIndex].acceptIdForChange = askingForChangeFromEmployeeListGlobal[askingIndex].id;
                  // setState(() {});
                }

                final bool isAdmin = (profileModelEmployeeGlobal == null);
                if (isAdmin) {
                  return Container();
                }
                return (askingForChangeFromEmployeeListGlobal[askingIndex].isAskingForChange &&
                        askingForChangeFromEmployeeListGlobal[askingIndex].id != profileModelEmployeeGlobal!.id!)
                    ? paddingAskingForChangeWidth(
                        okOnClick: okOnClick,
                        askingForChangeModel: askingForChangeFromEmployeeListGlobal[askingIndex],
                        isAdmin: false,
                      )
                    : Container();
              }

              return SingleChildScrollView(
                child: Column(children: [
                  paddingAskingForChangeFromAdmin(),
                  for (int askingIndex = 0; askingIndex < askingForChangeFromEmployeeListGlobal.length; askingIndex++)
                    paddingAskingForChangeFromEmployee(askingIndex: askingIndex),
                  for (int businessOptionIndex = 0; businessOptionIndex < widget.businessOptionList.length; businessOptionIndex++)
                    businessOptionWidget(index: businessOptionIndex)
                ]),
              );
              // return ListView.builder(
              //   itemCount: widget.businessOptionList.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     Widget paddingTopAndVerticalWidth() {
              //       Widget buttonWith() {
              //         final String? textStr = isBigScreen ? widget.businessOptionList[index].name : null;
              //         final int? countReceipt = isBigScreen ? widget.businessOptionList[index].countReceipt : null;
              //         final bool isDisable = (_selectedIndex == index);
              //         final MainAxisAlignment mainAxisAlignment = isBigScreen ? MainAxisAlignment.start : MainAxisAlignment.center;
              //         return buttonGlobal(
              //           onTapUnlessDisableAndValid: () {
              //             limitHistory();
              //             _selectedIndex = index;
              //             setState(() {});
              //             _pageController.jumpToPage(index);
              //           },
              //           colorTextAndIcon: optionTextAndIconColorGlobal,
              //           textStr: textStr,
              //           countReceipt: countReceipt,
              //           colorSideBox: widgetButtonColorGlobal,
              //           icon: widget.businessOptionList[index].icon,
              //           isDisable: isDisable,
              //           mainAxisAlignment: mainAxisAlignment,
              //           level: Level.normal,
              //           isExpandedText: true,
              //         );
              //       }

              //       return Padding(
              //         padding: EdgeInsets.only(
              //           left: paddingSizeGlobal(level: Level.normal),
              //           right: paddingSizeGlobal(level: Level.normal),
              //           bottom: paddingSizeGlobal(level: Level.mini),
              //         ),
              //         child: buttonWith(),
              //       );
              //     }

              //     return paddingTopAndVerticalWidth();
              //   },
              // );
            }

            return SizedBox(width: businessOptionWidth, child: optionList());
          }

          return Expanded(child: setSizeBoxWidthWidget());
        }

        Widget signOutContainerButton() {
          Widget signOutButton() {
            void signOutFunction() {
              void okFunction() {
                LocalStorageHelper.clearAll();
                // clearEmployeeNamePasswordAndTokenFromLocalStorage();
                // profileModelAdminGlobal = null;
                // profileModelEmployeeGlobal = null;

                widget.signOutFunction();
              }

              void cancelFunction() {}
              confirmationDialogGlobal(
                context: context,
                okFunction: okFunction,
                cancelFunction: cancelFunction,
                titleStr: signOutStrGlobal,
                subtitleStr: signOutConfirmGlobal,
              );
            }

            return buttonGlobal(
                context: context,
                icon: Icons.logout,
                colorSideBox: signOutButtonColorGlobal,
                textStr: signOutStrGlobal,
                elevation: 0,
                onTapUnlessDisableAndValid: signOutFunction,
                level: Level.mini);
          }

          return Container(margin: EdgeInsets.zero, color: signOutButtonColorGlobal, width: businessOptionWidth, child: signOutButton());
        }

        return Column(children: [
          paddingProfileAndSetWidth(),
          expandedOptionList(),
          signOutContainerButton(),
        ]);
      }

      Widget pageViewWidget() {
        BoxDecoration shadow() {
          return const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(blurRadius: 8, offset: Offset(4, 0))]);
        }

        return Expanded(
          child: Container(
            margin: EdgeInsets.zero,
            decoration: shadow(),
            child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [for (int i = 0; i < widget.businessOptionList.length; i++) widget.businessOptionList[i].optionFunction()]),
          ),
        );
      }

      Widget colorBackgroundWidget() {
        Widget rowOptionAndPageViewWidget() {
          return Row(children: [optionAndProfileWidget(), pageViewWidget()]);
        }

        return Container(margin: EdgeInsets.zero, color: optionBackgroundColor, child: rowOptionAndPageViewWidget());
      }

      return colorBackgroundWidget();
    }

    return sideMenuProviderWidget();
  }

  @override
  Widget build(BuildContext context) {
    // if (!deletingHistoryGlobal) {
    //   Timer(const Duration(seconds: checkingUpToDateSecondNumber), () {
    //     count++;
    //     print("count => $count (${DateTime.now()})");
    //     setState(() {});
    //     //     getUpToDateAdminGlobal(context: context);
    //   });
    // }
    return Scaffold(body: _sideMenuWidget());
  }
}
