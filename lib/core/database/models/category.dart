import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:budgetiser/shared/utils/color_utils.dart';
import 'package:flutter/material.dart';

class TransactionCategory extends Selectable {
  int id;
  String? description;
  bool archived;
  int? parentID; // used in json export
  List<int> children = [];

  TransactionCategory({
    required this.id,
    required super.name,
    required super.icon,
    required super.color,
    this.description,
    this.archived = false,
    this.parentID,
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
      other.parentID == parentID;
  // ignoring children, as [] comparison returns false

  @override
  int get hashCode => Object.hash(
        id,
        name,
        icon,
        color,
        description,
        archived,
        parentID,
        children,
      );

  TransactionCategory.fromDBmap(
    Map<String, dynamic> map,
  )   : id = map['id'],
        description = map['description'],
        archived = map['archived'] == 1,
        children = map['children'] ?? [],
        parentID = map['parent_id'],
        super(
          name: map['name'].toString(),
          color: Color(map['color']),
          icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
        );

  Map<String, dynamic> toMap() => {
        'name': name.trim(),
        'icon': icon.codePoint,
        'color': ColorEx(color).toInt32,
        'description': description?.trim(),
        'archived': (archived ? 1 : 0),
      };

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    m['parent_id'] = parentID;
    m['children'] = children;
    return m;
  }
}
