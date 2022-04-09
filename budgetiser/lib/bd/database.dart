import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static const databaseName = 'budgetiser5.db';
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async =>
      _database ??= await initializeDatabase();

  _onCreate(Database db, int version) async {
    print("creating database");
    await db.execute('''
CREATE TABLE IF NOT EXISTS account(
  id INTEGER,
  name STRING,
  icon INTEGER,
  color INTEGER,
  balance REAL,
  description STRING,
  PRIMARY KEY(id));
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS XXtransaction(
  id INTEGER,
  title STRING,
  value REAL,
  description STRING,
  category_id INTEGER,
  PRIMARY KEY(id),
  FOREIGN KEY(category_id) REFERENCES category ON DELETE SET NULL
  );
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS singleTransaction(
  transaction_id INTEGER,
  date STRING,
  id INTEGER,
  PRIMARY KEY(id),
  FOREIGN KEY(transaction_id) REFERENCES XXtransaction ON DELETE CASCADE);
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS recurringTransaction(
  transaction_id INTEGER,
  intervalType STRING,
  intervalAmount INTEGER,
  intervalUnit STRING,
  start_date STRING,
  end_date STRING,
  id INTEGER,
  PRIMARY KEY(id),
  CHECK(intervalType IN ('fixedPointOfTime', 'fixedInterval')),
  CHECK(intervalUnit IN ('day', 'week', 'month', 'quarter', 'year')),
  FOREIGN KEY(transaction_id) REFERENCES XXtransaction ON DELETE CASCADE);
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS category(
  id INTEGER,
  name STRING,
  icon INTEGER,
  color INTEGER,
  description STRING,
  is_hidden INTEGER,
  PRIMARY KEY(id),
  CHECK(is_hidden IN (0, 1)));
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS XXGroup(
  id INTEGER,
  name STRING,
  icon INTEGER,
  color INTEGER,
  description STRING,
  PRIMARY KEY(id));
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS saving(
  id INTEGER,
  name STRING,
  icon INTEGER,
  color INTEGER,
  balance REAL,
  start_date STRING,
  end_date STRING,
  goal REAL,
  description STRING,
  PRIMARY KEY(id));
  ''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS budget(
  id INTEGER,
  name STRING,
  icon INTEGER,
  color INTEGER,
  balance REAL,
  limitXX REAL,
  is_recurring INTEGER,
  intervalType STRING,
  intervalAmount INTEGER,
  intervalUnit STRING,
  start_date STRING,
  end_date STRING,
  description STRING,
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
    Map<String, dynamic> row = {
      'name': account.name,
      'icon': account.icon.codePoint,
      'color': account.color.value,
      'balance': account.balance,
      'description': account.description,
    };

    final db = await database;
    int id = await db.insert(
      'account',
      row,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    return id;
  }

  // Future<void> updateCategory(Category category) async {
  //   final db = await database;

  //   await db.update(
  //     'category',
  //     category.toMap(),
  //     where: 'category_id = ?',
  //     whereArgs: [category.category_id],
  //   );
  // }

  Future<List<Account>> getAccounts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('account');

    return List.generate(maps.length, (i) {
      return Account(
        id: maps[i]['id'],
        name: maps[i]['name'],
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(maps[i]['color']),
        balance: maps[i]['balance'],
        description: maps[i]['description'],
      );
    });
  }

  Future<void> deleteAccount(int accountID) async {
    final db = await database;

    await db.delete(
      'account',
      where: 'id = ?',
      whereArgs: [accountID],
    );
  }

  Future<int> createSingleTransaction(SingleTransaction transaction) async {
    final db = await database;

    Map<String, dynamic> rowTransaction = {
      'title': transaction.title,
      'value': transaction.value,
      'description': transaction.description,
      'category_id': transaction.category.id,
    };

    int transactionId = await db.insert(
      'transaction',
      rowTransaction,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    Map<String, dynamic> rowSingleTransaction = {
      'transaction_id': transactionId,
      'date': transaction.date,
    };

    int id = await db.insert(
      'transaction',
      rowSingleTransaction,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    return id;
  }

  Future<int> createCategory(TransactionCategory category) async {
    final db = await database;
    Map<String, dynamic> row = {
      'id': category.id,
      'name': category.name,
      'icon': category.icon.codePoint,
      'color': category.color.value,
      'description': category.description,
      'is_hidden': ((category.isHidden) ? 1 : 0),
    };

    int id = await db.insert(
      'transaction',
      row,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    return id;
  }
}
