import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearProgressBar extends StatelessWidget {
  const LinearProgressBar({
    super.key,
    required this.percent,
    required this.color,
  });

  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LinearPercentIndicator(
            lineHeight: 16.0,
            percent: normalizePercent(percent),
            backgroundColor: Colors.white,
            linearGradient: LinearGradient(colors: createGradient(color)),
            clipLinearGradient: true,
          ),
        ),
      ],
    );
  }

  List<Color> createGradient(Color baseColor) {
    List<Color> gradient = [];
    for (double opacity = 0.4; opacity <= 1.0; opacity += 0.1) {
      gradient.add(Color.fromRGBO(
          baseColor.red, baseColor.green, baseColor.blue, opacity));
    }
    return gradient;
  }

  double normalizePercent(double value) {
    if (value >= 1) {
      return 1.00;
    } else if (value <= 0) {
      return 0.00;
    } else {
      return value;
    }
  }
}
