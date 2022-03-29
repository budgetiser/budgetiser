import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';

class _Transaction {
  int id;
  String title;
  double value;
  TransactionCategory category;
  Account account;
  Account? account2;
  String description;

  _Transaction({
    required this.id,
    required this.title,
    required this.value,
    required this.category,
    required this.account,
    this.account2,
    required this.description,
  });
}

class SingleTransaction extends _Transaction {
  DateTime date;

  SingleTransaction({
    required int id,
    required String title,
    required double value,
    required TransactionCategory category,
    required Account account,
    Account? account2,
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

// enum IntervalType {  TODO: discuss enum
//   Daily,
//   Weekly,
//   Monthly,
//   Yearly,
// }

class RecurringTransaction extends _Transaction {
  DateTime startDate;
  DateTime endDate;
  String intervalType;
  int intervalAmount;
  String intervalUnit;

  RecurringTransaction({
    required int id,
    required String title,
    required double value,
    required TransactionCategory category,
    required Account account,
    Account? account2,
    required String description,
    required this.startDate,
    required this.endDate,
    required this.intervalType,
    required this.intervalAmount,
    required this.intervalUnit,
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
