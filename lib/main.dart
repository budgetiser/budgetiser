import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/database/provider/budget_provider.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/core/routes.dart';
import 'package:budgetiser/home/screens/home_screen.dart';
import 'package:budgetiser/settings/services/settings_stream.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

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

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    SettingsStreamClass.instance.settingsStream.listen(changeAppTheme);
    SettingsStreamClass.instance.pushGetSettingsStream();

    super.initState();
  }

  /// e.g.: MyApp.of(context).changeTheme(ThemeMode.dark);
  void changeAppTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  static final _defaultLightColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
  );

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          title: 'Budgetiser',
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [
            Locale('de', 'DE'),
          ],
          themeMode: _themeMode,
          theme: ThemeData(
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
            listTileTheme: customListTileTheme(),
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
            listTileTheme: customListTileTheme(),
          ),
          home: const HomeScreen(),
          routes: routes,
        );
      },
    );
  }

  ListTileThemeData customListTileTheme() {
    return ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
