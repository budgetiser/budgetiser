import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  DatePicker({
    required this.label,
    this.initialDate,
    Key? key,
  }) : super(key: key);
  final String label;
  DateTime? initialDate;

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final dateController = TextEditingController();

  @override
  void initState() {
    if (widget.initialDate != null) {
      dateController.text = widget.initialDate.toString().substring(0, 10);
    } else {
      // dateController.text = DateTime.now().toString().substring(0, 10);
    }

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: TextField(
            readOnly: true,
            controller: dateController,
            decoration: InputDecoration(
              hintText: widget.label,
              border: const OutlineInputBorder(),
              labelText: widget.label,
            ),
            onTap: () async {
              var date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));
              if (date != null) {
                setState(() {
                  dateController.text = date.toString().substring(0, 10);
                  print(
                      "date set to ${dateController.text}"); // TODO: how to get the date to new account layer?
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
