import 'dart:io';

import 'package:budgetiser/routes.dart';
import 'package:budgetiser/shared/services/settingsStream.dart';
import 'package:budgetiser/screens/createDBScreen.dart';
import 'package:budgetiser/screens/homeScreen.dart';
import 'package:budgetiser/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';

import 'config/themes/themes.dart';

Future<void> main() async {
  runApp(const MyApp());
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
      home: FutureBuilder(
        future: checkForStartScreen(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data) {
              case 0: //Codes: [0 - Database found, no encryption preference]
                return const HomeScreen();
              case 1: //Codes: [1 - Database found, encryption preference]
                return LoginScreen();
              case 2: //Codes: [2 - no database found]
                return const CreateDatabaseScreen();
              case -1: //Codes: [-1 - Error]
              default:
                break;
            }
          } else if (snapshot.hasError) {
            return const Text("Oops!");
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      routes: routes,
    );
  }

  Future<int> checkForStartScreen() async {
    //Codes: [0 - Database found, no encryption preference]
    //Codes: [1 - Database found, encryption preference]
    //Codes: [2 - no database found]
    //Codes: [-1 - Error]
    final prefs = await SharedPreferences.getInstance();
    var databasesPath = await getDatabasesPath();

    if (File(join(databasesPath, 'budgetiser.db')).existsSync()) {
      if (prefs.containsKey('encrypted')) {
        if (prefs.getBool('encrypted')!) {
          return 1;
        } else {
          return 0;
        }
      } else {
        return -1;
      }
    } else {
      return 2;
    }
  }
}
