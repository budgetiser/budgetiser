import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:budgetiser/shared/utils/color_utils.dart';
import 'package:flutter/material.dart';

/// Use .label for a readable string representation
enum IntervalUnit {
  day('daily'),
  week('weekly'),
  month('monthly'),
  quarter('quarterly'),
  year('yearly'),
  endless('endless');

  const IntervalUnit(this.label);
  final String label;
}

class Budget extends Selectable {
  int id;
  String? description;
  double maxValue;
  IntervalUnit intervalUnit;
  List<TransactionCategory> transactionCategories;
  double? value;

  Budget({
    required this.id,
    required super.name,
    required super.icon,
    required super.color,
    required this.description,
    required this.maxValue,
    required this.intervalUnit,
    required this.transactionCategories,
    this.value,
  });

  Budget.fromDBmap(
      Map<String, dynamic> map, List<TransactionCategory> categoryList)
      : id = map['id'],
        description = map['description'],
        maxValue = map['max_value'],
        intervalUnit = IntervalUnit.values
            .firstWhere((e) => e.toString() == map['interval_unit']),
        transactionCategories = categoryList,
        super(
          name: map['name'].toString(),
          color: Color(map['color']),
          icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
        );

  Map<String, dynamic> toMap() => {
        'name': name.trim(),
        'icon': icon.codePoint,
        'color': ColorEx(color).toInt32,
        'description': description?.trim(),
        'max_value': maxValue,
        'interval_unit': intervalUnit.toString(),
      };

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    m['transactionCategories'] =
        transactionCategories.map((element) => element.id).toList();
    return m;
  }
}
