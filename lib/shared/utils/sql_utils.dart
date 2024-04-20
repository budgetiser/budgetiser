import 'package:flutter/material.dart';

/// Returns where string for a SQL Query.
/// e.g. 'id in (1,2,3)'
///
/// ATTENTION: no ';' at the end
///
/// Values with empty list will be ignored.
/// Can return empty String.
String sqlWhereIn<T>(List<String> attributes, List<List<T>> values) {
  assert(attributes.isNotEmpty);
  assert(values.isNotEmpty);
  assert(attributes.length == values.length);

  String query = '';

  for (int i = 0; i < attributes.length; i++) {
    if (values[i].isEmpty) {
      continue;
    }
    query += '${attributes[i]} IN (';
    query += values[i].join(',');
    query += ')';
    if (i < attributes.length - 1 && values[i + 1].isNotEmpty) {
      query += ' AND ';
    }
  }
  return query;
}

/// Same as sqlWhereIn but with the additional 'WHERE ' if needed.
/// Can also return empty string.
String sqlWhereInWithWhere<T>(List<String> attributes, List<List<T>> values) {
  String query = sqlWhereIn(attributes, values);
  if (query == '') return '';

  return 'WHERE $query';
}

/// Returns date range selection where string for SQL
/// time in millisecondsSinceEpoch
/// e.g. '123 <= date <= 234'
String sqlWhereDateRange(String attribute, DateTimeRange dateRange) {
  return '$attribute BETWEEN ${dateRange.start.millisecondsSinceEpoch} AND ${dateRange.end.millisecondsSinceEpoch}';
}

/// Returns...
/// e.g. 'id IN (1,3,4) AND name IN (5,6,7) AND 123 <= date <= 234'
/// last item of [attributes] is attribute name of dateRange
String sqlWhereCombined<T>(
  List<String> attributes,
  List<List<T>> values,
  DateTimeRange dateRange,
) {
  assert(attributes.length - 1 == values.length);

  String query = '';
  query += sqlWhereIn(attributes.sublist(0, attributes.length - 1), values);
  if (query != '') {
    query += ' AND ';
  }
  query += sqlWhereDateRange(attributes.last, dateRange);
  return query;
}
