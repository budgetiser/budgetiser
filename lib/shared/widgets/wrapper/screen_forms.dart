import 'package:flutter/material.dart';

class ScrollViewWithDeadSpace extends StatelessWidget {
  ScrollViewWithDeadSpace({
    super.key,
    required this.deadSpaceContent,
    required this.child,
    this.deadSpaceSize = 200,
  });
  final Widget deadSpaceContent;
  final double deadSpaceSize;
  final Widget child;

  final ScrollController listScrollController = ScrollController();

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
              height: deadSpaceSize,
              child: deadSpaceContent,
            ),
            // content of the screen
            child
          ],
        ),
      ),
    );
  }
}
