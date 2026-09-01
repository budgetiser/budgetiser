import 'package:budgetiser/core/database/models/category.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    required this.categoryData,
    super.key,
    this.onTap,
    this.showDescription = false,
  });
  final TransactionCategory categoryData;
  final ValueChanged<TransactionCategory>? onTap;
  final bool showDescription;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'category named: ${categoryData.name}',
      child: ListTile(
        leading: Icon(categoryData.icon),
        title: Text(categoryData.name),
        iconColor: categoryData.color,
        textColor: categoryData.color,
        subtitle: (showDescription &&
                (categoryData.description?.trim().isNotEmpty ?? false))
            ? Text(
                categoryData.description!.trim(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        enabled: categoryData.archived == false,
        contentPadding: const EdgeInsets.fromLTRB(8, 0, -8, 0),
        onTap: () => onTap?.call(categoryData),
      ),
    );
  }
}
