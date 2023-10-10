part of 'database.dart';

extension DatabaseExtensionSingleTransaction on DatabaseHelper {
  Sink<List<SingleTransaction>> get allTransactionSink =>
      _allTransactionStreamController.sink;

  Stream<List<SingleTransaction>> get allTransactionStream =>
      _allTransactionStreamController.stream;

  Future pushGetAllTransactionsStream() async {
    Timeline.startSync('allTransactionsStream');
    final db = await database;
    final List<Map<String, dynamic>> mapSingle = await db.rawQuery(
      '''Select distinct * from singleTransaction, singleTransactionToAccount
      where singleTransaction.id = singleTransactionToAccount.transaction_id''',
    );

    List<SingleTransaction> list = [];
    for (int i = 0; i < mapSingle.length; i++) {
      list.add(
        await _mapToSingleTransaction(mapSingle[i]),
      );
    }

    list.sort((a, b) {
      return b.date.compareTo(a.date);
    });

    allTransactionSink.add(list);
    Timeline.finishSync();
  }

  Future<SingleTransaction> _mapToSingleTransaction(
    Map<String, dynamic> mapItem,
  ) async {
    TransactionCategory cat = await _getCategory(mapItem['category_id']);
    Account account = await getOneAccount(mapItem['account1_id']);
    return SingleTransaction(
      id: mapItem['id'],
      title: mapItem['title'].toString(),
      value: mapItem['value'],
      description: mapItem['description'].toString(),
      category: cat,
      account: account,
      account2: mapItem['account2_id'] == null
          ? null
          : await getOneAccount(mapItem['account2_id']),
      date: DateTime.parse(mapItem['date'].toString()),
    );
  }

  Future<int> createSingleTransaction(SingleTransaction transaction) async {
    final db = await database;

    int transactionId = await db.insert(
      'singleTransaction',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    Account account =
        await getOneAccount(transaction.account.id); // to get current balance
    if (transaction.account2 == null) {
      await _setAccountBalance(account, account.balance + transaction.value);
    } else {
      Account account2 = await getOneAccount(transaction.account2!.id);
      await _setAccountBalance(account, account.balance - transaction.value);
      await _setAccountBalance(account2, account2.balance + transaction.value);
    }

    await db.insert('singleTransactionToAccount', {
      'transaction_id': transactionId,
      'account1_id': transaction.account.id,
      'account2_id':
          transaction.account2 != null ? transaction.account2!.id : null,
    });

    pushGetAllTransactionsStream();
    pushGetAllAccountsStream();
    recentlyUsedAccount.addItem(account.id.toString());

    final List<Map<String, dynamic>> maps = await db.query(
      'categoryToBudget',
      columns: ['budget_id'],
      where: 'category_id = ?',
      whereArgs: [transaction.category.id],
      distinct: true,
    );
    for (int i = 0; i < maps.length; i++) {
      reloadBudgetBalanceFromID(maps[i]['budget_id']);
    }
    return transactionId;
  }

  Future<void> deleteSingleTransaction(SingleTransaction transaction) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categoryToBudget',
      columns: ['budget_id'],
      where: 'category_id = ?',
      whereArgs: [transaction.category.id],
      distinct: true,
    );

    if (transaction.account2 == null) {
      await _setAccountBalance(
        transaction.account,
        transaction.account.balance - transaction.value,
      );
    } else {
      await _setAccountBalance(
        transaction.account,
        transaction.account.balance + transaction.value,
      );
      await _setAccountBalance(
        transaction.account2!,
        transaction.account2!.balance - transaction.value,
      );
    }

    await db.delete(
      'singleTransaction',
      where: 'id = ?',
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
    await deleteSingleTransaction(await getOneTransaction(id));
  }

  Future<void> updateSingleTransaction(SingleTransaction transaction) async {
    await deleteSingleTransactionById(transaction.id);
    await createSingleTransaction(transaction);

    pushGetAllTransactionsStream();
  }

  Future<SingleTransaction> getOneTransaction(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> mapSingle = await db.rawQuery(
      '''Select distinct * from SingleTransaction, singleTransactionToAccount
      where SingleTransaction.id = singleTransactionToAccount.transaction_id 
      and SingleTransaction.id = ?''',
      [id],
    );

    if (mapSingle.length == 1) {
      return await _mapToSingleTransaction(mapSingle[0]);
    }
    throw Exception('Error in getOneTransaction');
  }

  /// returns all months containing a transaction as the first of the month
  Future<List<DateTime>> getAllMonths() async {
    final db = await database;
    final List<Map<String, dynamic>> dateList = await db.rawQuery(
      'Select distinct date from SingleTransaction',
    );

    Set<DateTime> distinctMonths = {};
    for (var item in dateList) {
      DateTime dateTime = DateTime.parse(item['date']);
      distinctMonths.add(DateTime.parse('${dateAsYYYYMM(dateTime)}-01'));
    }

    List<DateTime> sorted = distinctMonths.toList()
      ..sort(
        (a, b) => b.compareTo(a), // reverse sort
      );
    return sorted;
  }

  Future<List<SingleTransaction>> getFilteredTransactionsByMonth({
    required DateTime inMonth,
    Account? account,
    TransactionCategory? category,
  }) async {
    final db = await database;

    List<Map<String, dynamic>> mapSingle = await db.rawQuery(
      '''Select distinct * from singleTransaction, singleTransactionToAccount 
      where singleTransaction.id = singleTransactionToAccount.transaction_id 
      and date LIKE ?
      ${account != null ? "and (singleTransactionToAccount.account1_id = ${account.id} or singleTransactionToAccount.account2_id = ${account.id})" : ""}
      ${category != null ? "and singleTransaction.category_id = ${category.id}" : ""}
      ''',
      ['${dateAsYYYYMM(inMonth)}%'],
    );

    List<SingleTransaction> transactions = [];
    for (int i = 0; i < mapSingle.length; i++) {
      transactions.add(await _mapToSingleTransaction(mapSingle[i]));
    }

    transactions.sort((a, b) {
      return b.date.compareTo(a.date);
    });

    return transactions;
  }
}
