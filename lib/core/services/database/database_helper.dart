library my_database_helper;

import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nodemobile/core/services/database/database_service.dart';
import 'package:nodemobile/core/services/database/i_database_helper.dart';
import 'package:nodemobile/product/constants/query_constants.dart';
import 'package:nodemobile/core/utils/connection_helper.dart';
import 'package:nodemobile/product/models/fis_baslik_model.dart';
import 'package:nodemobile/product/models/fis_satir_model.dart';
import 'package:nodemobile/view/auth/login/model/firm_model.dart';
import 'package:sql_conn/sql_conn.dart';

part "modules/firm_manager.dart";
part 'modules/fis_manager.dart';

class DatabaseHelper implements IDatabaseHelper {
  FirmManager get firmManager => FirmManager._private;
  FisManager get fisManager => FisManager._private;

  static final DatabaseHelper _instance = DatabaseHelper._();
  static DatabaseHelper get instance => _instance;
  DatabaseHelper._();
}

class RemoteDatabaseHelper {
  static Future<bool> connect() async {
    FirmModel? firm =
        await DatabaseHelper.instance.firmManager.getDefaultFirm();
    log(firm!.toString());
    log("default firm: ${firm.id}");
    log("firm server url: ${firm.serverIp}");
    log("firm server user: ${firm.username}");
    log("firm server password: ${firm.password}");
    log("firm server db: ${firm.database}");

    try {
      await SqlConn.connect(
          ip: firm.serverIp,
          port: "1433",
          databaseName: firm.database,
          username: firm.username,
          password: firm.password,
          timeout: 5);
      return true;
    } catch (e) {
      log("Remote sql bağlantı hatası: $e");
      return false;
    }
  }

  static Future<dynamic> execute(String query, {List<dynamic>? args}) async {
    if (args != null) {
      for (var element in args) {
        query = query.replaceFirst("?", element.toString());
      }
    }
    return SqlConn.writeData(query);
  }

  static Future<RemoteDatatable?> read(
      String query, List<Map<String, dynamic>> types,
      {List<dynamic>? args}) async {
    // editing query
    if (args != null) {
      for (var element in args) {
        query = query.replaceFirst("?", element.toString());
      }
    } // end of editing query
    if (!SqlConn.isConnected) {
      await RemoteDatabaseHelper.connect();
    }
    if (SqlConn.isConnected) {
      try {
        RemoteDatatable table =
            RemoteDatatable(await SqlConn.readData(query), types);
        log("başarılı sorgu yapıldı. Satır sayısı: ${table.rowCount} \nSorgu: $query");
        return table;
      } catch (e) {
        log("hata oluştu: $e");
        return null;
      }
    } else {
      return null;
    }
  }
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

  Map<String, dynamic> rowByIndexAsJson(int index) => _data[index];
  Map<String, dynamic> rowByKeyValueAsJson(String key, dynamic value) =>
      _data.firstWhere((element) => element[key] == value);

  dynamic columnValueByIndex(int index, String columnName) =>
      _data[index][columnName];

  @override
  String toString() => _data.toString();

  debugPrint() {
    for (var element in _data) {
      log(element.toString());
    }
    log("Satır sayısı: $rowCount");
    log("Sütun sayısı: $columnCount");
  }
}

class RemoteDatatable {
  final List<Map<String, dynamic>> dataTypes;

  List<List<dynamic>> onlyRows = [];

  static const _rowSeperator = r"&$";
  static const _columnSeperator = r"#%";

  int get rowCount => onlyRows.length;
  int get columnCount => dataTypes.length;

  List<String> get columnNames {
    int i = 0;
    return List.generate(columnCount, (index) {
      Map<String, dynamic> columnData =
          dataTypes.where((element) => element["order"] == i).first;
      i++;
      return columnData["column"];
    });
  }

  List<DataTypes> get columnTypes {
    int i = 0;
    return List.generate(columnCount, (index) {
      Map<String, dynamic> columnData =
          dataTypes.where((element) => element["order"] == i).first;
      i++;
      return columnData["type"];
    });
  }

  Map<String, dynamic> rowInJson(int rowIndex) {
    Map<String, dynamic> row = {};
    int i = 0;
    for (var column in columnNames) {
      row[column] = onlyRows[rowIndex][i];
      i++;
    }
    return row;
  }

  List<Map<String, dynamic>> rowsInJson() {
    List<Map<String, dynamic>> rows = [];
    for (var row in onlyRows) {
      rows.add(rowInJson(onlyRows.indexOf(row)));
    }
    return rows;
  }

  RemoteDatatable(String rawString, this.dataTypes) {
    if (rawString.isEmpty) {
      return;
    }
    onlyRows = rawString.split(_rowSeperator).map((row) {
      int columnIndex = 0;
      return row.split(_columnSeperator).map((column) {
        Map<String, dynamic> columnData =
            dataTypes.where((element) => element["order"] == columnIndex).first;
        columnIndex++;
        if (column == "null") {
          return null;
        }
        DataTypes columnType = columnData["type"];
        switch (columnType) {
          case DataTypes.INT:
            return int.parse(column.replaceAll(".0", ""));
          case DataTypes.TEXT:
            return column;
          case DataTypes.REAL:
            return double.parse(column);
          case DataTypes.BOOL:
            return int.parse(column.replaceAll(".0", "")) == 1;
          default:
            return column;
        }
      }).toList();
    }).toList();
  }

  RemoteDatatable.fromLocale(data, this.dataTypes);

  // Datatable(dynamic data, this.dataTypes) {
  //   if (data is String) {
  //     // find the text between { and }
  //     Iterable<Match> matches = RegExp(r"{(.*?)}").allMatches(data);
  //     for (var row in matches) {
  //       Map<String, dynamic> innerRow = {};
  //       String beforeSplit = row.group(1) as String;
  //       try {
  //         final splitted = beforeSplit.split(', "').map((e) => '$e"');
  //         for (var parts in splitted) {
  //           List<String> keyValue = parts
  //               .split(":")
  //               .map((e) => e.trim().replaceAll('"', ''))
  //               .toList();
  //           if (keyValue[1] == "null") {
  //             innerRow[keyValue[0]] = null;
  //           } else {
  //             switch (dataTypes[keyValue[0]]) {
  //               case DataTypes.INT:
  //                 innerRow[keyValue[0]] = int.parse(keyValue[1]);
  //                 break;
  //               case DataTypes.TEXT:
  //                 innerRow[keyValue[0]] = keyValue[1];
  //                 break;
  //               case DataTypes.REAL:
  //                 innerRow[keyValue[0]] = double.parse(keyValue[1]);
  //                 break;
  //               case DataTypes.BOOL:
  //                 innerRow[keyValue[0]] =
  //                     (keyValue[1] == "0" || keyValue[1] == "false")
  //                         ? false
  //                         : true;
  //                 break;
  //               default:
  //             }
  //           }
  //         }
  //       } catch (e) {
  //         log("satırda hata var : $e");
  //         log("satır: $beforeSplit");
  //       }
  //       _data.add(innerRow);
  //     }
  //   } else {
  //     _data = data;
  //   }
  // }

  void debugPrint() {
    // if (_data.isEmpty) {
    //   log("Datatable is empty");
    // } else {
    //   for (var element in _data) {
    //     log(element.toString());
    //   }
    //   log("Row count: ${_data.length}");
    //   log("Column count: ${_data[0].length}");
    // }
  }

  void orderBy(field, {descending = false}) {
    // if (descending) {
    //   _data.sort((a, b) => b[field].compareTo(a[field]));
    // } else {
    //   _data.sort((a, b) => a[field].compareTo(b[field]));
    // }
  }

  void excludeFields(List<String> fields) {
    // for (var element in _data) {
    //   for (var field in fields) {
    //     element.remove(field);
    //   }
    // }
  }

  // getByValue(String field, dynamic value) =>
  //     _data.firstWhere((element) => element[field] == value);
  // getIndexByValue(String field, dynamic value) =>
  //     _data.indexWhere((element) => element[field] == value);

  // Datatable copy() => Datatable(_data, dataTypes);
}
