import 'package:budgetiser/bd/database.dart';
import 'package:budgetiser/screens/transactions/transactionForm.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/services/transactionItem.dart';
import 'package:budgetiser/shared/widgets/drawer.dart';
import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  static String routeID = 'transactions';
  TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    DatabaseHelper.instance.pushGetAllTransactionsStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transactions",
        ),
      ),
      drawer: createDrawer(context),
      body: StreamBuilder<List<AbstractTransaction>>(
        stream: DatabaseHelper.instance.allTransactionStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return TransactionItem(
                  transactionData: snapshot.data![index],
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Text("Oops!");
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TransactionForm()));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}