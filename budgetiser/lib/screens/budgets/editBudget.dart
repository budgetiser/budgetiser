import 'package:budgetiser/screens/budgets/shared/budgetForm.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:flutter/material.dart';

class EditBudget extends StatelessWidget {
  EditBudget({Key? key, this.initialBudget}) : super(key: key);
  Budget? initialBudget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Budget"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: BudgetForm(initialBudget: initialBudget,),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text("Save changes"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
