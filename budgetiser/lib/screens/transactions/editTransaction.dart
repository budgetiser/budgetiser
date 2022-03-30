import 'package:budgetiser/screens/transactions/shared/transactionForm.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:flutter/material.dart';

class EditTransaction extends StatelessWidget {
  EditTransaction({
    Key? key,
    required this.transactionData,
  }) : super(key: key);

  Transaction transactionData;

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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TransactionForm(
              initialTransactionData: transactionData,
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
