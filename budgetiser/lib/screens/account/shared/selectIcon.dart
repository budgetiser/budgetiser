import 'package:flutter/material.dart';

class SelectIcon extends StatefulWidget {
  const SelectIcon({Key? key}) : super(key: key);

  @override
  State<SelectIcon> createState() => _SelectIconState();
}

class _SelectIconState extends State<SelectIcon> {
  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.account_tree,
      size: 30,
    );
  }
}
