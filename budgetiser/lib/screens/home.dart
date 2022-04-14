import 'package:budgetiser/bd/database.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/tempData/tempData.dart';
import 'package:flutter/material.dart';

import '../shared/widgets/drawer.dart';

class Home extends StatefulWidget {
  static String routeID = 'home';
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int counter = 0;

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              "${counter}",
              style: Theme.of(context).textTheme.headline4,
            ),
            //_getAccounts(),
            FloatingActionButton(
              onPressed: ((() => {
                    DatabaseHelper.instance.createTransaction(
                        TMP_DATA_transactionList[0] as SingleTransaction),
                  })),
              child: Icon(
                Icons.add,
              ),
              heroTag: "btn3",
            ),
            FloatingActionButton(
              onPressed: ((() => {
                    DatabaseHelper.instance
                        .createCategory(TMP_DATA_categoryList[0]),
                  })),
              child: Text("new category"),
              heroTag: "btn2",
            ),
            FloatingActionButton(
              onPressed: ((() => {
                    DatabaseHelper.instance
                        .getAllSingleTransactions()
                        .then((value) => print(value)),
                  })),
              child: Text("print"),
              heroTag: "btn1",
            ),
          ],
        ),
      ),
      drawer: createDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => {
              setState(() {
                DatabaseHelper.instance.createAccount(TMP_DATA_accountList[2]);
                _incrementCounter();
              })
            }),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /*Widget _getAccounts() {
    return Expanded(
      child: FutureBuilder<List<Account>>(
        future: DatabaseHelper.instance.getAllAccounts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].balance.toString()),
                  trailing: IconButton(
                      alignment: Alignment.center,
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        DatabaseHelper.instance
                            .deleteAccount(snapshot.data![index].id);
                        setState(() {});
                      }),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("Oops!");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }*/
}
