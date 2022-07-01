import 'package:flutter/material.dart';
import 'package:nodemobile/core/services/database/database_helper.dart';
import 'package:nodemobile/core/utils/ui/popup.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel() {
    fillFisler();
  }

  List<Map<String, dynamic>> fisler = [];
  int _editingId = -1;
  int get editingId => _editingId;
  set editingId(int value) {
    _editingId = value;
    notifyListeners();
  }

  Future fillFisler() async {
    this.fisler = [];
    LocaleDatatable? fisler =
        await DatabaseHelper.instance.fisManager.getLocaleFisTypes();
    if (fisler != null) {
      this.fisler = fisler.rowsAsJson;
      notifyListeners();
    } else {
      PopupHelper.showSimpleSnackbar("Fisler yüklenemedi", error: true);
    }
  }

  Future fisUpdate(String name, int type) async {
    if (await DatabaseHelper.instance.fisManager
        .updateLocaleFisType(name, type)) {
      await fillFisler();
    } else {
      PopupHelper.showSimpleSnackbar("Hata oluştu", error: true);
    }
    DatabaseHelper.instance.fisManager.setStaticLocaleFisTypes();
  }
}
