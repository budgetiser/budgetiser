import 'dart:math';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

Color randomColor() {
  return Color.fromRGBO(
    Random().nextInt(255),
    Random().nextInt(255),
    Random().nextInt(255),
    1,
  );
}

// TODO: change to theming or something (let this function change theme, so that is does not need to be recalculated every time)
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
