part of my_database_helper;

class FisManager {
  static FisManager? _instance;
  static FisManager get _private => _instance ??= FisManager._();
  FisManager._();

  Future baslikOlustur() async {}
  Future<List<FisBasligiModel>> basliklariGetir(int type) async {
    try {
      final data = LocaleDatatable((await DatabaseService.instance.firmDb
          .rawQuery("SELECT * FROM TRN_StockTrans where type = $type")));
      if (data.isNotEmpty) {
        return data.rowsAsJson.map((e) => FisBasligiModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log("fiş başlıklarını getirirken hata oluştu: $e");
      return [];
    }
  }

  Future<LocaleDatatable?> isYerleriniGetir() async {
    try {
      return LocaleDatatable((await DatabaseService.instance.firmDb
          .rawQuery("select * from X_Branchs")));
    } catch (e) {
      log("isYerleriniGetir hatası: $e");
      return null;
    }
  }

  Future<LocaleDatatable?> depolariGetir() async {
    try {
      return LocaleDatatable((await DatabaseService.instance.firmDb
          .rawQuery("select * from CRD_StockWareHouse")));
    } catch (e) {
      log("depolariGetir hatası: $e");
      return null;
    }
  }

  Future<int> fisBasligiEkle(FisBasligiModel baslik) async {
    try {
      return await DatabaseService.instance.firmDb
          .insert(TableNames.TRN_StockTrans.name, baslik.toJson());
    } catch (e) {
      return -1;
    }
  }

  Future<LocaleDatatable?> getAllBranchs() async {
    try {
      return LocaleDatatable((await DatabaseService.instance.firmDb
          .rawQuery("select * from X_Branchs")));
    } catch (e) {
      log("getAllBranchs hatası: $e");
      return null;
    }
  }

  Future<LocaleDatatable?> getAllWareHouses() async {
    try {
      return LocaleDatatable((await DatabaseService.instance.firmDb
          .rawQuery("select * from CRD_StockWareHouse")));
    } catch (e) {
      log("getAllWareHouses hatası: $e");
      return null;
    }
  }

  Future<Map<String, int>?> baslikSil(int id) async {
    try {
      int removedTitle = await DatabaseService.instance.firmDb
          .rawDelete("DELETE FROM TRN_StockTrans WHERE id = $id");
      int removedLine = await DatabaseService.instance.firmDb.rawDelete(
          "delete from TRN_StockTransLines where StockTransID = $id");
      return {
        "removedTitle": removedTitle,
        "removedLine": removedLine,
      };
    } catch (e) {
      log("baslikSil hatası: $e");
      return null;
    }
  }

  Future<LocaleDatatable?> getProcutByBarcode(String barcode) async {
    try {
      return LocaleDatatable((await DatabaseService.instance.firmDb
          .rawQuery("select * from V_AllItems where Barcode = $barcode")));
    } catch (e) {
      log("getProcutByBarcode hatası: $e");
      return null;
    }
  }

  Future<LocaleDatatable?> getProcutById(int id) async {
    try {
      return LocaleDatatable((await DatabaseService.instance.firmDb
          .rawQuery("select * from V_AllItems where ID = $id")));
    } catch (e) {
      log("getProcutById hatası: $e");
      return null;
    }
  }

  Future<int> addTrnLine(FisSatiriModel satir) async {
    try {
      return await DatabaseService.instance.firmDb
          .insert(TableNames.TRN_StockTransLines.name, satir.toJson());
    } catch (e) {
      log("addTrnLine hatası: $e");
      return -1;
    }
  }

  Future sendToServer(
      FisBasligiModel baslik, List<FisSatiriModel> satirlar) async {
    try {
      if (!(await ConnectionHelper.databaseConnected())) {
        EasyLoading.show(status: "Sunucuya bağlı değil. Bağlanıyor...");
        if (await ConnectionHelper.connectDatabase()) {
          EasyLoading.dismiss();
          EasyLoading.show(status: "Bağlandı.");
        } else {
          EasyLoading.showToast("Sunucuya Bağlanamadı. Aktarım iptal edildi",
              duration: const Duration(seconds: 3), dismissOnTap: true);
          return;
        }
      }

      String baslikQuery = baslik.toInsertQuery();
      String satirlarQuery = satirlar.map((e) => e.toInsertQuery()).join("");

      try {
        String query = """
    SET XACT_ABORT ON;

        BEGIN TRANSACTION
          DECLARE @DataID int;
          $baslikQuery
          SELECT @DataID = scope_identity();
          $satirlarQuery
        COMMIT
        
        SET XACT_ABORT OFF;
    """;
        log(query);

        await RemoteDatabaseService.execute(query);

        await DatabaseService.instance.firmDb.rawDelete(
            "update TRN_StockTrans set GoldenSync = 1 where id = ${baslik.id}");
        await DatabaseService.instance.firmDb.rawDelete(
            "update TRN_StockTransLines set GoldenSync = 1 where StockTransID = ${baslik.id}");

        baslik.goldenSync = 1;
        for (var e in satirlar) {
          e.goldensync = 1;
        }
        EasyLoading.showToast(
            "1 Fiş\nve\n${satirlar.length} satır başarıyla aktarıldı !",
            duration: const Duration(seconds: 2),
            dismissOnTap: true);
      } catch (e) {
        EasyLoading.showToast("Sorgu yollanamadı: $e",
            dismissOnTap: true, duration: const Duration(seconds: 2));
      }

      // await DatabaseService.instance.firmDb
      //     .insert(TableNames.TRN_StockTrans, baslik.toJson());
      // await DatabaseService.instance.firmDb.execute(
      //     "delete from TRN_StockTransLines where StockTransID = ${baslik.id}");
    } catch (e) {
      log("sendToServer hatası: $e");
    }
  }

  Future<bool> updateTrnLine(FisSatiriModel satir) async {
    try {
      int changes = await DatabaseService.instance.firmDb.update(
          TableNames.TRN_StockTransLines.name,
          {"Amount": satir.amount, "Date": satir.date},
          where: "id = ${satir.id}");
      if (changes > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("updateTrnLine hatası: $e");
      return false;
    }
  }

  Future<bool> deleteTrnLine(int id) async {
    try {
      int changes = await DatabaseService.instance.firmDb
          .delete(TableNames.TRN_StockTransLines.name, where: "id = $id");
      if (changes > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("deleteTrnLine hatası: $e");
      return false;
    }
  }

  Future<bool> updateTrnHeader(FisBasligiModel baslik) async {
    try {
      int changes = await DatabaseService.instance.firmDb.update(
          TableNames.TRN_StockTrans.name, baslik.toJson(),
          where: "ID = ${baslik.id}");
      if (changes > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("updateTrnHeader hatası: $e");
      return false;
    }
  }

  Future<LocaleDatatable?> getLocaleFisTypes() async {
    try {
      return DatabaseService.instance.userDb
          .mySelectQuery(DatabaseConstants.select_FisListesi);
    } catch (e) {
      log("getLocaleFisTypes hatası: $e");
      return null;
    }
  }

  Future<bool> updateLocaleFisType(String fisName, int fisType) async {
    try {
      int result = await DatabaseService.instance.userDb.update(
          TableNames.FisListesi.name, {"FisName": fisName, "FisType": fisType},
          where: "FisType = $fisType");
      return result > 0;
    } catch (e) {
      log("updateLocaleFisType hatası: $e");
      return false;
    }
  }

  Future setStaticLocaleFisTypes() async {
    DatabaseConstants.fisTurleri.clear();
    LocaleDatatable? result = await DatabaseService.instance.userDb
        .mySelectQuery("select FisName, FisType from FisListesi");
    if (result != null) {
      for (var e in result.rowsAsJson) {
        DatabaseConstants.fisTurleri[e["FisName"]] = e["FisType"];
      }
    }
  }
}
