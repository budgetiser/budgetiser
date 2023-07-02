import 'package:budgetiser/screens/stats/lineChart.dart';
import 'package:budgetiser/screens/stats/simple_text_stat.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/picker/select_account.dart';
import 'package:budgetiser/shared/picker/select_category.dart';
import 'package:flutter/material.dart';
import 'package:budgetiser/drawer.dart';

class Stats extends StatefulWidget {
  static String routeID = 'stats';
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

enum PagesEnum { simpleText }

class _StatsState extends State<Stats> {
  Account? _selectedAccount;

  setAccount(Account account) {
    setState(() {
      _selectedAccount = account;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stats"),
      ),
      drawer: createDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
        children: [
          Row(
            children: [
              const Text("Account: "),
              Expanded(
                child: SelectAccount(
                  initialAccount: _selectedAccount,
                  callback: setAccount,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedAccount != null)
          LineChartTest(
            account: _selectedAccount
          ),
        ],
      )
    ));
  }
}
