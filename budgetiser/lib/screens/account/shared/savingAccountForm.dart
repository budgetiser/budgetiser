import 'package:flutter/material.dart';

import '../../../shared/services/datePicker.dart';

class SavingAccountForm extends StatefulWidget {
  const SavingAccountForm({Key? key}) : super(key: key);

  @override
  State<SavingAccountForm> createState() => _SavingAccountFormState();
}

class _SavingAccountFormState extends State<SavingAccountForm> {
  bool isSavingAccount = false;

  void tick(bool? v) {
    setState(() {
      isSavingAccount = v!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            enableFeedback: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isSavingAccount,
                  onChanged: tick,
                ),
                Text(
                  "saving account",
                  style: Theme.of(context).textTheme.headline2,
                ),
              ],
            ),
            onTap: () {
              tick(!isSavingAccount);
            }),

        // form for the saving account with input field for start and end date
        if (isSavingAccount) savingAccountForm(),
      ],
    );
  }

  Widget savingAccountForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          // color: const Color.fromARGB(255, 255, 165, 165),
        ),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16, right: 8),
                    child: DatePicker(
                      label: "start",
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16, left: 8),
                    child: DatePicker(
                      label: "end",
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: "Saving goal",
                labelText: "Saving goal",
                border: OutlineInputBorder(),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              width: 300,
              height: 20,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Theme.of(context).dividerColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add),
                  Text("new Saving transaction"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
