part of 'database.dart';

extension DatabaseExtensionAccount on DatabaseHelper {
  Sink<List<Account>> get allAccountsSink => _allAccountsStreamController.sink;

  Stream<List<Account>> get allAccountsStream =>
      _allAccountsStreamController.stream;

  void pushGetAllAccountsStream() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('account');

    allAccountsSink.add(List.generate(maps.length, (i) {
      return Account(
        id: maps[i]['id'],
        name: maps[i]['name'].toString(),
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        color: Color(maps[i]['color']),
        balance: maps[i]['balance'],
        description: maps[i]['description'],
      );
    }));
  }

  Future<int> createAccount(Account account) async {
    final db = await database;
    int id = await db.insert(
      'account',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    pushGetAllAccountsStream();
    return id;
  }

  Future<void> deleteAccount(int accountID) async {
    final db = await database;

    await db.delete(
      'account',
      where: 'id = ?',
      whereArgs: [accountID],
    );
    pushGetAllAccountsStream();
  }

  Future<void> updateAccount(Account account) async {
    final db = await database;

    await db.update(
      'account',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
    pushGetAllAccountsStream();
  }

  /// TODO: null checks
  Future<Account> _getOneAccount(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('account', where: 'id = ?', whereArgs: [id]);

    return Account(
      id: maps[0]['id'],
      name: maps[0]['name'],
      icon: IconData(maps[0]['icon'], fontFamily: 'MaterialIcons'),
      color: Color(maps[0]['color']),
      balance: maps[0]['balance'],
      description: maps[0]['description'],
    );
  }
}
