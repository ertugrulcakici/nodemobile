class VaryantModel {
  late int id;
  String? aciklama;
  String? name;
  double? miktar;
  String? barcode;
  int? unitId;
  int? type;
  double? unitPrice;
  int? urunRenk;
  int? beden;
  double? taxRate;

  VaryantModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    name ??= json['Name'];
    aciklama ??= json['Aciklama'];
    miktar ??= json['Miktar'];
    barcode ??= json['Barcode'];
    unitId ??= json['UnitID'];
    type ??= json['Type'];
    unitPrice ??= json['UnitPrice'];
    urunRenk ??= json['UrunRenk'];
    beden ??= json['Beden'];
    taxRate ??= json['TaxRate'];
  }

  toJson() {
    Map<String, dynamic> data = {
      'ID': id,
    };

    if (name != null) data['Name'] = name;
    if (aciklama != null) data['Aciklama'] = aciklama;
    if (miktar != null) data['Miktar'] = miktar;
    if (barcode != null) data['Barcode'] = barcode;
    if (unitId != null) data['UnitID'] = unitId;
    if (type != null) data['Type'] = type;
    if (unitPrice != null) data['UnitPrice'] = unitPrice;
    if (urunRenk != null) data['UrunRenk'] = urunRenk;
    if (beden != null) data['Beden'] = beden;
    if (taxRate != null) data['TaxRate'] = taxRate;
    return data;
  }

  @override
  String toString() => toJson().toString();
}
