part of 'database.dart';

extension DatabaseExtensionRecurring on DatabaseHelper {
  Sink<List<RecurringTransaction>> get allRecurringTransactionSink =>
      _allRecurringTransactionStreamController.sink;

  Stream<List<RecurringTransaction>> get allRecurringTransactionStream =>
      _allRecurringTransactionStreamController.stream;

  void pushGetAllRecurringTransactionsStream() async {
    final db = await database;
    final List<Map<String, dynamic>> mapRecurring = await db.rawQuery(
        'Select distinct * from recurringTransaction, recurringTransactionToAccount where recurringTransaction.id = recurringTransactionToAccount.transaction_id ');

    List<RecurringTransaction> list = [];
    for (int i = 0; i < mapRecurring.length; i++) {
      list.add(await _mapToRecurringTransaction(mapRecurring[i]));
    }

    list.sort((a, b) {
      return b.startDate.compareTo(a.startDate);
    });

    allRecurringTransactionSink.add(list);
  }

  Future<RecurringTransaction> _mapToRecurringTransaction(
      Map<String, dynamic> mapItem) async {
    TransactionCategory cat = await _getCategory(mapItem['category_id']);
    Account account = await _getOneAccount(mapItem['account1_id']);
    return RecurringTransaction(
      id: mapItem['id'],
      title: mapItem['title'].toString(),
      value: mapItem['value'],
      description: mapItem['description'].toString(),
      category: cat,
      account: account,
      account2: mapItem['account2_id'] == null
          ? null
          : await _getOneAccount(mapItem['account2_id']),
      startDate: DateTime.parse(mapItem['start_date'].toString()),
      endDate: DateTime.parse(mapItem['end_date'].toString()),
      intervalType: IntervalType.values
          .firstWhere((e) => e.toString() == mapItem['interval_type']),
      intervalUnit: IntervalUnit.values
          .firstWhere((e) => e.toString() == mapItem['interval_unit']),
      intervalAmount: mapItem['interval_amount'],
      repetitionAmount: mapItem['repetition_amount'],
    );
  }

  Future<int> createRecurringTransaction(
      RecurringTransaction recurringTransaction) async {
    final db = await database;

    int transactionId = await db.insert(
      'recurringTransaction',
      recurringTransaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    await db.insert('recurringTransactionToAccount', {
      'transaction_id': transactionId,
      'account1_id': recurringTransaction.account.id,
      'account2_id': recurringTransaction.account2 != null
          ? recurringTransaction.account2!.id
          : null,
    });
    pushGetAllRecurringTransactionsStream();

    return transactionId;
  }

  Future<void> deleteRecurringTransaction(
      RecurringTransaction transaction) async {
    final db = await database;

    await db.delete(
      'recurringTransaction',
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
    await db.delete(
      'singleToRecurringTransaction',
      where: 'recurring_transaction_id = ?',
      whereArgs: [transaction.id],
    );
    await db.delete(
      'recurringTransactionToAccount',
      where: 'transaction_id = ?',
      whereArgs: [transaction.id],
    );
    pushGetAllRecurringTransactionsStream();
  }

  Future<void> updateRecurringTransaction(
      RecurringTransaction recurringTransaction) async {
    await deleteRecurringTransactionById(recurringTransaction.id);
    await createRecurringTransaction(recurringTransaction);

    pushGetAllRecurringTransactionsStream();
  }

  Future<RecurringTransaction> getOneRecurringTransactionById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> mapRecurring = await db.rawQuery(
        'Select distinct * from recurringTransaction, recurringTransactionToAccount where recurringTransaction.id = recurringTransactionToAccount.transaction_id and recurringTransaction.id = ?',
        [id]);

    if (mapRecurring.length == 1) {
      return await _mapToRecurringTransaction(mapRecurring[0]);
    } else {
      throw Exception('Error in getOneRecurringTransaction');
    }
  }

  Future<RecurringTransaction?> _getRecurringTransactionFromSingeId(
      int id) async {
    final db = await database;
    final List<Map<String, dynamic>> mapRecurring = await db.rawQuery(
        'Select distinct * from singleToRecurringTransaction, recurringTransaction, recurringTransactionToAccount where singleToRecurringTransaction.single_transaction_id = ? and singleToRecurringTransaction.recurring_transaction_id = recurringTransaction.id and recurringTransaction.id = recurringTransactionToAccount.transaction_id',
        [
          id,
        ]);
    if (mapRecurring.length == 1) {
      return await _mapToRecurringTransaction(mapRecurring[0]);
    } else {
      return null;
    }
  }

  Future<void> deleteRecurringTransactionById(int id) async {
    final db = await database;

    await db.delete(
      'recurringTransaction',
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'recurringTransactionToAccount',
      where: 'transaction_id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'singleToRecurringTransaction',
      where: 'recurring_transaction_id = ?',
      whereArgs: [id],
    );
    pushGetAllRecurringTransactionsStream();
  }
}
