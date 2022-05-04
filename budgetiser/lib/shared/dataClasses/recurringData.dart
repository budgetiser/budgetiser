class RecurringData {
  DateTime startDate;
  bool isRecurring;
  IntervalType? intervalType;
  IntervalUnit? intervalUnit;
  int? intervalAmount;
  DateTime? endDate;
  int? repetitionAmount;

  RecurringData({
    required this.startDate,
    required this.isRecurring,
    this.intervalType,
    this.intervalUnit,
    this.intervalAmount,
    this.endDate,
    this.repetitionAmount,
  });
}

enum IntervalUnit {
  day,
  week,
  month,
  quarter,
  year,
}

enum IntervalType {
  fixedPointOfTime,
  fixedInterval,
}
