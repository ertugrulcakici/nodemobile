import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nodemobile/core/services/database/database_helper.dart';
import 'package:nodemobile/product/constants/database_constants.dart';
import 'package:nodemobile/view/auth/login/model/firm_model.dart';
import 'package:sql_conn/sql_conn.dart';

class RemoteDatabaseService {
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
          timeout: 3);
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

  /// type name seperator :
  /// type column seperator |
  /// type seperator |$&|%#|
  /// data seperator #%
  /// row seperator &$
  /// herhangi bir hata oluşursa null, boş bile dönerse [RemoteDatatable] nesnesi döner
  ///
  /// [query] sql sorgusu\n
  /// [args] sql sorgusunda kullanılacak değerler\n
  static Future<RemoteDatatable?> read(String query,
      {List<dynamic>? args}) async {
    // editing query
    if (args != null) {
      for (var element in args) {
        query = query.replaceFirst("?", element.toString());
      }
    } // end of editing query
    if (!SqlConn.isConnected) {
      await RemoteDatabaseService.connect();
    }
    if (SqlConn.isConnected) {
      try {
        RemoteDatatable table = RemoteDatatable(await SqlConn.readData(query));
        log("başarılı sorgu yapıldı. Satır sayısı: ${table.rowCount} \nSorgu: $query");
        return table;
      } catch (e) {
        EasyLoading.showError("Sunucuya bağlanamadı. Hata mesajı: \n$e");
        log("hata oluştu: $e");
        return null;
      }
    } else {
      return null;
    }
  }
}

class RemoteDatatable {
  List<List<dynamic>> rowsInList = [];

  static const _rowSeperator = r"&$";
  static const _columnSeperator = r"#%";
  static const _typeSeperator = r"|$&|%#|";
  static const _typeColumnSeperator = "|";
  static const _typeColumnNameSeperator = ":";

  int get rowCount => rowsInList.length;
  int get columnCount => columnTypes.length;

  List<String> columnNames = [];
  List<DataTypes> columnTypes = [];

  Map<String, dynamic> rowAsJson(int rowIndex) {
    Map<String, dynamic> row = {};
    int i = 0;
    for (var column in columnNames) {
      row[column] = rowsInList[rowIndex][i];
      i++;
    }
    return row;
  }

  List<Map<String, dynamic>> rowsAsJson() {
    List<Map<String, dynamic>> rows = [];
    for (var row in rowsInList) {
      rows.add(rowAsJson(rowsInList.indexOf(row)));
    }
    return rows;
  }

  RemoteDatatable(String rawString) {
    if (rawString.isEmpty) {
      return;
    }

    String colData = rawString.split(_typeSeperator)[0];
    colData.split(_typeColumnSeperator).forEach((element) {
      List<String> nameAndType = element.split(_typeColumnNameSeperator);
      columnNames.add(nameAndType[0]);
      if (nameAndType[1].contains("int")) {
        columnTypes.add(DataTypes.INT);
      } else if (nameAndType[1].contains("double") ||
          nameAndType[1].contains("float") ||
          nameAndType[1].contains("real")) {
        columnTypes.add(DataTypes.REAL);
      } else if (nameAndType[1].contains("char") ||
          nameAndType[1].contains("time") ||
          nameAndType[1].contains("date")) {
        columnTypes.add(DataTypes.TEXT);
      } else if (nameAndType[1].contains("bool")) {
        columnTypes.add(DataTypes.BOOL);
      } else {
        columnTypes.add(DataTypes.TEXT);
      }
    });

    String rowData = rawString.split(_typeSeperator)[1];
    rowsInList = rowData.split(_rowSeperator).map((row) {
      int columnIndex = 0;
      return row.split(_columnSeperator).map((column) {
        columnIndex++;
        if (column == "null") {
          return null;
        }
        DataTypes columnType = columnTypes[columnIndex - 1];
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
    if (rowsAsJson().isEmpty) {
      log("Datatable is empty");
    } else {
      for (var element in rowsAsJson()) {
        log(element.toString());
      }
      log("Row count: ${rowsAsJson().length}");
      log("Column count: ${rowsAsJson()[0].length}");
    }
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

  @override
  String toString() => "$rowCount row, $columnCount column";
}
