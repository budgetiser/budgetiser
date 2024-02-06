import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';

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
  SingleTransaction.fromDBmap(
    Map<String, dynamic> map, {
    required this.category,
    required this.account,
    required this.account2,
  })  : id = map['id'],
        title = map['title'],
        value = map['value'],
        description = map['description'],
        date = DateTime.fromMillisecondsSinceEpoch(map['date']);

  Map<String, dynamic> toMap() {
    return {
      'title': title.trim(),
      'value': value,
      'description':
          description == 'null' ? null : description?.trim(), // for json export
      'category_id': category.id,
      'date': date.millisecondsSinceEpoch,
      'account1_id': account.id,
      'account2_id': account2?.id,
    };
  }

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    return m;
  }

  @override
  String toString() {
    return 'Transaction: ${toJsonMap()}';
  }
}
