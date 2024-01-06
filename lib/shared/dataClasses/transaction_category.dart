import 'package:budgetiser/shared/dataClasses/selectable.dart';

class TransactionCategory extends Selectable {
  int id;
  String? description;
  bool archived;
  // TODO: discuss how to implement bridge
  int? parentID;
  int level; // starts at 0 for elements without parent

  TransactionCategory({
    required this.id,
    required super.name,
    required super.icon,
    required super.color,
    this.description = '',
    this.archived = false,
    this.parentID,
    this.level = 0,
  });

  @override
  bool operator ==(Object other) =>
      other is TransactionCategory &&
      other.runtimeType == runtimeType &&
      other.id == id &&
      other.name == name &&
      other.icon == icon &&
      other.color == color &&
      other.description == description &&
      other.archived == archived &&
      other.parentID == parentID &&
      other.level == level;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        icon,
        color,
        description,
        archived,
        parentID,
        level,
      );

  Map<String, dynamic> toMap() => {
        'name': name.trim(),
        'icon': icon.codePoint,
        'color': color.value,
        'description': description?.trim(),
        'archived': archived,
      };

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    m['parentID'] = parentID;
    return m;
  }
}
