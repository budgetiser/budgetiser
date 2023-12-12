import 'package:budgetiser/db/account_provider.dart';
import 'package:budgetiser/db/category_provider.dart';
import 'package:budgetiser/db/single_transaction_provider.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/transactions/transaction_expansion_tile.dart';
import 'package:budgetiser/screens/transactions/transaction_form.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/widgets/smallStuff/account_text_with_icon.dart';
import 'package:budgetiser/shared/widgets/smallStuff/category_text_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  static String routeID = 'transactions';
  const TransactionsScreen({
    Key? key,
    this.initialAccountFilter,
    this.initialCategoryFilter,
  }) : super(key: key);

  final Account? initialAccountFilter;
  final TransactionCategory? initialCategoryFilter;

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final GlobalKey _futureBuilderKey = GlobalKey();
  // Future<List<DateTime>> monthsFuture = TransactionModel().getAllMonths();

  Account? _currentFilterAccount;
  TransactionCategory? _currentFilterCategory;

  List<Account> _accountList = <Account>[];
  List<TransactionCategory> _categoryList = <TransactionCategory>[];

  @override
  void initState() {
    super.initState();

    CategoryModel().getAllCategories().then((value) => _categoryList = value);
    AccountModel().getAllAccounts().then((value) => _accountList = value);

    if (widget.initialAccountFilter != null) {
      _currentFilterAccount = widget.initialAccountFilter;
    }
    if (widget.initialCategoryFilter != null) {
      _currentFilterCategory = widget.initialCategoryFilter;
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
          future: TransactionModel().getMonthlyCount(),
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
            return SimpleDialog(
              contentPadding: const EdgeInsets.only(right: 25),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filter'),
                  ElevatedButton(
                    onPressed: (_currentFilterAccount == null &&
                            _currentFilterCategory == null)
                        ? null
                        : () {
                            setState(() {
                              _currentFilterAccount = null;
                              _currentFilterCategory = null;
                            });
                            Navigator.pop(context);
                          },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  child: Text('By Account'),
                ),
                RadioListTile<Account?>(
                  value: null,
                  title: const Text('All Accounts'),
                  visualDensity: VisualDensity.compact,
                  groupValue: _currentFilterAccount,
                  onChanged: (value) {
                    setState(() {
                      _currentFilterAccount = value;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                for (var account in _accountList)
                  _accountFilterListTile(account),
                const Divider(
                  indent: 25,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  child: Text('By Category'),
                ),
                RadioListTile<TransactionCategory?>(
                  value: null,
                  title: const Text('All Categories'),
                  visualDensity: VisualDensity.compact,
                  groupValue: _currentFilterCategory,
                  onChanged: (value) {
                    setState(() {
                      _currentFilterCategory = value;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                for (var category in _categoryList)
                  _categoryFilterListTile(category),
              ],
            );
          },
        );
      },
    );
  }

  SingleChildScrollView _screenContent(
    Map<String, int> monthYearSnapshotData,
    List<Account> fullAccountList,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        children: [
          for (var item in monthYearSnapshotData.keys)
            TransactionExpansionTile(
              date: item,
              count: monthYearSnapshotData[item]!,
              allAccounts: fullAccountList,
              accountFilter: _currentFilterAccount,
              categoryFilter: _currentFilterCategory,
              initiallyExpanded: monthYearSnapshotData.keys
                  .toList()
                  .sublist(
                      0,
                      monthYearSnapshotData[monthYearSnapshotData.keys.first]! >
                              10
                          ? 1
                          : 2)
                  .contains(item),
            ),
        ],
      ),
    );
  }

  RadioListTile _accountFilterListTile(Account element) {
    return RadioListTile<Account>(
      value: element,
      title: AccountTextWithIcon(element),
      visualDensity: VisualDensity.compact,
      groupValue: _currentFilterAccount,
      onChanged: (value) {
        setState(() {
          _currentFilterAccount = value;
        });
        Navigator.of(context).pop();
      },
    );
  }

  RadioListTile _categoryFilterListTile(TransactionCategory element) {
    return RadioListTile<TransactionCategory>(
      value: element,
      title: CategoryTextWithIcon(element),
      visualDensity: VisualDensity.compact,
      groupValue: _currentFilterCategory,
      onChanged: (value) {
        setState(() {
          _currentFilterCategory = value;
        });
        Navigator.of(context).pop();
      },
    );
  }
}
