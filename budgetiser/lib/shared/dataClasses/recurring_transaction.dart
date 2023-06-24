import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/recurring_data.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';

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

  Map<String, dynamic> toMap() => {
        'title': title,
        'value': value,
        'description': description,
        'category_id': category.id,
        'start_date': startDate.toString().substring(0, 10),
        'end_date': endDate.toString().substring(0, 10),
        'interval_type': intervalType.toString(),
        'interval_unit': intervalUnit.toString(),
        'interval_amount': intervalAmount,
        'repetition_amount': repetitionAmount,
      };

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    m['account'] = account.id;
    m['account2'] = account2?.id;
    return m;
  }
}
