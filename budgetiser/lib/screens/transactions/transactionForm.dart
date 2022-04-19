import 'package:budgetiser/bd/database.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/services/notification/recurringNotification.dart';
import 'package:budgetiser/shared/widgets/picker/selectAccount.dart';
import 'package:budgetiser/shared/widgets/picker/selectCategory.dart';
import 'package:budgetiser/shared/widgets/recurringForm.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  TransactionForm({
    Key? key,
    this.initialTransactionData,
  }) : super(key: key);
  AbstractTransaction? initialTransactionData;

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

  var titleController = TextEditingController();
  var valueController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  void initState() {
    DatabaseHelper.instance.allAccountsStream.listen((event) {
      // TODO: BUG: gets executed after hasAccount2 is set to true by the user
      selectedAccount = event.first;
    });
    DatabaseHelper.instance.allCategoryStream.listen((event) {
      selectedCategory = event.first;
    });

    if (widget.initialTransactionData != null) {
      if (widget.initialTransactionData is RecurringTransaction) {
        recurringData = RecurringData(
          isRecurring: true,
          startDate:
              (widget.initialTransactionData as RecurringTransaction).startDate,
          intervalType: (widget.initialTransactionData as RecurringTransaction)
              .intervalType,
          intervalUnit: (widget.initialTransactionData as RecurringTransaction)
              .intervalUnit,
          intervalAmount:
              (widget.initialTransactionData as RecurringTransaction)
                  .intervalAmount,
          endDate:
              (widget.initialTransactionData as RecurringTransaction).endDate,
        );
      } else {
        recurringData.isRecurring = false;
      }
      titleController.text = widget.initialTransactionData!.title;
      valueController.text = widget.initialTransactionData!.value.toString();
      selectedAccount = widget.initialTransactionData!.account;
      selectedCategory = widget.initialTransactionData!.category;
      hasAccount2 = widget.initialTransactionData!.account2 != null;
      selectedAccount2 = widget.initialTransactionData!.account2;
      descriptionController.text = widget.initialTransactionData!.description;
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
        title: widget.initialTransactionData != null
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
                      const SizedBox(height: 8),
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
                                DatabaseHelper.instance.allAccountsStream
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
                      Row(
                        children: [
                          const Text("Category:"),
                          const SizedBox(width: 8),
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
                          enabled: (widget.initialTransactionData != null)
                              ? false
                              : true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: "Notes",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const Divider(),
                      NotificationListener<RecurringNotification>(
                        child: RecurringForm(
                          initialRecurringData: recurringData,
                        ),
                        onNotification: (notification) {
                          print("new recurring data");
                          setState(() {
                            recurringData = notification.recurringData;
                          });
                          return true;
                        },
                      )
                    ],
                  ),
                ),
              ),
              if (widget.initialTransactionData != null)
                Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    FloatingActionButton.extended(
                      onPressed: (() async {
                        await DatabaseHelper.instance
                            .deleteTransaction(_currentTransaction());
                        Navigator.of(context).pop();
                      }),
                      label: const Text("Delete"),
                      heroTag: "delete",
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: _formKey.currentState?.validate();

          if (widget.initialTransactionData != null) {
            DatabaseHelper.instance.updateTransaction(_currentTransaction());
          } else {
            DatabaseHelper.instance.createTransaction(_currentTransaction());
          }
          Navigator.of(context).pop();
        },
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }

  AbstractTransaction _currentTransaction() {
    AbstractTransaction transaction;
    if (!recurringData.isRecurring) {
      print(
          "selected account: ${selectedAccount}\n selected account2: ${selectedAccount2}");
      transaction = SingleTransaction(
        id: 0,
        title: titleController.text,
        value: double.parse(valueController.text),
        category: selectedCategory!,
        account: selectedAccount!,
        account2: selectedAccount2,
        description: descriptionController.text,
        date: DateTime.now(),
      );
    } else {
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
        intervalAmount: recurringData.intervalAmount!,
        intervalType: recurringData.intervalType!,
        intervalUnit: recurringData.intervalUnit!,
      );
    }
    if (widget.initialTransactionData != null) {
      print("id is ${widget.initialTransactionData!.id}");
      transaction.id = widget.initialTransactionData!.id;
    }

    return transaction;
  }
}
