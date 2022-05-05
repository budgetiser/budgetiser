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

    ThemeMode _currentThemeMode = currentModeString == "system"
        ? ThemeMode.system
        : currentModeString == "light"
            ? ThemeMode.light
            : ThemeMode.dark;

    _settingsStreamSink.add(_currentThemeMode);
  }

  void setThemeModeFromString(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('key-themeMode', themeMode);

    ThemeMode _currentThemeMode = themeMode == "system"
        ? ThemeMode.system
        : themeMode == "light"
            ? ThemeMode.light
            : ThemeMode.dark;
    _settingsStreamSink.add(_currentThemeMode);
  }
}
