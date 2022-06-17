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
  late String seriNo;
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
      required this.seriNo,
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
    id = json.containsKey("ID") ? json["ID"] : null;
    beden = json.containsKey("Beden") ? json["Beden"] : null;
    renk = json.containsKey("Renk") ? json["Renk"] : null;
    type = json.containsKey("Type") ? json["Type"] : null;
    productType = json.containsKey("ProductType") ? json["ProductType"] : null;
    unitId = json.containsKey("UnitID") ? json["UnitID"] : null;
    unitPrice = json.containsKey("UnitPrice") ? json["UnitPrice"] : null;
    taxRate = json.containsKey("TaxRate") ? json["TaxRate"] : null;
    stockWareHouseId =
        json.containsKey("StockWareHouseID") ? json["StockWareHouseID"] : null;
    destStockWareHouseId = json.containsKey("DestStockWareHouseID")
        ? json["DestStockWareHouseID"]
        : null;

    date = json["Date"];
    stockTransId = json["StockTransID"];
    productId = json["ProductID"];
    seriNo = json["SeriNo"];
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
      "SeriNo": seriNo,
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
    if (stockWareHouseId != null) {
      data["StockWareHouseID"] = stockWareHouseId;
    }
    if (destStockWareHouseId != null) {
      data["DestStockWareHouseID"] = destStockWareHouseId;
    }
    if (beden != null) data["Beden"] = beden;
    if (renk != null) data["Renk"] = renk;
    if (type != null) data["Type"] = type;
    if (productType != null) data["ProductType"] = productType;
    if (unitId != null) data["UnitID"] = unitId;
    if (unitPrice != null) data["UnitPrice"] = unitPrice;
    if (taxRate != null) data["TaxRate"] = taxRate;
    return data;
  }

  @override
  String toString() => toJson().toString();

  String toInsertQuery() =>
      """INSERT INTO TRN_StockTransLines (Date, Direction, Status, InvoiceID, StockTransID, DestStockWareHouseID, ProductID, SeriNo, Beden, Renk, Type, ProductType, LineExp, Amount, UnitID, UnitPrice, CurrencyID, CurrencyRate, TaxRate, Branch, GoldenSync, CreatedBy, CreatedDate) VALUES (
        '$date',$direction,$status,$invoiceId,$stockTransId,$destStockWareHouseId,$productId,'$seriNo',$beden,$renk,$type,$productType,'$lineExp',$amount,$unitId,$unitPrice,$currencyId,$currencyRate,$taxRate,$branch,$goldensync,$createdBy,'$createdDate'
        );""";
}
