import 'package:budgetiser/shared/dataClasses/selectable.dart';

class Account extends Selectable {
  int id;
  double balance;
  String description;

  Account({
    required super.name,
    required super.icon,
    required super.color,
    required this.id,
    required this.balance,
    required this.description,
  });

  Map<String, dynamic> toMap() => {
        'name': name.trim(),
        'icon': icon.codePoint,
        'color': color.value,
        'balance': balance,
        'description': description.trim(),
      };

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    return m;
  }

  @override
  String toString() {
    return 'Account: ${toJsonMap()}';
  }
}
