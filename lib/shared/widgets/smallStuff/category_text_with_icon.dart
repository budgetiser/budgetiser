import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:flutter/material.dart';

class CategoryTextWithIcon extends StatelessWidget {
  const CategoryTextWithIcon(
    this.category, {
    super.key,
  });

  final TransactionCategory category;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          category.icon,
          color: category.color,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            category.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
