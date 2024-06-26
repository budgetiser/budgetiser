import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon_with_text.dart';
import 'package:flutter/material.dart';

class GeneralMultiPicker<T extends Selectable> extends StatefulWidget {
  const GeneralMultiPicker({
    super.key,
    required this.heading,
    required this.onPickedCallback,
    required this.possibleValues,
    this.initialValues,
  });
  final String heading;
  final Function(List<T> selected) onPickedCallback;
  final List<T> possibleValues;
  final List<T>? initialValues;

  @override
  State<GeneralMultiPicker<T>> createState() => _GeneralMultiPickerState<T>();
}

class _GeneralMultiPickerState<T extends Selectable>
    extends State<GeneralMultiPicker<T>> {
  List<T> selectedValues = [];

  @override
  void initState() {
    if (widget.initialValues != null) {
      selectedValues = widget.initialValues!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.heading),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              widget.onPickedCallback(selectedValues);
            });
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
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

  bool? allCheckboxState() {
    if (selectedValues.isEmpty) return false;
    if (selectedValues.length != widget.possibleValues.length) {
      return null;
    } else {
      return true;
    }
  }

  Widget dialogContent(StateSetter setState, BuildContext context) {
    void onAllClicked() {
      setState(() {
        if (selectedValues.isEmpty) {
          selectedValues = [
            ...widget.possibleValues
          ]; // clone data. otherwise deselecting single item would .remove() from both lists
        } else {
          selectedValues = [];
        }
      });
    }

    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            InkWell(
              onTap: onAllClicked,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleMedium?.fontSize,
                      ),
                    ),
                    Checkbox(
                      tristate: true,
                      value: allCheckboxState(),
                      onChanged: (value) => onAllClicked,
                    )
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.possibleValues.length,
              itemBuilder: (context, listIndex) {
                return CheckboxListTile(
                  title: SelectableIconWithText(
                    widget.possibleValues[listIndex],
                  ),
                  value: selectedValues.contains(
                    widget.possibleValues[listIndex],
                  ),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedValues.add(widget.possibleValues[listIndex]);
                      } else {
                        selectedValues.remove(widget.possibleValues[listIndex]);
                      }
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
