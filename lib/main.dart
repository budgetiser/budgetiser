import 'package:budgetiser/config/themes/themes.dart';
import 'package:budgetiser/db/account_provider.dart';
import 'package:budgetiser/db/category_provider.dart';
import 'package:budgetiser/db/group_provider.dart';
import 'package:budgetiser/db/single_transaction_provider.dart';
import 'package:budgetiser/routes.dart';
import 'package:budgetiser/screens/home_screen.dart';
import 'package:budgetiser/shared/services/settings_stream.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionModel()),
        ChangeNotifierProvider(create: (context) => CategoryModel()),
        ChangeNotifierProvider(create: (context) => GroupModel()),
        ChangeNotifierProvider(create: (context) => AccountModel())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode? _currentThemeMode;

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
