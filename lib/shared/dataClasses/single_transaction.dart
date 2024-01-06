import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';

class SingleTransaction {
  int id;
  String title;
  double value;
  TransactionCategory category;
  Account account;
  Account? account2;
  String? description;
  DateTime date;

  SingleTransaction({
    required this.id,
    required this.title,
    required this.value,
    required this.category,
    required this.account,
    this.account2,
    required this.description,
    required this.date,
  });

  // SingleTransaction.fromDbMap( // TODO after db refactor: use common map datatype for initializing a transaction
  //   this.category,
  //   this.account,
  //   this.account2,
  // ) {
  //   id = 1;
  //   title = '';
  //   value = 1;
  //   description = '';
  //   date = DateTime.now();
  // }

  Map<String, dynamic> toMap() => {
        'title': title.trim(),
        'value': value,
        'description': description?.trim(),
        'category_id': category.id,
        'date': date.millisecondsSinceEpoch,
        'account1_id': account.id,
        'account2_id': account2?.id,
      };

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    m['account'] = account.id;
    m['account2'] = account2?.id;
    return m;
  }

  @override
  String toString() {
    return 'Transaction: ${toJsonMap()}';
  }
}
