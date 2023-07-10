
import 'package:flutter/material.dart';

class PickerContent<T> extends StatefulWidget {
  const PickerContent({Key? key, this.initials, required this.values}) : super(key: key);
  final List<T> values;
  final List<T>? initials;

  @override
  State<PickerContent> createState() => _PickerContentState<T>();
}

class _PickerContentState<T> extends State<PickerContent> {

  List<T> _selectedValues = [];

  @override
  void initState() {
    if (widget.initials != null) {
      print(widget.initials![0].hashCode);
      _selectedValues = widget.initials!.cast<T>();
      print(_selectedValues[0].hashCode);
      print(widget.initials![0] == _selectedValues[0]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      //TODO: widget.values[idx] contains new hashcodes after each reopen. Idea: Accounts are always newly fetched -> new async -> new hashcodes -> stored objects not equal anymore
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
          }, child: const Text("Close"))
        ]
      )
    );
  }
}