import 'package:budgetiser/accounts/widgets/account_multi_picker.dart';
import 'package:budgetiser/categories/widgets/category_multi_picker.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/core/drawer.dart';
import 'package:budgetiser/transactions/screens/transaction_form.dart';
import 'package:budgetiser/transactions/widgets/transaction_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({
    super.key,
    this.initialAccountsFilter,
    this.initialCategoriesFilter,
  });
  static String routeID = 'transactions';

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
          IconButton(
            icon: const Icon(Icons.filter_alt_sharp),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CategoryMultiPicker(
                    onCategoriesPickedCallback: (selected) {
                      setState(() {
                        _currentFilterCategories = selected;
                      });
                    },
                    initialValues: _currentFilterCategories,
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_balance),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AccountMultiPicker(
                    onAccountsPickedCallback: (selected) {
                      setState(() {
                        _currentFilterAccounts = selected;
                      });
                    },
                    initialValues: _currentFilterAccounts,
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: const CreateDrawer(),
      body: Consumer<TransactionModel>(builder: (context, model, child) {
        return FutureBuilder<Map<String, int>>(
          future: model.getMonthlyCount(
            accounts: _currentFilterAccounts,
            categories: _currentFilterCategories,
          ),
          key: _futureBuilderKey,
          builder: (context, snapshot) {
            if (!snapshot.hasData && _accountList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No Transactions'),
              );
            }
            return _screenContent(snapshot.data!, _accountList);
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

  Widget _screenContent(
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
          initiallyExpanded: monthYearSnapshotData
              .keys // TODO: broken whenn only one transaction
              .toList()
              .sublist(
                  0,
                  monthYearSnapshotData[monthYearSnapshotData.keys.first]! > 10
                      ? 1
                      : 1)
              .contains(keys[i]),
        );
      },
    );
  }
}
