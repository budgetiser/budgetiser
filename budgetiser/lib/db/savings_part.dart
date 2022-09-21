part of 'database.dart';

extension DatabaseExtensionSavings on DatabaseHelper {
  Sink<List<Savings>> get allSavingsSink => _allSavingsStreamController.sink;

  Stream<List<Savings>> get allSavingsStream =>
      _allSavingsStreamController.stream;

  void pushGetAllSavingsStream() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('saving');

    allSavingsSink.add(List.generate(maps.length, (i) {
      return Savings(
        id: maps[i]['id'],
        name: maps[i]['name'].toString(),
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(maps[i]['color']),
        balance: maps[i]['balance'],
        startDate: DateTime.parse(maps[i]['start_date']),
        endDate: DateTime.parse(maps[i]['end_date']),
        goal: maps[i]['goal'],
        description: maps[i]['description'].toString(),
      );
    }));
  }

  Future<int> createSaving(Savings saving) async {
    final db = await database;

    int id = await db.insert(
      'saving',
      saving.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    pushGetAllSavingsStream();
    return id;
  }

  void deleteSaving(int savingID) async {
    final db = await database;

    await db.delete(
      'saving',
      where: 'id = ?',
      whereArgs: [savingID],
    );
    pushGetAllSavingsStream();
  }

  Future<void> updateSaving(Savings saving) async {
    final db = await database;
    await db.update(
      'saving',
      saving.toMap(),
      where: 'id = ?',
      whereArgs: [saving.id],
    );
    pushGetAllSavingsStream();
  }
}
