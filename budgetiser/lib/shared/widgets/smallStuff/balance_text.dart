import 'package:budgetiser/shared/services/setting_currency.dart';
import 'package:flutter/material.dart';

class BalanceText extends StatefulWidget {
  const BalanceText(this.balance, {Key? key}) : super(key: key);

  final double balance;

  @override
  State<BalanceText> createState() => _BalanceTextState();
}

class _BalanceTextState extends State<BalanceText> {
  String currency = SettingsCurrencyHandler().defaultCurrency;

  @override
  void initState() {
    awaitFunction(); //call async function.
    super.initState();
  }

  awaitFunction() async {
    final awaitedCurrency = await SettingsCurrencyHandler().getCurrency();
    setState(() {
      currency = awaitedCurrency;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.balance >= 0) ...[
          Text(
            "+ ${widget.balance.toStringAsFixed(2)} $currency",
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: const Color.fromARGB(239, 29, 129, 37),
                ),
          ),
        ] else ...[
          Text(
            "- ${(0 - widget.balance).toStringAsFixed(2)} $currency",
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: const Color.fromARGB(255, 174, 74, 99),
                ),
          ),
        ]
      ],
    );
  }
}
