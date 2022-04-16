import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';

abstract class AbstractTransaction {
  int id;
  String title;
  double value;
  TransactionCategory category;
  Account account;
  Account? account2;
  String description;

  AbstractTransaction({
    required this.id,
    required this.title,
    required this.value,
    required this.category,
    required this.account,
    this.account2,
    required this.description,
  });

  Map<String, dynamic> toMapAbstract() => {
        'title': title,
        'value': value,
        'description': description,
        'category_id': category.id,
      };
}

class SingleTransaction extends AbstractTransaction {
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

  @override
  String toString() {
    // TODO: implement toString
    return "singleTransaction ${this.id} ${this.title} ${this.value} ${this.category} ${this.account} ${this.account2} ${this.description} ${this.date}";
  }
}

// enum IntervalType {  TODO: discuss enum
//   Daily,
//   Weekly,
//   Monthly,
//   Yearly,
// }

class RecurringTransaction extends AbstractTransaction {
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
