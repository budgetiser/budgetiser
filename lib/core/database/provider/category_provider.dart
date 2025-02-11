import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/shared/services/profiler.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class CategoryModel extends ChangeNotifier {
  void _notifyCategoryUpdate() {
    notifyListeners();
  }

  /// Fetches category tree.
  /// Result Map can be used to query all categories for a list of their parents.
  ///
  /// Example:\
  /// 1: [2, 3]\
  /// 2: [3]\
  /// 3: [] (not included)\
  /// 4: [2, 3]\
  Future<Map<int, List<int>>> getParentsList() async {
    Profiler.instance.start('getParentsList');
    var db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categoryBridge',
      where: 'distance != 0',
      orderBy: 'distance ASC',
    );

    Map<int, List<int>> parentMap = {};

    for (var i = 0; i < maps.length; i++) {
      if (parentMap.containsKey(maps[i]['child_id'])) {
        parentMap[maps[i]['child_id']]!.add(maps[i]['parent_id']);
      } else {
        parentMap[maps[i]['child_id']] = [maps[i]['parent_id']];
      }
    }

    Profiler.instance.end();
    return parentMap;
  }

  Future<TransactionCategory> getCategory(int id) async {
    // TODO: hierarchical
    Profiler.instance.start('getCategory $id');
    var db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('category', where: 'id = ?', whereArgs: [id]);

    Profiler.instance.end();
    return TransactionCategory.fromDBmap(maps[0]);
  }

  Future<List<TransactionCategory>> getCategories(List<int> ids) async {
    var db = await DatabaseHelper.instance.database;
    if (ids.isEmpty) {
      return [];
    }
    final List<Map<String, dynamic>> maps =
        await db.query('category', where: 'id IN (${ids.join(",")})');

    return List.generate(maps.length, (i) {
      return TransactionCategory.fromDBmap(
        maps[i],
      );
    });
  }

  Future<void> moveCategory(
      TransactionCategory category, TransactionCategory? newParent) async {
    await moveCategoryByID(category.id, newParent?.id);
  }

  Future<void> moveCategoryByID(int category, int? newParent) async {
    var db = await DatabaseHelper.instance.database;
    await db.transaction((txn) async {
      // Unlink all links not coming from us or our children to
      // us or our children.
      String unlinkQuery = ('''
      DELETE FROM categoryBridge
      WHERE child_id IN(
        SELECT child_id
        FROM categoryBridge
        WHERE parent_id=?
      )
      AND parent_id IN(
        SELECT parent_id
        FROM categoryBridge
        WHERE child_id=?
        AND parent_id != child_id
      );
      ''');
      await txn.rawDelete(unlinkQuery, [category, category]);

      if (newParent != null) {
        // If newParent==null, we do not need to link us or our childs
        // to any other parents.
        String relinkQuery = ('''
        INSERT INTO categoryBridge
        SELECT a.parent_id, b.child_id, (a.distance+b.distance+1)
        FROM categoryBridge a
        CROSS JOIN categoryBridge b
        WHERE a.child_id=?
        AND b.parent_id=?;
        ''');
        await txn.rawInsert(relinkQuery, [newParent, category]);
      }
    });
  }

  Future<void> removeFromCategoryBridgeByID(int category) async {
    var db = await DatabaseHelper.instance.database;
    String unlinkQuery = ('''
      DELETE FROM categoryBridge
      WHERE child_id IN (
        SELECT child_id
        FROM categoryBridge
        WHERE parent_id = ?
      )
      AND NOT EXISTS(
        SELECT NULL
        FROM categoryBridge
        WHERE parent_id = ?
        AND child_id != parent_id
      );
      ''');
    int deletedRows = await db.rawDelete(unlinkQuery, [category, category]);
    if (deletedRows == 0) {
      throw Exception();
    }
  }

  Future<List<TransactionCategory>> getAllCategories() async {
    var db = await DatabaseHelper.instance.database;
    // final List<Map<String, dynamic>> map = await db.query('category');
    var map = await db.rawQuery('''
    SELECT 
        c.id,
        c.name,
        c.icon,
        c.color,
        c.description,
        c.archived,
        cb.parent_id,
        GROUP_CONCAT(cb2.child_id) AS children
    FROM 
        category c
    LEFT JOIN 
        categoryBridge cb ON c.id = cb.child_id
        AND cb.distance = 1
    LEFT JOIN 
        categoryBridge cb2 ON c.id = cb2.parent_id
        AND cb2.distance = 1
    GROUP BY 
        c.id, c.name, c.icon, c.color, c.description, c.archived, cb.parent_id;
    ''');
    var newMap = map.map(
      (e) {
        return Map.of(e);
      },
    ).toList();
    for (var i = 0; i < map.length; i++) {
      if (map[i]['children'] != null) {
        newMap[i]['children'] = map[i]['children']
            .toString()
            .split(',')
            .map((e) => int.parse(e))
            .toList();
      } else {
        newMap[i]['children'] = List<int>.empty();
      }
    }

    return List.generate(newMap.length, (i) {
      return TransactionCategory.fromDBmap(
        newMap[i],
      );
    });
  }

  /// adds category to database
  ///
  /// if [id] is not null the id will be used
  Future<int> createCategory(
    TransactionCategory category, {
    bool keepId = false,
  }) async {
    Profiler.instance.start('createCategory');
    final db = await DatabaseHelper.instance.database;
    Map<String, dynamic> map = category.toMap();
    int id = category.id;
    if (!keepId) {
      id = await db.insert(
        'category',
        map,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } else {
      await db.execute('''
        INSERT INTO category (id, name, icon, color, description, archived) 
        VALUES (?, ?, ?, ?, ?, ?);
      ''', [
        // TODO: why map
        id,
        map['name'],
        map['icon'],
        map['color'],
        map['description'],
        map['archived'],
      ]);
    }
    if (category.parentID != null) {
      // List<Map<String, dynamic>> ancestors = await db.rawQuery('''
      //   SELECT parent_id, descendant_id, distance
      //   FROM categoryBridge
      //   WHERE descendant_id = ?
      // ''', [category.ancestorID]);
      // ancestors.map((e) {
      //   e['child_id'] = category.id;
      //   e['distance'] += 1;
      // });
      // await db.update('categoryBridge', values)
      await db.execute('''
        INSERT INTO categoryBridge (parent_id, child_id, distance)
        SELECT parent_id, ?, distance + 1
        FROM categoryBridge
        WHERE child_id = ?;
        ''', [id, category.parentID]);
    }

    await db.insert(
      'categoryBridge',
      {'parent_id': id, 'child_id': id, 'distance': 0},
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    _notifyCategoryUpdate();
    Profiler.instance.end();
    return id;
  }

  Future<void> deleteCategory(int categoryID) async {
    var db = await DatabaseHelper.instance.database;
    await db.delete(
      'category',
      where: 'id = ?',
      whereArgs: [categoryID],
    );

    _notifyCategoryUpdate();
  }

  Future<void> updateCategory(TransactionCategory category) async {
    var db = await DatabaseHelper.instance.database;
    // Get old ancestor
    List<Map<String, dynamic>> oldAncestor = await db.query(
      'categoryBridge',
      where: 'child_id = ? AND distance = 1',
      whereArgs: [category.id],
    );
    // Normal update
    await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
    // Update bridge
    if (oldAncestor.isEmpty && category.parentID == null) {
      // no tree moving required (keep on toplevel)
      // TODO: (performance) no moving inside the tree
    } else {
      await moveCategoryByID(category.id, category.parentID);
    }
    _notifyCategoryUpdate();
  }
}
