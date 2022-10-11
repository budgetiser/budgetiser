import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Colorpicker extends StatefulWidget {
  const Colorpicker({
    Key? key,
    required this.initialSelectedColor,
    required this.onColorChangedCallback,
  }) : super(key: key);

  final Color initialSelectedColor;
  final Function(Color) onColorChangedCallback;

  @override
  State<Colorpicker> createState() => _ColorpickerState();
}

class _ColorpickerState extends State<Colorpicker> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
            });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 30,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: widget.initialSelectedColor,
        ),
      ),
    );
  }
}
