import 'package:flutter/material.dart';

class Account {
  int id;
  String name;
  IconData icon;
  Color color;
  double balance;
  String description;

  Account({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.balance,
    required this.description,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'icon': icon.codePoint,
        'color': color.value,
        'balance': balance,
        'description': description,
      };
}
