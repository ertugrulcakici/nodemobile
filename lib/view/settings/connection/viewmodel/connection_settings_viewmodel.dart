import 'package:flutter/material.dart';

import '../../../../core/services/cache/locale_manager.dart';
import '../../../../product/enums/locale_manager_enums.dart';

class ConnectionSettingsViewModel extends ChangeNotifier {
  ConnectionSettingsViewModel() {
    _getIpAndPort();
  }

  String _ip = "";
  String _port = "";

  String get ip => _ip;
  String get port => _port;

  void setIp(String ip) {
    _ip = ip;
    notifyListeners();
  }

  void setPort(String port) {
    _port = port;
    notifyListeners();
  }

  Future<bool> _setIpAndPort(String ip, String port) async {
    if ((await LocaleManager.instance
        .setString(LocaleManagerEnums.serverIp.name, ip))) {
      return true;
    } else {
      return false;
    }
  }

  _getIpAndPort() {
    setIp(LocaleManager.instance.getString(LocaleManagerEnums.serverIp.name) ??
        "");
  }

  Future<bool> save() async => await _setIpAndPort(ip, port);
}
