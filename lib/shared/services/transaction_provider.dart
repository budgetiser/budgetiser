import 'package:flutter/material.dart';

class TransactionModel extends ChangeNotifier {
  void notifyTransactionUpdate() {
    notifyListeners();
  }
}
