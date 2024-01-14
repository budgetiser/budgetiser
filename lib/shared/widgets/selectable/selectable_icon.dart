import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:flutter/material.dart';

class SelectableIcon extends StatelessWidget {
  /// Colored icon of a [selectable]
  const SelectableIcon(
    this.selectable, {
    this.size = 24.0,
    super.key,
  });
  final Selectable selectable;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      selectable.icon,
      color: selectable.color,
      size: size,
    );
  }
}
