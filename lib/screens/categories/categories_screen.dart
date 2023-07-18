import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/categories/category_form.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/widgets/items/category_item.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  static String routeID = 'categories';

  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseHelper.instance.pushGetAllCategoriesStream();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          // style: Theme.of(context).textTheme.caption,
        ),
      ),
      drawer: const CreateDrawer(),
      body: StreamBuilder<List<TransactionCategory>>(
        stream: DatabaseHelper.instance.allCategoryStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TransactionCategory> categoryList = snapshot.data!.toList();
            // ignore: cascade_invocations
            categoryList.sort((a, b) => a.name.compareTo(b.name));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: categoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      CategoryItem(
                        categoryData: categoryList[index],
                      ),
                      const Divider(
                        indent: 8,
                        endIndent: 8,
                      )
                    ],
                  );
                },
                padding: const EdgeInsets.only(bottom: 80),
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('Oops!');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CategoryForm()));
        },
        tooltip: 'New category',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
