import 'package:flutter/material.dart';

class ItemListDivider extends StatelessWidget {
  /// Divider for use in screen lists
  const ItemListDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 1,
      indent: 10,
      endIndent: 10,
    );
  }
}
