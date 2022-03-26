import 'package:budgetiser/routes.dart';
import 'package:budgetiser/shared/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'config/themes/themes.dart';
import 'screens/account/account.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: const Home(),
      routes: routes,
    );
  }
}
