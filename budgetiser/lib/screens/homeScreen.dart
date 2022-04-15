import 'package:budgetiser/screens/transactions/transactionForm.dart';
import 'package:flutter/material.dart';

import '../shared/widgets/drawer.dart';

class Home extends StatefulWidget {
  static String routeID = 'home';
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TransactionForm()));
          },
          label: const Text("new Transaction"),
          icon: const Icon(
            Icons.add,
          ),
          heroTag: "newTransaction",
        ),
      ),
      drawer: createDrawer(context),
    );
  }
}