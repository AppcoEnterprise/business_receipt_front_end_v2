import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/change_setting.dart';
import 'package:business_receipt/env/function/delay_env.dart';
import 'package:business_receipt/env/function/loading_env.dart';
import 'package:business_receipt/env/function/refresh_page_env.dart';
import 'package:business_receipt/env/function/request_api/account_request_api_env.dart';
import 'package:business_receipt/env/function/socket_io.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_area_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/edit_setting_type.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_or_admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:flutter/material.dart';

//-------------------close dialog----------------------------
void closeDialogGlobal({required BuildContext context}) {
  setStateFromOutsideToDialogGlobal = null;
  return Navigator.pop(context);
}

class DialogBody extends StatefulWidget {
  final Function? forceToChangeFunctionOnTap;
  final Function? afterCloseFunction;
  final Function? cancelFunctionOnTap;
  final Function? deleteFunctionOnTap;
  final Function? restoreFunctionOnTap;
  final Function? okFunctionOnTap;
  final Function? saveFunctionOnTap;
  final Function? restartFunctionOnTap;

  final Function? clearFunctionOnTap;
  final Function? saveAndPrintFunctionOnTap;
  final Function? printFunctionOnTap;
  final Function? closeSellingFunctionOnTap;
  final Function? validPrintFunctionOnTap;
  final Function? validCloseSellingFunctionOnTap;
  final Function? validDeleteFunctionOnTap;
  final Function? validOkButtonFunction;
  final Function? validSaveButtonFunction;
  final Function? validSaveAndPrintButtonFunction;
  final Function? initFunction;
  final double dialogWidth;
  final double dialogHeight;
  final BuildContext context;
  final Function contentFunctionReturnWidget;
  DialogBody({
    super.key,
    required this.forceToChangeFunctionOnTap,
    required this.afterCloseFunction,
    required this.cancelFunctionOnTap,
    required this.deleteFunctionOnTap,
    required this.restoreFunctionOnTap,
    required this.okFunctionOnTap,
    required this.saveFunctionOnTap,
    required this.restartFunctionOnTap,
    required this.saveAndPrintFunctionOnTap,
    required this.printFunctionOnTap,
    required this.closeSellingFunctionOnTap,
    required this.validPrintFunctionOnTap,
    required this.validCloseSellingFunctionOnTap,
    required this.validDeleteFunctionOnTap,
    required this.validOkButtonFunction,
    required this.validSaveButtonFunction,
    required this.validSaveAndPrintButtonFunction,
    required this.initFunction,
    required this.dialogWidth,
    required this.dialogHeight,
    required this.context,
    required this.clearFunctionOnTap,
    required this.contentFunctionReturnWidget,
  });

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  @override
  void initState() {
    super.initState();
    setStateFromOutsideToDialogGlobal = setState;
    if (widget.initFunction != null) widget.initFunction!();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final ValidButtonModel validButtonDefault = ValidButtonModel(isValid: true);
    final ValidButtonModel isValidDeleteButton = (widget.validDeleteFunctionOnTap == null) ? validButtonDefault : widget.validDeleteFunctionOnTap!();
    final ValidButtonModel isValidOkButton = (widget.validOkButtonFunction == null) ? validButtonDefault : widget.validOkButtonFunction!();
    final ValidButtonModel isValidSaveButton = (widget.validSaveButtonFunction == null) ? validButtonDefault : widget.validSaveButtonFunction!();

    final ValidButtonModel isValidSaveAndPriceButton = (widget.validSaveAndPrintButtonFunction == null) ? validButtonDefault : widget.validSaveAndPrintButtonFunction!();
    final ValidButtonModel isValidCloseSellingButton = (widget.validCloseSellingFunctionOnTap == null) ? validButtonDefault : widget.validCloseSellingFunctionOnTap!();
    final ValidButtonModel isValidPrintButton = (widget.validPrintFunctionOnTap == null) ? validButtonDefault : widget.validPrintFunctionOnTap!();
    Widget setSizeWidget() {
      Widget paddingWidget() {
        Widget contentAndActions() {
          Widget actionsWidget() {
            Widget paddingTopLeftWidget({required Widget widget}) {
              return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini), left: paddingSizeGlobal(level: Level.mini)), child: widget);
            }

            return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.end, children: [
              (widget.forceToChangeFunctionOnTap == null)
                  ? Container()
                  : paddingTopLeftWidget(
                      widget: forceToChangeButtonOrContainerWidget(
                        context: context,
                        level: Level.normal,
                        onTapFunction: widget.forceToChangeFunctionOnTap,
                      ),
                    ),
              (widget.restartFunctionOnTap == null)
                  ? Container()
                  : paddingTopLeftWidget(
                      widget: restartButtonOrContainerWidget(
                        context: context,
                        level: Level.normal,
                        onTapFunction: widget.restartFunctionOnTap,
                      ),
                    ),
              (widget.restoreFunctionOnTap == null)
                  ? Container()
                  : paddingTopLeftWidget(
                      widget: restoreButtonOrContainerWidget(
                      context: context,
                      level: Level.normal,
                      onTapFunction: widget.restoreFunctionOnTap,
                    )),
              (widget.deleteFunctionOnTap == null)
                  ? Container()
                  : paddingTopLeftWidget(
                      widget: deleteButtonOrContainerWidget(
                      context: context,
                      level: Level.normal,
                      onTapFunction: widget.deleteFunctionOnTap,
                      validModel: isValidDeleteButton,
                    )),
              (widget.okFunctionOnTap == null)
                  ? Container()
                  : paddingTopLeftWidget(widget: okButtonOrContainerWidget(context: context, level: Level.normal, onTapFunction: widget.okFunctionOnTap, validModel: isValidOkButton)),
              (widget.saveFunctionOnTap == null)
                  ? Container()
                  : paddingTopLeftWidget(
                      widget: saveButtonOrContainerWidget(
                        context: context,
                        level: Level.normal,
                        onTapFunction: widget.saveFunctionOnTap,
                        validModel: isValidSaveButton,
                      ),
                    ),
              (widget.saveAndPrintFunctionOnTap == null)
                  ? Container()
                  : paddingTopLeftWidget(
                      widget: saveAndPrintButtonOrContainerWidget(context: context, level: Level.normal, onTapFunction: widget.saveAndPrintFunctionOnTap, validModel: isValidSaveAndPriceButton)),
              (widget.closeSellingFunctionOnTap == null)
                  ? Container()
                  : paddingTopLeftWidget(
                      widget: closeSellingButtonOrContainerWidget(context: context, level: Level.normal, onTapFunction: widget.closeSellingFunctionOnTap, validModel: isValidCloseSellingButton)),
              (widget.printFunctionOnTap == null)
                  ? Container()
                  : paddingTopLeftWidget(widget: printButtonOrContainerWidget(context: context, level: Level.normal, onTapFunction: widget.printFunctionOnTap, validModel: isValidPrintButton)),
              (widget.clearFunctionOnTap == null)
                  ? Container()
                  : paddingTopLeftWidget(
                      widget: clearButtonOrContainerWidget(
                        context: context,
                        level: Level.normal,
                        onTapFunction: widget.clearFunctionOnTap,
                      ),
                    ),
              (widget.cancelFunctionOnTap == null)
                  ? Container()
                  : paddingTopLeftWidget(widget: cancelButtonOrContainerWidget(context: context, level: Level.normal, onTapFunction: widget.cancelFunctionOnTap)),
            ]);
          }

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Expanded(child: widget.contentFunctionReturnWidget(setStateFromDialog: setState, screenSizeFromDialog: screenSize)), actionsWidget()]);
        }

        return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.large)), child: contentAndActions());
      }

      return SizedBox(width: widget.dialogWidth, height: widget.dialogHeight, child: paddingWidget());
    }

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadiusGlobal))),
      contentPadding: EdgeInsets.zero,
      content: setSizeWidget(),
    );
  }
}

//-------------------dialog setState----------------
//Widget contentDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) { return Container();}
//actionDialogSetStateGlobal(saveFunctionOnTap: () {});
//bool validSaveButtonFunction() {return true or false;}
Future actionDialogSetStateGlobal({
  Function? forceToChangeFunctionOnTap,
  Function? afterCloseFunction,
  Function? cancelFunctionOnTap,
  Function? deleteFunctionOnTap,
  Function? restoreFunctionOnTap,
  Function? okFunctionOnTap,
  Function? clearFunctionOnTap,
  Function? saveFunctionOnTap,
  Function? restartFunctionOnTap,
  Function? saveAndPrintFunctionOnTap,
  Function? printFunctionOnTap,
  Function? closeSellingFunctionOnTap,
  Function? validPrintFunctionOnTap,
  Function? validCloseSellingFunctionOnTap,
  Function? validDeleteFunctionOnTap,
  Function? validOkButtonFunction,
  Function? validSaveButtonFunction,
  Function? validSaveAndPrintButtonFunction,
  required double dialogWidth,
  required double dialogHeight,
  required BuildContext context,
  required Function contentFunctionReturnWidget,
  Function? initFunction,
}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return DialogBody(
        forceToChangeFunctionOnTap: forceToChangeFunctionOnTap,
        afterCloseFunction: afterCloseFunction,
        cancelFunctionOnTap: cancelFunctionOnTap,
        deleteFunctionOnTap: deleteFunctionOnTap,
        restoreFunctionOnTap: restoreFunctionOnTap,
        okFunctionOnTap: okFunctionOnTap,
        saveFunctionOnTap: saveFunctionOnTap,
        saveAndPrintFunctionOnTap: saveAndPrintFunctionOnTap,
        clearFunctionOnTap: clearFunctionOnTap,
        printFunctionOnTap: printFunctionOnTap,
        closeSellingFunctionOnTap: closeSellingFunctionOnTap,
        validPrintFunctionOnTap: validPrintFunctionOnTap,
        validCloseSellingFunctionOnTap: validCloseSellingFunctionOnTap,
        validDeleteFunctionOnTap: validDeleteFunctionOnTap,
        validOkButtonFunction: validOkButtonFunction,
        validSaveButtonFunction: validSaveButtonFunction,
        validSaveAndPrintButtonFunction: validSaveAndPrintButtonFunction,
        initFunction: initFunction,
        dialogWidth: dialogWidth,
        dialogHeight: dialogHeight,
        context: context,
        contentFunctionReturnWidget: contentFunctionReturnWidget,
        restartFunctionOnTap: restartFunctionOnTap,
      );
    },
  ).then((_) {
    final bool isHasFunction = (afterCloseFunction != null);
    return isHasFunction ? afterCloseFunction() : null;
  });
}

//------------------- dialog ----------------
Future actionDialogGlobal({
  Function? afterCloseFunction,
  Function? cancelFunction,
  Function? okFunction,
  Function? saveFunction,
  Function? saveAndPriceFunction,
  required double dialogWidth,
  required double dialogHeight,
  required BuildContext context,
  required Widget contentWidget,
}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      Widget setSizeWidget() {
        Widget paddingWidget() {
          Widget contentAndActions() {
            Widget actionsWidget() {
              Widget paddingTopLeftWidget({required Widget widget}) {
                return Padding(padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.mini), left: paddingSizeGlobal(level: Level.mini)), child: widget);
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  paddingTopLeftWidget(widget: okButtonOrContainerWidget(context: context, level: Level.normal, onTapFunction: okFunction)),
                  paddingTopLeftWidget(widget: saveButtonOrContainerWidget(context: context, level: Level.normal, onTapFunction: saveFunction)),
                  paddingTopLeftWidget(widget: saveAndPrintButtonOrContainerWidget(context: context, level: Level.normal, onTapFunction: saveAndPriceFunction)),
                  paddingTopLeftWidget(widget: cancelButtonOrContainerWidget(context: context, level: Level.normal, onTapFunction: cancelFunction)),
                ],
              );
            }

            return Column(children: [Expanded(child: contentWidget), actionsWidget()]);
          }

          return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.large)), child: contentAndActions());
        }

        return SizedBox(width: dialogWidth, height: dialogHeight, child: paddingWidget());
      }

      return AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadiusGlobal))),
        content: setSizeWidget(),
      );
    },
  ).then((_) {
    final bool isHasFunction = (afterCloseFunction != null);
    return isHasFunction ? afterCloseFunction() : null;
  });
}

//-------------------loading dialog---------------------
Future<void> loadingDialogGlobal({required BuildContext context, required String loadingTitle, bool isDelayLogInAndAdvance = false}) async {
  Widget loadingContentWidget() {
    return loadingWidgetGlobal(loadingTitle: loadingTitle);
  }

  actionDialogGlobal(dialogWidth: loadingDialogWidthGlobal, dialogHeight: loadingDialogHeightGlobal, context: context, contentWidget: loadingContentWidget());

  if (isDelayLogInAndAdvance) {
    await delayMillisecond(millisecond: delayTimeOutLoadingGlobal);

    void okFunction() {
      void callBack() {
        refreshPageGlobal();
      }

      final bool isAdmin = (profileModelEmployeeGlobal == null);
      if (isAdmin) {
        updateDeleteToTrueAdminGlobal(callBack: callBack, context: context);
      } else {
        updateDeleteToTrueEmployeeGlobal(callBack: callBack, context: context);
      }
    }

    okDialogGlobal(context: context, titleStr: timeOutGlobal, subtitleStr: timeOutConfirmConfirmGlobal, okFunction: okFunction);
  }
}

//-------------------confirm dialog---------------------
void confirmationWithTextFieldDialogGlobal({
  required BuildContext context,
  required String titleStr,
  required String subtitleStr,
  required TextEditingController remarkController,
  required Function okFunction,
  Function? printFunction,
  required Function cancelFunction,
  required String init,
}) {
  final String initRemark = remarkController.text;
  remarkController.text = init;
  Widget contentWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
    Widget titleWidget() {
      return Padding(
        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
        child: Text(titleStr, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
      );
    }

    Widget confirmWidget() {
      return Padding(
        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
        child: Text(subtitleStr, style: textStyleGlobal(level: Level.normal)),
      );
    }

    Widget remarkTextFieldWidget() {
      void onTapFromOutsiderFunction() {}
      void onChangeFromOutsiderFunction() {}

      return Padding(
        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
        child: textAreaGlobal(
          controller: remarkController,
          onTapFromOutsiderFunction: onTapFromOutsiderFunction,
          onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
          labelText: remarkOptionalStrGlobal,
          level: Level.normal,
        ),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleWidget(), confirmWidget(), remarkTextFieldWidget()]);
  }

  void cancelFunctionOnTap() {
    remarkController.text = initRemark;
    closeDialogGlobal(context: context);
    cancelFunction();
  }

  actionDialogSetStateGlobal(
    dialogWidth: confirmDeletedSizeBoxWidthGlobal,
    dialogHeight: confirmDeletedWithTextFieldSizeBoxHeightGlobal,
    context: context,
    okFunctionOnTap: okFunction,
    printFunctionOnTap: printFunction,
    contentFunctionReturnWidget: contentWidget,
    cancelFunctionOnTap: cancelFunctionOnTap,
  );
}

void confirmationDialogGlobal({
  required BuildContext context,
  required String titleStr,
  required String subtitleStr,
  required Function okFunction,
  required Function cancelFunction,
}) {
  Widget contentWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
    Widget titleWidget() {
      return Padding(
        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
        child: Text(titleStr, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
      );
    }

    Widget confirmWidget() {
      return Padding(
        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
        child: SingleChildScrollView(child: Wrap(children: [Text(subtitleStr, style: textStyleGlobal(level: Level.normal))])),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleWidget(), Expanded(child: confirmWidget())]);
  }

  void cancelFunctionOnTap() {
    closeDialogGlobal(context: context);
    cancelFunction();
  }

  void okFunctionOnTap() {
    okFunction();
    closeDialogGlobal(context: context);
  }

  actionDialogSetStateGlobal(
    dialogWidth: okSizeBoxWidthGlobal,
    dialogHeight: confirmDeletedSizeBoxHeightGlobal,
    context: context,
    okFunctionOnTap: okFunctionOnTap,
    contentFunctionReturnWidget: contentWidget,
    cancelFunctionOnTap: cancelFunctionOnTap,
  );
}

//-------------------ok dialog---------------------
void okDialogGlobal({required BuildContext context, required String titleStr, required String subtitleStr, required Function okFunction}) {
  Widget contentWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
    Widget titleWidget() {
      return Padding(
        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
        child: Text(titleStr, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
      );
    }

    Widget confirmWidget() {
      return Padding(
        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
        child: SingleChildScrollView(child: Wrap(children: [Text(subtitleStr, style: textStyleGlobal(level: Level.normal))])),
        // child: scrollText(textStr: subtitleStr, textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.topLeft),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleWidget(), Expanded(child: confirmWidget())]);
  }

  actionDialogSetStateGlobal(
    dialogWidth: okSizeBoxWidthGlobal,
    dialogHeight: okSizeBoxHeightGlobal,
    context: context,
    okFunctionOnTap: okFunction,
    contentFunctionReturnWidget: contentWidget,
  );
}

//-------------------restart dialog---------------------
void restartDialogGlobal({required BuildContext context, required String titleStr, required String subtitleStr, required Function okFunction}) {
  Widget contentWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
    Widget titleWidget() {
      return Padding(
        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
        child: Text(titleStr, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
      );
    }

    Widget confirmWidget() {
      return Padding(
        padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
        child: SingleChildScrollView(child: Wrap(children: [Text(subtitleStr, style: textStyleGlobal(level: Level.normal))])),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleWidget(), Expanded(child: confirmWidget())]);
  }

  actionDialogSetStateGlobal(
    dialogWidth: okSizeBoxWidthGlobal,
    dialogHeight: okSizeBoxHeightGlobal,
    context: context,
    restartFunctionOnTap: okFunction,
    contentFunctionReturnWidget: contentWidget,
  );
}

//-------------------asking for change dialog---------------------
void askingForChangeDialogGlobal({
  required BuildContext context,
  required Function allowFunction,
  required EditSettingTypeEnum editSettingTypeEnum,
  String? employeeId,
}) {
  if (profileEmployeeModelListAdminGlobal.isEmpty) {
    allowFunction();
  } else {
    setAskingForChangeAdminOrEmployeeSocketIO(isAskingForChange: true, editSettingTypeEnum: editSettingTypeEnum, targetEmployeeId: employeeId);
    Widget contentWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
      Widget titleWidget() {
        return Padding(
          padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
          child: Text(waitingForEmployeeAcceptChangeStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
        );
      }

      Widget employeeListAcceptationWidget() {
        Widget employeeElementWidget({required int index}) {
          final bool isAdmin = (profileModelEmployeeGlobal == null);
          if (!isAdmin) {
            if (askingForChangeFromEmployeeListGlobal[index].id == profileModelEmployeeGlobal!.id) {
              return Container();
            }
          }
          void onTapUnlessDisable() {}
          final bool isVisibleDisplayOption = getCheckVisibleDisplayOptionEmployee(
            employeeId: askingForChangeFromEmployeeListGlobal[index].id,
            displayBusinessOptionModel: askingForChangeFromEmployeeListGlobal[index].displayBusinessOptionModel!,
            editSettingType: editSettingTypeStrGlobal(editSettingTypeEnum: editSettingTypeEnum),
            targetEmployeeId: employeeId,
          );
          Widget insideSizeBoxWidget() {
            final String onlineOrOffline = askingForChangeFromEmployeeListGlobal[index].isOnline ? "Online" : "Offline";
            final Color onlineOrOfflineColor = askingForChangeFromEmployeeListGlobal[index].isOnline ? Colors.green : Colors.grey;
            String acceptOrWaiting = "Waiting";
            Color acceptOrWaitingColor = Colors.grey;
            if (isVisibleDisplayOption) {
              if (askingForChangeFromEmployeeListGlobal[index].isOnline) {
                if (!askingForChangeFromEmployeeListGlobal[index].isAskingForChange) {
                  if (askingForChangeFromEmployeeListGlobal[index].acceptIdForChange != null) {
                    final bool isAdminAsking = profileModelEmployeeGlobal == null;
                    if (isAdminAsking) {
                      if (askingForChangeFromEmployeeListGlobal[index].acceptIdForChange == profileModelAdminGlobal!.id) {
                        acceptOrWaiting = "Accepted";
                        acceptOrWaitingColor = Colors.green;
                      } else {
                        acceptOrWaiting = "Unaccepted";
                        acceptOrWaitingColor = Colors.red;
                      }
                    } else {
                      if (askingForChangeFromEmployeeListGlobal[index].acceptIdForChange == profileModelEmployeeGlobal!.id) {
                        acceptOrWaiting = "Accepted";
                        acceptOrWaitingColor = Colors.green;
                      } else {
                        acceptOrWaiting = "Unaccepted";
                        acceptOrWaitingColor = Colors.red;
                      }
                    }
                  }
                } else {
                  acceptOrWaiting = "Asking For Change";
                  acceptOrWaitingColor = Colors.grey;
                }
              } else {
                acceptOrWaiting = "";
              }
            } else {
              acceptOrWaiting = "Not Related";
              acceptOrWaitingColor = Colors.grey;
            }
            return Row(children: [
              Text(onlineOrOffline, style: textStyleGlobal(level: Level.normal, color: onlineOrOfflineColor)),
              Expanded(child: Text(" | ${askingForChangeFromEmployeeListGlobal[index].name}", style: textStyleGlobal(level: Level.normal))),
              Text(acceptOrWaiting, style: textStyleGlobal(level: Level.normal, color: acceptOrWaitingColor)),
            ]);
          }

          bool checkIsDisable() {
            if (isVisibleDisplayOption) {
              if (askingForChangeFromEmployeeListGlobal[index].isOnline) {
                if (askingForChangeFromEmployeeListGlobal[index].isAskingForChange) {
                  return true;
                }
                if (askingForChangeFromEmployeeListGlobal[index].acceptIdForChange != null) {
                  return false;
                } else {
                  if (askingForChangeFromEmployeeListGlobal[index].acceptIdForChange == "") {
                    return false;
                  }
                  final bool isAdminAsking = profileModelEmployeeGlobal == null;
                  if (isAdminAsking) {
                    if (askingForChangeFromEmployeeListGlobal[index].acceptIdForChange == profileModelAdminGlobal!.name.text) {
                      return true;
                    } else {
                      return false;
                    }
                  } else {
                    if (askingForChangeFromEmployeeListGlobal[index].acceptIdForChange == profileModelEmployeeGlobal!.name.text) {
                      return true;
                    } else {
                      return false;
                    }
                  }
                }
              }
            }
            return true;
          }

          return Padding(
            padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
            child: CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable, isDisable: checkIsDisable()),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(paddingSizeGlobal(level: Level.normal)),
            child: Column(children: [
              for (int index = 0; index < askingForChangeFromEmployeeListGlobal.length; index++) employeeElementWidget(index: index),
            ]),
          ),
        );
      }

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleWidget(), employeeListAcceptationWidget()]);
    }

    void cancelFunctionOnTap() {
      void okFunction() {
        setAskingForChangeAdminOrEmployeeSocketIO(isAskingForChange: false, editSettingTypeEnum: editSettingTypeEnum, targetEmployeeId: employeeId);
        closeDialogGlobal(context: context);
      }

      void cancelFunction() {}
      confirmationDialogGlobal(
        context: context,
        okFunction: okFunction,
        cancelFunction: cancelFunction,
        titleStr: cancelEditingSettingGlobal,
        subtitleStr: cancelEditingSettingConfirmGlobal,
      );
    }

    void allowFunctionSub() {
      setAskingForChangeAdminOrEmployeeSocketIO(isAskingForChange: false, editSettingTypeEnum: editSettingTypeEnum, targetEmployeeId: employeeId);
      closeDialogGlobal(context: context);
      allowFunction();
    }

    ValidButtonModel getAllowToChangeAdminOrEmployeeGlobal() {
      final bool isAdmin = (profileModelEmployeeGlobal == null);
      final String adminIdOrEmployeeId = isAdmin ? profileModelAdminGlobal!.id! : profileModelEmployeeGlobal!.id!;
      for (int employeeIndex = 0; employeeIndex < askingForChangeFromEmployeeListGlobal.length; employeeIndex++) {
        final bool isVisibleDisplayOption = getCheckVisibleDisplayOptionEmployee(
          employeeId: askingForChangeFromEmployeeListGlobal[employeeIndex].id,
          displayBusinessOptionModel: askingForChangeFromEmployeeListGlobal[employeeIndex].displayBusinessOptionModel!,
          editSettingType: editSettingTypeStrGlobal(editSettingTypeEnum: editSettingTypeEnum),
          targetEmployeeId: employeeId,
        );
        if ((askingForChangeFromEmployeeListGlobal[employeeIndex].acceptIdForChange != adminIdOrEmployeeId) &&
            (askingForChangeFromEmployeeListGlobal[employeeIndex].isOnline) &&
            !askingForChangeFromEmployeeListGlobal[employeeIndex].isAskingForChange &&
            isVisibleDisplayOption) {
          if (isAdmin) {
            // return ValidButtonModel(isValid: false, errorStr: "Wait for the online and relate option employee(s) to accept.");
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.waitAllEmployeeAccept,
              error: "Wait for ${askingForChangeFromEmployeeListGlobal[employeeIndex].name} to accept.",
            );
          } else {
            if (askingForChangeFromEmployeeListGlobal[employeeIndex].id != profileModelEmployeeGlobal!.id) {
              // return ValidButtonModel(isValid: false, errorStr: "Wait for the online and relate option employee(s) to accept.");
              return ValidButtonModel(
                isValid: false,
                errorType: ErrorTypeEnum.waitAllEmployeeAccept,
                error: "Wait for ${askingForChangeFromEmployeeListGlobal[employeeIndex].name} to accept.",
              );
            }
          }
        }
      }
      // return ValidButtonModel(isValid: true, errorStr: "");
      return ValidButtonModel(isValid: true);
    }

    void forceToChangeFunctionOnTap() {
      // void okFunction() {
      // closeDialogGlobal(context: context);
      allowFunctionSub();
      // }

      // void cancelFunction() {}
      // confirmationDialogGlobal(
      //   context: context,
      //   okFunction: okFunction,
      //   cancelFunction: cancelFunction,
      //   titleStr: forceChangeConfirmGlobal,
      //   subtitleStr: forceChangeConfirmContentGlobal,
      // );
    }

    actionDialogSetStateGlobal(
      dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.05,
      dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.05,
      context: context,
      okFunctionOnTap: allowFunctionSub,
      validOkButtonFunction: () => getAllowToChangeAdminOrEmployeeGlobal(),
      forceToChangeFunctionOnTap: forceToChangeFunctionOnTap,
      cancelFunctionOnTap: cancelFunctionOnTap,
      contentFunctionReturnWidget: contentWidget,
    );
  }
}

void errorDetailDialogGlobal({required BuildContext context, required ValidButtonModel validModel}) {
  Widget editCustomerDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
    final ContentAndTitleListModel contentAndTitleListModel = getContentAndTitleListModel(errorTypeEnum: validModel.errorType);
    Widget paddingBottomTitleWidget() {
      Widget titleWidget() {
        return Text(contentAndTitleListModel.content, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold));
      }

      return Padding(padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)), child: titleWidget());
    }

    Widget paddingBottomRuleWidget() {
      if (validModel.overwriteRule == null) {
        if (contentAndTitleListModel.subContent != null) {
          return Padding(
            padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
            child: Text("The Rule: ${contentAndTitleListModel.subContent!.subtitle}", style: textStyleGlobal(level: Level.normal)),
          );
        }
      } else {
        return Padding(
          padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
          child: Text("The Rule: ${validModel.overwriteRule}", style: textStyleGlobal(level: Level.normal)),
        );
      }
      return Container();
    }

    Widget paddingBottomErrorWidget() {
      if (validModel.error != null) {
        return Padding(
          padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
          child: Wrap(direction: Axis.horizontal, children: [
            Text("Invalid: ", style: textStyleGlobal(level: Level.normal)),
            Text(validModel.error!, style: textStyleGlobal(level: Level.normal, color: Colors.red)),
          ]),
        );
      }
      return Container();
    }

    Widget paddingBottomErrorLocationWidget() {
      if (validModel.errorLocationList.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Error Location:", style: textStyleGlobal(level: Level.normal)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: validModel.errorLocationList.map((e) {
                  return Padding(
                    padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)),
                    child: Text("${e.title}: ${e.subtitle}", style: textStyleGlobal(level: Level.normal)),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }
      return Container();
    }

    Widget paddingBottomDetailWidget() {
      if (validModel.detailList.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Detail:", style: textStyleGlobal(level: Level.normal)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: validModel.detailList.map((e) {
                  return Padding(
                    padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)),
                    child: Text("${e.title}: ${e.subtitle}", style: textStyleGlobal(level: Level.normal)),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }
      return Container();
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      paddingBottomTitleWidget(),
      Expanded(
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            paddingBottomRuleWidget(),
            paddingBottomErrorLocationWidget(),
            paddingBottomErrorWidget(),
            paddingBottomDetailWidget(),
          ]),
        ),
      ),
    ]);
  }

  void okFunctionOnTap() {
    closeDialogGlobal(context: context);
  }

  actionDialogSetStateGlobal(
    dialogHeight: dialogSizeGlobal(level: Level.mini) * 0.5,
    dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.1,
    context: context,
    okFunctionOnTap: okFunctionOnTap,
    contentFunctionReturnWidget: editCustomerDialog,
  );
}
