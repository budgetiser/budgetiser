part of 'database.dart';

extension DatabaseExtensionStat on DatabaseHelper {
  /// Get balance of all transactions in a category and account.
  Future<double> getSpending(
      Account account, TransactionCategory transactionCategory) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT SUM(value) as value FROM singleTransaction, singleTransactionToAccount where singleTransaction.id = singleTransactionToAccount.transaction_id and account1_id = ? and category_id = ?',
        [account.id, transactionCategory.id]);
    return maps[0]['value'] ?? 0.0;
  }

  /// Get amount of transactions in a category and account.
  Future<int> getTransactionCount(
      Account account, TransactionCategory transactionCategory) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT COUNT(*) as count FROM singleTransaction, singleTransactionToAccount where singleTransaction.id = singleTransactionToAccount.transaction_id and account1_id = ? and category_id = ?',
        [account.id, transactionCategory.id]);
    return maps[0]['count'];
  }

  /// Get current balance of account
  Future<double> getCurrentAccountBalance(Account account) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''SELECT balance 
        FROM account
        WHERE account.id = ?''', [account.id]);
    return maps[0]['balance'];
  }

  /// Get Account Balances in date range
  Future<Map<Account, List<Map<String, dynamic>>>> getAccountBalancesAtTime(
    List<Account> accounts,
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final startString = start.toIso8601String();
    final endString = end.toIso8601String();
    Map<Account, List<Map<String, dynamic>>> result = {};
    accounts.forEach((account) async {
      final List<Map<String, dynamic>> balanceMaps = await db.rawQuery(
        '''SELECT balance 
        FROM account
        WHERE account.id = ?''',
        [account.id],
      );
      double balance = balanceMaps[0]['balance'];
      double startBalance = balance;
      double endBalance = balance;

      final List<Map<String, dynamic>> transactionMaps =
          await db.rawQuery('''SELECT SUM(value) as value, date 
        FROM singleTransaction, singleTransactionToAccount 
        WHERE singleTransaction.id = singleTransactionToAccount.transaction_id 
        AND account1_id = ?
        AND singleTransaction.date >= ?
        GROUP BY date
        ORDER BY singleTransaction.date DESC''', [account.id, startString]);
      List<Map<String, dynamic>> temp = [];
      for (var element in transactionMaps) {
        if (endString.compareTo(element['date']) <= 0) {
          balance = balance - element['value'];
          endBalance = balance;
        } else {
          temp.add({
            'value': double.parse((balance).toStringAsFixed(1)),
            'date': element['date']
          });
          balance = balance - element['value'];
          startBalance = balance;
        }
      }
      if (temp.isNotEmpty &&
          endString.compareTo(transactionMaps.first['date']) != 0) {
        temp.insert(0, {
          'value': double.parse((endBalance).toStringAsFixed(1)),
          'date': endString
        });
      }
      if (temp.isNotEmpty &&
          startString.compareTo(transactionMaps.last['date']) != 0) {
        temp.add({
          'value': double.parse((startBalance).toStringAsFixed(1)),
          'date': startString
        });
      }
      if (temp.isNotEmpty) {
        result[account] = temp;
      }
    });
    print(result);
    return result;
  }

  /// Get all transactions in a category and account
  Future<List<Map<String, dynamic>>> getTransactions(
    Account account,
    TransactionCategory transactionCategory,
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final startString = start.toIso8601String();
    final endString = end.toIso8601String();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''SELECT value, date 
        FROM singleTransaction, singleTransactionToAccount 
        WHERE singleTransaction.id = singleTransactionToAccount.transaction_id 
        AND account1_id = ? and category_id = ?
        AND singleTransaction.date >= ?
        AND singleTransaction.date <= ?
        ORDER BY singleTransaction.date''',
      [account.id, transactionCategory.id, startString, endString],
    );
    return maps;
  }
}
