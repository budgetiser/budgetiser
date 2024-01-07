import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatefulWidget {
  const ColorPickerWidget({
    super.key,
    required this.initialSelectedColor,
    required this.onColorChangedCallback,
    this.noPadding = false,
  });

  final Color initialSelectedColor;
  final Function(Color) onColorChangedCallback;
  final bool noPadding;

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  ScrollController listScrollController = ScrollController();

  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text('Simple'),
    1: Text('Advanced')
  };

  @override
  void dispose() {
    listScrollController.dispose();
    super.dispose();
  }

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
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Pick a color!'),
                    content: SingleChildScrollView(
                      controller: listScrollController,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoSlidingSegmentedControl<int>(
                              groupValue: segmentedControlGroupValue,
                              children: myTabs,
                              onValueChanged: (i) {
                                setState(() {
                                  segmentedControlGroupValue = i!;
                                });
                              }),
                          if (segmentedControlGroupValue == 1)
                            ColorPicker(
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
                          if (segmentedControlGroupValue == 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: BlockPicker(
                                pickerColor: widget.initialSelectedColor,
                                onColorChanged: (Color newColor) {
                                  widget.onColorChangedCallback(newColor);
                                },
                              ),
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
