import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsStreamClass {
  SettingsStreamClass._privateConstructor();

  static final SettingsStreamClass instance =
      SettingsStreamClass._privateConstructor();
  final StreamController<ThemeMode> _settingsStreamController =
      StreamController<ThemeMode>.broadcast();

  Sink<ThemeMode> get _settingsStreamSink => _settingsStreamController.sink;

  Stream<ThemeMode> get settingsStream => _settingsStreamController.stream;

  void dispose() {
    _settingsStreamController.close();
  }

  void pushGetSettingsStream() async {
    final preferences = await SharedPreferences.getInstance();
    final String? currentModeString = preferences.getString('key-themeMode');

    ThemeMode currentThemeMode = _stringToThemeMode(currentModeString);

    _settingsStreamSink.add(currentThemeMode);
  }

  void setThemeModeFromString(String themeModeString) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('key-themeMode', themeModeString);

    ThemeMode currentThemeMode = _stringToThemeMode(themeModeString);

    _settingsStreamSink.add(currentThemeMode);
  }

  ThemeMode _stringToThemeMode(String? themeModeString) {
    ThemeMode themeMode;
    switch (themeModeString) {
      case 'system':
        themeMode = ThemeMode.system;
        break;
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
        break;
    }
    return themeMode;
  }
}
