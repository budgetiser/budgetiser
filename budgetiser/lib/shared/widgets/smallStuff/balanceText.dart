import 'package:flutter/material.dart';

class BalanceText extends StatelessWidget {
  const BalanceText(this.balance, {Key? key}) : super(key: key);

  final double balance;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (balance >= 0) ...[
          Text(
            "+ ${balance.toStringAsFixed(2)} €",
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: const Color.fromARGB(239, 29, 129, 37),
                ),
          ),
        ] else ...[
          Text(
            "- ${(0 - balance).toStringAsFixed(2)} €",
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: const Color.fromARGB(255, 174, 74, 99),
                ),
          ),
        ]
      ],
    );
  }
}
