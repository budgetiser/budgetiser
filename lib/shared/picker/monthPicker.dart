import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPicker extends StatefulWidget {
  const MonthPicker({
    required this.onDateChangedCallback,
    Key? key,
  }) : super(key: key);
  final void Function(DateTime) onDateChangedCallback;

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  final dateController = TextEditingController();
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            tooltip: "Previous Month",
            onPressed: () {
              setState(() {
                startDate = new DateTime(startDate.year, startDate.month - 1, startDate.day);
                widget.onDateChangedCallback(startDate);
              });
            },
          ),
        ),
        Expanded(child: Center(
          child: InkWell(
            onTap: () {
              setState(() {
                startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
                widget.onDateChangedCallback(startDate);
              });
            },
            child: Text(DateFormat("yyyy, MMMM").format(startDate)),
            )
          ),
        ),
        Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_outlined),
            tooltip: "Next Month",
            onPressed: () {
              setState(() {
                startDate = new DateTime(startDate.year, startDate.month + 1, startDate.day);
                widget.onDateChangedCallback(startDate);
              });
            },
          ),
        )
      ],
    );
  }
}
