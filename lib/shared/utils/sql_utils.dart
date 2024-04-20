/// Returns where string for a SQL Query
/// e.g. 'WHERE id in (1,2,3)'
///
/// ATTENTION: no ';' at the end
///
/// values with empty list will be ignored
String sqlWhereIn<T>(List<String> attributes, List<List<T>> values) {
  assert(attributes.isNotEmpty);
  assert(values.isNotEmpty);
  assert(attributes.length == values.length);

  String query = 'WHERE ';

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
  if (query == 'WHERE ') return '';

  return query;
}
