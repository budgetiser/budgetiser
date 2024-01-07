import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon.dart';
import 'package:flutter/material.dart';

class SelectableIconWithText extends StatelessWidget {
  final Selectable selectable;
  final double? size;
  final bool coloredText;

  const SelectableIconWithText(
    this.selectable, {
    this.size,
    this.coloredText = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SelectableIcon(
          selectable,
          size: size,
        ),
        const SizedBox(width: 8),
        Text(
          selectable.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: coloredText ? selectable.color : null,
            fontSize: size,
          ),
        ),
      ],
    );
  }
}
