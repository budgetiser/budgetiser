import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static const databaseName = 'database1314.db';
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async =>
      _database ??= await initializeDatabase();

  _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE account( 
  accountID INTEGER PRIMARY KEY AUTOINCREMENT, 
  name STRING,  
  icon STRING, 
  color INTEGER, 
  balance REAL,
  description STRING
); 
CREATE TABLE transaction(  
  transactionID INTEGER PRIMARY KEY AUTOINCREMENT, 
  title STRING, 
  value REAL, 
  description STRING,
);
''');
  }

  _dropTables(Database db) async {
    await db.execute('''
          DROP TABLE IF EXISTS account; 
          DROP TABLE IF EXISTS transaction
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
        id: maps[i]['accountID'],
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
      where: 'accountID = ?',
      whereArgs: [accountID],
    );
  }
}
