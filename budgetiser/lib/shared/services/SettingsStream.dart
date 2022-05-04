import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsStreamClass {
  SettingsStreamClass._privateConstructor();

  static final SettingsStreamClass instance =
      SettingsStreamClass._privateConstructor();
  final StreamController<ThemeMode> _SettingsStreamController =
      StreamController<ThemeMode>.broadcast();

  Sink<ThemeMode> get settingsStreamSink => _SettingsStreamController.sink;

  Stream<ThemeMode> get settingsStream => _SettingsStreamController.stream;

  void pushGetSettingsStream() {
    ThemeMode _currentThemeMode =
        Settings.getValue("key-themeMode", "system") == "system"
            ? ThemeMode.system
            : Settings.getValue("key-themeMode", "system") == "light"
                ? ThemeMode.light
                : ThemeMode.dark;

    settingsStreamSink.add(_currentThemeMode);
  }
}
