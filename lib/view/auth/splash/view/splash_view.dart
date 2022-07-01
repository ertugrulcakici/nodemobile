// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:nodemobile/core/initialization.dart';
import 'package:nodemobile/core/services/navigation/navigation_service.dart';
import 'package:nodemobile/product/constants/navigation_constants.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  final Duration _duration = const Duration(seconds: 1);
  double _value = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      setState(() {
        _value = 1;
      });
      await initData();
      // if (LocaleManager.instance.getBool(LocaleManagerConsant.isSetupDone) ??
      //     false)
      // {
      NavigationService.instance
          .navigateToPageClear(path: NavigationConstants.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
            duration: _duration,
            opacity: _value,
            child: const Text("SplashView")),
      ),
    );
  }
}
