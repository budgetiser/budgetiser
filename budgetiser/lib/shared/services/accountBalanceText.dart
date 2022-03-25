import 'package:flutter/material.dart';

class AccountBalanceText extends StatelessWidget {
  const AccountBalanceText(this.balance, {Key? key}) : super(key: key);

  final int balance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (balance > 0) ...[
          Text(
            "+ $balance €",
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: const Color.fromARGB(239, 29, 129, 37),
                ),
          ),
        ] else ...[
          Text(
            "- ${0 - balance} €",
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: const Color.fromARGB(238, 129, 29, 29),
                ),
          ),
        ]
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }
}
