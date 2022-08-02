import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:nodemobile/core/services/database/database_helper.dart';

class StokListesiViewModel extends ChangeNotifier {
  StokListesiViewModel();

  List filtered = [];
  late LocaleDatatable stokListesi;
  late TextEditingController textEditingController;

  bool setupDone = false;

  Future init(TextEditingController controller) async {
    textEditingController = controller;
    await DatabaseHelper.instance.stokManager.updateStocks();
    setupDone = true;
    await fillStocks();
    filtered.addAll(stokListesi.rowsAsJson);
    log(filtered.first.toString());
    notifyListeners();
  }

  Future fillStocks() async {
    stokListesi = await DatabaseHelper.instance.stokManager.getNonVariants();
    notifyListeners();
  }

  onChanged(String value) {
    log(value);
    filtered.clear();
    if (value.isEmpty) {
      filtered.addAll(stokListesi.rowsAsJson);
    } else {
      log("not empty");
      for (Map<String, dynamic> element in stokListesi.rowsAsJson) {
        String searchString =
            "${element["Name"].toString()} ${element["Aciklama"].toString()} ${element["Barcode"].toString()} ${element["Miktar"].toString()} ${element["UnitCode"].toString()}"
                .toLowerCase();
        log("geldi");
        if (value
            .split(" ")
            .every((part) => searchString.contains(part.toLowerCase()))) {
          filtered.add(element);
        }
      }
    }
    notifyListeners();
  }
}
