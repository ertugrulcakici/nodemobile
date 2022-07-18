import 'package:flutter/material.dart';
import 'package:nodemobile/core/services/database/remote_database_service.dart';
import 'package:nodemobile/product/constants/database_constants.dart';
import 'package:nodemobile/product/models/sevkiyat_baslik_ozet_model.dart';

class SevkiyatFisleriListesiViewModel extends ChangeNotifier {
  SevkiyatFisleriListesiViewModel();

  List<SevkiyatBaslikOzetModel> sevkiyatBasliklari = [];

  Future fillSevkiyatBasliklari() async {
    RemoteDatabaseService.read(DatabaseConstants.select_Sevkiyat).then((value) {
      if (value != null) {
        if (value.rowCount > 0) {
          sevkiyatBasliklari = value.rowsAsJson().map((e) {
            return SevkiyatBaslikOzetModel.fromJson(e);
          }).toList();
          notifyListeners();
        }
      }
    });
  }
}
