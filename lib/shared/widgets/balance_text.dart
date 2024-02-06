import 'package:budgetiser/settings/services/setting_currency.dart';
import 'package:flutter/material.dart';

class BalanceText extends StatefulWidget {
  /// Widget to display a currency number with the correct currency symbol.
  /// Number is colored based on the [value]
  const BalanceText(
    this.value, {
    this.hasPrefix = true,
    this.isColored = true,
    super.key,
  });

  final double value;
  final bool hasPrefix;
  final bool isColored;

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

  void awaitFunction() async {
    final awaitedCurrency = await SettingsCurrencyHandler().getCurrency();
    setState(() {
      currency = awaitedCurrency;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyMedium!;
    String prefix = '';
    if (widget.value >= 0) {
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
      '$prefix${widget.value.abs().toStringAsFixed(2)} $currency',
      style: textStyle,
    );
  }
}
