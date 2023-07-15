import 'package:budgetiser/shared/dataClasses/selectables.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:flutter/material.dart';

class Group implements Selectable {
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

  Map<String, dynamic> toMap() => {
        'name': name,
        'icon': icon.codePoint,
        'color': color.value,
        'description': description,
      };

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    m['transactionCategories'] =
        transactionCategories.map((element) => element.id).toList();
    return m;
  }
}
