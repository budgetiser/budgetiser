import 'package:budgetiser/bd/database.dart';
import 'package:budgetiser/shared/widgets/picker/selectIcon.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/widgets/picker/colorpicker.dart';
import 'package:flutter/material.dart';

import '../../shared/services/notification/colorPicker.dart';

class AccountForm extends StatefulWidget {
  AccountForm({
    Key? key,
    this.initialAccount,
  }) : super(key: key);
  Account? initialAccount;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  var nameController = TextEditingController();
  var balanceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color _color = Colors.blue;

  @override
  void initState() {
    if (widget.initialAccount != null) {
      nameController.text = widget.initialAccount!.name;
      balanceController.text = widget.initialAccount!.balance.toString();
      _color = widget.initialAccount!.color;
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
            child: Column(
              children: [
                Form(
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
                                padding: const EdgeInsets.all(8.0),
                                child: IconPicker(
                                  initialIcon: widget.initialAccount != null
                                      ? widget.initialAccount!.icon
                                      : null,
                                  initialColor: widget.initialAccount != null
                                      ? widget.initialAccount!.color
                                      : null,
                                ),
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: nameController,
                                  // initialValue: widget.initialName,
                                  decoration: const InputDecoration(
                                    labelText: "Account Name",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          NotificationListener<ColorPicked>(
                            child: Colorpicker(selectedColor: _color),
                            onNotification: (n) {
                              setState(() {
                                _color = n.col;
                              });
                              return true;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextFormField(
                              controller: balanceController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                labelText: "Balance",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _formKey.currentState?.validate();
          Account a = Account(
              name: nameController.text,
              icon: Icons.abc,
              color: _color,
              balance: double.parse(balanceController.text),
              description: "d",
              id: 0);
          DatabaseHelper.instance.createAccount(a);
          Navigator.of(context).pop();
        },
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
