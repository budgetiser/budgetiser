import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:budgetiser/shared/dataClasses/recurringTransaction.dart';
import 'package:budgetiser/shared/dataClasses/singleTransaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/picker/selectAccount.dart';
import 'package:budgetiser/shared/picker/selectCategory.dart';
import 'package:budgetiser/shared/widgets/confirmationDialog.dart';
import 'package:budgetiser/shared/widgets/recurringForm.dart';
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
  TransactionForm({
    Key? key,
    this.initialSingleTransactionData,
    this.initialRecurringTransactionData,
    this.initialNegative,
  }) : super(key: key);
  SingleTransaction? initialSingleTransactionData;
  RecurringTransaction? initialRecurringTransactionData;
  bool? initialNegative;

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

    super.initState();
  }

  setAccount(Account a) {
    setState(() {
      selectedAccount = a;
    });
  }

  setAccount2(Account a) {
    setState(() {
      selectedAccount2 = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: hasInitalData
            ? const Text("Edit Transaction")
            : const Text("New Transaction"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
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
                            ),
                          ],
                        ),
                        ExpansionTile(
                          initiallyExpanded: true,
                          title: Row(
                            children: [
                              const Text(
                                "Account ",
                              ),
                              if (selectedAccount != null)
                                Icon(
                                  selectedAccount!.icon,
                                  color: selectedAccount!.color,
                                ),
                              if (selectedAccount2 != null)
                                Row(
                                  children: [
                                    const Text(" to "),
                                    Icon(
                                      selectedAccount2!.icon,
                                      color: selectedAccount2!.color,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          children: [
                            Column(
                              children: [
                                SelectAccount(
                                    initialAccount: selectedAccount,
                                    callback: setAccount),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: hasAccount2,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          hasAccount2 = newValue!;
                                        });
                                        if (hasAccount2) {
                                          DatabaseHelper
                                              .instance.allAccountsStream
                                              .listen((event) {
                                            setState(() {
                                              selectedAccount2 = event.first;
                                            });
                                          });
                                        } else {
                                          selectedAccount2 = null;
                                        }
                                      },
                                    ),
                                    const Text("transfer to another account"),
                                  ],
                                ),
                                if (hasAccount2)
                                  Row(
                                    children: [
                                      const Text("to "),
                                      SelectAccount(
                                        initialAccount: selectedAccount2,
                                        callback: setAccount2,
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("   Category: "),
                            SelectCategory(
                                initialCategory: selectedCategory,
                                callback: (TransactionCategory c) {
                                  setState(() {
                                    selectedCategory = c;
                                  });
                                }),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: TextFormField(
                            controller: valueController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: "Value",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              try {
                                double.parse(value);
                              } catch (e) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        ExpansionTile(
                          title: const Text("Notes"),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TextFormField(
                                controller: descriptionController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  labelText: "Notes",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        if (widget.initialSingleTransactionData != null &&
                            widget.initialSingleTransactionData!
                                    .recurringTransaction !=
                                null)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionForm(
                                    initialRecurringTransactionData: widget
                                        .initialSingleTransactionData!
                                        .recurringTransaction,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                                "From Recurring Transaction '${widget.initialSingleTransactionData!.recurringTransaction!.title}'"),
                          ),
                        RecurringForm(
                          onRecurringDataChangedCallback: (data) {
                            setState(() {
                              recurringData = data;
                            });
                          },
                          initialRecurringData: recurringData,
                        )
                      ],
                    ),
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
          const SizedBox(
            width: 5,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (hasInitalData) {
                  if (recurringData.isRecurring) {
                    DatabaseHelper.instance.updateRecurringTransaction(
                        _currentRecurringTransaction());
                  } else {
                    DatabaseHelper.instance
                        .updateSingleTransaction(_currentSingleTransaction());
                  }
                } else {
                  if (recurringData.isRecurring) {
                    DatabaseHelper.instance.createRecurringTransaction(
                        _currentRecurringTransaction());
                  } else {
                    DatabaseHelper.instance
                        .createSingleTransaction(_currentSingleTransaction());
                  }
                }
                Navigator.of(context).pop();
              }
            },
            label: const Text("Save"),
            icon: const Icon(Icons.save),
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
}
