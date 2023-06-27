part of 'database.dart';

extension DatabaseExtensionCategory on DatabaseHelper {
  Sink<List<TransactionCategory>> get allCategorySink =>
      _allCategoryStreamController.sink;

  Stream<List<TransactionCategory>> get allCategoryStream =>
      _allCategoryStreamController.stream;

  void pushGetAllCategoriesStream() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('category');

    allCategorySink.add(List.generate(maps.length, (i) {
      return TransactionCategory(
        id: maps[i]['id'],
        name: maps[i]['name'].toString(),
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(maps[i]['color']),
        description: maps[i]['description'].toString(),
        isHidden: maps[i]['is_hidden'] == 1,
      );
    }));
  }

  Future<int> createCategory(TransactionCategory category) async {
    final db = await database;
    Map<String, dynamic> row = {
      'name': category.name,
      'icon': category.icon.codePoint,
      'color': category.color.value,
      'description': category.description,
      'is_hidden': ((category.isHidden) ? 1 : 0),
    };

    int id = await db.insert(
      'category',
      row,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    pushGetAllCategoriesStream();
    return id;
  }

  Future<void> deleteCategory(int categoryID) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categoryToBudget',
        columns: ['budget_id'],
        where: 'category_id = ?',
        whereArgs: [categoryID],
        distinct: true);

    await db.delete(
      'category',
      where: 'id = ?',
      whereArgs: [categoryID],
    );

    for (int i = 0; i < maps.length; i++) {
      reloadBudgetBalanceFromID(maps[i]['budget_id']);
    }
    pushGetAllCategoriesStream();
  }

  Future<void> updateCategory(TransactionCategory category) async {
    final db = await database;

    await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
    pushGetAllCategoriesStream();
  }

  Future<void> hideCategory(int categoryID) async {
    final db = await database;

    await db.update(
      'category',
      {'is_hidden': true},
      where: 'id = ?',
      whereArgs: [categoryID],
    );
    pushGetAllCategoriesStream();
  }

  Future<TransactionCategory> _getCategory(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('category', where: 'id = ?', whereArgs: [id]);

    return TransactionCategory(
      id: maps[0]['id'],
      name: maps[0]['name'],
      icon: IconData(maps[0]['icon'], fontFamily: 'MaterialIcons'),
      color: Color(maps[0]['color']),
      description: maps[0]['description'],
      isHidden: maps[0]['is_hidden'] == 1,
    );
  }
}
