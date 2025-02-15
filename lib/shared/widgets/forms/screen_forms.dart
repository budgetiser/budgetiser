import 'package:flutter/material.dart';

class ScrollViewWithDeadSpace extends StatefulWidget {
  const ScrollViewWithDeadSpace({
    super.key,
    required this.children,
    this.deadSpaceContent,
    this.deadSpaceSize = 200,
  });
  final Widget? deadSpaceContent;
  final double deadSpaceSize;
  final List<Widget> children;

  @override
  State<ScrollViewWithDeadSpace> createState() =>
      _ScrollViewWithDeadSpaceState();
}

class _ScrollViewWithDeadSpaceState extends State<ScrollViewWithDeadSpace> {
  final ScrollController listScrollController = ScrollController();

  @override
  void dispose() {
    listScrollController.dispose();
    super.dispose();
  }

  @override
  SingleChildScrollView build(BuildContext context) {
    return SingleChildScrollView(
      controller: listScrollController,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        child: Column(
          children: [
            // dead space for visualization
            SizedBox(
              height: widget.deadSpaceSize,
              child: widget.deadSpaceContent,
            ),
            // content of the screen
            ...widget.children,
          ],
        ),
      ),
    );
  }
}
