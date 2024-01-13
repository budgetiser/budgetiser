import 'package:budgetiser/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';

class CancelActionButton extends StatelessWidget {
  final bool isDeletion;
  final String? deletionDescription;
  final Function()? onSubmitCallback;

  /// FloatingActionButton for canceling form or optional deleting the current form -> [isDeletion] required
  const CancelActionButton({
    super.key,
    this.isDeletion = false,
    this.deletionDescription,
    this.onSubmitCallback,
  }) : assert(
          isDeletion ? onSubmitCallback != null : true,
          'if isDeletion is true, onSubmitCallback needs to be set',
        );

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'cancel',
      backgroundColor: Colors.red,
      mini: true,
      onPressed: () {
        if (isDeletion) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ConfirmationDialog(
                title: 'Attention',
                description: deletionDescription != null
                    ? deletionDescription!
                    : "Are you sure to delete this item? All connected Items will deleted, too. This action can't be undone!",
                onSubmitCallback: () {
                  onSubmitCallback!();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                onCancelCallback: () {
                  Navigator.pop(context);
                },
              );
            },
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: isDeletion
          ? const Icon(Icons.delete_outline)
          : const Icon(Icons.close),
    );
  }
}
