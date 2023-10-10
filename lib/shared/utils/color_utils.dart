import 'dart:math';

import 'package:flutter/material.dart';

Color randomColor() {
  return Color.fromRGBO(
    Random().nextInt(255),
    Random().nextInt(255),
    Random().nextInt(255),
    1,
  );
}
