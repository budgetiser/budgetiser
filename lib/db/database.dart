import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:budgetiser/db/account_provider.dart';
import 'package:budgetiser/db/budget_provider.dart';
import 'package:budgetiser/db/category_provider.dart';
import 'package:budgetiser/db/recently_used.dart';
import 'package:budgetiser/db/single_transaction_provider.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/services/profiler.dart';
import 'package:budgetiser/shared/tempData/temp_data.dart';
import 'package:budgetiser/shared/utils/data_types_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

part 'sql_part.dart';
part 'stat_part.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static const databaseName = 'budgetiser.db';
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  final recentlyUsedAccount = RecentlyUsed<Account>();

  Future<Database> get database async =>
      _database ??= await initializeDatabase();

  /// Only for unittest
  void setDatabase(Database db) {
    _database = db;
  }

  /// Clear db and reset (TODO some) shared preferences
  // ignore: always_declare_return_types
  _resetDB(Database db, int newVersion) async {
    await _dropTables(db);
    await recentlyUsedAccount.removeAllItems();
    await _onCreate(db, newVersion);
  }

  /// Public method for resetting db
  // ignore: always_declare_return_types
  resetDB({int newVersion = 3}) async {
    final Database db = await database;
    await _resetDB(db, newVersion);
  }

  Future fillDBwithTMPdata() async {
    var length = TMP_DATA_accountList.length +
        TMP_DATA_categoryList.length +
        TMP_DATA_transactionList.length +
        TMP_DATA_budgetList.length;
    var i = 0;
    Profiler.instance.start('fill with TMP data');
    for (var account in TMP_DATA_accountList) {
      if (i % 100 == 0) {
        debugPrint('${num.parse(((i * 100) / length).toStringAsFixed(2))}\t\t');
      }
      i++;
      Profiler.instance.start('create account');
      await AccountModel().createAccount(account);
      Profiler.instance.end();
    }
    for (var category in TMP_DATA_categoryList) {
      if (i % 100 == 0) {
        debugPrint('${num.parse(((i * 100) / length).toStringAsFixed(2))}\t\t');
      }
      i++;
      Profiler.instance.start('create category');
      await CategoryModel().createCategory(category);
      Profiler.instance.end();
    }
    for (var transaction in TMP_DATA_transactionList) {
      if (i % 100 == 0) {
        debugPrint('${num.parse(((i * 100) / length).toStringAsFixed(2))}\t\t');
      }
      i++;
      Profiler.instance.start('create transaction');
      await TransactionModel().createSingleTransaction(
        transaction,
        notify: false,
      );
      Profiler.instance.end();
    }
    for (var budget in TMP_DATA_budgetList) {
      await BudgetModel().createBudget(budget);
    }
    debugPrint('finished filling DB with TMP data');
    Profiler.instance.end();
  }

  Future<Database> initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    try {
      return await openDatabase(
        join(databasesPath, databaseName),
        version: 3,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: (db, oldVersion, newVersion) async {
          await _resetDB(db, newVersion);
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

    await AccountModel().getAllAccounts().then((value) {
      fullJSON['Accounts'] = value.map((e) => e.toJsonMap()).toList();
    });

    await BudgetModel().getAllBudgets().then((value) {
      fullJSON['Budgets'] = value.map((e) => e.toJsonMap()).toList();
    });

    await CategoryModel().getAllCategories().then((value) {
      fullJSON['Categories'] = value.map((e) => e.toJsonMap()).toList();
    });

    await TransactionModel().getAllTransactions().then((value) {
      fullJSON['Transactions'] = value.map((e) => e.toJsonMap()).toList();
    });

    saveJsonToJsonFile(jsonEncode(fullJSON));
  }

  void importFromJson() async {
    String jsonString = await readJsonFromFile();
    Map<String, dynamic> jsonObject = jsonDecode(jsonString);

    assert(jsonObject['Accounts'] is List);
    assert(jsonObject['Budgets'] is List);
    assert(jsonObject['Categories'] is List);
    assert(jsonObject['Transactions'] is List);

    // clear db?
    await resetDB();

    // import data
    debugPrint('importing data from json...');
    for (var object in jsonObject['Accounts']) {
      Account account = Account.fromDBmap(object);
      await AccountModel().createAccount(account, keepId: true);
    }
    for (var object in jsonObject['Categories']) {
      TransactionCategory category = TransactionCategory.fromDBmap(object);
      await CategoryModel().createCategory(category, keepId: true);
    }
    for (var object in jsonObject['Budgets']) {
      Budget budget =
          Budget.fromDBmap(object, await CategoryModel().getAllCategories());
      await BudgetModel().createBudget(budget, keepId: true);
    }
    for (Map<String, dynamic> object in jsonObject['Transactions']) {
      SingleTransaction transaction = SingleTransaction.fromDBmap(
        object,
        category: await CategoryModel().getCategory(object['category_id']),
        account: await AccountModel().getOneAccount(object['account1_id']),
        account2: object['account2_id'] == null
            ? null
            : await AccountModel().getOneAccount(object['account2_id']),
      );
      await TransactionModel()
          .createSingleTransaction(transaction, keepId: true);
    }
    debugPrint('done importing data from json!');
  }

  void saveJsonToJsonFile(String jsonString) async {
    final directory =
        await getExternalStorageDirectories(type: StorageDirectory.downloads);
    final file = File('${directory?.first.path}/budgetiser.json');
    await file.writeAsString(jsonString, mode: FileMode.write);
  }

  Future<String> readJsonFromFile() async {
    final directory =
        await getExternalStorageDirectories(type: StorageDirectory.downloads);
    final file = File('${directory?.first.path}/budgetiser.json');

    try {
      if (await file.exists()) {
        String contents = await file.readAsString();
        return contents;
      } else {
        throw const FileSystemException('File not found');
      }
    } catch (e) {
      // Handle exceptions, such as File not found or other I/O errors.
      throw Exception('Error reading JSON file: $e');
    }
  }

  /*
  * All Stream Controller
  */
  final StreamController<List<Account>> _allAccountsStreamController =
      StreamController<List<Account>>.broadcast();

  final StreamController<List<TransactionCategory>>
      _allCategoryStreamController =
      StreamController<List<TransactionCategory>>.broadcast();

  final StreamController<List<Budget>> _allBudgetsStreamController =
      StreamController<List<Budget>>.broadcast();

  void dispose() {
    _allAccountsStreamController.close();
    _allCategoryStreamController.close();
    _allBudgetsStreamController.close();
  }
}
