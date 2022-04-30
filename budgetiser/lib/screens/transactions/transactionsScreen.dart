import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/transactions/transactionForm.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/widgets/transactionItem.dart';
import 'package:budgetiser/drawer.dart';
import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  static String routeID = 'transactions';
  TransactionsScreen({
    Key? key,
    this.initalAccountFilterName,
  }) : super(key: key);

  String? initalAccountFilterName;

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    DatabaseHelper.instance.pushGetAllTransactionsStream();
    DatabaseHelper.instance.allAccountsStream.listen((event) {
      _accountList = event;
    });
    DatabaseHelper.instance.pushGetAllAccountsStream();

    if (widget.initalAccountFilterName != null) {
      _currentFilterAccountName = widget.initalAccountFilterName!;
    }
    super.initState();
  }

  var _currentFilterAccountName = "";

  var _accountList = <Account>[];

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
                    title: const Text('Filter by Account'),
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _currentFilterAccountName = '';
                          });
                        },
                        child: const Text('All'),
                      ),
                      for (var account in _accountList)
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _currentFilterAccountName = account.name;
                            });
                          },
                          child: Text(account.name),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        title: const Text(
          "Transactions",
        ),
      ),
      drawer: createDrawer(context),
      body: StreamBuilder<List<SingleTransaction>>(
        stream: DatabaseHelper.instance.allTransactionStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var filteredList = snapshot.data!.where((element) {
              if (_currentFilterAccountName == "") {
                return true;
              } else {
                return element.account.name == _currentFilterAccountName ||
                    (element.account2 != null &&
                        element.account2!.name == _currentFilterAccountName);
              }
            }).toList();
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: filteredList.length,
              itemBuilder: (BuildContext context, int index) {
                return TransactionItem(
                  transactionData: filteredList[index],
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Text("Oops!");
          }
          return const Center(child: CircularProgressIndicator());
        },
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
