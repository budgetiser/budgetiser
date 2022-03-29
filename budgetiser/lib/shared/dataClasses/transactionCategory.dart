import 'package:flutter/material.dart';

class TransactionCategory {
  int id;
  String name;
  Icon icon;
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
}
