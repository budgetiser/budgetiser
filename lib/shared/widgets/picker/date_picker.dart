import 'package:budgetiser/shared/utils/date_utils.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    required this.label,
    this.initialDate,
    required this.onDateChangedCallback,
    super.key,
  });
  final String label;
  final DateTime? initialDate;
  final void Function(DateTime) onDateChangedCallback;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final dateController = TextEditingController();

  @override
  void initState() {
    if (widget.initialDate != null) {
      if (isSameDay(widget.initialDate!, DateTime.now())) {
        dateController.text = 'Today';
      } else {
        dateController.text = widget.initialDate.toString().substring(0, 10);
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: dateController,
      decoration: InputDecoration(
        hintText: widget.label,
        labelText: widget.label,
      ),
      onTap: () async {
        var date = await showDatePicker(
          context: context,
          initialDate: widget.initialDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          setState(() {
            if (isSameDay(date, DateTime.now())) {
              dateController.text = 'Today';
            } else {
              dateController.text = date.toString().substring(0, 10);
            }
            widget.onDateChangedCallback(date);
          });
        }
      },
    );
  }
}
