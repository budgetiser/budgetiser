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
}
