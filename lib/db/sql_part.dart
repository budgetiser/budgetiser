// ignore_for_file: always_declare_return_types

part of 'database.dart';

extension DatabaseExtensionSQL on DatabaseHelper {
  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion >= 2 && oldVersion < 2) {
      if (kDebugMode) {
        print('deleting savings table if existent');
      }
      await db.execute('''
          DROP TABLE IF EXISTS saving;
          ''');
    }
    if (newVersion >= 3 && oldVersion < 3) {
      await upgradeToV3(db);
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
        archived INTEGER NOT NULL DEFAULT 0,
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
        archived INTEGER NOT NULL DEFAULT 0,
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
        interval_index INTEGER NOT NULL,
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

Future<void> upgradeToV3(Database db) async {
  if (kDebugMode) {
    print('upgrading to DB V3...');
  }
  await db.transaction((txn) async {
    await txn.execute('PRAGMA foreign_keys = OFF;');

    // account
    await txn.execute('''
      CREATE TABLE IF NOT EXISTS NEW_account(
        id INTEGER NOT NULL,
        name TEXT NOT NULL,
        icon INTEGER NOT NULL,
        color INTEGER NOT NULL,
        balance REAL NOT NULL,
        description TEXT,
        archived INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY(id),
        CHECK(archived IN (0, 1))
        );
    ''');

    await txn.execute('''
      INSERT INTO NEW_account (id, name, icon, color, balance, description) 
      SELECT id, name, icon, color, balance, description FROM account;
    ''');

    await txn.execute('''
      UPDATE NEW_account SET description = NULL
      WHERE description = '';
    ''');

    await txn.execute('''
      DROP TABLE account;
    ''');

    await txn.execute('''
      ALTER TABLE NEW_account RENAME TO account;
    ''');

    // category
    await txn.execute('''
      CREATE TABLE IF NOT EXISTS NEW_category(
        id INTEGER NOT NULL,
        name TEXT NOT NULL,
        icon INTEGER NOT NULL,
        color INTEGER NOT NULL,
        description TEXT,
        archived INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY(id),
        CHECK(archived IN (0, 1))
      );
    ''');

    await txn.execute('''
      INSERT INTO NEW_category (id, name, icon, color, archived, description) 
      SELECT id, name, icon, color, is_hidden, description FROM category;
    ''');

    await txn.execute('''
      UPDATE NEW_category SET description = NULL
      WHERE description = '';
    ''');

    await txn.execute('''
      DROP TABLE category;
    ''');

    await txn.execute('''
      ALTER TABLE NEW_category RENAME TO category;
    ''');

    // singleTransaction
    await txn.execute('''
      CREATE TABLE IF NOT EXISTS NEW_singleTransaction(
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

    final List<Map<String, dynamic>> mapSingle = await txn.rawQuery(
      '''SELECT DISTINCT *, category.icon AS category_icon, category.color AS category_color, category.id AS category_id, category.name AS category_name,
      account.icon AS account_icon, account.color AS account_color, account.id AS account_id, account.name AS account_name, account.balance AS account_balance,
      singleTransaction.description AS description, singleTransaction.id AS id
      FROM singleTransaction, singleTransactionToAccount, category, account
      WHERE account.id = singleTransactionToAccount.account1_id 
      AND singleTransactionToAccount.transaction_id = singleTransaction.id
      AND category.id = singleTransaction.category_id;
      ''',
    );

    for (Map<String, dynamic> transaction in mapSingle) {
      transaction = Map.of(transaction);
      transaction['date'] =
          DateTime.parse(transaction['date']).millisecondsSinceEpoch;
      if (transaction['description'] == '') {
        await txn.execute('''
        INSERT INTO NEW_singleTransaction (id, title, value, category_id, date, account1, account2) 
        VALUES (?, ?, ?, ?, ?, ?, ?);
      ''', [
          transaction['id'],
          transaction['title'],
          transaction['value'],
          transaction['category_id'],
          transaction['date'],
          transaction['account1_id'],
          transaction['account2_id']
        ]);
      } else {
        await txn.execute('''
        INSERT INTO NEW_singleTransaction (id, title, value, description, category_id, date, account1, account2) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?);
      ''', [
          transaction['id'],
          transaction['title'],
          transaction['value'],
          transaction['description'],
          transaction['category_id'],
          transaction['date'],
          transaction['account1_id'],
          transaction['account2_id']
        ]);
      }
    }

    await txn.execute('''
      DROP TABLE singleTransaction;
    ''');

    await txn.execute('''
      ALTER TABLE NEW_singleTransaction RENAME TO singleTransaction;
    ''');

    // budgets
    await txn.execute('''
      CREATE TABLE IF NOT EXISTS NEW_budget(
        id INTEGER NOT NULL,
        name TEXT NOT NULL,
        icon INTEGER NOT NULL,
        color INTEGER NOT NULL,
        max_value REAL NOT NULL,
        interval_unit TEXT NOT NULL,
        interval_index INTEGER NOT NULL,
        interval_repetitions INTEGER,
        start_date INTEGER NOT NULL,
        end_date INTEGER,
        description TEXT,
        PRIMARY KEY(id),
        CHECK(interval_unit IN ('IntervalUnit.day', 'IntervalUnit.week', 'IntervalUnit.month', 'IntervalUnit.quarter', 'IntervalUnit.year'))
      );
    ''');

    final List<Map<String, dynamic>> mapBudgets = await txn.rawQuery(
      '''SELECT id, name, icon, color, limitXX, is_recurring, interval_unit, interval_repititions, start_date, end_date, description FROM budget;
      ''',
    );

    for (Map<String, dynamic> item in mapBudgets) {
      item = Map.of(item);
      if (item['is_recurring'] != 1) {
        item['interval_unit'] = 'IntervalUnit.month';
        item['interval_repetitions'] = null;
      }
      item['start_date'] =
          DateTime.parse(item['start_date']).millisecondsSinceEpoch;
      item['end_date'] = item['end_date'] == null
          ? null
          : DateTime.parse(item['end_date']).millisecondsSinceEpoch;
      await txn.execute('''
        INSERT INTO NEW_budget (id, name, icon, color, max_value, interval_unit, interval_index, interval_repetitions, start_date, end_date, description) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''', [
        item['id'],
        item['name'],
        item['icon'],
        item['color'],
        item['limitXX'],
        item['interval_unit'],
        0,
        item['interval_repititions'],
        item['start_date'],
        item['end_date'],
        item['description'] == '' ? null : item['description']
      ]);
    }

    await txn.execute('''
      DROP TABLE budget;
    ''');

    await txn.execute('''
      ALTER TABLE NEW_budget RENAME TO budget;
    ''');

    // categoryBridge
    await txn.execute('''
      CREATE TABLE IF NOT EXISTS categoryBridge(
        ancestor_id INTEGER NOT NULL,
        descendent_id INTEGER NOT NULL,
        distance INTEGER NOT NULL,
        PRIMARY KEY(ancestor_id, descendent_id),
        FOREIGN KEY(ancestor_id) REFERENCES category ON DELETE CASCADE,
        FOREIGN KEY(descendent_id) REFERENCES category ON DELETE CASCADE
        );
    ''');

    final List<Map<String, dynamic>> mapBridge = await txn.rawQuery(
      '''SELECT id FROM category;
      ''',
    );

    for (Map<String, dynamic> item in mapBridge) {
      item = Map.of(item);
      await txn.execute('''
        INSERT INTO categoryBridge (ancestor_id, descendent_id, distance) 
        VALUES (?, ?, ?);
      ''', [item['id'], item['id'], 0]);
    }

    // final
    await txn.execute('DROP TABLE categoryToGroup;');
    await txn.execute('DROP TABLE XXGroup;');
    await txn.execute('DROP TABLE singleTransactionToAccount;');

    await txn.execute('PRAGMA foreign_key_check;');
    await txn.execute('PRAGMA foreign_keys = ON;');
  });

  if (kDebugMode) {
    print('upgrade to DB V3 done!');
  }
}
