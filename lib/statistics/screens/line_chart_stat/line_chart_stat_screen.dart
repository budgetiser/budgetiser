import 'package:budgetiser/accounts/widgets/account_multi_picker.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/shared/widgets/picker/month_picker.dart';
import 'package:budgetiser/statistics/screens/line_chart_stat/line_chart.dart';
import 'package:flutter/material.dart';

class LineChartStatScreen extends StatefulWidget {
  const LineChartStatScreen({super.key});

  @override
  State<LineChartStatScreen> createState() => _LineChartStatScreenState();
}

class _LineChartStatScreenState extends State<LineChartStatScreen> {
  List<Account>? _selectedAccounts;
  DateTime startDate = DateTime.now();

  void setAccounts(List<Account> accounts) {
    if (mounted) {
      setState(() {
        _selectedAccounts = accounts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts Line Chart')),
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
            InkWell(
              child: const Text('Select Accounts'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AccountMultiPicker(
                      onAccountsPickedCallback: setAccounts,
                      initialValues: _selectedAccounts,
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            if (_selectedAccounts != null)
              LineChartAccounts(
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
