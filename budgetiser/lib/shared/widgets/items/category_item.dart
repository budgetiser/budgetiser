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
      return Container(
        height: 0,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              //color: Colors.red,
            ),
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CategoryForm(
                              categoryData: categoryData,
                            )));
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    categoryData.icon,
                                    color: categoryData.color,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                    child: Text(
                                      categoryData.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: categoryData.color,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
        const Divider(
          indent: 15,
          endIndent: 15,
        )
      ],
    );
  }
}
