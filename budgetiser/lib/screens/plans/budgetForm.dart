import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:budgetiser/shared/picker/selectIcon.dart';
import 'package:budgetiser/shared/widgets/recurringForm.dart';
import 'package:flutter/material.dart';

class BudgetForm extends StatefulWidget {
  BudgetForm(
      {Key? key, this.initialBudgetData})
      : super(key: key);
  Budget? initialBudgetData;

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  var nameController = TextEditingController();
  var balanceController = TextEditingController();

  @override
  void initState() {
    if (widget.initialBudgetData != null) {
      nameController.text = widget.initialBudgetData!.name;
      balanceController.text = widget.initialBudgetData!.balance.toString();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Budget"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 13),
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
                  padding: const EdgeInsets.only(top: 13),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconPicker(
                          onIconChangedCallback: (p0) {},
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
                RecurringForm(
                  onRecurringDataChangedCallback: (p0) {
                    // TODO: callback
                  },
                  initialRecurringData: RecurringData(
                    isRecurring: false,
                    startDate: DateTime.now(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text("Add Budget"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
