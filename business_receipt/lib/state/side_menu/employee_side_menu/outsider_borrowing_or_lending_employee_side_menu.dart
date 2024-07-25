// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/active_log.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/request_api/customer_request_api_env.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/active_log.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:business_receipt/state/side_menu/set_up_customer_dialog.dart';
import 'package:flutter/material.dart';

class OutsiderBorrowingEmployeeSideMenu extends StatefulWidget {
  String title;
  Function callback;
  OutsiderBorrowingEmployeeSideMenu({Key? key, required this.title, required this.callback}) : super(key: key);

  @override
  State<OutsiderBorrowingEmployeeSideMenu> createState() => _OutsiderBorrowingEmployeeSideMenuState();
}

class _OutsiderBorrowingEmployeeSideMenuState extends State<OutsiderBorrowingEmployeeSideMenu> {
  int customerLengthIncrease = queryLimitNumberGlobal;
  bool isShowSeeMoreWidget = true;
  List<ActiveLogModel> activeLogModelBorrowOrLendingList = [];
  @override
  void initState() {
    if (customerLengthIncrease > customerModelListGlobal.length) {
      isShowSeeMoreWidget = false;
      customerLengthIncrease = customerModelListGlobal.length;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingOrBody() {
      Widget bodyTemplateSideMenu() {
        List<Widget> inWrapWidgetList() {
          Widget customerButtonWidget({required int customerIndex}) {
            Widget setWidthSizeBox() {
              Widget insideSizeBoxWidget() {
                String moneyTypeListText = "";
                for (int moneyTypeIndex = 0; moneyTypeIndex < customerModelListGlobal[customerIndex].totalList.length; moneyTypeIndex++) {
                  final String providerStr = (moneyTypeIndex == (customerModelListGlobal[customerIndex].totalList.length - 1)) ? "" : providerStrGlobal;
                  moneyTypeListText = "$moneyTypeListText ${customerModelListGlobal[customerIndex].totalList[moneyTypeIndex].moneyType} $providerStr";
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(customerModelListGlobal[customerIndex].name.text, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
                    scrollText(textStr: moneyTypeListText, textStyle: textStyleGlobal(level: Level.mini), alignment: Alignment.topCenter),
                  ],
                );
              }

              void onTapUnlessDisable() {
                addActiveLogElement(
                  activeLogModelList: activeLogModelBorrowOrLendingList,
                  activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
                    Location(title: "customer index", subtitle: customerIndex.toString()),
                    Location(title: "button name", subtitle: customerModelListGlobal[customerIndex].name.text),
                  ]),
                );
                setUpCustomerDialog(
                  isCreateNewCustomer: false,
                  customerIndex: customerIndex,
                  context: context,
                  isAdminEditing: false,
                  setState: setState,
                  callback: widget.callback,
                  activeLogModelList: activeLogModelBorrowOrLendingList,
                );
              }

              return CustomButtonGlobal(
                  sizeBoxWidth: sizeBoxWidthGlobal,
                  sizeBoxHeight: sizeBoxHeightGlobal,
                  insideSizeBoxWidget: insideSizeBoxWidget(),
                  onTapUnlessDisable: onTapUnlessDisable);
            }

            return (customerModelListGlobal[customerIndex].deletedDate != null) ? Container() : setWidthSizeBox();
          }

          return [for (int customerIndex = 0; customerIndex < customerLengthIncrease; customerIndex++) customerButtonWidget(customerIndex: customerIndex)];
        }

        void bottomFunction() {
          customerLengthIncrease = customerLengthIncrease + queryLimitNumberGlobal;
          if (customerLengthIncrease > customerModelListGlobal.length) {
            isShowSeeMoreWidget = false;
            customerLengthIncrease = customerModelListGlobal.length;
          }
        }

        void historyOnTapFunction() {
          limitHistory();
          addActiveLogElement(
            activeLogModelList: activeLogModelBorrowOrLendingList,
            activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
              Location(color: ColorEnum.blue, title: "button name", subtitle: "history button"),
            ]),
          );
          void cancelFunctionOnTap() {
            closeDialogGlobal(context: context);
            // setState(() {});
          }

          Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
            void setStateOutsider() {
              setStateFromDialog(() {});
            }

            Widget titleTextWidget() {
              return Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text(borrowOrLendHistoryStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))], //TODO: change this
                ),
              );
            }

            Widget borrowOrLendHistoryListWidget() {
              //TODO: change this function name
              List<Widget> inWrapWidgetList() {
                return [
                  for (int borrowAndLendIndex = 0; borrowAndLendIndex < borrowOrLendModelListEmployeeGlobal.length; borrowAndLendIndex++) //TODO: change this
                    HistoryElement(
                      isForceShowNoEffect: false,
                      isAdminEditing: false,
                      index: borrowAndLendIndex,
                      borrowingOrLending: borrowOrLendModelListEmployeeGlobal[borrowAndLendIndex], //TODO: change this
                      setStateOutsider: setStateOutsider,
                    )
                ];
              }

              void topFunction() {}
              void bottomFunction() {
                if (!outOfDataQueryBorrowOrLendListGlobal) {
                  //TODO: change this
                  final int beforeQuery = borrowOrLendModelListEmployeeGlobal.length; //TODO: change this
                  void callBack() {
                    final int afterQuery = borrowOrLendModelListEmployeeGlobal.length; //TODO: change this

                    if (beforeQuery == afterQuery) {
                      outOfDataQueryBorrowOrLendListGlobal = true; //TODO: change this
                    } else {
                      skipBorrowOrLendListGlobal = skipBorrowOrLendListGlobal + queryLimitNumberGlobal; //TODO: change this
                    }
                    setStateFromDialog(() {});
                  }

                  getBorrowOrLendListEmployeeGlobal(
                    employeeId: profileModelEmployeeGlobal!.id!,
                    callBack: callBack,
                    context: context,
                    skip: skipBorrowOrLendListGlobal,
                    targetDate: DateTime.now(),
                    borrowOrLendModelListEmployee: borrowOrLendModelListEmployeeGlobal,
                  ); //TODO: change this
                }
              }

              return wrapScrollDetectWidget(
                inWrapWidgetList: inWrapWidgetList(),
                topFunction: topFunction,
                bottomFunction: bottomFunction,
                isShowSeeMoreWidget: !outOfDataQueryBorrowOrLendListGlobal,
              );
            }

            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleTextWidget(), Expanded(child: borrowOrLendHistoryListWidget())]);
          }

          actionDialogSetStateGlobal(
            dialogHeight: dialogSizeGlobal(level: Level.mini),
            dialogWidth: dialogSizeGlobal(level: Level.mini),
            cancelFunctionOnTap: cancelFunctionOnTap,
            context: context,
            contentFunctionReturnWidget: contentFunctionReturnWidget,
          );
        }

        return BodyTemplateSideMenu(
          bottomFunction: bottomFunction,
          isShowSeeMoreWidget: isShowSeeMoreWidget,
          title: widget.title,
          inWrapWidgetList: inWrapWidgetList(),
          historyOnTapFunction: historyOnTapFunction,
        );
      }

      // return _isLoadingOnGetCustomerList ? Container() : bodyTemplateSideMenu();
      return bodyTemplateSideMenu();
    }

    return loadingOrBody();
  }
}
