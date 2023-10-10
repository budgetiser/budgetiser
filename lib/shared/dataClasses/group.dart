import 'package:budgetiser/shared/dataClasses/selectable.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';

class Group extends Selectable {
  int id;
  String description;
  List<TransactionCategory> transactionCategories;

  Group({
    required this.id,
    required super.name,
    required super.icon,
    required super.color,
    required this.description,
    required this.transactionCategories,
  });

  Map<String, dynamic> toMap() => {
        'name': name.trim(),
        'icon': icon.codePoint,
        'color': color.value,
        'description': description.trim(),
      };

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    m['transactionCategories'] =
        transactionCategories.map((element) => element.id).toList();
    return m;
  }
}
