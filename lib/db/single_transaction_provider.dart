import 'dart:developer';

import 'package:budgetiser/db/account_provider.dart';
import 'package:budgetiser/db/category_provider.dart';
import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/db/recently_used.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/services/profiler.dart';
import 'package:budgetiser/shared/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class TransactionModel extends ChangeNotifier {
  final recentlyUsedAccount = RecentlyUsed<Account>();

  void notifyTransactionUpdate() {
    notifyListeners();
  }

  Future<List<SingleTransaction>> getAllTransactions() async {
    Profiler.instance.start('getAllTransactions');
    var db = await DatabaseHelper.instance.database;
    Profiler.instance.start('sql fetching');
    final List<Map<String, dynamic>> mapSingle = await db.rawQuery(
      '''Select distinct * from singleTransaction, singleTransactionToAccount
      where singleTransaction.id = singleTransactionToAccount.transaction_id''',
    );
    Profiler.instance.end();
    List<SingleTransaction> list = [];
    for (int i = 0; i < mapSingle.length; i++) {
      list.add(
        await _mapToSingleTransactionLEGACY(mapSingle[i]),
      );
    }

    Profiler.instance.start('date sorting');
    list.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    Profiler.instance.end();

    Profiler.instance.end();
    return list;
  }

  Future<SingleTransaction> _mapToSingleTransactionLEGACY(
    Map<String, dynamic> mapItem,
  ) async {
    Profiler.instance.start('map to single transactionLEGACY');
    TransactionCategory cat =
        await CategoryModel().getCategory(mapItem['category_id']);
    Account account =
        await AccountModel().getOneAccount(mapItem['account1_id']);
    SingleTransaction s = SingleTransaction(
      id: mapItem['id'],
      title: mapItem['title'].toString(),
      value: mapItem['value'],
      description: mapItem['description'].toString(),
      category: cat,
      account: account,
      account2: mapItem['account2_id'] == null
          ? null
          : await AccountModel().getOneAccount(mapItem['account2_id']),
      date: DateTime.parse(mapItem['date'].toString()),
    );
    Profiler.instance.end();
    return s;
  }

  Future<SingleTransaction> _mapToSingleTransaction(
    Map<String, dynamic> mapItem,
  ) async {
    if (mapItem['account2_id'] != null) {
      return _mapToSingleTransactionLEGACY(mapItem);
    }
    Profiler.instance.start('map to single transaction');
    SingleTransaction returnTransaction = SingleTransaction(
      id: mapItem['id'],
      title: mapItem['title'].toString(),
      value: mapItem['value'],
      description: mapItem['description'].toString(),
      category: TransactionCategory(
        id: mapItem['category_id'],
        name: mapItem['category_name'],
        color: Color(mapItem['category_color']),
        icon: IconData(mapItem['category_icon'], fontFamily: 'MaterialIcons'),
      ),
      account: Account(
        name: mapItem['account_name'],
        icon: IconData(mapItem['account_icon'], fontFamily: 'MaterialIcons'),
        color: Color(mapItem['account_color']),
        id: mapItem['account_id'],
        balance: mapItem['account_balance'],
        // todo no description
      ),
      // account2: mapItem['account2_id'] == null
      //     ? null
      //     : await getOneAccount(mapItem['account2_id']),
      date: DateTime.parse(mapItem['date'].toString()),
    );
    Profiler.instance.end();
    return returnTransaction;
  }

  Future<int> createSingleTransaction(
    SingleTransaction transaction, {
    bool notify = true,
  }) async {
    final db = await DatabaseHelper.instance.database;
    int transactionId = 0; //TODO: fix
    await db.transaction((txn) async {
      transactionId = await txn.insert(
        'singleTransaction',
        transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );

      if (transaction.account2 != null) {
        await txn.rawUpdate(
            'UPDATE account SET balance = balance - ? WHERE id = ?',
            [transaction.value, transaction.account.id]);
        await txn.rawUpdate(
            'UPDATE account SET balance = balance + ? WHERE id = ?',
            [transaction.value, transaction.account2!.id]);
      } else {
        await txn.rawUpdate(
            'UPDATE account SET balance = balance + ? WHERE id = ?',
            [transaction.value, transaction.account.id]);
      }

      await txn.insert('singleTransactionToAccount', {
        'transaction_id': transactionId,
        'account1_id': transaction.account.id,
        'account2_id':
            transaction.account2 != null ? transaction.account2!.id : null,
      });
    });

    if (notify) {
      // getAllTransactions(); TODO: notifier
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      notifyTransactionUpdate();
      // TODO: account notify
    }

    recentlyUsedAccount.addItem(transaction.account.id.toString());

    return transactionId;
  }

  Future<void> deleteSingleTransaction(SingleTransaction transaction) async {
    final db = await DatabaseHelper.instance.database;
    if (transaction.account2 == null) {
      await AccountModel().setAccountBalance(
        transaction.account.id,
        transaction.account.balance - transaction.value,
      );
    } else {
      await AccountModel().setAccountBalance(
        transaction.account.id,
        transaction.account.balance + transaction.value,
      );
      await AccountModel().setAccountBalance(
        transaction.account2!.id,
        transaction.account2!.balance - transaction.value,
      );
    }

    await db.delete(
      'singleTransaction',
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
    await db.delete(
      'singleTransactionToAccount',
      where: 'transaction_id = ?',
      whereArgs: [transaction.id],
    );

    // pushGetAllAccountsStream();
    // pushGetAllTransactionsStream();
    // TODO:
    notifyTransactionUpdate();
  }

  Future<void> deleteSingleTransactionById(int id) async {
    await deleteSingleTransaction(await getOneTransaction(id));
  }

  Future<void> updateSingleTransaction(SingleTransaction transaction) async {
    await deleteSingleTransactionById(transaction.id);
    await createSingleTransaction(transaction, notify: false);

    // pushGetAllTransactionsStream();
  }

  Future<SingleTransaction> getOneTransaction(int id) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapSingle = await db.rawQuery(
      '''Select distinct * from SingleTransaction, singleTransactionToAccount
      where SingleTransaction.id = singleTransactionToAccount.transaction_id 
      and SingleTransaction.id = ?''',
      [id],
    );

    if (mapSingle.length == 1) {
      return await _mapToSingleTransactionLEGACY(mapSingle[0]);
    }
    throw Exception('Error in getOneTransaction');
  }

  /// returns all months containing a transaction as the first of the month
  Future<List<DateTime>> getAllMonths() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> dateList = await db.rawQuery(
      'Select distinct date from SingleTransaction',
    );

    Set<DateTime> distinctMonths = {};
    for (var item in dateList) {
      DateTime dateTime = DateTime.parse(item['date']);
      distinctMonths.add(firstOfMonth(dateTime));
    }

    List<DateTime> sorted = distinctMonths.toList()
      ..sort(
        (a, b) => b.compareTo(a), // reverse sort
      );
    return sorted;
  }

  Future<List<SingleTransaction>> getFilteredTransactionsByMonth({
    required DateTime inMonth,
    Account? account,
    TransactionCategory? category,
  }) async {
    var timelineTask = TimelineTask(filterKey: 'getFilterByMonth')
      ..start('get filter by month ${dateAsYYYYMM(inMonth)}');
    final db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> mapSingle = await db.rawQuery(
      '''Select distinct *, category.icon as category_icon, category.color as category_color, category.id as category_id, category.name as category_name,
      account.icon as account_icon, account.color as account_color, account.id as account_id, account.name as account_name, account.balance as account_balance,
      singleTransaction.description as description, singleTransaction.id as id
      from singleTransaction, singleTransactionToAccount, category, account
      where account.id = singleTransactionToAccount.account1_id 
      and singleTransactionToAccount.transaction_id = singleTransaction.id
      and category.id = singleTransaction.category_id
      and date LIKE ?
      ${account != null ? "and (singleTransactionToAccount.account1_id = ${account.id} or singleTransactionToAccount.account2_id = ${account.id})" : ""}
      ${category != null ? "and singleTransaction.category_id = ${category.id}" : ""}
      ''',
      ['${dateAsYYYYMM(inMonth)}%'],
    );
    List<SingleTransaction> transactions = [];
    for (int i = 0; i < mapSingle.length; i++) {
      transactions.add(await _mapToSingleTransaction(mapSingle[i]));
    }

    transactions.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    timelineTask.finish();
    return transactions;
  }
}
