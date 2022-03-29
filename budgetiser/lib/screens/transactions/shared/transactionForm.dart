import 'package:budgetiser/shared/services/selectAccount.dart';
import 'package:budgetiser/shared/services/selectCategory.dart';
import 'package:flutter/material.dart';

import '../../../shared/services/datePicker.dart';
import '../../account/shared/selectIcon.dart';

class TransactionForm extends StatefulWidget {
  TransactionForm({
    Key? key,
    this.initialNotes,
    this.initialTitle,
    this.initialValue,
    this.initialIntervalMode,
    this.initialIsRecurring,
  }) : super(key: key);
  bool? initialIsRecurring;
  String? initialIntervalMode;
  String? initialTitle;
  int? initialValue;
  String? initialNotes;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  bool isRecurring = false;
  String intervalMode = "Days";
  var titleController = TextEditingController();
  var valueController = TextEditingController();
  var notesController = TextEditingController();

  @override
  void initState() {
    if (widget.initialIsRecurring != null) {
      isRecurring = widget.initialIsRecurring!;
    }
    if (widget.initialIntervalMode != null) {
      intervalMode = widget.initialIntervalMode!;
    }
    if (widget.initialTitle != null) {
      titleController.text = widget.initialTitle!;
    }
    if (widget.initialValue != null) {
      valueController.text = widget.initialValue!.toString();
    }
    if (widget.initialNotes != null) {
      notesController.text = widget.initialNotes!;
    }

    super.initState();
  }

  void tick(bool? v) {
    setState(() {
      isRecurring = v!;
    });
  }

  void setIntervalMode(String? mode) {
    setState(() {
      intervalMode = mode!;
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
                  const SizedBox(height: 8),
                  const SelectAccount(),
                  Row(
                    children: const [
                      Text("Category:"),
                      SizedBox(width: 8),
                      SelectCategory(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
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
          const Divider(),
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
                Row(
                  // number input for the interval and dropdown with day month year input
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16, right: 8),
                        child: TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: "interval",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16, left: 8),
                        child: DropdownButton<String>(
                          items: <String>[
                            "Days",
                            "Weeks",
                            "Months",
                            "Years",
                          ]
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (e) {
                            setIntervalMode(e);
                          },
                          value: intervalMode,
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
