import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/widgets/picker/colorpicker.dart';
import 'package:budgetiser/shared/widgets/picker/datePicker.dart';
import 'package:budgetiser/shared/widgets/picker/selectIcon.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconPicker(
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
        Colorpicker(),
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
    );
  }
}
