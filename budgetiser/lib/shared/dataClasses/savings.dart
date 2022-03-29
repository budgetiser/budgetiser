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
}
