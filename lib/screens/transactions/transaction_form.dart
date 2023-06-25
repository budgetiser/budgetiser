import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/transactions/transactions_screen.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/recurring_data.dart';
import 'package:budgetiser/shared/dataClasses/recurring_transaction.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/picker/date_picker.dart';
import 'package:budgetiser/shared/picker/select_account.dart';
import 'package:budgetiser/shared/picker/select_category.dart';
import 'package:budgetiser/shared/widgets/confirmation_dialog.dart';
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
  Account? selectedAccount;
  Account? selectedAccount2;
  TransactionCategory? selectedCategory;
  DateTime transactionDate = DateTime.now();
  bool hasAccount2 = false;
  bool hasInitialData = false;

  var titleController = TextEditingController();
  var valueController = TextEditingController();
  var descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // for the recurring form to scroll to the bottom
  ScrollController listScrollController = ScrollController();

  RecurringData recurringData = RecurringData(
    startDate: DateTime.now(),
    isRecurring: false,
  );

  @override
  void initState() {
    if (widget.initialNegative == true) {
      valueController.text = "-";
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
    if (widget.initialRecurringTransactionData != null) {
      hasInitialData = true;
      titleController.text = widget.initialRecurringTransactionData!.title;
      valueController.text =
          widget.initialRecurringTransactionData!.value.toString();
      selectedAccount = widget.initialRecurringTransactionData!.account;
      selectedCategory = widget.initialRecurringTransactionData!.category;
      hasAccount2 = widget.initialRecurringTransactionData!.account2 != null;
      selectedAccount2 = widget.initialRecurringTransactionData!.account2;
      descriptionController.text =
          widget.initialRecurringTransactionData!.description;
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
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: hasInitialData
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
                    // dead space for visualization
                    SizedBox(
                      height: 180,
                      child: selectedAccount2 != null
                          ? _visualizeTwoAccountTransaction()
                          : _visualizeOneAccountTransaction(),
                    ),
                    const SizedBox(height: 16),
                    // value & date input
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: valueController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: "Value",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              // _formKey.currentState!.validate();

                              // to update the visualization
                              setState(() {});
                            },
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
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: DatePicker(
                            label: "Date",
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
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Account",
                              textAlign: TextAlign.left,
                              style: themeData
                                          .inputDecorationTheme.labelStyle !=
                                      null
                                  ? themeData.inputDecorationTheme.labelStyle!
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
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Category",
                              textAlign: TextAlign.left,
                              style: themeData
                                          .inputDecorationTheme.labelStyle !=
                                      null
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
              if (hasInitialData) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        title: "Attention",
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
                    });
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
                  Navigator.of(context).pop();
                } else {
                  DatabaseHelper.instance
                      .createSingleTransaction(_currentSingleTransaction());
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
    if (selectedAccount == null ||
        selectedAccount2 == null ||
        selectedCategory == null) {
      return const SizedBox();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              selectedAccount!.icon,
              color: selectedAccount!.color,
              size: 40,
            ),
            const Icon(Icons.arrow_right_alt, size: 60),
            Icon(
              selectedCategory!.icon,
              color: selectedCategory!.color,
              size: 40,
            ),
            const Icon(Icons.arrow_right_alt, size: 60),
            Icon(
              selectedAccount2!.icon,
              color: selectedAccount2!.color,
              size: 40,
            ),
          ],
        ),
        if (double.tryParse(valueController.text) != null &&
            double.parse(valueController.text) >= 0)
          BalanceText(
            double.parse(valueController.text),
            hasPrefix: false,
          ),
      ],
    );
  }

  Widget _visualizeOneAccountTransaction() {
    if (selectedAccount == null || selectedCategory == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                selectedAccount!.icon,
                color: selectedAccount!.color,
                size: 40,
              ),
              (double.tryParse(valueController.text) != null &&
                      double.parse(valueController.text) >= 0)
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
          if (double.tryParse(valueController.text) != null)
            BalanceText(
              double.parse(valueController.text),
              hasPrefix: false,
            ),
        ],
      ),
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
      date: transactionDate,
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
