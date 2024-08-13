import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:flutter/foundation.dart';
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

  group('All Test cases should succeed', () {
    List<TestCase> testCases = [
      TestCaseLevel0(),
      TestCaseLevel1(),
      TestCaseLevel2(),
      TestCaseLevel3(),
    ];
    for (var testCase in testCases) {
      test('$testCase', () async {
        var db = await openDatabase(inMemoryDatabasePath);
        var dbh = DatabaseHelper.instance..setDatabase(db);
        await dbh.resetDB();

        await testCase.insertCategories();
        var expectedResult = testCase.getRelations();

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
            reason: 'Missing Relations for $testCase: $missingRelations');
        expect(categoryBridgeResults.length, expectedResult.length);
      });
    }
  });
}

List<Map<String, int>> getMissingRelations(
  List<Map<String, int>> expected,
  List<Map<String, dynamic>> actual,
) {
  List<Map<String, int>> missing = [];

  for (var expectItem in expected) {
    bool gotMatched = false;
    for (var actualItem in actual) {
      if (mapEquals(expectItem, actualItem)) {
        gotMatched = true;
        break;
      }
    }
    if (!gotMatched) {
      missing.add(expectItem);
    }
  }
  return missing;
}
