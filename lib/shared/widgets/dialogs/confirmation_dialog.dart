import 'package:flutter/material.dart';

class ConfirmationDialog extends StatefulWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onCancelCallback,
    required this.onSubmitCallback,
  });
  final Function onCancelCallback;
  final Function onSubmitCallback;
  final String title;
  final String description;

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.description),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            // ignore: avoid_dynamic_calls
            widget.onCancelCallback();
          },
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            // ignore: avoid_dynamic_calls
            widget.onSubmitCallback();
          },
        )
      ],
    );
  }
}
