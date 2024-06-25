import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class ColorList extends StatefulWidget {
  ColorList({
    super.key,
    this.initialColor,
    required this.onColorSelected,
  });

  Color? initialColor;
  final ValueChanged<Color> onColorSelected;

  @override
  State<ColorList> createState() => _ColorListState();
}

class _ColorListState extends State<ColorList>
    with AutomaticKeepAliveClientMixin {
  // Required for keeping scroll position when used in Tabs
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final List<List<Color>> colors = createThemeMatchingColors(context);
    final int crossAxisCount = colors[0].length;
    final int mainAxisCount = colors.length;
    final int itemCount = mainAxisCount * crossAxisCount;

    return GridView.builder(
        shrinkWrap: true,
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, // number of items in each row
          mainAxisSpacing: 16.0, // spacing between rows
          crossAxisSpacing: 8.0, // spacing between columns
        ),
        itemCount: mainAxisCount,
        itemBuilder: (context, itemIndex) {
          int mainAxisIndex = (itemIndex % itemCount);
          int crossAxisIndex = (itemIndex / itemCount).floor();
          return ColorItem(
            color: colors[mainAxisIndex][crossAxisIndex],
            selected:
                colors[mainAxisIndex][crossAxisIndex] == widget.initialColor,
            onSelection: (Color selectedColor) {
              setState(() {
                widget.initialColor = selectedColor;
                widget.onColorSelected(selectedColor);
              });
            },
          );
        });
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
        border: Border.all(color: Colors.grey, width: 4),
        borderRadius: BorderRadius.circular(40),
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

List<List<Color>> createThemeMatchingColors(
  BuildContext context, {
  bool harmonized = true,
}) {
  final List<Color> baseColors = [
    Colors.pink,
    Colors.red,
    Colors.deepOrange,
    Colors.orange,
    Colors.amber,
    Colors.yellow,
    Colors.lime,
    Colors.lightGreen,
    Colors.green,
    Colors.teal,
    Colors.cyan,
    Colors.lightBlue,
    Colors.blue,
    Colors.indigo,
    Colors.deepPurple,
    Colors.purple,
    Colors.brown,
  ];
  List<List<Color>> resultColors = [];

  for (var base in baseColors) {
    List<Color> variants = [];
    base = base.harmonizeWith(Theme.of(context).colorScheme.primary);
    final hct = Hct.fromInt(base.value);
    TonalPalette palette = TonalPalette.of(hct.hue, hct.chroma);
    variants
      ..add(base)
      ..add(Color(palette.get(65)))
      ..add(Color(palette.get(75)))
      ..add(Color(palette.get(85)));

    resultColors.add(variants);
  }

  return resultColors;
}
