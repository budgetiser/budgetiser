import 'package:flutter/material.dart';

class Account {
  int id;
  String name;
  Icon icon;
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
}
