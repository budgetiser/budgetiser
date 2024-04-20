import 'package:budgetiser/categories/screens/category_form.dart';
import 'package:budgetiser/categories/widgets/category_item.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/core/drawer.dart';
import 'package:budgetiser/shared/widgets/list_views/item_list_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  static String routeID = 'categories';

  @override
  Widget build(BuildContext context) {
    // return buildA(context);
    return buildB(context);
  }
}

@override
Widget buildB(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Categories'),
    ),
    drawer: const CreateDrawer(),
    body: Consumer<CategoryModel>(
      builder: (context, model, child) {
        return FutureBuilder<List<TransactionCategory>>(
          future: model.getAllCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.isEmpty) {
              return _NoCategories();
            }
            if (snapshot.hasError) {
              return const Text('Oops!');
            }

            List<TransactionCategory> categoryList = snapshot.data!
              ..sort((a, b) => a.name.compareTo(b.name));
            return _CategoryList(categories: categoryList);
          },
        );
      },
    ),
    floatingActionButton: FloatingActionButton.extended(
      icon: const Icon(Icons.add_rounded),
      label: const Text('Add category'),
      tooltip: 'Create a new category',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CategoryForm(),
          ),
        );
      },
    ),
  );
}

class _NoCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No Categories'),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.categories});
  final List<TransactionCategory> categories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // padding: const EdgeInsets.only(bottom: 80),
      // separatorBuilder: (context, index) => const ItemListDivider(),
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        return CategoryItem(
          categoryData: categories[index],
        );
      },
    );
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 8),
    //   child:
    // );
  }
}

Widget buildA(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Categories',
      ),
    ),
    drawer: const CreateDrawer(),
    body: Consumer<CategoryModel>(
      builder: (context, model, child) {
        return FutureBuilder<List<TransactionCategory>>(
          future: model.getAllCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No Categories'),
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
    floatingActionButton: FloatingActionButton.large(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CategoryForm(),
          ),
        );
      },
      tooltip: 'New category',
      child: const Icon(Icons.add_rounded),
    ),
  );
}
