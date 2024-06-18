import 'package:flutter/material.dart';

class CustomInputFieldBorder extends StatelessWidget {
  /// Border with the (nearly) same style as an TextInputField border for custom children
  const CustomInputFieldBorder({
    required this.child,
    required this.title,
    this.onTap,
    super.key,
  });
  final Widget child;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: InkWell(
            onTap: onTap,
            splashFactory: NoSplash.splashFactory,
            child: Container(
              width: double.maxFinite,
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.centerLeft,
              child: child,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                title,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
