import 'package:budgetiser/shared/widgets/picker/icon_color/color_list.dart';
import 'package:budgetiser/shared/widgets/picker/icon_color/icon_list.dart';
import 'package:flutter/material.dart';

class IconColorDialog extends StatefulWidget {
  const IconColorDialog({
    super.key,
    required this.initialIcon,
    required this.initialColor,
    required this.onSelection,
  });

  final IconData initialIcon;
  final Color initialColor;
  final Function(IconData selectedIcon, Color selectedColor) onSelection;

  @override
  State<IconColorDialog> createState() => _IconColorDialogState();
}

class _IconColorDialogState extends State<IconColorDialog> {
  late IconData currentIcon;
  late Color currentColor;

  @override
  void initState() {
    super.initState();

    currentIcon = widget.initialIcon;
    currentColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Choose Appearance'),
          actions: [
            TextButton(
              onPressed: () {
                widget.onSelection(currentIcon, currentColor);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: TabBar(tabs: [
            Tab(
              icon: Icon(
                currentIcon,
                color: currentColor,
              ),
              text: 'Icon',
            ),
            Tab(
              icon: Icon(
                Icons.color_lens_rounded,
                color: currentColor,
              ),
              text: 'Color',
            ),
          ]),
        ),
        body: _tabContents(),
      ),
    );
  }

  Widget _tabContents() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TabBarView(
        children: [
          IconList(
            initialIcon: currentIcon,
            onIconSelected: (IconData newIcon) {
              setState(() {
                currentIcon = newIcon;
              });
            },
          ),
          ColorList(
            initialColor: currentColor,
            onColorSelected: (Color newColor) {
              setState(() {
                currentColor = newColor;
              });
            },
          ),
        ],
      ),
    );
  }
}
