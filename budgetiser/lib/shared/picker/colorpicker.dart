import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Colorpicker extends StatefulWidget {
  Colorpicker({
    Key? key,
    this.initialSelectedColor,
    required this.onColorChangedCallback,
  }) : super(key: key);

  Color? initialSelectedColor;
  Function(Color) onColorChangedCallback;

  @override
  State<Colorpicker> createState() => _ColorpickerState();
}

class _ColorpickerState extends State<Colorpicker> {
  Color color = Color.fromRGBO(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);

  @override
  Widget build(BuildContext context) {
    if (widget.initialSelectedColor != null) {
      color = widget.initialSelectedColor!;
    }

    Future(_executeAfterBuild);
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Pick a color!'),
                content: SingleChildScrollView(
                  child: MaterialPicker(
                    pickerColor: color,
                    onColorChanged: (Color newColor) {
                      widget.onColorChangedCallback(newColor);
                      setState(() {
                        color = newColor;
                      });
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
          color: color,
        ),
      ),
    );
  }

  /// executes after build is done by being called in a Future() from the build() method
  Future<void> _executeAfterBuild() async {
    widget.onColorChangedCallback(color);
  }
}
