import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'category_bridge/category_test_cases.dart';

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

  test('Removing with children', () async {
    var db = await openDatabase(inMemoryDatabasePath);
    var dbh = DatabaseHelper.instance..setDatabase(db);
    await dbh.resetDB();

    var l1Cats = TestCaseLevel1();
    await l1Cats.insertCategories();

    try {
      await CategoryModel().removeFromCategoryBridgeByID(category2.id);
    } catch (e) {
      return;
    }
    fail('Exception not thrown');
  });
}
