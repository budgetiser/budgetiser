import 'package:budgetiser/shared/utils/color_utils.dart';
import 'package:budgetiser/shared/widgets/picker/icon_color/dialog.dart';
import 'package:flutter/material.dart';

class IconColorPicker extends StatefulWidget {
  const IconColorPicker({
    super.key,
    this.initialIcon,
    this.initialColor,
    required this.onSelection,
  });

  final IconData? initialIcon;
  final Color? initialColor;
  final Function(IconData selectedIcon, Color selectedColor) onSelection;

  @override
  State<IconColorPicker> createState() => _IconColorPickerState();
}

class _IconColorPickerState extends State<IconColorPicker> {
  @override
  Widget build(BuildContext context) {
    var color = widget.initialColor ?? randomColor();
    var iconData = widget.initialIcon ?? Icons.abc;
    return InkWell(
      onTap: () => {
        _showFullScreenDialog(
          context,
          iconData,
          color,
        )
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: color,
            width: 2,
          ),
        ),
        child: Icon(
          iconData,
          color: color,
          size: 30,
        ),
      ),
    );
  }

  void _showFullScreenDialog(
    BuildContext context,
    IconData initialIcon,
    Color initialColor,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return IconColorDialog(
            initialIcon: initialIcon,
            initialColor: initialColor,
            onSelection: widget.onSelection,
          );
        },
      ),
    );
  }
}
