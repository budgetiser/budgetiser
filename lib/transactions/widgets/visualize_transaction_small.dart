import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/shared/widgets/arrow_icon.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon.dart';
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
          SelectableIcon(transaction.category),
          ArrowIcon(size: 32, flipped: transaction.value < 0),
          SelectableIcon(transaction.account),
        ],
      );
    } else {
      return Row(
        children: [
          SelectableIcon(transaction.account),
          const ArrowIcon(size: 32),
          SelectableIcon(transaction.category),
          const ArrowIcon(size: 32),
          SelectableIcon(transaction.account2!),
        ],
      );
    }
  }
}
