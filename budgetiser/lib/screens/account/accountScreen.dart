import 'package:budgetiser/bd/database.dart';
import 'package:budgetiser/screens/account/newAccount.dart';
import 'package:budgetiser/shared/tempData/tempData.dart';
import 'package:flutter/material.dart';
import '../../shared/dataClasses/account.dart';
import '../../shared/services/accountItem/accountItem.dart';
import '../../shared/widgets/drawer.dart';

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              FutureBuilder<List<Account>>(
                future: DatabaseHelper.instance.getAllAccounts(),
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
                    return Text("Oops!");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NewAccount()));
        },
        tooltip: 'Increment',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
