import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/widgets/picker/colorpicker.dart';
import 'package:budgetiser/shared/widgets/picker/datePicker.dart';
import 'package:budgetiser/shared/widgets/recurringForm.dart';
import 'package:flutter/material.dart';

class BudgetForm extends StatefulWidget {
  BudgetForm({Key? key, this.initialBudget}) : super(key: key);
  Budget? initialBudget;

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  var nameController = TextEditingController();
  var limitController = TextEditingController();
  bool isRecurring = false;

  @override
  void initState() {
    if (widget.initialBudget != null) {
      nameController.text = widget.initialBudget!.name;
      limitController.text = widget.initialBudget!.limit.toString();
      isRecurring = widget.initialBudget!.isRecurring;
      if (widget.initialBudget!.isRecurring == true) {}
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
            decoration: const InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.add),
            Expanded(
              child: Colorpicker(selectedColor: (widget.initialBudget != null) ? widget.initialBudget!.color : Theme.of(context).colorScheme.primary),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 13),
          child: TextFormField(
            controller: limitController,
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
          children: [RecurringForm(isHidden: !isRecurring)],
        )
      ],
    );
  }
}
