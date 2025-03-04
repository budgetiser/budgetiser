import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class BudgetModel extends ChangeNotifier {
  Future<Budget> getBudget(int id) async {
    final db = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> budgetMap = await db.query(
      'budget',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (budgetMap.isEmpty) {
      throw ErrorDescription('budget id:$id not found');
    }

    List<TransactionCategory> categoryList =
        await _getBudgetCategories(budgetMap[0]['id']);

    Budget budget = Budget.fromDBmap(budgetMap[0], categoryList);
    budget.value = await _calculateBudgetValue(budget);

    return budget;
  }

  Future<List<Budget>> getAllBudgets() async {
    final Database db = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> budgetsMap = await db.query('budget');
    List<Budget> allBudgets = [];

    await Future.forEach(budgetsMap, (element) async {
      List<TransactionCategory> categoryList =
          await _getBudgetCategories(element['id']);
      Budget budget = Budget.fromDBmap(element, categoryList);
      budget.value = await _calculateBudgetValue(budget);
      allBudgets.add(budget);
    });

    return allBudgets;
  }

  Future<void> createBudget(
    Budget budget, {
    bool keepId = false,
  }) async {
    final Database db = await DatabaseHelper.instance.database;
    Map<String, dynamic> map = budget.toMap();
    int id = budget.id;

    await db.transaction((txn) async {
      if (!keepId) {
        id = await txn.insert(
          'budget',
          map,
          conflictAlgorithm: ConflictAlgorithm.fail,
        );
      } else {
        await txn.execute('''
        INSERT INTO budget (id, name, icon, color, max_value, interval_unit, description) 
        VALUES (?, ?, ?, ?, ?, ?, ?);
      ''', [
          id,
          map['name'],
          map['icon'],
          map['color'],
          map['max_value'],
          map['interval_unit'],
          map['description'] == '' ? null : map['description'],
        ]);
      }

      Batch batch = txn.batch();
      for (var element in budget.transactionCategories) {
        batch.insert('categoryToBudget', {
          'category_id': element.id,
          'budget_id': id,
        });
      }
      await batch.commit(noResult: true);
    });

    notifyListeners();
  }

  Future<void> updateBudget(Budget budget) async {
    final Database db = await DatabaseHelper.instance.database;

    await db.transaction((txn) async {
      await txn.update(
        'budget',
        budget.toMap(),
        where: 'id = ?',
        whereArgs: [budget.id],
      );

      await txn.delete(
        'categoryToBudget',
        where: 'budget_id = ?',
        whereArgs: [budget.id],
      );

      Batch batch = txn.batch();
      for (var element in budget.transactionCategories) {
        batch.insert(
          'categoryToBudget',
          {
            'category_id': element.id,
            'budget_id': budget.id,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      await batch.commit(noResult: true);
    });

    notifyListeners();
  }

  Future<void> deleteBudget(int budgetID) async {
    final Database db = await DatabaseHelper.instance.database;

    await db.delete(
      'budget',
      where: 'id = ?',
      whereArgs: [budgetID],
    );

    notifyListeners();
  }

  Future<List<TransactionCategory>> _getBudgetCategories(int budgetID) async {
    final Database db = await DatabaseHelper.instance.database;

    List<TransactionCategory> categoryList = [];
    final List<Map<String, dynamic>> categories = await db.query(
      'categoryToBudget',
      where: 'budget_id = ?',
      whereArgs: [budgetID],
    );
    await Future.forEach(categories, (element) async {
      TransactionCategory category =
          await CategoryModel().getCategory(element['category_id']);
      categoryList.add(category);
    });

    return categoryList;
  }

  Future<double> _calculateBudgetValue(Budget budget) async {
    final Database db = await DatabaseHelper.instance.database;

    final (lowerBound, upperBound) = _calculateBounds(budget.intervalUnit);
    String dateOption = '';
    if (lowerBound != null && upperBound != null) {
      dateOption =
          'AND date BETWEEN ${lowerBound.millisecondsSinceEpoch} AND ${upperBound.millisecondsSinceEpoch}';
    } else if (lowerBound != null && upperBound == null) {
      dateOption = 'AND date >= ${lowerBound.millisecondsSinceEpoch}';
    } else if (lowerBound == null && upperBound != null) {
      'AND date <= ${upperBound.millisecondsSinceEpoch}';
    }

    final List<Map<String, dynamic>> valueMap = await db.rawQuery(
      '''
        SELECT -SUM(value) as value 
        FROM singleTransaction 
        WHERE category_id IN (
          SELECT category_id FROM categoryToBudget
          WHERE budget_id = ?
        )
        AND account2_id IS NULL
        $dateOption;
        ''',
      [budget.id],
    );

    return valueMap[0]['value'] ?? .0;
  }

  (DateTime?, DateTime?) _calculateBounds(IntervalUnit type) {
    final DateTime? lowerBound;
    final DateTime? upperBound;
    final DateTime now = DateTime.now();
    final DateTime nowClean = DateTime(now.year, now.month, now.day);

    switch (type) {
      case IntervalUnit.day:
        lowerBound = nowClean;
        upperBound = nowClean.add(const Duration(days: 1));
      case IntervalUnit.week:
        final int weekDiff = nowClean.weekday - 1;
        lowerBound = nowClean.subtract(Duration(days: weekDiff));
        upperBound = nowClean.add(Duration(days: 7 - weekDiff));
      case IntervalUnit.month:
        lowerBound = DateTime(nowClean.year, nowClean.month);
        upperBound = DateTime(
          nowClean.month == 12 ? nowClean.year + 1 : nowClean.year,
          nowClean.month == 12 ? 1 : nowClean.month + 1,
        );
      case IntervalUnit.quarter:
        final int currentQuarter = ((nowClean.month - 1) / 3).floor(); //max 3
        final int lowerMonth = (currentQuarter * 3) + 1; //max 10
        final int upperMonth = lowerMonth == 10 ? 1 : lowerMonth + 3;
        final int upperYear =
            lowerMonth == 10 ? nowClean.year + 1 : nowClean.year;
        lowerBound = DateTime(nowClean.year, lowerMonth);
        upperBound = DateTime(upperYear, upperMonth);
      case IntervalUnit.year:
        lowerBound = DateTime(nowClean.year);
        upperBound = DateTime(nowClean.year + 1);
      case IntervalUnit.endless:
        lowerBound = null;
        upperBound = null;
    }

    return (lowerBound, upperBound);
  }
}
