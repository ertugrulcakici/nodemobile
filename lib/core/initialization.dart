import 'package:flutter/widgets.dart';

import 'services/cache/locale_manager.dart';
import 'services/database/database_service.dart';

Future initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocaleManager.instance.prefrencesInit();
  await DatabaseService.instance.initUserDb();
}

Future initData() async {}
