// ignore_for_file: must_be_immutable

import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/toggle_env.dart';
import 'package:business_receipt/env/function/wrap_scroll_detect.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:flutter/material.dart';

class BodyTemplateSideMenu extends StatefulWidget {
  int maxAddButtonLimit;
  int currentAddButtonQty;
  String title;
  // bool isShowPrevious;
  // bool isValidShowPrevious;
  bool isShowSeeMoreWidget;
  ValidButtonModel? isValidAddOnTap;
  ValidButtonModel? isValidSaveOnTap;
  ValidButtonModel? isValidSaveAndPrintOnTap;
  ValidButtonModel? isValidAnalysisOnTap;
  ValidButtonModel? isValidCalculateOnTap;
  ValidButtonModel? isValidAdvanceCalculateOnTap;
  ValidButtonModel? isValidHistoryAsyncOnTap;
  ValidButtonModel? isValidRefreshAsyncOnTap;
  List<Widget?> inWrapWidgetList;
  Widget? previousWidget;
  Function? calculateOnTapFunction;
  Function? advanceCalculateOnTapFunction;
  Function? historyOnTapFunction;
  Function? historyAsyncOnTapFunction;
  Function? addOnTapFunction;
  Function? analysisOnTapFunction;
  // Function? previousOnTapFunction;
  Function? saveOnTapFunction;
  Function? saveAndPrintOnTapFunction;
  Widget? customBetweenHeaderAndBodyWidget;
  Widget? customRowBetweenHeaderAndBodyWidget;
  Function? topFunction;
  Function? bottomFunction;
  Function? clearFunction;
  Function? refreshFunction;
  bool? isFormatToggle;
  Function? formatToggleFunction;
  BodyTemplateSideMenu({
    Key? key,
    this.currentAddButtonQty = 0,
    this.maxAddButtonLimit = 0,
    this.isShowSeeMoreWidget = false,
    this.isValidAddOnTap,
    this.isValidSaveOnTap,
    this.isValidSaveAndPrintOnTap,
    this.isValidAnalysisOnTap,
    this.isValidCalculateOnTap,
    this.isValidAdvanceCalculateOnTap,
    this.isValidHistoryAsyncOnTap,
    this.isValidRefreshAsyncOnTap,
    required this.title,
    required this.inWrapWidgetList,
    this.customBetweenHeaderAndBodyWidget,
    this.customRowBetweenHeaderAndBodyWidget,
    // this.previousWidget,
    this.calculateOnTapFunction,
    this.advanceCalculateOnTapFunction,
    this.historyOnTapFunction,
    this.historyAsyncOnTapFunction,
    this.clearFunction,
    this.addOnTapFunction,
    this.analysisOnTapFunction,
    // this.previousOnTapFunction,
    this.saveOnTapFunction,
    this.saveAndPrintOnTapFunction,
    // this.isShowPrevious = false,
    this.topFunction,
    this.bottomFunction,
    this.refreshFunction,
    this.isFormatToggle,
    this.formatToggleFunction,
  }) : super(key: key);

  @override
  _BodyTemplateSideMenuState createState() => _BodyTemplateSideMenuState();
}

class _BodyTemplateSideMenuState extends State<BodyTemplateSideMenu> {
  @override
  void initState() {
    super.initState();

    widget.isValidAddOnTap ??= ValidButtonModel(isValid: true);
    widget.isValidSaveOnTap ??= ValidButtonModel(isValid: true);
    widget.isValidSaveAndPrintOnTap ??= ValidButtonModel(isValid: true);
    widget.isValidAnalysisOnTap ??= ValidButtonModel(isValid: true);
    widget.isValidCalculateOnTap ??= ValidButtonModel(isValid: true);
    widget.isValidAdvanceCalculateOnTap ??= ValidButtonModel(isValid: true);
    widget.isValidHistoryAsyncOnTap ??= ValidButtonModel(isValid: true);
    widget.isValidRefreshAsyncOnTap ??= ValidButtonModel(isValid: true);
  }

  @override
  Widget build(BuildContext context) {
    Widget stackBody() {
      Widget mainWidget() {
        Widget headerWidget() {
          Widget scrollHorizontalWidgets() {
            Widget paddingInHeaderWidgets() {
              Widget rowInHeaderWidgets() {
                Widget paddingRightWidgets({required Widget widget}) {
                  return Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)), child: widget);
                }

                return Row(children: [
                  paddingRightWidgets(widget: Text(widget.title, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold))),
                  (widget.addOnTapFunction == null)
                      ? Container()
                      : paddingRightWidgets(
                          widget: addButtonOrContainerWidget(
                            context: context,
                            validModel: widget.isValidAddOnTap,
                            onTapFunction: widget.addOnTapFunction,
                            level: Level.normal,
                            currentAddButtonQty: widget.currentAddButtonQty,
                            maxAddButtonLimit: widget.maxAddButtonLimit,
                          ),
                        ),
                  (widget.analysisOnTapFunction == null)
                      ? Container()
                      : paddingRightWidgets(
                          widget: analysisButtonOrContainerWidget(
                              context: context, onTapFunction: widget.analysisOnTapFunction, level: Level.normal, validModel: widget.isValidAnalysisOnTap)),
                  (widget.historyOnTapFunction == null)
                      ? Container()
                      : paddingRightWidgets(
                          widget: historyButtonOrContainerWidget(context: context, onTapFunction: widget.historyOnTapFunction, level: Level.normal)),
                  (widget.historyAsyncOnTapFunction == null)
                      ? Container()
                      : paddingRightWidgets(
                          widget: historyAsyncButtonOrContainerWidget(
                              context: context,
                              onTapFunction: widget.historyAsyncOnTapFunction,
                              level: Level.normal,
                              validModel: widget.isValidHistoryAsyncOnTap)),
                  (widget.clearFunction == null)
                      ? Container()
                      : paddingRightWidgets(widget: clearButtonOrContainerWidget(context: context, onTapFunction: widget.clearFunction, level: Level.normal)),
                  (widget.refreshFunction == null)
                      ? Container()
                      : paddingRightWidgets(
                          widget: refreshButtonOrContainerWidget(
                              context: context, onTapFunction: widget.refreshFunction, level: Level.normal, validModel: widget.isValidRefreshAsyncOnTap)),
                  (widget.isFormatToggle == null)
                      ? Container()
                      : paddingRightWidgets(
                          widget: formatOrAccurateToggleWidgetGlobal(isLeftSelected: widget.isFormatToggle!, onToggle: widget.formatToggleFunction!))
                ]);
              }

              return Padding(padding: EdgeInsets.all(paddingSizeGlobal(level: Level.large)), child: rowInHeaderWidgets());
            }

            return SingleChildScrollView(scrollDirection: Axis.horizontal, child: paddingInHeaderWidgets());
          }

          return scrollHorizontalWidgets();
        }

        Widget customBetweenHeaderAndBodyWidget() {
          return (widget.customBetweenHeaderAndBodyWidget == null) ? Container() : widget.customBetweenHeaderAndBodyWidget!;
        }

        Widget customRowBetweenHeaderAndBodyWidget() {
          return (widget.customRowBetweenHeaderAndBodyWidget == null)
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.large)),
                  child: widget.customRowBetweenHeaderAndBodyWidget!,
                );
        }

        Widget bodyWidget() {
          Function topFunction() {
            void doNothing() {}
            return (widget.topFunction == null) ? doNothing : widget.topFunction!;
          }

          Function bottomFunction() {
            void doNothing() {}
            return (widget.bottomFunction == null) ? doNothing : widget.bottomFunction!;
          }

          return Expanded(
            child: wrapScrollDetectWidget(
              inWrapWidgetList: widget.inWrapWidgetList,
              topFunction: topFunction(),
              bottomFunction: bottomFunction(),
              isShowSeeMoreWidget: (widget.bottomFunction != null) && widget.isShowSeeMoreWidget,
            ),
          );
        }

        Widget footerWidget() {
          Widget paddingRowWidget() {
            // final bool isHasPreviousWidget = (widget.previousWidget != null);
            // void showPreviousFunction() {
            //   widget.isShowPrevious = !widget.isShowPrevious;
            //   widget.previousOnTapFunction!();
            //   setState(() {});
            // }

            Widget paddingRightWidget({required Widget widget}) {
              return Padding(padding: EdgeInsets.only(right: paddingSizeGlobal(level: Level.normal)), child: widget);
            }

            Widget expandedProviderWidget({required Widget widget, required Function? function}) {
              return (function == null) ? Container() : Expanded(child: widget);
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: paddingSizeGlobal(level: Level.mini),
                left: paddingSizeGlobal(level: Level.large),
                right: paddingSizeGlobal(level: Level.large),
              ),
              child: Row(children: [
                // paddingRightWidget(
                //   widget: buttonOrContainerWidget(
                //     isValid: widget.isValidShowPrevious,
                //     icon: menuIconGlobal,
                //     onTapFunction: isHasPreviousWidget ? showPreviousFunction : null,
                //     level: Level.normal,
                //   ),
                // ),
                expandedProviderWidget(
                  widget: paddingRightWidget(
                    widget: saveButtonOrContainerWidget(
                      context: context,
                      onTapFunction: widget.saveOnTapFunction,
                      isExpanded: true,
                      level: Level.normal,
                      validModel: widget.isValidSaveOnTap,
                    ),
                  ),
                  function: widget.saveOnTapFunction,
                ),
                expandedProviderWidget(
                  widget: saveAndPrintButtonOrContainerWidget(
                    context: context,
                    onTapFunction: widget.saveAndPrintOnTapFunction,
                    isExpanded: true,
                    level: Level.normal,
                    validModel: widget.isValidSaveAndPrintOnTap,
                  ),
                  function: widget.saveAndPrintOnTapFunction,
                ),
                expandedProviderWidget(
                  widget: paddingRightWidget(
                    widget: calculateButtonOrContainerWidget(
                      context: context,
                      onTapFunction: widget.calculateOnTapFunction,
                      isExpanded: true,
                      level: Level.normal,
                      validModel: widget.isValidCalculateOnTap,
                    ),
                  ),
                  function: widget.calculateOnTapFunction,
                ),
                expandedProviderWidget(
                  widget: advanceCalculateButtonOrContainerWidget(
                    context: context,
                    onTapFunction: widget.advanceCalculateOnTapFunction,
                    isExpanded: true,
                    level: Level.normal,
                    validModel: widget.isValidAdvanceCalculateOnTap,
                  ),
                  function: widget.advanceCalculateOnTapFunction,
                ),
              ]),
            );
          }

          return paddingRowWidget();
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customRowBetweenHeaderAndBodyWidget(),
            Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                headerWidget(),
                customBetweenHeaderAndBodyWidget(),
                bodyWidget(),
                footerWidget(),
              ]),
            ),
          ],
        );
      }

      return mainWidget();
    }

    return stackBody();
  }
}
