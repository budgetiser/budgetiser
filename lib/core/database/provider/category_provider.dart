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
    Profiler.instance.start('getCategory $id');
    var db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('category', where: 'id = ?', whereArgs: [id]);

    Profiler.instance.end();
    return TransactionCategory(
      id: maps[0]['id'],
      name: maps[0]['name'],
      icon: IconData(maps[0]['icon'], fontFamily: 'MaterialIcons'),
      color: Color(maps[0]['color']),
      description: maps[0]['description'],
      archived: maps[0]['archived'] == 1,
    );
  }

  Future<List<TransactionCategory>> getAllCategories() async {
    var db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('category');

    return List.generate(maps.length, (i) {
      return TransactionCategory(
        id: maps[i]['id'],
        name: maps[i]['name'].toString(),
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(maps[i]['color']),
        description: maps[i]['description'],
        archived: maps[i]['is_hidden'] == 1,
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
        id,
        map['name'],
        map['icon'],
        map['color'],
        map['description'],
        map['archived'],
      ]);
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

    _notifyCategoryUpdate();
  }

  Future<void> updateCategory(TransactionCategory category) async {
    var db = await DatabaseHelper.instance.database;
    await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
    _notifyCategoryUpdate();
  }
}
