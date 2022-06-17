import 'package:flutter/material.dart';

import '../../services/navigation/navigation_route.dart';

class PopupHelper {
  static Future<void> showSimpleSnackbar(String message,
      {bool error = false}) async {
    if (!error) {
      ScaffoldMessenger.of(
              NavigationRouter.instance.navigatorKey.currentContext!)
          .showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } else {
      ScaffoldMessenger.of(
              NavigationRouter.instance.navigatorKey.currentContext!)
          .showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
