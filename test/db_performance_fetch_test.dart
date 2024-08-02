import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/core/database/temporary_data/datasets/old.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

void main() {
  // Setup sqflite_common_ffi for flutter test
  setUpAll(() async {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  });
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test('Performance: Fetch all TMP Transactions', () async {
    var db = await openDatabase(
      inMemoryDatabasePath,
    );
    var dbh = DatabaseHelper.instance..setDatabase(db);
    await dbh.resetDB();
    await dbh.fillDBwithTMPdata(OldDataset());

    final stopwatch = Stopwatch()..start();

    List<SingleTransaction> allTransactions =
        await TransactionModel().getAllTransactions();

    stopwatch.stop();

    if (kDebugMode) {
      print('got Transaction stream in ${stopwatch.elapsed}');
    }

    expect(
        allTransactions.length, equals(OldDataset().getTransactions().length));
    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 1)));
  });
  test('Performance: Fetch all TMP categories', () async {
    var db = await openDatabase(
      inMemoryDatabasePath,
    );
    var dbh = DatabaseHelper.instance..setDatabase(db);
    await dbh.resetDB();
    await dbh.fillDBwithTMPdata(OldDataset());

    final stopwatch = Stopwatch()..start();

    var fetchedData = await CategoryModel().getAllCategories();

    stopwatch.stop();

    if (kDebugMode) {
      print('got Categories stream in ${stopwatch.elapsed}');
    }

    expect(fetchedData.length, equals(OldDataset().getCategories().length));
    expect(stopwatch.elapsed, lessThan(const Duration(milliseconds: 100)));
  });
}
