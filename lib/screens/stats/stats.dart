import 'package:budgetiser/screens/stats/line_chart.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/picker/account_picker.dart';
import 'package:budgetiser/shared/picker/monthPicker.dart';
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
  List<Account>? _selectedAccounts;
  DateTime startDate = DateTime.now();

  setAccount(List<Account> accounts) {
    setState(() {
      _selectedAccounts = accounts;
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
            MonthPicker(
              onDateChangedCallback: (DateTime time) => {
                setState(() {
                  startDate = time;
                })
              },
            ),
            Row(
              children: [
                Expanded(
                  child: AccountPicker(
                    onAccountPickedCallback: (List<Account> accounts) {
                      setState(() {
                        _selectedAccounts = accounts;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_selectedAccounts != null)
              LineChartTest(
                accounts: _selectedAccounts!,
                startDate: DateTime(startDate.year, startDate.month, 1),
                endDate: DateTime(startDate.year, startDate.month + 1, 0),
              ),
          ],
        ),
      ),
    );
  }
}
