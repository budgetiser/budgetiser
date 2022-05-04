import 'dart:io';

import 'package:budgetiser/routes.dart';
import 'package:budgetiser/screens/createDBScreen.dart';
import 'package:budgetiser/screens/login.dart';
import 'package:flutter/material.dart';
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
        future: checkForDatabaseExists(),
        builder: (BuildContext context, snapshot) {
          if(snapshot.hasData){
            if(snapshot.data == true){
              return LoginScreen();
            }else {
              return CreateDatabaseScreen();
            }
          }
          return Container();
        },
      ),
      routes: routes,
    );
  }

  Future<bool> checkForDatabaseExists() async {
    var databasesPath = await getDatabasesPath();
    return File(join(databasesPath, 'budgetiser.db')).existsSync();
  }
}
