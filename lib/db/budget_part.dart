part of 'database.dart';

extension DatabaseExtensionBudget on DatabaseHelper {
  Sink<List<Budget>> get allBudgetsSink => _allBudgetsStreamController.sink;

  Stream<List<Budget>> get allBudgetsStream =>
      _allBudgetsStreamController.stream;

  void pushGetAllBudgetsStream() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('budget');
    List<List<TransactionCategory>> categoryList = [];
    for (int i = 0; i < maps.length; i++) {
      categoryList.add(await _getCategoriesToBudget(maps[i]['id']));
    }
    allBudgetsSink.add(List.generate(maps.length, (i) {
      Budget returnBudget = Budget(
        id: maps[i]['id'],
        name: maps[i]['name'].toString(),
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(maps[i]['color']),
        balance: maps[i]['balance'] ?? 0,
        limit: maps[i]['limitXX'],
        startDate: DateTime.parse(maps[i]['start_date']),
        description: maps[i]['description'].toString(),
        isRecurring: maps[i]['is_recurring'] == 1,
        transactionCategories: categoryList[i],
      );
      if (maps[i]['is_recurring'] == 1) {
        returnBudget
          ..endDate = DateTime.parse(maps[i]['end_date'])
          ..intervalUnit = IntervalUnit.values
              .firstWhere((e) => e.toString() == maps[i]['interval_unit'])
          ..intervalType = IntervalType.values
              .firstWhere((e) => e.toString() == maps[i]['interval_type'])
          ..intervalAmount = maps[i]['interval_amount']
          ..intervalRepetitions = maps[i]['interval_repititions'];
      }
      return returnBudget;
    }));
  }

  Future<Budget> _getBudgetToID(int budgetID) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('budget', where: 'id = ?', whereArgs: [budgetID]);
    List<List<TransactionCategory>> categoryList = [];
    for (int i = 0; i < maps.length; i++) {
      categoryList.add(await _getCategoriesToBudget(maps[i]['id']));
    }
    Budget returnBudget = Budget(
      id: maps[0]['id'],
      name: maps[0]['name'].toString(),
      icon: IconData(maps[0]['icon'], fontFamily: 'MaterialIcons'),
      color: Color(maps[0]['color']),
      balance: maps[0]['balance'] ?? 0,
      limit: maps[0]['limitXX'],
      startDate: DateTime.parse(maps[0]['start_date']),
      description: maps[0]['description'].toString(),
      isRecurring: maps[0]['is_recurring'] == 1,
      transactionCategories: categoryList[0],
    );
    if (maps[0]['is_recurring'] == 1) {
      returnBudget
        ..endDate = DateTime.parse(maps[0]['end_date'])
        ..intervalUnit = IntervalUnit.values
            .firstWhere((e) => e.toString() == maps[0]['interval_unit'])
        ..intervalType = IntervalType.values
            .firstWhere((e) => e.toString() == maps[0]['interval_type'])
        ..intervalAmount = maps[0]['interval_amount']
        ..intervalRepetitions = maps[0]['interval_repititions'];
    }
    return returnBudget;
  }

  Future<List<TransactionCategory>> _getCategoriesToBudget(int budgetID) async {
    final db = await database;

    final List<Map<String, dynamic>> mapCategories = await db.rawQuery(
        'Select distinct id, name, icon, color, description, is_hidden from category, categoryToBudget where category_id = category.id and budget_id = ?',
        [budgetID]);
    return List.generate(mapCategories.length, (i) {
      return TransactionCategory(
        id: mapCategories[i]['id'],
        name: mapCategories[i]['name'].toString(),
        icon: IconData(mapCategories[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(mapCategories[i]['color']),
        description: mapCategories[i]['description'].toString(),
        archived: mapCategories[i]['is_hidden'] == 1,
      );
    });
  }

  Future<int> createBudget(Budget budget) async {
    final db = await database;

    int id = await db.insert(
      'budget',
      budget.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    List<TransactionCategory> budgetCategories = budget.transactionCategories;

    for (int i = 0; i < budgetCategories.length; i++) {
      Map<String, dynamic> rowCategory = {
        'category_id': budgetCategories[i].id,
        'budget_id': id,
      };
      await db.insert(
        'categoryToBudget',
        rowCategory,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
    reloadBudgetBalanceFromID(id);
    pushGetAllBudgetsStream();
    return id;
  }

  void deleteBudget(int budgetID) async {
    final db = await database;

    await db.delete(
      'budget',
      where: 'id = ?',
      whereArgs: [budgetID],
    );
    pushGetAllBudgetsStream();
  }

  Future<void> updateBudget(Budget budget) async {
    final db = await database;
    await db.update(
      'budget',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
    List<TransactionCategory> budgetCategories = budget.transactionCategories;

    await db.delete(
      'categoryToBudget',
      where: 'budget_id = ?',
      whereArgs: [budget.id],
    );

    for (int i = 0; i < budgetCategories.length; i++) {
      Map<String, dynamic> rowCategory = {
        'category_id': budgetCategories[i].id,
        'budget_id': budget.id,
      };
      await db.insert(
        'categoryToBudget',
        rowCategory,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
    reloadBudgetBalanceFromID(budget.id);
    pushGetAllBudgetsStream();
  }

  void reloadBudgetBalanceFromID(int budgetID) async {
    final db = await database;
    //Get BudgetData
    Budget budget = await _getBudgetToID(budgetID);
    Map<String, DateTime> interval = budget.calculateCurrentInterval();

    if (budget.isRecurring) {
      await db.rawUpdate('''UPDATE budget SET balance =
            (
              SELECT -SUM(value)
              FROM singleTransaction
              INNER JOIN category ON category.id = singleTransaction.category_id
              INNER JOIN categoryToBudget ON category.id = categoryToBudget.category_id
              INNER JOIN budget ON categoryToBudget.budget_id = budget.id
              WHERE categoryToBudget.budget_id = ?
                  and ? <= singleTransaction.date
                  and ? >= singleTransaction.date
            )
        WHERE id = ?;
    ''', [
        budgetID,
        interval['start'].toString().substring(0, 10),
        interval['end'].toString().substring(0, 10),
        budgetID,
      ]);
    } else {
      await db.rawUpdate('''UPDATE budget SET balance =
            (
              SELECT -SUM(value)
              FROM singleTransaction
              INNER JOIN category ON category.id = singleTransaction.category_id
              INNER JOIN categoryToBudget ON category.id = categoryToBudget.category_id
              INNER JOIN budget ON categoryToBudget.budget_id = budget.id
              WHERE categoryToBudget.budget_id = ?
                  and ? <= singleTransaction.date
            )
        WHERE id = ?;
    ''', [
        budgetID,
        budget.startDate.toString().substring(0, 10),
        budgetID,
      ]);
    }
    pushGetAllBudgetsStream();
  }

  /// takes a long time
  void reloadAllBudgetBalance() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('budget', columns: ['id']);
    for (int i = 0; i < maps.length; i++) {
      reloadBudgetBalanceFromID(maps[i]['id']);
    }
    pushGetAllBudgetsStream();
  }
}
