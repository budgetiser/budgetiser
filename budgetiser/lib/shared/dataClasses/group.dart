import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:flutter/material.dart';

class Group {
  int id;
  String name;
  IconData icon;
  Color color;
  String description;
  List<TransactionCategory> transactionCategories;

  Group({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    required this.transactionCategories,
  });
}
