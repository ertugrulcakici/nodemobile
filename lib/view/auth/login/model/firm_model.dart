import '../../../../core/services/cache/locale_manager.dart';
import '../../../../product/enums/locale_manager_enums.dart';

class FirmModel {
  int? id;
  String name;
  String serverIp;
  String username;
  String password;
  String database;

  bool get isDefault =>
      id ==
      LocaleManager.instance.getInt(LocaleManagerEnums.defaultFirmId.name);

  FirmModel({
    this.id,
    required this.name,
    required this.serverIp,
    required this.username,
    required this.password,
    required this.database,
  });

  factory FirmModel.fromJson(Map<String, dynamic> json) {
    return FirmModel(
      id: json.containsKey('FirmNr') ? json['FirmNr'] : null,
      name: json['Name'] as String,
      serverIp: json['Server'] as String,
      username: json['User'] as String,
      password: json['Pass'] as String,
      database: json['Database'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'Name': name,
      'Server': serverIp,
      'User': username,
      'Pass': password,
      'Database': database,
    };
    if (id != null) {
      data['FirmNr'] = id;
    }
    return data;
  }

  FirmModel.empty()
      : name = "",
        serverIp = "",
        username = "",
        password = "",
        database = "";

  @override
  String toString() =>
      'FirmModel(id: $id, name: $name, serverIp: $serverIp, username: $username, password: $password, database: $database)';

  FirmModel.copy(FirmModel other)
      : id = other.id,
        name = other.name,
        serverIp = other.serverIp,
        username = other.username,
        password = other.password,
        database = other.database;

  @override
  // ignore: hash_and_equals
  operator ==(Object other) =>
      identical(this, other) ||
      other is FirmModel && runtimeType == other.runtimeType && id == other.id;
}
