import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:flutter/material.dart';

class TransactionCategory extends Selectable {
  int id;
  String? description;
  bool archived;
  int? ancestorID; // used in json export
  List<int> children = [];

  TransactionCategory({
    required this.id,
    required super.name,
    required super.icon,
    required super.color,
    this.description,
    this.archived = false,
    this.ancestorID,
    List<int>? children,
  }) {
    this.children = children ?? [];
  }

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
      other.ancestorID == ancestorID &&
      other.children == children;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        icon,
        color,
        description,
        archived,
        ancestorID,
        children,
      );

  TransactionCategory.fromDBmap(
    Map<String, dynamic> map,
  )   : id = map['id'],
        description = map['description'],
        archived = map['archived'] == 1,
        // children = map['children'] ?? [],
        children = map['children'] != null
            ? (map['children'] as String)
                .split(',')
                .map((e) => int.parse(e))
                .toList()
            : [],
        ancestorID = map['ancestor_id'],
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
    m['ancestor_id'] = ancestorID;
    m['children'] = children;
    return m;
  }
}
