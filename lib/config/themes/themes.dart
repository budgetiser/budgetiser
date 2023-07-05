import 'package:flutter/material.dart';

class MyThemes {
  static const Color LIGHT_PRIMARY = Color.fromARGB(255, 50, 130, 184);
  static const Color LIGHT_SECONDARY = Color.fromARGB(255, 187, 225, 250);
  static const Color LIGHT_TERTIARY = Color.fromARGB(255, 27, 38, 44);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      displayLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(fontSize: 30), // for headline inside a screen
      bodyMedium: TextStyle(fontSize: 20), // normal text
      titleMedium: TextStyle(fontSize: 20), // for the drawer items
    ),
    primaryColor: const Color.fromRGBO(0, 0, 0, 1),
    dividerTheme: const DividerThemeData(
      thickness: 1.5,
      color: Color.fromARGB(59, 0, 0, 0),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return LIGHT_PRIMARY;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return LIGHT_PRIMARY;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return LIGHT_PRIMARY;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return LIGHT_PRIMARY;
        }
        return null;
      }),
    ),
    colorScheme: const ColorScheme.light(
      primary: LIGHT_PRIMARY,
      secondary: LIGHT_SECONDARY,
      tertiary: LIGHT_TERTIARY,
    ).copyWith(background: Colors.white),
  );

  static const Color DARK_PRIMARY = Color.fromARGB(255, 50, 130, 184);
  static const Color DARK_CLICKABLE = Color.fromARGB(255, 50, 130, 184);
  static const Color DARK_SECONDARY = Color.fromARGB(255, 15, 76, 117);
  static const Color DARK_TERTIARY = Color.fromARGB(255, 255, 255, 255);
  static const Color DARK_BACKGROUND = Color.fromARGB(255, 27, 38, 44);
  static const Color DARK_GRAY_TEXT = Color.fromARGB(255, 153, 153, 153);

  static final darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: DARK_BACKGROUND,
    colorScheme: const ColorScheme.dark(
      primary: DARK_PRIMARY,
      secondary: DARK_SECONDARY,
      tertiary: DARK_TERTIARY,
    ),

    // hintColor used in input fields and clickable icons
    hintColor: DARK_CLICKABLE,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: DARK_CLICKABLE,
      ),
      color: DARK_BACKGROUND,
      centerTitle: true,
      titleTextStyle: TextStyle(
        // title text in appbar
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: DARK_BACKGROUND,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      errorStyle: TextStyle(fontSize: 18),
      labelStyle: TextStyle(color: DARK_GRAY_TEXT),
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
          color: DARK_TERTIARY, fontSize: 25, fontWeight: FontWeight.bold),
      displayLarge: TextStyle(
          // for the drawer "budgetiser" title
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: DARK_TERTIARY),
      displayMedium: TextStyle(fontSize: 30), // for headline inside a screen
      bodyMedium: TextStyle(fontSize: 20), // normal text
      titleMedium: TextStyle(fontSize: 20), // for the drawer items
      bodyLarge: TextStyle(fontSize: 20, color: Colors.grey), // ??
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1.5,
      color: Color.fromARGB(50, 255, 255, 255),
    ),
  );
}
