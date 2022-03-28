import 'package:budgetiser/screens/account/shared/accountForm.dart';
import 'package:budgetiser/screens/account/shared/savingAccountForm.dart';
import 'package:flutter/material.dart';

class NewBudget extends StatelessWidget {
  const NewBudget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Budget"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text("Add Budget"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
