import 'package:badges/badges.dart' as badges;
import 'package:budgetiser/accounts/widgets/account_multi_picker.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/shared/widgets/picker/segmented_duration_picker.dart';
import 'package:budgetiser/statistics/screens/account_stat/simple_account_stat.dart';
import 'package:flutter/material.dart';

class SimpleAccountStatScreen extends StatefulWidget {
  const SimpleAccountStatScreen({super.key});

  @override
  State<SimpleAccountStatScreen> createState() =>
      _SimpleAccountStatScreenState();
}

class _SimpleAccountStatScreenState extends State<SimpleAccountStatScreen> {
  List<Account> _selectedAccounts = [];
  DateTime _selectedStartDate = DateTime(2000);

  void setAccount(List<Account> a) {
    if (mounted) {
      setState(() {
        _selectedAccounts = a;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account stats'),
        actions: [
          IconButton(
            icon: badges.Badge(
              badgeContent: Text(
                _selectedAccounts.length.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              showBadge: _selectedAccounts.isNotEmpty,
              child: const Icon(Icons.filter_alt_sharp),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SegmentedDurationPicker(
              callback: (newDate) {
                setState(() {
                  _selectedStartDate = newDate;
                });
              },
            ),
            Text(
              'Showing data since ${_selectedStartDate.year}-${_selectedStartDate.month}-${_selectedStartDate.day}',
            ),
            SimpleAccountStatTables(
              accounts: _selectedAccounts,
              startDate: _selectedStartDate,
            ),
          ],
        ),
      ),
    );
  }
}
