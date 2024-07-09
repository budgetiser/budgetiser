import 'package:budgetiser/categories/screens/category_form.dart';
import 'package:budgetiser/categories/widgets/category_item.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/core/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  static String routeID = 'categories';

  @override
  Widget build(BuildContext context) {
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
                return const Center(
                  child: Text('No Categories'),
                );
              }
              if (snapshot.hasError) {
                return const Text('Oops!');
              }
              return _screenContent(snapshot);
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
}

Widget _screenContent(AsyncSnapshot<List<TransactionCategory>> snapshot) {
  List<TransactionCategory> categoryList = snapshot.data!
    ..sort((a, b) => a.name.compareTo(b.name));

  List<TransactionCategory> onlyTopLevelCategoryList = categoryList
      .where(
        (element) => element.parentID == null,
      )
      .toList();

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 400,
          child: _CategoryList(categories: categoryList),
        ),
        const SizedBox(
          height: 8,
          width: 8,
        ),
        const Text('top level:'),
        SizedBox(
          height: 400,
          child: _CategoryList(categories: onlyTopLevelCategoryList),
        ),
      ],
    ),
  );
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.categories});
  final List<TransactionCategory> categories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        return CategoryItem(
          categoryData: categories[index],
        );
      },
    );
  }
}
