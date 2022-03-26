import 'package:budgetiser/screens/account/shared/accountForm.dart';
import 'package:budgetiser/screens/account/shared/savingAccountForm.dart';
import 'package:flutter/material.dart';

class EditAccount extends StatelessWidget {
  EditAccount({
    Key? key,
    required this.accountName,
    required this.accountBalance,
  }) : super(key: key);

  final String accountName;
  final int accountBalance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Account"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                AccountForm(
                  initialName: accountName,
                  initalBalance: accountBalance,
                ),
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
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
