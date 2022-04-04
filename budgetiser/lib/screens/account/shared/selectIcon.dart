import 'package:flutter/material.dart';

class SelectIcon extends StatefulWidget {
  SelectIcon({Key? key, this.initialIcon, this.color}) : super(key: key);

  IconData? initialIcon;
  Color? color;

  @override
  State<SelectIcon> createState() => _SelectIconState();
}

class _SelectIconState extends State<SelectIcon> {
  @override
  Widget build(BuildContext context) {
    if (widget.initialIcon != null) {
      return Icon(
        widget.initialIcon,
        size: 30,
        color: widget.color ?? Colors.black,
      );
    }
    return const Icon(
      Icons.account_tree,
      size: 30,
    );
  }
}
