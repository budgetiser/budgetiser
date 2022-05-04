import 'package:flutter/material.dart';

class ConfirmationDialog extends StatefulWidget {
  ConfirmationDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.onCancelCallback,
    required this.onSubmitCallback,
  }) : super(key: key);
  Function onCancelCallback;
  Function onSubmitCallback;
  String title;
  String description;

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(
          widget.description),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            widget.onCancelCallback();
          },
        ),
        TextButton(
          child: Text("Submit"),
          onPressed: () {
            widget.onSubmitCallback();
          },
        )
      ],
    );
  }
}
