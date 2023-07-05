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
    this.initialAccountFilterName,
  }) : super(key: key);

  final String? initialAccountFilterName;

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

    if (widget.initialAccountFilterName != null) {
      _currentFilterAccountName = widget.initialAccountFilterName!;
    }
    super.initState();
  }

  String _currentFilterAccountName = "";
  String _currentFilterCategoryName = "";

  List<Account> _accountList = <Account>[];
  List<TransactionCategory> _categoryList = <TransactionCategory>[];

  // Function to filter all transactions by account and category
  bool _filterFunction(SingleTransaction transaction) {
    if (_currentFilterAccountName == "") {
      if (_currentFilterCategoryName == "") {
        return true;
      } else {
        return transaction.category.name == _currentFilterCategoryName;
      }
    } else {
      if (_currentFilterCategoryName == "") {
        return transaction.account.name == _currentFilterAccountName ||
            (transaction.account2 != null &&
                transaction.account2!.name == _currentFilterAccountName);
      } else {
        return (transaction.account.name == _currentFilterAccountName ||
                (transaction.account2 != null &&
                    transaction.account2!.name == _currentFilterAccountName)) &&
            transaction.category.name == _currentFilterCategoryName;
      }
    }
  }

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
                          onPressed: (_currentFilterAccountName == "" &&
                                  _currentFilterCategoryName == "")
                              ? null
                              : () {
                                  setState(() {
                                    _currentFilterAccountName = "";
                                    _currentFilterCategoryName = "";
                                  });
                                  Navigator.pop(context);
                                },
                          child: const Text("Reset"),
                        ),
                      ],
                    ),
                    alignment: Alignment.topRight,
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
                        leading: Radio(
                          value: "",
                          groupValue: _currentFilterAccountName,
                          onChanged: (value) {
                            setState(() {
                              _currentFilterAccountName = value.toString();
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      for (var account in _accountList)
                        _filterListTile(account),
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
                        leading: Radio(
                          value: "",
                          groupValue: _currentFilterCategoryName,
                          onChanged: (value) {
                            setState(() {
                              _currentFilterCategoryName = value.toString();
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      for (var category in _categoryList)
                        _filterListTile(category),
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
      body: StreamBuilder<List<SingleTransaction>>(
        stream: DatabaseHelper.instance.allTransactionStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var filteredList = snapshot.data!.where(_filterFunction).toList();
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: filteredList.length,
              itemBuilder: (BuildContext context, int index) {
                return TransactionItem(
                  singleTransactionData: filteredList[index],
                );
              },
              padding: const EdgeInsets.only(bottom: 80),
            );
          } else if (snapshot.hasError) {
            return const Text("Oops!");
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

  ListTile _filterListTile(element) {
    if (element is! Account && element is! TransactionCategory) {
      throw Exception("Unknown element passed to _filterListTile");
    }
    return ListTile(
      title: element is Account
          ? AccountTextWithIcon(element)
          : CategoryTextWithIcon(element),
      visualDensity: VisualDensity.compact,
      leading: Radio(
        value: element.name.toString(),
        groupValue: (element is Account)
            ? _currentFilterAccountName
            : _currentFilterCategoryName,
        onChanged: (value) {
          setState(() {
            if (element is Account) {
              _currentFilterAccountName = value.toString();
            } else {
              _currentFilterCategoryName = value.toString();
            }
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
