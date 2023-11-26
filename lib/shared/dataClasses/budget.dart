import 'package:budgetiser/shared/dataClasses/selectable.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';

enum IntervalUnit {
  day,
  week,
  month,
  quarter,
  year,
}

class Budget extends Selectable {
  int id;
  String? description;
  double maxValue;
  IntervalUnit intervalUnit;
  int intervalIndex;
  int? intervalRepetitions;
  DateTime startDate;
  DateTime? endDate;
  List<TransactionCategory> transactionCategories;

  Budget({
    required this.id,
    required super.name,
    required super.icon,
    required super.color,
    required this.description,
    required this.maxValue,
    required this.intervalUnit,
    required this.intervalIndex,
    this.intervalRepetitions,
    required this.startDate,
    this.endDate,
    required this.transactionCategories,
  });

  Map<String, dynamic> toMap() => {
        'name': name.trim(),
        'icon': icon.codePoint,
        'color': color.value,
        'description': description?.trim(),
        'maxValue': maxValue,
        'Interval_unit': intervalUnit.toString(),
        'intervalIndex': intervalIndex,
        'interval_repetitions': intervalRepetitions,
        'start_date': startDate.millisecondsSinceEpoch,
        'end_date': endDate?.millisecondsSinceEpoch,
      };

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    m['transactionCategories'] =
        transactionCategories.map((element) => element.id).toList();
    return m;
  }

// TODO: fix budgets
  // Map<String, DateTime> calculateCurrentInterval() {
  //   if (!isRecurring) return {};
  //   DateTime endInterval = DateTime.now();
  //   DateTime startInterval = DateTime.now();
  //   for (int i = 0; i < intervalRepetitions!; i++) {
  //     if (intervalType == IntervalType.fixedPointOfTime) {
  //       switch (intervalUnit) {
  //         case IntervalUnit.week:
  //           Duration untilFirstPointOfTime = Duration(
  //               days: (intervalAmount! - startDate.weekday) >= 0
  //                   ? intervalAmount! - startDate.weekday
  //                   : 7 - (startDate.weekday - intervalAmount!));
  //           Duration fromRepetitions =
  //               Duration(days: 7 * (intervalRepetitions! - 1 - i));
  //           DateTime a = startDate.add(untilFirstPointOfTime + fromRepetitions);
  //           if (a.compareTo(DateTime.now()) > 0) {
  //             endInterval = a;
  //             startInterval = a.subtract(const Duration(days: 7));
  //           }
  //           break;
  //         case IntervalUnit.month:
  //           Duration untilFirstPointOfTime = Duration(
  //               days: intervalAmount! - startDate.day >= 0
  //                   ? intervalAmount! - startDate.day
  //                   : Jiffy.parseFromDateTime(startDate).daysInMonth -
  //                       startDate.day +
  //                       intervalAmount!);
  //           DateTime a = startDate.add(untilFirstPointOfTime);
  //           a = Jiffy.parseFromDateTime(a)
  //               .add(months: intervalRepetitions! - 1 - i)
  //               .dateTime;
  //           if (a.compareTo(DateTime.now()) > 0) {
  //             endInterval = a;
  //             startInterval = Jiffy.parseFromDateTime(a)
  //                 .add(months: intervalRepetitions! - 2 - i)
  //                 .dateTime;
  //           }
  //           break;
  //         case IntervalUnit.year:
  //           Duration untilFirstPointOfTime = Duration(
  //             days: (intervalAmount! -
  //                         Jiffy.parseFromDateTime(startDate).dayOfYear >=
  //                     0)
  //                 ? intervalAmount! -
  //                     Jiffy.parseFromDateTime(startDate).dayOfYear
  //                 : ((Jiffy.parseFromDateTime(startDate).isLeapYear == true)
  //                         ? 366
  //                         : 365) -
  //                     Jiffy.parseFromDateTime(startDate).dayOfYear +
  //                     intervalAmount!,
  //           );
  //           DateTime a = startDate.add(untilFirstPointOfTime);
  //           a = Jiffy.parseFromDateTime(a)
  //               .add(years: intervalRepetitions! - 1 - i)
  //               .dateTime;
  //           if (a.compareTo(DateTime.now()) > 0) {
  //             endInterval = a;
  //             startInterval = Jiffy.parseFromDateTime(a)
  //                 .add(years: intervalRepetitions! - 2 - i)
  //                 .dateTime;
  //           }
  //           break;
  //         default:
  //           throw Exception('Error in _calculateEndDate: unknown intervalMode');
  //       }
  //     } else {
  //       switch (intervalUnit) {
  //         case IntervalUnit.day:
  //           DateTime a = startDate.add(
  //               Duration(days: intervalAmount!) * (intervalRepetitions! - i));
  //           if (a.compareTo(DateTime.now()) > 0) {
  //             endInterval = a;
  //             startInterval = a.subtract(Duration(days: intervalAmount!) *
  //                 (intervalRepetitions! - 1 - i));
  //           }
  //           break;
  //         case IntervalUnit.week:
  //           DateTime a = startDate.add(Duration(
  //               days: intervalAmount! * (intervalRepetitions! - i) * 7));
  //           if (a.compareTo(DateTime.now()) > 0) {
  //             endInterval = a;
  //             startInterval = a.subtract(Duration(days: intervalAmount!) *
  //                 (intervalRepetitions! - 1 - i));
  //           }
  //           break;
  //         case IntervalUnit.month:
  //           DateTime a = Jiffy.parseFromDateTime(startDate)
  //               .add(months: intervalAmount! * (intervalRepetitions! - i))
  //               .dateTime;
  //           if (a.compareTo(DateTime.now()) > 0) {
  //             endInterval = a;
  //             startInterval = Jiffy.parseFromDateTime(startDate)
  //                 .add(months: intervalAmount! * (intervalRepetitions! - i - 1))
  //                 .dateTime;
  //           }
  //           break;
  //         default:
  //           throw Exception('Error in _calculateEndDate: unknown intervalMode');
  //       }
  //     }
  //   }
  //   return {
  //     'start': startInterval,
  //     'end': endInterval,
  //   };
  // }

  // int compareTo(Budget other) {
  //   //negative: this is ordered before other
  //   //positive: this is ordered after other
  //   if (isRecurring && !other.isRecurring) {
  //     return 1;
  //   } else if (!isRecurring && other.isRecurring) {
  //     return -1;
  //   } else if (isRecurring && other.isRecurring) {
  //     //both recurring
  //     if (DateTime.now().compareTo(endDate!) >= 0 &&
  //         DateTime.now().compareTo(other.endDate!) >= 0) {
  //       //both ended
  //       if (endDate!.compareTo(other.endDate!) >= 0) {
  //         //this ended after other
  //         return -1;
  //       } else {
  //         //this ended before other
  //         return 1;
  //       }
  //     } else if (DateTime.now().compareTo(endDate!) <= 0 &&
  //         DateTime.now().compareTo(other.endDate!) <= 0) {
  //       //both not ended
  //       if (calculateCurrentInterval()['end']!
  //               .difference(other.calculateCurrentInterval()['end']!) <=
  //           const Duration(days: 0)) {
  //         //this has less time than other
  //         return -1;
  //       } else {
  //         //this has more time than other
  //         return 1;
  //       }
  //     }
  //     if (DateTime.now().compareTo(endDate!) >= 0 &&
  //         DateTime.now().compareTo(other.endDate!) <= 0) {
  //       //this ended but other not
  //       return 1;
  //     } else if (DateTime.now().compareTo(endDate!) >= 0 &&
  //         DateTime.now().compareTo(other.endDate!) <= 0) {
  //       //other ended but this not
  //       return -1;
  //     } else {
  //       //both not recurring
  //       if (startDate.difference(other.startDate) <= const Duration(days: 0)) {
  //         //this started before other
  //         return -1;
  //       } else {
  //         //this started after other
  //         return 1;
  //       }
  //     }
  //   }
  //   return 0;
  // }
}
