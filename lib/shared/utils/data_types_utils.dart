/// rounds to 2 decimal places by cutting off all digits after
double roundDouble(double value) {
  return double.parse(value.toStringAsFixed(2));
}

/// rounds to 2 decimal places by cutting off all digits after
double roundString(String value) {
  return roundDouble(double.parse(value));
}
