import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/initialization.dart';
import 'core/services/navigation/navigation_route.dart';

void main(List<String> args) async {
  await initApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 800),
      builder: (context, widget) {
        return ProviderScope(
          child: MaterialApp(
            builder: EasyLoading.init(),
            theme: ThemeData.light().copyWith(
                appBarTheme: AppBarTheme.of(context).copyWith(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    iconTheme: const IconThemeData(color: Colors.black),
                    titleTextStyle:
                        TextStyle(color: Colors.black, fontSize: 25.sp),
                    shadowColor: Colors.transparent)),
            debugShowCheckedModeBanner: false,
            initialRoute: NavigationRouter.instance.initialRoute,
            navigatorKey: NavigationRouter.instance.navigatorKey,
            routes: NavigationRouter.instance.routes,
          ),
        );
      },
    );
  }
}
