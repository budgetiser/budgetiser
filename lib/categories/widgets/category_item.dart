import 'package:budgetiser/core/database/models/category.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    required this.categoryData,
    super.key,
    this.onTap,
  });
  final TransactionCategory categoryData;
  final ValueChanged<TransactionCategory>? onTap;

  @override
  Widget build(BuildContext context) {
    if (categoryData.archived) {
      return Container(); // TODO: archived not yet implemented #143
    }
    return Semantics(
      label: 'category named: ${categoryData.name}',
      child: ListTile(
        leading: Icon(categoryData.icon),
        title: Text(categoryData.name),
        iconColor: categoryData.color,
        textColor: categoryData.color,
        contentPadding: const EdgeInsets.fromLTRB(8, 0, -8, 0),
        onTap: () => onTap?.call(categoryData),
      ),
    );
  }
}
