import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon_with_text.dart';
import 'package:flutter/material.dart';

class GeneralSinglePicker<T extends Selectable> extends StatefulWidget {
  const GeneralSinglePicker({
    super.key,
    required this.onPickedCallback,
    required this.possibleValues,
    this.blacklistedValues,
  });

  const GeneralSinglePicker.nullable({
    super.key,
    required this.onPickedCallback,
    required this.possibleValues,
    this.blacklistedValues,
  });

  final Function(T selected) onPickedCallback;
  final List<T> possibleValues;
  final List<T>? blacklistedValues;

  @override
  State<GeneralSinglePicker<T>> createState() => _GeneralSinglePickerState<T>();
}

class _GeneralSinglePickerState<T extends Selectable>
    extends State<GeneralSinglePicker<T>> {
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
            title: SelectableIconWithText(widget.possibleValues[listIndex]),
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
