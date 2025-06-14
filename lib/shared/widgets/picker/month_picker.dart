import 'package:budgetiser/shared/utils/date_utils.dart';
import 'package:flutter/material.dart';

class MonthPicker extends StatefulWidget {
  const MonthPicker({
    required this.onDateChangedCallback,
    super.key,
  });
  final void Function(DateTime) onDateChangedCallback;

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  DateTime selectedDate = firstOfMonth(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            tooltip: 'Previous Month',
            onPressed: () {
              setState(() {
                selectedDate = DateTime(
                  selectedDate.year,
                  selectedDate.month - 1,
                );
                widget.onDateChangedCallback(selectedDate);
              });
            },
          ),
        ),
        Expanded(
          child: Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedDate = firstOfMonth(DateTime.now());
                  widget.onDateChangedCallback(selectedDate);
                });
              },
              child: Text(dateAsYYYYMM(selectedDate)),
            ),
          ),
        ),
        Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_outlined),
            tooltip: 'Next Month',
            onPressed: () {
              setState(() {
                selectedDate = DateTime(
                  selectedDate.year,
                  selectedDate.month + 1,
                );
                widget.onDateChangedCallback(selectedDate);
              });
            },
          ),
        ),
      ],
    );
  }
}
