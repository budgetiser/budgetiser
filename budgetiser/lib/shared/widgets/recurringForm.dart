import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:budgetiser/shared/services/notification/recurringNotification.dart';
import 'package:budgetiser/shared/widgets/picker/datePicker.dart';
import 'package:flutter/material.dart';

class RecurringForm extends StatefulWidget {
  RecurringForm({Key? key}) : super(key: key);

  @override
  State<RecurringForm> createState() => _RecurringFormState();
}

enum IntervalType {
  fixedTurnus,
  everyInterval,
}

class _RecurringFormState extends State<RecurringForm> {
  bool isRecurring = false;
  DateTime startDate = DateTime.now();
  IntervalType _selectedType = IntervalType.fixedTurnus;
  var turnusController = TextEditingController();
  var intervalController = TextEditingController();
  var repetitionsController = TextEditingController();
  String fixedTurnusMode = "week";
  String intervalMode = "day";

  List<DropdownMenuItem<String>> get dropdownItemsTurnus {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("of a week"), value: "week"),
      const DropdownMenuItem(child: Text("of a month"), value: "month"),
      const DropdownMenuItem(child: Text("of a year"), value: "year"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemsInterval {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("day"), value: "day"),
      const DropdownMenuItem(child: Text("week"), value: "week"),
      const DropdownMenuItem(child: Text("month"), value: "month"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 0, right: 8, top: 13),
          child: Row(children: [
            Flexible(
              child: DatePicker(
                label: "start",
                initialDate: startDate,
              ),
            ),
            Checkbox(
              value: isRecurring,
              onChanged: (bool? newValue) {
                setState(() {
                  isRecurring = newValue!;
                  _sendRecurringNotification();
                });
              },
            ),
            const Text("recurring"),
          ]),
        ),
        if (isRecurring)
          Column(
            children: [
              Row(children: <Widget>[
                Radio(
                  onChanged: (IntervalType? value) {
                    setState(() {
                      _selectedType = value!;
                      _sendRecurringNotification();
                    });
                  },
                  groupValue: _selectedType,
                  value: IntervalType.fixedTurnus,
                ),
                const Text("always on the: "),
                SizedBox(
                  width: 40,
                  height: 30,
                  child: TextFormField(
                    controller: turnusController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                SizedBox(
                  child: DropdownButton(
                    value: fixedTurnusMode,
                    items: dropdownItemsTurnus,
                    onChanged: (String? value) {
                      setState(() {
                        fixedTurnusMode = value!;
                        _sendRecurringNotification();
                      });
                    },
                  ),
                )
              ]),
              Row(children: <Widget>[
                Radio(
                  onChanged: (IntervalType? value) {
                    setState(() {
                      _selectedType = value!;
                      _sendRecurringNotification();
                    });
                  },
                  groupValue: _selectedType,
                  value: IntervalType.everyInterval,
                ),
                const Text("every: "),
                SizedBox(
                  width: 40,
                  height: 30,
                  child: TextFormField(
                    controller: intervalController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                  ),
                ),
                SizedBox(
                  child: DropdownButton(
                    value: intervalMode,
                    items: dropdownItemsInterval,
                    onChanged: (String? value) {
                      setState(() {
                        intervalMode = value!;
                        _sendRecurringNotification();
                      });
                    },
                  ),
                )
              ]),
              Row(
                children: [
                  const Text("Repetitions: "),
                  SizedBox(
                    width: 40,
                    height: 30,
                    child: TextFormField(
                      controller: repetitionsController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                    ),
                  )
                ],
              ),
              Row(
                children: const [
                  Text("Ends on:"),
                ],
              ),
            ],
          ),
      ],
    );
  }

  void _sendRecurringNotification() {
    RecurringNotification(
      RecurringData(
        startDate: startDate,
        isRecurring: isRecurring,
        intervalType: _selectedType,
        intervalUnit: intervalMode,
        intervalAmount:
            repetitionsController.text.isEmpty || intervalController.text == ""
                ? null
                : int.parse(intervalController.text),
        endDate: DateTime.now(),
      ),
    ).dispatch(context);
  }
}
