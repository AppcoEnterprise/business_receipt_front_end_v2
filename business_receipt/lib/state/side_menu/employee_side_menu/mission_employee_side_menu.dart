import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/request_api/mission_request_api_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/state/side_menu/body_template_side_menu.dart';
import 'package:flutter/material.dart';

class MissionSideEmployeeMenu extends StatefulWidget {
  String title;
  MissionSideEmployeeMenu({Key? key, required this.title}) : super(key: key);

  @override
  State<MissionSideEmployeeMenu> createState() => _MissionSideEmployeeMenuState();
}

class _MissionSideEmployeeMenuState extends State<MissionSideEmployeeMenu> {
  bool isAllowRefresh = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingOrBody() {
      Widget bodyTemplateSideMenu() {
        List<Widget> inWrapWidgetList() {
          Widget customerButtonWidget() {
            void onTapUnlessDisable() {}
            Widget insideSizeBoxWidget() {
              Widget closeSellingWidget({required int closeSellingIndex}) {
                final String targetDateStr = formatDateHourToStr(date: missionModelGlobal.closeSellingDate[closeSellingIndex].targetDate);
                final String targetCountStr =
                    formatAndLimitNumberTextGlobal(valueStr: missionModelGlobal.closeSellingDate[closeSellingIndex].count.text, isRound: false);
                final String countStr = formatAndLimitNumberTextGlobal(valueStr: missionModelGlobal.totalService.toString(), isRound: false);
                final bool isCompletedTarget =
                    missionModelGlobal.totalService >= textEditingControllerToInt(controller: missionModelGlobal.closeSellingDate[closeSellingIndex].count)!;
                return Text(
                  "($targetDateStr): $countStr/$targetCountStr ${isCompletedTarget ? "(completed)" : ""}",
                  style: textStyleGlobal(level: Level.normal, color: isCompletedTarget ? Colors.green : Colors.black),
                );
              }

              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
                  child: Text(targetCustomerStrGlobal, style: textStyleGlobal(level: Level.normal, fontWeight: FontWeight.bold)),
                ),
                for (int closeSellingIndex = 0; closeSellingIndex < missionModelGlobal.closeSellingDate.length; closeSellingIndex++)
                  closeSellingWidget(closeSellingIndex: closeSellingIndex)
              ]);
            }

            return CustomButtonGlobal(sizeBoxWidth: sizeBoxWidthGlobal, insideSizeBoxWidget: insideSizeBoxWidget(), onTapUnlessDisable: onTapUnlessDisable);
          }

          return [customerButtonWidget()];
        }

        void refreshFunction() {
          void callBack() {
            isAllowRefresh = false;
            Future.delayed(const Duration(seconds: delayApiRequestSecond), () {
              isAllowRefresh = true;
              if (mounted) {
                setState(() {});
              }
            });
            setState(() {});
          }

          getMissionEmployeeGlobal(callBack: callBack, context: context);
        }

        return BodyTemplateSideMenu(
          title: widget.title,
          inWrapWidgetList: inWrapWidgetList(),
          refreshFunction: refreshFunction,
          isValidRefreshAsyncOnTap: ValidButtonModel(isValid: isAllowRefresh, error: "Please wait $delayApiRequestSecond seconds before refresh."),
        );
      }

      return bodyTemplateSideMenu();
    }

    return loadingOrBody();
  }
}
