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
}
