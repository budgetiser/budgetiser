import 'package:budgetiser/routes.dart';
import 'package:flutter/material.dart';

import 'config/themes/themes.dart';
import 'screens/homeScreen.dart';

void main() {
  // DateTime d = DateTime.now();
  // print(d);
  // print("date as string ${d.toString()}");
  // int s = d.toUtc().microsecondsSinceEpoch;
  // print("string is $s");

  // print(DateTime.fromMicrosecondsSinceEpoch(s));
  // print("from substring ${DateTime.parse(d.toString().substring(0, 10))}");

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
      home: const Home(),
      routes: routes,
    );
  }
}
