import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'services/cache/locale_manager.dart';
import 'services/database/database_service.dart';

Future initApp() async {
  EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;

  WidgetsFlutterBinding.ensureInitialized();

  await LocaleManager.instance.prefrencesInit();
  await DatabaseService.instance.initUserDb();
}

Future initData() async {}
