import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:flutter/material.dart';

class SelectableIcon extends StatelessWidget {
  final Selectable selectable;
  final double? size;

  /// Colored icon of a [selectable]
  const SelectableIcon(
    this.selectable, {
    this.size = 24.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      selectable.icon,
      color: selectable.color,
      size: size,
    );
  }
}
