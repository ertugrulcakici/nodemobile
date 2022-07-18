part of my_database_helper;

class SevkiyatManager {
  static SevkiyatManager? _instance;
  static SevkiyatManager get _private => _instance ??= SevkiyatManager._();
  SevkiyatManager._();

  Future<RemoteDatatable?> getInitialLines(int id) async {
    return await RemoteDatabaseService.read(
        "select I.ID as PD, I.Name as UrunAd, ISNULL(SeriNo,I.Barcode) as Barkod, Amount as Miktar, Amount as RealAmount, 0 as Yuklenen, Amount as Kalan, T.* from TRN_StockTransLines T, CRD_Items I where I.ID= T.ProductID AND T.StockTransID = ?;",
        args: [id]);
  }

  Future<RemoteDatatable?> getProductByBarcode(String barcode) async =>
      await RemoteDatabaseService.read('''
DECLARE @NO nvarchar(100) = '$barcode';

SELECT * FROM 
      (
      SELECT 'PALET' as IslemTuru, SUM(CONVERT(DECIMAL(18,3),Miktar)) as Miktar ,BalyaNo, '' as PaketNo ,Code,Name,Depo, ID,WorkOrderID, LotID, SUM(PakettekiAdet) AS PakettekiAdet,LineExp FROM V_DepoHareketleri 
      WHERE  BalyaNo= @NO
      GROUP BY BalyaNo,Depo, ID,WorkOrderID, LotID,LineExp, Name,Code
      HAVING SUM(CONVERT(DECIMAL(18,3),Miktar))>0
      
      UNION ALL
      
      SELECT 'PAKET' as IslemTuru,SUM(CONVERT(DECIMAL(18,3),Miktar)) as Miktar, Max(BalyaNo), PaketNo  ,Code, Name,Depo, ID,WorkOrderID, LotID,  SUM(PakettekiAdet) AS PakettekiAdet,LineExp FROM V_DepoHareketleri 
      WHERE PaketNo= @NO
      GROUP BY PaketNo,Depo, ID,WorkOrderID, LotID,LineExp, Name,Code
      HAVING SUM(CONVERT(DECIMAL(18,3),Miktar))>0
      ) as Z
''');

  Future<int> addLineToLocale(Map<String, dynamic> data,
      Map<String, dynamic> line, SevkiyatBaslikOzetModel baslik) async {
    String now = DateTime.now().DT;
    return await DatabaseService.instance.userDb
        .insert(TableNames.TRN_StockTransLines.name, {
      "Date": now,
      "Direction": -1,
      "OrderID": line["OrderID"],
      "OrderLinesID": line["OrderLinesID"],
      "WorkOrderID": data["WorkOrderID"],
      "Status": 6,
      "StockTransID": line["StockTransID"],
      "ProjectID": line["ProjectID"],
      "ProductID": data["ID"],
      "SeriNo": line["SeriNo"],
      "Type": line["Type"],
      "LotID": data["LotID"],
      "BalyaNo": data["BalyaNo"],
      "ProductType": line["ProductType"],
      "Amount": data["Miktar"],
      "RealAmount": line["RealAmount"],
      "UnitID": line["UnitID"],
      "UnitPrice": line["UnitPrice"],
      "LineTotal": line["LineTotal"],
      "Discount": line["Discount"],
      "DiscountRate": line["DiscountRate"],
      "Discount2": line["Discount2"],
      "DiscountRate2": line["DiscountRate2"],
      "Discount3": line["Discount3"],
      "DiscountRate3": line["DiscountRate3"],
      "Total": line["Total"],
      "CurrencyID": line["CurrencyID"],
      "CurrencyRate": line["CurrencyRate"],
      "TaxRate": line["TaxRate"],
      "TotalTax": line["TotalTax"],
      "Branch": baslik.branchId,
      "StockWareHouseID": baslik.wareHouseId,
      "CreatedBy":
          LocaleManager.instance.getInt(LocaleManagerEnums.loggedUserId),
      "CreatedDate": now,
      "PakettekiAdet": data["PakettekiAdet"],
      "PaketNo": data["PaketNo"],
      "LineExp": data["LineExp"],
    });
  }

  Future<RemoteDatatable?> depolariGetir() async {
    return await RemoteDatabaseService.read(
        "select ID,Name from CRD_StockWareHouse;");
  }

  Future<RemoteDatatable?> branchleriGetir() async {
    return await RemoteDatabaseService.read(
        "select BranchNo,Name from X_Branchs;");
  }

  Future<bool> deleteLine(int id) async {
    try {
      await DatabaseService.instance.userDb.execute(
        "delete from TRN_StockTransLines where ID = ?",
        [id],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<LocaleDatatable?> getLocaleLines(int baslikId) async {
    return await DatabaseService.instance.userDb.mySelectQuery(
        "select * from TRN_StockTransLines where StockTransID = ?", [baslikId]);
  }

  Future save({required int stockTransId}) async {
    LocaleDatatable? lines = await getLocaleLines(stockTransId);
    if (lines == null) {
      return;
    }
    List<String> linesData = [];
    for (Map<String, dynamic> element in lines.rowsAsJson) {
      linesData.add("""
        INSERT INTO TRN_StockTransLines (
          Date,
          Direction,
          OrderID,
          OrderLinesID,
          WorkOrderID,
          Status,
          StockTransID,
          ProjectID,
          ProductID,
          SeriNo,
          Type,
          LotID,
          BalyaNo,
          ProductType,
          Amount,
          RealAmount,
          UnitID,
          UnitPrice,
          LineTotal,
          Discount,
          DiscountRate,
          Discount2,
          DiscountRate2,
          Discount3,
          DiscountRate3,
          Total,
          CurrencyID,
          CurrencyRate,
          TaxRate,
          TotalTax,
          Branch,
          StockWareHouseID,
          CreatedBy,
          CreatedDate,
          PakettekiAdet,
          PaketNo,
          LineExp
          ) VALUES (
          '${element["Date"]}',
          ${element["Direction"]},
          ${element["OrderID"]},
          ${element["OrderLinesID"]},
          ${element["WorkOrderID"]},
          ${element["Status"]},
          ${element["StockTransID"]},
          ${element["ProjectID"]},
          ${element["ProductID"]},
          '${element["SeriNo"]}',
          ${element["Type"]},
          ${element["LotID"] != null ? "'${element["LotID"]}'" : "null"},
          ${element["BalyaNo"] != null ? "'${element["BalyaNo"]}'" : "null"},
          ${element["ProductType"]},
          ${element["Amount"]},
          ${element["RealAmount"]},
          ${element["UnitID"]},
          ${element["UnitPrice"]},
          ${element["LineTotal"]},
          ${element["Discount"]},
          ${element["DiscountRate"]},
          ${element["Discount2"]},
          ${element["DiscountRate2"]},
          ${element["Discount3"]},
          ${element["DiscountRate3"]},
          ${element["Total"]},
          ${element["CurrencyID"]},
          ${element["CurrencyRate"]},
          ${element["TaxRate"]},
          ${element["TotalTax"]},
          ${element["Branch"]},
          ${element["StockWareHouseID"]},
          ${element["CreatedBy"]},
          '${element["CreatedDate"]}',
          ${element["PakettekiAdet"]},
          ${element["PaketNo"] != null ? "'${element["PaketNo"]}'" : "null"},
          ${element["LineExp"] != null ? "'${element["LineExp"]}'" : "null"},
          );
      """);
    }
    String query = """
SET XACT_ABORT ON;
BEGIN TRANSACTION
    update TRN_StockTrans set Status = 6 where ID = $stockTransId;
    delete from TRN_StockTransLines where StockTransID = $stockTransId;
    ${linesData.join("\n")}
    COMMIT
    SET XACT_ABORT OFF;
""";
    try {
      await RemoteDatabaseService.execute(query);
      await DatabaseService.instance.userDb.execute(
        "delete from TRN_StockTransLines where StockTransID = ?",
        [stockTransId],
      );
      return true;
    } catch (e) {
      log(e.toString());
      EasyLoading.showError("Sevkiyat kaydedilemedi. Hata kodu: $e");
      return false;
    }
  }
}
