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
      log(SqlConn.isConnected.toString());
      final news = await RemoteDatabaseService.read(
          "select * from V_AllItems where CreatedDate > '$lastTime' or ModifiedDate > '$lastTime'");
      final deleted = await RemoteDatabaseService.read(
          "SELECT RecordID FROM TRN_Logs where LogDate >'$lastTime' and LogTitle = 'Silindi' and ModuleTable = 'StokKarti';");
      if (news == null || deleted == null) {
        EasyLoading.dismiss();
        EasyLoading.showError("Stok listesi güncellenemedi. Veriler boş geldi");
        return;
      }
      if (news.rowCount > 0) {
        for (var element in news.rowsInJson()) {
          VaryantModel model = VaryantModel.fromJson(element);
          int changed = await _updateStock(model: model);
          log("changed: $changed");
          if (changed == -1) {
            int added = await _insertStock(model: model);
            log("added: $added");
            if (added == -1) {
              EasyLoading.showError(
                  "Stok listesi değiştirilemedi (ekleme / değiştirme).");
              return;
            }
          }
        }
      }

      if (deleted.rowCount > 0) {
        for (var element in deleted.rowsInJson()) {
          int deleted = await _deleteStock(id: element["RecordID"]);
          log("deleted: $deleted");
          if (deleted == -1) {
            EasyLoading.showError("Stok listesi değiştirilemedi (silme).");
            return;
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
      return -1;
    }
  }

  Future<int> _insertStock({required VaryantModel model}) async {
    try {
      return DatabaseService.instance.firmDb
          .insert(TableNames.V_AllItems.name, model.toJson());
    } catch (e) {
      return -1;
    }
  }

  Future<int> _deleteStock({required int id}) async {
    try {
      return await DatabaseService.instance.firmDb
          .delete("V_AllItems", where: "ID = ?", whereArgs: [id]);
    } catch (e) {
      return -1;
    }
  }
}
