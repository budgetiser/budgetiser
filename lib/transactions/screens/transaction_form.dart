import 'package:budgetiser/accounts/widgets/account_single_picker.dart';
import 'package:budgetiser/accounts/widgets/account_single_picker_nullable.dart';
import 'package:budgetiser/categories/widgets/category_single_picker.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/shared/services/recently_used.dart';
import 'package:budgetiser/shared/utils/data_types_utils.dart';
import 'package:budgetiser/shared/widgets/actionButtons/cancel_action_button.dart';

import 'package:budgetiser/shared/widgets/forms/custom_input_field.dart';
import 'package:budgetiser/shared/widgets/forms/screen_forms.dart';
import 'package:budgetiser/shared/widgets/picker/date_picker.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon_with_text.dart';
import 'package:budgetiser/transactions/screens/transactions_screen.dart';
import 'package:budgetiser/transactions/widgets/visualize_transaction.dart';

import 'package:equations/equations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionForm extends StatefulWidget {
  /// A screen that allows the user to add a transaction
  /// or edit an existing one
  ///
  /// attributes:
  /// * optional [SingleTransaction] - edit this transaction
  /// * optional [initialBalance] - set initial balance
  /// * optional [SingleTransaction] - set initial selected account
  const TransactionForm({
    super.key,
    this.initialSingleTransactionData,
    this.initialBalance,
    this.initialSelectedAccount,
  });
  final SingleTransaction? initialSingleTransactionData;
  final String? initialBalance;
  final Account? initialSelectedAccount;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

enum EnumPrefix { plus, minus, other }

class _TransactionFormState extends State<TransactionForm> {
  Account? selectedAccount;
  Account? selectedAccount2;
  TransactionCategory? selectedCategory;
  DateTime transactionDate = DateTime.now();
  bool hasInitialData = false;

  var titleController = TextEditingController();
  var valueController = TextEditingController(text: '-');
  var descriptionController = TextEditingController();

  /// remembering if value was negative to display the correct prefix button when value field is not valid
  bool wasValueNegative = true;

  final _formKey = GlobalKey<FormState>();
  final _valueKey = GlobalKey<FormState>();

  ScrollController listScrollController = ScrollController();
  ExpressionParser valueParser = const ExpressionParser();

  bool _prefixButtonVisible = true;

  @override
  void initState() {
    if (widget.initialBalance != null) {
      valueController.text = widget.initialBalance!;
    }
    if (widget.initialSingleTransactionData != null) {
      hasInitialData = true;
      titleController.text = widget.initialSingleTransactionData!.title;
      valueController.text =
          widget.initialSingleTransactionData!.value.toStringAsFixed(2);
      selectedAccount = widget.initialSingleTransactionData!.account;
      selectedCategory = widget.initialSingleTransactionData!.category;
      selectedAccount2 = widget.initialSingleTransactionData!.account2;
      descriptionController.text =
          widget.initialSingleTransactionData!.description ?? '';

      transactionDate = widget.initialSingleTransactionData!.date;
    }
    if (widget.initialSelectedAccount != null) {
      selectedAccount = widget.initialSelectedAccount;
    }
    updateWasValueNegative(valueController.text);

    setInitialSelections();

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    valueController.dispose();
    descriptionController.dispose();
    listScrollController.dispose();
    super.dispose();
  }

  void setInitialSelections() async {
    if (selectedAccount == null) {
      final recentlyUsedAccount = RecentlyUsed<Account>();
      selectedAccount = await recentlyUsedAccount.getLastUsed();
    }
    if (selectedCategory == null) {
      final recentlyUsedCategory = RecentlyUsed<TransactionCategory>();
      selectedCategory = await recentlyUsedCategory.getLastUsed();
    }
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      _prefixButtonVisible = preferences.getBool('key-prefix-button-active') ??
          _prefixButtonVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: hasInitialData
            ? const Text('Edit Transaction')
            : const Text('New Transaction'),
      ),
      body: ScrollViewWithDeadSpace(
        deadSpaceContent: VisualizeTransaction(
          account1: selectedAccount,
          account2: selectedAccount2,
          category: selectedCategory,
          wasNegative: wasValueNegative,
          value: tryValueParse(valueController.text),
        ),
        children:[ _transactionFormContent(context)],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CancelActionButton(
            isDeletion: hasInitialData,
            onSubmitCallback: () {
              Provider.of<TransactionModel>(context, listen: false)
                  .deleteSingleTransactionById(
                widget.initialSingleTransactionData!.id,
              );
            },
          ),
          const SizedBox(width: 5),
          // Save button
          FloatingActionButton.extended(
            onPressed: () async {
              _valueKey.currentState!
                  .validate(); // will otherwise not be called if global form is also invalid
              if (_formKey.currentState!.validate() &&
                  _valueKey.currentState!.validate()) {
                if (hasInitialData) {
                  Provider.of<TransactionModel>(context, listen: false)
                      .updateSingleTransaction(
                    _currentTransaction(),
                  );
                  Navigator.of(context).pop();
                } else {
                  Provider.of<TransactionModel>(context, listen: false)
                      .createSingleTransaction(
                    _currentTransaction(),
                  );
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const TransactionsScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                }
              }
            },
            label: const Text('Save'),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  void setAccount(Account a) {
    if (mounted) {
      setState(() {
        selectedAccount = a;
        if (selectedAccount == selectedAccount2) {
          selectedAccount2 = null;
        }
      });
    }
  }

  void setAccount2(Account? a) {
    if (mounted) {
      setState(() {
        selectedAccount2 = a;
      });
    }
  }

  void setCategory(TransactionCategory c) {
    if (mounted) {
      setState(() {
        selectedCategory = c;
      });
    }
  }

  Form _transactionFormContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // prefix-button, value & date input
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_prefixButtonVisible)
                IconButton(
                  icon: Icon(wasValueNegative ? Icons.remove : Icons.add),
                  onPressed: () {
                    togglePrefix();
                  },
                  color: wasValueNegative
                      ? const Color.fromARGB(255, 174, 74, 99)
                      : const Color.fromARGB(239, 29, 129, 37),
                  splashRadius: 24,
                  iconSize: 40,
                ),
              Flexible(
                child: Form(
                  key: _valueKey,
                  child: TextFormField(
                    controller: valueController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Value',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (tryValueParse(valueController.text) != null) {
                        _valueKey.currentState!.validate();
                      }
                      updateWasValueNegative(value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      try {
                        if (selectedAccount2 != null &&
                            valueParser.evaluate(value) < 0) {
                          return 'Only positive values with two accounts';
                        }
                        if (valueParser.evaluate(value) == double.infinity ||
                            valueParser.evaluate(value) == -double.infinity) {
                          return 'Please enter a valid number';
                        }
                      } catch (e) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: DatePicker(
                  label: 'Date',
                  initialDate: transactionDate,
                  onDateChangedCallback: (date) {
                    setState(() {
                      transactionDate = date;
                    });
                  },
                ),
              ),
            ],
          ),
          // title input
          const SizedBox(height: 20),
          TextFormField(
            onChanged: (value) {
              setState(() {});
            },
            controller: titleController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: titleController.text == ''
                  ? 'Title: ${selectedCategory?.name}'
                  : 'Title',
              border: const OutlineInputBorder(),
            ),
          ),
          // category picker
          const SizedBox(height: 8),
          CustomInputFieldBorder(
            title: 'Category',
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return CategorySinglePicker(
                  onCategoryPickedCallback: setCategory,
                );
              },
            ),
            child: InkWell(
              child: selectedCategory != null
                  ? SelectableIconWithText(selectedCategory!)
                  : const Text('Select Category'),
            ),
          ),
          // account picker
          const SizedBox(height: 8),
          CustomInputFieldBorder(
            title: 'Account',
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AccountSinglePicker(
                  onAccountPickedCallback: setAccount,
                );
              },
            ),
            child: InkWell(
              child: selectedAccount != null
                  ? SelectableIconWithText(selectedAccount!)
                  : const Text('Select Account'),
            ),
          ),
          const SizedBox(height: 8),
          CustomInputFieldBorder(
            title: 'Account 2',
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AccountSinglePickerNullable(
                  onAccountPickedCallback: setAccount2,
                  blacklistedValues:
                      selectedAccount != null ? [selectedAccount!] : null,
                );
              },
            ),
            child: selectedAccount2 != null
                ? SelectableIconWithText(selectedAccount2!)
                : const Text(
                    'None',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
          ),
          // notes input
          const SizedBox(height: 18),
          TextFormField(
            controller: descriptionController,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Notes',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }

  double? tryValueParse(String value) {
    try {
      return valueParser.evaluate(value);
    } catch (e) {
      return null;
    }
  }

  SingleTransaction _currentTransaction() {
    String description = '';
    if (double.tryParse(valueController.text) == null) {
      description =
          '${descriptionController.text.trim()}\nCalculated from: ${valueController.text.trim()}'
              .trim();
    } else {
      description = descriptionController.text.trim();
    }

    String title = titleController.text.trim();
    if (title == '') {
      title = selectedCategory!.name;
    }

    SingleTransaction transaction = SingleTransaction(
      id: 0,
      title: title,
      value: roundDouble(valueParser.evaluate(valueController.text)),
      category: selectedCategory!,
      account: selectedAccount!,
      account2: selectedAccount2,
      description: parseNullableString(description),
      date: transactionDate,
    );

    if (hasInitialData) {
      transaction.id = widget.initialSingleTransactionData!.id;
    }

    return transaction;
  }

  void updateWasValueNegative(String newValue) {
    setState(() {
      if (valueController.text.trim() == '') {
        wasValueNegative = false;
      }
      if (valueController.text.trim() == '-') {
        wasValueNegative = true;
      }
      if (tryValueParse(valueController.text) != null) {
        wasValueNegative = tryValueParse(valueController.text)! < 0;
      }
    });
  }

  /// Toggles prefix of valueController from negative to positive or vice versa
  ///
  /// If value cant be parsed, prefix wont be changed
  void togglePrefix() {
    double? currentValue = tryValueParse(valueController.text);

    setState(() {
      if (currentValue == null) {
        if (valueController.text == '-') {
          valueController.text = '';
        } else if (valueController.text == '') {
          valueController.text = '-';
        }
        return;
      }
      if (!_valueKey.currentState!.validate()) {
        return;
      }

      if (currentValue < 0) {
        valueController.text =
            roundDouble(currentValue.abs()).toStringAsFixed(2);
      } else {
        valueController.text = roundDouble(-currentValue).toStringAsFixed(2);
      }
    });
    updateWasValueNegative(valueController.text);
    // move cursor to the end
    valueController.selection =
        TextSelection.collapsed(offset: valueController.text.length);
  }
}
