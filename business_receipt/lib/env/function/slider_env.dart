import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:flutter/material.dart';

//sliderWidgetGlobal(onChangeFunction: ({required double newValue}) {})
Widget sliderPositiveAndNegativeWidgetGlobal({required double sliderValue, required Function onChangeFunction, required double minSlider, required double maxSlider}) {
  Widget stackConfigSlider() {
    Widget rowRedAndBlue() {
      Widget paddingRowWidget() {
        Widget expandedWithFlexWidget({required int flex, required double linearProgressIndicatorValue, required Color leftColor, required Color rightColor}) {
          return Expanded(
            flex: flex,
            child: LinearProgressIndicator(
              value: linearProgressIndicatorValue,
              color: leftColor,
              backgroundColor: rightColor,
            ),
          );
        }

        Widget expandedOnLeft() {
          final int flex = minSlider.abs().round();
          final double linearProgressIndicatorValue = 1 - sliderValue / minSlider;
          return expandedWithFlexWidget(flex: flex, linearProgressIndicatorValue: linearProgressIndicatorValue, leftColor: notUsedSliderChooseColorGlobal, rightColor: leftSliderColorGlobal);
        }

        Widget expandedOnRight() {
          final int flex = maxSlider.abs().round();
          final double linearProgressIndicatorValue = sliderValue / maxSlider;
          return expandedWithFlexWidget(flex: flex, linearProgressIndicatorValue: linearProgressIndicatorValue, leftColor: rightSliderColorGlobal, rightColor: notUsedSliderChooseColorGlobal);
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [expandedOnLeft(), expandedOnRight()]),
        );
      }

      return paddingRowWidget();
    }

    Widget sliderWidget() {
      final bool isSliderValueProviderLeftOrRight = (sliderValue > 0);
      final bool isSliderValueEqual0 = (sliderValue == 0);
      Color thumbColor = isSliderValueProviderLeftOrRight ? rightSliderColorGlobal : leftSliderColorGlobal;
      thumbColor = isSliderValueEqual0 ? notUsedSliderChooseColorGlobal : thumbColor;
      return Slider(
        value: sliderValue,
        activeColor: transparentColorGlobal,
        inactiveColor: transparentColorGlobal,
        thumbColor: thumbColor,
        min: minSlider,
        max: maxSlider,
        // divisions: divisionsSlider,
        label: sliderValue.toString(),
        onChanged: (double newValue) => onChangeFunction(newValue: newValue),
      );
    }

    return Stack(alignment: AlignmentDirectional.center, children: [rowRedAndBlue(), sliderWidget()]);
  }

  return stackConfigSlider();
}

Widget sliderWidgetGlobal({required double sliderValue, required Function onChangeFunction, required double minSlider, required double maxSlider}) {
  return Slider(
    value: sliderValue,
    // activeColor: headerColorGlobal,
    inactiveColor: headerColorGlobal,
    thumbColor: rightSliderColorGlobal,
    min: minSlider,
    max: maxSlider,
    // divisions: divisionsSlider,
    label: sliderValue.toString(),
    onChanged: (double newValue) => onChangeFunction(newValue: newValue),
  );
}
