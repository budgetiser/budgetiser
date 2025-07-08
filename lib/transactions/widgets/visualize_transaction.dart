import 'package:budgetiser/accounts/screens/account_form.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/shared/widgets/arrow_icon.dart';
import 'package:budgetiser/shared/widgets/balance_text.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon.dart';
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
                  SelectableIcon(
                    widget.category!,
                    size: 48,
                  ),
                  const ArrowIcon(),
                  clickableAccountIcon(widget.account2!),
                ]
              : [
                  SelectableIcon(widget.category!, size: 48),
                  ArrowIcon(flipped: widget.wasNegative),
                  clickableAccountIcon(widget.account1!),
                ],
        ),
        if (widget.value != null && (widget.account2 == null))
          // text for single account transactions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BalanceText(
                widget.value!,
                hasPrefix: false,
              ),
              SizedBox(width: 60), // same width as ArrowIcon
              BalanceText(
                widget.account1!.balance + widget.value!,
              ),
            ],
          ),
        if (widget.value != null &&
            widget.account2 != null &&
            !widget.wasNegative)
          // text for double account transactions
          // text is not aligned with icons perfectly, because the text width is not known (columns needed)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BalanceText(
                widget.account1!.balance - widget.value!,
              ),
              SizedBox(width: 60), // same width as ArrowIcon
              BalanceText(
                widget.value!,
                hasPrefix: false,
              ),
              SizedBox(width: 60), // same width as ArrowIcon
              BalanceText(
                widget.account2!.balance + widget.value!,
              ),
            ],
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
      child: SelectableIcon(
        account,
        size: 48,
      ),
    );
  }
}
