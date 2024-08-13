import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:flutter/material.dart';

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

  TestCaseLevel0missing5() {
    categories.removeAt(categories.length - 1);
  }

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

void connectCategories(TransactionCategory parent, TransactionCategory child) {
  child.parentID = parent.id;
}
