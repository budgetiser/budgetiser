import 'package:budgetiser/screens/newAccount.dart';
import 'package:flutter/material.dart';
import '../shared/services/accountItem.dart';

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Accounts"),
      ),
      body: Center(
        child: Column(
          children: [
            AccountItem("ksk", Icons.wallet_giftcard, 123),
            AccountItem("sparen pc", Icons.abc, -123),
            AccountItem("kreditkarte", Icons.payment, 123),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewAccount()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
