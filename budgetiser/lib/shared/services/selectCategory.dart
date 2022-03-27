import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectCategory extends StatelessWidget {
  /*
    popup to select category
    todo: implementation -> how to pass selected item back to caller?
  */
  const SelectCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.account_tree,
      size: 30,
    );
  }
}
