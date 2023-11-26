import 'package:budgetiser/db/account_provider.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// TODO: account: also add second account if 2 account transaction
/// TODO: make singleton and manage list inside class to not always fetch new from storage (needs analysis)
class RecentlyUsed<T> {
  late SharedPreferences preferences;
  final int listLength = 3;
  final key = 'recently_used_$T';

  Future init() async {
    preferences = await SharedPreferences.getInstance();
    if (T.toString() == 'dynamic') {
      throw ErrorDescription('use a non generic type');
    }
  }

  Future<List<T>> getList() async {
    await init();
    final list = preferences.getStringList(key) ?? [];
    List<T> casted = [];
    for (int i = 0; i < list.length; i++) {
      casted.add(await _itemFromID(list[i]) as T);
    }
    return casted;
  }

  Future<T?> getLastUsed() async {
    await init();
    final list = preferences.getStringList(key) ?? [];

    return list.isNotEmpty ? await _itemFromID(list[0]) : null;
  }

  Future<void> addItem(String itemID) async {
    await init();
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

  Future removeItem(String itemID) async {
    await init();
    var list = preferences.getStringList(key) ?? []
      ..remove(itemID);
    await preferences.setStringList(key, list);
  }

  Future removeAllItems() async {
    await init();
    await preferences.remove(key);
  }

  Future _itemFromID(String id) async {
    // TODO: support more Dataclasses
    if (T == Account) {
      return await AccountModel().getOneAccount(int.parse(id));
    }
  }
}
