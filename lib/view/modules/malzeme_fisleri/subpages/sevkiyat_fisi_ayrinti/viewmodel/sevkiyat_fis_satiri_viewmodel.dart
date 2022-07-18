import 'package:flutter/cupertino.dart';
import 'package:nodemobile/core/services/database/database_helper.dart';
import 'package:nodemobile/core/services/database/database_service.dart';
import 'package:nodemobile/core/utils/ui/popup.dart';
import 'package:nodemobile/product/models/sevkiyat_baslik_ozet_model.dart';

class SevkiyatFisSatiriViewModel extends ChangeNotifier {
  final SevkiyatBaslikOzetModel baslik;
  final int productId;
  SevkiyatFisSatiriViewModel({required this.baslik, required this.productId});

  List<Map<String, dynamic>> lines =
      List.generate(0, (index) => <String, dynamic>{}, growable: true);

  Future getLines() async {
    LocaleDatatable? result = await DatabaseService.instance.userDb.mySelectQuery(
        "select * from TRN_StockTransLines where ProductID = $productId and StockTransID = ${baslik.id}");
    if (result != null) {
      lines = result.rowsAsJson;
      notifyListeners();
    } else {
      PopupHelper.showSimpleSnackbar("Hata", error: true);
    }
  }

  Future deleteLine(int index) async {
    bool success = await DatabaseHelper.instance.sevkiyatManager
        .deleteLine(lines[index]["ID"]);
    if (success) {
      List<Map<String, dynamic>> lines = List.from(this.lines);
      lines.removeAt(index);
      this.lines = lines;
      notifyListeners();
      PopupHelper.showSimpleSnackbar("Silindi");
    } else {
      PopupHelper.showSimpleSnackbar("Hata", error: true);
    }
  }
}
