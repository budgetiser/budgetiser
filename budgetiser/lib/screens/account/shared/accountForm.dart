import 'package:budgetiser/screens/account/shared/selectIcon.dart';
import 'package:flutter/material.dart';

class AccountForm extends StatelessWidget {
  const AccountForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SelectIcon(),
                ),
                Flexible(
                  child: TextFormField(
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
                initialValue: "0",
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
