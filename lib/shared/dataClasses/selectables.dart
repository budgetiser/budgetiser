import 'package:flutter/material.dart';

abstract class Selectable {
  String name;
  IconData icon;
  Color color;

  Selectable({
    required this.name,
    required this.icon,
    required this.color
  });
}