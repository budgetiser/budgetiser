part of 'database.dart';

extension DatabaseExtensionGroup on DatabaseHelper {
  Sink<List<Group>> get allGroupsSink => _allGroupsStreamController.sink;

  Stream<List<Group>> get allGroupsStream => _allGroupsStreamController.stream;

  void pushGetAllGroupsStream() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('XXGroup');
    List<List<TransactionCategory>> categoryList = [];
    for (int i = 0; i < maps.length; i++) {
      categoryList.add(await _getCategoriesToGroup(maps[i]['id']));
    }

    allGroupsSink.add(List.generate(maps.length, (i) {
      return Group(
        id: maps[i]['id'],
        name: maps[i]['name'].toString(),
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(maps[i]['color']),
        description: maps[i]['description'].toString(),
        transactionCategories: categoryList[i],
      );
    }));
  }

  Future<List<TransactionCategory>> _getCategoriesToGroup(int groupID) async {
    final db = await database;

    final List<Map<String, dynamic>> mapCategories = await db.rawQuery(
        'Select distinct id, name, icon, color, description, is_hidden from category, categoryToGroup where category_id = category.id and group_id = ?',
        [groupID]);
    return List.generate(mapCategories.length, (i) {
      return TransactionCategory(
        id: mapCategories[i]['id'],
        name: mapCategories[i]['name'].toString(),
        icon: IconData(mapCategories[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(mapCategories[i]['color']),
        description: mapCategories[i]['description'].toString(),
        isHidden: mapCategories[i]['is_hidden'] == 1,
      );
    });
  }

  Future<int> createGroup(Group group) async {
    final db = await database;

    int id = await db.insert(
      'XXGroup',
      group.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    List<TransactionCategory> groupCategories = group.transactionCategories;

    for (int i = 0; i < groupCategories.length; i++) {
      Map<String, dynamic> rowCategory = {
        'category_id': groupCategories[i].id,
        'group_id': id,
      };
      await db.insert(
        'categoryToGroup',
        rowCategory,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
    pushGetAllGroupsStream();
    return id;
  }

  void deleteGroup(int groupID) async {
    final db = await database;

    await db.delete(
      'XXGroup',
      where: 'id = ?',
      whereArgs: [groupID],
    );
    pushGetAllGroupsStream();
  }

  Future<void> updateGroup(Group group) async {
    final db = await database;
    await db.update(
      'XXGroup',
      group.toMap(),
      where: 'id = ?',
      whereArgs: [group.id],
    );
    List<TransactionCategory> groupCategories = group.transactionCategories;

    await db.delete(
      'categoryToGroup',
      where: 'group_id = ?',
      whereArgs: [group.id],
    );

    for (int i = 0; i < groupCategories.length; i++) {
      Map<String, dynamic> rowCategory = {
        'category_id': groupCategories[i].id,
        'group_id': group.id,
      };
      await db.insert(
        'categoryToGroup',
        rowCategory,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
    pushGetAllGroupsStream();
  }
}
