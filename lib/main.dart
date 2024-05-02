import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/database/provider/budget_provider.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/core/routes.dart';
import 'package:budgetiser/home/screens/home_screen.dart';
import 'package:budgetiser/settings/services/settings_stream.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budgetiser',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        // TODO ellipsis listTile title without changing color
        // listTileTheme: ListTileTheme.of(context).copyWith(
        //     titleTextStyle: Theme.of(context)
        //         .textTheme
        //         .titleMedium
        //         ?.copyWith(overflow: TextOverflow.ellipsis)),
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
      routes: routes,
    );
  }
}
