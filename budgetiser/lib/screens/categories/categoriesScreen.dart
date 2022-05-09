import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/categories/categoryForm.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/widgets/categoryItem.dart';
import 'package:flutter/material.dart';
import 'package:budgetiser/drawer.dart';

class CategoriesScreen extends StatelessWidget {
  static String routeID = 'categories';

  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseHelper.instance.pushGetAllCategoriesStream();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Categories",
          // style: Theme.of(context).textTheme.caption,
        ),
      ),
      drawer: createDrawer(context),
      body: StreamBuilder<List<TransactionCategory>>(
        stream: DatabaseHelper.instance.allCategoryStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TransactionCategory> _categories = snapshot.data!.toList();
            _categories.sort((a, b) => a.name.compareTo(b.name));
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _categories.length,
              itemBuilder: (BuildContext context, int index) {
                return CategoryItem(
                  categoryData: _categories[index],
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Text("Oops!");
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CategoryForm()));
        },
        tooltip: 'New category',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
