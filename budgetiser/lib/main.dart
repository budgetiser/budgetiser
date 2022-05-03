import 'package:budgetiser/routes.dart';
import 'package:budgetiser/screens/login.dart';
import 'package:flutter/material.dart';

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
      home: LoginScreen(),
      routes: routes,
    );
  }
}
