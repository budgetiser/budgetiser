import 'package:budgetiser/bd/database.dart';
import 'package:budgetiser/screens/transactions/transactionForm.dart';
import 'package:budgetiser/shared/services/transactionItem.dart';
import 'package:flutter/material.dart';
import '../../shared/tempData/tempData.dart';
import '../../shared/widgets/drawer.dart';

class Transactions extends StatefulWidget {
  static String routeID = 'transactions';
  Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // StreamBuilder<List<AbstractTransaction>>(
              //   stream: DatabaseHelper.instance.allTransactionStream,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return ListView.builder(
              //         scrollDirection: Axis.vertical,
              //         shrinkWrap: true,
              //         itemCount: snapshot.data!.length,
              //         itemBuilder: (BuildContext context, int index) {
              //           return TransactionItem(
              //             transactionData: snapshot.data![index],
              //           );
              //         },
              //       );
              //     } else if (snapshot.hasError) {
              //       return const Text("Oops!");
              //     }
              //     return const Center(child: CircularProgressIndicator());
              //   },
              // ),
              for (var transaction in TMP_DATA_transactionList)
                TransactionItem(
                  transactionData: transaction,
                ),
            ],
          ),
        ),
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
