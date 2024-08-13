import 'package:budgetiser/shared/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.format_paint_rounded),
          onPressed: _customColorDialog,
          label: const Text('Custom'),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: GridView.builder(
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
                onSelection: _onNewColorSelected,
              );
            },
          ),
        ),
      ],
    );
  }

  void _onNewColorSelected(Color selectedColor) {
    setState(() {
      currentColor = selectedColor;
      widget.onColorSelected(selectedColor);
    });
  }

  void _customColorDialog() {
    ScrollController listScrollController = ScrollController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                controller: listScrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ColorPicker(
                      pickerColor: currentColor,
                      hexInputBar: true,
                      labelTypes: const [],
                      paletteType: PaletteType.hueWheel,
                      enableAlpha: false,
                      pickerAreaHeightPercent: 1,
                      onColorChanged: _onNewColorSelected,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FloatingActionButton.extended(
                  heroTag: 'close',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: const Text('Close'),
                  icon: const Icon(Icons.cancel),
                ),
              ],
            );
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

  @override
  Widget build(BuildContext context) {
    return Material(
      // Material wrapper as fix for:
      // https://github.com/flutter/flutter/issues/73315#issuecomment-1712743656 -> Fix for 'Ink()' displaying outside of GridView
      child: InkWell(
        customBorder: const CircleBorder(),
        child: Container(
          foregroundDecoration: selected
              ? BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).indicatorColor, width: 5),
                  shape: BoxShape.circle,
                  // TODO: checkbox on selected icon
                )
              : null,
          child: Ink(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
        onTap: () {
          onSelection(color);
        },
      ),
    );
  }
}
