import 'package:budgetiser/shared/widgets/picker/selectIcon.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/widgets/picker/colorpicker.dart';
import 'package:flutter/material.dart';

import '../../../shared/services/notification/colorPicker.dart';

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

  @override
  void initState() {
    if (widget.initialAccount != null) {
      nameController.text = widget.initialAccount!.name;
      balanceController.text = widget.initialAccount!.balance.toString();
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
            widget.initialAccount != null
                ? NotificationListener<ColorPicked>(
                    child: Colorpicker(
                        selectedColor: widget.initialAccount!.color),
                    onNotification: (n) {
                      setState(() {
                        widget.initialAccount!.color = n.col;
                      });
                      return true;
                    },
                  )
                : Colorpicker(),
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
