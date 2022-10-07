import 'package:flutter/material.dart';
import 'package:nodemobile/product/constants/navigation_constants.dart';
import 'package:nodemobile/view/auth/login/view/login_view.dart';
import 'package:nodemobile/view/auth/splash/view/splash_view.dart';
import 'package:nodemobile/view/home/view/home_view.dart';
import 'package:nodemobile/view/modules/e_ticaret/e_ticaret.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/malzeme_fisleri_view.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/sevkiyat_fisleri_listesi/view/sevkiyat_fisleri_listesi_view.dart';
import 'package:nodemobile/view/modules/stoklar/view/stok_listesi_view.dart';
import 'package:nodemobile/view/settings/view/settings_view.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationRouter {
  static final NavigationRouter _instance = NavigationRouter._init();
  static NavigationRouter get instance => _instance;
  NavigationRouter._init();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  String initialRoute = NavigationConstants.splash;
  Map<String, Widget Function(BuildContext)> routes = {
    NavigationConstants.sevkiyatFisleriListesi: (context) =>
        const SevkiyatFisleriListesiView(),
    NavigationConstants.malzemeFisleri: (context) => const MalzemeFisleriView(),
    NavigationConstants.stoklar: (context) => const StokListesiView(),
    NavigationConstants.eTicaret: (context) => const ETicaretView(),
    NavigationConstants.home: (BuildContext context) => const HomeView(),
    NavigationConstants.splash: (BuildContext context) => const SplashView(),
    NavigationConstants.login: (BuildContext context) => const LoginView(),
    NavigationConstants.settings: (BuildContext context) =>
        const SettingsView(),
  };

//   List<MaterialPageRoute> _navigate(Widget page) =>
//       [MaterialPageRoute(builder: (context) => page)];
}
