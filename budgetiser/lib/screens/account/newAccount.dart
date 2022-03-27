import 'package:budgetiser/screens/account/shared/accountForm.dart';
import 'package:budgetiser/screens/account/shared/savingAccountForm.dart';
import 'package:flutter/material.dart';

class NewAccount extends StatelessWidget {
  const NewAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Account"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                AccountForm(),
                Divider(
                  indent: 8,
                ),
                SavingAccountForm(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text("Add Account"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
