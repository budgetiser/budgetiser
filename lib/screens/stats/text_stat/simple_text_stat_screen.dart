import 'package:budgetiser/screens/stats/text_stat/simple_text_stat.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/picker/select_account.dart';
import 'package:budgetiser/shared/picker/select_category.dart';
import 'package:flutter/material.dart';

class SimpleTextStatScreen extends StatefulWidget {
  const SimpleTextStatScreen({super.key});

  @override
  State<SimpleTextStatScreen> createState() => _SimpleTextStatScreenState();
}

class _SimpleTextStatScreenState extends State<SimpleTextStatScreen> {
  TransactionCategory? _selectedCategory;
  Account? _selectedAccount;
  void setA(account) {
    if (mounted) {
      setState(() {
        _selectedAccount = account;
      });
    }
  }

  void setCategory(TransactionCategory category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Account: '),
              Expanded(
                child: SelectAccount(
                  initialAccount: _selectedAccount,
                  callback: setA,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SelectCategory(
            initialCategory: _selectedCategory,
            callback: setCategory,
          ),
          const Divider(),
          if (_selectedAccount != null && _selectedCategory != null)
            SimpleTextStat(
              account: _selectedAccount,
              category: _selectedCategory,
            ),
        ],
      ),
    );
  }
}
