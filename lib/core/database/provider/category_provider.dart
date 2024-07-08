import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/shared/services/profiler.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class CategoryModel extends ChangeNotifier {
  void _notifyCategoryUpdate() {
    notifyListeners();
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

  Future<List<TransactionCategory>> getAllCategories() async {
    var db = await DatabaseHelper.instance.database;
    // final List<Map<String, dynamic>> map = await db.query('category');
    var map = await db.rawQuery('''
    WITH max_distance AS (
        SELECT 
            descendent_id,
            MAX(distance) AS max_distance
        FROM 
            categoryBridge
        GROUP BY 
            descendent_id
    )
    SELECT 
        c.id,
        c.name,
        c.icon,
        c.color,
        c.description,
        c.archived,
        cb.ancestor_id AS ancestorID,
        cb.distance AS level
    FROM 
        category c
    LEFT JOIN 
        categoryBridge cb 
        ON c.id = cb.descendent_id 
        AND NOT (cb.ancestor_id = c.id AND cb.distance = 0)
        AND cb.distance = (SELECT max_distance FROM max_distance WHERE max_distance.descendent_id = c.id);
    ''');

    return List.generate(map.length, (i) {
      return TransactionCategory.fromDBmap(
        map[i],
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
    if (category.ancestorID != null) {
      // List<Map<String, dynamic>> ancestors = await db.rawQuery('''
      //   SELECT ancestor_id, descendant_id, distance
      //   FROM categoryBridge
      //   WHERE descendant_id = ?
      // ''', [category.ancestorID]);
      // ancestors.map((e) {
      //   e['descendent_id'] = category.id;
      //   e['distance'] += 1;
      // });
      // await db.update('categoryBridge', values)
      await db.execute('''
        INSERT INTO categoryBridge (ancestor_id, descendent_id, distance)
        SELECT ancestor_id, ?, distance + 1
        FROM categoryBridge
        WHERE descendent_id = ?;
        ''', [id, category.ancestorID]);
    }

    await db.insert(
      'categoryBridge',
      {'ancestor_id': id, 'descendent_id': id, 'distance': 0},
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
    await db.delete(
      'categoryBridge',
      where: 'ancestor_id = ? OR descendent_id = ?',
      whereArgs: [categoryID, categoryID],
    );
    await db.execute('''
      DELETE FROM categoryBridge
      WHERE descendent_id IN (
        SELECT descendent_id
        FROM categoryBridge
        WHERE ancestor_id = ?
      )
    ''');

    _notifyCategoryUpdate();
  }

  Future<void> updateCategory(TransactionCategory category) async {
    var db = await DatabaseHelper.instance.database;
    // Get old ancestor
    List<Map<String, dynamic>> oldAncestor = await db.query(
      'categoryBridge',
      where: 'descendent_id = ? AND distance = 1',
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
    if (oldAncestor.length == 1 && category.ancestorID != null) {
      // move inside the tree
      await db.execute('''
        DELETE FROM categoryBridge
        WHERE descendent_id IN (
          SELECT descendent_id
          FROM categoryBridge
          WHERE ancestor_id = ?
        )
        AND ancestor_id IN (
          SELECT ancestor_id
          FROM categoryBridge
          WHERE descendent_id = ?
          AND ancestor_id != descendent_id
        );
      ''', [category.id, category.id]);
      await db.execute('''
        INSERT INTO categoryBridge (ancestor_id, descendent_id, distance)
        SELECT a.ancestor_id, b.descendent_id, a.distance+b.distance+1
        FROM categoryBridge a
        CROSS JOIN categoryBridge b
        WHERE a.descendent_id = ?
        AND b.ancestor_id = ?;
        ''', [category.ancestorID, category.id]);
    } else if (oldAncestor.length == 1 && category.ancestorID == null) {
      // move from tree to toplevel
      await db.execute('''
        DELETE FROM categoryBridge
        WHERE descendent_id IN (
          SELECT descendent_id
          FROM categoryBridge
          WHERE ancestor_id = ?
        )
        AND ancestor_id IN (
          SELECT ancestor_id
          FROM categoryBridge
          WHERE descendent_id = ?
          AND ancestor_id != descendent_id
        );
      ''', [
        category.id,
        category.id
      ]); // TODO: check why other args then in "move inside the tree"
    } else if (oldAncestor.isEmpty && category.ancestorID != null) {
      // move from top level to inside the tree
      var map = await db.rawQuery(
        '''
        SELECT a.ancestor_id, b.descendent_id, a.distance+b.distance+1 as distance
        FROM categoryBridge a
        CROSS JOIN categoryBridge b
        WHERE a.descendent_id = ?
        AND b.ancestor_id = ?;
        ''',
        [category.ancestorID, category.id],
      );
      for (var row in map) {
        await db.insert(
          'categoryBridge',
          row,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } else if (oldAncestor.isEmpty && category.ancestorID == null) {
      // no tree moving required (keep on toplevel)
      // TODO: (performance) no moving inside the tree
    } else {
      throw Exception('Unhandled path while moving category inside the tree');
    }
    _notifyCategoryUpdate();
  }
}
