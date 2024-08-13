import 'package:flutter/foundation.dart';

List<Map<String, int>> getMissingRelations(
  List<Map<String, int>> expected,
  List<Map<String, dynamic>> actual,
) {
  List<Map<String, int>> missing = [];

  for (var expectItem in expected) {
    bool gotMatched = false;
    for (var actualItem in actual) {
      if (mapEquals(expectItem, actualItem)) {
        gotMatched = true;
        break;
      }
    }
    if (!gotMatched) {
      missing.add(expectItem);
    }
  }
  return missing;
}
