import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:nodemobile/core/services/database/database_helper.dart';
import 'package:nodemobile/core/services/database/database_service.dart';
import 'package:nodemobile/core/services/database/remote_database_service.dart';
import 'package:nodemobile/core/services/navigation/navigation_route.dart';
import 'package:nodemobile/core/utils/ui/popup.dart';
import 'package:nodemobile/product/models/sevkiyat_baslik_ozet_model.dart';

class SevkiyatFisiIcerikViewModel extends ChangeNotifier {
  SevkiyatBaslikOzetModel baslikOzetModel;
  TextEditingController barcodeController;
  SevkiyatFisiIcerikViewModel(this.baslikOzetModel,
      {required this.barcodeController});

  List<Map<String, dynamic>> initialSatirlar =
      List.generate(0, (index) => <String, dynamic>{}, growable: true);
  List<Map<String, dynamic>> localeSatirlar =
      List.generate(0, (index) => <String, dynamic>{}, growable: true);

  Map<String, dynamic>? _urun;
  Map<String, dynamic>? get urun => _urun;
  set urun(Map<String, dynamic>? value) {
    _urun = value;
    notifyListeners();
  }

  Future getInitialLines() async {
    initialSatirlar.clear();
    final result = await DatabaseHelper.instance.sevkiyatManager
        .getInitialLines(baslikOzetModel.id);
    if (result != null) {
      initialSatirlar.addAll(result.rowsAsJson());
      notifyListeners();
    } else {
      PopupHelper.showSimpleSnackbar("Hata", error: true);
    }
  }

  Future getLocaleLines() async {
    localeSatirlar.clear();
    final result = await DatabaseHelper.instance.sevkiyatManager
        .getLocaleLines(baslikOzetModel.id);
    if (result != null) {
      localeSatirlar.addAll(result.rowsAsJson);
      for (Map<String, dynamic> initialSatir in initialSatirlar) {
        initialSatir["Yuklenen"] = 0;
        localeSatirlar
            .where(
                (element) => element["ProductID"] == initialSatir["ProductID"])
            .forEach((element) {
          initialSatir["Yuklenen"] += element["Amount"];
        });
      }
      notifyListeners();
    } else {
      PopupHelper.showSimpleSnackbar("Hata", error: true);
    }
  }

  Future getProductByBarcode(String barcode) async {
    RemoteDatatable? result = await DatabaseHelper.instance.sevkiyatManager
        .getProductByBarcode(barcode);
    barcodeController.clear();
    if (result != null) {
      if (result.rowCount == 0) {
        PopupHelper.showSimpleSnackbar("Ürün bulunamadı", error: true);
        urun = null;
      } else {
        urun = result.rowsAsJson().first;
        log(urun.toString());
      }
    } else {
      PopupHelper.showSimpleSnackbar("Hata! Ürün bilgisi alınamadı",
          error: true);
    }
  }

  Future readBarcode() async {
    final data = await FlutterBarcodeScanner.scanBarcode(
        "white", "iptal", false, ScanMode.DEFAULT);
    if (data != "-1") {
      barcodeController.text = data;
      await getProductByBarcode(data);
    }
  }

  Future addLineToLocale() async {
    if (urun == null) {
      PopupHelper.showSimpleSnackbar("Ürün seçilmedi", error: true);
      return;
    }

    bool hasBalya =
        urun!["BalyaNo"].toString().replaceAll("null", "").isNotEmpty;
    if (urun!["IslemTuru"] == "PAKET" && hasBalya) {
      PopupHelper.showSimpleSnackbar(
          "Bu paketin bir paleti olduğu için eklenemez!",
          error: true);
      urun = null;
      return;
    }

    bool existsInLines =
        initialSatirlar.any((element) => element["PD"] == urun!["ID"]);
    if (!existsInLines) {
      PopupHelper.showSimpleSnackbar("Bu ürün sevkiyat listesinde yok!",
          error: true);
      urun = null;
      return;
    }

    LocaleDatatable? addedResult;
    if (urun!["IslemTuru"] == "PAKET") {
      addedResult = await DatabaseService.instance.userDb.mySelectQuery(
          "select ID from TRN_StockTransLines where PaketNo = '${urun!["PaketNo"]}'");
    } else {
      addedResult = await DatabaseService.instance.userDb.mySelectQuery(
          "select ID from TRN_StockTransLines where BalyaNo = ${urun!["BalyaNo"]}");
    }

    if (addedResult != null && addedResult.rowCount > 0) {
      PopupHelper.showSimpleSnackbar(
          "Bu ${urun!["IslemTuru"].toLowerCase()} zaten sevkiyat listesinde var!",
          error: true);
      urun = null;
      return;
    }

    try {
      Map<String, dynamic> line =
          initialSatirlar.firstWhere((element) => element["PD"] == urun!["ID"]);
      int result = await DatabaseHelper.instance.sevkiyatManager
          .addLineToLocale(urun!, line, baslikOzetModel);
      if (result != 0) {
        PopupHelper.showSimpleSnackbar("Ürün başarıyla eklendi");
        await getLocaleLines();
      } else {
        PopupHelper.showSimpleSnackbar("Hata. Ürün eklenemedi", error: true);
      }
      urun = null;
    } catch (e) {
      PopupHelper.showSimpleSnackbar("Hata: $e", error: true);
    }
  }

  Future savePrompt() async {
    bool allOk = true;
    for (var element in initialSatirlar) {
      if (element["Yuklenen"] != element["Amount"]) {
        allOk = false;
      }
    }
    if (!allOk) {
      AwesomeDialog(
        context: NavigationRouter.instance.navigatorKey.currentState!.context,
        btnOkText: "Devam et",
        btnOkColor: Colors.green,
        btnOkIcon: FontAwesome5.check,
        btnOkOnPress: () {
          save();
        },
        btnCancelText: "İptal",
        btnCancelColor: Colors.red,
        btnCancelIcon: FontAwesome5.times,
        btnCancelOnPress: () {},
        headerAnimationLoop: false,
        dialogType: DialogType.WARNING,
        animType: AnimType.TOPSLIDE,
        title: "Dikkat!",
        desc: "Ürünlerin yüklenme durumu eksik. Devam etmek istiyor musunuz?",
      ).show();
    }
  }

  Future save() async {
    if (await DatabaseHelper.instance.sevkiyatManager
        .save(stockTransId: baslikOzetModel.id)) {
      PopupHelper.showSimpleSnackbar("Sevkiyat başarıyla kaydedildi");
    } else {
      PopupHelper.showSimpleSnackbar("Sevkiyat kaydedilemedi", error: true);
    }
  }
}
