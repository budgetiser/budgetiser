import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:flutter/material.dart';

class TransactionCategory extends Selectable {
  int id;
  String? description;
  bool archived;
  // TODO: discuss how to implement bridge #231
  int? parentID; // used in json export
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

  TransactionCategory.fromDBmap(Map<String, dynamic> map)
      : id = map['id'],
        description = map['description'],
        archived = map['archived'] == 1,
        level = 0, // TODO: 231
        super(
          name: map['name'].toString(),
          color: Color(map['color']),
          icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
        );

  Map<String, dynamic> toMap() => {
        'name': name.trim(),
        'icon': icon.codePoint,
        'color': color.value,
        'description': description?.trim(),
        'archived': (archived ? 1 : 0),
      };

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    m['parentID'] = parentID;
    return m;
  }
}
