class SevkiyatBaslikOzetModel {
  int id;
  String? ficheNo;
  String transDate;
  String? notes;
  String? cariAdi;
  String? depoAdi;
  String? nameSurname;
  String? branchName;
  String? soforAdi;
  String? soforTC;
  String? soforTelefon;
  String? konteynerAracPlaka;
  String? dorsePlaka;
  int? branchId;
  int? wareHouseId;

  SevkiyatBaslikOzetModel({
    required this.id,
    this.ficheNo,
    required this.transDate,
    this.notes,
    this.cariAdi,
    this.depoAdi,
    this.nameSurname,
    this.branchName,
    this.branchId,
    this.wareHouseId,
    this.soforAdi,
    this.soforTC,
    this.soforTelefon,
    this.konteynerAracPlaka,
    this.dorsePlaka,
  });

  factory SevkiyatBaslikOzetModel.fromJson(Map<String, dynamic> json) =>
      SevkiyatBaslikOzetModel(
        id: json["ID"],
        transDate: json["TransDate"],
        notes: json["Notes"],
        cariAdi: json["CariAdi"],
        depoAdi: json["DepoAdi"],
        nameSurname: json["NameSirname"],
        branchName: json["BranchName"],
        branchId: json["Branch"],
        wareHouseId: json["StockWareHouseID"],
        soforAdi: json["SoforAdi"],
        soforTC: json["SoforTC"],
        soforTelefon: json["SoforTelefon"],
        konteynerAracPlaka: json["KonteynerAracPlaka"],
        dorsePlaka: json["DorsePlaka"],
      );

  String toPrettyString() {
    String subtitle = "";
    subtitle += "Fiş id: $id\n";
    subtitle += "Fiş numarası: $ficheNo\n";
    subtitle += "Not: $notes\n";
    subtitle += "Eklenme tarihi: $transDate\n";
    subtitle += "Cari adı: $cariAdi\n";
    subtitle += "Depo adı: $depoAdi\n";
    subtitle += "Ekleyen: $nameSurname\n";
    subtitle += "İş yeri: $branchName";
    return subtitle;
  }

  SevkiyatBaslikOzetModel copy() => SevkiyatBaslikOzetModel.fromJson(toJson());

  toJson() => {
        "ID": id,
        "TransDate": transDate,
        "Notes": notes,
        "CariAdi": cariAdi,
        "DepoAdi": depoAdi,
        "NameSirname": nameSurname,
        "BranchName": branchName,
        "Branch": branchId,
        "StockWareHouseID": wareHouseId,
        "SoforAdi": soforAdi,
        "SoforTC": soforTC,
        "SoforTelefon": soforTelefon,
        "KonteynerAracPlaka": konteynerAracPlaka,
        "DorsePlaka": dorsePlaka,
      };
}
