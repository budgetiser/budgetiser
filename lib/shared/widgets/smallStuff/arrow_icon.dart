import 'dart:math';

import 'package:flutter/material.dart';

/// white arrow icon
///
/// if [flipped] is set the arrow points to the left
class ArrowIcon extends StatelessWidget {
  const ArrowIcon({
    super.key,
    this.flipped = false,
    this.size = 60,
  });

  final bool flipped;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (flipped) {
      return Transform.rotate(
        angle: pi, // rotate by pi to flip the arrow
        child: Icon(
          Icons.arrow_right_alt,
          size: size,
        ),
      );
    } else {
      return Icon(Icons.arrow_right_alt, size: size);
    }
  }
}
