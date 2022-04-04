import 'package:budgetiser/routes.dart';
import 'package:budgetiser/shared/services/notification/themeChangedNotification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'config/themes/themes.dart';
import 'screens/home.dart';

Future<void> main() async {
  SharePreferenceCache spCache = SharePreferenceCache();
  await spCache.init();
  await Settings.init(cacheProvider: spCache);
  print(Settings.getValue("key-themeMode", "123"));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _themeModeString = Settings.getValue("key-themeMode", "system");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _getThemeModeFromString(_themeModeString),
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: NotificationListener<ThemeChangedNotification>(
        child: const Home(),
        onNotification: (n) {
          print("got");
          setState(() {
            _themeModeString = n.themeMode.toString();
          });
          return true;
        },
      ),
      routes: routes,
    );
  }

  ThemeMode _getThemeModeFromString(String themMode) {
    switch (Settings.getValue("key-themeMode", "system")) {
      case "system":
        print("system");
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
