import 'package:flutter/material.dart';
import 'package:nodemobile/product/constants/navigation_constants.dart';
import 'package:nodemobile/view/auth/login/view/login_view.dart';
import 'package:nodemobile/view/auth/setup/view/setup_view.dart';
import 'package:nodemobile/view/auth/splash/view/splash_view.dart';
import 'package:nodemobile/view/home/view/home_view.dart';
import 'package:nodemobile/view/modules/perakende/perakende_view.dart';
import 'package:nodemobile/view/modules/perakende/subpages/malzeme_fisleri_listesi/view/malzeme_fisleri_listesi.dart';
import 'package:nodemobile/view/settings/connection/view/connection_settings_view.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationRouter {
  static final NavigationRouter _instance = NavigationRouter._init();
  static NavigationRouter get instance => _instance;
  NavigationRouter._init();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  String initialRoute = NavigationConstants.splash;
  Map<String, Widget Function(BuildContext)> routes = {
    NavigationConstants.malzemeFisleriListesi: (context) =>
        MalzemeFisleriListesiView(),
    NavigationConstants.perakende: (context) => const PerakendeView(),
    NavigationConstants.home: (BuildContext context) => const HomeView(),
    NavigationConstants.connectionSettings: (BuildContext context) =>
        const ConnectionSettingsView(),
    NavigationConstants.splash: (BuildContext context) => const SplashView(),
    NavigationConstants.setup: (BuildContext context) => const SetupView(),
    NavigationConstants.login: (BuildContext context) => const LoginView(),
  };

//   List<MaterialPageRoute> _navigate(Widget page) =>
//       [MaterialPageRoute(builder: (context) => page)];
}
