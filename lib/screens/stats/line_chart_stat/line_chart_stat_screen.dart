import 'package:budgetiser/screens/stats/line_chart_stat/line_chart.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/picker/month_picker.dart';
import 'package:budgetiser/shared/picker/multi_picker/account_picker.dart';
import 'package:flutter/material.dart';

class LineChartStatScreen extends StatefulWidget {
  const LineChartStatScreen({super.key});

  @override
  State<LineChartStatScreen> createState() => _LineChartStatScreenState();
}

class _LineChartStatScreenState extends State<LineChartStatScreen> {
  List<Account>? _selectedAccounts;
  DateTime startDate = DateTime.now();

  void setAccount(List<Account> accounts) {
    if (mounted) {
      setState(() {
        _selectedAccounts = accounts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  onAccountPickedCallback: setAccount,
                ),
              ),
            ],
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
    );
  }
}
