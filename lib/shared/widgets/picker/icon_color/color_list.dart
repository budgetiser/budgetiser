import 'package:budgetiser/shared/utils/color_utils.dart';
import 'package:flutter/material.dart';

class ColorList extends StatefulWidget {
  const ColorList({
    super.key,
    required this.initialColor,
    required this.onColorSelected,
  });

  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  @override
  State<ColorList> createState() => _ColorListState();
}

class _ColorListState extends State<ColorList>
    with AutomaticKeepAliveClientMixin {
  // Required for keeping scroll position when used in Tabs
  @override
  bool get wantKeepAlive => true;

  late Color currentColor;

  @override
  void initState() {
    super.initState();

    currentColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final List<List<Color>> colors2d = createThemeMatchingColors(context);
    final List<Color> colors = colors2d.expand((i) => i).toList();

    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // number of items in each row
        mainAxisSpacing: 16.0, // spacing between rows
        crossAxisSpacing: 8.0, // spacing between columns
      ),
      itemCount: colors.length,
      itemBuilder: (context, itemIndex) {
        return ColorItem(
          color: colors[itemIndex],
          selected: colors[itemIndex] == currentColor,
          onSelection: (Color selectedColor) {
            setState(() {
              currentColor = selectedColor;
              widget.onColorSelected(selectedColor);
            });
          },
        );
      },
    );
  }
}

class ColorItem extends StatelessWidget {
  const ColorItem({
    super.key,
    required this.color,
    this.selected = false,
    required this.onSelection,
  });

  final Color color;
  final bool selected;

  final ValueChanged<Color> onSelection;

  BoxDecoration? get foregroundDecoration {
    if (selected) {
      return BoxDecoration(
        border: Border.all(color: Colors.grey, width: 5),
        borderRadius: BorderRadius.circular(40),
        // TODO: checkbox on selected icon
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      child: Container(
        foregroundDecoration: foregroundDecoration,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: color,
        ),
      ),
      onTap: () {
        onSelection(color);
      },
    );
  }
}
