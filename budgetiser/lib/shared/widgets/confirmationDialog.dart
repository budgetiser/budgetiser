import 'package:flutter/material.dart';

class ConfirmationDialog extends StatefulWidget {
  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.onCancelCallback,
    required this.onSubmitCallback,
  }) : super(key: key);
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
      elevation: 0,
      title: Text(widget.title),
      content: Text(widget.description),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            widget.onCancelCallback();
          },
        ),
        TextButton(
          child: const Text("Submit"),
          onPressed: () {
            widget.onSubmitCallback();
          },
        )
      ],
    );
  }
}
