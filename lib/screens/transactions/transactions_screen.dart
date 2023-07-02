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
    // this.initialAccountFilterName,
  }) : super(key: key);

  // final String? initialAccountFilterName;

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String title = "Transactions";

  @override
  void initState() {
    DatabaseHelper.instance.pushGetAllTransactionsStream();
    DatabaseHelper.instance.allAccountsStream.listen((event) {
      _accountList = event;
    });
    DatabaseHelper.instance.allCategoryStream.listen((event) {
      _categoryList = event;
    });
    DatabaseHelper.instance.pushGetAllAccountsStream();
    DatabaseHelper.instance.pushGetAllCategoriesStream();

    // if (widget.initialAccountFilterName != null) {
    //   _currentFilterAccount = widget.initialAccountFilterName!;
    // }

    super.initState();
  }

  Account? _currentFilterAccount;
  TransactionCategory? _currentFilterCategory;

  List<Account> _accountList = <Account>[];
  List<TransactionCategory> _categoryList = <TransactionCategory>[];

  // Function to filter all transactions by account and category
  // bool _filterFunction(SingleTransaction transaction) {
  //   if (_currentFilterAccount == "") {
  //     if (_currentFilterCategory == "") {
  //       return true;
  //     } else {
  //       return transaction.category.name == _currentFilterCategory;
  //     }
  //   } else {
  //     if (_currentFilterCategory == "") {
  //       return transaction.account.name == _currentFilterAccount ||
  //           (transaction.account2 != null &&
  //               transaction.account2!.name == _currentFilterAccount);
  //     } else {
  //       return (transaction.account.name == _currentFilterAccount ||
  //               (transaction.account2 != null &&
  //                   transaction.account2!.name == _currentFilterAccount)) &&
  //           transaction.category.name == _currentFilterCategory;
  //     }
  //   }
  // }

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
                    elevation: 0,
                    contentPadding: const EdgeInsets.only(right: 25),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filter'),
                        ElevatedButton(
                          onPressed: (_currentFilterAccount == "" &&
                                  _currentFilterCategory == "")
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
      drawer: createDrawer(context),
      body: FutureBuilder<List<DateTime>>(
        future: DatabaseHelper.instance.getAllMonths(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  for (DateTime monthYear in snapshot.data!)
                    FutureBuilder<List<SingleTransaction>>(
                      future: DatabaseHelper.instance
                          .getFilteredTransactionsByMonth(
                              inMonth: monthYear,
                              account: _currentFilterAccount,
                              category: _currentFilterCategory),
                      builder: (context, snapshot) {
                        print("===");
                        if (snapshot.hasData) {
                          print("data");
                          print(snapshot.data!);
                          return ExpansionTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${monthYear.year}-${monthYear.month.toString().padLeft(2, '0')}"),
                                Text(snapshot.data!.length.toString()),
                              ],
                            ),
                            children: [
                              SizedBox(
                                height: 400,
                                child: ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return TransactionItem(
                                      singleTransactionData:
                                          snapshot.data![index],
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
