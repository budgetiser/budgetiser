import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/shared/widgets/arrow_icon.dart';
import 'package:flutter/material.dart';

/// small transaction visualization with arrow and icons for category and account/s
class TransactionVisualization extends StatelessWidget {
  const TransactionVisualization({
    super.key,
    required this.transaction,
  });

  final SingleTransaction transaction;

  @override
  Widget build(BuildContext context) {
    if (transaction.account2 == null) {
      return Row(
        children: [
          transaction.category.getSelectableIconWidget(),
          ArrowIcon(size: 32, flipped: transaction.value < 0),
          transaction.account.getSelectableIconWidget(),
        ],
      );
    } else {
      return Row(
        children: [
          transaction.account.getSelectableIconWidget(),
          const ArrowIcon(size: 32),
          transaction.category.getSelectableIconWidget(),
          const ArrowIcon(size: 32),
          transaction.account2!.getSelectableIconWidget(),
        ],
      );
    }
  }
}
