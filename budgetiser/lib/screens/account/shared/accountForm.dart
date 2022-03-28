import 'package:budgetiser/screens/account/shared/selectIcon.dart';
import 'package:flutter/material.dart';

class AccountForm extends StatefulWidget {
  AccountForm({
    Key? key,
    this.initialName,
    this.initalBalance,
  }) : super(key: key);
  String? initialName;
  int? initalBalance;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  var nameController = TextEditingController();
  var balanceController = TextEditingController();

  @override
  void initState() {
    if (widget.initialName != null) {
      nameController.text = widget.initialName!;
    }
    if (widget.initalBalance != null) {
      balanceController.text = widget.initalBalance!.toString();
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SelectIcon(),
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
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextFormField(
                controller: balanceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Balance",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}