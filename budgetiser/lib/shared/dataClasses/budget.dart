import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:flutter/material.dart';

class Budget {
  int id;
  String name;
  IconData icon;
  Color color;
  String description;
  double balance;
  double limit;
  bool isRecurring;
  IntervalType intervalType;
  int intervalAmount;
  IntervalUnit intervalUnit;
  DateTime startDate;
  DateTime endDate;
  List<TransactionCategory> transactionCategories;

  Budget({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    required this.balance,
    required this.limit,
    required this.isRecurring,
    required this.intervalType,
    required this.intervalAmount,
    required this.intervalUnit,
    required this.startDate,
    required this.endDate,
    required this.transactionCategories,
  });
}
