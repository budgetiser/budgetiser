import 'package:budgetiser/accounts/widgets/account_items_widget.dart';
import 'package:budgetiser/core/drawer.dart';
import 'package:budgetiser/transactions/screens/transaction_form.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });
  static String routeID = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const CreateDrawer(),
      body: AccountItemsWidget(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TransactionForm(),
            ),
          );
        },
        label: const Text('new Transaction'),
        icon: const Icon(
          Icons.add,
        ),
        heroTag: 'newTransaction',
      ),
    );
  }
}
