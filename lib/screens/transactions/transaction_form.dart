import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/account/account_form.dart';
import 'package:budgetiser/screens/transactions/transactions_screen.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/recurring_data.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/picker/date_picker.dart';
import 'package:budgetiser/shared/picker/select_account.dart';
import 'package:budgetiser/shared/picker/select_category.dart';
import 'package:budgetiser/shared/widgets/confirmation_dialog.dart';
import 'package:budgetiser/shared/widgets/smallStuff/balance_text.dart';
import 'package:budgetiser/shared/widgets/wrapper/screen_forms.dart';
import 'package:equations/equations.dart';
import 'package:flutter/material.dart';

/// A screen that allows the user to add a transaction
/// or edit an existing one
///
/// attributes:
/// * optional [SingleTransaction] - edit this transaction
/// * optional [initialBalance] - set initial balance
/// * optional [SingleTransaction] - set initial selected account

class TransactionForm extends StatefulWidget {
  const TransactionForm({
    Key? key,
    this.initialSingleTransactionData,
    this.initialBalance,
    this.initialSelectedAccount,
  }) : super(key: key);
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
  bool hasAccount2 = false;
  bool hasInitialData = false;

  var titleController = TextEditingController();
  var valueController = TextEditingController(text: '-');
  var descriptionController = TextEditingController();
  bool wasValueNegative =
      true; // remembering if value was negative to display the correct prefix button when value field is not valid

  final _formKey = GlobalKey<FormState>();

  ScrollController listScrollController = ScrollController();
  ExpressionParser valueParser = const ExpressionParser();

  RecurringData recurringData = RecurringData(
    startDate: DateTime.now(),
    isRecurring: false,
  );

  @override
  void initState() {
    if (widget.initialBalance != null) {
      valueController.text = widget.initialBalance!;
    }
    if (widget.initialSingleTransactionData != null) {
      hasInitialData = true;
      titleController.text = widget.initialSingleTransactionData!.title;
      valueController.text =
          widget.initialSingleTransactionData!.value.toString();
      selectedAccount = widget.initialSingleTransactionData!.account;
      selectedCategory = widget.initialSingleTransactionData!.category;
      hasAccount2 = widget.initialSingleTransactionData!.account2 != null;
      selectedAccount2 = widget.initialSingleTransactionData!.account2;
      descriptionController.text =
          widget.initialSingleTransactionData!.description;

      transactionDate = widget.initialSingleTransactionData!.date;
    }
    if (widget.initialSelectedAccount != null) {
      selectedAccount = widget.initialSelectedAccount;
    }

    super.initState();
  }

  void setAccount(Account a) {
    if (mounted) {
      setState(() {
        selectedAccount = a;
      });
    }
  }

  void setAccount2(Account a) {
    if (mounted) {
      setState(() {
        selectedAccount2 = a;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: hasInitialData
            ? const Text('Edit Transaction')
            : const Text('New Transaction'),
      ),
      body: ScrollViewWithDeadSpace(
        deadSpaceContent: selectedAccount2 != null
            ? _visualizeTwoAccountTransaction()
            : _visualizeOneAccountTransaction(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // prefix-button, value & date input
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 70,
                    child: IconButton(
                      icon: Icon(wasValueNegative ? Icons.remove : Icons.add),
                      onPressed: () {
                        changePrefix(EnumPrefix.other);
                      },
                      color: wasValueNegative
                          ? const Color.fromARGB(255, 174, 74, 99)
                          : const Color.fromARGB(239, 29, 129, 37),
                      splashRadius: 24,
                      iconSize: 48,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: valueController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Value',
                      ),
                      onChanged: (value) {
                        // _formKey.currentState!.validate();
                        updateWasValueNegative(value);
                        // to update the visualization
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        try {
                          if (valueParser.evaluate(value) < 0 && hasAccount2) {
                            return 'Only positive values with two accounts';
                          }
                        } catch (e) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                controller: titleController,
                // initialValue: widget.initialName,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              // account picker
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Account',
                        textAlign: TextAlign.left,
                        style: themeData.inputDecorationTheme.labelStyle != null
                            ? themeData.inputDecorationTheme.labelStyle!
                                .copyWith(fontSize: 16)
                            : const TextStyle(fontSize: 16),
                      ),
                    ),
                    SelectAccount(
                        initialAccount: selectedAccount, callback: setAccount),
                    InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onTap: () {
                        _onAccount2checkboxClicked();
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: hasAccount2,
                            onChanged: (bool? newValue) {
                              _onAccount2checkboxClicked();
                            },
                          ),
                          const Flexible(
                            child: Text(
                              'transfer to another account',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (hasAccount2)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('to '),
                          Flexible(
                            child: SelectAccount(
                              initialAccount: selectedAccount2,
                              callback: setAccount2,
                              blackListAccountId: selectedAccount?.id,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              // category picker
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Category',
                        textAlign: TextAlign.left,
                        style: themeData.inputDecorationTheme.labelStyle != null
                            ? themeData.inputDecorationTheme.labelStyle!
                                .copyWith(fontSize: 16)
                            : const TextStyle(fontSize: 16),
                      ),
                    ),
                    SelectCategory(
                      initialCategory: selectedCategory,
                      callback: (TransactionCategory c) {
                        setState(() {
                          if (mounted) {
                            selectedCategory = c;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              // notes input
              const SizedBox(height: 16),
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: TextFormField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    alignLabelWithHint: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Cancel/ Delete button
          FloatingActionButton(
            heroTag: 'cancel',
            backgroundColor: Colors.red,
            mini: true,
            onPressed: () {
              if (hasInitialData) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Attention',
                      description:
                          "Are you sure to delete this Transaction? This action can't be undone!",
                      onSubmitCallback: () {
                        DatabaseHelper.instance.deleteSingleTransactionById(
                            widget.initialSingleTransactionData!.id);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      onCancelCallback: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              } else {
                Navigator.of(context).pop();
              }
            },
            child: hasInitialData
                ? const Icon(Icons.delete_outline)
                : const Icon(Icons.close),
          ),
          // between cancel and save button
          const SizedBox(
            width: 5,
          ),
          // Save button
          FloatingActionButton.extended(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (hasInitialData) {
                  DatabaseHelper.instance
                      .updateSingleTransaction(_currentTransaction());
                  Navigator.of(context).pop();
                } else {
                  DatabaseHelper.instance
                      .createSingleTransaction(_currentTransaction());
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const TransactionsScreen(),
                      ),
                      (Route<dynamic> route) => false);
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

  double? tryValueParse(String value) {
    try {
      return valueParser.evaluate(value);
    } catch (e) {
      return null;
    }
  }

  Widget _visualizeTwoAccountTransaction() {
    if (selectedAccount == null ||
        selectedAccount2 == null ||
        selectedCategory == null) {
      return const SizedBox();
    }
    double? value = tryValueParse(valueController.text);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            clickableAccountIcon(selectedAccount!),
            const Icon(Icons.arrow_right_alt, size: 60),
            Icon(
              selectedCategory!.icon,
              color: selectedCategory!.color,
              size: 40,
            ),
            const Icon(Icons.arrow_right_alt, size: 60),
            clickableAccountIcon(selectedAccount2!),
          ],
        ),
        if (value != null && value >= 0)
          BalanceText(
            value,
            hasPrefix: false,
          ),
      ],
    );
  }

  Widget _visualizeOneAccountTransaction() {
    if (selectedAccount == null || selectedCategory == null) {
      return const SizedBox();
    }
    double? value = tryValueParse(valueController.text);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              clickableAccountIcon(selectedAccount!),
              (value != null && value >= 0)
                  ? Transform.rotate(
                      // rotate by pi to flip the arrow
                      angle: 3.14,
                      child: const Icon(
                        Icons.arrow_right_alt,
                        size: 60,
                      ),
                    )
                  : const Icon(Icons.arrow_right_alt, size: 60),
              Icon(
                selectedCategory!.icon,
                color: selectedCategory!.color,
                size: 40,
              ),
            ],
          ),
          if (value != null)
            BalanceText(
              value,
              hasPrefix: false,
            ),
        ],
      ),
    );
  }

  InkWell clickableAccountIcon(Account account) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      splashColor: Colors.white10,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => AccountForm(
              initialAccount: account,
            ),
          ),
        );
      },
      child: Icon(
        account.icon,
        color: account.color,
        size: 40,
      ),
    );
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

    SingleTransaction transaction;
    transaction = SingleTransaction(
      id: 0,
      title: titleController.text.trim(),
      value: valueParser.evaluate(valueController.text),
      category: selectedCategory!,
      account: selectedAccount!,
      account2: selectedAccount2,
      description: description,
      date: transactionDate,
    );

    if (widget.initialSingleTransactionData != null) {
      transaction.id = widget.initialSingleTransactionData!.id;
    }

    return transaction;
  }

  void updateWasValueNegative(String newValue) {
    if (tryValueParse(valueController.text) != null) {
      setState(() {
        wasValueNegative = tryValueParse(valueController.text)! < 0;
      });
    }
  }

  void changePrefix(EnumPrefix prefix) {
    /// TODO: this can be improved when e.g. having multiplications
    bool needsBrackets = double.tryParse(valueController.text) == null;
    double? currentValue = tryValueParse(valueController.text);

    setState(() {
      switch (prefix) {
        case EnumPrefix.other:
          if (needsBrackets && currentValue != null) {
            valueController.text = '-(${valueController.text})';
          } else {
            valueController.text.startsWith('-')
                ? valueController.text = valueController.text.substring(1)
                : valueController.text = '-${valueController.text}';
          }
          break;
        case EnumPrefix.minus:
          if (currentValue == null || currentValue < 0) break;
          if (needsBrackets) {
            valueController.text = '-(${valueController.text})';
          } else {
            valueController.text = '-${valueController.text}';
          }
          break;
        case EnumPrefix.plus:
          if (currentValue == null || currentValue >= 0) break;
          if (needsBrackets) {
            valueController.text = '-(${valueController.text})';
          } else {
            valueController.text = valueController.text.substring(1);
          }
          break;
      }
    });
  }

  void _onAccount2checkboxClicked() {
    setState(() {
      hasAccount2 = !hasAccount2;
      if (hasAccount2) {
        changePrefix(EnumPrefix.plus);
      } else {
        selectedAccount2 = null;
      }
    });
  }
}
