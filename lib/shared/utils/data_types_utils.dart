import 'package:budgetiser/core/database/models/budget.dart';

/// rounds to 2 decimal places by cutting off all digits after
double roundDouble(double value) {
  return double.parse(value.toStringAsFixed(2));
}
