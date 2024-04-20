import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/database/provider/budget_provider.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/core/routes.dart';
import 'package:budgetiser/home/screens/home_screen.dart';
import 'package:budgetiser/settings/services/settings_stream.dart';
import 'package:budgetiser/shared/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionModel()),
        ChangeNotifierProvider(create: (context) => CategoryModel()),
        ChangeNotifierProvider(create: (context) => AccountModel()),
        ChangeNotifierProvider(create: (context) => BudgetModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('de', 'DE'),
      ],
      themeMode: _currentThemeMode,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: const HomeScreen(),
      routes: routes,
    );
  }
}
