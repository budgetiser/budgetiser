import 'package:badges/badges.dart' as badges;
import 'package:budgetiser/accounts/screens/account_form.dart';
import 'package:budgetiser/accounts/widgets/account_multi_picker.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountBarChartScreen extends StatefulWidget {
  const AccountBarChartScreen({super.key});

  @override
  State<AccountBarChartScreen> createState() => _AccountBarChartScreenState();
}

class _AccountBarChartScreenState extends State<AccountBarChartScreen> {
  List<Account> _selectedAccounts = [];

  void setAccount(List<Account> a) {
    if (mounted) {
      setState(() {
        _selectedAccounts = a;
      });
    }
  }

  @override
  void initState() {
    initAsync();
    super.initState();
  }

  void initAsync() async {
    List<Account> allAccounts =
        await Provider.of<AccountModel>(context, listen: false)
            .getAllAccounts();
    setState(() {
      _selectedAccounts = allAccounts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: badges.Badge(
              badgeContent: Text(
                _selectedAccounts.length.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              showBadge: _selectedAccounts.isNotEmpty,
              child: const Icon(Icons.account_balance),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AccountMultiPicker(
                    onAccountsPickedCallback: setAccount,
                    initialValues: _selectedAccounts,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: screenContent(_selectedAccounts),
    );
  }

  Widget screenContent(List<Account> selectedAccounts) {
    selectedAccounts.sort((a, b) => (a.balance > b.balance) ? 1 : -1);
    double totalBalance = selectedAccounts.fold(
      0,
      (previousValue, element) => previousValue + element.balance,
    );
    List<Account> accountsPositiveBalance = selectedAccounts
        .where(
          (element) => element.balance >= 0,
        )
        .toList();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: accountsPositiveBalance
                      .map(
                        (e) => pieChartSection(e),
                      )
                      .toList(),
                  pieTouchData: PieTouchData(
                    enabled: true,
                    touchCallback: (p0, p1) {
                      debugPrint(
                          'Touched on: ${p0.localPosition}, index: ${p1?.touchedSection?.touchedSectionIndex}');
                      if (p1?.touchedSection?.touchedSectionIndex != null &&
                          p1!.touchedSection!.touchedSectionIndex >= 0) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AccountForm(
                              initialAccount: accountsPositiveBalance[
                                  p1.touchedSection!.touchedSectionIndex],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              height: 400,
              child: BarChart(
                BarChartData(
                  titlesData: const FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text('123'),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 1,
                      barRods: selectedAccounts
                          .map(
                            (e) => barChartRod(e),
                          )
                          .toList(),
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: totalBalance,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  PieChartSectionData pieChartSection(Account account) {
    return PieChartSectionData(
      value: account.balance,
      color: account.color,
    );
  }

  BarChartRodData barChartRod(Account account) {
    return BarChartRodData(
      toY: account.balance,
      color: account.color,
    );
  }
}
