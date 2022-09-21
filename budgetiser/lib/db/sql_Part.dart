part of "database.dart";

extension DatabaseExtension on DatabaseHelper {
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
  interval_repititions INTEGER,
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
  FOREIGN KEY(account1_id) REFERENCES account ON DELETE CASCADE,
  FOREIGN KEY(account2_id) REFERENCES account ON DELETE CASCADE,
  FOREIGN KEY(transaction_id) REFERENCES singleTransaction ON DELETE CASCADE);
''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS recurringTransactionToAccount(
  transaction_id INTEGER,
  account1_id INTEGER,
  account2_id INTEGER,
  PRIMARY KEY(transaction_id, account1_id, account2_id),
  FOREIGN KEY(account1_id) REFERENCES account ON DELETE CASCADE,
  FOREIGN KEY(account2_id) REFERENCES account ON DELETE CASCADE,
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
}
