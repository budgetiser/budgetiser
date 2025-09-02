import 'package:flutter/material.dart';

class MultiStepHeader extends StatelessWidget {
  const MultiStepHeader({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MultiStepElement extends StatelessWidget {
  const MultiStepElement(this.header, {super.key});

  final MultiStepHeader header;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
