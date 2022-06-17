import 'package:flutter/material.dart';

abstract class INavigationService {
  Future<void> navigateToPage({required String path, Object? data});
  Future<void> navigateToPageClear({required String path, Object? data});
  Future<bool> back(Object? data);
  void backUntil(String path);
  Future<void> navigateToWidget({required Widget widget, Object? data});
}
