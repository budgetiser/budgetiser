import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../services/notification/colorPicker.dart';

class Colorpicker extends StatefulWidget {
  const Colorpicker({
    Key? key,
  }) : super(key: key);

  @override
  State<Colorpicker> createState() => _ColorpickerState();
}

class _ColorpickerState extends State<Colorpicker> {
  Color selectedColor = Colors.blueAccent;
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
                    pickerColor: selectedColor, //default color
                    onColorChanged: (Color color) {
                      sendToParent(color);
                      setState(() {
                        selectedColor = color;
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
          color: selectedColor,
        ),
      ),
    );
  }

  void sendToParent(Color col) {
    ColorPicked(col).dispatch(context);
  }
}
