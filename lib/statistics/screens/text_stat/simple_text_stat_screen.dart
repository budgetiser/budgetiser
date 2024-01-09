import 'package:budgetiser/accounts/widgets/account_single_picker.dart';
import 'package:budgetiser/categories/widgets/category_single_picker.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon.dart';
import 'package:budgetiser/statistics/screens/text_stat/simple_text_stat.dart';
import 'package:flutter/material.dart';

class SimpleTextStatScreen extends StatefulWidget {
  const SimpleTextStatScreen({super.key});

  @override
  State<SimpleTextStatScreen> createState() => _SimpleTextStatScreenState();
}

class _SimpleTextStatScreenState extends State<SimpleTextStatScreen> {
  TransactionCategory? _selectedCategory;
  Account? _selectedAccount;

  void setAccount(Account a) {
    if (mounted) {
      setState(() {
        _selectedAccount = a;
      });
    }
  }

  void setCategory(TransactionCategory c) {
    setState(() {
      _selectedCategory = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Account: '),
              Expanded(
                child: InkWell(
                  child: _selectedAccount != null
                      ? SelectableIcon(_selectedAccount!)
                      : const Text('Select Account'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AccountSinglePicker(
                              onAccountPickedCallback: setAccount);
                        });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            child: _selectedCategory != null
                ? SelectableIcon(_selectedCategory!)
                : const Text('No data'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CategorySinglePicker(
                      onCategoryPickedCallback: setCategory,
                    );
                  });
            },
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
