import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
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
    List<T> casted = [];
    for (int i = 0; i < list.length; i++) {
      casted.add(await _itemFromID(list[i]) as T);
    }

    return casted;
  }

  Future<void> addItem(String itemID) async {
    final preferences = await SharedPreferences.getInstance();
    final list = preferences.getStringList(key) ?? [];

    // Check if the item already exists in the list
    if (list.contains(itemID)) {
      list
        ..remove(itemID)
        ..insert(0, itemID);
    } else {
      // Add the new item to the beginning of the list
      list.insert(0, itemID);

      // Remove the oldest item if the list exceeds the maximum number of items
      if (list.length > listLength) {
        list.removeLast();
      }
    }

    await preferences.setStringList(key, list);
  }

  Future _itemFromID(String id) async {
    // TODO: support more Dataclasses
    if (T == Account) {
      return await DatabaseHelper.instance.getOneAccount(int.parse(id));
    }
  }
}
