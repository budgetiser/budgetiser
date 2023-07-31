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
