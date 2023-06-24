import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/transactions/transaction_form.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/shared/widgets/confirmation_dialog.dart';
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
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TransactionForm()));
              },
              label: const Text("new Transaction"),
              icon: const Icon(
                Icons.add,
              ),
              heroTag: "newTransaction",
            ),
            const SizedBox(
              height: 80,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: "Attention",
                      description: "Are you sure? This action can't be undone!",
                      onSubmitCallback: () {
                        DatabaseHelper.instance.resetDB();
                        Navigator.of(context).pop();
                      },
                      onCancelCallback: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              label: const Text("reset DB"),
              icon: const Icon(
                Icons.delete,
              ),
              heroTag: "resetDB",
              backgroundColor: Colors.red,
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: "Attention",
                      description: "Are you sure? This action can't be undone!",
                      onSubmitCallback: () async {
                        await DatabaseHelper.instance.resetDB();
                        await DatabaseHelper.instance.fillDBwithTMPdata();
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      },
                      onCancelCallback: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              label: const Text("reset and fill DB"),
              icon: const Icon(
                Icons.refresh,
              ),
              heroTag: "fillDB",
              backgroundColor: Colors.red,
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("DB reset and filled with TMP data"),
                  ),
                );
              },
              label: const Text("test"),
              icon: const Icon(
                Icons.refresh,
              ),
              heroTag: "test",
            ),
          ],
        ),
      ),
      drawer: createDrawer(context),
    );
  }
}
