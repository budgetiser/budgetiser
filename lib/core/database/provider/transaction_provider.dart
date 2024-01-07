import 'dart:developer';

import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/core/database/recently_used.dart';
import 'package:budgetiser/shared/services/profiler.dart';
import 'package:budgetiser/shared/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class TransactionModel extends ChangeNotifier {
  final recentlyUsedAccount = RecentlyUsed<Account>();
  final recentlyUsedCategory = RecentlyUsed<TransactionCategory>();

  void notifyTransactionUpdate() {
    notifyListeners();
  }

  Future<List<SingleTransaction>> getAllTransactions() async {
    Profiler.instance.start('getAllTransactions');
    var db = await DatabaseHelper.instance.database;
    Profiler.instance.start('sql fetching');
    final List<Map<String, dynamic>> mapSingle = await db.query(
      'singleTransaction',
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

    SingleTransaction s = SingleTransaction(
      id: mapItem['id'],
      title: mapItem['title'].toString(),
      value: mapItem['value'],
      description: mapItem['description'].toString(),
      category: cat,
      account: await AccountModel().getOneAccount(mapItem['account1_id']),
      account2: mapItem['account2_id'] == null
          ? null
          : await AccountModel().getOneAccount(mapItem['account2_id']),
      date: DateTime.fromMillisecondsSinceEpoch(mapItem['date']),
    );
    Profiler.instance.end();
    return s;
  }

  Future<SingleTransaction> _mapToSingleTransaction(
    Map<String, dynamic> mapItem,
    List<Account> fullAccountList,
  ) async {
    Profiler.instance.start('map to single transaction');
    Profiler.instance.start('get accounts from list');
    Account account1 = fullAccountList.firstWhere(
        (element) => element.id == mapItem['account1_id']); // TODO if not found
    Account? account2 = mapItem['account2_id'] == null
        ? null
        : fullAccountList.firstWhere((element) =>
            element.id == mapItem['account2_id']); // TODO if not found
    Profiler.instance.end();
    SingleTransaction returnTransaction = SingleTransaction(
      id: mapItem['id'],
      title: mapItem['title'].toString(),
      value: mapItem['value'],
      description: mapItem['description'],
      category: TransactionCategory(
        id: mapItem['category_id'],
        name: mapItem['category_name'],
        color: Color(mapItem['category_color']),
        icon: IconData(mapItem['category_icon'], fontFamily: 'MaterialIcons'),
      ),
      account: account1,
      account2: account2,
      date: DateTime.fromMillisecondsSinceEpoch(mapItem['date']),
    );
    Profiler.instance.end();
    return returnTransaction;
  }

  Future<int> createSingleTransaction(
    SingleTransaction transaction, {
    bool notify = true,
  }) async {
    final db = await DatabaseHelper.instance.database;
    int transactionId = 0;
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
    });

    if (notify) {
      notifyTransactionUpdate();
    }

    recentlyUsedAccount.addItem(transaction.account.id.toString());
    recentlyUsedCategory.addItem(transaction.category.id.toString());

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

    notifyTransactionUpdate();
  }

  Future<void> deleteSingleTransactionById(int id) async {
    await deleteSingleTransaction(await getOneTransaction(id));
  }

  Future<void> updateSingleTransaction(SingleTransaction transaction) async {
    await deleteSingleTransactionById(transaction.id);
    await createSingleTransaction(transaction, notify: false);
  }

  Future<SingleTransaction> getOneTransaction(int id) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapSingle = await db.query(
      'singleTransaction',
      where: 'singleTransaction.id = ?',
      whereArgs: [id],
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
      """ SELECT DISTINCT STRFTIME('%Y%m', DATETIME(ROUND(date/1000), 'unixepoch'), 'start of month') AS month, COUNT(id)
          FROM singleTransaction
          GROUP BY month
          ORDER BY month DESC;
      """,
    );
    Set<DateTime> distinctMonths = {};
    for (var item in dateList) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(item['date']);
      distinctMonths.add(firstOfMonth(dateTime));
    }

    List<DateTime> sorted = distinctMonths.toList()
      ..sort(
        (a, b) => b.compareTo(a), // reverse sort
      );
    return sorted;
  }

  Future<Map<String, int>> getMonthlyCount(
      {List<Account>? accounts, List<TransactionCategory>? categories}) async {
    final db = await DatabaseHelper.instance.database;
    String? accountFilter;
    if (accounts != null) {
      for (var i = 0; i < accounts.length; i++) {
        if (i == 0) {
          accountFilter = '${accounts[i].id}';
        } else {
          accountFilter = '${accountFilter!}, ${accounts[i].id}';
        }
      }
    }
    String? categoryFilter;
    if (categories != null) {
      for (var i = 0; i < categories.length; i++) {
        if (i == 0) {
          categoryFilter = '${categories[i].id}';
        } else {
          categoryFilter = '${categoryFilter!}, ${categories[i].id}';
        }
      }
    }
// ${accountFilter != null ? "WHERE (account1_id IN ($accountFilter) OR account2_id IN ($accountFilter))" : ""}
    final List<Map<String, dynamic>> dateList = await db.rawQuery(
      """ SELECT DISTINCT STRFTIME('%Y-%m', DATETIME(ROUND(date/1000), 'unixepoch'), 'start of month') AS month, COUNT(id) as amount
          FROM singleTransaction
          ${accountFilter != null ? "WHERE (account1_id IN ($accountFilter) OR account2_id IN ($accountFilter))" : ""}
          ${categoryFilter != null ? "${accountFilter != null ? "AND" : "WHERE"} category_id IN ($categoryFilter)" : ""}
          GROUP BY month
          ORDER BY month DESC;
      """,
    );

    Map<String, int> months = {};
    for (int i = 0; i < dateList.length; i++) {
      months.putIfAbsent(
          dateList[i]['month'], () => dateList[i]['amount'] as int);
    }

    return months;
  }

  Future<List<SingleTransaction>> getFilteredTransactionsByMonth({
    required DateTime inMonth,
    List<Account>? accounts,
    List<TransactionCategory>? categories,
    required List<Account> fullAccountList,
  }) async {
    var timelineTask = TimelineTask(filterKey: 'getFilterByMonth')
      ..start('get filter by month ${dateAsYYYYMM(inMonth)}');
    final db = await DatabaseHelper.instance.database;

    String? categoryFilter;
    if (categories != null) {
      categoryFilter = categories.fold(
          null,
          (previousValue, element) =>
              '$previousValue, ${element.id.toString()}');
    }

    String? accountFilter;
    if (accounts != null) {
      accountFilter = accounts.fold(
          null,
          (previousValue, element) =>
              '$previousValue, ${element.id.toString()}');
    }

    timelineTask.start('sql');
    List<Map<String, dynamic>> mapSingle = await db.rawQuery(
      // TODO: archived ?
      // query only for account1, account2 needs to be fetched separately
      '''SELECT *, category.icon AS category_icon, category.color AS category_color, category.id AS category_id, category.name AS category_name,
      singleTransaction.description AS description, singleTransaction.id AS id

      FROM singleTransaction, category

      WHERE category.id = singleTransaction.category_id
      AND date >= ? AND date <= ?
      ${accountFilter != null ? "AND (account1_id IN ($accountFilter) OR account2_id IN ($accountFilter))" : ""}
      ${categoryFilter != null ? "AND category_id IN ($categoryFilter)" : ""}
      
      ''',
      [
        firstOfMonth(inMonth).millisecondsSinceEpoch,
        lastSecondOfMonth(inMonth)
      ],
    );
    // timelineTask
    //   ..finish()
    //   ..start('get accounts for mapping');
    // List<Account> accountList = await AccountModel().getAllAccounts();

    timelineTask
      ..finish()
      ..start('mapping');

    List<SingleTransaction> transactions = [];
    for (int i = 0; i < mapSingle.length; i++) {
      transactions
          .add(await _mapToSingleTransaction(mapSingle[i], fullAccountList));
    }
    timelineTask
      ..finish()
      ..start('sorting');
    transactions.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    timelineTask
      ..finish()
      ..finish();
    return transactions;
  }
}
