class FisBasligiModel {
  int? id;
  late String ficheNo;
  int? cariId;
  late int branch;
  late int type;
  late int status;
  late String transdate;
  late String notes;
  int? stockWareHouseID;
  int? destStockWareHouseID;
  late int createdBy;
  late String createdDate;
  late int goldenSync;

  FisBasligiModel.empty();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "FicheNo": ficheNo,
      "Branch": branch,
      "Type": type,
      "Status": status,
      "TransDate": transdate,
      "Notes": notes,
      "CreatedBy": createdBy,
      "CreatedDate": createdDate,
      "GoldenSync": goldenSync
    };
    if (id != null) {
      data["ID"] = id;
    }
    if (cariId != null) {
      data["CariID"] = cariId;
    }
    if (stockWareHouseID != null) {
      data["StockWareHouseID"] = stockWareHouseID;
    }
    if (destStockWareHouseID != null) {
      data["DestStockWareHouseID"] = destStockWareHouseID;
    }
    return data;
  }

  FisBasligiModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey("ID") ? json["ID"] : null;
    ficheNo = json["FicheNo"];
    cariId = json.containsKey("CariID") ? json["CariID"] : null;
    branch = json["Branch"];
    type = json["Type"];
    status = json["Status"];
    transdate = json["TransDate"];
    notes = json["Notes"];
    stockWareHouseID =
        json.containsKey("StockWareHouseID") ? json["StockWareHouseID"] : null;
    destStockWareHouseID = json.containsKey("DestStockWareHouseID")
        ? json["DestStockWareHouseID"]
        : null;
    createdBy = json["CreatedBy"];
    createdDate = json["CreatedDate"];
    goldenSync = json["GoldenSync"];
  }

  toInsertQuery() {
    return "INSERT INTO TRN_StockTrans (FicheNo, CariID, Branch, Type, Status, TransDate, Notes, StockWareHouseID, DestStockWareHouseID, CreatedBy, CreatedDate, GoldenSync) VALUES ('$ficheNo', $cariId, $branch, $type, $status, '$transdate', '$notes', $stockWareHouseID, $destStockWareHouseID, $createdBy, '$createdDate', $goldenSync);";
  }

  FisBasligiModel copy() {
    return FisBasligiModel.fromJson(toJson());
  }

  @override
  String toString() => toJson().toString();
}
