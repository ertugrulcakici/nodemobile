import 'package:flutter/material.dart';

import 'i_navigation_service.dart';
import 'navigation_route.dart';

class NavigationService implements INavigationService {
  static final NavigationService _instance = NavigationService._init();
  static NavigationService get instance => _instance;
  NavigationService._init();

  @override
  Future<void> navigateToPage({required String path, Object? data}) async {
    await NavigationRouter.instance.navigatorKey.currentState!
        .pushNamed(path, arguments: data);
  }

  @override
  Future<void> navigateToPageClear({required String path, Object? data}) async {
    await NavigationRouter.instance.navigatorKey.currentState!
        .pushNamedAndRemoveUntil(path, (Route<dynamic> route) => false,
            arguments: data);
  }

  @override
  Future<bool> back([Object? data]) =>
      NavigationRouter.instance.navigatorKey.currentState!.maybePop(data);

  @override
  backUntil(String path) {
    NavigationRouter.instance.navigatorKey.currentState!
        .popUntil((Route<dynamic> route) => route.settings.name == path);
  }

  @override
  Future<dynamic> navigateToWidget(
      {required Widget widget, Object? data}) async {
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
}
