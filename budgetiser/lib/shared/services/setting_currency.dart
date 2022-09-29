import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsCurrencyHandler {
  String defaultCurrency = '€';

  Future<String> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    String currency = prefs.getString('key-currency') ?? defaultCurrency;
    return currency;
  }

  Future<void> setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('key-currency', currency);
  }
}
