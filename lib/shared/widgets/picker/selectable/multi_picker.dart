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
    this.noDataButton,
  });
  final String heading;
  final Function(List<T> selected) onPickedCallback;
  final List<T> possibleValues;
  final List<T>? initialValues;

  /// Optional button for dialog. Displayed if no data is available.
  final TextButton? noDataButton;

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
        Container(
          child: widget.noDataButton ?? widget.noDataButton,
        ),
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
            return const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                height: 30,
                child: Center(
                  child: Text('Nothing to select!'),
                ),
              ),
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
    void onAllClicked(bool? value) {
      setState(() {
        if (selectedValues.isEmpty) {
          selectedValues = [
            ...widget.possibleValues,
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
            CheckboxListTile(
              tristate: true,
              onChanged: onAllClicked,
              value: allCheckboxState(),
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('All'),
                ],
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
