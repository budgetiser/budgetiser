import 'dart:async';

import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/tempData/tempData.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static const databaseName = 'budgetiser.db';
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
CREATE TABLE IF NOT EXISTS XXtransaction(
  id INTEGER,
  title TEXT,
  value REAL,
  description TEXT,
  category_id INTEGER,
  PRIMARY KEY(id),
  FOREIGN KEY(category_id) REFERENCES category ON DELETE CASCADE
  );
    ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS singleTransaction(
  transaction_id INTEGER,
  date TEXT,
  st_id INTEGER,
  PRIMARY KEY(st_id),
  FOREIGN KEY(transaction_id) REFERENCES XXtransaction ON DELETE CASCADE);
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS recurringTransaction(
  transaction_id INTEGER,
  intervalType TEXT,
  intervalAmount INTEGER,
  intervalUnit TEXT,
  start_date TEXT,
  end_date TEXT,
  rt_id INTEGER,
  PRIMARY KEY(rt_id),
  CHECK(intervalType IN ('IntervalType.fixedPointOfTime', 'IntervalType.fixedInterval')),
  CHECK(intervalUnit IN ('IntervalUnit.day', 'IntervalUnit.week', 'IntervalUnit.month', 'IntervalUnit.quarter', 'IntervalUnit.year')),
  FOREIGN KEY(transaction_id) REFERENCES XXtransaction ON DELETE CASCADE);
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
  intervalType TEXT,
  intervalAmount INTEGER,
  intervalUnit TEXT,
  start_date TEXT,
  end_date TEXT,
  description TEXT,
  PRIMARY KEY(id),
  CHECK(is_recurring IN (0, 1)),
  CHECK(intervalType IN ('IntervalType.fixedInterval', 'IntervalType.fixedPointOfTime')),
  CHECK(intervalUnit IN ('IntervalUnit.day', 'IntervalUnit.week', 'IntervalUnit.month', 'IntervalUnit.quarter', 'IntervalUnit.year')));
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
  FOREIGN KEY(category_id) REFERENCES category,
  FOREIGN KEY(group_id) REFERENCES XXGroup);
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS transactionToAccount(
  transaction_id INTEGER,
  toAccount_id INTEGER,
  fromAccount_id INTEGER,
  PRIMARY KEY(transaction_id, toAccount_id, fromAccount_id),
  FOREIGN KEY(toAccount_id) REFERENCES account
  FOREIGN KEY(fromAccount_id) REFERENCES account,
  FOREIGN KEY(transaction_id) REFERENCES XXtransaction ON DELETE CASCADE);
''');
    if (kDebugMode) {
      print("done");
    }
  }

  _dropTables(Database db) async {
    await db.execute('''
          DROP TABLE IF EXISTS singleTransaction;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS recurringTransaction;
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
          DROP TABLE IF EXISTS transactionToAccount;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS account; 
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS category;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS XXtransaction;
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
    for (var transaction in TMP_DATA_transactionList) {
      await createTransaction(transaction);
    }
    for (var saving in TMP_DATA_savingsList) {
      await createSaving(saving);
    }
    for (var budget in TMP_DATA_budgetList) {
      await createBudget(budget);
    }
    // TMP_DATA_groupList.forEach((group) async {
    //   await createGroup(group);
    // });
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

  final StreamController<List<AbstractTransaction>>
      _AllTransactionStreamController =
      StreamController<List<AbstractTransaction>>.broadcast();

  Sink<List<AbstractTransaction>> get allTransactionSink =>
      _AllTransactionStreamController.sink;

  Stream<List<AbstractTransaction>> get allTransactionStream =>
      _AllTransactionStreamController.stream;

  void pushGetAllTransactionsStream() async {
    final db = await database;
    final List<Map<String, dynamic>> mapSingle = await db.rawQuery(
        'Select distinct * from XXtransaction, transactionToAccount, singleTransaction where XXtransaction.id = transactionToAccount.transaction_id and XXtransaction.id = singleTransaction.transaction_id');
    final List<Map<String, dynamic>> mapRecurring = await db.rawQuery(
        'Select distinct * from XXtransaction, transactionToAccount, recurringTransaction where XXtransaction.id = transactionToAccount.transaction_id and XXtransaction.id = recurringTransaction.transaction_id');

    List<AbstractTransaction> list = [];
    for (int i = 0; i < mapSingle.length; i++) {
      list.add(await _mapToSingleTransaction(mapSingle[i]));
    }
    for (int i = 0; i < mapRecurring.length; i++) {
      list.add(await _mapToRecurringTransaction(mapRecurring[i]));
    }
    list.sort((a, b) {
      if (b is SingleTransaction && a is SingleTransaction) {
        return b.date.compareTo(a.date);
      } else if (b is RecurringTransaction && a is RecurringTransaction) {
        return b.startDate.compareTo(a.startDate);
      } else if (b is SingleTransaction && a is RecurringTransaction) {
        return b.date.compareTo(a.startDate);
      } else if (b is RecurringTransaction && a is SingleTransaction) {
        return b.startDate.compareTo(a.date);
      } else {
        throw Exception('Error in AbstractTransaction sorting');
      }
    });
    allTransactionSink.add(list);
  }

  Future<RecurringTransaction> _mapToRecurringTransaction(
      Map<String, dynamic> mapItem) async {
    TransactionCategory cat = await _getCategory(mapItem['category_id']);
    Account account = await _getOneAccount(mapItem['toAccount_id']);
    return RecurringTransaction(
      id: mapItem['id'],
      title: mapItem['title'].toString(),
      value: mapItem['value'],
      description: mapItem['description'].toString(),
      category: cat,
      account: account,
      account2: mapItem['fromAccount_id'] == null
          ? null
          : await _getOneAccount(mapItem['fromAccount_id']),
      startDate: DateTime.parse(mapItem['start_date'].toString()),
      endDate: DateTime.parse(mapItem['end_date'].toString()),
      intervalAmount: mapItem['intervalAmount'],
      intervalUnit: IntervalUnit.values
          .firstWhere((e) => e.toString() == mapItem['intervalUnit']),
      intervalType: IntervalType.values
          .firstWhere((e) => e.toString() == mapItem['intervalType']),
    );
  }

  Future<SingleTransaction> _mapToSingleTransaction(
      Map<String, dynamic> mapItem) async {
    TransactionCategory cat = await _getCategory(mapItem['category_id']);
    Account account = await _getOneAccount(mapItem['toAccount_id']);
    return SingleTransaction(
      id: mapItem['id'],
      title: mapItem['title'].toString(),
      value: mapItem['value'],
      description: mapItem['description'].toString(),
      category: cat,
      account: account,
      account2: mapItem['fromAccount_id'] == null
          ? null
          : await _getOneAccount(mapItem['fromAccount_id']),
      date: DateTime.parse(mapItem['date'].toString()),
    );
  }

  Future<AbstractTransaction> getOneTransaction(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> mapSingle = await db.rawQuery(
        'Select distinct * from XXtransaction, transactionToAccount, singleTransaction where XXtransaction.id = transactionToAccount.transaction_id and XXtransaction.id = singleTransaction.transaction_id and XXtransaction.id = ?',
        [id]);
    final List<Map<String, dynamic>> mapRecurring = await db.rawQuery(
        'Select distinct * from XXtransaction, transactionToAccount, recurringTransaction where XXtransaction.id = transactionToAccount.transaction_id and XXtransaction.id = recurringTransaction.transaction_id and XXtransaction.id = ?',
        [id]);

    if (mapSingle.length == 1) {
      return await _mapToSingleTransaction(mapSingle[0]);
    } else if (mapRecurring.length == 1) {
      return await _mapToRecurringTransaction(mapRecurring[0]);
    } else {
      throw Exception('Error in getOneTransaction');
    }
  }

  Future<int> createTransaction(AbstractTransaction transaction) async {
    final db = await database;

    Map<String, dynamic> rowTransaction = {
      'title': transaction.title,
      'value': transaction.value,
      'description': transaction.description,
      'category_id': transaction.category.id,
    };

    int transactionId = await db.insert(
      'XXtransaction',
      rowTransaction,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    if (transaction is SingleTransaction) {
      Map<String, dynamic> rowSingleTransaction = {
        'transaction_id': transactionId,
        'date': transaction.date.toString().substring(0, 10),
      };

      await db.insert(
        'singleTransaction',
        rowSingleTransaction,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } else if (transaction is RecurringTransaction) {
      Map<String, dynamic> rowRecurringTransaction = {
        'transaction_id': transactionId,
        'intervalType': transaction.intervalType.toString(),
        'intervalAmount': transaction.intervalAmount,
        'intervalUnit': transaction.intervalUnit.toString(),
        'start_date': transaction.startDate.toString().substring(0, 10),
        'end_date': transaction.endDate.toString().substring(0, 10),
      };

      await db.insert(
        'recurringTransaction',
        rowRecurringTransaction,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    // TODO: adjust account balance in recurring transactions
    if (transaction is SingleTransaction) {
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
    }

    await db.insert('transactionToAccount', {
      'transaction_id': transactionId,
      'toAccount_id': transaction.account.id,
      'fromAccount_id':
          transaction.account2 != null ? transaction.account2!.id : null,
    });
    pushGetAllTransactionsStream();
    pushGetAllAccountsStream();

    return transactionId;
  }

  Future<void> deleteTransaction(AbstractTransaction transaction) async {
    final db = await database;

    if (transaction is SingleTransaction) {
      // TODO: current only balance change with single transaction
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
    }

    await db.delete(
      'XXtransaction',
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
    await db.delete(
      'singleTransaction',
      where: 'transaction_id = ?',
      whereArgs: [transaction.id],
    );
    await db.delete(
      'recurringTransaction',
      where: 'transaction_id = ?',
      whereArgs: [transaction.id],
    );
    await db.delete(
      'transactionToAccount',
      where: 'transaction_id = ?',
      whereArgs: [transaction.id],
    );
    pushGetAllTransactionsStream();
  }

  Future<void> updateTransaction(AbstractTransaction transaction) async {
    final db = await database;

    var oldTransaction = await getOneTransaction(transaction.id);
    await deleteTransaction(oldTransaction);
    await createTransaction(transaction);

    pushGetAllTransactionsStream();
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

  Future<void> deleteCategory(int categoryID) async {
    final db = await database;

    await db.delete(
      'category',
      where: 'id = ?',
      whereArgs: [categoryID],
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

  final StreamController<List<Budget>> _AllBudgetsStreamController =
      StreamController<List<Budget>>.broadcast();

  Sink<List<Budget>> get allBudgetsSink => _AllBudgetsStreamController.sink;

  Stream<List<Budget>> get allBudgetsStream =>
      _AllBudgetsStreamController.stream;

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
            .firstWhere((e) => e.toString() == maps[i]['intervalUnit']);
        returnBudget.intervalType = IntervalType.values
            .firstWhere((e) => e.toString() == maps[i]['intervalType']);
        returnBudget.intervalAmount = maps[i]['intervalAmount'];
      }
      return returnBudget;
    }));
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
}
