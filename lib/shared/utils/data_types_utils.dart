/// rounds to 2 decimal places by cutting off all digits after
double roundDouble(double value) {
  return double.parse(value.toStringAsFixed(2));
}

/// rounds to 2 decimal places by cutting off all digits after
double roundString(String value) {
  return roundDouble(double.parse(value));
}

/// if string is empty(or can be trimmed empty) null is returned, otherwise the string itself
String? parseNullableString(String? s) {
  if (s == null) {
    return null;
  }
  s = s.trim();
  if (s == '') {
    return null;
  }
  return s;
}
