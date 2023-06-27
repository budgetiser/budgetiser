part of "database.dart";

extension DatabaseExtensionSingleTransaction on DatabaseHelper {
  Sink<List<SingleTransaction>> get allTransactionSink =>
      _allTransactionStreamController.sink;

  Stream<List<SingleTransaction>> get allTransactionStream =>
      _allTransactionStreamController.stream;

  void pushGetAllTransactionsStream() async {
    Timeline.startSync("allTransactionsStream");
    final db = await database;
    final List<Map<String, dynamic>> mapSingle = await db.rawQuery(
        'Select distinct * from singleTransaction, singleTransactionToAccount where singleTransaction.id = singleTransactionToAccount.transaction_id');

    List<SingleTransaction> list = [];
    for (int i = 0; i < mapSingle.length; i++) {
      list.add(await _mapToSingleTransaction(mapSingle[i]));
    }

    list.sort((a, b) {
      return b.date.compareTo(a.date);
    });

    allTransactionSink.add(list);
    Timeline.finishSync();
  }

  Future<SingleTransaction> _getOneSingleTransaction(int transactionId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'Select distinct * from singleTransaction, singleTransactionToAccount where singleTransaction.id = singleTransactionToAccount.transaction_id and singleTransaction.id = ?',
      [transactionId],
    );

    return await _mapToSingleTransaction(maps[0]);
  }

  Future<SingleTransaction> _mapToSingleTransaction(
      Map<String, dynamic> mapItem) async {
    TransactionCategory cat = await _getCategory(mapItem['category_id']);
    Account account = await _getOneAccount(mapItem['account1_id']);
    RecurringTransaction? recurringTransaction =
        await _getRecurringTransactionFromSingeId(mapItem['id']);
    return SingleTransaction(
      id: mapItem['id'],
      title: mapItem['title'].toString(),
      value: mapItem['value'],
      description: mapItem['description'].toString(),
      category: cat,
      account: account,
      account2: mapItem['account2_id'] == null
          ? null
          : await _getOneAccount(mapItem['account2_id']),
      date: DateTime.parse(mapItem['date'].toString()),
      recurringTransaction: recurringTransaction,
    );
  }

  Future<int> createSingleTransaction(SingleTransaction transaction) async {
    final db = await database;

    int transactionId = await db.insert(
      'singleTransaction',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    Account account = await _getOneAccount(transaction.account.id);
    if (transaction.account2 == null) {
      await db.update(
        'account',
        {'balance': _roundDouble(account.balance + transaction.value)},
        where: 'id = ?',
        whereArgs: [account.id],
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } else {
      Account account2 = await _getOneAccount(transaction.account2!.id);
      await db.update('account',
          {'balance': _roundDouble(account.balance - transaction.value)},
          where: 'id = ?', whereArgs: [account.id]);
      await db.update('account',
          {'balance': _roundDouble(account2.balance + transaction.value)},
          where: 'id = ?', whereArgs: [account2.id]);
    }

    await db.insert('singleTransactionToAccount', {
      'transaction_id': transactionId,
      'account1_id': transaction.account.id,
      'account2_id':
          transaction.account2 != null ? transaction.account2!.id : null,
    });

    pushGetAllTransactionsStream();
    pushGetAllAccountsStream();

    final List<Map<String, dynamic>> maps = await db.query('categoryToBudget',
        columns: ['budget_id'],
        where: 'category_id = ?',
        whereArgs: [transaction.category.id],
        distinct: true);
    for (int i = 0; i < maps.length; i++) {
      reloadBudgetBalanceFromID(maps[i]['budget_id']);
    }
    return transactionId;
  }

  Future<void> deleteSingleTransaction(SingleTransaction transaction) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categoryToBudget',
        columns: ['budget_id'],
        where: 'category_id = ?',
        whereArgs: [transaction.category.id],
        distinct: true);

    if (transaction.account2 == null) {
      await db.update(
          'account',
          {
            'balance':
                _roundDouble(transaction.account.balance - transaction.value)
          },
          where: 'id = ?',
          whereArgs: [transaction.account.id]);
    } else {
      await db.update(
          'account',
          {
            'balance':
                _roundDouble(transaction.account.balance + transaction.value)
          },
          where: 'id = ?',
          whereArgs: [transaction.account.id]);
      await db.update(
          'account',
          {
            'balance':
                _roundDouble(transaction.account2!.balance - transaction.value)
          },
          where: 'id = ?',
          whereArgs: [transaction.account2!.id]);
    }

    await db.delete(
      'singleTransaction',
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
    await db.delete(
      'singleToRecurringTransaction',
      where: 'single_transaction_id = ?',
      whereArgs: [transaction.id],
    );
    await db.delete(
      'singleTransactionToAccount',
      where: 'transaction_id = ?',
      whereArgs: [transaction.id],
    );

    for (int i = 0; i < maps.length; i++) {
      reloadBudgetBalanceFromID(maps[i]['budget_id']);
    }

    pushGetAllAccountsStream();
    pushGetAllTransactionsStream();
  }

  Future<void> deleteSingleTransactionById(int id) async {
    await deleteSingleTransaction(await _getOneSingleTransaction(id));
  }

  Future<void> updateSingleTransaction(SingleTransaction transaction) async {
    await deleteSingleTransactionById(transaction.id);
    await createSingleTransaction(transaction);

    pushGetAllTransactionsStream();
  }

  Future<SingleTransaction> getOneTransaction(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> mapSingle = await db.rawQuery(
        'Select distinct * from SingleTransaction, singleTransactionToAccount where SingleTransaction.id = singleTransactionToAccount.transaction_id and SingleTransaction.id = ?',
        [id]);

    if (mapSingle.length == 1) {
      return await _mapToSingleTransaction(mapSingle[0]);
    }
    throw Exception('Error in getOneTransaction');
  }
}
