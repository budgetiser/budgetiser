import 'package:budgetiser/categories/screens/category_form.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon_with_text.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    required this.categoryData,
    super.key,
  });
  final TransactionCategory categoryData;

  @override
  Widget build(BuildContext context) {
    if (categoryData.archived) {
      return Container(); // TODO: archived not yet implemented #143
    }
    return ListTile(
        leading: Icon(categoryData.icon),
        title: Text(categoryData.name),
        iconColor: categoryData.color,
        textColor: categoryData.color,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CategoryForm(
                categoryData: categoryData,
              ),
            ),
          );
        });
  }
}
