import 'package:flutter/material.dart';

class AccountItemTitle extends StatelessWidget {
  const AccountItemTitle({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 30,
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline1?.merge(
                  const TextStyle(fontSize: 30),
                ),
          ),
        ),
      ],
    );
  }
}
