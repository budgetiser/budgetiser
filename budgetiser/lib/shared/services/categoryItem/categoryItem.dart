import 'package:budgetiser/screens/categories/shared/editCategory.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final bool hidden;

  const CategoryItem(
    this.id,
    this.name,
    this.icon,
    this.color,
    this.hidden, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hidden) {
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditCategory(categoryTitle: name, selectedColor: color,)));
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
                                    icon,
                                    color: color,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                    child: Text(
                                      name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.copyWith(
                                            color: color,
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
