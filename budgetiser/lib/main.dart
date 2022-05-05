import 'dart:io';

import 'package:budgetiser/routes.dart';
import 'package:budgetiser/screens/createDBScreen.dart';
import 'package:budgetiser/screens/homeScreen.dart';
import 'package:budgetiser/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';

import 'config/themes/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
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
                return CreateDatabaseScreen();
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
