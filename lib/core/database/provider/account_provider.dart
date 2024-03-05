import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/shared/services/profiler.dart';
import 'package:budgetiser/shared/services/recently_used.dart';
import 'package:budgetiser/shared/utils/data_types_utils.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class AccountModel extends ChangeNotifier {
  final recentlyUsedAccount = RecentlyUsed<Account>();
  DateTime lastTimeFetchedAllAccounts = DateTime(0);
  List<Account> cachedAllAccounts = [];

  Future<List<Account>> getAllAccounts() async {
    debugPrint(
        'since last cache ${DateTime.now().difference(lastTimeFetchedAllAccounts).inMilliseconds}');
    if (DateTime.now().difference(lastTimeFetchedAllAccounts) <
        const Duration(milliseconds: 200)) {
      return cachedAllAccounts;
    }
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('account');

    List<Account> accounts = List.generate(maps.length, (i) {
      return Account.fromDBmap(maps[i]);
    });
    lastTimeFetchedAllAccounts = DateTime.now();
    cachedAllAccounts = accounts;
    return accounts;
  }

  /// adds account to database
  ///
  /// if [id] is not null the id will be used
  Future<int> createAccount(
    Account account, {
    bool keepId = false,
  }) async {
    final db = await DatabaseHelper.instance.database;
    Map<String, dynamic> map = account.toMap();
    int id = account.id;
    if (!keepId) {
      id = await db.insert(
        'account',
        map,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } else {
      await db.execute('''
        INSERT INTO account (id, name, icon, color, balance, description, archived) 
        VALUES (?, ?, ?, ?, ?, ?, ?);
      ''', [
        id,
        map['name'],
        map['icon'],
        map['color'],
        map['balance'],
        map['description'],
        map['archived'],
      ]);
    }

    notifyListeners();
    return id;
  }

  Future<void> deleteAccount(int accountID) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      'account',
      where: 'id = ?',
      whereArgs: [accountID],
    );
    notifyListeners();
    recentlyUsedAccount.removeItem(accountID.toString());
  }

  Future<void> updateAccount(Account account) async {
    final db = await DatabaseHelper.instance.database;

    await db.update(
      'account',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
    notifyListeners();
  }

  Future<void> setAccountBalance(int accountID, double newBalance) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'account',
      {'balance': roundDouble(newBalance)},
      where: 'id = ?',
      whereArgs: [accountID],
    );
  }

  Future<Account> getOneAccount(int id) async {
    Profiler.instance.start('getOneAccount id: $id');
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'account',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      throw ErrorDescription('account id:$id not found');
    }
    Profiler.instance.end();
    return Account.fromDBmap(maps[0]);
  }
}
