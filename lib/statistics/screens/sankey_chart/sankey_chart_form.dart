import 'package:badges/badges.dart' as badges;
import 'package:budgetiser/accounts/widgets/account_multi_picker.dart';
import 'package:budgetiser/categories/picker/category_picker.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/statistics/screens/sankey_chart/sankey_char_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SankeyChartForm extends StatefulWidget {
  const SankeyChartForm({super.key});

  @override
  State<SankeyChartForm> createState() => _SankeyChartFormState();
}

class _SankeyChartFormState extends State<SankeyChartForm> {
  List<Account> _selectedAccounts = [];
  List<TransactionCategory> _selectedCategories = [];
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

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
    List<TransactionCategory> allCategories =
        await Provider.of<CategoryModel>(context, listen: false)
            .getAllCategories();
    setState(() {
      _selectedCategories = allCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sankey chart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Sankey chart'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'The generated text can be used to create a Sankey chart in a tool like:',
                        ),
                        const SizedBox(height: 16),
                        // clickable link
                        GestureDetector(
                          onTap: () async {
                            final Uri urlParsed =
                                Uri.parse('https://sankeymatic.com/build');
                            if (!await launchUrl(urlParsed,
                                mode: LaunchMode.externalApplication)) {
                              throw Exception('Could not launch $urlParsed');
                            }
                          },
                          child: const Text(
                            'sankeymatic.com/build',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select accounts '),
                badges.Badge(
                  badgeContent: Text(
                    _selectedAccounts.length.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  showBadge: _selectedAccounts.isNotEmpty,
                  child: const Icon(Icons.account_balance),
                ),
              ],
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AccountMultiPicker(
                    onAccountsPickedCallback: onAccountsPickedCallback,
                    initialValues: _selectedAccounts,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select categories '),
                badges.Badge(
                  badgeContent: Text(
                    _selectedCategories.length.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  showBadge: _selectedCategories.isNotEmpty,
                  child: const Icon(Icons.account_balance),
                ),
              ],
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CategoryPicker.multi(
                    onCategoryPickedCallbackMulti:
                        onCategoryPickedCallbackMulti,
                    initialValues: _selectedCategories,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select date range '),
                const Icon(Icons.date_range),
                Text(' - ${_selectedDateRange.duration.inDays} days')
              ],
            ),
            onPressed: () {
              showDateRangePicker(
                context: context,
                firstDate: DateTime(2021),
                lastDate: DateTime.now(),
                initialDateRange: _selectedDateRange,
              ).then((value) {
                if (value != null) {
                  setState(() {
                    _selectedDateRange = value;
                  });
                }
              });
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'save_to_file',
            onPressed: null,
            backgroundColor: Theme.of(context).disabledColor,
            label: const Text('Save to file'),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'copy_to_clipboard',
            onPressed: () async {
              Clipboard.setData(ClipboardData(
                text: await generateSankeyChart(
                  context,
                  _selectedAccounts,
                  _selectedCategories,
                  _selectedDateRange,
                ),
              )).then((_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Text copied to clipboard'),
                    ),
                  );
                }
              });
            },
            label: const Text('Copy to clipboard'),
          ),
        ],
      ),
    );
  }

  void onAccountsPickedCallback(List<Account> selected) {
    if (mounted) {
      setState(() {
        _selectedAccounts = selected;
      });
    }
  }

  void onCategoryPickedCallbackMulti(List<TransactionCategory> selected) {
    if (mounted) {
      setState(() {
        _selectedCategories = selected;
      });
    }
  }
}
