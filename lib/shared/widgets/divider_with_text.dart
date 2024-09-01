import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  /// Divider with small gray text in between (shifted slightly to the left, can be adjusted with [leftWidth])
  const DividerWithText(
    this.label, {
    this.dividerHeight = 8.0,
    this.flexFactor = .1,
    this.innerPadding = const EdgeInsets.only(left: 10, right: 15),
    super.key,
  });

  final String label;
  final double flexFactor;
  final double dividerHeight;
  final EdgeInsetsGeometry innerPadding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: (100 * (flexFactor)).floor(),
          child: Divider(
            height: dividerHeight,
          ),
        ),
        Padding(
          padding: innerPadding,
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).disabledColor,
            ),
          ),
        ),
        Flexible(
          flex: (100 * (1 - flexFactor)).floor(),
          child: Divider(
            height: dividerHeight,
          ),
        ),
      ],
    );
  }
}
