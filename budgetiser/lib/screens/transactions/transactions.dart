import 'package:budgetiser/screens/transactions/newTransaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/services/transactionItem.dart';
import 'package:flutter/material.dart';
import '../../shared/dataClasses/account.dart';
import '../../shared/widgets/drawer.dart';

class Transactions extends StatelessWidget {
  static String routeID = 'transactions';
  Transactions({Key? key}) : super(key: key);

  List<Transaction> transactionList = [
    SingleTransaction(
      id: 1,
      title: 'Test',
      value: 10.0,
      category: TransactionCategory(
        id: 123,
        name: 'Test',
        icon: Icons.abc,
        color: Colors.red,
        description: "Test description",
        isHidden: false,
      ),
      account: Account(
        id: 123,
        name: 'ksk',
        icon: Icons.account_balance_wallet,
        color: Colors.red,
        balance: 10.0,
        description: "Test description",
      ),
      date: DateTime.now(),
      description: 'Test description',
    ),
    SingleTransaction(
      id: 2,
      title: 'second transaction',
      value: 10.0,
      category: TransactionCategory(
        id: 123,
        name: 'Test',
        icon: Icons.abc,
        color: Colors.red,
        description: "Test description",
        isHidden: false,
      ),
      account: Account(
        id: 1232,
        name: 'pocket',
        icon: Icons.account_balance_wallet,
        color: Colors.red,
        balance: 10.0,
        description: "Test description",
      ),
      date: DateTime.now(),
      description: 'Test description',
    ),
    RecurringTransaction(
      id: 3,
      title: 'Recurring transaction',
      value: 10.0,
      category: TransactionCategory(
        id: 123,
        name: 'Test',
        icon: Icons.abc,
        color: Colors.red,
        description: "Test description",
        isHidden: false,
      ),
      account: Account(
        id: 123,
        name: 'ksk',
        icon: Icons.account_balance_wallet,
        color: Colors.red,
        balance: 10.0,
        description: "Test description",
      ),
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      intervalType: 'Daily',
      intervalAmount: 1,
      intervalUnit: 'Days',
      description: 'Test description',
    ),
  ];

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
              for (var transaction in transactionList)
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
