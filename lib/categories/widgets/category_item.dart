import 'package:budgetiser/categories/screens/category_form.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon_with_text.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final TransactionCategory categoryData;

  const CategoryItem({
    required this.categoryData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryData.archived) {
      return Container(); // TODO: archived not yet implemented #143
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoryForm(
              categoryData: categoryData,
            ),
          ),
        );
      },
      borderRadius: const BorderRadius.all(
        Radius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SelectableIconWithText(categoryData),
      ),
    );
  }
}
