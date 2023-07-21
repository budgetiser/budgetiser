import 'package:budgetiser/db/database.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentlyUsed<T> {
  SharedPreferences? preferences;
  List<String>? items;
  final int listLength = 3;
  final key = 'recently_used_$T';

  Future<void> load() async {
    preferences = await SharedPreferences.getInstance();
    if (T.toString() == 'dynamic') {
      throw ErrorDescription('use a non generic type');
    } else {
      items = preferences!.getStringList(key);
    }
  }

  // constructor
  RecentlyUsed() {
    load();
  }

  Future<List<T>> getList() async {
    final preferences = await SharedPreferences.getInstance();
    final list = preferences.getStringList(key) ?? [];
    List<T> casted = list
        .map((String str) async =>
            await DatabaseHelper.instance.getOneAccount(int.parse(str)))
        .cast<T>()
        .toList();

    return casted;
  }

  Future<void> addItem(String item) async {
    final preferences = await SharedPreferences.getInstance();
    final list = preferences.getStringList(key) ?? []
      // Add the new item to the beginning of the list
      ..insert(0, item);

    // Remove the oldest item if the list exceeds the maximum number of items
    if (list.length > listLength) {
      list.removeLast();
    }

    await preferences.setStringList(key, list);
  }
}
