import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    Key? key,
    required this.initialSelectedColor,
    required this.onColorChangedCallback,
    this.noPadding = false,
  }) : super(key: key);

  final Color initialSelectedColor;
  final Function(Color) onColorChangedCallback;
  final bool noPadding;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
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
                  child: MaterialPicker(
                    pickerColor: widget.initialSelectedColor,
                    onColorChanged: (Color newColor) {
                      widget.onColorChangedCallback(newColor);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop(); //dismiss the color picker
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
