import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nodemobile/core/services/database/database_helper.dart';
import 'package:nodemobile/core/services/database/database_service.dart';
import 'package:nodemobile/core/utils/ui/popup.dart';
import 'package:nodemobile/product/models/fis_baslik_model.dart';
import 'package:nodemobile/product/models/fis_satir_model.dart';

class MalzemeFisleriViewModel extends ChangeNotifier {
  List<FisBasligiModel> basliklar = [];
  late LocaleDatatable branchs;
  late LocaleDatatable warehouses;

  Future<void> getAllFisBasliklari(int type) async {
    basliklar.clear();
    try {
      basliklar =
          await DatabaseHelper.instance.fisManager.basliklariGetir(type);
      branchs = (await DatabaseHelper.instance.fisManager.getAllBranchs())!;
      warehouses =
          (await DatabaseHelper.instance.fisManager.getAllWareHouses())!;
      Future.delayed(Duration.zero, () {
        notifyListeners();
      });
    } catch (e) {
      PopupHelper.showSimpleSnackbar("Hata oluştu: $e", error: true);
    }
  }

  Future<void> deleteFisBaslik(FisBasligiModel baslik) async {
    try {
      Map? deleted =
          await DatabaseHelper.instance.fisManager.baslikSil(baslik.id!);
      if (deleted != null) {
        int removedTitle = deleted['removedTitle'];
        int removedLine = deleted['removedLine'];
        EasyLoading.showSuccess(
            "$removedTitle fiş\nve\n$removedLine satır silindi.",
            duration: const Duration(seconds: 2));
        basliklar.removeWhere((element) => element.id == baslik.id);
        notifyListeners();
      } else {
        PopupHelper.showSimpleSnackbar("Fiş silinirken hata oluştu.",
            error: true);
      }
    } catch (e) {
      PopupHelper.showSimpleSnackbar("Hata oluştu: $e", error: true);
    }
  }

  Future sendFisToServer(FisBasligiModel baslik) async {
    LocaleDatatable? rows = await DatabaseService.instance.firmDb.mySelectQuery(
        "select * from TRN_StockTransLines where StockTransId = ${baslik.id}");
    if (rows != null) {
      if (rows.isNotEmpty) {
        List<FisSatiriModel> fisSatirlari =
            rows.rowsAsJson.map((e) => FisSatiriModel.jromJson(e)).toList();
        await DatabaseHelper.instance.fisManager
            .sendToServer(baslik, fisSatirlari);
        notifyListeners();
      } else {
        EasyLoading.showToast("Satırları boş olamaz.",
            duration: const Duration(seconds: 2));
      }
    }
  }
}
