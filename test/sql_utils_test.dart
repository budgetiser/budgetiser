// Import the test package and Counter class
import 'package:budgetiser/shared/utils/date_utils.dart';
import 'package:budgetiser/shared/utils/sql_utils.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  test('Test sqlWhereIn', () {
    List<String> attributes = ['id', 'name'];
    List<List<int>> values = [
      [1, 3, 4],
      [5, 6, 7],
    ];

    String result = sqlWhereIn(attributes, values);

    expect(result, 'id IN (1,3,4) AND name IN (5,6,7)');
  });

  test('Test sqlWhereIn short', () {
    List<String> attributes = ['id'];
    List<List<int>> values = [
      [1, 3, 4],
    ];

    String result = sqlWhereIn(attributes, values);

    expect(result, 'id IN (1,3,4)');
  });

  test('Test sqlWhereIn half empty', () {
    List<String> attributes = ['id', 'name'];
    List<List<int>> values = [
      [1, 3, 4],
      [],
    ];

    String result = sqlWhereIn(attributes, values);

    expect(result, 'id IN (1,3,4)');
  });

  test('Test sqlWhereIn all empty', () {
    List<String> attributes = ['name'];
    List<List<int>> values = [[]];

    String result = sqlWhereIn(attributes, values);

    expect(result, '');
  });

  test('Test sqlWhereIn assert error', () {
    List<String> attributes = ['id', 'name'];
    List<List<int>> values = [
      [1, 3, 4],
    ];

    expect(
      () {
        sqlWhereIn(attributes, values);
      },
      throwsA(
        isA<AssertionError>(),
      ),
    );
  });

  // sqlWhereDateRange
  test('Test sqlWhereDateRange', () {
    DateTime start = today();
    DateTime end = today().add(const Duration(days: 1));
    String result = sqlWhereDateRange(
      'date',
      DateTimeRange(
        start: start,
        end: end,
      ),
    );

    expect(
      result,
      'date BETWEEN ${start.millisecondsSinceEpoch} AND ${end.millisecondsSinceEpoch}',
    );
  });

  test('Test sqlWhereCombined', () {
    List<String> attributes = ['id', 'name', 'date'];
    List<List<int>> values = [
      [1, 3, 4],
      [5, 6, 7],
    ];
    DateTime start = today();
    DateTime end = today().add(const Duration(days: 1));

    String result = sqlWhereCombined(
      attributes,
      values,
      DateTimeRange(start: start, end: end),
    );

    expect(
      result,
      'id IN (1,3,4) AND name IN (5,6,7) AND date BETWEEN ${start.millisecondsSinceEpoch} AND ${end.millisecondsSinceEpoch}',
    );
  });
}
