import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

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
  int? intervalRepititions;
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
    this.intervalRepititions,
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
        'interval_amount': isRecurring ? intervalAmount : null,
        'Interval_unit': isRecurring ? intervalUnit.toString() : null,
        'Interval_type': isRecurring ? intervalType.toString() : null,
        'Interval_repetitions': isRecurring ? intervalRepititions : null,
        'start_date': startDate.toString().substring(0, 10),
        'end_date': isRecurring ? endDate.toString().substring(0, 10) : null,
      };

  Map<String, DateTime> calculateCurrentInterval() {
    if (!isRecurring) return {};
    DateTime endInterval = DateTime.now();
    DateTime startInterval = DateTime.now();
    for (int i = 0; i < intervalRepititions!; i++) {
      if (intervalType == IntervalType.fixedPointOfTime) {
        switch (intervalUnit) {
          case IntervalUnit.week:
            Duration untilFirstPointOfTime = Duration(
                days: (intervalAmount! - startDate.weekday) >= 0
                    ? intervalAmount! - startDate.weekday
                    : 7 - (startDate.weekday - intervalAmount!));
            Duration fromRepetitions =
                Duration(days: 7 * (intervalRepititions! - 1 - i));
            DateTime a = startDate.add(untilFirstPointOfTime + fromRepetitions);
            if (a.compareTo(DateTime.now()) > 0) {
              endInterval = a;
              startInterval = a.subtract(Duration(days: 7));
            }
            break;
          case IntervalUnit.month:
            Duration untilFirstPointOfTime = Duration(
                days: intervalAmount! - startDate.day >= 0
                    ? intervalAmount! - startDate.day
                    : Jiffy(startDate).daysInMonth -
                        startDate.day +
                        intervalAmount!);
            DateTime a = startDate.add(untilFirstPointOfTime);
            a = Jiffy(a).add(months: intervalRepititions! - 1 - i).dateTime;
            if (a.compareTo(DateTime.now()) > 0) {
              endInterval = a;
              startInterval =
                  Jiffy(a).add(months: intervalRepititions! - 2 - i).dateTime;
            }
            break;
          case IntervalUnit.year:
            Duration untilFirstPointOfTime = Duration(
              days: (intervalAmount! - Jiffy(startDate).dayOfYear >= 0)
                  ? intervalAmount! - Jiffy(startDate).dayOfYear
                  : ((Jiffy(startDate).isLeapYear == true) ? 366 : 365) -
                      Jiffy(startDate).dayOfYear +
                      intervalAmount!,
            );
            DateTime a = startDate.add(untilFirstPointOfTime);
            a = Jiffy(a).add(years: intervalRepititions! - 1 - i).dateTime;
            if (a.compareTo(DateTime.now()) > 0) {
              endInterval = a;
              startInterval =
                  Jiffy(a).add(years: intervalRepititions! - 2 - i).dateTime;
            }
            break;
          default:
            print("Error in _calculateEndDate: unknown intervalMode");
        }
      } else {
        switch (intervalUnit) {
          case IntervalUnit.day:
            DateTime a = startDate.add(
                Duration(days: intervalAmount!) * (intervalRepititions! - i));
            if (a.compareTo(DateTime.now()) > 0) {
              endInterval = a;
              startInterval = a.subtract(Duration(days: intervalAmount!) *
                  (intervalRepititions! - 1 - i));
            }
            break;
          case IntervalUnit.week:
            DateTime a = startDate.add(Duration(
                days: intervalAmount! * (intervalRepititions! - i) * 7));
            if (a.compareTo(DateTime.now()) > 0) {
              endInterval = a;
              startInterval = a.subtract(Duration(days: intervalAmount!) *
                  (intervalRepititions! - 1 - i));
            }
            break;
          case IntervalUnit.month:
            DateTime a = Jiffy(startDate)
                .add(months: intervalAmount! * (intervalRepititions! - i))
                .dateTime;
            if (a.compareTo(DateTime.now()) > 0) {
              endInterval = a;
              startInterval = Jiffy(startDate)
                  .add(months: intervalAmount! * (intervalRepititions! - i - 1))
                  .dateTime;
            }
            break;
          default:
            print(
                "Error in _calculateEndDate(fixedInterval): unknown intervalMode");
        }
      }
    }
    return {
      'start': startInterval,
      'end': endInterval,
    };
  }

  int compareTo(Budget other) {
    //negative: this is ordered before other
    //positive: this is ordered after other
    if (isRecurring && !other.isRecurring) {
      return 1;
    } else if (!isRecurring && other.isRecurring) {
      return -1;
    } else if (isRecurring && other.isRecurring) {
      //both recurring
      if (DateTime.now().compareTo(endDate!) >= 0 &&
          DateTime.now().compareTo(other.endDate!) >= 0) {
        //both ended
        if (endDate!.compareTo(other.endDate!) >= 0) {
          //this ended after other
          return -1;
        } else {
          //this ended before other
          return 1;
        }
      } else if (DateTime.now().compareTo(endDate!) <= 0 &&
          DateTime.now().compareTo(other.endDate!) <= 0) {
        //both not ended
        if (calculateCurrentInterval()['end']!
                .difference(other.calculateCurrentInterval()['end']!) <=
            const Duration(days: 0)) {
          //this has less time than other
          return -1;
        } else {
          //this has more time than other
          return 1;
        }
      }
      if (DateTime.now().compareTo(endDate!) >= 0 &&
          DateTime.now().compareTo(other.endDate!) <= 0) {
        //this ended but other not
        return 1;
      } else if (DateTime.now().compareTo(endDate!) >= 0 &&
          DateTime.now().compareTo(other.endDate!) <= 0) {
        //other ended but this not
        return -1;
      } else {
        //both not recurring
        if (startDate.difference(other.startDate) <= const Duration(days: 0)) {
          //this started before other
          return -1;
        } else {
          //this started after other
          return 1;
        }
      }
    }
    return 0;
  }
}
