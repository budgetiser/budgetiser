part of 'database.dart';

extension DatabaseExtensionStat on DatabaseHelper {
  /// Get balance of all transactions in a category and account.
  Future<double> getSpending(
      Account account, TransactionCategory transactionCategory) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''SELECT SUM(value) as value 
        FROM singleTransaction, singleTransactionToAccount 
        WHERE singleTransaction.id = singleTransactionToAccount.transaction_id 
        AND account1_id = ? and category_id = ?''',
        [account.id, transactionCategory.id]);
    return maps[0]['value'] ?? 0.0;
  }

  /// Get amount of transactions in a category and account.
  Future<int> getTransactionCount(
      Account account, TransactionCategory transactionCategory) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''SELECT COUNT(*) as count 
        FROM singleTransaction, singleTransactionToAccount 
        WHERE singleTransaction.id = singleTransactionToAccount.transaction_id 
        AND account1_id = ? and category_id = ?''',
        [account.id, transactionCategory.id]);
    return maps[0]['count'];
  }

  /// Get current balance of account
  Future<double> getCurrentAccountBalance(Account account) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''SELECT balance 
        FROM account
        WHERE account.id = ?''',
      [account.id],
    );
    return maps[0]['balance'];
  }

  /// Get Account Balances in date range
  Future<Map<Account, List<Map<DateTime, double>>>> getAccountBalancesAtTime(
    List<Account> accounts,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final startString = startDate.toString().substring(0, 19);
    final endString = endDate.toString().substring(0, 19);
    Map<Account, List<Map<DateTime, double>>> result = {};
    await Future.forEach(accounts, (account) async {
      final List<Map<String, dynamic>> balanceMaps = await db.query(
        'account',
        columns: ['balance'],
        where: 'id=?',
        whereArgs: [account.id],
      );

      double balance = balanceMaps[0]['balance'];
      double startBalance = balance;
      double endBalance = balance;

      // compare to: https://stackoverflow.com/questions/16244952/case-when-null-makes-wrong-result-in-sqlite
      final List<Map<String, dynamic>> transactionMaps = await db.rawQuery(
        '''SELECT SUM(CASE WHEN account2_id IS NULL THEN value WHEN account2_id = ? THEN value ELSE -value END) as value, date 
        FROM singleTransaction, singleTransactionToAccount 
        WHERE singleTransaction.id = singleTransactionToAccount.transaction_id
        AND (account1_id = ? OR account2_id = ?)
        AND singleTransaction.date >= ?
        GROUP BY date
        ORDER BY singleTransaction.date DESC''',
        [account.id, account.id, account.id, startString],
      );
      List<Map<DateTime, double>> singleAccountResult = [];

      for (var element in transactionMaps) {
        if (endString.compareTo(element['date']) < 0) {
          balance = balance - element['value'];
          endBalance = balance;
        } else {
          singleAccountResult.add({
            DateTime.parse(element['date']).add(const Duration(minutes: 1)):
                roundDouble(balance),
          });
          balance = balance - element['value'];
          singleAccountResult.add({
            DateTime.parse(element['date']): roundDouble(balance),
          });
        }
      }
      startBalance = balance;

      if (singleAccountResult.isNotEmpty) {
        singleAccountResult
          ..insert(0, {
            startDate: roundDouble(startBalance),
          })
          ..add({
            endDate: roundDouble(endBalance),
          });
      }

      if (singleAccountResult.isEmpty) {
        singleAccountResult = [
          {startDate: roundDouble(startBalance)},
          {endDate: roundDouble(endBalance)},
        ];
      }
      result[account] = singleAccountResult;
    });
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
