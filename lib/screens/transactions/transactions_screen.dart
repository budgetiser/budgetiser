import 'package:budgetiser/db/account_provider.dart';
import 'package:budgetiser/db/single_transaction_provider.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/transactions/transaction_expansion_tile.dart';
import 'package:budgetiser/screens/transactions/transaction_filter.dart';
import 'package:budgetiser/screens/transactions/transaction_form.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  static String routeID = 'transactions';
  const TransactionsScreen({
    Key? key,
    this.initialAccountsFilter,
    this.initialCategoriesFilter,
  }) : super(key: key);

  final List<Account>? initialAccountsFilter;
  final List<TransactionCategory>? initialCategoriesFilter;

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final GlobalKey _futureBuilderKey = GlobalKey();
  // Future<List<DateTime>> monthsFuture = TransactionModel().getAllMonths();

  List<Account>? _currentFilterAccounts = [];
  List<TransactionCategory> _currentFilterCategories = [];

  List<Account> _accountList =
      <Account>[]; // used for caching all accounts in order to query the list only one time

  @override
  void initState() {
    super.initState();

    AccountModel().getAllAccounts().then((value) => _accountList = value);

    if (widget.initialAccountsFilter != null) {
      _currentFilterAccounts = widget.initialAccountsFilter;
    }
    if (widget.initialCategoriesFilter != null) {
      _currentFilterCategories = widget.initialCategoriesFilter!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          transactionFilter(context),
        ],
      ),
      drawer: const CreateDrawer(),
      body: Consumer<TransactionModel>(builder: (context, value, child) {
        return FutureBuilder<Map<String, int>>(
          future: TransactionModel().getMonthlyCount(
            accounts: _currentFilterAccounts,
            categories: _currentFilterCategories,
          ),
          key: _futureBuilderKey,
          builder: (context, snapshot) {
            if (snapshot.hasData && _accountList.isNotEmpty) {
              return _screenContent(snapshot.data!, _accountList);
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TransactionForm(),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  // TODO: extract as seperate widget, use general multi picker
  IconButton transactionFilter(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_alt_sharp),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return TransactionFilter(
                initialCategories: _currentFilterCategories,
                initialAccounts: _currentFilterAccounts,
                onPickedCallback: (categories, accounts) {
                  setState(() {
                    _currentFilterCategories = categories;
                    _currentFilterAccounts = accounts;
                  });
                });
          },
        );
      },
    );
  }

  ListView _screenContent(
    Map<String, int> monthYearSnapshotData,
    List<Account> fullAccountList,
  ) {
    var keys = monthYearSnapshotData.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (context, i) {
        return TransactionExpansionTile(
          date: keys[i],
          count: monthYearSnapshotData[keys[i]]!,
          allAccounts: fullAccountList,
          accountsFilter: _currentFilterAccounts,
          categoriesFilter: _currentFilterCategories,
          initiallyExpanded: monthYearSnapshotData.keys
              .toList()
              .sublist(
                  0,
                  monthYearSnapshotData[monthYearSnapshotData.keys.first]! > 10
                      ? 1
                      : 2)
              .contains(keys[i]),
        );
      },
    );
  }
}
