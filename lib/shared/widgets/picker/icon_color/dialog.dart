import 'package:budgetiser/shared/widgets/picker/icon_color/color_list.dart';
import 'package:budgetiser/shared/widgets/picker/icon_color/icon_list.dart';
import 'package:flutter/material.dart';

class IconColorDialog extends StatefulWidget {
  IconColorDialog(
      {super.key, required this.currentIcon, required this.currentColor});

  IconData currentIcon;
  Color currentColor;

  @override
  State<IconColorDialog> createState() => _IconColorDialogState();
}

class _IconColorDialogState extends State<IconColorDialog> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Choose Appearance'),
            actions: [TextButton(onPressed: () {}, child: const Text('Save'))],
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: TabBar(tabs: [
              Tab(
                icon: Icon(widget.currentIcon),
                text: 'Icon',
              ),
              Tab(
                icon: Icon(
                  Icons.color_lens_rounded,
                  color: widget.currentColor,
                ),
                text: 'Color',
              ),
            ]),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: TabBarView(children: [
              IconList(
                initialIcon: widget.currentIcon,
                onIconSelected: (IconData newIcon) {
                  setState(() {
                    widget.currentIcon = newIcon;
                  });
                },
              ),
              ColorList(
                initialColor: widget.currentColor,
                onColorSelected: (Color newColor) {
                  setState(() {
                    widget.currentColor = newColor;
                  });
                },
              ),
            ]),
          )),
    );
  }
}
