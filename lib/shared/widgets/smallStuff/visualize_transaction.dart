import 'package:budgetiser/screens/account/account_form.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/widgets/smallStuff/arrow_icon.dart';
import 'package:budgetiser/shared/widgets/smallStuff/balance_text.dart';
import 'package:flutter/material.dart';

class VisualizeTransaction extends StatefulWidget {
  const VisualizeTransaction({
    super.key,
    required this.account1,
    required this.account2,
    required this.category,
    required this.wasNegative,
    required this.value,
  });

  final Account? account1;
  final Account? account2;
  final TransactionCategory? category;
  final bool wasNegative;
  final double? value;

  @override
  State<VisualizeTransaction> createState() => _VisualizeTransactionState();
}

class _VisualizeTransactionState extends State<VisualizeTransaction> {
  @override
  Widget build(BuildContext context) {
    if (widget.account1 == null || widget.category == null) {
      return Container();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: (widget.account2 != null)
              ? [
                  clickableAccountIcon(widget.account1!),
                  const ArrowIcon(),
                  Icon(
                    widget.category!.icon,
                    color: widget.category!.color,
                    size: 40,
                  ),
                  const ArrowIcon(),
                  clickableAccountIcon(widget.account2!),
                ]
              : [
                  widget.category!.getSelectableIconWidget(size: 40),
                  ArrowIcon(flipped: widget.wasNegative),
                  clickableAccountIcon(widget.account1!),
                ],
        ),
        if (widget.value != null &&
            (widget.account2 == null || !widget.wasNegative))
          BalanceText(
            widget.value!,
            hasPrefix: false,
          ),
      ],
    );
  }

  InkWell clickableAccountIcon(Account account) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      splashColor: Colors.white10,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => AccountForm(
              initialAccount: account,
            ),
          ),
        );
      },
      child: Icon(
        account.icon,
        color: account.color,
        size: 40,
      ),
    );
  }
}
