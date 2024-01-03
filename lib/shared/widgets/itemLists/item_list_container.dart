import 'package:flutter/material.dart';

/// Container with a item as [child] and a divider below
class ItemListContainer extends StatelessWidget {
  final Widget child;

  const ItemListContainer({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        child,
        const Divider(
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
      ],
    );
  }
}
