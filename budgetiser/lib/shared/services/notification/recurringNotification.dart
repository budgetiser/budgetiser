import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:flutter/material.dart';

class RecurringNotification extends Notification {
  final RecurringData recurringData;

  RecurringNotification(this.recurringData);
}
