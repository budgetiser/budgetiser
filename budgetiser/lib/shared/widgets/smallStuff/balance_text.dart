import 'package:budgetiser/shared/services/setting_currency.dart';
import 'package:flutter/material.dart';

class BalanceText extends StatefulWidget {
  BalanceText(
    this.balance, {
    this.hasPrefix = true,
    Key? key,
  }) : super(key: key);

  final double balance;
  bool hasPrefix;

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
    TextStyle textStyle = Theme.of(context).textTheme.bodyText2!;
    String prefix = "";
    if (widget.balance >= 0) {
      textStyle = textStyle.copyWith(
        color: const Color.fromARGB(239, 29, 129, 37),
      );
      if (widget.hasPrefix) {
        prefix = "+ ";
      }
    } else {
      textStyle = textStyle.copyWith(
        color: const Color.fromARGB(255, 174, 74, 99),
      );
      if (widget.hasPrefix) {
        prefix = "- ";
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "${prefix}${widget.balance.abs().toStringAsFixed(2)} $currency",
          style: textStyle,
        ),
      ],
    );
  }
}
