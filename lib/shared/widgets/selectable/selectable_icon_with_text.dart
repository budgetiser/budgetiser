import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon.dart';
import 'package:flutter/material.dart';

class SelectableIconWithText extends StatelessWidget {
  /// Colored icon of [selectable] with name to the right
  ///
  /// [size] defines the size of the icon and the textFont
  ///
  /// Sometime needs to be wrapped by Expanded
  const SelectableIconWithText(
    this.selectable, {
    this.size,
    this.coloredText = true,
    super.key,
  });
  final Selectable selectable;
  final double? size;
  final bool coloredText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SelectableIcon(
          selectable,
          size: size,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            selectable.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: coloredText ? selectable.color : null,
              fontSize: size,
            ),
          ),
        ),
      ],
    );
  }
}
