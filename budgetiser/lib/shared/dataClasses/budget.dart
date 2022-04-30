import 'package:budgetiser/shared/dataClasses/recurringData.dart';
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
  IntervalType? intervalType;
  int? intervalAmount;
  IntervalUnit? intervalUnit;
  DateTime startDate;
  DateTime? endDate;
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
    this.intervalType,
    this.intervalAmount,
    this.intervalUnit,
    required this.startDate,
    this.endDate,
    required this.transactionCategories,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'icon': icon.codePoint,
        'color': color.value,
        'description': description,
        'balance': balance,
        'limitXX': limit,
        'is_recurring': isRecurring ? 1 : 0,
        'intervalAmount': isRecurring ? intervalAmount : null,
        'IntervalUnit': isRecurring ? intervalUnit.toString() : null,
        'IntervalType': isRecurring ? intervalType.toString() : null,
        'start_date': startDate.toString().substring(0, 10),
        'end_date': isRecurring ? endDate.toString().substring(0, 10) : null,
      };
}
