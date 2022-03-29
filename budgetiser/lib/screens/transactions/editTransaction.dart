import 'package:budgetiser/screens/transactions/shared/transactionForm.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/drawer.dart';

class EditTransaction extends StatelessWidget {
  EditTransaction({
    Key? key,
    required this.initialNotes,
    required this.initialTitle,
    required this.initialValue,
    required this.initialIntervalMode,
    required this.initialIsRecurring,
  }) : super(key: key);

  bool? initialIsRecurring;
  String? initialIntervalMode;
  String? initialTitle;
  int? initialValue;
  String? initialNotes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Transaction"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: TransactionForm(
              initialIntervalMode: initialIntervalMode,
              initialIsRecurring: initialIsRecurring,
              initialNotes: initialNotes,
              initialTitle: initialTitle,
              initialValue: initialValue,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
