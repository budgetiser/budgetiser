import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:flutter/material.dart';

class CategoryTextWithIcon extends StatelessWidget {
  const CategoryTextWithIcon(
    this.category, {
    Key? key,
  }) : super(key: key);

  final TransactionCategory category;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        category.icon,
        color: category.color,
      ),
      Flexible(
        child: Text(" " + category.name, overflow: TextOverflow.ellipsis),
      ),
    ]);
  }
}
