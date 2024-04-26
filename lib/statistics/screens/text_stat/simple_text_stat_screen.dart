import 'package:badges/badges.dart' as badges;
import 'package:budgetiser/accounts/widgets/account_multi_picker.dart';
import 'package:budgetiser/categories/widgets/category_multi_picker.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/shared/widgets/picker/segmented_duration_picker.dart';
import 'package:budgetiser/statistics/screens/text_stat/simple_text_stat.dart';
import 'package:flutter/material.dart';

class SimpleTextStatScreen extends StatefulWidget {
  const SimpleTextStatScreen({super.key});

  @override
  State<SimpleTextStatScreen> createState() => _SimpleTextStatScreenState();
}

class _SimpleTextStatScreenState extends State<SimpleTextStatScreen> {
  List<TransactionCategory> _selectedCategories = [];
  List<Account> _selectedAccounts = [];
  DateTime _selectedStartDate = DateTime(2000);

  void setAccount(List<Account> a) {
    if (mounted) {
      setState(() {
        _selectedAccounts = a;
      });
    }
  }

  void setCategory(List<TransactionCategory> c) {
    setState(() {
      _selectedCategories = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text stat'),
        actions: [
          IconButton(
            icon: badges.Badge(
              badgeContent: Text(
                _selectedCategories.length.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              showBadge: _selectedCategories.isNotEmpty,
              child: const Icon(Icons.filter_alt_sharp),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CategoryMultiPicker(
                    onCategoriesPickedCallback: setCategory,
                    initialValues: _selectedCategories,
                  );
                },
              );
            },
          ),
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
                'Showing data since ${_selectedStartDate.year}-${_selectedStartDate.month}-${_selectedStartDate.day}'),
            SimpleTextStat(
              accounts: _selectedAccounts,
              categories: _selectedCategories,
              startDate: _selectedStartDate,
            ),
          ],
        ),
      ),
    );
  }
}
