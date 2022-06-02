import 'package:jiffy/jiffy.dart';

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

  DateTime? calculateEndDate() {
    if (!isRecurring || intervalAmount == null || intervalUnit == null) {
      return null;
    }

    if (intervalType == IntervalType.fixedPointOfTime) {
      switch (intervalUnit) {
        case IntervalUnit.week:
          Duration untilFirstPointOfTime = Duration(
              days: (intervalAmount! - startDate.weekday) >= 0
                  ? intervalAmount! - startDate.weekday
                  : 7 - (startDate.weekday - intervalAmount!));
          Duration fromRepetitions =
              Duration(days: 7 * (repetitionAmount! - 1));
          return startDate.add(untilFirstPointOfTime + fromRepetitions);
        case IntervalUnit.month:
          Duration untilFirstPointOfTime = Duration(
              days: intervalAmount! - startDate.day >= 0
                  ? intervalAmount! - startDate.day
                  : Jiffy(startDate).daysInMonth -
                      startDate.day +
                      intervalAmount!);
          DateTime enddate = startDate.add(untilFirstPointOfTime);
          return Jiffy(enddate).add(months: repetitionAmount! - 1).dateTime;
        case IntervalUnit.year:
          Duration untilFirstPointOfTime = Duration(
            days: (intervalAmount! - Jiffy(startDate).dayOfYear >= 0)
                ? intervalAmount! - Jiffy(startDate).dayOfYear
                : ((Jiffy(startDate).isLeapYear == true) ? 366 : 365) -
                    Jiffy(startDate).dayOfYear +
                    intervalAmount!,
          );
          DateTime enddate = startDate.add(untilFirstPointOfTime);
          return Jiffy(enddate).add(years: repetitionAmount! - 1).dateTime;
        default:
          throw Exception('Error in _calculateEndDate: Unknown interval unit');
      }
    } else {
      switch (intervalUnit) {
        case IntervalUnit.day:
          return startDate
              .add(Duration(days: intervalAmount!) * repetitionAmount!);
        case IntervalUnit.week:
          return startDate
              .add(Duration(days: intervalAmount! * repetitionAmount! * 7));
        case IntervalUnit.month:
          return Jiffy(startDate)
              .add(months: intervalAmount! * repetitionAmount!)
              .dateTime;
        default:
          throw Exception(
              "Error in _calculateEndDate(fixedInterval): Unknown interval unit");
      }
    }
  }

  void setEndDateByCalculation() {
    endDate = calculateEndDate();
  }

  int calculateNeededRepetitions() {
    // TODO: not finished and buggy
    print("NO");
    if (isRecurring) {
      if (intervalType == IntervalType.fixedPointOfTime) {
        switch (intervalUnit) {
          case IntervalUnit.week:
            return endDate!.difference(startDate).inDays ~/ 7;
          // case "month":
          // return startDate.difference(enddate!).inDays ~/ 30;
          default:
            return 0;
        }
      } else {
        switch (intervalUnit) {
          case IntervalUnit.day:
            return endDate!.difference(startDate).inDays;
          case IntervalUnit.week:
            return endDate!.difference(startDate).inDays ~/ 7;
          // case "month":
          // return startDate.difference(enddate!).inDays ~/ 30;
          default:
            return 0;
        }
      }
    } else {
      return 0;
    }
  }
}
