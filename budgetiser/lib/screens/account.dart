import 'package:flutter/material.dart';
import '../shared/services/accountItem/accountItem.dart';

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Accounts",
          style: Theme.of(context).textTheme.caption,
        ),
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
        onPressed: null,
        tooltip: 'Increment',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add),
      ),
    );
  }
}
