import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/picker/colorpicker.dart';
import 'package:budgetiser/shared/picker/datePicker.dart';
import 'package:budgetiser/shared/picker/selectIcon.dart';
import 'package:flutter/material.dart';

class SavingForm extends StatefulWidget {
  SavingForm({Key? key, this.initialSavingData}) : super(key: key);
  Savings? initialSavingData;

  @override
  State<SavingForm> createState() => _SavingFormState();
}

class _SavingFormState extends State<SavingForm> {
  var nameController = TextEditingController();
  var initBalController = TextEditingController();
  var goalController = TextEditingController();

  @override
  void initState() {
    if (widget.initialSavingData != null) {
      nameController.text = widget.initialSavingData!.name;
      initBalController.text = widget.initialSavingData!.balance.toString();
      goalController.text = widget.initialSavingData!.goal.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    initBalController.dispose();
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.initialSavingData != null
            ? const Text("Edit Saving")
            : const Text("Create Saving"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconPicker(
                        onIconChangedCallback: (p0) {},
                        initialIcon: widget.initialSavingData != null
                            ? widget.initialSavingData!.icon
                            : null,
                        initialColor: widget.initialSavingData != null
                            ? widget.initialSavingData!.color
                            : null,
                      ),
                    ),
                    Flexible(
                        child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                    ))
                  ],
                ),
                Colorpicker(
                  onColorChangedCallback: (color) {},
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                        child: TextFormField(
                      controller: initBalController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: "Start",
                        border: OutlineInputBorder(),
                      ),
                    )),
                    Flexible(
                        child: TextFormField(
                      controller: goalController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: "Goal",
                        border: OutlineInputBorder(),
                      ),
                    ))
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                        child: DatePicker(
                      label: 'Start',
                      initialDate: (widget.initialSavingData != null)
                          ? widget.initialSavingData!.startDate
                          : DateTime.now(),
                      onDateChangedCallback: (date) {},
                    )),
                    Flexible(
                        child: DatePicker(
                      label: 'End',
                      initialDate: (widget.initialSavingData != null)
                          ? widget.initialSavingData!.endDate
                          : DateTime.now().add(const Duration(days: 30)),
                      onDateChangedCallback: (date) {},
                    ))
                  ],
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
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
