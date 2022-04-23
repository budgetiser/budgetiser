import 'package:budgetiser/shared/dataClasses/transaction.dart';

class RecurringData {
  DateTime startDate;
  bool isRecurring;
  IntervalType? intervalType;
  IntervalUnit? intervalUnit;
  int? intervalAmount;
  DateTime? endDate;

  RecurringData({
    required this.startDate,
    required this.isRecurring,
    this.intervalType,
    this.intervalUnit,
    this.intervalAmount,
    this.endDate,
  });
}
