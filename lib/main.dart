import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/globals.dart';

import 'core/routes/router.dart';
import 'core/values/string_manager.dart';
import 'core/values/theme_manager.dart';

void main() async {
  await Globals.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  const MyApp._internal();

  static const MyApp instance = MyApp._internal();

  factory MyApp() => instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: StringManager.appTitle,
            routeInformationParser: MyAppRouter.router.routeInformationParser,
            routerDelegate: MyAppRouter.router.routerDelegate,
            routeInformationProvider:
                MyAppRouter.router.routeInformationProvider,
            theme: ThemeManager.getLightTheme(),
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}
