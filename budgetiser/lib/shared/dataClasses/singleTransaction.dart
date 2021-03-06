import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/recurringTransaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';

class SingleTransaction {
  int id;
  String title;
  double value;
  TransactionCategory category;
  Account account;
  Account? account2;
  String description;
  DateTime date;
  RecurringTransaction? recurringTransaction;

  SingleTransaction({
    required this.id,
    required this.title,
    required this.value,
    required this.category,
    required this.account,
    this.account2,
    required this.description,
    required this.date,
    this.recurringTransaction,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'value': value,
        'description': description,
        'category_id': category.id,
        'date': date.toString().substring(0, 10)
      };
}
