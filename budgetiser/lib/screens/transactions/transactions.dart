import 'package:budgetiser/screens/transactions/newTransaction.dart';
import 'package:budgetiser/shared/services/transactionItem.dart';
import 'package:flutter/material.dart';
import '../../shared/widgets/drawer.dart';
import '../account/newAccount.dart';

class Transactions extends StatelessWidget {
  static String routeID = 'transactions';
  const Transactions({Key? key}) : super(key: key);

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
              TransactionItem(
                account: "account",
                category: "category",
                date: DateTime(2020, 3, 01),
                value: 321,
                isRecurring: false,
                notes: "notes lang alksdjfö lasdhf lökajhl sdkfh ",
              ),
              TransactionItem(
                account: "account",
                category: "category",
                date: DateTime(2020, 3, 01),
                value: -20,
                isRecurring: false,
                notes: "notesasdfadsfasd fd",
              ),
              TransactionItem(
                account: "account",
                category: "cat123",
                date: DateTime(2020, 3, 01),
                value: 4000,
                isRecurring: true,
                notes: "note sas d asdasdasd ad s",
              ),
              TransactionItem(
                account: "account",
                category: "asdfasd",
                date: DateTime(2020, 3, 01),
                value: 4000,
                isRecurring: true,
                notes: null,
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
