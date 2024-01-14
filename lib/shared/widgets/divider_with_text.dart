import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  /// Divider with small grey text in between (shifted slightly to the left, can be adjusted with [leftWidth])
  const DividerWithText(
    this.label, {
    this.height = 16,
    this.leftWidth = 32,
    super.key,
  });
  final String label;
  final double height;
  final double leftWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: leftWidth,
          margin: const EdgeInsets.only(left: 10.0, right: 15.0),
          child: Divider(
            height: height,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).disabledColor,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              height: height,
            ),
          ),
        ),
      ],
    );
  }
}
