import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:nodemobile/core/services/database/remote_database_service.dart';
import 'package:nodemobile/core/services/navigation/navigation_service.dart';
import 'package:nodemobile/core/utils/ui/popup.dart';
import 'package:nodemobile/product/widgets/search_view.dart';

class SiparisKontrolViewModel extends ChangeNotifier {
  TextEditingController barcodeController;
  TextEditingController countController;
  FocusNode countFocus;
  FocusNode barcodeFocus;

  SiparisKontrolViewModel(
      {required this.barcodeController,
      required this.countController,
      required this.countFocus,
      required this.barcodeFocus});

  Map<String, dynamic> headerData = {};
  List<Map<String, dynamic>> data = [];
  Map<String, dynamic>? product;
  Map<String, num> addedList = {};

  bool _easyBarcode = false;
  bool get easyBarcode => _easyBarcode;
  set easyBarcode(bool value) {
    _easyBarcode = value;
    notifyListeners();
  }

  bool _easyCount = false;
  bool get easyCount => _easyCount;
  set easyCount(bool value) {
    _easyCount = value;
    notifyListeners();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getData({required String ficheNo}) async {
    // TODO: Sorguuu
    RemoteDatatable? header = await RemoteDatabaseService.read("""

SELECT        C.Name AS CustomerName, CA.MobilePhone AS Phone, CA.Adress,     WO.FicheNo, WO.OrderDate, WO.DeliveryDate, WO.OrderNotes

 FROM            V_WebOrders AS WO LEFT OUTER JOIN
                     CRD_CariAdres AS CA ON WO.DeliveryAdressID = CA.ID LEFT OUTER JOIN
                      CRD_Cari AS C ON WO.CariID = C.ID

          WHERE WO.FicheNo='$ficheNo' AND WO.Iade=0  GROUP BY C.Name, CA.MobilePhone , CA.Adress, WO.OrderID , WO.MainStatusName , WO.FicheNo, WO.OrderDate, WO.DeliveryDate, WO.OrderNotes, WO.MainStatus,
                                  WO.DeliveryAdressID
    """);
    if (header != null) {
      headerData = header.rowsAsJson()[0];
    }

    RemoteDatatable? lines = await RemoteDatabaseService.read("""

SELECT        I.Name, I.UnitCode, I.ColorName, I.Beden, O.Amount, ISNULL(O.Notes,''), I.Barcode
FROM            V_WebOrders AS O INNER JOIN
                         V_AllItems AS I ON O.SeriNo = I.Barcode
WHERE        (O.FicheNo = '$ficheNo') AND (O.SeriNo <> 'DELIVERY') AND (O.Iade = 0) AND (O.LineIptal = 0)
    """);
    if (lines != null) {
      data = lines.rowsAsJson();
    }
    isLoading = false;
  }

  Future<void> getProductByBarcode(String barcode) async {
    if (data.any((element) => element["Barcode"] == barcode)) {
      product = data.firstWhere((element) => element["Barcode"] == barcode);
    } else {
      product = null;
      PopupHelper.showSimpleSnackbar("Ürün listede yok");
      barcodeController.text = "";
    }

    notifyListeners();
    if (easyCount) {
      addProductToList();
    }
  }

  Future<void> readBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "iPTAL", true, ScanMode.DEFAULT);
    if (barcode != "-1") {
      barcodeController.text = barcode;
      getProductByBarcode(barcode);
    }
  }

  Future<void> selectFromList() async {
    Map<String, dynamic>? product = await NavigationService.instance
        .navigateToWidget(SearchView(
            label: "Ürün ara",
            data: data,
            titleKey: "Name",
            searchBy: const ["Barcode", "Name"]));
    if (product != null) {
      this.product = product;
      barcodeController.text = product["Barcode"];
      if (easyCount) {
        addProductToList();
      } else {
        countFocus.requestFocus();
      }
    }
    notifyListeners();
  }

  void addProductToList() {
    String countString = countController.text;
    num count = num.parse(countString.replaceAll(",", "."));
    if (product == null) {
      PopupHelper.showSimpleSnackbar("Bir ürün seçilmedi", error: true);
      return;
    }
    if (addedList.containsKey(product!["Barcode"])) {
      if (addedList[product!["Barcode"]]! + count > product!["Amount"]) {
        PopupHelper.showSimpleSnackbar(
            "Ürün adedi sipariş adedinden fazla olamaz",
            error: true);
        return;
      }
      addedList[product!["Barcode"]] =
          addedList[product!["Barcode"]]! + (count);
    } else {
      addedList[product!["Barcode"]] = count;
    }
    PopupHelper.showSimpleSnackbar("Ürün eklendi");
    notifyListeners();
    if (easyBarcode) {
      readBarcode();
    }
  }

  Future<void> save() async {
    bool allAdded = true;
    for (var element in data) {
      if (element["Amount"] != addedList[element["Barcode"]]) {
        allAdded = false;
      }
    }
    if (!allAdded) {
      PopupHelper.showSimpleSnackbar("Sipariş tamamlanmadı", error: true);
      return;
    }
    showDialog(
        context: NavigationService.context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Dikkat."),
            content:
                const Text("Sipariş kontrolü tamamlandı. Siparişi tamamla?"),
            actions: [
              TextButton(
                  onPressed: () {
                    NavigationService.instance.back();
                  },
                  child: const Text("Hayır")),
              TextButton(
                  onPressed: () {
                    // TODO: Sorguuu
                  },
                  child: const Text("Evet")),
            ],
          );
        });
  }
}
