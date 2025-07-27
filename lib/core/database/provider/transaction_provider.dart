import 'dart:developer';

import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/shared/services/profiler.dart';
import 'package:budgetiser/shared/services/recently_used.dart';
import 'package:budgetiser/shared/utils/date_utils.dart';
import 'package:budgetiser/shared/utils/sql_utils.dart';
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

  /// Returns Transaction object from [mapItem]
  ///
  /// Uses additional providers to get Category and Account Object
  Future<SingleTransaction> _mapToSingleTransactionLEGACY(
    Map<String, dynamic> mapItem,
  ) async {
    Profiler.instance.start('map to single transactionLEGACY');

    SingleTransaction s = SingleTransaction.fromDBmap(
      mapItem,
      categories: await CategoryModel().getCategories(mapItem['category_ids']),
      account: await AccountModel().getOneAccount(mapItem['account1_id']),
      account2: mapItem['account2_id'] == null
          ? null
          : await AccountModel().getOneAccount(mapItem['account2_id']),
    );
    Profiler.instance.end();
    return s;
  }

  /// Uses [fullAccountList] for more efficient parsing of transactions in bulk
  Future<SingleTransaction> _mapToSingleTransaction(
    Map<String, dynamic> mapItem,
    List<Account> fullAccountList,
  ) async {
    Profiler.instance.start('map to single transaction');
    Profiler.instance.start('get accounts from list');
    Account account1 = fullAccountList.firstWhere(
      (element) => element.id == mapItem['account1_id'],
    ); // TODO if not found
    Account? account2 = mapItem['account2_id'] == null
        ? null
        : fullAccountList.firstWhere(
            (element) => element.id == mapItem['account2_id'],
          ); // TODO if not found
    Profiler.instance.end();
    SingleTransaction returnTransaction = SingleTransaction.fromDBmap(
      mapItem,
      categories: await getCategoriesFromTransactionId(mapItem['id']),
      account: account1,
      account2: account2,
    );
    Profiler.instance.end();
    return returnTransaction;
  }

  Future<List<TransactionCategory>> getCategoriesFromTransactionId(
    int transactionId,
  ) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapCategories = await db.query(
      'categoryToTransaction',
      where: 'transaction_id = ?',
      whereArgs: [transactionId],
    );

    List<TransactionCategory> categories = [];
    for (int i = 0; i < mapCategories.length; i++) {
      categories.add(
        await CategoryModel().getCategory(mapCategories[i]['category_id']),
      );
    }
    return categories;
  }

  Future<int> createSingleTransaction(
    SingleTransaction transaction, {
    bool notify = true,
    bool keepId = false,
  }) async {
    final db = await DatabaseHelper.instance.database;
    Map<String, dynamic> map = transaction.toMap();
    int id = transaction.id;
    await db.transaction((txn) async {
      if (!keepId) {
        id = await txn.insert(
          'singleTransaction',
          {
            'title': map['title'],
            'value': map['value'],
            'description': map['description'],
            'date': map['date'],
            'account1_id': map['account1_id'],
            'account2_id': map['account2_id'],
          },
          conflictAlgorithm: ConflictAlgorithm.fail,
        );
      } else {
        await txn.execute('''
        INSERT INTO singleTransaction (id, title, value, description, date, account1_id, account2_id) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?);
      ''', [
          id,
          map['title'],
          map['value'],
          map['description'],
          map['date'],
          map['account1_id'],
          map['account2_id'],
        ]);
      }

      for (TransactionCategory category in transaction.categories) {
        await txn.insert(
          'categoryToTransaction',
          {
            'transaction_id': id,
            'category_id': category.id,
          },
          conflictAlgorithm: ConflictAlgorithm.fail,
        );
      }

      if (transaction.account2 != null) {
        await txn.rawUpdate(
          'UPDATE account SET balance = round(balance - ?, 2) WHERE id = ?',
          [transaction.value, transaction.account.id],
        );
        await txn.rawUpdate(
          'UPDATE account SET balance = round(balance + ?, 2) WHERE id = ?',
          [transaction.value, transaction.account2!.id],
        );
      } else {
        await txn.rawUpdate(
          'UPDATE account SET balance = round(balance + ?, 2) WHERE id = ?',
          [transaction.value, transaction.account.id],
        );
      }
    });

    if (notify) {
      notifyTransactionUpdate();
    }

    recentlyUsedAccount.addItem(transaction.account.id.toString());

    return id;
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

  Future<Map<String, int>> getMonthlyCount({
    List<Account>? accounts,
    List<TransactionCategory>? categories,
  }) async {
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
          FROM singleTransaction, categoryToTransaction
          WHERE categoryToTransaction.transaction_id = singleTransaction.id
          ${accountFilter != null ? "WHERE (account1_id IN ($accountFilter) OR account2_id IN ($accountFilter))" : ""}
          ${categoryFilter != null ? "${accountFilter != null ? "AND" : "WHERE"} categoryToTransaction.category_id IN ($categoryFilter)" : ""}
          GROUP BY month
          ORDER BY month DESC;
      """,
    );

    Map<String, int> months = {};
    for (int i = 0; i < dateList.length; i++) {
      months.putIfAbsent(
        dateList[i]['month'],
        () => dateList[i]['amount'] as int,
      );
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
        (previousValue, element) => '$previousValue, ${element.id.toString()}',
      );
    }

    String? accountFilter;
    if (accounts != null) {
      accountFilter = accounts.fold(
        null,
        (previousValue, element) => '$previousValue, ${element.id.toString()}',
      );
    }

    timelineTask.start('sql');
    List<Map<String, dynamic>> mapSingle = await db.rawQuery(
      // TODO: archived ?
      // query only for account1, account2 needs to be fetched separately
      '''SELECT *, singleTransaction.description AS description, singleTransaction.id AS id

      FROM singleTransaction
      LEFT JOIN categoryToTransaction ON categoryToTransaction.transaction_id = singleTransaction.id
      WHERE date >= ? AND date <= ?
      ${accountFilter != null ? "AND (account1_id IN ($accountFilter) OR account2_id IN ($accountFilter))" : ""}
      ${categoryFilter != null ? "AND categoryToTransaction.category_id IN ($categoryFilter)" : ""}
      ''',
      [
        firstOfMonth(inMonth).millisecondsSinceEpoch,
        lastSecondOfMonth(inMonth),
      ],
    );

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

  Future<List<Map<String, dynamic>>> getAccountStats(
    List<Account> accounts,
    DateTimeRange dateRange,
  ) async {
    final db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
        WITH adjusted_transactions AS (
            SELECT 
                account1_id AS account_id,
                CASE 
                    WHEN account2_id IS NOT NULL THEN -ST.value
                    ELSE ST.value
                END AS adjusted_value,
                CASE 
                    WHEN account2_id IS NOT NULL THEN 1
                    ELSE 0
                END AS is_transfer,
                date
            FROM singleTransaction AS ST
            UNION ALL
            SELECT 
                account2_id AS account_id,
                ST.value AS adjusted_value,
                1 AS is_transfer,
                date
            FROM singleTransaction AS ST
            WHERE account2_id IS NOT NULL
        )

        SELECT A.name, A.color, A.icon, SUM(case when ST.is_transfer = 1 then 0 else 1 end) AS 'count', SUM(ST.is_transfer) AS 'transfers', SUM(ST.adjusted_value) AS 'sum', AVG(ST.adjusted_value) AS 'mean', SUM(case when ST.adjusted_value > 0 then ST.adjusted_value else 0 end) AS 'psum',  SUM(case when ST.adjusted_value < 0 then ST.adjusted_value else 0 end) AS 'nsum'
        FROM adjusted_transactions AS ST, account as A
        WHERE ST.account_id = A.id
        AND ${sqlWhereCombined(
      [
        'ST.account_id',
        'ST.date',
      ],
      [
        accounts.map((e) => e.id).toList(),
      ],
      dateRange,
    )}
        GROUP BY ST.account_id;
        ''');
    return maps;
  }

  Future<List<Map<String, dynamic>>> getCategoryStats(
    List<TransactionCategory> categories,
    DateTimeRange dateRange,
  ) async {
    final db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT C.name, C.color, C.icon, COUNT(ST.value) AS 'count', SUM(ST.value) AS 'sum', AVG(ST.value) AS 'mean', SUM(case when ST.value > 0 then ST.value else 0 end) AS 'psum',  SUM(case when ST.value < 0 then ST.value else 0 end) AS 'nsum'
        FROM singleTransaction AS ST, category as C
        WHERE ST.category_id = C.id
        AND account2_id IS NULL
        AND ${sqlWhereCombined(
      [
        'ST.category_id',
        'ST.date',
      ],
      [
        categories.map((e) => e.id).toList(),
      ],
      dateRange,
    )}
        GROUP BY ST.category_id;
        ''');

    return maps;
  }
}
