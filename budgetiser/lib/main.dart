import 'package:budgetiser/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'config/themes/themes.dart';
import 'screens/home.dart';

Future<void> main() async {
  SharePreferenceCache spCache = SharePreferenceCache();
  await spCache.init();
  await Settings.init(cacheProvider: spCache);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _getThemeMode(),
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: const Home(),
      routes: routes,
    );
  }

  ThemeMode _getThemeMode() {
    switch (Settings.getValue("key-themeMode", "system")) {
      case "system":
        return ThemeMode.system;
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
