class FisSatiriModel {
  int? id;
  int? beden;
  int? renk;
  int? type;
  int? productType;
  int? unitId;
  double? unitPrice;
  double? taxRate;
  int? stockWareHouseId;
  int? destStockWareHouseId;
  String? seriNo;

  int get direction {
    if (type == 0 || type == 11 || type == 14) {
      return 1;
    } else if (type == 1 || type == 10) {
      return -1;
    } else {
      return 0;
    }
  }

  int status = 1;
  int invoiceId = 0;
  int currencyId = 0;
  double currencyRate = 1;
  String lineExp = "";

  late String date;
  late int stockTransId;
  late int productId;
  late double amount;
  late int branch;
  late int goldensync;
  late int createdBy;
  late String createdDate;

  FisSatiriModel(
      {this.id,
      required this.date,
      required this.stockTransId,
      required this.productId,
      this.seriNo,
      this.beden,
      this.renk,
      required this.type,
      this.productType,
      required this.amount,
      this.unitId,
      this.unitPrice,
      this.taxRate,
      required this.branch,
      required this.goldensync,
      this.stockWareHouseId,
      this.destStockWareHouseId,
      required this.createdBy,
      required this.createdDate});

  FisSatiriModel.jromJson(Map<String, dynamic> json) {
    id ??= json["ID"];
    beden ??= json["Beden"];
    renk ??= json["Renk"];
    type ??= json["Type"];
    productType ??= json["ProductType"];
    unitId ??= json["UnitID"];
    unitPrice ??= json["UnitPrice"];
    taxRate ??= json["TaxRate"];
    stockWareHouseId ??= json["StockWareHouseID"];
    destStockWareHouseId ??= json["DestStockWareHouseID"];
    seriNo ??= json["SeriNo"];

    date = json["Date"];
    stockTransId = json["StockTransID"];
    productId = json["ProductID"];
    amount = json["Amount"];
    branch = json["Branch"];
    goldensync = json["GoldenSync"];
    createdBy = json["CreatedBy"];
    createdDate = json["CreatedDate"];
  }

  toJson() {
    Map<String, dynamic> data = {
      "Date": date,
      "Direction": direction,
      "Status": status,
      "InvoiceID": invoiceId,
      "StockTransID": stockTransId,
      "ProductID": productId,
      "LineExp": lineExp,
      "Amount": amount,
      "CurrencyID": currencyId,
      "CurrencyRate": currencyRate,
      "Branch": branch,
      "GoldenSync": goldensync,
      "CreatedBy": createdBy,
      "CreatedDate": createdDate,
    };

    if (id != null) data["ID"] = id;
    if (beden != null) data["Beden"] = beden;
    if (renk != null) data["Renk"] = renk;
    if (type != null) data["Type"] = type;
    if (productType != null) data["ProductType"] = productType;
    if (unitId != null) data["UnitID"] = unitId;
    if (seriNo != null) data["SeriNo"] = seriNo;
    if (unitPrice != null) data["UnitPrice"] = unitPrice;
    if (taxRate != null) data["TaxRate"] = taxRate;
    if (stockWareHouseId != null) data["StockWareHouseID"] = stockWareHouseId;
    if (destStockWareHouseId != null) {
      data["DestStockWareHouseID"] = destStockWareHouseId;
    }

    return data;
  }

  @override
  String toString() => toJson().toString();

  String toInsertQuery() =>
      """INSERT INTO TRN_StockTransLines (Date, Direction, Status, InvoiceID, StockTransID, DestStockWareHouseID, ProductID, SeriNo, Beden, Renk, Type, ProductType, LineExp, Amount, UnitID, UnitPrice, CurrencyID, CurrencyRate, TaxRate, Branch, GoldenSync, CreatedBy, CreatedDate) VALUES (
        '$date',$direction,$status,$invoiceId,@DataID,$destStockWareHouseId,$productId,'$seriNo',$beden,$renk,$type,$productType,'$lineExp',$amount,$unitId,$unitPrice,$currencyId,$currencyRate,$taxRate,$branch,$goldensync,$createdBy,'$createdDate'
        );""";
}
