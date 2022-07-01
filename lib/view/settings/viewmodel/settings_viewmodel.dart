import 'package:flutter/material.dart';
import 'package:nodemobile/core/services/database/database_helper.dart';
import 'package:nodemobile/core/utils/ui/popup.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel() {
    fillFisler();
  }

  List<Map<String, dynamic>> fisler = [];

  deleteFis(int type) async {
    if ((await DatabaseHelper.instance.fisManager.deleteLocaleFisType(type)) !=
        0) {
      await fillFisler();
    } else {
      PopupHelper.showSimpleSnackbar("Hata oluştu", error: true);
    }
  }

  addFis(String name, int type) async {
    if ((await DatabaseHelper.instance.fisManager
            .addLocaleFisType(name, type)) !=
        0) {
      await fillFisler();
    } else {
      PopupHelper.showSimpleSnackbar("Hata oluştu", error: true);
    }
  }

  Future fillFisler() async {
    this.fisler.clear();
    LocaleDatatable? fisler =
        await DatabaseHelper.instance.fisManager.getLocaleFisTypes();
    if (fisler != null) {
      this.fisler = fisler.rowsAsJson;
      notifyListeners();
    } else {
      PopupHelper.showSimpleSnackbar("Fisler yüklenemedi", error: true);
    }
  }
}
