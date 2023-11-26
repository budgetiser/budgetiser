// ignore_for_file: always_declare_return_types

part of 'database.dart';

extension DatabaseExtensionSQL on DatabaseHelper {
  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion >= 2) {
      if (kDebugMode) {
        print('deleting savings table if existent');
      }
      await db.execute('''
          DROP TABLE IF EXISTS saving;
          ''');
    }
  }

  _onCreate(Database db, int version) async {
    if (kDebugMode) {
      print('creating database version $version');
    }
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS account(
        id INTEGER NOT NULL,
        name TEXT NOT NULL,
        icon INTEGER NOT NULL,
        color INTEGER NOT NULL,
        balance REAL NOT NULL,
        description TEXT,
        archived INTEGER NOT NULL,
        PRIMARY KEY(id),
        CHECK(archived IN (0, 1))
        );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS category(
        id INTEGER NOT NULL,
        name TEXT NOT NULL,
        icon INTEGER NOT NULL,
        color INTEGER NOT NULL,
        description TEXT,
        archived INTEGER NOT NULL,
        PRIMARY KEY(id),
        CHECK(archived IN (0, 1))
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS singleTransaction(
        id INTEGER NOT NULL,
        title TEXT NOT NULL,
        value REAL NOT NULL,
        description TEXT,
        category_id INTEGER NOT NULL,
        date INTEGER NOT NULL,
        account1 INTEGER NOT NULL,
        account2 INTEGER,
        PRIMARY KEY(id),
        FOREIGN KEY(category_id) REFERENCES category ON DELETE CASCADE,
        FOREIGN KEY(account1) REFERENCES account ON DELETE CASCADE,
        FOREIGN KEY(account2) REFERENCES account ON DELETE CASCADE
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS budget(
        id INTEGER NOT NULL,
        name TEXT NOT NULL,
        icon INTEGER NOT NULL,
        color INTEGER NOT NULL,
        max_value REAL NOT NULL,
        interval_unit TEXT NOT NULL,
        interval_repetitions INTEGER,
        start_date INTEGER NOT NULL,
        end_date INTEGER,
        description TEXT,
        PRIMARY KEY(id),
        CHECK(interval_unit IN ('IntervalUnit.day', 'IntervalUnit.week', 'IntervalUnit.month', 'IntervalUnit.quarter', 'IntervalUnit.year'))
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS categoryToBudget(
        category_id INTEGER,
        budget_id INTEGER,
        PRIMARY KEY(category_id, budget_id),
        FOREIGN KEY(budget_id) REFERENCES budget ON DELETE CASCADE,
        FOREIGN KEY(category_id) REFERENCES category ON DELETE CASCADE
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS categoryBridge(
        ancestor_id INTEGER NOT NULL,
        descendent_id INTEGER NOT NULL,
        distance INTEGER NOT NULL,
        PRIMARY KEY(ancestor_id, descendent_id),
        FOREIGN KEY(ancestor_id) REFERENCES category ON DELETE CASCADE,
        FOREIGN KEY(descendent_id) REFERENCES category ON DELETE CASCADE
        );
    ''');
    if (kDebugMode) {
      print('done initializing tables');
    }
  }

  _dropTables(Database db) async {
    await db.execute('''
          DROP TABLE IF EXISTS XXGroup;
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
          DROP TABLE IF EXISTS singleTransaction;
          ''');
    await db.execute('''
          DROP TABLE IF EXISTS category;
          ''');
  }
}
