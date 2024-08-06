import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

TransactionCategory category0 = TransactionCategory(
  id: 0,
  name: 'category0',
  icon: Icons.abc,
  color: Colors.red,
);
TransactionCategory category1 = TransactionCategory(
  id: 1,
  name: 'category1',
  icon: Icons.abc,
  color: Colors.red,
);
TransactionCategory category2 = TransactionCategory(
  id: 2,
  name: 'category2',
  icon: Icons.abc,
  color: Colors.red,
);
TransactionCategory category3 = TransactionCategory(
  id: 3,
  name: 'category3',
  icon: Icons.abc,
  color: Colors.red,
);
TransactionCategory category4 = TransactionCategory(
  id: 4,
  name: 'category4',
  icon: Icons.abc,
  color: Colors.red,
);
TransactionCategory category5 = TransactionCategory(
  id: 5,
  name: 'category5',
  icon: Icons.abc,
  color: Colors.red,
);

abstract class TestCase {
  List<Map<String, int>> relations = [];
  List<TransactionCategory> categories = [
    category0,
    category1,
    category2,
    category3,
    category4,
    category5,
  ];

  void _createZeroDistanceRelations() {
    for (var category in categories) {
      relations.add({
        'parent_id': category.id,
        'child_id': category.id,
        'distance': 0,
      });
    }
  }

  Future<void> insertCategories() async {
    _connectCategories();
    for (var category in categories) {
      await CategoryModel().createCategory(category, keepId: true);
    }
  }

  void _connectCategories();
  void _createComplexRelations();

  List<Map<String, int>> getRelations() {
    _createZeroDistanceRelations();
    _createComplexRelations();
    return relations;
  }
}

class TestCaseLevel0 extends TestCase {
  // Cat0
  // Cat1
  // Cat2
  // Cat3
  // Cat4
  // Cat5

  @override
  void _createComplexRelations() {}

  @override
  void _connectCategories() {}
}

class TestCaseLevel0missing5 extends TestCase {
  // Cat0
  // Cat1
  // Cat2
  // Cat3
  // Cat4

  @override
  List<TransactionCategory> categories = [
    category0,
    category1,
    category2,
    category3,
    category4,
  ];

  @override
  void _createComplexRelations() {}

  @override
  void _connectCategories() {}
}

class TestCaseLevel1 extends TestCase {
  // Cat0
  //  - Cat1
  // Cat2
  //  - Cat3
  // Cat4
  //  - Cat5

  @override
  void _createComplexRelations() {
    relations.addAll([
      {'parent_id': 0, 'child_id': 1, 'distance': 1},
      {'parent_id': 2, 'child_id': 3, 'distance': 1},
      {'parent_id': 4, 'child_id': 5, 'distance': 1},
    ]);
  }

  @override
  void _connectCategories() {
    connectCategories(categories[0], categories[1]);
    connectCategories(categories[2], categories[3]);
    connectCategories(categories[4], categories[5]);
  }
}

class TestCaseLevel2 extends TestCase {
  // Cat0
  //  - Cat1
  //    - Cat2
  //  - Cat3
  // Cat4
  //  - Cat5

  @override
  void _createComplexRelations() {
    relations.addAll([
      {'parent_id': 0, 'child_id': 1, 'distance': 1},
      {'parent_id': 0, 'child_id': 2, 'distance': 2},
      {'parent_id': 1, 'child_id': 2, 'distance': 1},
      {'parent_id': 0, 'child_id': 3, 'distance': 1},
      {'parent_id': 4, 'child_id': 5, 'distance': 1},
    ]);
  }

  @override
  void _connectCategories() {
    connectCategories(categories[0], categories[1]);
    connectCategories(categories[1], categories[2]);
    connectCategories(categories[0], categories[3]);
    connectCategories(categories[4], categories[5]);
  }
}

class TestCaseLevel3 extends TestCase {
  // Cat0
  //  - Cat1
  //    - Cat2
  //      - Cat3
  // Cat4
  //  - Cat5

  @override
  void _createComplexRelations() {
    relations.addAll([
      {'parent_id': 0, 'child_id': 1, 'distance': 1},
      {'parent_id': 0, 'child_id': 2, 'distance': 2},
      {'parent_id': 0, 'child_id': 3, 'distance': 3},
      {'parent_id': 1, 'child_id': 2, 'distance': 1},
      {'parent_id': 1, 'child_id': 3, 'distance': 2},
      {'parent_id': 2, 'child_id': 3, 'distance': 1},
      {'parent_id': 4, 'child_id': 5, 'distance': 1},
    ]);
  }

  @override
  void _connectCategories() {
    connectCategories(categories[0], categories[1]);
    connectCategories(categories[1], categories[2]);
    connectCategories(categories[2], categories[3]);
    connectCategories(categories[4], categories[5]);
  }
}

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

  test('Nested->Root', () async {
    var db = await openDatabase(inMemoryDatabasePath);
    var dbh = DatabaseHelper.instance..setDatabase(db);
    await dbh.resetDB();

    var rootCats = TestCaseLevel0();
    var l1Cats = TestCaseLevel1();

    await l1Cats.insertCategories();
    await CategoryModel().moveCategory(category1, null);
    await CategoryModel().moveCategory(category3, null);
    await CategoryModel().moveCategory(category5, null);
    var expectedResult = rootCats.getRelations();

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

  test('Root->Nested', () async {
    var db = await openDatabase(inMemoryDatabasePath);
    var dbh = DatabaseHelper.instance..setDatabase(db);
    await dbh.resetDB();

    var rootCats = TestCaseLevel0();
    var l1Cats = TestCaseLevel1();

    await rootCats.insertCategories();
    await CategoryModel().moveCategory(category1, category0);
    await CategoryModel().moveCategory(category3, category2);
    await CategoryModel().moveCategory(category5, category4);
    var expectedResult = l1Cats.getRelations();

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

  test('Deep Nested->Nested Root', () async {
    var db = await openDatabase(inMemoryDatabasePath);
    var dbh = DatabaseHelper.instance..setDatabase(db);
    await dbh.resetDB();

    var l1Cats = TestCaseLevel1();
    var l3Cats = TestCaseLevel3();

    await l3Cats.insertCategories();
    await CategoryModel().moveCategory(category2, null);
    var expectedResult = l1Cats.getRelations();

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

  test('Nested Root->Deep Nested', () async {
    var db = await openDatabase(inMemoryDatabasePath);
    var dbh = DatabaseHelper.instance..setDatabase(db);
    await dbh.resetDB();

    var l1Cats = TestCaseLevel1();
    var l3Cats = TestCaseLevel3();

    await l1Cats.insertCategories();
    await CategoryModel().moveCategory(category2, category1);
    var expectedResult = l3Cats.getRelations();

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

void connectCategories(TransactionCategory parent, TransactionCategory child) {
  child.parentID = parent.id;
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
