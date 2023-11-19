import 'package:budgetiser/db/category_provider.dart';
import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/db/single_transaction_provider.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/transactions/transaction_form.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/utils/date_utils.dart';
import 'package:budgetiser/shared/widgets/items/transaction_item.dart';
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
  Future<List<DateTime>> monthsFuture = TransactionModel().getAllMonths();

  Account? _currentFilterAccount;
  TransactionCategory? _currentFilterCategory;

  List<Account> _accountList = <Account>[];
  List<TransactionCategory> _categoryList = <TransactionCategory>[];

  @override
  void initState() {
    super.initState();

    CategoryModel().getAllCategories().then((value) => _categoryList = value);
    DatabaseHelper.instance.allAccountsStream.listen((event) {
      _accountList = event;
    });
    DatabaseHelper.instance.pushGetAllAccountsStream();

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
        actions: [
          transactionFilter(context),
        ],
        title: const Text('Transactions'),
      ),
      drawer: const CreateDrawer(),
      body: Consumer<TransactionModel>(builder: (context, value, child) {
        return FutureBuilder<List<DateTime>>(
          future: TransactionModel().getAllMonths(),
          key: _futureBuilderKey,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _screenContent(snapshot.data!);
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

  void updateMonthsFuture() async {
    if (mounted) {
      setState(() {
        monthsFuture = TransactionModel().getAllMonths();
      });
    }
  }

  SingleChildScrollView _screenContent(List<DateTime> monthYearSnapshotData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        children: [
          for (DateTime monthYear in monthYearSnapshotData)
            FutureBuilder<List<SingleTransaction>>(
              future: TransactionModel().getFilteredTransactionsByMonth(
                inMonth: monthYear,
                account: _currentFilterAccount,
                category: _currentFilterCategory,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return Container();
                }
                return ExpansionTile(
                  backgroundColor: Theme.of(context).dividerTheme.color,
                  collapsedBackgroundColor:
                      Theme.of(context).dividerTheme.color,
                  initiallyExpanded: isCurrentMonth(monthYear),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isCurrentMonth(monthYear))
                        const Text('Current Month')
                      else
                        Text(dateAsYYYYMM(monthYear)),
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
                            // TODO: Bug: no splash effect. probably because of colored container
                            transactionData: snapshot.data![index],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
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
