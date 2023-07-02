import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/account/account_form.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/shared/widgets/items/accountItem/account_item.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  static String routeID = 'account';
  const AccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String currentSort = "name";

  @override
  void initState() {
    DatabaseHelper.instance.pushGetAllAccountsStream();
    super.initState();
  }

  int sortFunction(a, b) {
    switch (currentSort) {
      case 'nameReverse':
        return b.name.compareTo(a.name);
      case 'name':
        return a.name.compareTo(b.name);
      case 'balance':
        return b.balance.compareTo(a.balance);
      case 'balanceReverse':
        return a.balance.compareTo(b.balance);
      default:
        // by name
        return a.name.compareTo(b.name);
    }
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
                    elevation: 0,
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            if (currentSort == 'name') {
                              currentSort = 'nameReverse';
                            } else {
                              currentSort = 'name';
                            }
                          });
                        },
                        child: Row(
                          children: [
                            const Text('Name'),
                            (currentSort == "name")
                                ? const Icon(Icons.keyboard_arrow_up)
                                : const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            if (currentSort == "balance") {
                              currentSort = "balanceReverse";
                            } else {
                              currentSort = "balance";
                            }
                          });
                        },
                        child: Row(
                          children: [
                            const Text('Balance'),
                            (currentSort == "balance")
                                ? const Icon(Icons.keyboard_arrow_up)
                                : const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
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
            snapshot.data!.sort(sortFunction);
            return ListView.builder(
              itemCount: snapshot.data!.length,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 80),
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
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AccountForm()));
        },
        tooltip: 'Increment',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
