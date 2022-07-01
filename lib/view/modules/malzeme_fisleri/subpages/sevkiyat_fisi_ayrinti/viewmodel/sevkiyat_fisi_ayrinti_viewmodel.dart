import 'package:flutter/material.dart';

class SevkiyatFisiIcerikViewModel extends ChangeNotifier {
  SevkiyatFisiIcerikViewModel();

  int _selectableIndex = 0;
  int get selectableIndex => _selectableIndex;
  set selectableIndex(int value) {
    _selectableIndex = value;
    notifyListeners();
  }
}
