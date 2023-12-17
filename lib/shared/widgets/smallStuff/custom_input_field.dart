import 'package:flutter/material.dart';

/// Border with the (nearly) same style as an TextInputField border for custom children
class CustomInputField extends StatelessWidget {
  const CustomInputField({
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
    ThemeData themeData = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: themeData.inputDecorationTheme.labelStyle != null
                  ? themeData.inputDecorationTheme.labelStyle!
                      .copyWith(fontSize: 16)
                  : const TextStyle(fontSize: 16),
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          splashFactory: NoSplash.splashFactory,
          child: Container(
            width: double.maxFinite,
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.centerLeft,
            child: child,
          ),
        ),
      ],
    );
  }
}
