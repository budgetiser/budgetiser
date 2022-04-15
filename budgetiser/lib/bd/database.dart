import 'dart:async';

import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/tempData/tempData.dart';
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
    print("creating database");
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
  FOREIGN KEY(category_id) REFERENCES category ON DELETE SET NULL
  );
    ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS singleTransaction(
  transaction_id INTEGER,
  date TEXT,
  id INTEGER,
  PRIMARY KEY(id),
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
  id INTEGER,
  PRIMARY KEY(id),
  CHECK(intervalType IN ('fixedPointOfTime', 'fixedInterval')),
  CHECK(intervalUnit IN ('day', 'week', 'month', 'quarter', 'year')),
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
  CHECK(intervalType IN ('fixedPointOfTime', 'fixedInterval')),
  CHECK(intervalUnit IN ('day', 'week', 'month', 'quarter', 'year')));
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS categoryToBudget(
  category_id INTEGER,
  budget_id INTEGER,
  PRIMARY KEY(category_id, budget_id),
  FOREIGN KEY(budget_id) REFERENCES budget,
  FOREIGN KEY(category_id) REFERENCES category);
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
  FOREIGN KEY(transaction_id) REFERENCES XXtransaction);
''');
    print("done");
  }

  _dropTables(Database db) async {
    await db.execute('''
          DROP TABLE IF EXISTS account; 
          DROP TABLE IF EXISTS XXtransaction;
          DROP TABLE IF EXISTS singleTransaction;
          DROP TABLE IF EXISTS recurringTransaction;
          DROP TABLE IF EXISTS category;
          DROP TABLE IF EXISTS XXGroup;
          DROP TABLE IF EXISTS saving;
          DROP TABLE IF EXISTS budget;
          DROP TABLE IF EXISTS categoryToBudget;
          DROP TABLE IF EXISTS categoryToGroup;
          DROP TABLE IF EXISTS transactionToAccount;
      ''');
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
    final List<Map<String, dynamic>> maps = await db.query('XXtransaction');

    allTransactionSink.add(List.generate(maps.length, (i) {
      return SingleTransaction(
          id: maps[i]['id'],
          account: TMP_DATA_accountList[0],
          category: TMP_DATA_categoryList[0],
          description: maps[i]['description'].toString(),
          title: maps[i]['title'].toString(),
          value: maps[i]['value'],
          account2: null,
          date: DateTime.now());
    }));
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
        'date': transaction.date.hashCode,
      };

      int id = await db.insert(
        'singleTransaction',
        rowSingleTransaction,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } else if (transaction is RecurringTransaction) {
      Map<String, dynamic> rowRecurringTransaction = {
        'transaction_id': transactionId,
        'intervalType': transaction.intervalType,
        'intervalAmount': transaction.intervalAmount,
        'intervalUnit': transaction.intervalUnit,
        'start_date': transaction.startDate.hashCode,
        'end_date': transaction.endDate.hashCode,
      };

      int id = await db.insert(
        'recurringTransaction',
        rowRecurringTransaction,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } else {
      print(
          "for testing: should not come here (in createTransaction in db-file)");
    }
    await db.update(
        'account', {'balance': transaction.account.balance + transaction.value},
        where: 'id = ?', whereArgs: [transaction.account.id]);

    await db.insert('transactionToAccount', {
      'transaction_id': transactionId,
      'toAccount_id': transaction.account.id,
      'fromAccount_id': null,
    });
    pushGetAllTransactionsStream();

    return transactionId;
  }

  Future<void> deleteTransaction(AbstractTransaction transaction) async {
    final db = await database;

    await db.update(
        'account', {'balance': transaction.account.balance - transaction.value},
        where: 'id = ?', whereArgs: [transaction.account.id]);

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

  Future<List<SingleTransaction>> getAllSingleTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'Select * from singleTransaction, XXtransaction, transactionToAccount where singleTransaction.transaction_id = XXtransaction.id and transactionToAccount.transaction_id = XXtransaction.id');

    List<SingleTransaction> list = [];
    for (int i = 0; i < maps.length; i++) {
      TransactionCategory cat = await _getCategorie(maps[i]['category_id']);
      Account account = await _getOneAccount(maps[i]['toAccount_id']);
      list.add(SingleTransaction(
        id: maps[i]['id'],
        title: maps[i]['title'],
        value: maps[i]['value'],
        description: maps[i]['description'],
        category: cat,
        account: account,
        account2: null,
        date: DateTime.parse(maps[i]['date'].toString()),
      ));
    }
    return list;
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

    return id;
  }

  Future<TransactionCategory> _getCategorie(int id) async {
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
}
