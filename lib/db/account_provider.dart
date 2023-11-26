import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/db/recently_used.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/utils/data_types_utils.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class AccountModel extends ChangeNotifier {
  final recentlyUsedAccount = RecentlyUsed<Account>();

  Future<List<Account>> getAllAccounts() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('account');

    List<Account> accounts = List.generate(maps.length, (i) {
      return Account(
        id: maps[i]['id'],
        name: maps[i]['name'].toString(),
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(maps[i]['color']),
        balance: maps[i]['balance'],
        description: maps[i]['description'],
      );
    });
    return accounts;
  }

  Future<int> createAccount(Account account) async {
    final db = await DatabaseHelper.instance.database;
    int id = await db.insert(
      'account',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

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

  /// TODO: null checks
  Future<Account> getOneAccount(int id) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'account',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      throw ErrorDescription('account id:$id not found');
    }

    return Account(
      id: maps[0]['id'],
      name: maps[0]['name'],
      icon: IconData(maps[0]['icon'], fontFamily: 'MaterialIcons'),
      color: Color(maps[0]['color']),
      balance: maps[0]['balance'],
      description: maps[0]['description'],
    );
  }
}