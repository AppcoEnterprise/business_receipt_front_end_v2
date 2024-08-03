import 'dart:async';

import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/state/provider.dart';
import 'package:business_receipt/test.dart';
import 'package:business_receipt/test2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class _NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.stylus};
}

void main() {
  ThemeData themeData() {
    return ThemeData(primarySwatch: Colors.blue);
  }

  ScrollBehavior scrollBehavior() {
    return _NoThumbScrollBehavior().copyWith(scrollbars: false);
  }

  runApp(MaterialApp(title: appTitle, debugShowCheckedModeBanner: false, scrollBehavior: scrollBehavior(), theme: themeData(), home: const Home()));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late StreamSubscription<InternetStatus> _subscription;
  bool _enableWaitingNetworkDialog = false;
  @override
  void initState() {
    super.initState();
    _subscription = InternetConnection().onStatusChange.listen((status) {
      switch (status) {
        case InternetStatus.connected:
          if (_enableWaitingNetworkDialog) {
            closeDialogGlobal(context: context);
            _enableWaitingNetworkDialog = false;
            setState(() {});
          }

          break;
        case InternetStatus.disconnected:
          loadingDialogGlobal(context: context, loadingTitle: waitingForInternetConnection);
          if (!_enableWaitingNetworkDialog) {
            _enableWaitingNetworkDialog = true;
            setState(() {});
          }
          break;
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Provider());
    // return  Scaffold(body: Test());
  }
}
