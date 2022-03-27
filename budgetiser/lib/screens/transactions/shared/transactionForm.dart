import 'package:budgetiser/shared/services/selectAccount.dart';
import 'package:flutter/material.dart';

import '../../../shared/services/datePicker.dart';
import '../../account/shared/selectIcon.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({Key? key}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  bool isRecurring = false;
  var titleController = TextEditingController();
  var valueController = TextEditingController();
  var notesController = TextEditingController();

  void tick(bool? v) {
    setState(() {
      isRecurring = v!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: titleController,
                          // initialValue: widget.initialName,
                          decoration: const InputDecoration(
                            labelText: "Title",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SelectAccount(),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: valueController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: "Value",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: "Notes",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // recurring:
          Divider(),
          InkWell(
              enableFeedback: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isRecurring,
                    onChanged: tick,
                  ),
                  Text(
                    "is recurring",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
              onTap: () {
                tick(!isRecurring);
              }),

          // form for the saving account with input field for start and end date
          if (isRecurring)
            Column(
              children: [
                Row(
                  children: const <Widget>[
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16, right: 8),
                        child: DatePicker(
                          label: "start",
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16, left: 8),
                        child: DatePicker(
                          label: "end",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
