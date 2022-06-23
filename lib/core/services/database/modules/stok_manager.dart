part of my_database_helper;

class StokManager {
  static StokManager? _instance;
  static StokManager get _private => _instance ??= StokManager._();
  StokManager._();

  Future<LocaleDatatable> getNonVariants() async =>
      (await DatabaseService.instance.firmDb
          .mySelectQuery("select * from V_AllItems where VaryantID = 0"))!;

  Future<void> updateStocks() async {
    await ConnectionHelper.tryConnect(onDone: () async {
      String lastTime = await LocaleHelper.instance.getLastStockUpdateTime();
      EasyLoading.show(status: "Stok listesi güncelleniyor");
      final news = await RemoteDatabaseService.read(
          "select * from V_AllItems where CreatedDate > '$lastTime' or ModifiedDate > '$lastTime'",
          DatabaseConstants.types_V_AllItems);
      final deleted = await RemoteDatabaseService.read(
          "SELECT RecordID FROM TRN_Logs where LogDate >'$lastTime' and LogTitle = 'Silindi' and ModuleTable = 'StokKarti';",
          [
            {"column": "RecordID", "type": DataTypes.INT, "order": 0}
          ]);
      if (news == null || deleted == null) {
        EasyLoading.dismiss();
        EasyLoading.showError("Stok listesi güncellenemedi.");
        return;
      }
      if (news.rowCount > 0) {
        for (var element in news.rowsInJson()) {
          VaryantModel model = VaryantModel.fromJson(element);
          int changed = await _updateStock(model: model);
          log("changed: $changed");
          if (changed == 0) {
            int added = await _insertStock(model: model);
            log("added: $added");
            if (added == 0) {
              EasyLoading.showError("Stok listesi güncellenemedi.");
              return;
            }
          }
        }
      }
      EasyLoading.dismiss();
      EasyLoading.showToast("Stoklar güncel");
      await LocaleHelper.instance.setLastStockUpdateTime();
      log("news count: ${news.rowCount}");
      log("deleted count: ${deleted.rowCount}");
    });
  }

  Future<int> _updateStock({required VaryantModel model}) async {
    try {
      return DatabaseService.instance.firmDb.update(
          TableNames.V_AllItems.name, model.toJson(),
          where: "ID = ?", whereArgs: [model.id]);
    } catch (e) {
      return 0;
    }
  }

  Future<int> _insertStock({required VaryantModel model}) async {
    try {
      return DatabaseService.instance.firmDb
          .insert(TableNames.V_AllItems.name, model.toJson());
    } catch (e) {
      return 0;
    }
  }
}
