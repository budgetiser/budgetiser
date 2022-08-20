import 'dart:async';
import 'dart:developer';
import 'dart:io';

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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

part 'sql_Part.dart';
part 'account_part.dart';
part 'stat_part.dart';
part 'single_transaction_part.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static const databaseName = 'budgetiser.db';
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  static String? _passcode;

  Future<Database> get database async =>
      _database ??= await initializeDatabase();

  Future<int> login(String passCode) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('encrypted')) {
      prefs.setBool('encrypted', false);
    }
    _passcode = passCode;
    _database = await initializeDatabase();
    return _database != null ? (_database!.isOpen ? 1 : 0) : 0;
  }

  Future<int> createDatabase(String passCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('encrypted', passCode != '' ? true : false);
    _passcode = passCode;
    _database = await initializeDatabase();
    return _database != null ? (_database!.isOpen ? 1 : 0) : 0;
  }

  void logout() async {
    final db = await database;
    if (db.isOpen) {
      db.close();
    }
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
    if (kDebugMode) {
      print("finished filling DB with TMP data");
    }
  }

  initializeDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    var databasesPath = await getDatabasesPath();
    try {
      return await openDatabase(
        join(databasesPath, databaseName),
        version: 1,
        password: prefs.getBool('encrypted')! ? _passcode : null,
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
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  /// Exports the database to a file in the Download folder.
  exportDB() async {
    final String path = '${await getDatabasesPath()}/$databaseName';
    final file = File(path);
    file.copy("/storage/emulated/0/Download/$databaseName");
  }

  /// Imports the database from a file in the Download folder. Overwrites the current database.
  importDB() async {
    final String path = '${await getDatabasesPath()}/$databaseName';
    final file = File("/storage/emulated/0/Download/$databaseName");
    file.copy(path);
  }

  /*
  * All Stream Controller
  */
  final StreamController<List<Account>> _allAccountsStreamController =
      StreamController<List<Account>>.broadcast();

  final StreamController<List<SingleTransaction>>
      _allTransactionStreamController =
      StreamController<List<SingleTransaction>>.broadcast();

  /*
  * RecurringTransaction
  */

  final StreamController<List<RecurringTransaction>>
      _allRecurringTransactionStreamController =
      StreamController<List<RecurringTransaction>>.broadcast();

  Sink<List<RecurringTransaction>> get allRecurringTransactionSink =>
      _allRecurringTransactionStreamController.sink;

  Stream<List<RecurringTransaction>> get allRecurringTransactionStream =>
      _allRecurringTransactionStreamController.stream;

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
    await deleteRecurringTransactionById(recurringTransaction.id);
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

  Future<void> deleteRecurringTransactionById(int id) async {
    final db = await database;

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
      where: 'recurring_transaction_id = ?',
      whereArgs: [id],
    );
    pushGetAllRecurringTransactionsStream();
  }

  /*
  * Single and Recurring Transaction
  */

  ///create a single transaction from a recurring transaction
  Future<int> createSingleTransactionFromRecurringTransaction(
      RecurringTransaction recurringTransaction) async {
    final db = await database;

    SingleTransaction singleTransaction = SingleTransaction(
      id: 0, // id will be overwritten by the database
      title: recurringTransaction.title,
      value: recurringTransaction.value,
      description: recurringTransaction.description,
      category: recurringTransaction.category,
      account: recurringTransaction.account,
      account2: recurringTransaction.account2,
      date: DateTime.now(),
    );

    int singleTransactionId = await createSingleTransaction(singleTransaction);

    await db.insert(
      'singleToRecurringTransaction',
      {
        'single_transaction_id': singleTransactionId,
        'recurring_transaction_id': recurringTransaction.id,
      },
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    return singleTransactionId;
  }

  /*
  * Category
  */

  final StreamController<List<TransactionCategory>>
      _allCategoryStreamController =
      StreamController<List<TransactionCategory>>.broadcast();

  Sink<List<TransactionCategory>> get allCategorySink =>
      _allCategoryStreamController.sink;

  Stream<List<TransactionCategory>> get allCategoryStream =>
      _allCategoryStreamController.stream;

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
    final List<Map<String, dynamic>> maps = await db.query('categoryToBudget',
        columns: ['budget_id'],
        where: 'category_id = ?',
        whereArgs: [categoryID],
        distinct: true);

    await db.delete(
      'category',
      where: 'id = ?',
      whereArgs: [categoryID],
    );

    for (int i = 0; i < maps.length; i++) {
      reloadBudgetBalanceFromID(maps[i]['budget_id']);
    }
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

  final StreamController<List<Savings>> _allSavingsStreamController =
      StreamController<List<Savings>>.broadcast();

  Sink<List<Savings>> get allSavingsSink => _allSavingsStreamController.sink;

  Stream<List<Savings>> get allSavingsStream =>
      _allSavingsStreamController.stream;

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

  final StreamController<List<Budget>> _allBudgetsStreamController =
      StreamController<List<Budget>>.broadcast();

  Sink<List<Budget>> get allBudgetsSink => _allBudgetsStreamController.sink;

  Stream<List<Budget>> get allBudgetsStream =>
      _allBudgetsStreamController.stream;

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
        balance: maps[i]['balance'] ?? 0,
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
        returnBudget.intervalRepetitions = maps[i]['interval_repititions'];
      }
      return returnBudget;
    }));
  }

  Future<Budget> _getBudgetToID(int budgetID) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('budget', where: 'id = ?', whereArgs: [budgetID]);
    List<List<TransactionCategory>> categoryList = [];
    for (int i = 0; i < maps.length; i++) {
      categoryList.add(await _getCategoriesToBudget(maps[i]['id']));
    }
    Budget returnBudget = Budget(
      id: maps[0]['id'],
      name: maps[0]['name'].toString(),
      icon: IconData(maps[0]['icon'], fontFamily: 'MaterialIcons'),
      color: Color(maps[0]['color']),
      balance: maps[0]['balance'] ?? 0,
      limit: maps[0]['limitXX'],
      startDate: DateTime.parse(maps[0]['start_date']),
      description: maps[0]['description'].toString(),
      isRecurring: maps[0]['is_recurring'] == 1,
      transactionCategories: categoryList[0],
    );
    if (maps[0]['is_recurring'] == 1) {
      returnBudget.endDate = DateTime.parse(maps[0]['end_date']);
      returnBudget.intervalUnit = IntervalUnit.values
          .firstWhere((e) => e.toString() == maps[0]['interval_unit']);
      returnBudget.intervalType = IntervalType.values
          .firstWhere((e) => e.toString() == maps[0]['interval_type']);
      returnBudget.intervalAmount = maps[0]['interval_amount'];
      returnBudget.intervalRepetitions = maps[0]['interval_repititions'];
    }
    return returnBudget;
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

    List<TransactionCategory> budgetCategories = budget.transactionCategories;

    for (int i = 0; i < budgetCategories.length; i++) {
      Map<String, dynamic> rowCategory = {
        'category_id': budgetCategories[i].id,
        'budget_id': id,
      };
      await db.insert(
        'categoryToBudget',
        rowCategory,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
    reloadBudgetBalanceFromID(id);
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
    List<TransactionCategory> budgetCategories = budget.transactionCategories;

    await db.delete(
      'categoryToBudget',
      where: 'budget_id = ?',
      whereArgs: [budget.id],
    );

    for (int i = 0; i < budgetCategories.length; i++) {
      Map<String, dynamic> rowCategory = {
        'category_id': budgetCategories[i].id,
        'budget_id': budget.id,
      };
      await db.insert(
        'categoryToBudget',
        rowCategory,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
    reloadBudgetBalanceFromID(budget.id);
    pushGetAllBudgetsStream();
  }

  void reloadBudgetBalanceFromID(int budgetID) async {
    final db = await database;
    //Get BudgetData
    Budget budget = await _getBudgetToID(budgetID);
    Map<String, DateTime> interval = budget.calculateCurrentInterval();

    if (budget.isRecurring) {
      await db.rawUpdate("""UPDATE budget SET balance =
            (
              SELECT -SUM(value)
              FROM singleTransaction
              INNER JOIN category ON category.id = singleTransaction.category_id
              INNER JOIN categoryToBudget ON category.id = categoryToBudget.category_id
              INNER JOIN budget ON categoryToBudget.budget_id = budget.id
              WHERE categoryToBudget.budget_id = ?
                  and ? <= singleTransaction.date
                  and ? >= singleTransaction.date
            )
        WHERE id = ?;
    """, [
        budgetID,
        interval['start'].toString().substring(0, 10),
        interval['end'].toString().substring(0, 10),
        budgetID,
      ]);
    } else {
      await db.rawUpdate("""UPDATE budget SET balance =
            (
              SELECT -SUM(value)
              FROM singleTransaction
              INNER JOIN category ON category.id = singleTransaction.category_id
              INNER JOIN categoryToBudget ON category.id = categoryToBudget.category_id
              INNER JOIN budget ON categoryToBudget.budget_id = budget.id
              WHERE categoryToBudget.budget_id = ?
                  and ? <= singleTransaction.date
            )
        WHERE id = ?;
    """, [
        budgetID,
        budget.startDate.toString().substring(0, 10),
        budgetID,
      ]);
    }
    pushGetAllBudgetsStream();
  }

  /// takes a long time
  void reloadAllBudgetBalance() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('budget', columns: ['id']);
    for (int i = 0; i < maps.length; i++) {
      reloadBudgetBalanceFromID(maps[i]['id']);
    }
    pushGetAllBudgetsStream();
  }

  /*
  * Group
  */
  final StreamController<List<Group>> _allGroupsStreamController =
      StreamController<List<Group>>.broadcast();

  Sink<List<Group>> get allGroupsSink => _allGroupsStreamController.sink;

  Stream<List<Group>> get allGroupsStream => _allGroupsStreamController.stream;

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

    List<TransactionCategory> groupCategories = group.transactionCategories;

    for (int i = 0; i < groupCategories.length; i++) {
      Map<String, dynamic> rowCategory = {
        'category_id': groupCategories[i].id,
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
    List<TransactionCategory> groupCategories = group.transactionCategories;

    await db.delete(
      'categoryToGroup',
      where: 'group_id = ?',
      whereArgs: [group.id],
    );

    for (int i = 0; i < groupCategories.length; i++) {
      Map<String, dynamic> rowCategory = {
        'category_id': groupCategories[i].id,
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

  /**
   * Helper methods
   */

  /// rounds to 2 decimal places by cutting off all digits after
  double _roundDouble(double value) {
    return double.parse(value.toStringAsFixed(2));
  }
}
