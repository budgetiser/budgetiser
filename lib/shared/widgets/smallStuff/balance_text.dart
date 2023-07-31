import 'package:budgetiser/shared/services/setting_currency.dart';
import 'package:flutter/material.dart';

class BalanceText extends StatefulWidget {
  const BalanceText(
    this.balance, {
    this.hasPrefix = true,
    this.isColored = true,
    Key? key,
  }) : super(key: key);

  final double balance;
  final bool hasPrefix;
  final bool isColored;

  @override
  State<BalanceText> createState() => _BalanceTextState();
}

class _BalanceTextState extends State<BalanceText> {
  String currency = SettingsCurrencyHandler().defaultCurrency;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyMedium!;
    String prefix = '';
    if (widget.balance >= 0) {
      if (widget.isColored) {
        textStyle = textStyle.copyWith(
          color: Colors.green,
        );
      }
      if (widget.hasPrefix) {
        prefix = '+ ';
      }
    } else {
      if (widget.isColored) {
        textStyle = textStyle.copyWith(
          color: Colors.red,
        );
      }
      if (widget.hasPrefix) {
        prefix = '- ';
      }
    }
    return Text(
      '$prefix${widget.balance.abs().toStringAsFixed(2)} $currency',
      style: textStyle,
    );
  }
}
