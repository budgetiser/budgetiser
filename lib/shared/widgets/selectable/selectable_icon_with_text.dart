import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon.dart';
import 'package:flutter/material.dart';

class SelectableIconWithText extends StatelessWidget {
  final Selectable selectable;

  const SelectableIconWithText(
    this.selectable, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SelectableIcon(selectable),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            selectable.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: selectable.color,
            ),
          ),
        ),
      ],
    );
  }
}
