import 'package:badges/badges.dart' as badges;
import 'package:budgetiser/accounts/widgets/account_multi_picker.dart';
import 'package:budgetiser/categories/picker/category_picker.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/core/drawer.dart';
import 'package:budgetiser/transactions/multi_step_form/account_selection_step.dart';
import 'package:budgetiser/transactions/multi_step_form/multi_step_form.dart';
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

  List<Account> _currentFilterAccounts = [];
  List<TransactionCategory> _currentFilterCategories = [];

  List<Account> _accountList =
      <Account>[]; // used for caching all accounts in order to query the list only one time

  @override
  void initState() {
    super.initState();

    Provider.of<AccountModel>(context, listen: false)
        .getAllAccounts()
        .then((value) => _accountList = value);

    if (widget.initialAccountsFilter != null) {
      _currentFilterAccounts = widget.initialAccountsFilter!;
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
          Semantics(
            label: 'filter by category',
            child: IconButton(
              icon: badges.Badge(
                badgeContent: Text(
                  _currentFilterCategories.length.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
                showBadge: _currentFilterCategories.isNotEmpty,
                child: const Icon(
                  Icons.filter_alt_sharp,
                  semanticLabel: 'filter by category',
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CategoryPicker.multi(
                      onCategoryPickedCallbackMulti: (selected) {
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
          ),
          Semantics(
            label: 'filter by account',
            child: IconButton(
              icon: badges.Badge(
                badgeContent: Text(
                  _currentFilterAccounts.length.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
                showBadge: _currentFilterAccounts.isNotEmpty,
                child: const Icon(
                  Icons.account_balance,
                  semanticLabel: 'filter by account',
                ),
              ),
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
          ),
        ],
      ),
      drawer: const CreateDrawer(),
      body: Consumer<TransactionModel>(
        builder: (context, model, child) {
          return FutureBuilder<Map<String, int>>(
            future: model.getMonthlyCount(
              accounts: _currentFilterAccounts,
              categories: _currentFilterCategories,
            ),
            key: _futureBuilderKey,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No Transactions'),
                );
              }
              return _screenContent(snapshot.data!, _accountList);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          semanticLabel: 'add transaction',
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MultiStepTransactionForm(steps: [
                AccountSelectionStep(),
                AccountSelectionStep(),
                AccountSelectionStep()
              ]),
            ),
          );
        },
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
      padding: const EdgeInsets.only(bottom: 100),
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
                    : 1,
              )
              .contains(keys[i]),
        );
      },
    );
  }
}
