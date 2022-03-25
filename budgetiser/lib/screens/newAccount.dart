import 'package:budgetiser/shared/services/datePicker.dart';
import 'package:budgetiser/shared/services/selectCategory.dart';
import 'package:flutter/material.dart';

class NewAccount extends StatelessWidget {
  const NewAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Account"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            // const Text("Name"),
            const MyCustomForm(),
            const SavingAccountPart(),
          ],
        ),
      ),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          // color: const Color.fromARGB(255, 255, 165, 165),
        ),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SelectCategory(),
                ),
                Flexible(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter name',
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: const Text("balance"),
                  ),
                  Flexible(
                    child: TextFormField(
                      initialValue: "0",
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: "Enter amount",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SavingAccountPart extends StatefulWidget {
  const SavingAccountPart({Key? key}) : super(key: key);

  @override
  State<SavingAccountPart> createState() => _SavingAccountPartState();
}

class _SavingAccountPartState extends State<SavingAccountPart> {
  bool isSavingAccount = false;

  void tick(bool? v) {
    setState(() {
      isSavingAccount = v!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              color: Color.fromARGB(255, 255, 255, 255),
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("is a saving account"),
              Checkbox(
                value: isSavingAccount,
                onChanged: tick,
              ),
            ],
          ),
          // form for the saving account with input field for start and end date
          if (isSavingAccount)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  // color: const Color.fromARGB(255, 255, 165, 165),
                ),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: const Text("start date"),
                        ),
                        Flexible(
                          child: DatePicker(),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: const Text("end date"),
                        ),
                        Flexible(
                          child: DatePicker(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
