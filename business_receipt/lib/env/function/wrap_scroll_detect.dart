import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:flutter/material.dart';

Widget wrapScrollDetectWidget({
  required List<Widget?> inWrapWidgetList,
  required Function topFunction,
  required Function bottomFunction,
  required bool isShowSeeMoreWidget,
}) {
  Widget paddingBottomAndRightInWrapWidget({required int inWrapWidgetIndex}) {
    return (inWrapWidgetList[inWrapWidgetIndex] == null)
        ? Container(width: 0)
        : Padding(
            padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini), right: paddingSizeGlobal(level: Level.mini)),
            child: inWrapWidgetList[inWrapWidgetIndex],
          );
  }

  Widget seeMoreWidget() {
    onTapUnlessDisable() {
      bottomFunction();
    }

    Widget insideSizeBoxWidget() {
      return Text("See More", style: textStyleGlobal(level: Level.mini));
    }

    return CustomButtonGlobal(insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
  }

  return Padding(
    padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)),
    child: NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.atEdge) {
          bool isTop = metrics.pixels == 0;
          if (isTop) {
            topFunction();
          } else {
            bottomFunction();
          }
        }
        return true;
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(paddingSizeGlobal(level: Level.mini)),
          child: Wrap(
            direction: Axis.horizontal,
            children: [
              for (int inWrapWidgetIndex = 0; inWrapWidgetIndex < inWrapWidgetList.length; inWrapWidgetIndex++)
                paddingBottomAndRightInWrapWidget(inWrapWidgetIndex: inWrapWidgetIndex),
              isShowSeeMoreWidget ? seeMoreWidget() : Container(),
            ],
          ),
        ),
      ),
    ),
  );
}
