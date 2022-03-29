import 'package:budgetiser/screens/transactions/newTransaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/services/transactionItem.dart';
import 'package:flutter/material.dart';
import '../../shared/dataClasses/account.dart';
import '../../shared/tempData/tempData.dart';
import '../../shared/widgets/drawer.dart';

class Transactions extends StatelessWidget {
  static String routeID = 'transactions';
  Transactions({Key? key}) : super(key: key);

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
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NewTransaction()));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
