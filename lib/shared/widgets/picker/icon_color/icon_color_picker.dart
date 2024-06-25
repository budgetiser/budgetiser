import 'package:budgetiser/shared/widgets/picker/icon_color/dialog.dart';
import 'package:flutter/material.dart';

class IconColorPicker extends StatefulWidget {
  const IconColorPicker({
    super.key,
    required this.selectedIcon,
    required this.selectedColor,
    required this.onSelection,
  });

  final IconData selectedIcon;
  final Color selectedColor;
  final Function(IconData selectedIcon, Color selectedColor) onSelection;

  @override
  State<IconColorPicker> createState() => _IconColorPickerState();
}

class _IconColorPickerState extends State<IconColorPicker> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        _showFullScreenDialog(
          context,
          widget.selectedIcon,
          widget.selectedColor,
        )
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: widget.selectedColor,
            width: 2,
          ),
        ),
        child: Icon(
          widget.selectedIcon,
          color: widget.selectedColor,
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
