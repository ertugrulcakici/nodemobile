import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sql_conn/sql_conn.dart';

import '../../product/enums/locale_manager_enums.dart';
import '../../view/auth/login/model/firm_model.dart';
import '../services/cache/locale_manager.dart';
import '../services/database/database_helper.dart';

class ConnectionHelper {
  static Future<bool> networkConnected() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> databaseConnected() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        return SqlConn.isConnected;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> connectDatabase() async {
    if (await networkConnected()) {
      int? firmId =
          LocaleManager.instance.getInt(LocaleManagerEnums.defaultFirmId.name);
      if (firmId == null) {
        log("Firma id si seçilmemiş");
        return false;
      }
      FirmModel? model =
          await DatabaseHelper.instance.firmManager.getDefaultFirm();
      if (model == null) {
        log("Firma seçilmemiş");
        return false;
      }
      try {
        await SqlConn.connect(
            ip: model.serverIp,
            port: "1433",
            databaseName: model.database,
            username: model.username,
            password: model.password,
            timeout: 5);
        return true;
      } catch (e) {
        log("bağlantı hatası oluştu: $e");
        return false;
      }
    } else {
      return false;
    }
  }
}
