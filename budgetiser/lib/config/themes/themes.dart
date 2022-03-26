import 'package:flutter/material.dart';

class MyThemes {
  static const Color LIGHT_PRIMARY = Color.fromARGB(255, 50, 130, 184);
  static const Color LIGHT_SECONDARY = Color.fromARGB(255, 187, 225, 250);
  static const Color LIGHT_TERTIARY = Color.fromARGB(255, 27, 38, 44);

  static final lightTheme = ThemeData(
    backgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: LIGHT_PRIMARY,
      secondary: LIGHT_SECONDARY,
      tertiary: LIGHT_TERTIARY,
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    textTheme: const TextTheme(
      caption: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      headline1: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      headline6: TextStyle(fontSize: 30),
      bodyText2: TextStyle(fontSize: 20),
      bodyText1: TextStyle(fontSize: 10),
      subtitle1: TextStyle(fontSize: 20), // for the drawer items
    ),
    primaryColor: const Color.fromRGBO(0, 0, 0, 1),
    dividerTheme: const DividerThemeData(
      thickness: 1.5,
      color: Color.fromARGB(59, 0, 0, 0),
    ),
    toggleableActiveColor: LIGHT_PRIMARY,
  );

  static const Color DARK_PRIMARY = Color.fromARGB(255, 50, 130, 184);
  static const Color DARK_SECONDARY = Color.fromARGB(255, 15, 76, 117);
  static const Color DARK_TERTIARY = Color.fromARGB(255, 187, 225, 250);
  static const Color DARK_BACKGROUND = Color.fromARGB(255, 27, 38, 44);

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: DARK_BACKGROUND,
    colorScheme: const ColorScheme.dark(
      primary: DARK_PRIMARY,
      secondary: DARK_SECONDARY,
      tertiary: DARK_TERTIARY,
    ),
    textTheme: const TextTheme(
      caption: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 25,
          fontWeight: FontWeight.bold),
      headline1: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 255, 255, 255)),
      headline2: TextStyle(fontSize: 30), // for headline inside a screen
      bodyText2: TextStyle(fontSize: 20), // normal text
      subtitle1: TextStyle(fontSize: 20), // for the drawer items
    ),
    primaryColor: Colors.black,
    dividerTheme: const DividerThemeData(
      thickness: 1.5,
      color: Color.fromARGB(50, 255, 255, 255),
    ),
    toggleableActiveColor: DARK_PRIMARY,
    appBarTheme: const AppBarTheme(
      color: DARK_BACKGROUND,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        // title text in appbar
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: DARK_PRIMARY,
    ),
  );
}
