import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/tempData/temp_data.dart';
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
    await dbh.fillDBwithTMPdata();

    final stopwatch = Stopwatch()..start();

    List<SingleTransaction>? streamContent;
    var transactions = dbh.allTransactionStream.listen((event) {
      streamContent = event;
    });
    await dbh.pushGetAllTransactionsStream();

    stopwatch.stop();
    transactions.cancel();

    if (kDebugMode) {
      print('got Transaction stream in ${stopwatch.elapsed}');
    }

    expect(streamContent!.length, equals(TMP_DATA_transactionList.length));
    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 1)));
  });
  test('Performance: Fetch all TMP categories', () async {
    var db = await openDatabase(
      inMemoryDatabasePath,
    );
    var dbh = DatabaseHelper.instance..setDatabase(db);
    await dbh.resetDB();
    await dbh.fillDBwithTMPdata();

    final stopwatch = Stopwatch()..start();

    dbh.pushGetAllCategoriesStream();
    var stream = await dbh.allCategoryStream.first;

    stopwatch.stop();

    if (kDebugMode) {
      print('got Categories stream in ${stopwatch.elapsed}');
    }

    expect(stream.length, equals(TMP_DATA_categoryList.length));
    expect(stopwatch.elapsed, lessThan(const Duration(milliseconds: 100)));
  });
}
