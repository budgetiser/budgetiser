import 'package:budgetiser/screens/categories/category_form.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final TransactionCategory categoryData;

  const CategoryItem({
    required this.categoryData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoryData.isHidden) {
      return Container(); // isHidden not yet used
    }
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CategoryForm(
                categoryData: categoryData,
              ),
            ),
          );
        },
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  categoryData.icon,
                  color: categoryData.color,
                ),
                const SizedBox(width: 8),
                Text(
                  categoryData.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: categoryData.color,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
