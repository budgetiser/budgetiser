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
import 'package:flutter/material.dart';

/// a screen that allows the user to add a transaction
/// or edit an existing one
///
/// attributes:
/// * [initialBalance] - set initial balance
/// * TODO:
///
/// ONE of the following can be passed in:
/// - a SingleTransaction
/// - a RecurringTransaction
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

class _TransactionFormState extends State<TransactionForm> {
  Account? selectedAccount;
  Account? selectedAccount2;
  TransactionCategory? selectedCategory;
  DateTime transactionDate = DateTime.now();
  bool hasAccount2 = false;
  bool hasInitalData = false;

  var titleController = TextEditingController();
  var valueController = TextEditingController();
  var descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formValueKey = GlobalKey<FormFieldState>();

  // for the recurring form to scroll to the bottom
  ScrollController listScrollController = ScrollController();

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

      transactionDate = widget.initialSingleTransactionData!.date;
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(valueController.text.startsWith("-")
                              ? Icons.remove
                              : Icons.add),
                          onPressed: () {
                            setState(() {
                              valueController.text.startsWith("-")
                                  ? valueController.text =
                                      valueController.text.substring(1)
                                  : valueController.text =
                                      "-${valueController.text}";
                            });
                            _formValueKey.currentState!.validate();
                          },
                          color: valueController.text.startsWith("-")
                              ? const Color.fromARGB(255, 174, 74, 99)
                              : const Color.fromARGB(239, 29, 129, 37),
                          splashRadius: 24,
                          iconSize: 48,
                        ),
                        Flexible(
                          child: TextFormField(
                            key: _formValueKey,
                            controller: valueController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: "Value",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _formValueKey.currentState!.validate();

                              // to update the visualization
                              setState(() {});
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter a value';
                              }
                              try {
                                if (double.parse(value) < 0 && hasAccount2) {
                                  return 'Only positive values with two accounts';
                                }
                              } catch (e) {
                                return 'Enter a valid number';
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
              if (hasInitalData) {
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
                  DatabaseHelper.instance
                      .updateSingleTransaction(_currentSingleTransaction());

                  Navigator.of(context).pop();
                } else {
                  DatabaseHelper.instance
                      .createSingleTransaction(_currentSingleTransaction());
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const TransactionsScreen()),
                      (Route<dynamic> route) => false);
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
              clickableAccountIcon(selectedAccount!),
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
                    )));
      },
      child: Icon(
        account.icon,
        color: account.color,
        size: 40,
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

    return transaction;
  }

  void _onAccount2checkboxClicked() {
    setState(() {
      hasAccount2 = !hasAccount2;
      if (!hasAccount2) {
        selectedAccount2 = null;
      }
    });
    _formValueKey.currentState!.validate();
  }
}
