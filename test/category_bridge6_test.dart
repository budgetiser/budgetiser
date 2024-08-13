import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'category_bridge/category_test_cases.dart';
import 'category_bridge/category_test_utils.dart';

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

  test('Removing wo. children', () async {
    var db = await openDatabase(inMemoryDatabasePath);
    var dbh = DatabaseHelper.instance..setDatabase(db);
    await dbh.resetDB();

    var rootCats = TestCaseLevel0();
    var rootCatsShort = TestCaseLevel0missing5();

    await rootCats.insertCategories();
    await CategoryModel().removeFromCategoryBridgeByID(category5.id);
    var expectedResult = rootCatsShort.getRelations();

    List<Map<String, dynamic>> categoryBridgeTable =
        await db.query('categoryBridge');
    categoryBridgeTable = categoryBridgeTable.toList();
    List<Map<String, int>> categoryBridgeResults = [];
    for (var element in categoryBridgeTable) {
      categoryBridgeResults.add(Map<String, int>.from(element));
    }

    var missingRelations =
        getMissingRelations(expectedResult, categoryBridgeResults);
    expect(missingRelations, [],
        reason: 'Missing Relations: $missingRelations');
    expect(categoryBridgeResults.length, expectedResult.length);
  });
}
