class VaryantModel {
  late int id;
  late String aciklama;
  late String name;
  late double miktar;
  late String barcode;
  int? unitId;
  int? type;
  double? unitPrice;
  int? urunRenk;
  int? beden;
  double? taxRate;

  VaryantModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    name = json['Name'];
    aciklama = json['Aciklama'];
    miktar = json['Miktar'];
    barcode = json['Barcode'];
    unitId = json.containsKey("UnitID") ? json['UnitID'] : null;
    type = json.containsKey("Type") ? json['Type'] : null;
    unitPrice = json.containsKey("UnitPrice") ? json['UnitPrice'] : null;
    urunRenk = json.containsKey("UrunRenk") ? json['UrunRenk'] : null;
    beden = json.containsKey("Beden") ? json['Beden'] : null;
    taxRate = json.containsKey("TaxRate") ? json['TaxRate'] : null;
  }

  toJson() {
    Map<String, dynamic> data = {
      'ID': id,
      'Aciklama': aciklama,
      'Miktar': miktar,
      'Barcode': barcode,
      'Name': name,
    };
    if (unitId != null) {
      data['UnitID'] = unitId;
    }
    if (type != null) {
      data['Type'] = type;
    }
    if (unitPrice != null) {
      data['UnitPrice'] = unitPrice;
    }
    if (beden != null) {
      data['Beden'] = beden;
    }
    if (urunRenk != null) {
      data['UrunRenk'] = urunRenk;
    }
    if (taxRate != null) {
      data['TaxRate'] = taxRate;
    }
    return data;
  }

  @override
  String toString() => toJson().toString();
}
