// Import the test package and Counter class
import 'package:budgetiser/shared/utils/sql_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Test sqlWhereIn', () {
    List<String> attributes = ['id', 'name'];
    List<List<int>> values = [
      [1, 3, 4],
      [5, 6, 7]
    ];

    String result = sqlWhereIn(attributes, values);

    expect(result, 'WHERE id IN (1,3,4) AND name IN (5,6,7)');
  });

  test('Test sqlWhereIn short', () {
    List<String> attributes = ['id'];
    List<List<int>> values = [
      [1, 3, 4]
    ];

    String result = sqlWhereIn(attributes, values);

    expect(result, 'WHERE id IN (1,3,4)');
  });

  test('Test sqlWhereIn half empty', () {
    List<String> attributes = ['id', 'name'];
    List<List<int>> values = [
      [1, 3, 4],
      []
    ];

    String result = sqlWhereIn(attributes, values);

    expect(result, 'WHERE id IN (1,3,4)');
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
      [1, 3, 4]
    ];

    expect(() {
      sqlWhereIn(attributes, values);
    }, throwsA(isA<AssertionError>()));
  });
}
