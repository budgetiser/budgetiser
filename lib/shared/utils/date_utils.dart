/// Returns true if the two dates are on the same day ignoring the time.
bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

/// Return true is [date] is in the same month as DateTime.now()
bool isCurrentMonth(DateTime date) {
  return DateTime.now().month == date.month && DateTime.now().year == date.year;
}

/// Return [date] in 'YYYY-MM' string format
String dateAsYYYYMM(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}';
}

/// Return [date] in 'DD-MM-YYYY' string format
String dateAsDDMMYYYY(DateTime date) {
  return '${date.day.toString().padLeft(2, "0")}.${date.month.toString().padLeft(2, "0")}.${date.year}';
}
