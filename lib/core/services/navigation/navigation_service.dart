import 'package:flutter/material.dart';

import 'navigation_route.dart';

class NavigationService {
  static BuildContext get context =>
      NavigationRouter.instance.navigatorKey.currentState!.context;
  static final NavigationService _instance = NavigationService._init();
  static NavigationService get instance => _instance;
  NavigationService._init();

  Future<void> navigateToPage({required String path, Object? data}) async {
    await NavigationRouter.instance.navigatorKey.currentState!
        .pushNamed(path, arguments: data);
  }

  Future<void> navigateToPageClear({required String path, Object? data}) async {
    await NavigationRouter.instance.navigatorKey.currentState!
        .pushNamedAndRemoveUntil(path, (Route<dynamic> route) => false,
            arguments: data);
  }

  Future<bool> back([Object? data]) =>
      NavigationRouter.instance.navigatorKey.currentState!.maybePop(data);

  backUntil(String path) {
    NavigationRouter.instance.navigatorKey.currentState!
        .popUntil((Route<dynamic> route) => route.settings.name == path);
  }

  Future<dynamic> navigateToWidget(Widget widget, {Object? data}) async {
    return await NavigationRouter.instance.navigatorKey.currentState!.push(
        MaterialPageRoute(
            builder: (context) => widget,
            settings: RouteSettings(arguments: data)));
  }

  Future<dynamic> navigateToWidgetClear(
      {required Widget widget, Object? data}) async {
    return await NavigationRouter.instance.navigatorKey.currentState!
        .pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => widget,
                settings: RouteSettings(arguments: data)),
            (Route<dynamic> route) => false);
  }

  Future<dynamic> navigateToInstead(
      {required Widget widget, Object? object}) async {
    return await NavigationRouter.instance.navigatorKey.currentState!
        .pushReplacement(MaterialPageRoute(
      builder: (context) => widget,
      settings: RouteSettings(arguments: object),
    ));
  }
}
