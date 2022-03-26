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
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyCustomForm(),
              SavingAccountPart(),
            ],
          ),
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
          borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    child: Text("balance"),
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
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(
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
        if (isSavingAccount) savingAccountForm(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            indent: 20,
            endIndent: 20,
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
              Text("Add Account"),
            ],
          ),
        ),
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("start date"),
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
                  child: Text("end date"),
                ),
                Flexible(
                  child: DatePicker(),
                ),
              ],
            ),
            Row(
              children: [
                const Text("saving goal"),
                Flexible(
                  child: TextFormField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      hintText: "Enter amount",
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              width: 300,
              height: 20,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: 0.7,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary),
                  backgroundColor: const Color(0xffD6D6D6),
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
