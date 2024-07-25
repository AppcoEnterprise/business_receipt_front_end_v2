import 'package:business_receipt/env/function/button/button_env.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/override_lib/day_night/am_pm.dart';
import 'package:business_receipt/override_lib/day_night/common/action_buttons.dart';
import 'package:business_receipt/override_lib/day_night/common/display_value.dart';
import 'package:business_receipt/override_lib/day_night/common/filter_wrapper.dart';
import 'package:business_receipt/override_lib/day_night/common/wrapper_container.dart';
import 'package:business_receipt/override_lib/day_night/common/wrapper_dialog.dart';
import 'package:business_receipt/override_lib/day_night/constants.dart';
import 'package:business_receipt/override_lib/day_night/daynight_banner.dart';
import 'package:business_receipt/override_lib/day_night/state/state_container.dart';
import 'package:business_receipt/override_lib/day_night/state/time.dart';
import 'package:business_receipt/override_lib/day_night/utils.dart';
import 'package:flutter/material.dart';

/// Private class. [StatefulWidget] that renders the content of the picker.
// ignore: must_be_immutable
class DayNightTimePickerAndroid extends StatefulWidget {
  const DayNightTimePickerAndroid({
    Key? key,
    required this.sunrise,
    required this.sunset,
    required this.duskSpanInMinutes,
    required this.width,
    required this.height,
  }) : super(key: key);
  final TimeOfDay sunrise;
  final TimeOfDay sunset;
  final int duskSpanInMinutes;
  final double width;
  final double height;

  @override
  DayNightTimePickerAndroidState createState() => DayNightTimePickerAndroidState();
}

/// Picker state class
class DayNightTimePickerAndroidState extends State<DayNightTimePickerAndroid> {
  late TimeModelBindingState timeState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timeState = TimeModelBinding.of(context);
  }

  @override
  Widget build(BuildContext context) {
    double min = getMin(timeState.widget.minMinute, timeState.widget.minuteInterval);
    double max = getMax(timeState.widget.maxMinute, timeState.widget.minuteInterval);

    int minDiff = (max - min).round();
    int divisions = getDivisions(minDiff, timeState.widget.minuteInterval);

    if (timeState.selected == SelectedInput.HOUR) {
      min = timeState.widget.minHour!;
      max = timeState.widget.maxHour!;
      divisions = (max - min).round();
    }

    final color = timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;

    final hourValue = timeState.widget.is24HrFormat ? timeState.time.hour : timeState.time.hourOfPeriod;

    final ltrMode = timeState.widget.ltrMode ? TextDirection.ltr : TextDirection.rtl;

    final hideButtons = timeState.widget.hideButtons;

    Orientation currentOrientation = MediaQuery.of(context).orientation;

    double value = timeState.time.hour.roundToDouble();
    if (timeState.selected == SelectedInput.MINUTE) {
      value = timeState.time.minute.roundToDouble();
    } else if (timeState.selected == SelectedInput.SECOND) {
      value = timeState.time.second.roundToDouble();
    }

    Widget buttonList({
      required String titleStr,
      required int buttonLength,
      int? buttonIndexInit,
      required Function onClick,
      required bool isHour,
      ValidButtonModel? validModel,
    }) {
      validModel ??= ValidButtonModel(isValid: true);
      if (buttonIndexInit == -1) {
        buttonIndexInit = buttonLength - 1;
      }
      Widget buttonElement({required buttonIndex}) {
        final String textStr = formatAndLimitNumberTextGlobal(
          valueStr: (isHour ? ((buttonIndex == 0) ? 12 : buttonIndex) : buttonIndex).toString(),
          isRound: false,
        );
        void onTapUnlessDisableAndValid() {
          onClick(index: buttonIndex);
        }

        return Padding(
          padding: EdgeInsets.only(left: paddingSizeGlobal(level: Level.mini), bottom: paddingSizeGlobal(level: Level.mini)),
          child: buttonGlobal(
            context: context,
            isDisable: (buttonIndexInit == buttonIndex),
            colorTextAndIcon: (buttonIndexInit == buttonIndex) ? Colors.black : Colors.white,
            sizeBoxWidth: 40,
            textStr: textStr,
            level: Level.mini,
            validModel: validModel,
            onTapUnlessDisableAndValid: onTapUnlessDisableAndValid,
          ),
        );
      }

      return Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: isHour ? null : 550,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(titleStr, style: textStyleGlobal(level: Level.normal)),
            Expanded(
              child: Wrap(direction: Axis.horizontal, children: [
                for (int buttonIndex = 0; buttonIndex < buttonLength; buttonIndex++) buttonElement(buttonIndex: buttonIndex),
              ]),
            ),
            // isHour ? Container() : const SizedBox(width: 120),
          ]),
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        physics: currentOrientation == Orientation.portrait ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
        child: FilterWrapper(
          child: WrapperDialog(
            child: Container(
              width: widget.width,
              height: widget.height,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DayNightBanner(
                    sunrise: widget.sunrise,
                    sunset: widget.sunset,
                    duskSpanInMinutes: widget.duskSpanInMinutes,
                  ),
                  WrapperContainer(
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(children: [
                              AmPm(isAm: timeState.time.period == DayPeriod.am),
                              const SizedBox(height: 8),
                              Row(
                                textDirection: ltrMode,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  DisplayValue(
                                    onTap: timeState.widget.disableHour!
                                        ? null
                                        : () {
                                            timeState.onSelectedInputChange(
                                              SelectedInput.HOUR,
                                            );
                                          },
                                    value: hourValue.toString().padLeft(2, '0'),
                                    isSelected: timeState.selected == SelectedInput.HOUR,
                                  ),
                                  const DisplayValue(
                                    value: ':',
                                  ),
                                  DisplayValue(
                                    onTap: timeState.widget.disableMinute!
                                        ? null
                                        : () {
                                            timeState.onSelectedInputChange(
                                              SelectedInput.MINUTE,
                                            );
                                          },
                                    value: timeState.time.minute.toString().padLeft(2, '0'),
                                    isSelected: timeState.selected == SelectedInput.MINUTE,
                                  ),
                                  ...timeState.widget.showSecondSelector
                                      ? [
                                          const DisplayValue(
                                            value: ':',
                                          ),
                                          DisplayValue(
                                            onTap: () {
                                              timeState.onSelectedInputChange(
                                                SelectedInput.SECOND,
                                              );
                                            },
                                            value: timeState.time.second.toString().padLeft(2, '0'),
                                            isSelected: timeState.selected == SelectedInput.SECOND,
                                          ),
                                        ]
                                      : [],
                                ],
                              ),
                              Slider(
                                onChangeEnd: (_) => onChangedSlider(),
                                value: value,
                                onChanged: timeState.onTimeChange,
                                min: min,
                                max: max,
                                divisions: divisions,
                                activeColor: color,
                                inactiveColor: color.withAlpha(55),
                              ),
                              const SizedBox(height: 20),
                              buttonList(
                                titleStr: "AM: ",
                                buttonLength: 12,
                                buttonIndexInit: (timeState.time.hour < 12) ? (timeState.time.hour) : null,
                                onClick: ({required int index}) {
                                  timeState.time = Time(hour: (index), minute: timeState.time.minute, second: timeState.time.second);
                                  timeState.selected = SelectedInput.HOUR;
                                  setState(() {});
                                },
                                isHour: true,
                                validModel: ValidButtonModel(isValid: !timeState.widget.disableHour!),
                              ),
                              buttonList(
                                titleStr: "PM: ",
                                buttonLength: 12,
                                buttonIndexInit: (timeState.time.hour < 12) ? null : (timeState.time.hour - 12),
                                onClick: ({required int index}) {
                                  timeState.time = Time(hour: (index + 12), minute: timeState.time.minute, second: timeState.time.second);
                                  timeState.selected = SelectedInput.HOUR;
                                  setState(() {});
                                },
                                isHour: true,
                                // validModel: !timeState.widget.disableHour!,
                                validModel: ValidButtonModel(isValid: !timeState.widget.disableHour!),
                              ),
                              const SizedBox(height: 15),
                              buttonList(
                                titleStr: "mm:",
                                buttonLength: 60,
                                buttonIndexInit: timeState.time.minute,
                                onClick: ({required int index}) {
                                  timeState.time = Time(hour: timeState.time.hour, minute: index, second: timeState.time.second);
                                  timeState.selected = SelectedInput.MINUTE;
                                  setState(() {});
                                },
                                isHour: false,
                                // isValid: !timeState.widget.disableMinute!,
                                validModel: ValidButtonModel(isValid: !timeState.widget.disableMinute!),
                              ),
                              const SizedBox(height: 15),
                              timeState.widget.showSecondSelector
                                  ? buttonList(
                                      titleStr: "ss:   ",
                                      buttonLength: 60,
                                      buttonIndexInit: timeState.time.second,
                                      onClick: ({required int index}) {
                                        timeState.time = Time(hour: timeState.time.hour, minute: timeState.time.minute, second: index);
                                        timeState.selected = SelectedInput.SECOND;
                                        setState(() {});
                                      },
                                      isHour: false,
                                      // isValid: !timeState.widget.disableMinute!,
                                      validModel: ValidButtonModel(isValid: !timeState.widget.disableMinute!),
                                    )
                                  : Container(),
                            ]),
                          ),
                        ),
                        if (!hideButtons) const ActionButtons(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onChangedSlider() {
    if (!timeState.widget.disableAutoFocusToNextInput) {
      if (timeState.selected == SelectedInput.HOUR) {
        if (!(timeState.widget.disableMinute ?? false)) {
          timeState.onSelectedInputChange(SelectedInput.MINUTE);
        } else if (timeState.widget.showSecondSelector) {
          timeState.onSelectedInputChange(SelectedInput.SECOND);
        }
      } else if (timeState.selected == SelectedInput.MINUTE && timeState.widget.showSecondSelector) {
        timeState.onSelectedInputChange(SelectedInput.SECOND);
      }
    }
    if (timeState.widget.isOnValueChangeMode) {
      timeState.onOk();
    }
  }
}
