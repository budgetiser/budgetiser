import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/dataClasses/recurring_data.dart';
import 'package:budgetiser/shared/dataClasses/recurring_transaction.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/tempData/temp_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

part 'account_part.dart';
part 'stat_part.dart';
part 'single_transaction_part.dart';
part 'recurring_transaction_part.dart';
part 'category_part.dart';
part 'savings_part.dart';
part 'budget_part.dart';
part 'sql_part.dart';
part 'group_part.dart';

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

  exportAsJson() async {
    String fullJSONstring = "";

    allAccountsStream.listen((event) {
      List<String> jsonList =
          event.map((element) => jsonEncode(element.toJsonMap())).toList();
      fullJSONstring += '{"Accounts": ${jsonList.toString()},';
    });
    pushGetAllAccountsStream();
    await allAccountsStream.isEmpty;

    allBudgetsStream.listen((event) {
      List<String> jsonList =
          event.map((element) => jsonEncode(element.toMap())).toList();
      fullJSONstring += '"Budgets": ${jsonList.toString()},';
    });
    pushGetAllBudgetsStream();
    await allBudgetsStream.first;

    allCategoryStream.listen((event) {
      List<String> jsonList =
          event.map((element) => jsonEncode(element.toJsonMap())).toList();
      fullJSONstring += '"Category": ${jsonList.toString()},';
    });
    pushGetAllCategoriesStream();
    await allCategoryStream.first;

    allGroupsStream.listen((event) {
      List<String> jsonList =
          event.map((element) => jsonEncode(element.toMap())).toList();
      fullJSONstring += '"Groups": ${jsonList.toString()},';
    });
    pushGetAllGroupsStream();
    await allGroupsStream.first;

    allRecurringTransactionStream.listen((event) {
      List<String> jsonList =
          event.map((element) => jsonEncode(element.toMap())).toList();
      fullJSONstring += '"RecurringTransaction": ${jsonList.toString()},';
    });
    pushGetAllRecurringTransactionsStream();
    await allRecurringTransactionStream.first;

    allSavingsStream.listen((event) {
      List<String> jsonList =
          event.map((element) => jsonEncode(element.toMap())).toList();
      fullJSONstring += '"Savings": ${jsonList.toString()},';
    });
    pushGetAllSavingsStream();
    await allSavingsStream.first;

    allTransactionStream.listen((event) {
      List<String> jsonList =
          event.map((element) => jsonEncode(element.toJsonMap())).toList();
      fullJSONstring += '"transactions": ${jsonList.toString()}}';
    });
    pushGetAllTransactionsStream();
    await allTransactionStream.first;

    saveJsonToFile(fullJSONstring);
  }

  void saveJsonToFile(String jsonString) async {
    // final directory = await getApplicationDocumentsDirectory();
    // final file = File('${directory.path}/players.json');
    final file = File('/storage/emulated/0/Download/budgetiser.json');
    await file.writeAsString("", mode: FileMode.write);
    await file.writeAsString(jsonString, mode: FileMode.append);
    if (kDebugMode) {
      print("saved");
    }
  }

  /*
  * All Stream Controller
  */
  final StreamController<List<Account>> _allAccountsStreamController =
      StreamController<List<Account>>.broadcast();

  final StreamController<List<SingleTransaction>>
      _allTransactionStreamController =
      StreamController<List<SingleTransaction>>.broadcast();

  final StreamController<List<RecurringTransaction>>
      _allRecurringTransactionStreamController =
      StreamController<List<RecurringTransaction>>.broadcast();

  final StreamController<List<TransactionCategory>>
      _allCategoryStreamController =
      StreamController<List<TransactionCategory>>.broadcast();

  final StreamController<List<Savings>> _allSavingsStreamController =
      StreamController<List<Savings>>.broadcast();

  final StreamController<List<Budget>> _allBudgetsStreamController =
      StreamController<List<Budget>>.broadcast();

  final StreamController<List<Group>> _allGroupsStreamController =
      StreamController<List<Group>>.broadcast();

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

  void dispose() {
    _allAccountsStreamController.close();
    _allTransactionStreamController.close();
    _allRecurringTransactionStreamController.close();
    _allCategoryStreamController.close();
    _allSavingsStreamController.close();
    _allBudgetsStreamController.close();
    _allGroupsStreamController.close();
  }

  /**
   * Helper methods
   */

  /// rounds to 2 decimal places by cutting off all digits after
  double _roundDouble(double value) {
    return double.parse(value.toStringAsFixed(2));
  }
}
