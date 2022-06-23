import 'package:nodemobile/product/enums/locale_manager_enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleManager {
  static final LocaleManager _instance = LocaleManager._init();
  SharedPreferences? _preferences;
  static LocaleManager get instance => _instance;

  LocaleManager._init();

  Future prefrencesInit() async {
    instance._preferences ??= await SharedPreferences.getInstance();
  }

  bool? getBool(LocaleManagerEnums key) => _preferences!.getBool(key.name);
  double? getDouble(LocaleManagerEnums key) =>
      _preferences!.getDouble(key.name);
  int? getInt(LocaleManagerEnums key) => _preferences!.getInt(key.name);
  String? getString(LocaleManagerEnums key) =>
      _preferences!.getString(key.name);
  List<String>? getStringList(String key) => _preferences!.getStringList(key);
  dynamic get(LocaleManagerEnums key) => _preferences!.get(key.name);

  Future<bool> setBool(LocaleManagerEnums key, bool value) async =>
      await _preferences!.setBool(key.name, value);
  Future<bool> setDouble(LocaleManagerEnums key, double value) async =>
      await _preferences!.setDouble(key.name, value);
  Future<bool> setInt(LocaleManagerEnums key, int value) async =>
      await _preferences!.setInt(key.name, value);
  Future<bool> setString(LocaleManagerEnums key, String value) async =>
      await _preferences!.setString(key.name, value);
  Future<bool> setStringList(
          LocaleManagerEnums key, List<String> value) async =>
      await _preferences!.setStringList(key.name, value);

  Future<bool> setDynamicString(
          LocaleManagerEnums key, String prefix, String value) async =>
      await _preferences!.setString("${key.name}$prefix", value);

  Future<String?> getDynamicString(
          LocaleManagerEnums key, String prefix) async =>
      _preferences!.getString("${key.name}$prefix");

  Future<bool> clear() async => await _preferences!.clear();
  Future<bool> remove(LocaleManagerEnums key) async =>
      await _preferences!.remove(key.name);

  bool containsKey(LocaleManagerEnums key) =>
      _preferences!.containsKey(key.name);
}
