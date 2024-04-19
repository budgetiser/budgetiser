import 'package:flutter/material.dart';

class StatPreviewWidget extends StatelessWidget {
  const StatPreviewWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });
  final String text;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: InkWell(
        borderRadius: BorderRadius.circular(8), // TODO: from material design
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              icon,
              size: 70,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.titleLarge, // TODO: design
            ),
          ],
        ),
      ),
    );
  }
}
