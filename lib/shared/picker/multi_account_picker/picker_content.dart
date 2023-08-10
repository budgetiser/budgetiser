import 'package:budgetiser/shared/dataClasses/selectable.dart';
import 'package:flutter/material.dart';

class GeneralMultiPicker<T extends Selectable> extends StatefulWidget {
  const GeneralMultiPicker({
    Key? key,
    required this.heading,
    required this.callback,
    required this.allValues,
  }) : super(key: key);
  final String heading;
  final Function(List<T> selected) callback;
  final List<T> allValues;

  @override
  State<GeneralMultiPicker<T>> createState() => _GeneralMultiPickerState<T>();
}

class _GeneralMultiPickerState<T extends Selectable>
    extends State<GeneralMultiPicker<T>> {
  final List<T> _selectedValues = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(widget.heading),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  print('inner build');
                  if (widget.allValues.isEmpty) {
                    return const SizedBox(
                      width: double.maxFinite,
                      child: Text('No data!'),
                    );
                  }
                  return SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.allValues.length,
                          itemBuilder: (context, listIDX) {
                            return CheckboxListTile(
                              title: Row(
                                children: [
                                  Icon(
                                    widget.allValues[listIDX].icon,
                                    color: widget.allValues[listIDX].color,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      widget.allValues[listIDX].name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: widget.allValues[listIDX].color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              value: _selectedValues
                                  .contains(widget.allValues[listIDX]),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedValues
                                        .add(widget.allValues[listIDX]);
                                  } else {
                                    _selectedValues
                                        .remove(widget.allValues[listIDX]);
                                  }
                                });
                              },
                            );
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, _selectedValues);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );

        // dialog closed
        widget.callback(_selectedValues);
      },
      child: ListTile(
        leading: const Icon(Icons.add),
        title: Center(child: Text(widget.heading)),
      ),
    );
  }
}
