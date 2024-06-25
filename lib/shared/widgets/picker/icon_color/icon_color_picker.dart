import 'package:budgetiser/shared/widgets/picker/icon_color/dialog.dart';
import 'package:flutter/material.dart';

class IconColorPicker extends StatefulWidget {
  IconColorPicker({
    super.key,
    required this.selectedIcon,
    required this.selectedColor,
    required this.onSelection,
  });

  IconData selectedIcon;
  Color selectedColor;
  final Function(IconData selectedIcon, Color selectedColor) onSelection;

  @override
  State<IconColorPicker> createState() => _IconColorPickerState();
}

class _IconColorPickerState extends State<IconColorPicker> {
  @override
  Widget build(BuildContext context) {
    String tab = 'icon';

    return SizedBox(
      width: 40,
      height: 40,
      child: InkWell(
        onTap: () => {_showFullScreenDialog(context, widget.selectedIcon, widget.selectedColor)},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: widget.selectedColor,
          ),
        ),
      ),
    );
  }


  void _showFullScreenDialog(BuildContext context, IconData initialIcon, Color initialColor) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return IconColorDialog(currentIcon: initialIcon, currentColor: initialColor,);
        },
      ),
    );
  }
}