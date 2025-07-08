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
    final hct = Hct.fromInt(ColorEx(base).toInt32);
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

/*
* The following code is from the Flutter SDK as Color.value got deprecated without a successor
* https://github.com/flutter/flutter/issues/160184
*
* in the future, a toARGB32() function might be added
*/

/// This class is to supplement deprecated_member_use for value
/// value converted RGBA into a 32 bit integer, but the SDK doesn't provide
/// a successor?
extension ColorEx on Color {
  static int floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }

  /// A 32 bit value representing this color.
  ///
  /// The bits are assigned as follows:
  ///
  /// * Bits 24-31 are the alpha value.
  /// * Bits 16-23 are the red value.
  /// * Bits 8-15 are the green value.
  /// * Bits 0-7 are the blue value.
  int get toInt32 {
    return floatToInt8(a) << 24 |
        floatToInt8(r) << 16 |
        floatToInt8(g) << 8 |
        floatToInt8(b) << 0;
  }
}
