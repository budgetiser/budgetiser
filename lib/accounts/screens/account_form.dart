import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/shared/utils/color_utils.dart';
import 'package:budgetiser/shared/utils/data_types_utils.dart';
import 'package:budgetiser/shared/widgets/actionButtons/cancel_action_button.dart';
import 'package:budgetiser/shared/widgets/forms/screen_forms.dart';
import 'package:budgetiser/shared/widgets/picker/icon_color/icon_color_picker.dart';
import 'package:budgetiser/transactions/screens/transaction_form.dart';
import 'package:budgetiser/transactions/screens/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({
    super.key,
    this.initialAccount,
  });
  final Account? initialAccount;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  var nameController = TextEditingController();
  var balanceController = TextEditingController();
  var descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color _color = randomColor();
  IconData _icon = Icons.abc;

  @override
  void initState() {
    super.initState();
    if (widget.initialAccount != null) {
      nameController.text = widget.initialAccount!.name;
      balanceController.text =
          widget.initialAccount!.balance.toStringAsFixed(2);
      descriptionController.text = widget.initialAccount!.description ?? '';
      _color = widget.initialAccount!.color;
      _icon = widget.initialAccount!.icon;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    balanceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.initialAccount != null
            ? const Text('Edit Account')
            : const Text('Add Account'),
      ),
      body: ScrollViewWithDeadSpace(
          deadSpaceContent: Container(),
          deadSpaceSize: 150,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // icon and name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconColorPicker(
                        initialIcon: _icon,
                        initialColor: _color,
                        onSelection: (selectedIcon, selectedColor) {
                          setState(() {
                            _icon = selectedIcon;
                            _color = selectedColor;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: nameController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            labelText: 'Account Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (data) {
                            if (data!.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: balanceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Balance',
                      border: OutlineInputBorder(),
                    ),
                    validator: (data) {
                      if (data!.isEmpty) {
                        return 'Please enter a balance';
                      }
                      try {
                        double.parse(data);
                      } catch (e) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  // account action buttons
                  if (widget.initialAccount != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        FloatingActionButton.extended(
                          label: const Text('Set balance with transaction'),
                          icon: const Icon(Icons.keyboard_tab_rounded),
                          heroTag: 'setBalanceWithTransaction',
                          onPressed: (() {
                            showBalanceDialog(context);
                          }),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        FloatingActionButton.extended(
                          label: const Text('View all transactions'),
                          icon: const Icon(Icons.list),
                          heroTag: 'viewTransactions',
                          onPressed: (() {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TransactionsScreen(
                                  initialAccountsFilter:
                                      widget.initialAccount != null
                                          ? [widget.initialAccount!]
                                          : [],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ]),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        CancelActionButton(
          isDeletion: widget.initialAccount != null,
          onSubmitCallback: () {
            Provider.of<AccountModel>(context, listen: false).deleteAccount(
              widget.initialAccount!.id,
            );
          },
        ),
        const SizedBox(
          width: 5,
        ),
        FloatingActionButton.extended(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Account a = Account(
                name: nameController.text.trim(),
                icon: _icon,
                color: _color,
                balance: double.parse(balanceController.text),
                description: parseNullableString(descriptionController.text),
                id: 0,
              );
              if (widget.initialAccount != null) {
                a.id = widget.initialAccount!.id;
                Provider.of<AccountModel>(context, listen: false)
                    .updateAccount(a);
              } else {
                Provider.of<AccountModel>(context, listen: false)
                    .createAccount(a);
              }
              Navigator.of(context).pop();
            }
          },
          label: const Text('Save'),
          icon: const Icon(Icons.save),
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
          title: const Text('Set balance'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: inputController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              autofocus: true,
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
                        initialBalance: (roundString(inputController.text) -
                                roundString(balanceController.text))
                            .toStringAsFixed(2),
                        initialSelectedAccount: widget.initialAccount,
                      ),
                    ),
                  );
                }
              },
              label: const Text('Set'),
              icon: const Icon(Icons.check),
            ),
          ],
        );
      },
    );
  }
}
