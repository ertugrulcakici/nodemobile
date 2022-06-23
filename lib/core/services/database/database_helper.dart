library my_database_helper;

import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nodemobile/core/services/cache/locale_helper.dart';
import 'package:nodemobile/core/services/database/database_service.dart';
import 'package:nodemobile/core/services/database/remote_database_service.dart';
import 'package:nodemobile/core/utils/connection_helper.dart';
import 'package:nodemobile/core/utils/extentions/map_extention.dart';
import 'package:nodemobile/product/constants/database_constants.dart';
import 'package:nodemobile/product/models/fis_baslik_model.dart';
import 'package:nodemobile/product/models/fis_satir_model.dart';
import 'package:nodemobile/product/models/varyant_model.dart';
import 'package:nodemobile/view/auth/login/model/firm_model.dart';

part "modules/firm_manager.dart";
part 'modules/fis_manager.dart';
part 'modules/stok_manager.dart';

class DatabaseHelper {
  FirmManager get firmManager => FirmManager._private;
  FisManager get fisManager => FisManager._private;
  StokManager get stokManager => StokManager._private;

  static final DatabaseHelper _instance = DatabaseHelper._();
  static DatabaseHelper get instance => _instance;
  DatabaseHelper._();
}

class LocaleDatatable {
  final List<Map<String, dynamic>> _data;
  LocaleDatatable(this._data);

  List<Map<String, dynamic>> get rowsAsJson => _data;

  bool get isEmpty => _data.isEmpty;
  bool get isNotEmpty => _data.isNotEmpty;

  List<String> get columns => isNotEmpty ? _data.first.keys.toList() : [];
  int get columnCount => columns.length;

  int get rowCount => _data.length;

  List<List<dynamic>> rowsAsList() =>
      _data.map((e) => e.values.toList()).toList();

  List<dynamic> rowByIndexAsList(int index) => _data[index].values.toList();
  List<dynamic> rowByKeyValueAsList(String key, dynamic value) =>
      _data.firstWhere((e) => e[key] == value).values.toList();

  Map<String, dynamic> rowByIncludeData(Map<String, dynamic> data) {
    return _data.firstWhere((e) => e.containsValues(data));
  }

  Map<String, dynamic> rowByIndexAsJson(int index) => _data[index];
  Map<String, dynamic> rowByKeyValueAsJson(String key, dynamic value) =>
      _data.firstWhere((element) => element[key] == value);

  dynamic columnValueByIndex(int index, String columnName) =>
      _data[index][columnName];

  @override
  String toString() => _data.toString();

  // debugPrint() {
  //   for (var element in _data) {
  //     log(element.toString());
  //   }
  //   log("Satır sayısı: $rowCount");
  //   log("Sütun sayısı: $columnCount");
  // }
}
