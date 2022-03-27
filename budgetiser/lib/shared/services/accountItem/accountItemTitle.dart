import 'package:flutter/material.dart';

class AccountItemTitle extends StatelessWidget {
  const AccountItemTitle(this.title, this.icon, {Key? key}) : super(key: key);

  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 30,
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
