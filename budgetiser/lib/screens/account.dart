import 'package:budgetiser/screens/newAccount.dart';
import 'package:flutter/material.dart';
import '../shared/services/accountItem/accountItem.dart';
import '../shared/widgets/drawer.dart';

class Account extends StatelessWidget {
  static String routeID = 'account';
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Accounts",
        ),
      ),
      drawer: createDrawer(context),
      body: Center(
        child: Column(
          children: const [
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
