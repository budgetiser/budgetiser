import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/transactions/transactions_screen.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/recurring_data.dart';
import 'package:budgetiser/shared/dataClasses/recurring_transaction.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/picker/select_account.dart';
import 'package:budgetiser/shared/picker/select_category.dart';
import 'package:budgetiser/shared/widgets/confirmation_dialog.dart';
import 'package:budgetiser/shared/widgets/recurring_form.dart';
import 'package:budgetiser/shared/widgets/smallStuff/balance_text.dart';
import 'package:flutter/material.dart';

/// a screen that allows the user to add a transaction
/// or edit an existing one
///
/// attributes:
/// * [initialNegative] - if true, the transaction has a "-"" prefilled
///
/// ONE of the following can be passed in:
/// - a SingleTransaction
/// - a RecurringTransaction
class TransactionForm extends StatefulWidget {
  const TransactionForm({
    Key? key,
    this.initialSingleTransactionData,
    this.initialRecurringTransactionData,
    this.initialNegative,
    this.initialSelectedAccount,
  }) : super(key: key);
  final SingleTransaction? initialSingleTransactionData;
  final RecurringTransaction? initialRecurringTransactionData;
  final bool? initialNegative;
  final Account? initialSelectedAccount;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  RecurringData recurringData = RecurringData(
    isRecurring: false,
    startDate: DateTime.now(),
  );
  Account? selectedAccount;
  Account? selectedAccount2;
  TransactionCategory? selectedCategory;
  bool hasAccount2 = false;
  bool hasInitalData = false;

  var titleController = TextEditingController();
  var valueController = TextEditingController();
  var descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // for the recurring form to scroll to the bottom
  ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    if (widget.initialNegative == true) {
      valueController.text = "-";
    }
    if (widget.initialSingleTransactionData != null) {
      hasInitalData = true;
      titleController.text = widget.initialSingleTransactionData!.title;
      valueController.text =
          widget.initialSingleTransactionData!.value.toString();
      selectedAccount = widget.initialSingleTransactionData!.account;
      selectedCategory = widget.initialSingleTransactionData!.category;
      hasAccount2 = widget.initialSingleTransactionData!.account2 != null;
      selectedAccount2 = widget.initialSingleTransactionData!.account2;
      descriptionController.text =
          widget.initialSingleTransactionData!.description;

      recurringData = RecurringData(
        isRecurring: false,
        startDate: widget.initialSingleTransactionData!.date,
      );
    }
    if (widget.initialRecurringTransactionData != null) {
      hasInitalData = true;
      titleController.text = widget.initialRecurringTransactionData!.title;
      valueController.text =
          widget.initialRecurringTransactionData!.value.toString();
      selectedAccount = widget.initialRecurringTransactionData!.account;
      selectedCategory = widget.initialRecurringTransactionData!.category;
      hasAccount2 = widget.initialRecurringTransactionData!.account2 != null;
      selectedAccount2 = widget.initialRecurringTransactionData!.account2;
      descriptionController.text =
          widget.initialRecurringTransactionData!.description;

      recurringData = RecurringData(
        isRecurring: true,
        startDate: widget.initialRecurringTransactionData!.startDate,
        intervalType: widget.initialRecurringTransactionData!.intervalType,
        intervalUnit: (widget.initialRecurringTransactionData)!.intervalUnit,
        intervalAmount: widget.initialRecurringTransactionData!.intervalAmount,
        endDate: widget.initialRecurringTransactionData!.endDate,
        repetitionAmount:
            widget.initialRecurringTransactionData!.repetitionAmount,
      );
    }
    if (widget.initialSelectedAccount != null) {
      selectedAccount = widget.initialSelectedAccount;
    }

    super.initState();
  }

  setAccount(Account a) {
    if (mounted) {
      setState(() {
        selectedAccount = a;
      });
    }
  }

  setAccount2(Account a) {
    if (mounted) {
      setState(() {
        selectedAccount2 = a;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: hasInitalData
            ? const Text("Edit Transaction")
            : const Text("New Transaction"),
      ),
      body: SingleChildScrollView(
        controller: listScrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // dead space
                    SizedBox(
                      height: 200,
                      child: selectedAccount2 != null
                          ? _visualizeTwoAccountTransaction()
                          : _visualizeOneAccountTransaction(),
                    ),
                    // value input
                    TextFormField(
                      controller: valueController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: "Value",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        try {
                          if (double.parse(value) < 0 && hasAccount2) {
                            return 'Only positive values with two accounts';
                          }
                        } catch (e) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
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
                        labelText: "Title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // account picker
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              "Account",
                              textAlign: TextAlign.left,
                              style: _themeData
                                          .inputDecorationTheme.labelStyle !=
                                      null
                                  ? _themeData.inputDecorationTheme.labelStyle!
                                      .copyWith(fontSize: 16)
                                  : const TextStyle(fontSize: 16),
                            ),
                          ),
                          SelectAccount(
                              initialAccount: selectedAccount,
                              callback: setAccount),
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
                                const Text("transfer to another account"),
                              ],
                            ),
                          ),
                          if (hasAccount2)
                            Row(
                              children: [
                                const Text("to "),
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
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              "Category",
                              textAlign: TextAlign.left,
                              style: _themeData
                                          .inputDecorationTheme.labelStyle !=
                                      null
                                  ? _themeData.inputDecorationTheme.labelStyle!
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
                          labelText: "Notes",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
              if (hasInitalData) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        title: "Attention",
                        description:
                            "Are you sure to delete this Transaction? This action can't be undone!",
                        onSubmitCallback: () {
                          if (recurringData.isRecurring) {
                            DatabaseHelper.instance
                                .deleteRecurringTransactionById(
                                    widget.initialRecurringTransactionData!.id);
                          } else {
                            DatabaseHelper.instance.deleteSingleTransactionById(
                                widget.initialSingleTransactionData!.id);
                          }
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        onCancelCallback: () {
                          Navigator.pop(context);
                        },
                      );
                    });
              } else {
                Navigator.of(context).pop();
              }
            },
            child: hasInitalData
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
                if (hasInitalData) {
                  if (recurringData.isRecurring) {
                    if (widget.initialRecurringTransactionData != null) {
                      DatabaseHelper.instance.updateRecurringTransaction(
                          _currentRecurringTransaction());
                    } else {
                      DatabaseHelper.instance.deleteSingleTransactionById(
                          widget.initialSingleTransactionData!.id);
                      DatabaseHelper.instance.createRecurringTransaction(
                          _currentRecurringTransaction());
                    }
                  } else {
                    // isRecurring is false
                    if (widget.initialSingleTransactionData != null) {
                      DatabaseHelper.instance
                          .updateSingleTransaction(_currentSingleTransaction());
                    } else {
                      DatabaseHelper.instance.deleteRecurringTransactionById(
                          widget.initialRecurringTransactionData!.id);
                      DatabaseHelper.instance
                          .createSingleTransaction(_currentSingleTransaction());
                    }
                  }
                  Navigator.of(context).pop();
                } else {
                  if (recurringData.isRecurring) {
                    DatabaseHelper.instance.createRecurringTransaction(
                        _currentRecurringTransaction());
                  } else {
                    DatabaseHelper.instance
                        .createSingleTransaction(_currentSingleTransaction());
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TransactionsScreen(),
                    ),
                  );
                }
              }
            },
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  Widget _visualizeTwoAccountTransaction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          selectedAccount != null ? selectedAccount!.icon : Icons.blur_linear,
          color:
              selectedAccount != null ? selectedAccount!.color : Colors.black,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selectedCategory != null
                  ? selectedCategory!.icon
                  : Icons.blur_linear,
              color: selectedCategory != null
                  ? selectedCategory!.color
                  : Colors.black,
            ),
            Icon(Icons.arrow_right_alt, size: 60),
            if (double.tryParse(valueController.text) != null)
              BalanceText(
                double.parse(valueController.text),
                hasPrefix: false,
              ),
          ],
        ),
        Icon(
          selectedAccount2 != null ? selectedAccount2!.icon : Icons.blur_linear,
          color:
              selectedAccount2 != null ? selectedAccount2!.color : Colors.black,
        ),
      ],
    );
  }

  Widget _visualizeOneAccountTransaction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
            selectedAccount != null ? selectedAccount!.icon : Icons.blur_linear,
            color: selectedAccount != null
                ? selectedAccount!.color
                : Colors.black),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selectedCategory != null
                  ? selectedCategory!.icon
                  : Icons.blur_linear,
              color: selectedCategory != null
                  ? selectedCategory!.color
                  : Colors.black,
            ),
            Icon(Icons.arrow_right_alt, size: 60),
          ],
        ),
      ],
    );
  }

  SingleTransaction _currentSingleTransaction() {
    SingleTransaction transaction;
    transaction = SingleTransaction(
      id: 0,
      title: titleController.text,
      value: double.parse(valueController.text),
      category: selectedCategory!,
      account: selectedAccount!,
      account2: selectedAccount2,
      description: descriptionController.text,
      date: recurringData.startDate,
    );

    if (widget.initialSingleTransactionData != null) {
      transaction.id = widget.initialSingleTransactionData!.id;
    }
    if (widget.initialRecurringTransactionData != null) {
      transaction.id = widget.initialRecurringTransactionData!.id;
    }

    return transaction;
  }

  RecurringTransaction _currentRecurringTransaction() {
    RecurringTransaction transaction;
    transaction = RecurringTransaction(
      id: 0,
      title: titleController.text,
      value: double.parse(valueController.text),
      category: selectedCategory!,
      account: selectedAccount!,
      account2: selectedAccount2,
      description: descriptionController.text,
      startDate: recurringData.startDate,
      endDate: recurringData.endDate!,
      intervalType: recurringData.intervalType!,
      intervalAmount: recurringData.intervalAmount!,
      intervalUnit: recurringData.intervalUnit!,
      repetitionAmount: recurringData.repetitionAmount!,
    );

    if (widget.initialSingleTransactionData != null) {
      transaction.id = widget.initialSingleTransactionData!.id;
    }
    if (widget.initialRecurringTransactionData != null) {
      transaction.id = widget.initialRecurringTransactionData!.id;
    }

    return transaction;
  }

  void _onAccount2checkboxClicked() {
    setState(() {
      hasAccount2 = !hasAccount2;
      if (!hasAccount2) {
        selectedAccount2 = null;
      }
    });
  }
}
