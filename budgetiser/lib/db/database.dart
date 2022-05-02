import 'dart:async';

import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:budgetiser/shared/dataClasses/recurringTransaction.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/dataClasses/singleTransaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/tempData/tempData.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static const databaseName = 'budgetiser11.db';
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async =>
      _database ??= await initializeDatabase();

  _onCreate(Database db, int version) async {
    if (kDebugMode) {
      print("creating database");
    }
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute('''
CREATE TABLE IF NOT EXISTS account(
  id INTEGER,
  name TEXT,
  icon INTEGER,
  color INTEGER,
  balance REAL,
  description TEXT,
  PRIMARY KEY(id));
    ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS category(
  id INTEGER,
  name TEXT,
  icon INTEGER,
  color INTEGER,
  description TEXT,
  is_hidden INTEGER,
  PRIMARY KEY(id),
  CHECK(is_hidden IN (0, 1)));
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS singleTransaction(
  id INTEGER,
  title TEXT,
  value REAL,
  description TEXT,
  category_id INTEGER,
  date TEXT,
  PRIMARY KEY(id),
  FOREIGN KEY(category_id) REFERENCES category ON DELETE CASCADE
  );
    ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS recurringTransaction(
  id INTEGER,
  title TEXT,
  value REAL,
  description TEXT,
  category_id INTEGER,
  start_date TEXT,
  end_date TEXT,
  interval_type TEXT,
  interval_unit TEXT,
  interval_amount INTEGER,
  repetition_amount INTEGER,
  PRIMARY KEY(id),
  FOREIGN KEY(category_id) REFERENCES category ON DELETE CASCADE,
  CHECK(interval_type IN ('IntervalType.fixedPointOfTime', 'IntervalType.fixedInterval')),
  CHECK(interval_unit IN ('IntervalUnit.day', 'IntervalUnit.week', 'IntervalUnit.month', 'IntervalUnit.quarter', 'IntervalUnit.year'))
  );
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS singleToRecurringTransaction(
  single_transaction_id INTEGER,
  recurring_transaction_id INTEGER,
  PRIMARY KEY(single_transaction_id, recurring_transaction_id),
  FOREIGN KEY(single_transaction_id) REFERENCES singleTransaction ON DELETE CASCADE,
  FOREIGN KEY(recurring_transaction_id) REFERENCES recurringTransaction ON DELETE CASCADE
  );
    ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS XXGroup(
  id INTEGER,
  name TEXT,
  icon INTEGER,
  color INTEGER,
  description TEXT,
  PRIMARY KEY(id));
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS saving(
  id INTEGER,
  name TEXT,
  icon INTEGER,
  color INTEGER,
  balance REAL,
  start_date TEXT,
  end_date TEXT,
  goal REAL,
  description TEXT,
  PRIMARY KEY(id));
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS budget(
  id INTEGER,
  name TEXT,
  icon INTEGER,
  color INTEGER,
  balance REAL,
  limitXX REAL,
  is_recurring INTEGER,
  interval_type TEXT,
  interval_amount INTEGER,
  interval_unit TEXT,
  start_date TEXT,
  end_date TEXT,
  description TEXT,
  PRIMARY KEY(id),
  CHECK(is_recurring IN (0, 1)),
  CHECK(interval_type IN ('IntervalType.fixedInterval', 'IntervalType.fixedPointOfTime')),
  CHECK(interval_unit IN ('IntervalUnit.day', 'IntervalUnit.week', 'IntervalUnit.month', 'IntervalUnit.quarter', 'IntervalUnit.year')));
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS categoryToBudget(
  category_id INTEGER,
  budget_id INTEGER,
  PRIMARY KEY(category_id, budget_id),
  FOREIGN KEY(budget_id) REFERENCES budget ON DELETE CASCADE,
  FOREIGN KEY(category_id) REFERENCES category ON DELETE CASCADE);
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS categoryToGroup(
  category_id INTEGER,
  group_id INTEGER,
  PRIMARY KEY(category_id, group_id),
  FOREIGN KEY(category_id) REFERENCES category ON DELETE CASCADE,
  FOREIGN KEY(group_id) REFERENCES XXGroup ON DELETE CASCADE);
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS singleTransactionToAccount(
  transaction_id INTEGER,
  account1_id INTEGER,
  account2_id INTEGER,
  PRIMARY KEY(transaction_id, account1_id, account2_id),
  FOREIGN KEY(account1_id) REFERENCES account
  FOREIGN KEY(account2_id) REFERENCES account,
  FOREIGN KEY(transaction_id) REFERENCES singleTransaction ON DELETE CASCADE);
''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS recurringTransactionToAccount(
  transaction_id INTEGER,
  account1_id INTEGER,
  account2_id INTEGER,
  PRIMARY KEY(transaction_id, account1_id, account2_id),
  FOREIGN KEY(account1_id) REFERENCES account
  FOREIGN KEY(account2_id) REFERENCES account,
  FOREIGN KEY(transaction_id) REFERENCES recurringTransaction ON DELETE CASCADE);
''');
    if (kDebugMode) {
      print("done");
    }
  }

  _dropTables(Database db) async {
    await db.execute('''
          DROP TABLE IF EXISTS recurringTransactionToAccount;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS XXGroup;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS saving;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS budget;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS categoryToBudget;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS categoryToGroup;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS singleTransactionToAccount;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS account; 
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS singleToRecurringTransaction;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS singleTransaction;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS recurringTransaction;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS category;
          ''');
  }

  resetDB() async {
    final Database db = await database;
    await _dropTables(db);
    await _onCreate(db, 1);
  }

  fillDBwithTMPdata() async {
    for (var account in TMP_DATA_accountList) {
      await createAccount(account);
    }
    for (var category in TMP_DATA_categoryList) {
      await createCategory(category);
    }
    for (var recurringTransaction in TMP_DATA_recurringTransactionList) {
      await createRecurringTransaction(recurringTransaction);
    }
    for (var transaction in TMP_DATA_transactionList) {
      await createSingleTransaction(transaction);
    }
    for (var saving in TMP_DATA_savingsList) {
      await createSaving(saving);
    }
    for (var budget in TMP_DATA_budgetList) {
      await createBudget(budget);
    }
    for (var group in TMP_DATA_groupList) {
      await createGroup(group);
    }
  }

  initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    return await openDatabase(
      join(databasesPath, databaseName),
      version: 1,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        _dropTables(db);
        _onCreate(db, newVersion);
      },
      onDowngrade: (db, oldVersion, newVersion) async {
        _dropTables(db);
        _onCreate(db, newVersion);
      },
    );
  }

  /*
  * Account
  */
  final StreamController<List<Account>> _AllAccountsStreamController =
      StreamController<List<Account>>.broadcast();

  Sink<List<Account>> get allAccountsSink => _AllAccountsStreamController.sink;

  Stream<List<Account>> get allAccountsStream =>
      _AllAccountsStreamController.stream;

  void pushGetAllAccountsStream() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('account');

    allAccountsSink.add(List.generate(maps.length, (i) {
      return Account(
        id: maps[i]['id'],
        name: maps[i]['name'].toString(),
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(maps[i]['color']),
        balance: maps[i]['balance'],
        description: maps[i]['description'],
      );
    }));
  }

  Future<int> createAccount(Account account) async {
    final db = await database;
    int id = await db.insert(
      'account',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    pushGetAllAccountsStream();
    return id;
  }

  Future<void> deleteAccount(int accountID) async {
    final db = await database;

    await db.delete(
      'account',
      where: 'id = ?',
      whereArgs: [accountID],
    );
    pushGetAllAccountsStream();
  }

  Future<void> updateAccount(Account account) async {
    final db = await database;

    await db.update(
      'account',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
    pushGetAllAccountsStream();
  }

  Future<Account> _getOneAccount(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('account', where: 'id = ?', whereArgs: [id]);

    if (maps.length > 1) {
      throw Exception(' TODO: check : More than one account with id $id');
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

  /*
  * SingleTransaction
  */
  final StreamController<List<SingleTransaction>>
      _AllTransactionStreamController =
      StreamController<List<SingleTransaction>>.broadcast();

  Sink<List<SingleTransaction>> get allTransactionSink =>
      _AllTransactionStreamController.sink;

  Stream<List<SingleTransaction>> get allTransactionStream =>
      _AllTransactionStreamController.stream;

  void pushGetAllTransactionsStream() async {
    final db = await database;
    final List<Map<String, dynamic>> mapSingle = await db.rawQuery(
        'Select distinct * from singleTransaction, singleTransactionToAccount where singleTransaction.id = singleTransactionToAccount.transaction_id');

    List<SingleTransaction> list = [];
    for (int i = 0; i < mapSingle.length; i++) {
      list.add(await _mapToSingleTransaction(mapSingle[i]));
    }

    list.sort((a, b) {
      return b.date.compareTo(a.date);
    });

    allTransactionSink.add(list);
  }

  Future<SingleTransaction> _mapToSingleTransaction(
      Map<String, dynamic> mapItem) async {
    TransactionCategory cat = await _getCategory(mapItem['category_id']);
    Account account = await _getOneAccount(mapItem['account1_id']);
    RecurringTransaction? recurringTransaction =
        await _getRecurringTransactionFromSingeId(mapItem['id']);
    return SingleTransaction(
      id: mapItem['id'],
      title: mapItem['title'].toString(),
      value: mapItem['value'],
      description: mapItem['description'].toString(),
      category: cat,
      account: account,
      account2: mapItem['account2_id'] == null
          ? null
          : await _getOneAccount(mapItem['account2_id']),
      date: DateTime.parse(mapItem['date'].toString()),
      recurringTransaction: recurringTransaction,
    );
  }

  Future<int> createSingleTransaction(SingleTransaction transaction) async {
    final db = await database;

    int transactionId = await db.insert(
      'singleTransaction',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    Map<String, dynamic> rowSingleTransaction = {
      'transaction_id': transactionId,
      'date': transaction.date.toString().substring(0, 10),
    };

    Account account = await _getOneAccount(transaction.account.id);
    if (transaction.account2 == null) {
      await db.update(
        'account',
        {'balance': account.balance + transaction.value},
        where: 'id = ?',
        whereArgs: [account.id],
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } else {
      Account account2 = await _getOneAccount(transaction.account2!.id);
      await db.update(
          'account', {'balance': account.balance - transaction.value},
          where: 'id = ?', whereArgs: [account.id]);
      await db.update(
          'account', {'balance': account2.balance + transaction.value},
          where: 'id = ?', whereArgs: [account2.id]);
    }

    if (transaction.recurringTransaction != null) {
      await db.insert(
        'singleToRecurringTransaction',
        {
          'single_transaction_id': transactionId,
          'recurring_transaction_id': transaction.recurringTransaction!.id,
        },
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await db.insert('singleTransactionToAccount', {
      'transaction_id': transactionId,
      'account1_id': transaction.account.id,
      'account2_id':
          transaction.account2 != null ? transaction.account2!.id : null,
    });

    pushGetAllTransactionsStream();
    pushGetAllAccountsStream();

    return transactionId;
  }

  Future<void> deleteSingleTransaction(SingleTransaction transaction) async {
    final db = await database;

    if (transaction.account2 == null) {
      await db.update('account',
          {'balance': transaction.account.balance - transaction.value},
          where: 'id = ?', whereArgs: [transaction.account.id]);
    } else {
      await db.update('account',
          {'balance': transaction.account.balance + transaction.value},
          where: 'id = ?', whereArgs: [transaction.account.id]);
      await db.update('account',
          {'balance': transaction.account2!.balance - transaction.value},
          where: 'id = ?', whereArgs: [transaction.account2!.id]);
    }

    await db.delete(
      'singleTransaction',
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
    await db.delete(
      'singleToRecurringTransaction',
      where: 'single_transaction_id = ?',
      whereArgs: [transaction.id],
    );
    await db.delete(
      'singleTransactionToAccount',
      where: 'transaction_id = ?',
      whereArgs: [transaction.id],
    );
    pushGetAllTransactionsStream();
  }

  Future<void> updateSingleTransaction(SingleTransaction transaction) async {
    await deleteTransactionById(transaction.id);
    await createSingleTransaction(transaction);

    pushGetAllTransactionsStream();
  }

  Future<SingleTransaction> getOneTransaction(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> mapSingle = await db.rawQuery(
        'Select distinct * from SingleTransaction, singleTransactionToAccount where SingleTransaction.id = singleTransactionToAccount.transaction_id and SingleTransaction.id = ?',
        [id]);

    if (mapSingle.length == 1) {
      return await _mapToSingleTransaction(mapSingle[0]);
      // } else if (mapRecurring.length == 1) {
      //   return await _mapToRecurringTransaction(mapRecurring[0]);
    } else {
      throw Exception('Error in getOneTransaction');
    }
  }

  /*
  * RecurringTransaction
  */

  final StreamController<List<RecurringTransaction>>
      _AllRecurringTransactionStreamController =
      StreamController<List<RecurringTransaction>>.broadcast();

  Sink<List<RecurringTransaction>> get allRecurringTransactionSink =>
      _AllRecurringTransactionStreamController.sink;

  Stream<List<RecurringTransaction>> get allRecurringTransactionStream =>
      _AllRecurringTransactionStreamController.stream;

  void pushGetAllRecurringTransactionsStream() async {
    final db = await database;
    final List<Map<String, dynamic>> mapRecurring = await db.rawQuery(
        'Select distinct * from recurringTransaction, recurringTransactionToAccount where recurringTransaction.id = recurringTransactionToAccount.transaction_id ');

    List<RecurringTransaction> list = [];
    for (int i = 0; i < mapRecurring.length; i++) {
      list.add(await _mapToRecurringTransaction(mapRecurring[i]));
    }

    list.sort((a, b) {
      return b.startDate.compareTo(a.startDate);
    });

    allRecurringTransactionSink.add(list);
  }

  Future<RecurringTransaction> _mapToRecurringTransaction(
      Map<String, dynamic> mapItem) async {
    TransactionCategory cat = await _getCategory(mapItem['category_id']);
    Account account = await _getOneAccount(mapItem['account1_id']);
    return RecurringTransaction(
      id: mapItem['id'],
      title: mapItem['title'].toString(),
      value: mapItem['value'],
      description: mapItem['description'].toString(),
      category: cat,
      account: account,
      account2: mapItem['account2_id'] == null
          ? null
          : await _getOneAccount(mapItem['account2_id']),
      startDate: DateTime.parse(mapItem['start_date'].toString()),
      endDate: DateTime.parse(mapItem['end_date'].toString()),
      intervalType: IntervalType.values
          .firstWhere((e) => e.toString() == mapItem['interval_type']),
      intervalUnit: IntervalUnit.values
          .firstWhere((e) => e.toString() == mapItem['interval_unit']),
      intervalAmount: mapItem['interval_amount'],
      repetitionAmount: mapItem['repetition_amount'],
    );
  }

  Future<int> createRecurringTransaction(
      RecurringTransaction recurringTransaction) async {
    final db = await database;

    int transactionId = await db.insert(
      'recurringTransaction',
      recurringTransaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    await db.insert('recurringTransactionToAccount', {
      'transaction_id': transactionId,
      'account1_id': recurringTransaction.account.id,
      'account2_id': recurringTransaction.account2 != null
          ? recurringTransaction.account2!.id
          : null,
    });
    pushGetAllRecurringTransactionsStream();

    return transactionId;
  }

  Future<void> deleteRecurringTransaction(
      RecurringTransaction transaction) async {
    final db = await database;

    await db.delete(
      'recurringTransaction',
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
    await db.delete(
      'singleToRecurringTransaction',
      where: 'recurring_transaction_id = ?',
      whereArgs: [transaction.id],
    );
    await db.delete(
      'recurringTransactionToAccount',
      where: 'transaction_id = ?',
      whereArgs: [transaction.id],
    );
    pushGetAllRecurringTransactionsStream();
  }

  Future<void> updateRecurringTransaction(
      RecurringTransaction recurringTransaction) async {
    await deleteTransactionById(recurringTransaction.id);
    await createRecurringTransaction(recurringTransaction);

    pushGetAllRecurringTransactionsStream();
  }

  Future<RecurringTransaction> getOneRecurringTransactionById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> mapRecurring = await db.rawQuery(
        'Select distinct * from recurringTransaction, recurringTransactionToAccount where recurringTransaction.id = recurringTransactionToAccount.transaction_id and recurringTransaction.id = ?',
        [id]);

    if (mapRecurring.length == 1) {
      return await _mapToRecurringTransaction(mapRecurring[0]);
    } else {
      throw Exception('Error in getOneRecurringTransaction');
    }
  }

  Future<RecurringTransaction?> _getRecurringTransactionFromSingeId(
      int id) async {
    final db = await database;
    final List<Map<String, dynamic>> mapRecurring = await db.rawQuery(
        'Select distinct * from singleToRecurringTransaction, recurringTransaction, recurringTransactionToAccount where singleToRecurringTransaction.single_transaction_id = ? and singleToRecurringTransaction.recurring_transaction_id = recurringTransaction.id and recurringTransaction.id = recurringTransactionToAccount.transaction_id',
        [
          id,
        ]);
    if (mapRecurring.length == 1) {
      return await _mapToRecurringTransaction(mapRecurring[0]);
    } else {
      return null;
    }
  }

  /*
  * Single & Recurring Transaction 
  */

  Future<void> deleteTransactionById(int id) async {
    final db = await database;

    await db.delete(
      'singleTransaction',
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'singleTransactionToAccount',
      where: 'transaction_id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'recurringTransaction',
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'recurringTransactionToAccount',
      where: 'transaction_id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'singleToRecurringTransaction',
      where: 'single_transaction_id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'singleToRecurringTransaction',
      where: 'recurring_transaction_id = ?',
      whereArgs: [id],
    );
    pushGetAllTransactionsStream();
    pushGetAllRecurringTransactionsStream();
  }

  /*
  * Category
  */

  final StreamController<List<TransactionCategory>>
      _AllCategoryStreamController =
      StreamController<List<TransactionCategory>>.broadcast();

  Sink<List<TransactionCategory>> get allCategorySink =>
      _AllCategoryStreamController.sink;

  Stream<List<TransactionCategory>> get allCategoryStream =>
      _AllCategoryStreamController.stream;

  void pushGetAllCategoriesStream() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('category');

    allCategorySink.add(List.generate(maps.length, (i) {
      return TransactionCategory(
        id: maps[i]['id'],
        name: maps[i]['name'].toString(),
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(maps[i]['color']),
        description: maps[i]['description'].toString(),
        isHidden: maps[i]['is_hidden'] == 1,
      );
    }));
  }

  Future<int> createCategory(TransactionCategory category) async {
    final db = await database;
    Map<String, dynamic> row = {
      'name': category.name,
      'icon': category.icon.codePoint,
      'color': category.color.value,
      'description': category.description,
      'is_hidden': ((category.isHidden) ? 1 : 0),
    };

    int id = await db.insert(
      'category',
      row,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    pushGetAllCategoriesStream();
    return id;
  }

  Future<void> deleteCategory(int categoryID) async {
    final db = await database;

    await db.delete(
      'category',
      where: 'id = ?',
      whereArgs: [categoryID],
    );
    pushGetAllCategoriesStream();
  }

  Future<void> updateCategory(TransactionCategory category) async {
    final db = await database;

    await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
    pushGetAllCategoriesStream();
  }

  Future<void> hideCategory(int categoryID) async {
    final db = await database;

    await db.update(
      'category',
      {'is_hidden': true},
      where: 'id = ?',
      whereArgs: [categoryID],
    );
    pushGetAllCategoriesStream();
  }

  Future<TransactionCategory> _getCategory(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('category', where: 'id = ?', whereArgs: [id]);

    return TransactionCategory(
      id: maps[0]['id'],
      name: maps[0]['name'],
      icon: IconData(maps[0]['icon'], fontFamily: 'MaterialIcons'),
      color: Color(maps[0]['color']),
      description: maps[0]['description'],
      isHidden: maps[0]['is_hidden'] == 1,
    );
  }

  /*
  * Savings
  */

  final StreamController<List<Savings>> _AllSavingsStreamController =
      StreamController<List<Savings>>.broadcast();

  Sink<List<Savings>> get allSavingsSink => _AllSavingsStreamController.sink;

  Stream<List<Savings>> get allSavingsStream =>
      _AllSavingsStreamController.stream;

  void pushGetAllSavingsStream() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('saving');

    allSavingsSink.add(List.generate(maps.length, (i) {
      return Savings(
        id: maps[i]['id'],
        name: maps[i]['name'].toString(),
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(maps[i]['color']),
        balance: maps[i]['balance'],
        startDate: DateTime.parse(maps[i]['start_date']),
        endDate: DateTime.parse(maps[i]['end_date']),
        goal: maps[i]['goal'],
        description: maps[i]['description'].toString(),
      );
    }));
  }

  Future<int> createSaving(Savings saving) async {
    final db = await database;

    int id = await db.insert(
      'saving',
      saving.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    pushGetAllSavingsStream();
    return id;
  }

  void deleteSaving(int savingID) async {
    final db = await database;

    await db.delete(
      'saving',
      where: 'id = ?',
      whereArgs: [savingID],
    );
    pushGetAllSavingsStream();
  }

  Future<void> updateSaving(Savings saving) async {
    final db = await database;
    await db.update(
      'saving',
      saving.toMap(),
      where: 'id = ?',
      whereArgs: [saving.id],
    );
    pushGetAllSavingsStream();
  }

  /*
  * Budget
  */

  final StreamController<List<Budget>> _AllBudgetsStreamController =
      StreamController<List<Budget>>.broadcast();

  Sink<List<Budget>> get allBudgetsSink => _AllBudgetsStreamController.sink;

  Stream<List<Budget>> get allBudgetsStream =>
      _AllBudgetsStreamController.stream;

  void pushGetAllBudgetsStream() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('budget');
    List<List<TransactionCategory>> categoryList = [];
    for (int i = 0; i < maps.length; i++) {
      categoryList.add(await _getCategoriesToBudget(maps[i]['id']));
    }

    allBudgetsSink.add(List.generate(maps.length, (i) {
      Budget returnBudget = Budget(
        id: maps[i]['id'],
        name: maps[i]['name'].toString(),
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(maps[i]['color']),
        balance: maps[i]['balance'],
        limit: maps[i]['limitXX'],
        startDate: DateTime.parse(maps[i]['start_date']),
        description: maps[i]['description'].toString(),
        isRecurring: maps[i]['is_recurring'] == 1,
        transactionCategories: categoryList[i],
      );
      if (maps[i]['is_recurring'] == 1) {
        returnBudget.endDate = DateTime.parse(maps[i]['end_date']);
        returnBudget.intervalUnit = IntervalUnit.values
            .firstWhere((e) => e.toString() == maps[i]['interval_unit']);
        returnBudget.intervalType = IntervalType.values
            .firstWhere((e) => e.toString() == maps[i]['interval_type']);
        returnBudget.intervalAmount = maps[i]['interval_amount'];
      }
      return returnBudget;
    }));
  }

  Future<List<TransactionCategory>> _getCategoriesToBudget(int budgetID) async {
    final db = await database;

    final List<Map<String, dynamic>> mapCategories = await db.rawQuery(
        'Select distinct id, name, icon, color, description, is_hidden from category, categoryToBudget where category_id = category.id and budget_id = ?',
        [budgetID]);
    return List.generate(mapCategories.length, (i) {
      return TransactionCategory(
        id: mapCategories[i]['id'],
        name: mapCategories[i]['name'].toString(),
        icon: IconData(mapCategories[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(mapCategories[i]['color']),
        description: mapCategories[i]['description'].toString(),
        isHidden: mapCategories[i]['is_hidden'] == 1,
      );
    });
  }

  Future<int> createBudget(Budget budget) async {
    final db = await database;

    int id = await db.insert(
      'budget',
      budget.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    List<TransactionCategory> _categories = budget.transactionCategories;

    for (int i = 0; i < _categories.length; i++) {
      Map<String, dynamic> rowCategory = {
        'category_id': _categories[i].id,
        'budget_id': id,
      };
      await db.insert(
        'categoryToBudget',
        rowCategory,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
    pushGetAllBudgetsStream();
    return id;
  }

  void deleteBudget(int budgetID) async {
    final db = await database;

    await db.delete(
      'budget',
      where: 'id = ?',
      whereArgs: [budgetID],
    );
    pushGetAllBudgetsStream();
  }

  Future<void> updateBudget(Budget budget) async {
    final db = await database;
    await db.update(
      'budget',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
    List<TransactionCategory> _categories = budget.transactionCategories;

    await db.delete(
      'categoryToBudget',
      where: 'budget_id = ?',
      whereArgs: [budget.id],
    );

    for (int i = 0; i < _categories.length; i++) {
      Map<String, dynamic> rowCategory = {
        'category_id': _categories[i].id,
        'budget_id': budget.id,
      };
      await db.insert(
        'categoryToBudget',
        rowCategory,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
    pushGetAllBudgetsStream();
  }

  /*
  * Group
  */
  final StreamController<List<Group>> _AllGroupsStreamController =
      StreamController<List<Group>>.broadcast();

  Sink<List<Group>> get allGroupsSink => _AllGroupsStreamController.sink;

  Stream<List<Group>> get allGroupsStream => _AllGroupsStreamController.stream;

  void pushGetAllGroupsStream() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('XXGroup');
    List<List<TransactionCategory>> categoryList = [];
    for (int i = 0; i < maps.length; i++) {
      categoryList.add(await _getCategoriesToGroup(maps[i]['id']));
    }

    allGroupsSink.add(List.generate(maps.length, (i) {
      return Group(
        id: maps[i]['id'],
        name: maps[i]['name'].toString(),
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(maps[i]['color']),
        description: maps[i]['description'].toString(),
        transactionCategories: categoryList[i],
      );
    }));
  }

  Future<List<TransactionCategory>> _getCategoriesToGroup(int groupID) async {
    final db = await database;

    final List<Map<String, dynamic>> mapCategories = await db.rawQuery(
        'Select distinct id, name, icon, color, description, is_hidden from category, categoryToGroup where category_id = category.id and group_id = ?',
        [groupID]);
    return List.generate(mapCategories.length, (i) {
      return TransactionCategory(
        id: mapCategories[i]['id'],
        name: mapCategories[i]['name'].toString(),
        icon: IconData(mapCategories[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(mapCategories[i]['color']),
        description: mapCategories[i]['description'].toString(),
        isHidden: mapCategories[i]['is_hidden'] == 1,
      );
    });
  }

  Future<int> createGroup(Group group) async {
    final db = await database;

    int id = await db.insert(
      'XXGroup',
      group.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    List<TransactionCategory> _categories = group.transactionCategories;

    for (int i = 0; i < _categories.length; i++) {
      Map<String, dynamic> rowCategory = {
        'category_id': _categories[i].id,
        'group_id': id,
      };
      await db.insert(
        'categoryToGroup',
        rowCategory,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
    pushGetAllGroupsStream();
    return id;
  }

  void deleteGroup(int groupID) async {
    final db = await database;

    await db.delete(
      'XXGroup',
      where: 'id = ?',
      whereArgs: [groupID],
    );
    pushGetAllGroupsStream();
  }

  Future<void> updateGroup(Group group) async {
    final db = await database;
    await db.update(
      'XXGroup',
      group.toMap(),
      where: 'id = ?',
      whereArgs: [group.id],
    );
    List<TransactionCategory> _categories = group.transactionCategories;

    await db.delete(
      'categoryToGroup',
      where: 'group_id = ?',
      whereArgs: [group.id],
    );

    for (int i = 0; i < _categories.length; i++) {
      Map<String, dynamic> rowCategory = {
        'category_id': _categories[i].id,
        'group_id': group.id,
      };
      await db.insert(
        'categoryToGroup',
        rowCategory,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
    pushGetAllGroupsStream();
  }
}
