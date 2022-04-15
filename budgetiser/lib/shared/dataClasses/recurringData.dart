import 'package:budgetiser/shared/widgets/recurringForm.dart';

class RecurringData {
  DateTime startDate;
  bool isRecurring;
  IntervalType? intervalType;
  String? intervalUnit;
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
