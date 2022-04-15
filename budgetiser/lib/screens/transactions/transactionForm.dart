import 'package:budgetiser/bd/database.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/services/notification/recurringNotification.dart';
import 'package:budgetiser/shared/tempData/tempData.dart';
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
  TransactionCategory? selectedCategory;
  var titleController = TextEditingController();
  var valueController = TextEditingController();
  var descriptionController = TextEditingController();
  var intervalController = TextEditingController();

  @override
  void initState() {
    if (widget.initialTransactionData != null) {
      recurringData.isRecurring =
          widget.initialTransactionData! is RecurringTransaction;
      titleController.text = widget.initialTransactionData!.title;
      valueController.text = widget.initialTransactionData!.value.toString();
      descriptionController.text = widget.initialTransactionData!.description;
      selectedAccount = widget.initialTransactionData!.account;
      selectedCategory = widget.initialTransactionData!.category;
      if (widget.initialTransactionData is RecurringTransaction) {
        intervalController.text =
            (widget.initialTransactionData as RecurringTransaction)
                .intervalAmount
                .toString();
        // recurringData.intervalType = (widget.initialTransactionData as RecurringTransaction)
      }
    }

    super.initState();
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
                      SelectAccount(initialAccount: selectedAccount),
                      Row(
                        children: [
                          const Text("Category:"),
                          const SizedBox(width: 8),
                          SelectCategory(initialCategory: selectedCategory),
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
                        onNotification: (notification) {
                          setState(() {
                            recurringData = notification.recurringData;
                            print("new recurring data");
                          });
                          return true;
                        },
                        child: RecurringForm(),
                      )
                    ],
                  ),
                ),
              ),

              // recurring:
              // const Divider(),
              // InkWell(
              //     enableFeedback: false,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Checkbox(
              //           value: isRecurring,
              //           onChanged: tick,
              //         ),
              //         Text(
              //           "is recurring",
              //           style: Theme.of(context).textTheme.headline2,
              //         ),
              //       ],
              //     ),
              //     onTap: () {
              //       tick(!isRecurring);
              //     }),

              // form for the saving account with input field for start and end date

              // Column(
              //   children: [
              //     Row(
              //       children: <Widget>[
              //         Flexible(
              //           child: Padding(
              //             padding:
              //                 const EdgeInsets.only(bottom: 16, right: 8),
              //             child: DatePicker(
              //               label: "start",
              //               initialDate: (widget.initialTransactionData
              //                       is RecurringTransaction)
              //                   ? (widget.initialTransactionData
              //                           as RecurringTransaction)
              //                       .startDate
              //                   : DateTime.now(),
              //             ),
              //           ),
              //         ),
              //         const Flexible(
              //           child: Padding(
              //             padding: EdgeInsets.only(bottom: 16, left: 8),
              //             child: Text("Ends: "),
              //           ),
              //         ),
              //       ],
              //     ),
              //     Row(
              //       // number input for the interval and dropdown with day month year input
              //       children: <Widget>[
              //         Flexible(
              //           child: Padding(
              //             padding:
              //                 const EdgeInsets.only(bottom: 16, right: 8),
              //             child: TextFormField(
              //               keyboardType:
              //                   const TextInputType.numberWithOptions(
              //                 decimal: true,
              //               ),
              //               controller: intervalController,
              //               decoration: const InputDecoration(
              //                 labelText: "interval",
              //                 border: OutlineInputBorder(),
              //               ),
              //             ),
              //           ),
              //         ),
              //         Flexible(
              //           child: Padding(
              //             padding:
              //                 const EdgeInsets.only(bottom: 16, left: 8),
              //             child: DropdownButton<String>(
              //               items: <String>[
              //                 "Days",
              //                 "Weeks",
              //                 "Months",
              //                 "Years",
              //               ]
              //                   .map((e) => DropdownMenuItem(
              //                         value: e,
              //                         child: Text(
              //                           e,
              //                         ),
              //                       ))
              //                   .toList(),
              //               onChanged: (e) {
              //                 setIntervalMode(e);
              //               },
              //               value: intervalType,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              if (widget.initialTransactionData != null)
                Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    FloatingActionButton.extended(
                      onPressed: (() {
                        DatabaseHelper.instance
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
          // _formKey.currentState?.validate();

          if (widget.initialTransactionData != null) {
            // DatabaseHelper.instance.updateAccount(a);
          } else {
            DatabaseHelper.instance
                .createTransaction(_currentTransaction() as SingleTransaction);
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
      transaction = SingleTransaction(
        id: 0,
        title: titleController.text,
        value: double.parse(valueController.text),
        category: TMP_DATA_categoryList[0],
        account: TMP_DATA_accountList[0],
        account2: null,
        description: descriptionController.text,
        date: DateTime.now(),
      );
    } else {
      transaction = RecurringTransaction(
        id: 0,
        title: titleController.text,
        value: double.parse(valueController.text),
        category: TMP_DATA_categoryList[0],
        account: TMP_DATA_accountList[0],
        account2: null,
        description: descriptionController.text,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        intervalAmount: 1,
        intervalType: "isByMonth",
        intervalUnit: "Month",
      );
    }
    if (widget.initialTransactionData != null) {
      transaction.id = widget.initialTransactionData!.id;
    }

    return transaction;
  }
}
