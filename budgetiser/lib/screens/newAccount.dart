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
            const Text("Name"),
            MyCustomForm(),
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
          color: const Color.fromARGB(255, 255, 165, 165),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
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
      ),
    );
  }
}
