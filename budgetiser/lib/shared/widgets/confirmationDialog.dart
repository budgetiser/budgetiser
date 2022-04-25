import 'package:flutter/material.dart';

class ConfirmationDialog extends StatefulWidget {
  ConfirmationDialog(
      {Key? key, required this.onCancelCallback, required this.onSubmitCallback})
      : super(key: key);
  Function onCancelCallback;
  Function onSubmitCallback;

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Attention"),
      content: const Text(
          "Are you sure to perform this action? This can't be undone!"),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            widget.onCancelCallback();
          },
        ),
        TextButton(
          child: Text("Continue"),
          onPressed: () {
            widget.onSubmitCallback();
          },
        )
      ],
    );
  }
}
