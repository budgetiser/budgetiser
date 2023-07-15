
import 'package:budgetiser/shared/dataClasses/selectables.dart';
import 'package:flutter/material.dart';

import '../../../db/database.dart';

class PickerContent<T extends Selectable> extends StatefulWidget {
  const PickerContent({Key? key, this.initials, required this.values, required this.heading, required this.callback}) : super(key: key);
  final List<T> values;
  final List<T>? initials;
  final String heading;
  final Function(List<T> selected) callback;

  @override
  State<PickerContent<T>> createState() => _PickerContentState<T>();
}

class _PickerContentState<T extends Selectable> extends State<PickerContent<T>> {

  List<T> _selectedValues = [];

  @override
  void initState() {
    if (widget.initials != null) {
      _selectedValues = widget.initials!.cast<T>();
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
            DatabaseHelper.instance.pushGetAllAccountsStream();
            return AlertDialog(
              title: Text(widget.heading),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  if(widget.values.isEmpty){
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
                          itemCount: widget.values.length,
                          itemBuilder: (context, listIDX) {
                            return CheckboxListTile(
                              title: Row(
                                children: [
                                  Icon(
                                    widget.values[listIDX].icon,
                                    color: widget.values[listIDX].color,
                                  ),
                                  const SizedBox( width: 8 ),
                                  Flexible(
                                    child: Text(
                                      widget.values[listIDX].name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: widget.values[listIDX].color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              value: _selectedValues.contains(widget.values[listIDX]),
                              onChanged: (bool? value) {
                                setState(() {
                                  if ( value == true ) {
                                    _selectedValues.add(widget.values[listIDX]);
                                  } else {
                                    _selectedValues.remove(widget.values[listIDX]);
                                  }
                                });
                              },
                            );
                          }
                        ),
                        TextButton(onPressed: () {
                          Navigator.pop(context, _selectedValues);
                        }, child: const Text("Save"))
                      ]
                    )
                  );
                })
            );
          }).then((value) => {
            setState(() {
              widget.callback(value ?? []);
            })
        });
      },
      child: ListTile(
        leading: const Icon(Icons.add),
        iconColor: Colors.white,
        title: Center(child:Text(widget.heading)),
      ),
    );
  }
}