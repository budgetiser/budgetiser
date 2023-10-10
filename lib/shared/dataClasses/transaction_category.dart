import 'package:budgetiser/shared/dataClasses/selectable.dart';

class TransactionCategory extends Selectable {
  int id;
  String description;
  bool isHidden;

  TransactionCategory({
    required this.id,
    required super.name,
    required super.icon,
    required super.color,
    required this.description,
    required this.isHidden,
  });

  Map<String, dynamic> toMap() => {
        'name': name.trim(),
        'icon': icon.codePoint,
        'color': color.value,
        'description': description.trim(),
        'is_hidden': isHidden,
      };

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    return m;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TransactionCategory &&
        id == other.id &&
        name == other.name &&
        icon == other.icon &&
        color == other.color &&
        description == other.description &&
        isHidden == other.isHidden;
  }

  @override
  int get hashCode => Object.hash(id, name, icon, color, description, isHidden);
}
