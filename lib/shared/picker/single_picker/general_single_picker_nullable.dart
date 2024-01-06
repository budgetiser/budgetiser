import 'package:budgetiser/shared/dataClasses/selectable.dart';
import 'package:flutter/material.dart';

class GeneralSinglePickerNullable<T extends Selectable> extends StatefulWidget {
  const GeneralSinglePickerNullable({
    super.key,
    required this.onPickedCallback,
    required this.possibleValues,
    this.blacklistedValues,
  });

  final Function(T? selected) onPickedCallback;
  final List<T> possibleValues;
  final List<T>? blacklistedValues;

  @override
  State<GeneralSinglePickerNullable<T>> createState() =>
      _GeneralSinglePickerNullableState<T>();
}

class _GeneralSinglePickerNullableState<T extends Selectable>
    extends State<GeneralSinglePickerNullable<T>> {
  final List<T> selectedValues = [];

  @override
  void initState() {
    if (widget.blacklistedValues != null) {
      for (var element in widget.blacklistedValues!) {
        widget.possibleValues.remove(element);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      actions: [
        TextButton(
          child: const Text('Select None'),
          onPressed: () {
            setState(() {
              widget.onPickedCallback(null);
            });
            Navigator.of(context).pop();
          },
        ),
      ],
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          if (widget.possibleValues.isEmpty) {
            return const SizedBox(
              width: double.maxFinite,
              child: Text('No data!'),
            );
          }
          return dialogContent(setState, context);
        },
      ),
    );
  }

  SizedBox dialogContent(StateSetter setState, BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.possibleValues.length,
        itemBuilder: (context, listIndex) {
          return ListTile(
            title: widget.possibleValues[listIndex].getSelectableIconWithText(),
            onTap: () {
              setState(() {
                widget.onPickedCallback(widget.possibleValues[listIndex]);
              });
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
