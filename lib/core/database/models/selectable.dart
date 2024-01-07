import 'package:flutter/material.dart';

abstract class Selectable {
  String name;
  IconData icon;
  Color color;

  Selectable({
    required this.name,
    required this.icon,
    required this.color,
  });

  Icon getSelectableIconWidget({double size = 24}) {
    return Icon(
      icon,
      color: color,
      size: size,
    );
  }

  Widget getSelectableIconWithText() {
    return Row(
      children: [
        getSelectableIconWidget(),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
