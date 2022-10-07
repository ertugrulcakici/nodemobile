import 'package:flutter/material.dart';
import 'package:nodemobile/core/services/database/remote_database_service.dart';

class WebSatisViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> headers = [];
  Map<int, List> data = {};

  late int selectedCode;

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getHeader() async {
    String query = """
SELECT Code,Name FROM X_Types WHERE TableName='Orders' AND ColumnsName='Status' AND Code3=15 AND Code>400 AND Code<407
""";
    RemoteDatatable? result = await RemoteDatabaseService.read(query);
    headers.addAll(result!.rowsAsJson());
    selectedCode = headers[0]['Code'] as int;
    getProductsByCode(selectedCode);
  }

  Future<void> getProductsByCode(int code) async {
    isLoading = true;
    String query = """
SELECT        C.Name AS CustomerName, CA.MobilePhone AS Phone, CA.Adress, WO.OrderID AS ID, WO.MainStatusName AS StatusName, WO.FicheNo, WO.OrderDate, WO.DeliveryDate, WO.OrderNotes, WO.MainStatus AS StatusCode, 
                     WO.DeliveryAdressID 
 FROM            V_WebOrders AS WO LEFT OUTER JOIN 
                     CRD_CariAdres AS CA ON WO.DeliveryAdressID = CA.ID LEFT OUTER JOIN 
                      CRD_Cari AS C ON WO.CariID = C.ID 
 
          WHERE WO.MainStatus=$code AND WO.Iade=0  GROUP BY C.Name, CA.MobilePhone , CA.Adress, WO.OrderID , WO.MainStatusName , WO.FicheNo, WO.OrderDate, WO.DeliveryDate, WO.OrderNotes, WO.MainStatus, 
                                  WO.DeliveryAdressID
""";
    RemoteDatatable? result = await RemoteDatabaseService.read(query);
    if (result != null) {
      data[code] = result.rowsAsJson();
    }
    selectedCode = code;
    isLoading = false;
  }
}
