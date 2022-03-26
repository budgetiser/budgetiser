import 'package:flutter/material.dart';

class MyThemes {
  static final lightTheme = ThemeData(
    backgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 50, 130, 184),
      secondary: Color.fromARGB(255, 187, 225, 250),
      tertiary: Color.fromARGB(255, 27, 38, 44),
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    textTheme: const TextTheme(
      caption: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 30),
      bodyText2: TextStyle(fontSize: 20),
      bodyText1: TextStyle(fontSize: 10),
    ),
    primaryColor: const Color.fromRGBO(0, 0, 0, 1),
    dividerColor: const Color.fromARGB(59, 0, 0, 0),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 27, 38, 44),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 50, 130, 184),
      secondary: Color.fromARGB(255, 15, 76, 117),
      tertiary: Color.fromARGB(255, 187, 225, 250),
    ),
    textTheme: const TextTheme(
      caption: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 25,
          fontWeight: FontWeight.bold),
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 30),
      bodyText2: TextStyle(fontSize: 20),
      bodyText1: TextStyle(fontSize: 10),
    ),
    primaryColor: Colors.black,
    dividerColor: const Color.fromARGB(62, 255, 255, 255),
    toggleableActiveColor: const Color.fromARGB(255, 50, 130, 184),
  );
}
