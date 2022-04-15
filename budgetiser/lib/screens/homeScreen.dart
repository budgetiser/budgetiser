import 'package:budgetiser/bd/database.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
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
            FloatingActionButton.extended(
              onPressed: () {
                DatabaseHelper.instance.resetDB();
              },
              label: const Text("reset DB"),
              icon: const Icon(
                Icons.add,
              ),
              heroTag: "resetDB",
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                await DatabaseHelper.instance.resetDB();
                await DatabaseHelper.instance.fillDBwithTMPdata();
              },
              label: const Text("reset and fill DB"),
              icon: const Icon(
                Icons.add,
              ),
              heroTag: "fillDB",
            ),
          ],
        ),
      ),
      drawer: createDrawer(context),
    );
  }
}
