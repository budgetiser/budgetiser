import 'package:flutter/material.dart';

class RadioItemClickable extends StatelessWidget {
  const RadioItemClickable({
    required this.onChangedCallback,
    required this.value,
    required this.groupValue,
    required this.title,
    super.key,
  });
  final Function(dynamic) onChangedCallback;
  final dynamic value;
  final dynamic groupValue;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChangedCallback(value);
      },
      child: ListTile(
        title: Text(title),
        leading: Radio(
          value: value,
          groupValue: groupValue,
          onChanged: (value) {
            onChangedCallback(value);
          },
        ),
      ),
    );
  }
}
