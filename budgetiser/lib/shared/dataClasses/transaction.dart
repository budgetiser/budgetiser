import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';

class _Transaction {
  int id;
  String title;
  int value;
  TransactionCategory category;
  Account account;
  Account account2;
  String description;

  _Transaction({
    required this.id,
    required this.title,
    required this.value,
    required this.category,
    required this.account,
    required this.account2,
    required this.description,
  });
}

class SingleTransaction extends _Transaction {
  DateTime date;

  SingleTransaction({
    required int id,
    required String title,
    required int value,
    required TransactionCategory category,
    required Account account,
    required Account account2,
    required String description,
    required this.date,
  }) : super(
          id: id,
          title: title,
          value: value,
          category: category,
          account: account,
          account2: account2,
          description: description,
        );
}
