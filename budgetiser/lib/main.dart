import 'package:budgetiser/routes.dart';
import 'package:budgetiser/shared/services/SettingsStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'config/themes/themes.dart';
import 'screens/homeScreen.dart';

Future<void> main() async {
  SharePreferenceCache spCache = SharePreferenceCache();
  await spCache.init();
  await Settings.init(cacheProvider: spCache);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _currentThemeMode =
      Settings.getValue("key-themeMode", "system") == "system"
          ? ThemeMode.system
          : Settings.getValue("key-themeMode", "system") == "light"
              ? ThemeMode.light
              : ThemeMode.dark;

  @override
  void initState() {
    SettingsStreamClass.instance.settingsStream.listen((themeMode) {
      setState(() {
        _currentThemeMode = themeMode;
      });
    });
    SettingsStreamClass.instance.pushGetSettingsStream();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _currentThemeMode,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: const HomeScreen(),
      routes: routes,
    );
  }
}
