import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/services/profiler.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class CategoryModel extends ChangeNotifier {
  void _notifyCategoryUpdate() {
    notifyListeners();
  }

  Future<TransactionCategory> getCategory(int id) async {
    var db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('category', where: 'id = ?', whereArgs: [id]);

    return TransactionCategory(
      id: maps[0]['id'],
      name: maps[0]['name'],
      icon: IconData(maps[0]['icon'], fontFamily: 'MaterialIcons'),
      color: Color(maps[0]['color']),
      description: maps[0]['description'],
      archived: maps[0]['is_hidden'] == 1,
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
        description: maps[i]['description'].toString(),
        archived: maps[i]['is_hidden'] == 1,
      );
    });
  }

  Future<int> createCategory(TransactionCategory category) async {
    Profiler.instance.start('createCategory');
    var db = await DatabaseHelper.instance.database;
    Map<String, dynamic> row = {
      'name': category.name,
      'icon': category.icon.codePoint,
      'color': category.color.value,
      'description': category.description,
      'is_hidden': ((category.archived) ? 1 : 0),
    };

    int id = await db.insert(
      'category',
      row,
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
    await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
    _notifyCategoryUpdate();
  }
}
