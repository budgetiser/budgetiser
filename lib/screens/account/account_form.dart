import 'dart:math';

import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/transactions/transaction_form.dart';
import 'package:budgetiser/screens/transactions/transactions_screen.dart';
import 'package:budgetiser/shared/picker/select_icon.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/picker/color_picker.dart';
import 'package:budgetiser/shared/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({
    Key? key,
    this.initialAccount,
  }) : super(key: key);
  final Account? initialAccount;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  var nameController = TextEditingController();
  var balanceController = TextEditingController();
  var descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color _color = Color.fromRGBO(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
  IconData? _icon;

  @override
  void initState() {
    if (widget.initialAccount != null) {
      nameController.text = widget.initialAccount!.name;
      balanceController.text = widget.initialAccount!.balance.toString();
      descriptionController.text = widget.initialAccount!.description;
      _color = widget.initialAccount!.color;
      _icon = widget.initialAccount!.icon;
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.initialAccount != null
            ? const Text("Edit Account")
            : const Text("Add Account"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: IconPicker(
                                onIconChangedCallback: (iconData) {
                                  setState(() {
                                    _icon = iconData;
                                  });
                                },
                                initialIcon: _icon,
                                color: _color,
                              )),
                          Flexible(
                            child: TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: "Account Name",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          if (widget.initialAccount !=
                              null) // actions for existing accounts
                            Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                FloatingActionButton.extended(
                                  onPressed: (() {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => TransactionsScreen(
                                        initialAccountFilterName:
                                            nameController.text,
                                      ),
                                    ));
                                  }),
                                  label: const Text("View all transactions"),
                                  heroTag: "viewTransactions",
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                FloatingActionButton.extended(
                                  onPressed: (() {
                                    showBalanceDialog(context);
                                  }),
                                  label: const Text(
                                      "Set balance with transaction"),
                                  heroTag: "setBalanceWithTransaction",
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ColorPicker(
                        initialSelectedColor: _color,
                        onColorChangedCallback: (color) {
                          setState(() {
                            _color = color;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          controller: balanceController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            labelText: "Balance",
                            border: OutlineInputBorder(),
                          ),
                          validator: (data) {
                            if (data!.isEmpty) {
                              return "Please enter a balance";
                            }
                            try {
                              double.parse(data);
                            } catch (e) {
                              return "Please enter a valid number";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            labelText: "Description",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      if (widget.initialAccount != null)
                        Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            FloatingActionButton.extended(
                              onPressed: (() {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TransactionsScreen(
                                    initialAccountFilterName:
                                        nameController.text,
                                  ),
                                ));
                              }),
                              label: const Text("View all transactions"),
                              heroTag: "viewTransactions",
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          heroTag: 'cancel',
          backgroundColor: Colors.red,
          mini: true,
          onPressed: () {
            if (widget.initialAccount != null) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: "Attention",
                      description:
                          "Are you sure to delete this Account?\nALL TRANSACTIONS FROM THIS ACCOUNT WILL BE DELETED!\nThis action can't be undone!",
                      onSubmitCallback: () {
                        DatabaseHelper.instance.deleteAccount(
                          widget.initialAccount!.id,
                        );
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
          child: widget.initialAccount != null
              ? const Icon(Icons.delete_outline)
              : const Icon(Icons.close),
        ),
        const SizedBox(
          width: 5,
        ),
        FloatingActionButton.extended(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Account a = Account(
                  name: nameController.text,
                  icon: _icon ?? Icons.blur_on,
                  color: _color,
                  balance: double.parse(balanceController.text),
                  description: descriptionController.text,
                  id: 0);
              if (widget.initialAccount != null) {
                a.id = widget.initialAccount!.id;
                DatabaseHelper.instance.updateAccount(a);
              } else {
                DatabaseHelper.instance.createAccount(a);
              }
              Navigator.of(context).pop();
            }
          },
          label: const Text("Save"),
          icon: const Icon(Icons.save),
          heroTag: "save",
        ),
      ]),
    );
  }

  Future showBalanceDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var inputController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Set balance"),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: inputController,
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter number';
                  }

                  return null;
                },
              ),
            ),
            actions: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.red,
                mini: true,
                child: const Icon(Icons.close),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => TransactionForm(
                                initialBalance: (double.parse(
                                            inputController.text) -
                                        double.parse(balanceController.text))
                                    .toStringAsFixed(2))));
                  }
                },
                label: const Text("Set"),
                icon: const Icon(Icons.check),
              ),
            ],
          );
        });
  }
}
