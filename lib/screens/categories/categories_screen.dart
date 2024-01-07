import 'package:budgetiser/db/category_provider.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/categories/category_form.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/widgets/itemLists/item_list_divider.dart';
import 'package:budgetiser/shared/widgets/items/category_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  static String routeID = 'categories';

  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
        ),
      ),
      drawer: const CreateDrawer(),
      body: Consumer<CategoryModel>(
        builder: (context, value, child) {
          return FutureBuilder<List<TransactionCategory>>(
            future: CategoryModel().getAllCategories(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Text('Oops!');
              }
              List<TransactionCategory> categoryList = snapshot.data!
                ..sort((a, b) => a.name.compareTo(b.name));
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  separatorBuilder: (context, index) => const ItemListDivider(),
                  itemCount: categoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CategoryItem(
                      categoryData: categoryList[index],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CategoryForm(),
            ),
          );
        },
        tooltip: 'New category',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
