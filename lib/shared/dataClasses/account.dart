import 'package:budgetiser/shared/dataClasses/selectable.dart';

class Account extends Selectable {
  int id;
  double balance;
  String? description;
  bool archived;

  Account({
    required super.name,
    required super.icon,
    required super.color,
    required this.id,
    required this.balance,
    this.archived = false,
    this.description,
  });

  Map<String, dynamic> toMap() => {
        'name': name.trim(),
        'icon': icon.codePoint,
        'color': color.value,
        'balance': balance,
        'description': description?.trim(),
        'archived': archived ? 1 : 0,
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

  @override
  bool operator ==(Object other) =>
      other is Account &&
      other.runtimeType == runtimeType &&
      other.id == id &&
      other.name == name &&
      other.icon == icon &&
      other.color == color &&
      other.description == description &&
      other.archived == archived &&
      other.balance == balance;

  @override
  int get hashCode => id.hashCode;
}
