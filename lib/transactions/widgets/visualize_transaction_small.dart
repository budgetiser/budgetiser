import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/shared/widgets/arrow_icon.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon.dart';
import 'package:flutter/material.dart';

class TransactionAccountVisualizationSmall extends StatelessWidget {
  /// small transaction visualization with arrow and icons for account/s
  const TransactionAccountVisualizationSmall({
    super.key,
    required this.transaction,
  });

  final SingleTransaction transaction;

  @override
  Widget build(BuildContext context) {
    if (transaction.account2 == null) {
      return SelectableIcon(transaction.account);
    } else {
      return Row(
        children: [
          SelectableIcon(transaction.account),
          const ArrowIcon(size: 20),
          SelectableIcon(transaction.account2!),
        ],
      );
    }
  }
}
