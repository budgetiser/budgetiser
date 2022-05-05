import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/transactions/transactionForm.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/recurringTransaction.dart';
import 'package:budgetiser/shared/dataClasses/singleTransaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/widgets/transactionItem.dart';
import 'package:budgetiser/drawer.dart';
import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  static String routeID = 'transactions';
  const TransactionsScreen({
    Key? key,
    this.initalAccountFilterName,
  }) : super(key: key);

  final String? initalAccountFilterName;

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

enum pages { singleTransactions, recurringTransactions }

class _TransactionsScreenState extends State<TransactionsScreen> {
  final PageController _pageController = PageController(
    initialPage: pages.singleTransactions.index,
  );
  String title = "Transactions";

  @override
  void initState() {
    DatabaseHelper.instance.pushGetAllTransactionsStream();
    DatabaseHelper.instance.pushGetAllRecurringTransactionsStream();
    DatabaseHelper.instance.allAccountsStream.listen((event) {
      _accountList = event;
    });
    DatabaseHelper.instance.allCategoryStream.listen((event) {
      _categoryList = event;
    });
    DatabaseHelper.instance.pushGetAllAccountsStream();
    DatabaseHelper.instance.pushGetAllCategoriesStream();

    if (widget.initalAccountFilterName != null) {
      _currentFilterAccountName = widget.initalAccountFilterName!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _currentFilterAccountName = "";
  String _currentFilterCategoryName = "";

  List<Account> _accountList = <Account>[];
  List<TransactionCategory> _categoryList = <TransactionCategory>[];

  // Function to filter all transactions by account and category
  bool _filterFunction(transaction) {
    if (transaction is SingleTransaction ||
        transaction is RecurringTransaction) {
      transaction = transaction;
    } else {
      throw Exception("Unknown transaction type passed to filterFunction");
    }

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
                    title: const Text('Filter'),
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
                        ListTile(
                          visualDensity: VisualDensity.compact,
                          title: Text(account.name),
                          leading: Radio(
                            value: account.name,
                            groupValue: _currentFilterAccountName,
                            onChanged: (value) {
                              setState(() {
                                _currentFilterAccountName = value.toString();
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      // divider
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
                        ListTile(
                          visualDensity: VisualDensity.compact,
                          title: Text(category.name),
                          leading: Radio(
                            value: category.name,
                            groupValue: _currentFilterCategoryName,
                            onChanged: (value) {
                              setState(() {
                                _currentFilterCategoryName = value.toString();
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
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
      body: PageView(
        onPageChanged: (int page) {
          setState(() {
            if (page == pages.singleTransactions.index) {
              // title = "Budgets";
              DatabaseHelper.instance.pushGetAllTransactionsStream();
            } else if (page == pages.recurringTransactions.index) {
              // title = "Savings";
              DatabaseHelper.instance.pushGetAllRecurringTransactionsStream();
            }
          });
        },
        children: [
          StreamBuilder<List<SingleTransaction>>(
            stream: DatabaseHelper.instance.allTransactionStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var filteredList =
                    snapshot.data!.where(_filterFunction).toList();
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
          StreamBuilder<List<RecurringTransaction>>(
            stream: DatabaseHelper.instance.allRecurringTransactionStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var filteredList =
                    snapshot.data!.where(_filterFunction).toList();
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: filteredList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TransactionItem(
                      recurringTransactionData: filteredList[index],
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TransactionForm()));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}



















// import 'package:budgetiser/db/database.dart';
// import 'package:budgetiser/drawer.dart';
// import 'package:budgetiser/screens/plans/budgetForm.dart';
// import 'package:budgetiser/screens/plans/savingForm.dart';
// import 'package:budgetiser/shared/dataClasses/budget.dart';
// import 'package:budgetiser/shared/dataClasses/savings.dart';
// import 'package:budgetiser/shared/widgets/budgetItem.dart';
// import 'package:budgetiser/shared/widgets/savingItem.dart';
// import 'package:flutter/material.dart';


// c

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       drawer: createDrawer(context),
//       body: PageView(
//         onPageChanged: (int page) {
//           setState(() {
//             if (page == pages.budgets.index) {
//               title = "Budgets";
//               buttonTooltip = "Create Budget";
//               _currentPage = pages.budgets.index;
//               DatabaseHelper.instance.pushGetAllBudgetsStream();
//             } else if (page == pages.savings.index) {
//               title = "Savings";
//               buttonTooltip = "Create Saving";
//               _currentPage = pages.savings.index;
//               DatabaseHelper.instance.pushGetAllSavingsStream();
//             }
//           });
//         },
//         children: [
//           StreamBuilder<List<Budget>>(
//             stream: DatabaseHelper.instance.allBudgetsStream,
//             builder: (context, snapshot) {
//               if(snapshot.hasData){
//                 List<Budget> _budgets = snapshot.data!.toList();
//                 _budgets.sort((a, b) => a.name.compareTo(b.name));
//                 return ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   itemCount: _budgets.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return BudgetItem(
//                       budgetData: _budgets[index],
//                     );
//                   },
//                 );
//               }else if (snapshot.hasError) {
//                 return const Text("Oops!");
//               }
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             },
//           ),
//           StreamBuilder<List<Savings>>(
//             stream: DatabaseHelper.instance.allSavingsStream,
//             builder: (context, snapshot) {
//               if(snapshot.hasData){
//                 List<Savings> _savings = snapshot.data!.toList();
//                 _savings.sort((a, b) => a.name.compareTo(b.name));
//                 return ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   itemCount: _savings.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return SavingItem(
//                       savingData: _savings[index],
//                     );
//                   },
//                 );
//               }else if (snapshot.hasError) {
//                 return const Text("Oops!");
//               }
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: _currentPage == pages.budgets.index
//           ? FloatingActionButton(
//               tooltip: buttonTooltip,
//               onPressed: () {
//                 Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => BudgetForm()));
//               },
//               child: const Icon(Icons.add),
//             )
//           : FloatingActionButton(
//               tooltip: buttonTooltip,
//               onPressed: () {
//                 Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => SavingForm()));
//               },
//               child: const Icon(Icons.add),
//             ),
//     );
//   }
// }
