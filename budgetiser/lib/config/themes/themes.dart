import 'package:flutter/material.dart';

class MyThemes {
  static final lightTheme = ThemeData(
    backgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 187, 225, 250),
      secondary: Color.fromARGB(255, 50, 130, 184),
      tertiary: Color.fromARGB(255, 27, 38, 44),
    ),
    scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
    textTheme: const TextTheme(
      caption: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 30),
      bodyText2: TextStyle(fontSize: 20),
      bodyText1: TextStyle(fontSize: 10),
    ),
  );
//   static final lightTheme = ThemeData(
//     colorScheme: const ColorScheme.dark(
//       primary: Color.fromARGB(255, 187, 225, 250),
//       secondary: Color.fromARGB(255, 50, 130, 184),
//       tertiary: Color.fromARGB(255, 27, 38, 44),
//     ),
//     primaryColor: Colors.black,
//     primaryTextTheme: const TextTheme(
//       headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//       headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//       bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
//       bodyText1: TextStyle(fontSize: 10),
//     ),
//     // brightness: Brightness.light,

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Color.fromARGB(255, 27, 38, 44),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 15, 76, 117),
      secondary: Color.fromARGB(255, 50, 130, 184),
      tertiary: Color.fromARGB(255, 187, 225, 250),
    ),
  );
}


// primarySwatch: Colors.brown,
