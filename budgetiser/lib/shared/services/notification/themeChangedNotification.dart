import 'package:flutter/material.dart';

class ThemeChangedNotification extends Notification {
  final String themeMode;
  ThemeChangedNotification(this.themeMode);
}
