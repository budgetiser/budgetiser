import 'package:flutter/material.dart';

class TransactionCategory {
  int id;
  String name;
  IconData icon;
  Color color;
  String description;
  bool isHidden;

  TransactionCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    required this.isHidden,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'icon': icon.codePoint,
        'color': color.value,
        'description': description,
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
