import 'package:flutter/cupertino.dart';
import 'package:nodemobile/core/services/database/database_helper.dart';

class StokListesiViewModel extends ChangeNotifier {
  StokListesiViewModel();

  late LocaleDatatable stokListesi;

  bool setupDone = false;

  Future init() async {
    await DatabaseHelper.instance.stokManager.updateStocks();
    setupDone = true;
    await fillStocks();
    notifyListeners();
  }

  Future fillStocks() async {
    stokListesi = await DatabaseHelper.instance.stokManager.getNonVariants();
    notifyListeners();
  }
}
