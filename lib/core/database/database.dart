import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/database/provider/budget_provider.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/core/database/temporary_data/dataset.dart';
import 'package:budgetiser/shared/services/profiler.dart';
import 'package:budgetiser/shared/services/recently_used.dart';
import 'package:budgetiser/shared/utils/data_types_utils.dart';
import 'package:budgetiser/shared/utils/sql_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

part 'json_part.dart';
part 'sql_part.dart';
part 'stat_part.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static const databaseName = 'budgetiser.db';
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  final recentlyUsedAccount = RecentlyUsed<Account>();
  final recentlyUsedCategory = RecentlyUsed<TransactionCategory>();

  static const int currentDatabaseVersion = 4;

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
    await recentlyUsedCategory.removeAllItems();
    await _onCreate(db, newVersion);
  }

  /// Public method for resetting db
  // ignore: always_declare_return_types
  resetDB({int newVersion = currentDatabaseVersion}) async {
    final Database db = await database;
    await _resetDB(db, newVersion);
  }

  Future fillDBwithTMPdata(DemoDataset dataset) async {
    var accounts = dataset.getAccounts();
    var budgets = dataset.getBudgets();
    var categories = dataset.getCategories();
    var transactions = dataset.getTransactions();
    var length = accounts.length +
        budgets.length +
        categories.length +
        transactions.length;
    var i = 0;
    Profiler.instance.start('fill with TMP data');
    for (var account in accounts) {
      if (i % 100 == 0) {
        debugPrint('${num.parse(((i * 100) / length).toStringAsFixed(2))}\t\t');
      }
      i++;
      Profiler.instance.start('create account');
      await AccountModel().createAccount(account);
      Profiler.instance.end();
    }
    for (var category in categories) {
      if (i % 100 == 0) {
        debugPrint('${num.parse(((i * 100) / length).toStringAsFixed(2))}\t\t');
      }
      i++;
      Profiler.instance.start('create category');
      await CategoryModel().createCategory(category, keepId: true);
      Profiler.instance.end();
    }
    for (var transaction in transactions) {
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
    for (var budget in budgets) {
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
        version: currentDatabaseVersion,
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

    if (!await FlutterFileDialog.isPickDirectorySupported()) {
      debugPrint('Picking directory not supported');
      Exception('Picking directory not supported ');
    }

    final pickedDirectory = await FlutterFileDialog.pickDirectory();

    if (pickedDirectory != null) {
      final filePath = await FlutterFileDialog.saveFileToDirectory(
        directory: pickedDirectory,
        data: newFile.readAsBytesSync(),
        mimeType: 'application/db', // TODO: bug: name when file already exists
        fileName: 'budgetiser.db',
        replace: true,
      );
      debugPrint('saved db to: $filePath');
    }
  }

  Future<Uint8List> getDatabaseContent() async {
    final File db = File('${await getDatabasesPath()}/$databaseName');
    final fileContent = await db.readAsBytes();

    return fileContent;
  }

  /// Imports the database from a file in the Download folder. Overwrites the current database.
  void importDatabaseFromPath(String path) async {
    Uint8List fileContent = await File(path).readAsBytes();
    final dbPath = File('${await getDatabasesPath()}/$databaseName');
    await dbPath.writeAsBytes(fileContent);
  }
}
