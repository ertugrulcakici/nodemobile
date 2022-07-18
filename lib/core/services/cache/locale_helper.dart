import 'package:nodemobile/core/services/cache/locale_manager.dart';
import 'package:nodemobile/core/services/database/database_helper.dart';
import 'package:nodemobile/core/utils/extentions/datetime_extention.dart';
import 'package:nodemobile/product/enums/locale_manager_enums.dart';

class LocaleHelper {
  static final LocaleHelper _instance = LocaleHelper._();
  static LocaleHelper get instance => _instance;
  LocaleHelper._();

  Future setLastStockUpdateTime([int? id]) async {
    String innerId = id != null
        ? id.toString()
        : (await DatabaseHelper.instance.firmManager.getDefaultFirm())!
            .id
            .toString();
    LocaleManager.instance.setDynamicString(
        LocaleManagerEnums.lastStockUpdateTime, innerId, DateTime.now().DT);
  }

  Future<String> getLastStockUpdateTime() async {
    String innerId =
        (await DatabaseHelper.instance.firmManager.getDefaultFirm())!
            .id
            .toString();
    return (await LocaleManager.instance
        .getDynamicString(LocaleManagerEnums.lastStockUpdateTime, innerId))!;
  }
}
