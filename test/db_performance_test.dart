import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/temporary_data/datasets/old.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

void main() {
  // Setup sqflite_common_ffi for flutter test
  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  });
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test('Performance: Refill DB with TMP data', () async {
    var db = await openDatabase(
      inMemoryDatabasePath,
    );
    var dbh = DatabaseHelper.instance..setDatabase(db);

    final stopwatch = Stopwatch()..start();

    await dbh.resetDB();
    await dbh.fillDBwithTMPdata(OldDataset());

    stopwatch.stop();

    if (kDebugMode) {
      print('refilled DB in ${stopwatch.elapsed}');
    }

    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 1)));
  });
}
