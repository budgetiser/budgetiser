import 'package:budgetiser/shared/dataClasses/selectable.dart';
import 'package:flutter/material.dart';

class NullableGeneralSinglePicker<T extends Selectable> extends StatefulWidget {
  const NullableGeneralSinglePicker({
    Key? key,
    required this.onPickedCallback,
    required this.possibleValues,
    this.blacklistedValues,
  }) : super(key: key);

  final Function(T? selected) onPickedCallback;
  final List<T> possibleValues;
  final List<T>? blacklistedValues;

  @override
  State<NullableGeneralSinglePicker<T>> createState() =>
      _NullableGeneralSinglePickerState<T>();
}

class _NullableGeneralSinglePickerState<T extends Selectable>
    extends State<NullableGeneralSinglePicker<T>> {
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
            title: Row(
              children: [
                Icon(
                  widget.possibleValues[listIndex].icon,
                  color: widget.possibleValues[listIndex].color,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.possibleValues[listIndex].name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: widget.possibleValues[listIndex].color,
                    ),
                  ),
                ),
              ],
            ),
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
