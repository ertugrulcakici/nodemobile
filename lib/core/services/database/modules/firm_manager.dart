part of my_database_helper;

class FirmManager {
  static FirmManager? _instance;
  static FirmManager get _private => _instance ??= FirmManager._();
  FirmManager._();

  Future<FirmModel?> getFirm(int id) async {
    try {
      List<FirmModel> firms = await getFirms();
      for (var firm in firms) {
        if (firm.id == id) {
          return firm;
        }
      }
    } catch (e) {
      log("Firma id sine göre firma getirilemedi. Id: $id Hata: $e");
    }
    return null;
  }

  Future<FirmModel?> getDefaultFirm() async {
    try {
      List<FirmModel> firms = await getFirms();
      for (var firm in firms) {
        if (firm.isDefault) {
          return firm;
        }
      }
    } catch (e) {
      log("Default firma getirilemedi. Hata: $e");
    }
    return null;
  }

  Future<List<FirmModel>> getFirms() async {
    List<FirmModel> firms = [];
    final result =
        await DatabaseService.instance.userDb.rawQuery("select * from X_Firms");
    for (var item in result) {
      firms.add(FirmModel.fromJson(item));
    }
    return firms;
  }

  Future<Map<String, dynamic>?> getDefaultFirmUser(FirmModel model) async {
    LocaleDatatable? result = await DatabaseService.instance.userDb.mySelectQuery(
        "select defaultUsername, defaultPassword from X_Firms where FirmNr = ${model.id}");
    if (result != null) {
      return result.rowsAsJson.first;
    } else {
      return null;
    }
  }

  Future<int> editFirm(FirmModel model) async =>
      await DatabaseService.instance.userDb.rawUpdate(
          "update X_Firms set Name = ?, Server = ?, User = ?, Pass = ?, Database = ? where FirmNr = ?",
          [
            model.name,
            model.serverIp,
            model.username,
            model.password,
            model.database,
            model.id
          ]);

  /// firmayı siler ve geriye silinen firma sayısını döndürür
  Future<int> deleteFirm(FirmModel model) async =>
      await DatabaseService.instance.userDb
          .rawDelete("delete from X_Firms where FirmNr = ${model.id}");

  Future<void> addFirm(FirmModel model) async {
    log("model bilgisi: ${model.toString()}");
    DatabaseService.instance.userDb.execute(
        "INSERT INTO X_Firms (Name,Server,User,Pass,Database) VALUES ('${model.name}', '${model.serverIp}', '${model.username}', '${model.password}', '${model.database}')");
  }

  Future<int> getLastFirmId() async => (await DatabaseService.instance.userDb
          .rawQuery("select max(FirmNr) from X_Firms"))
      .first['max(FirmNr)'] as int;
}
