import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/transactions/transaction_form.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String routeID = 'home';
  const HomeScreen({
    Key? key,
  }) : super(key: key);

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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TransactionForm()));
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
