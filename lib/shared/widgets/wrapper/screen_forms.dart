import 'package:flutter/material.dart';

class ScrollViewWithDeadSpace extends StatefulWidget {
  const ScrollViewWithDeadSpace({
    super.key,
    required this.deadSpaceContent,
    this.deadSpaceSize = 200,
    required this.child,
  });
  final Widget deadSpaceContent;
  final double deadSpaceSize;
  final Widget child;

  @override
  State<ScrollViewWithDeadSpace> createState() =>
      _ScrollViewWithDeadSpaceState();
}

class _ScrollViewWithDeadSpaceState extends State<ScrollViewWithDeadSpace> {
  ScrollController listScrollController = ScrollController();

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
            widget.child
          ],
        ),
      ),
    );
  }
}
