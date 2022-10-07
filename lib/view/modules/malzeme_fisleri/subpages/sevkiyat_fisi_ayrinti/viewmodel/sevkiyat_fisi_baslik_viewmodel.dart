import 'package:flutter/material.dart';
import 'package:nodemobile/core/services/database/database_helper.dart';
import 'package:nodemobile/core/services/database/remote_database_service.dart';
import 'package:nodemobile/core/services/navigation/navigation_service.dart';
import 'package:nodemobile/core/utils/ui/popup.dart';
import 'package:nodemobile/product/models/sevkiyat_baslik_ozet_model.dart';
import 'package:nodemobile/product/widgets/secme_ekrani_view.dart';

class SevkiyatFisiBaslikViewModel extends ChangeNotifier {
  SevkiyatBaslikOzetModel baslikOzet;

  bool _isPaket = false;
  bool get isPaket => _isPaket;
  set isPaket(bool value) {
    _isPaket = value;
    notifyListeners();
  }

  String _depoString = "";
  String _branchString = "";

  String get depoString => _depoString;
  String get branchString => _branchString;

  set depoString(String value) {
    _depoString = value;
    notifyListeners();
  }

  set branchString(String value) {
    _branchString = value;
    notifyListeners();
  }

  SevkiyatFisiBaslikViewModel(this.baslikOzet) {
    _branchString = baslikOzet.branchName ?? "Seçilmedi";
    _depoString = baslikOzet.depoAdi ?? "Seçilmedi";
  }

  Future selectBranch() async {
    RemoteDatatable? branchs =
        await DatabaseHelper.instance.sevkiyatManager.branchleriGetir();
    if (branchs != null) {
      final result =
          await NavigationService.instance.navigateToWidget(SecmeEkraniView(
        data: branchs.rowsAsJson(),
        label: "İş yeri seç",
        searchBy: const ["Name"],
        titleKey: "Name",
      ));
      if (result != null) {
        try {
          // RemoteDatabaseService.execute(
          //     "update TRN_StockTrans set Branch = ? where ID = ?",
          //     args: [result["BranchNo"], baslikOzet.id]);
          baslikOzet.branchName = result["Name"];
          baslikOzet.branchId = result["BranchNo"];
          branchString = result["Name"];
        } catch (e) {
          PopupHelper.showSimpleSnackbar("İş yeri seçilemedi. Hata: $e",
              error: true);
        }
      }
    } else {
      PopupHelper.showSimpleSnackbar("İş yeri seçme hatası", error: true);
    }
  }

  Future selectDepo() async {
    RemoteDatatable? depolar =
        await DatabaseHelper.instance.sevkiyatManager.depolariGetir();
    if (depolar != null) {
      final result =
          await NavigationService.instance.navigateToWidget(SecmeEkraniView(
        data: depolar.rowsAsJson(),
        label: "Depo seç",
        searchBy: const ["Name"],
        titleKey: "Name",
      ));
      if (result != null) {
        try {
          // RemoteDatabaseService.execute(
          //     "update TRN_StockTrans set StockWareHouseID = ? where ID = ?",
          //     args: [result["ID"], baslikOzet.id]);
          depoString = result["Name"];
          baslikOzet.depoAdi = result["Name"];
          baslikOzet.wareHouseId = result["ID"];
        } catch (e) {
          PopupHelper.showSimpleSnackbar(
              "Depo seçme hatası (Uzak sunucuya bağlanamadı): $e",
              error: true);
        }
      }
    } else {
      PopupHelper.showSimpleSnackbar("Depo seçme hatası", error: true);
    }
  }

  Future<bool> save() async {
    RemoteDatabaseService.execute('''
update TRN_StockTrans set 
SoforAdi = ${baslikOzet.soforAdi == null ? 'null' : "'${baslikOzet.soforAdi}'"},
SoforTC = ${baslikOzet.soforTC == null ? 'null' : "'${baslikOzet.soforTC}'"},
SoforTelefon = ${baslikOzet.soforTelefon == null ? 'null' : "'${baslikOzet.soforTelefon}'"},
KonteynerAracPlaka = ${baslikOzet.konteynerAracPlaka == null ? 'null' : "'${baslikOzet.konteynerAracPlaka}'"},
DorsePlaka = ${baslikOzet.dorsePlaka == null ? 'null' : "'${baslikOzet.dorsePlaka}'"},
Branch = ${baslikOzet.branchId == null ? 'null' : "'${baslikOzet.branchId}'"},
StockWareHouseID = ${baslikOzet.wareHouseId == null ? 'null' : "'${baslikOzet.wareHouseId}'"}
where ID = ${baslikOzet.id};
''');
    return true;
  }
}
