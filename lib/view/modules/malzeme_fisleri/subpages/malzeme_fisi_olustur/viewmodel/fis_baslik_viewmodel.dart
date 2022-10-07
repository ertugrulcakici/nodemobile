import 'package:flutter/cupertino.dart';
import 'package:nodemobile/core/services/cache/locale_manager.dart';
import 'package:nodemobile/core/services/database/database_helper.dart';
import 'package:nodemobile/core/services/navigation/navigation_service.dart';
import 'package:nodemobile/core/utils/extentions/datetime_extention.dart';
import 'package:nodemobile/core/utils/ui/popup.dart';
import 'package:nodemobile/product/enums/locale_manager_enums.dart';
import 'package:nodemobile/product/models/fis_baslik_model.dart';
import 'package:nodemobile/product/models/fis_satir_model.dart';
import 'package:nodemobile/product/widgets/search_view.dart';

class FisBaslikViewModel extends ChangeNotifier {
  FisBaslikViewModel();

  FisBasligiModel baslik = FisBasligiModel.empty();
  List<FisSatiriModel> satirlar = [];

  String isYeriText = "İş yeri seç";
  String girisDeposuText = "Giriş deposu seç";
  String cikisDeposuText = "Çıkış deposu seç";

  Future initDefaults(FisBasligiModel model) async {
    baslik = model.copy();
    final isYerleri =
        await DatabaseHelper.instance.fisManager.isYerleriniGetir();
    final depolar = await DatabaseHelper.instance.fisManager.depolariGetir();
    if (isYerleri != null) {
      isYeriText = isYerleri.rowsAsJson.firstWhere(
          (element) => element["BranchNo"] == baslik.branch)["Name"];
    }
    if (depolar != null) {
      if (baslik.stockWareHouseID != null) {
        cikisDeposuText = depolar.rowsAsJson.firstWhere(
            (element) => element["ID"] == baslik.stockWareHouseID)["Name"];
      }
      if (baslik.destStockWareHouseID != null) {
        girisDeposuText = depolar.rowsAsJson.firstWhere(
            (element) => element["ID"] == baslik.destStockWareHouseID)["Name"];
      }
    }

    notifyListeners();
  }

  Future isYeriSec() async {
    final data = await DatabaseHelper.instance.fisManager.isYerleriniGetir();
    if (data != null) {
      final selected =
          await NavigationService.instance.navigateToWidget(SearchView(
        data: data.rowsAsJson,
        label: "İş Yeri Seç",
        titleKey: "Name",
        subTitles: const [],
        searchBy: const ["Name"],
      ));
      if (selected != null) {
        baslik.branch = selected["BranchNo"];
        isYeriText = "İş yeri: ${selected["Name"]}";
        notifyListeners();
      }
    }
  }

  Future girisDeposuSec() async {
    final data = await DatabaseHelper.instance.fisManager.depolariGetir();
    if (data != null) {
      final selected =
          await NavigationService.instance.navigateToWidget(SearchView(
        data: data.rowsAsJson,
        label: "Giriş deposu seç",
        titleKey: "Name",
        subTitles: const [],
        searchBy: const ["Name"],
      ));
      if (selected != null) {
        baslik.destStockWareHouseID = selected["ID"];
        girisDeposuText = "Giriş deposu: ${selected["Name"]}";
        notifyListeners();
      }
    }
  }

  Future cikisDeposuSec() async {
    final data = await DatabaseHelper.instance.fisManager.depolariGetir();
    if (data != null) {
      final selected =
          await NavigationService.instance.navigateToWidget(SearchView(
        data: data.rowsAsJson,
        label: "Çıkış deposu seç",
        titleKey: "Name",
        subTitles: const [],
        searchBy: const ["Name"],
      ));
      if (selected != null) {
        baslik.stockWareHouseID = selected["ID"];
        cikisDeposuText = "Çıkış deposu: ${selected["Name"]}";
        notifyListeners();
      }
    }
  }

  Future<bool> save({required int type}) async {
    final now = DateTime.now();
    baslik.type = type;
    baslik.status = 1;
    baslik.transdate = now.DT;
    baslik.createdBy =
        LocaleManager.instance.getInt(LocaleManagerEnums.loggedUserId)!;
    baslik.createdDate = now.DT;
    baslik.goldenSync = 0;

    Future.delayed(const Duration(milliseconds: 500), () {
      notifyListeners();
    });
    int result =
        await DatabaseHelper.instance.fisManager.fisBasligiEkle(baslik);
    if (result == -1) {
      return false;
    }
    baslik.id = result;
    return true;
  }

  Future<bool> update() async {
    try {
      bool result =
          await DatabaseHelper.instance.fisManager.updateTrnHeader(baslik);
      if (result) {
        PopupHelper.showSimpleSnackbar("Fiş başlığı güncellendi.");
        return true;
      } else {
        PopupHelper.showSimpleSnackbar(
            "Fiş başlığı güncellenirken hata oluştu.");
        return false;
      }
    } catch (e) {
      PopupHelper.showSimpleSnackbar(
          "Fiş başlığı güncellenirken hata oluştu: $e");
      return false;
    }
  }
}
