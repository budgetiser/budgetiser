import 'package:budgetiser/screens/stats/simple_text_stat.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/picker/selectAccount.dart';
import 'package:budgetiser/shared/picker/selectCategory.dart';
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
  TransactionCategory? _selectedCategory;
  Account? _selectedAccount;

  setCategory(TransactionCategory category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  setAccount(Account account) {
    setState(() {
      _selectedAccount = account;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Stats",
          // style: Theme.of(context).textTheme.caption,
        ),
      ),
      drawer: createDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SelectAccount(
              initialAccount: _selectedAccount,
              callback: setAccount,
            ),
            SelectCategory(
              initialCategory: _selectedCategory,
              callback: setCategory,
            ),
            Divider(),
            if (_selectedAccount != null && _selectedCategory != null)
              SimpleTextStat(
                account: _selectedAccount,
                category: _selectedCategory,
              ),
          ],
        ),
      ),
    );
  }
}
