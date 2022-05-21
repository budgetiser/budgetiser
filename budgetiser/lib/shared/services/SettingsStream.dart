import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsStreamClass {
  SettingsStreamClass._privateConstructor();

  static final SettingsStreamClass instance =
      SettingsStreamClass._privateConstructor();
  final StreamController<ThemeMode> _SettingsStreamController =
      StreamController<ThemeMode>.broadcast();

  Sink<ThemeMode> get _settingsStreamSink => _SettingsStreamController.sink;

  Stream<ThemeMode> get settingsStream => _SettingsStreamController.stream;

  void pushGetSettingsStream() async {
    final prefs = await SharedPreferences.getInstance();
    final String? currentModeString = prefs.getString('key-themeMode');

    ThemeMode _currentThemeMode = _stringToThemeMode(currentModeString);

    _settingsStreamSink.add(_currentThemeMode);
  }

  void setThemeModeFromString(String themeModeString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('key-themeMode', themeModeString);

    ThemeMode _currentThemeMode = _stringToThemeMode(themeModeString);

    _settingsStreamSink.add(_currentThemeMode);
  }

  ThemeMode _stringToThemeMode(themeModeString) {
    ThemeMode themeMode;
    switch (themeModeString) {
      case "system":
        themeMode = ThemeMode.system;
        break;
      case "light":
        themeMode = ThemeMode.light;
        break;
      case "dark":
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
        break;
    }
    return themeMode;
  }
}
