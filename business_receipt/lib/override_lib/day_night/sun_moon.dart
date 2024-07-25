import 'package:business_receipt/env/value_env/path_env.dart';
import 'package:business_receipt/override_lib/day_night/constants.dart';
import 'package:business_receipt/override_lib/day_night/state/state_container.dart';
import 'package:flutter/material.dart';

/// [Widget] for rendering the Sun and Moon Asset
class SunMoon extends StatelessWidget {
  /// Whether currently the Sun is displayed
  final bool? isSun;

  /// Initialize the Class
  const SunMoon({
    Key? key,
    this.isSun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    return SizedBox(
      width: SUN_MOON_WIDTH,
      child: AnimatedSwitcher(
        switchInCurve: Curves.ease,
        switchOutCurve: Curves.ease,
        duration: const Duration(milliseconds: 250),
        child: isSun!
            ? Container(key: const ValueKey(1), child: timeState.widget.sunAsset ?? const Image(image: AssetImage(sunIconImageGlobal)))
            : Container(key: const ValueKey(2), child: timeState.widget.moonAsset ?? const Image(image: AssetImage(moonIconImageGlobal))),
        transitionBuilder: (child, anim) {
          return ScaleTransition(
            scale: anim,
            child: FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: anim.drive(
                  Tween(
                    begin: const Offset(0, 4),
                    end: const Offset(0, 0),
                  ),
                ),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
