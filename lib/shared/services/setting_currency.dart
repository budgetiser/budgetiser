import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsCurrencyHandler {
  String defaultCurrency = '€';
  // TODO: perfomance improvement with caching

  Future<String> getCurrency() async {
    final preferences = await SharedPreferences.getInstance();
    String currency = preferences.getString('key-currency') ?? defaultCurrency;
    return currency;
  }

  Future<void> setCurrency(String currency) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('key-currency', currency);
  }
}
