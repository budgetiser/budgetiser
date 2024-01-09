import 'package:budgetiser/core/database/models/budget.dart';

/// rounds to 2 decimal places by cutting off all digits after
double roundDouble(double value) {
  return double.parse(value.toStringAsFixed(2));
}

/// get interval representation as string
String getIntervalString(IntervalUnit unit) {
  switch (unit) {
    case IntervalUnit.day:
      return 'daily';
    case IntervalUnit.week:
      return 'weekly';
    case IntervalUnit.month:
      return 'monthly';
    case IntervalUnit.quarter:
      return 'quarterly';
    case IntervalUnit.year:
      return 'yearly';
    default:
      return '';
  }
}
