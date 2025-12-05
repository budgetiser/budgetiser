import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: 'empty screen', group: 'shared')
Widget previewEmptyScreen() {
  return const EmptyScreen(onPressed: SizedBox(), type: 'Account');
}

class EmptyScreen extends StatelessWidget {
  /// Widget to display when there is no data available.
  /// This widget shows a centered message and a button to create a new [type].
  ///
  /// The [onPressed] parameter is the widget to navigate to when the button is pressed.
  /// The [type] parameter is used to specify the type of content or data represented by the screen.
  const EmptyScreen({super.key, required this.onPressed, required this.type});

  /// The widget to navigate to when the button is pressed.
  final Widget onPressed;

  /// The type of content or data represented by the screen.
  final String type;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo_white.png',
            width: 120,
            color: Theme.of(context).disabledColor,
          ),
          Text(
            'No $type!',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Theme.of(context).disabledColor),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => onPressed,
                ),
              );
            },
            label: Text('Create $type'),
            heroTag: 'create-$type-empty',
            icon: Icon(
              Icons.add,
              semanticLabel: 'create $type',
            ),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
