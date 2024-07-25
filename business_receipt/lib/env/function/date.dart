import 'package:business_receipt/env/function/button/button_unless_function_not_null.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/icon_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/override_lib/day_night/constants.dart';
import 'package:business_receipt/override_lib/day_night/day_night_time_picker_android.dart';
import 'package:business_receipt/override_lib/day_night/daynight_time_picker.dart';
import 'package:business_receipt/override_lib/day_night/state/time.dart';
import 'package:flutter/material.dart';

String formatFullDateToStr({required DateTime date}) {
  return dateFullFormat.format(date);
}

String formatFullWithoutSSDateToStr({required DateTime date}) {
  return dateFullWithoutSSFormat.format(date);
}
String formatDateYMToStr({required DateTime date}) {
  return dateYMFormat.format(date);
}

String formatDateDateToStr({required DateTime date}) {
  return dateDateFormat.format(date);
}

String formatDateHourToStr({required DateTime date}) {
  return timeDateFormat.format(date);
}

DateTime removeUAndTDate({required DateTime date}) {
  return DateTime.parse(date.toString().replaceAll('Z', '').replaceAll('T', ''));
}

//void callback({required DateTime dateTime}) {
//...
//setState(() {});
//};
Widget pickTime({
  required BuildContext context,
  required DateTime dateTimeOutsider,
  required Function callback,
  bool isExpanded = false,
  required Level level,
  required ValidButtonModel validModel,
}) {
  Time time = Time(hour: dateTimeOutsider.hour, minute: dateTimeOutsider.minute, second: dateTimeOutsider.second);
  void onTapFunction() {
    // void cancelFunctionOnTap() {
    //   closeDialogGlobal(context: context);
    // }

    // Widget contentFunctionReturnWidget({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
    //   return Theme(
    //       data: Theme.of(context),
    //       child: DayNightTimePickerAndroid(
    //     sunrise: const TimeOfDay(hour: 6, minute: 0),
    //     sunset: const TimeOfDay(hour: 18, minute: 0),
    //     duskSpanInMinutes: 120,
    //   ));
    // }

    // void okFunctionOnTap() {}

    // actionDialogSetStateGlobal(
    //   dialogHeight: dialogSizeGlobal(level: Level.mini) / 1.5,
    //   dialogWidth: dialogSizeGlobal(level: Level.mini) / 1.5,
    //   cancelFunctionOnTap: cancelFunctionOnTap,
    //   okFunctionOnTap: okFunctionOnTap,
    //   context: context,
    //   contentFunctionReturnWidget: contentFunctionReturnWidget,
    // );

    Navigator.of(context).push(
      showPicker(
        height: (dialogSizeGlobal(level: Level.mini) + 100),
        showSecondSelector: false,
        context: context,
        value: time,
        onChange: (Time newTime) {},
        minuteInterval: TimePickerInterval.ONE,
        // Optional onChange to receive value as DateTime
        onChangeDateTime: (DateTime dateTime) {
          callback(dateTime: dateTime);
        },
      ),
    );
  }

  return buttonOrContainerWidget(
    context: context,
    validModel: validModel,
    onTapFunction: onTapFunction,
    icon: timeIconGlobal,
    str: timeNoSecondDateFormat.format(dateTimeOutsider),
    isExpanded: isExpanded,
    level: level,
    colorTextAndIcon: defaultTextColorGlobal,
    colorSideBox: buttonIconColorGlobal,
  );
}

DateTime defaultDate({required int hour, required int minute, required int second}) {
  return DateTime(1000, 1, 1, hour, minute, second);
}

String secondNumberToHMSStr(int second) {
  int h, m, s;
  h = second ~/ 3600;
  m = ((second - h * 3600)) ~/ 60;
  s = second - (h * 3600) - (m * 60);
  String result = "${h}h:${m}m:${s}s";

  return result;
}

String hhMmSsDuration(Duration duration) {
  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "$negativeSign${twoDigits(duration.inHours)}h:${twoDigitMinutes}m:${twoDigitSeconds}s";
}