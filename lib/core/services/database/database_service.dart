import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nodemobile/core/services/cache/locale_helper.dart';
import 'package:nodemobile/core/services/database/remote_database_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../product/constants/database_constants.dart';
import '../../../view/auth/login/model/firm_model.dart';
import 'database_helper.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  static DatabaseService get instance => _instance;
  DatabaseService._();

  late Database _userDb;
  late Database _firmDb;
  Database get firmDb => _firmDb;
  Database get userDb => _userDb;

  final String userDbName = 'user.db';

  static Future<String> get _baseDbPath async =>
      '${(await getExternalStorageDirectory())!.path}/databases';
  Future get _userDbPath async => '${(await _baseDbPath)}/$userDbName';
  Future get _firmDbPath async {
    FirmModel? defaultFirm =
        await DatabaseHelper.instance.firmManager.getDefaultFirm();
    return '${(await _baseDbPath)}/${defaultFirm!.id}.db';
  }

  Future<void> initUserDb() async {
    _userDb = await openDatabase(await _userDbPath, version: 1,
        onCreate: (Database db, version) async {
      log("init user db çalıştı");
      for (String query in DatabaseConstants.create_LocaleTables) {
        await db.execute(query);
      }
    });
  }

  /// eğer id gelirse o firma için db oluşturur. Gelmezse sadece açılıyor
  Future<void> initFirmDatabase([int? id]) async {
    // log("Database bağlantısı: ${id == null ? "id null geldi" : "id dolu geldi"}");
    _firmDb = await openDatabase(
        id == null ? await _firmDbPath : "${await _baseDbPath}/$id.db",
        version: 1, onCreate: (Database db, version) async {
      EasyLoading.show(status: "Veritabanı oluşturuluyor...");
      await db.execute(DatabaseConstants.create_X_Users);
      await db.execute(DatabaseConstants.create_X_Branchs);
      await db.execute(DatabaseConstants.create_CRD_Cari);
      await db.execute(DatabaseConstants.create_CRD_StockWareHouse);
      await db.execute(DatabaseConstants.create_L_Units);
      await db.execute(DatabaseConstants.create_V_AllItems);
      await db.execute(DatabaseConstants.create_TRN_StockTrans);
      await db.execute(DatabaseConstants.create_TRN_StockTransLines);

      EasyLoading.show(status: "Tablolar verileri alınıyor 1/6");
      RemoteDatatable? dataXUsers =
          await RemoteDatabaseService.read(DatabaseConstants.select_X_Users);
      EasyLoading.show(status: "Tablo verileri yazılıyor 1/6");
      if (dataXUsers != null) {
        for (var element in dataXUsers.rowsInList) {
          await db.execute(
              "insert into X_Users (${dataXUsers.columnNames.join(',')}) values (${List.generate(element.length, (index) => '?').join(',')})",
              element);
        }
        log("X_Users inserted");
      } else {
        throw Exception("X_Users verileri alınamadı");
      }
      EasyLoading.show(status: "Tablolar verileri alınıyor 2/6");
      RemoteDatatable? dataXBranchs =
          await RemoteDatabaseService.read(DatabaseConstants.select_X_Branchs);

      EasyLoading.show(status: "Tablo verileri yazılıyor 2/6");
      if (dataXBranchs != null) {
        for (var element in dataXBranchs.rowsInList) {
          await db.execute(
              "insert into X_Branchs (${dataXBranchs.columnNames.join(',')}) values (${List.generate(element.length, (index) => '?').join(',')})",
              element);
        }
        log("X_Branchs inserted");
      } else {
        throw Exception("X_Branchs verileri alınamadı");
      }

      EasyLoading.show(status: "Tablolar verileri alınıyor 3/6");
      RemoteDatatable? dataCari =
          await RemoteDatabaseService.read(DatabaseConstants.select_CRD_Cari);

      EasyLoading.show(status: "Tablo verileri yazılıyor 3/6");
      if (dataCari != null) {
        for (var element in dataCari.rowsInList) {
          await db.execute(
              "insert into CRD_Cari (${dataCari.columnNames.join(',')}) values (${List.generate(element.length, (index) => '?').join(',')})",
              element);
        }
        log("CRD_Cari inserted");
      } else {
        throw Exception("CRD_Cari verileri alınamadı");
      }

      EasyLoading.show(status: "Tablolar verileri alınıyor 4/6");
      RemoteDatatable? dataStockWareHouse = await RemoteDatabaseService.read(
          DatabaseConstants.select_CRD_StockWareHouse);

      EasyLoading.show(status: "Tablo verileri yazılıyor 4/6");
      if (dataStockWareHouse != null) {
        for (var element in dataStockWareHouse.rowsInList) {
          await db.execute(
              "insert into CRD_StockWareHouse (${dataStockWareHouse.columnNames.join(',')}) values (${List.generate(element.length, (index) => '?').join(',')})",
              element);
        }
        log("CRD_StockWareHouse inserted");
      } else {
        throw Exception("CRD_StockWareHouse verileri alınamadı");
      }

      EasyLoading.show(status: "Tablolar verileri alınıyor 5/6");
      RemoteDatatable? dataUnits =
          await RemoteDatabaseService.read(DatabaseConstants.select_L_Units);

      EasyLoading.show(status: "Tablo verileri yazılıyor 5/6");
      if (dataUnits != null) {
        for (var element in dataUnits.rowsInList) {
          await db.execute(
              "insert into L_Units (${dataUnits.columnNames.join(',')}) values (${List.generate(element.length, (index) => '?').join(',')})",
              element);
        }
        log("L_Units inserted");
      } else {
        throw Exception("L_Units verileri alınamadı");
      }
      EasyLoading.show(status: "Tablolar verileri alınıyor 6/6");

      RemoteDatatable? dataAllItems =
          await RemoteDatabaseService.read(DatabaseConstants.select_V_AllItems);

      EasyLoading.show(status: "Tablo verileri yazılıyor 6/6");
      if (dataAllItems != null) {
        for (var element in dataAllItems.rowsInList) {
          db.rawInsert(
              "insert into V_AllItems (${dataAllItems.columnNames.join(',')}) values (${List.generate(element.length, (index) => '?').join(',')})",
              element);
        }
        LocaleHelper.instance.setLastStockUpdateTime(id);
        log("V_AllItems inserted");
      } else {
        throw Exception("V_AllItems verileri alınamadı");
      }

      EasyLoading.dismiss();
      EasyLoading.showToast("Veritabanı oluşturuldu",
          duration: const Duration(seconds: 2));
    });
  }
}

extension DatabaseExtention on Database {
  Future<LocaleDatatable?> mySelectQuery(String sql,
      [List<Object?>? arguments]) async {
    try {
      return LocaleDatatable(await rawQuery(sql, arguments));
    } catch (e) {
      log("mySelectQuery error: $e");
      return null;
    }
  }
}
