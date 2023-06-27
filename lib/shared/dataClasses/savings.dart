import 'package:flutter/material.dart';

class Savings {
  int id;
  String name;
  IconData icon;
  Color color;
  double balance;
  DateTime startDate;
  DateTime endDate;
  double goal;
  String description;

  Savings({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.balance,
    required this.startDate,
    required this.endDate,
    required this.goal,
    required this.description,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'icon': icon.codePoint,
        'color': color.value,
        'balance': balance,
        'start_date': startDate.toString().substring(0, 10),
        'end_date': endDate.toString().substring(0, 10),
        'goal': goal,
        'description': description,
      };

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    return m;
  }
}
