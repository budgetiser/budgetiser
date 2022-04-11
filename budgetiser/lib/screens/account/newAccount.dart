import 'package:budgetiser/bd/database.dart';
import 'package:budgetiser/screens/account/shared/accountForm.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/tempData/tempData.dart';
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
            child: AccountForm(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Account a = TMP_DATA_accountList[0];
          DatabaseHelper.instance.createAccount(a);
          Navigator.of(context).pop();
        },
        label: const Text("Add Account"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
