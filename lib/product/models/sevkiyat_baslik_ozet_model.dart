class SevkiyatBaslikOzetModel {
  int id;
  String? ficheNo;
  String transDate;
  String? notes;
  String? cariAdi;
  String? depoAdi;
  String? nameSurname;
  String? branchName;

  SevkiyatBaslikOzetModel({
    required this.id,
    this.ficheNo,
    required this.transDate,
    this.notes,
    this.cariAdi,
    this.depoAdi,
    this.nameSurname,
    this.branchName,
  });

  factory SevkiyatBaslikOzetModel.fromJson(Map<String, dynamic> json) =>
      SevkiyatBaslikOzetModel(
        id: json["ID"],
        transDate: json["TransDate"],
        notes: json.containsKey("Notes") ? json["Notes"] : null,
        cariAdi: json.containsKey("CariAdi") ? json["CariAdi"] : null,
        depoAdi: json.containsKey("DepoAdi") ? json["DepoAdi"] : null,
        nameSurname:
            json.containsKey("NameSirname") ? json["NameSirname"] : null,
        branchName: json.containsKey("BranchName") ? json["BranchName"] : null,
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
}
