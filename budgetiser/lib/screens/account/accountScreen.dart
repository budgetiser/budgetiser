import 'package:budgetiser/bd/database.dart';
import 'package:budgetiser/screens/account/accountForm.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/services/accountItem/accountItem.dart';
import 'package:budgetiser/shared/tempData/tempData.dart';
import 'package:budgetiser/shared/widgets/drawer.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  static String routeID = 'account';
  AccountScreen({
    Key? key,
  }) : super(key: key);

  List<Account> accountList = TMP_DATA_accountList;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String currentSort = '';

  @override
  void initState() {
    DatabaseHelper.instance.pushGetAllAccountsStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text('Sort by'),
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            if (currentSort == 'name') {
                              currentSort = '';
                              widget.accountList
                                  .sort((b, a) => a.name.compareTo(b.name));
                            } else {
                              currentSort = 'name';
                              widget.accountList
                                  .sort((a, b) => a.name.compareTo(b.name));
                            }
                          });
                        },
                        child: const Text('Name'),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            if (currentSort == "balance") {
                              widget.accountList.sort(
                                  (a, b) => a.balance.compareTo(b.balance));
                              currentSort = "";
                            } else {
                              widget.accountList.sort(
                                  (a, b) => b.balance.compareTo(a.balance));
                              currentSort = "balance";
                            }
                          });
                        },
                        child: const Text('Balance'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        title: const Text(
          "Accounts",
        ),
      ),
      drawer: createDrawer(context),
      body: StreamBuilder<List<Account>>(
        stream: DatabaseHelper.instance.allAccountsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return AccountItem(
                  accountData: snapshot.data![index],
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Text("Oops!");
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AccountForm()));
        },
        tooltip: 'Increment',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
