import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/transactions/transaction_form.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/widgets/items/transaction_item.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/shared/widgets/smallStuff/category_text_with_icon.dart';
import 'package:budgetiser/shared/widgets/smallStuff/account_text_with_icon.dart';
import 'package:flutter/material.dart';

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
  String title = "Transactions";

  @override
  void initState() {
    DatabaseHelper.instance.allTransactionStream.listen((event) {
      updateMonthsFuture();
    });
    DatabaseHelper.instance.allAccountsStream.listen((event) {
      _accountList = event;
    });
    DatabaseHelper.instance.allCategoryStream.listen((event) {
      _categoryList = event;
    });
    DatabaseHelper.instance.pushGetAllAccountsStream();
    DatabaseHelper.instance.pushGetAllCategoriesStream();

    if (widget.initialAccountFilter != null) {
      _currentFilterAccount = widget.initialAccountFilter;
    }
    if (widget.initialCategoryFilter != null) {
      _currentFilterCategory = widget.initialCategoryFilter;
    }

    super.initState();
  }

  final GlobalKey _futureBuilderKey = GlobalKey();
  Future<List<DateTime>> monthsFuture = DatabaseHelper.instance.getAllMonths();

  Account? _currentFilterAccount;
  TransactionCategory? _currentFilterCategory;

  List<Account> _accountList = <Account>[];
  List<TransactionCategory> _categoryList = <TransactionCategory>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
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
                          child: const Text("Reset"),
                        ),
                      ],
                    ),
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10,
                        ),
                        child: Text("By Account"),
                      ),
                      ListTile(
                        title: const Text("All Accounts"),
                        visualDensity: VisualDensity.compact,
                        leading: Radio<Account?>(
                          value: null,
                          groupValue: _currentFilterAccount,
                          onChanged: (value) {
                            setState(() {
                              _currentFilterAccount = value;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
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
                        child: Text("By Category"),
                      ),
                      ListTile(
                        title: const Text("All Categories"),
                        visualDensity: VisualDensity.compact,
                        leading: Radio<TransactionCategory?>(
                          value: null,
                          groupValue: _currentFilterCategory,
                          onChanged: (value) {
                            setState(() {
                              _currentFilterCategory = value;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      for (var category in _categoryList)
                        _categoryFilterListTile(category),
                    ],
                  );
                },
              );
            },
          ),
        ],
        title: Text(title),
      ),
      drawer: const CreateDrawer(),
      body: FutureBuilder<List<DateTime>>(
        future: monthsFuture,
        key: _futureBuilderKey,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _screenContent(snapshot);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TransactionForm()));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void updateMonthsFuture() async {
    if (mounted) {
      setState(() {
        monthsFuture = DatabaseHelper.instance.getAllMonths();
      });
    }
  }

  SingleChildScrollView _screenContent(AsyncSnapshot<List<DateTime>> snapshot) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        children: [
          for (DateTime monthYear in snapshot.data!)
            FutureBuilder<List<SingleTransaction>>(
              future: DatabaseHelper.instance.getFilteredTransactionsByMonth(
                  inMonth: monthYear,
                  account: _currentFilterAccount,
                  category: _currentFilterCategory),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  bool isCurrentMonth =
                      DateTime.now().month == monthYear.month &&
                          DateTime.now().year == monthYear.year;
                  if (snapshot.data!.isEmpty) return Container();
                  return ExpansionTile(
                    backgroundColor: Theme.of(context).dividerTheme.color,
                    collapsedBackgroundColor:
                        Theme.of(context).dividerTheme.color,
                    onExpansionChanged: (value) => updateMonthsFuture(),
                    initiallyExpanded: isCurrentMonth,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isCurrentMonth)
                          const Text("Current Month")
                        else
                          Text(
                              "${monthYear.year}-${monthYear.month.toString().padLeft(2, '0')}"),
                        Text(snapshot.data!.length.toString()),
                      ],
                    ),
                    children: [
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return TransactionItem(
                              singleTransactionData: snapshot.data![index],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
        ],
      ),
    );
  }

  ListTile _accountFilterListTile(Account element) {
    return ListTile(
      title: AccountTextWithIcon(element),
      visualDensity: VisualDensity.compact,
      leading: Radio<Account>(
        value: element,
        groupValue: _currentFilterAccount,
        onChanged: (value) {
          setState(() {
            _currentFilterAccount = value;
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  ListTile _categoryFilterListTile(TransactionCategory element) {
    return ListTile(
      title: CategoryTextWithIcon(element),
      visualDensity: VisualDensity.compact,
      leading: Radio<TransactionCategory>(
        value: element,
        groupValue: _currentFilterCategory,
        onChanged: (value) {
          setState(() {
            _currentFilterCategory = value;
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
