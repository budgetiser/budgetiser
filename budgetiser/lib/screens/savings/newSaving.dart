import 'package:budgetiser/screens/savings/shared/savingForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewSaving extends StatelessWidget {
  const NewSaving({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Saving"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                SavingForm(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text("Add Saving"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
