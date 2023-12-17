import 'package:budgetiser/db/account_provider.dart';
import 'package:budgetiser/db/category_provider.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:flutter/material.dart';

class MixedPicker extends StatefulWidget {
  const MixedPicker({
    Key? key,
    required this.onPickedCallback,
    this.initialCategories,
    this.initialAccounts,
  }) : super(key: key);

  @override
  State<MixedPicker> createState() => _MixedPickerState();
  final Function(List<TransactionCategory>, List<Account>) onPickedCallback;
  final List<TransactionCategory>? initialCategories;
  final List<Account>? initialAccounts;
}

class _MixedPickerState extends State<MixedPicker> {
  List<TransactionCategory> _selectedCategories = [];
  List<Account> _selectedAccounts = [];

  var scrollController = ScrollController();

  @override
  void initState() {
    if (widget.initialCategories != null) {
      _selectedCategories = widget.initialCategories!;
    }
    if (widget.initialAccounts != null) {
      _selectedAccounts = widget.initialAccounts!;
    }
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget categoryPicker() {
    return FutureBuilder<List<TransactionCategory>>(
      future: CategoryModel().getAllCategories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Text('Oops!');
        }

        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, j) {
            return StatefulBuilder(
              builder: (context, localSetState) => CheckboxListTile(
                title: Row(
                  children: [
                    Icon(
                      snapshot.data![j].icon,
                      color: snapshot.data![j].color,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        snapshot.data![j].name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: snapshot.data![j].color,
                        ),
                      ),
                    ),
                  ],
                ),
                value: _selectedCategories.contains(snapshot.data![j]),
                onChanged: (bool? value) {
                  localSetState(() {
                    if (value == true) {
                      _selectedCategories.add(
                        snapshot.data![j],
                      );
                    } else {
                      _selectedCategories.remove(
                        snapshot.data![j],
                      );
                    }
                  });
                },
              ),
            );
          },
          itemCount: snapshot.data!.length,
        );
      },
    );
  }

  Widget accountPicker() {
    return FutureBuilder<List<Account>>(
      future: AccountModel().getAllAccounts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Text('Oops!');
        }

        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, j) {
            return StatefulBuilder(
              builder: (context, localSetState) => CheckboxListTile(
                title: Row(
                  children: [
                    Icon(
                      snapshot.data![j].icon,
                      color: snapshot.data![j].color,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        snapshot.data![j].name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: snapshot.data![j].color,
                        ),
                      ),
                    ),
                  ],
                ),
                value: _selectedAccounts.contains(snapshot.data![j]),
                onChanged: (bool? value) {
                  localSetState(() {
                    if (value == true) {
                      _selectedAccounts.add(
                        snapshot.data![j],
                      );
                    } else {
                      _selectedAccounts.remove(
                        snapshot.data![j],
                      );
                    }
                  });
                },
              ),
            );
          },
          itemCount: snapshot.data!.length,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select options'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            ExpansionTile(
              title: const Text('Select Account'),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: accountPicker(),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Select Category'),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: categoryPicker(),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Close'),
          onPressed: () {
            setState(() {
              widget.onPickedCallback(_selectedCategories, _selectedAccounts);
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
