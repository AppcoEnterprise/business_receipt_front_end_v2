import 'package:business_receipt/env/function/active_log.dart';
import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/drop_zone.dart';
import 'package:business_receipt/env/function/history.dart';
import 'package:business_receipt/env/function/hover_and_button.dart';
import 'package:business_receipt/env/function/print.dart';
import 'package:business_receipt/env/function/request_api/excel_request_api_env.dart';
import 'package:business_receipt/env/function/text/scroll_text_env.dart';
import 'package:business_receipt/env/function/text/text_area_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/active_log.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/employee_model/active_log_model.dart';
import 'package:business_receipt/model/employee_model/excel_employee_model.dart';
import 'package:business_receipt/model/employee_model/file_model.dart';
import 'package:business_receipt/model/money_type_and_value_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:business_receipt/state/side_menu/set_up_print_dialog.dart';
import 'package:flutter/material.dart';

class ImportFromExcelEmployee extends StatefulWidget {
  String title;
  Function callback;
  ImportFromExcelEmployee({Key? key, required this.title, required this.callback}) : super(key: key);

  @override
  State<ImportFromExcelEmployee> createState() => _ImportFromExcelEmployeeState();
}

class _ImportFromExcelEmployeeState extends State<ImportFromExcelEmployee> {
  List<ActiveLogModel> activeLogModelExcelList = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyTemplateSideMenu() {
      List<Widget> inWrapWidgetList() {
        Widget customerButtonWidget({required int excelAdminIndex}) {
          Widget setWidthSizeBox() {
            Widget insideSizeBoxWidget() {
              final DateTime? deleteDateOrNull = excelAdminModelListGlobal[excelAdminIndex].deletedDate;

              Widget deleteDateScrollTextWidget() {
                return (deleteDateOrNull == null)
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(top: paddingSizeGlobal(level: Level.normal)),
                        child: scrollText(
                          textStr: "$deleteAtStrGlobal ${formatFullDateToStr(date: deleteDateOrNull.add(const Duration(days: deleteAtDay)))}",
                          textStyle: textStyleGlobal(level: Level.mini, fontWeight: FontWeight.bold, color: Colors.red),
                          alignment: Alignment.topCenter,
                        ),
                      );
              }

              Widget dataCountWidget() {
                ExcelEmployeeModel? excelEmployeeOrNull;
                final int excelIndex =
                    excelListEmployeeGlobal.indexWhere((element) => (element.excelConfigId == excelAdminModelListGlobal[excelAdminIndex].id));
                if (excelIndex != -1) {
                  excelEmployeeOrNull = excelListEmployeeGlobal[excelIndex];
                }
                return (excelEmployeeOrNull == null)
                    ? Container()
                    : Text("Data Count: ${excelEmployeeOrNull.countData}", style: textStyleGlobal(level: Level.normal));
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    excelAdminModelListGlobal[excelAdminIndex].excelName.text,
                    style: textStyleGlobal(
                      level: Level.large,
                      fontWeight: FontWeight.bold,
                      color: (deleteDateOrNull == null) ? defaultTextColorGlobal : deleteTextColorGlobal,
                    ),
                  ),
                  dataCountWidget(),
                  deleteDateScrollTextWidget(),
                ],
              );
            }

            void onTapUnlessDisable() {
              limitHistory();
              addActiveLogElement(
                activeLogModelList: activeLogModelExcelList,
                activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
                  Location(title: "excel index", subtitle: excelAdminIndex.toString()),
                  Location(title: "button name", subtitle: excelAdminModelListGlobal[excelAdminIndex].excelName.text),
                ]),
              );

              ExcelEmployeeModel? excelEmployeeOrNull;
              ExcelFileModel? excelFileModel;
              final int excelIndex = excelListEmployeeGlobal.indexWhere((element) => (element.excelConfigId == excelAdminModelListGlobal[excelAdminIndex].id));
              if (excelIndex != -1) {
                excelEmployeeOrNull = excelListEmployeeGlobal[excelIndex];
              }

              void cancelFunctionOnTap() {
                addActiveLogElement(
                  activeLogModelList: activeLogModelExcelList,
                  activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
                    Location(title: "excel index", subtitle: excelAdminIndex.toString()),
                    Location(title: "excel name", subtitle: excelAdminModelListGlobal[excelAdminIndex].excelName.text),
                    Location(title: "button name", subtitle: "cancel button"),
                  ]),
                );
                void okFunction() {
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

              ValidButtonModel validSaveButtonFunction() {
                if (excelEmployeeOrNull != null) {
                  // return !(excelEmployeeOrNull!.id != null);
                  return ValidButtonModel(isValid: !(excelEmployeeOrNull!.id != null), error: "Data is empty.");
                } else {
                  // return false;
                  return ValidButtonModel(isValid: false, error: "Data is empty.");
                }
              }

              void saveFunctionOnTap() {
                addActiveLogElement(
                  activeLogModelList: activeLogModelExcelList,
                  activeLogModel: ActiveLogModel(
                    idTemp: "save button",
                    activeType: ActiveLogTypeEnum.clickButton,
                    locationList: [
                      Location(title: "excel index", subtitle: excelAdminIndex.toString()),
                      Location(title: "excel name", subtitle: excelAdminModelListGlobal[excelAdminIndex].excelName.text),
                      Location(color: ColorEnum.blue, title: "button name", subtitle: "save button"),
                    ],
                  ),
                );

                setFinalEditionActiveLog(activeLogModelList: activeLogModelExcelList);
                excelEmployeeOrNull!.activeLogModelList = activeLogModelExcelList;

                void callBack() {
                  // closeDialogGlobal(context: context);
                  closeDialogGlobal(context: context);
                  activeLogModelExcelList = [];
                  widget.callback();
                }

                updateExcelEmployeeGlobal(callBack: callBack, context: context, excelEmployee: excelEmployeeOrNull!);
              }

              Widget editCustomerDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
                Widget dropZone() {
                  return Expanded(
                    child: DropZoneWidget(
                      callBackDropZone: () {
                        addActiveLogElement(
                          activeLogModelList: activeLogModelExcelList,
                          activeLogModel: ActiveLogModel(
                            idTemp: "import excel",
                            activeType: ActiveLogTypeEnum.importFileFromExcel,
                            locationList: [
                              Location(title: "excel index", subtitle: excelAdminIndex.toString()),
                              Location(title: "excel name", subtitle: excelAdminModelListGlobal[excelAdminIndex].excelName.text),
                              Location(color: ColorEnum.green, title: "import excel", subtitle: "drop file"),
                            ],
                          ),
                        );
                      },
                      callBackChooseFile: () {
                        addActiveLogElement(
                          activeLogModelList: activeLogModelExcelList,
                          activeLogModel: ActiveLogModel(
                            idTemp: "import excel",
                            activeType: ActiveLogTypeEnum.importFileFromExcel,
                            locationList: [
                              Location(title: "excel index", subtitle: excelAdminIndex.toString()),
                              Location(title: "excel name", subtitle: excelAdminModelListGlobal[excelAdminIndex].excelName.text),
                              Location(color: ColorEnum.blue, title: "import excel", subtitle: "choose file"),
                            ],
                          ),
                        );
                      },
                      onDroppedFile: (ExcelFileModel value) {
                        excelEmployeeOrNull = value.getExcelEmployeeModel(excelAdminIndex: excelAdminIndex, context: context);
                        if (excelEmployeeOrNull == null) {
                          void okFunction() {
                            closeDialogGlobal(context: context);
                            setStateFromDialog(() {});
                          }

                          okDialogGlobal(context: context, okFunction: okFunction, titleStr: 'Excel Error', subtitleStr: 'Some data is missing.');
                        }

                        // closeDialogGlobal(context: context);
                        excelFileModel = value;
                        setStateFromDialog(() {});
                      },
                      excelEmployeeModel: excelEmployeeOrNull,
                    ),
                  );
                }

                Widget display() {
                  Widget textWidget({required String titleStr, required String subtitleStr}) {
                    return scrollText(textStr: "$titleStr: $subtitleStr", textStyle: textStyleGlobal(level: Level.normal), alignment: Alignment.centerLeft);
                  }

                  Widget sizeBoxWidget({required int index}) {
                    Widget printOrContainerWidget() {
                      void onTapFunction() {
                        for (int otherIndex = 0; otherIndex < printModelGlobal.otherList.length; otherIndex++) {
                          if (printModelGlobal.otherList[otherIndex].title.text == excelEmployeeOrNull!.dataList[index].printTypeName) {
                            printOtherInvoice(context: context, printCustomize: printModelGlobal.otherList[otherIndex]);
                            return;
                          }
                        }
                        setUpOtherPrint(isCreateNewOtherPrint: true, otherIndex: null, context: context, setState: setState);
                      }

                      final bool isAdminEditing = (excelAdminModelListGlobal[excelAdminIndex].deletedDate == null && profileModelEmployeeGlobal == null);
                      return !isAdminEditing
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                printAndDeleteWidgetGlobal(
                                  context: context,
                                  isHovering: excelEmployeeOrNull!.dataList[index].isHover,
                                  onPrintFunction: onTapFunction,
                                  onDeleteFunction: null,
                                  isDelete: false,
                                ),
                              ],
                            )
                          : Container();
                    }

                    Widget insideSizeBoxWidget() {
                      final String moneyTypeStr = excelEmployeeOrNull!.dataList[index].moneyType;
                      final double profitNumber = excelEmployeeOrNull!.dataList[index].profit;
                      final double amountNumber = excelEmployeeOrNull!.dataList[index].amount;
                      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            Text("${index + 1}. ${excelEmployeeOrNull!.dataList[index].name}",
                                style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold))
                          ]),
                        ),
                        (excelEmployeeOrNull!.dataList[index].id == null)
                            ? Container()
                            : textWidget(titleStr: "Invoice Id", subtitleStr: excelEmployeeOrNull!.dataList[index].id!),
                        textWidget(titleStr: "Date", subtitleStr: formatFullDateToStr(date: excelEmployeeOrNull!.dataList[index].date)),
                        textWidget(titleStr: "Status", subtitleStr: excelEmployeeOrNull!.dataList[index].status),
                        textWidget(titleStr: "ID", subtitleStr: excelEmployeeOrNull!.dataList[index].txnID),
                        textWidget(titleStr: "Print Type Name", subtitleStr: excelEmployeeOrNull!.dataList[index].printTypeName),
                        // textWidget(
                        //   titleStr: "Amount",
                        //   subtitleStr: "${formatAndLimitNumberTextGlobal(valueStr: excelEmployeeOrNull!.dataList[index].amount.toString(), isRound: false)} $moneyTypeStr",
                        // ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            Text("Amount: ", style: textStyleGlobal(level: Level.normal)),
                            Text(
                              "${formatAndLimitNumberTextGlobal(valueStr: amountNumber.toString(), isRound: false)} $moneyTypeStr",
                              style: textStyleGlobal(level: Level.normal, color: (amountNumber >= 0) ? positiveColorGlobal : negativeColorGlobal),
                            ),
                            Text(" (no effect)", style: textStyleGlobal(level: Level.normal, color: Colors.grey)),
                          ]),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            Text("Profit: ", style: textStyleGlobal(level: Level.normal)),
                            Text(
                              "${formatAndLimitNumberTextGlobal(valueStr: profitNumber.toString(), isRound: false)} $moneyTypeStr",
                              style: textStyleGlobal(level: Level.normal, color: (profitNumber >= 0) ? positiveColorGlobal : negativeColorGlobal),
                            ),
                          ]),
                        ),
                        printOrContainerWidget(),
                      ]);
                    }

                    customHoverFunction({required bool isHovering}) {
                      excelEmployeeOrNull!.dataList[index].isHover = isHovering;
                      setStateFromDialog(() {});
                    }

                    void onTapUnlessDisable() {}
                    return CustomButtonGlobal(
                      insideSizeBoxWidget: insideSizeBoxWidget(),
                      onTapUnlessDisable: onTapUnlessDisable,
                      customHoverFunction: customHoverFunction,
                    );
                  }

                  Widget profitListWidget() {
                    Widget profitTextWidget({required int profitIndex}) {
                      final double profitNumber = excelEmployeeOrNull!.profitList[profitIndex].value;
                      final String moneyTypeStr = excelEmployeeOrNull!.profitList[profitIndex].moneyType;
                      return Row(
                        children: [
                          // Text((profitIndex == 0) ? "" : " | ", style: textStyleGlobal(level: Level.normal)),
                          Text(
                            "${formatAndLimitNumberTextGlobal(valueStr: profitNumber.toString(), isRound: false)} $moneyTypeStr",
                            style: textStyleGlobal(level: Level.normal, color: (profitNumber >= profitNumber) ? positiveColorGlobal : negativeColorGlobal),
                          ),
                          Text((profitIndex == (excelEmployeeOrNull!.profitList.length - 1)) ? "" : " | ", style: textStyleGlobal(level: Level.normal)),
                        ],
                      );
                    }

                    return excelEmployeeOrNull!.profitList.isEmpty
                        ? Container()
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              Text("Profit: ", style: textStyleGlobal(level: Level.normal)),
                              for (int profitIndex = 0; profitIndex < excelEmployeeOrNull!.profitList.length; profitIndex++)
                                profitTextWidget(profitIndex: profitIndex),
                            ]),
                          );
                  }

                  Widget remarkTextFieldWidget() {
                    void onTapFromOutsiderFunction() {}
                    void onChangeFromOutsiderFunction() {
                      setStateFromDialog(() {});
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.normal)),
                      child: textAreaGlobal(
                        isEnabled: validSaveButtonFunction().isValid,
                        controller: excelEmployeeOrNull!.remark,
                        onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                        onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                        labelText: remarkOptionalStrGlobal,
                        level: Level.normal,
                      ),
                    );
                  }

                  void topFunction() {}
                  void bottomFunction() {
                    if (!outOfDataQueryExcelListGlobal && (excelFileModel == null)) {
                      final int beforeQuery = excelEmployeeOrNull!.dataList.length;
                      void callBack() {
                        final int afterQuery = excelEmployeeOrNull!.dataList.length;

                        if (beforeQuery == afterQuery) {
                          outOfDataQueryExcelListGlobal = true;
                        } else {
                          skipExcelListGlobal = skipExcelListGlobal + queryLimitNumberGlobal;
                        }
                        setStateFromDialog(() {});
                      }

                      getExcelListEmployeeGlobal(
                        callBack: callBack,
                        context: context,
                        skip: skipExcelListGlobal,
                        excelConfigId: excelEmployeeOrNull!.excelConfigId!,
                      );
                    }
                  }

                  return Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      (excelFileModel == null) ? Container() : textWidget(titleStr: "File Name", subtitleStr: excelFileModel!.name),
                      (excelFileModel == null) ? Container() : textWidget(titleStr: "File Size", subtitleStr: excelFileModel!.size),
                      textWidget(
                          titleStr: "Data Count",
                          subtitleStr: formatAndLimitNumberTextGlobal(valueStr: excelEmployeeOrNull!.countData.toString(), isRound: false)),
                      profitListWidget(),
                      remarkTextFieldWidget(),
                      Expanded(
                        child: wrapScrollDetectWidget(
                          inWrapWidgetList: [for (int index = 0; index < excelEmployeeOrNull!.dataList.length; index++) sizeBoxWidget(index: index)],
                          topFunction: topFunction,
                          bottomFunction: bottomFunction,
                          isShowSeeMoreWidget: !outOfDataQueryExcelListGlobal && (excelFileModel == null),
                        ),
                      )
                      // Expanded(
                      //   child: SingleChildScrollView(
                      //     child: Padding(
                      //       padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
                      //       child: Column(children: [for (int index = 0; index < excelEmployeeOrNull!.dataList.length; index++) sizeBoxWidget(index: index)]),
                      //     ),
                      //   ),
                      // ),
                    ]),
                  );
                }

                Widget titleWidget() {
                  return Padding(
                    padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                    child: Text(excelAdminModelListGlobal[excelAdminIndex].excelName.text,
                        style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
                  );
                }

                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleWidget(), (excelEmployeeOrNull == null) ? dropZone() : display()]);
              }

              void deleteFunctionOrNull() {
                addActiveLogElement(
                  activeLogModelList: activeLogModelExcelList,
                  activeLogModel: ActiveLogModel(activeType: ActiveLogTypeEnum.clickButton, locationList: [
                    Location(title: "excel index", subtitle: excelAdminIndex.toString()),
                    Location(title: "excel name", subtitle: excelAdminModelListGlobal[excelAdminIndex].excelName.text),
                    Location(color: ColorEnum.red, title: "button name", subtitle: "delete button"),
                  ]),
                );
                void okFunction() {
                  void callBack() {
                    closeDialogGlobal(context: context);
                    activeLogModelExcelList = [];
                    widget.callback();
                  }

                  deleteExcelEmployeeGlobal(callBack: callBack, context: context, excelConfigId: excelEmployeeOrNull!.excelConfigId!);
                }

                void cancelFunction() {}
                confirmationDialogGlobal(
                  context: context,
                  okFunction: okFunction,
                  cancelFunction: cancelFunction,
                  titleStr: "$deleteGlobal data of ${excelAdminModelListGlobal[excelAdminIndex].excelName.text}",
                  subtitleStr: deleteConfirmGlobal,
                );
              }

              ValidButtonModel validDeleteFunctionOnTap() {
                if (excelEmployeeOrNull != null) {
                  // return (excelEmployeeOrNull!.id != null);
                  return ValidButtonModel(isValid: (excelEmployeeOrNull!.id != null), error: "Data is empty.");
                } else {
                  // return false;
                  return ValidButtonModel(isValid: false, error: ".");
                }
              }

              actionDialogSetStateGlobal(
                dialogHeight: dialogSizeGlobal(level: Level.mini),
                dialogWidth: dialogSizeGlobal(level: Level.mini),
                cancelFunctionOnTap: cancelFunctionOnTap,
                context: context,
                validSaveButtonFunction: () => validSaveButtonFunction(),
                validDeleteFunctionOnTap: () => validDeleteFunctionOnTap(),
                saveFunctionOnTap:
                    ((excelAdminModelListGlobal[excelAdminIndex].deletedDate == null) && (excelEmployeeOrNull == null)) ? saveFunctionOnTap : null,
                contentFunctionReturnWidget: editCustomerDialog,
                deleteFunctionOnTap:
                    ((excelAdminModelListGlobal[excelAdminIndex].deletedDate == null) && (excelEmployeeOrNull != null)) ? deleteFunctionOrNull : null,
              );
            }

            return CustomButtonGlobal(
              sizeBoxWidth: sizeBoxWidthGlobal,
              sizeBoxHeight: sizeBoxHeightGlobal,
              insideSizeBoxWidget: insideSizeBoxWidget(),
              onTapUnlessDisable: onTapUnlessDisable,
            );
          }

          return setWidthSizeBox();
        }

        return [
          for (int excelIndex = 0; excelIndex < excelAdminModelListGlobal.length; excelIndex++)
            (excelAdminModelListGlobal[excelIndex].deletedDate != null) ? Container() : customerButtonWidget(excelAdminIndex: excelIndex)
        ];
      }

      void historyOnTapFunction() {
        limitHistory();
        addActiveLogElement(
          activeLogModelList: activeLogModelExcelList,
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
                children: [Text(excelHistoryStrGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))], //TODO: change this
              ),
            );
          }

          //TODO: change this function name
          Widget excelHistoryListWidget() {
            List<Widget> inWrapWidgetList() {
              return [
                for (int excelIndex = 0; excelIndex < excelHistoryListEmployeeGlobal.length; excelIndex++) //TODO: change this
                  HistoryElement(
                    isForceShowNoEffect: true,
                    isAdminEditing: false,
                    index: excelIndex,
                    excelData: excelHistoryListEmployeeGlobal[excelIndex], //TODO: change this
                    setStateOutsider: setStateOutsider,
                  )
              ];
            }

            void topFunction() {}
            void bottomFunction() {
              if (!outOfDataQueryExcelHistoryListGlobal) {
                //TODO: change this
                final int beforeQuery = excelHistoryListEmployeeGlobal.length; //TODO: change this
                void callBack() {
                  final int afterQuery = excelHistoryListEmployeeGlobal.length; //TODO: change this
                  if (beforeQuery == afterQuery) {
                    outOfDataQueryExcelHistoryListGlobal = true; //TODO: change this
                  } else {
                    skipExcelHistoryListGlobal = skipExcelHistoryListGlobal + queryLimitNumberGlobal; //TODO: change this
                  }
                  setStateFromDialog(() {});
                }

                getExcelHistoryListEmployeeGlobal(
                  employeeId: profileModelEmployeeGlobal!.id!,
                  callBack: callBack,
                  context: context,
                  skip: skipExcelHistoryListGlobal,
                  targetDate: DateTime.now(),
                  excelListEmployee: excelHistoryListEmployeeGlobal,
                ); //TODO: change this
              }
            }

            return wrapScrollDetectWidget(
              inWrapWidgetList: inWrapWidgetList(),
              topFunction: topFunction,
              bottomFunction: bottomFunction,
              isShowSeeMoreWidget: !outOfDataQueryExcelHistoryListGlobal,
            );
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleTextWidget(), Expanded(child: excelHistoryListWidget())]);
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
        title: widget.title,
        inWrapWidgetList: inWrapWidgetList(),
        historyOnTapFunction: historyOnTapFunction,
      );
    }

    return bodyTemplateSideMenu();
  }
}
