import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/transactions/transactionForm.dart';
import 'package:budgetiser/shared/widgets/drawer.dart';
import 'package:flutter/material.dart';

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
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                DatabaseHelper.instance.resetDB();
              },
              label: const Text("reset DB"),
              icon: const Icon(
                Icons.delete,
              ),
              heroTag: "resetDB",
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                await DatabaseHelper.instance.resetDB();
                await DatabaseHelper.instance.fillDBwithTMPdata();
              },
              label: const Text("reset and fill DB"),
              icon: const Icon(
                Icons.refresh,
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
