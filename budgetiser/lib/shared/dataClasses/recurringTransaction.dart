import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';

class RecurringTransaction {
  int id;
  String title;
  double value;
  TransactionCategory category;
  Account account;
  Account? account2;
  String description;
  DateTime startDate;
  DateTime endDate;
  IntervalType intervalType;
  IntervalUnit intervalUnit;
  int intervalAmount;
  int repetitionAmount;

  RecurringTransaction({
    required this.id,
    required this.title,
    required this.value,
    required this.category,
    required this.account,
    this.account2,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.intervalType,
    required this.intervalUnit,
    required this.intervalAmount,
    required this.repetitionAmount,
  });

  // Map<String, dynamic> toMap() => {
  //       'title': title,
  //       'value': value,
  //       'description': description,
  //       'category_id': category.id,
  //       'date': startDate.toString().substring(0, 10)
  //     };
}
