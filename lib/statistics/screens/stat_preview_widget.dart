import 'package:flutter/material.dart';

class StatPreviewWidget extends StatelessWidget {
  const StatPreviewWidget({
    super.key,
    required this.child,
    required this.text,
    required this.onTap,
  });
  final String text;
  final Widget child;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: Theme.of(context).hoverColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            child,
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
