import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/widgets/picker/datePicker.dart';
import 'package:budgetiser/shared/widgets/picker/selectIcon.dart';
import 'package:budgetiser/shared/widgets/recurringForm.dart';
import 'package:flutter/material.dart';

class BudgetForm extends StatefulWidget {
  BudgetForm({
    Key? key,
    this.initialName,
    this.initalBalance,
    this.initialBudgetData
  }) : super(key: key);
  String? initialName;
  int? initalBalance;
  Budget? initialBudgetData;

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  var nameController = TextEditingController();
  var balanceController = TextEditingController();
  bool isRecurring = false;

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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 13),
          child: TextFormField(
            controller: nameController,
            // initialValue: widget.initialName,
            decoration: const InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 13),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconPicker(
                  initialIcon: widget.initialBudgetData != null
                      ? widget.initialBudgetData!.icon
                      : null,
                  initialColor: widget.initialBudgetData != null
                      ? widget.initialBudgetData!.color
                      : null,
                ),
              ),
              //ColorPicker();
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 13),
          child: TextFormField(
            controller: balanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: "Limit",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0, right: 8, top: 13),
          child: Row(children: [
            Flexible(
              child: DatePicker(
                label: "start",
              ),
            ),
            Checkbox(
              value: isRecurring,
              onChanged: (bool? newValue) {
                setState(() {
                  isRecurring = newValue!;
                });
              },
            ),
            const Text("recurring"),
          ]),
        ),
        Row(
          children: [
            RecurringForm(isHidden: !isRecurring),
          ],
        )
      ],
    );
  }
}
