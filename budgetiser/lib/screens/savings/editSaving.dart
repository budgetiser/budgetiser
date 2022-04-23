import 'package:budgetiser/screens/savings/shared/savingForm.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:flutter/material.dart';

class EditSaving extends StatelessWidget {
  EditSaving({Key? key, required this.savingData}) : super(key: key);
  Savings savingData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Saving"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                SavingForm(
                  initialSavingData: savingData,
                ),
              ],
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
