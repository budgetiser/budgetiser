import 'package:budgetiser/shared/dataClasses/selectable.dart';
import 'package:flutter/material.dart';

class PickerContent<T extends Selectable> extends StatefulWidget {
  const PickerContent({
    Key? key,
    this.initialSelected,
    required this.allValues,
    required this.heading,
    required this.callback,
  }) : super(key: key);
  final List<T> allValues;
  final List<T>? initialSelected;
  final String heading;
  final Function(List<T> selected) callback;

  @override
  State<PickerContent<T>> createState() => _PickerContentState<T>();
}

class _PickerContentState<T extends Selectable>
    extends State<PickerContent<T>> {
  List<T> _selectedValues = [];

  @override
  void initState() {
    if (widget.initialSelected != null) {
      _selectedValues = widget.initialSelected!.cast<T>();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(widget.heading),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  if (widget.allValues.isEmpty) {
                    return const SizedBox(
                      width: double.maxFinite,
                      child: Text("No data!"),
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
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ).then(
          (value) => {
            setState(() {
              widget.callback(value ?? []);
            }),
          },
        );
      },
      child: ListTile(
        leading: const Icon(Icons.add),
        title: Center(child: Text(widget.heading)),
      ),
    );
  }
}
