import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:budgetiser/db/recently_used.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/dataClasses/recurring_data.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/tempData/temp_data.dart';
import 'package:budgetiser/shared/utils/date_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

part 'account_part.dart';
part 'budget_part.dart';
part 'category_part.dart';
part 'group_part.dart';
part 'savings_part.dart';
part 'single_transaction_part.dart';
part 'sql_part.dart';
part 'stat_part.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static const databaseName = 'budgetiser.db';
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  static String? _passcode;
  final recentlyUsedAccount = RecentlyUsed<Account>();

  Future<Database> get database async =>
      _database ??= await initializeDatabase();

  Future<int> login(String passCode) async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('encrypted')) {
      preferences.setBool('encrypted', false);
    }
    _passcode = passCode;
    _database = await initializeDatabase();
    return _database != null ? (_database!.isOpen ? 1 : 0) : 0;
  }

  Future<int> createDatabase(String passCode) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool('encrypted', passCode != '' ? true : false);
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

  /// Clear db and reset (TODO some) shared preferences
  // ignore: always_declare_return_types
  resetDB() async {
    final Database db = await database;
    await _dropTables(db);
    await recentlyUsedAccount.removeAllItems();
    await _onCreate(db, 1);
  }

  void fillDBwithTMPdata() async {
    for (var account in TMP_DATA_accountList) {
      await createAccount(account);
    }
    for (var category in TMP_DATA_categoryList) {
      await createCategory(category);
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
      print('finished filling DB with TMP data');
    }
  }

  Future<Database> initializeDatabase() async {
    final preferences = await SharedPreferences.getInstance();
    var databasesPath = await getDatabasesPath();
    try {
      return await openDatabase(
        join(databasesPath, databaseName),
        version: 1,
        password: preferences.getBool('encrypted')! ? _passcode : null,
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
      throw Error();
    }
  }

  /// Exports the database to a file in the Download folder.
  void exportDB() async {
    final File db = File('${await getDatabasesPath()}/$databaseName');
    final fileContent = await db.readAsBytes();

    final externalDirectory =
        await getExternalStorageDirectories(type: StorageDirectory.downloads);
    final newFile = File('${externalDirectory?.first.path}/budgetiser.db');
    await newFile.writeAsBytes(fileContent);
  }

  /// Imports the database from a file in the Download folder. Overwrites the current database.
  void importDB() async {
    final externalDirectory =
        await getExternalStorageDirectories(type: StorageDirectory.downloads);
    final externalFile = File('${externalDirectory?.first.path}/budgetiser.db');
    final fileContent = await externalFile.readAsBytes();

    final db = File('${await getDatabasesPath()}/$databaseName');
    await db.writeAsBytes(fileContent);
  }

  void exportAsJson() async {
    var fullJSON = {};

    allAccountsStream.listen((event) {
      fullJSON['Accounts'] =
          event.map((element) => element.toJsonMap()).toList();
    });
    pushGetAllAccountsStream();
    await allAccountsStream.isEmpty;

    allBudgetsStream.listen((event) {
      fullJSON['Budgets'] =
          event.map((element) => element.toJsonMap()).toList();
    });
    pushGetAllBudgetsStream();
    await allBudgetsStream.first;

    allCategoryStream.listen((event) {
      fullJSON['Categories'] =
          event.map((element) => element.toJsonMap()).toList();
    });
    pushGetAllCategoriesStream();
    await allCategoryStream.first;

    allGroupsStream.listen((event) {
      fullJSON['Groups'] = event.map((element) => element.toJsonMap()).toList();
    });
    pushGetAllGroupsStream();
    await allGroupsStream.first;

    allSavingsStream.listen((event) {
      fullJSON['Savings'] =
          event.map((element) => element.toJsonMap()).toList();
    });
    pushGetAllSavingsStream();
    await allSavingsStream.first;

    allTransactionStream.listen((event) {
      fullJSON['Transactions'] =
          event.map((element) => element.toJsonMap()).toList();
    });
    pushGetAllTransactionsStream();
    await allTransactionStream.first;

    saveJsonToJsonFile(jsonEncode(fullJSON));
  }

  void saveJsonToJsonFile(String jsonString) async {
    final directory =
        await getExternalStorageDirectories(type: StorageDirectory.downloads);
    final file = File('${directory?.first.path}/budgetiser.json');
    await file.writeAsString(jsonString, mode: FileMode.write);
  }

  /*
  * All Stream Controller
  */
  final StreamController<List<Account>> _allAccountsStreamController =
      StreamController<List<Account>>.broadcast();

  final StreamController<List<SingleTransaction>>
      _allTransactionStreamController =
      StreamController<List<SingleTransaction>>.broadcast();

  final StreamController<List<TransactionCategory>>
      _allCategoryStreamController =
      StreamController<List<TransactionCategory>>.broadcast();

  final StreamController<List<Savings>> _allSavingsStreamController =
      StreamController<List<Savings>>.broadcast();

  final StreamController<List<Budget>> _allBudgetsStreamController =
      StreamController<List<Budget>>.broadcast();

  final StreamController<List<Group>> _allGroupsStreamController =
      StreamController<List<Group>>.broadcast();

  void dispose() {
    _allAccountsStreamController.close();
    _allTransactionStreamController.close();
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
