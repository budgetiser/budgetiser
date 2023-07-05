import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatefulWidget {
  const ColorPickerWidget({
    Key? key,
    required this.initialSelectedColor,
    required this.onColorChangedCallback,
    this.noPadding = false,
  }) : super(key: key);

  final Color initialSelectedColor;
  final Function(Color) onColorChangedCallback;
  final bool noPadding;

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.noPadding
          ? const EdgeInsets.all(0)
          : const EdgeInsets.only(top: 16, bottom: 20),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Pick a color!'),
                content: SingleChildScrollView(
                  controller: listScrollController,
                  child: ColorPicker(
                    pickerColor: widget.initialSelectedColor,
                    hexInputBar: true,
                    labelTypes: const [],
                    paletteType: PaletteType.hueWheel,
                    enableAlpha: false,
                    pickerAreaHeightPercent: 1,
                    onColorChanged: (Color newColor) {
                      widget.onColorChangedCallback(newColor);
                    },
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: widget.initialSelectedColor,
          ),
        ),
      ),
    );
  }
}
