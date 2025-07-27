import 'package:budgetiser/categories/picker/category_picker.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:flutter/material.dart';

class CategoriesOverview extends StatelessWidget {
  const CategoriesOverview({
    super.key,
    this.initialCategories,
    this.onCategoryRemoved,
    this.onCategoriesChanged,
  });

  final List<TransactionCategory>? initialCategories;
  final ValueChanged<TransactionCategory>? onCategoryRemoved;
  final ValueChanged<List<TransactionCategory>>? onCategoriesChanged;

  @override
  Widget build(BuildContext context) {
    final List<TransactionCategory> selectedCategories =
        initialCategories ?? [];
    return Wrap(
      spacing: 8,
      children: [
        for (TransactionCategory category in selectedCategories)
          Chip(
            avatar: Icon(
              category.icon,
              color: category.color,
            ),
            label: Text(
              category.name,
              style: TextStyle(color: category.color),
            ),
            deleteIcon: const Icon(Icons.close),
            onDeleted: () => onCategoryRemoved?.call(category),
          ),
        InkWell(
          child: const Chip(
            avatar: Icon(Icons.difference),
            label: Text('Change categories'),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CategoryPicker.multi(
                  onCategoryPickedCallbackMulti: (selection) =>
                      onCategoriesChanged?.call(selection),
                  initialValues: selectedCategories,
                );
              },
            );
          },
        ),
      ],
    );
  }
}