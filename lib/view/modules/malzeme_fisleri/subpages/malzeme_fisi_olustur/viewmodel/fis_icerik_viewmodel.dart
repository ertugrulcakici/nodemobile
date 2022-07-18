import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:nodemobile/core/services/cache/locale_manager.dart';
import 'package:nodemobile/core/services/database/database_helper.dart';
import 'package:nodemobile/core/services/database/database_service.dart';
import 'package:nodemobile/core/services/navigation/navigation_service.dart';
import 'package:nodemobile/core/utils/datetime_helper.dart';
import 'package:nodemobile/core/utils/extentions/datetime_extention.dart';
import 'package:nodemobile/core/utils/ui/popup.dart';
import 'package:nodemobile/product/enums/locale_manager_enums.dart';
import 'package:nodemobile/product/models/fis_baslik_model.dart';
import 'package:nodemobile/product/models/fis_satir_model.dart';
import 'package:nodemobile/product/models/varyant_model.dart';
import 'package:nodemobile/product/widgets/search_view.dart';

class FisIcerikViewModel extends ChangeNotifier {
  VaryantModel? _urun;
  VaryantModel? get urun => _urun;
  set urun(VaryantModel? value) {
    if (value != null) {
      urunAdi = '${value.name}\nPaketteki miktar: ${value.stokAdeti}';
      barcodeController.text = value.barcode ?? "Barkod bulunamadı";
      _urun = value;
    }
  }

  LocaleDatatable? productList;

  List<VaryantModel> get urunlerModelleri =>
      productList!.rowsAsJson.map((e) => VaryantModel.fromJson(e)).toList();
  List<FisSatiriModel> fisSatirlari = [];

  FisBasligiModel fisBasligi;
  FisIcerikViewModel(
      {required this.fisBasligi,
      required this.barcodeController,
      required this.countController,
      required this.countFocus,
      required this.barcodeFocus,
      required this.formKey}) {
    DatabaseHelper.instance.stokManager.updateStocks().then((value) {
      DatabaseService.instance.firmDb
          .mySelectQuery(
              "select ID,Barcode,Name,Aciklama,Miktar from V_AllItems")
          .then((value) {
        productList = value;
        retriveAllRows();
      });
    });

    countController.addListener(() {
      if (easyCount) {
        countController.text = easyCountValue.toString();
      }
    });
  }

  GlobalKey<FormState> formKey;
  TextEditingController barcodeController;
  TextEditingController countController;
  FocusNode countFocus;
  FocusNode barcodeFocus;

  String _urunAdi = "Ürün adı burada gözükecek";
  String get urunAdi => _urunAdi;
  set urunAdi(String value) {
    _urunAdi = value;
    notifyListeners();
  }

  bool _easyBarcode = false;
  bool _easyCount = false;
  double easyCountValue = 0;
  bool get easyBarcode => _easyBarcode;
  bool get easyCount => _easyCount;
  set easyBarcode(bool value) {
    _easyBarcode = value;
    notifyListeners();
  }

  set easyCount(bool value) {
    double? value2 = double.tryParse(countController.text);
    if (value2 != null && value2 != 0) {
      _easyCount = value;
      easyCountValue = value2;
      notifyListeners();
    }
  }

  Future readBarcode() async {
    final data = await FlutterBarcodeScanner.scanBarcode(
        "white", "iptal", false, ScanMode.DEFAULT);
    if (data != "-1") {
      barcodeController.text = data;
      await getProductByBarcode();
    } else {
      barcodeFocus.requestFocus();
    }
    notifyListeners();
  }

  Future addProduct([String? barkod]) async {
    String barcode = barkod ?? barcodeController.text;
    String count = countController.text;
    if (barcode.isEmpty) {
      PopupHelper.showSimpleSnackbar("Barkod boş olamaz", error: true);
    }
    if (count.isEmpty) {
      PopupHelper.showSimpleSnackbar("Adet boş olamaz", error: true);
    }
    notifyListeners();
  }

  // Future getProductById(int id) async {
  //   LocaleDatatable? result =
  //       await DatabaseHelper.instance.fisManager.getProcutById(id);
  //   if (result != null) {
  //     urun = VaryantModel.fromJson(result.rowsAsJson.first);
  //     if (easyCount) {
  //       addTrnLine();
  //     } else {
  //       countFocus.requestFocus();
  //     }
  //   } else {
  //     PopupHelper.showSimpleSnackbar("Ürün bulunamadı", error: true);
  //     barcodeFocus.requestFocus();
  //   }
  // }

  // Future<VaryantModel?> returnProductById(int id) async {
  //   LocaleDatatable? result =
  //       await DatabaseHelper.instance.fisManager.getProcutById(id);
  //   if (result != null) {
  //     return VaryantModel.fromJson(result.rowsAsJson.first);
  //   } else {
  //     return null;
  //   }
  // }

  Future<void> getProductByBarcode([String? barkod]) async {
    LocaleDatatable? result = await DatabaseHelper.instance.fisManager
        .getProcutByBarcode(barkod ?? barcodeController.text);
    if (result != null) {
      if (result.isNotEmpty) {
        urun = VaryantModel.fromJson(result.rowsAsJson.first);
        if (easyCount) {
          addTrnLine();
        } else {
          countFocus.requestFocus();
        }
      } else {
        urun = null;
        urunAdi = "Ürün bulunamadı";
        barcodeController.clear();
        barcodeFocus.requestFocus();
      }
    } else {
      PopupHelper.showSimpleSnackbar("Ürün bulunamadı", error: true);
    }
  }

  Future addTrnLine() async {
    if (urun == null) {
      PopupHelper.showSimpleSnackbar("Ürün seçilmedi", error: true);
      return;
    } else if (countController.text.isEmpty) {
      PopupHelper.showSimpleSnackbar("Adet boş olamaz", error: true);
      return;
    }
    await addProduct();
    if (fisSatirlari.any((element) {
      if (element.productId == urun!.id && element.seriNo == urun!.barcode) {
        return true;
      } else {
        return false;
      }
    })) {
      await updateLine(
          fisSatirlari.indexWhere((element) => element.productId == urun!.id),
          adding: true);
      countController.text = "";
      barcodeController.text = "";
      barcodeFocus.requestFocus();
      urun = null;
      urunAdi = "Ürün adı burada gözükecek";
      orderLinesByDate();
      if (easyBarcode) {
        readBarcode();
      } else {
        barcodeFocus.requestFocus();
      }
      PopupHelper.showSimpleSnackbar("Satır güncellendi");
      return;
    }

    final now = DateTime.now();
    FisSatiriModel satir = FisSatiriModel(
      date: now.DT,
      stockTransId: fisBasligi.id!,
      productId: urun!.id,
      seriNo: urun!.barcode,
      beden: urun!.beden,
      renk: urun!.urunRenk,
      type: fisBasligi.type,
      productType: urun!.type,
      amount: double.parse(countController.text.replaceAll(",", ".")),
      unitId: urun!.unitId,
      unitPrice: urun!.unitPrice,
      taxRate: urun!.taxRate,
      branch: fisBasligi.branch,
      goldensync: 0,
      createdBy:
          LocaleManager.instance.getInt(LocaleManagerEnums.loggedUserId)!,
      createdDate: now.DT,
    );
    int id = await DatabaseHelper.instance.fisManager.addTrnLine(satir);
    if (id != -1) {
      satir.id = id;
      fisSatirlari.add(satir);
      countController.text = "";
      barcodeController.text = "";
      barcodeFocus.requestFocus();
      urun = null;
      urunAdi = "Ürün adı burada gözükecek";
      orderLinesByDate();
      if (easyBarcode) {
        await readBarcode();
      } else {
        barcodeFocus.requestFocus();
      }
      PopupHelper.showSimpleSnackbar("Satır eklendi");
    } else {
      PopupHelper.showSimpleSnackbar("Satır eklenemedi", error: true);
    }
  }

  Future selectFromList() async {
    if (productList != null) {
      final data = await NavigationService.instance.navigateToWidget(
          widget: SearchView(
              label: "Ürün seç",
              data: productList!.rowsAsJson,
              titleKey: "Name",
              subTitles: const ["Miktar", "Aciklama", "Barcode"],
              searchBy: const ["Name", "Barcode", "Miktar", "Aciklama"]));
      if (data != null) {
        await getProductByBarcode(data["Barcode"]);
      } else {
        log("data null");
      }
    } else {
      await PopupHelper.showSimpleSnackbar("Ürünler listelenemedi",
          error: true);
    }
  }

  Future retriveAllRows() async {
    LocaleDatatable? rows = await DatabaseService.instance.firmDb.mySelectQuery(
        "select * from TRN_StockTransLines where StockTransId = ${fisBasligi.id}");
    if (rows != null) {
      fisSatirlari =
          rows.rowsAsJson.map((e) => FisSatiriModel.jromJson(e)).toList();
    }
    orderLinesByDate();
  }

  Future updateLine(int index, {required bool adding}) async {
    FisSatiriModel satir = fisSatirlari[index];
    double oldAmount = satir.amount;
    String oldDate = satir.date;
    if (adding) {
      satir.amount += double.parse(countController.text.replaceAll(",", "."));
    } else {
      satir.amount = double.parse(countController.text.replaceAll(",", "."));
    }
    satir.date = DateTime.now().DT;
    bool success =
        await DatabaseHelper.instance.fisManager.updateTrnLine(satir);
    if (success) {
      orderLinesByDate();
      PopupHelper.showSimpleSnackbar("Satır güncellendi");
    } else {
      satir.amount = oldAmount;
      satir.date = oldDate;
    }
  }

  Future removeTrnLine(int index) async {
    FisSatiriModel satir = fisSatirlari[index];
    bool success =
        await DatabaseHelper.instance.fisManager.deleteTrnLine(satir.id!);
    if (success) {
      fisSatirlari.removeAt(index);
      orderLinesByDate();
      PopupHelper.showSimpleSnackbar("Satır silindi");
    } else {
      PopupHelper.showSimpleSnackbar("Satır silinemedi", error: true);
    }
  }

  orderLinesByDate() {
    fisSatirlari.sort((a, b) => DatetimeHelper.fromDateTimeString(b.date)
        .compareTo(DatetimeHelper.fromDateTimeString(a.date)));
    notifyListeners();
  }
}
