import 'package:budgetiser/categories/screens/category_form.dart';
import 'package:budgetiser/categories/widgets/category_tree.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/core/drawer.dart';
import 'package:budgetiser/shared/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  static String routeID = 'categories';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      drawer: const CreateDrawer(),
      body: _screenContent(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create a new category',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CategoryForm(),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Padding _screenContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              hintText: 'Search',
              prefixIcon: const Icon(
                Icons.search,
              ),
            ),
            onChanged: (String value) {
              setState(() {
                _searchString = value;
              });
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Consumer<CategoryModel>(
              builder: (context, model, child) {
                return FutureBuilder<List<TransactionCategory>>(
                  future: model.getAllCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.data!.isEmpty) {
                      return EmptyScreen(
                        type: 'category',
                        onPressed: const CategoryForm(),
                      );
                    }
                    return categoryListView(snapshot);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryListView(AsyncSnapshot<List<TransactionCategory>> snapshot) {
    final List<TransactionCategory> fullCategoryList = snapshot.data!
      ..sort((a, b) {
        if (a.children.isNotEmpty && b.children.isNotEmpty ||
            a.children.isEmpty && b.children.isEmpty) {
          return a.name.compareTo(b.name);
        } else if (a.children.isEmpty && b.children.isNotEmpty) {
          return -1;
        } else if (a.children.isNotEmpty && b.children.isEmpty) {
          return 1;
        }
        return 0;
      });

    // Filter categories by search string, including all parents of matches
    Set<int> matchedIds = {};
    Set<int> parentIds = {};

    for (final category in fullCategoryList) {
      if (_searchString.isEmpty ||
          partialRatio(
                category.name.toLowerCase(),
                _searchString.toLowerCase(),
              ) >
              80) {
        matchedIds.add(category.id);

        // Collect all parent ids up the tree
        TransactionCategory current = category;
        while (current.parentID != null) {
          parentIds.add(current.parentID!);
          current = fullCategoryList.firstWhere(
            (c) => c.id == current.parentID,
          );
        }
      }
    }

    List<TransactionCategory> filteredCategoryList = fullCategoryList
        .where((c) => matchedIds.contains(c.id) || parentIds.contains(c.id))
        .toList();

    return CategoryTree(
      categories: filteredCategoryList,
      separated: _searchString.isNotEmpty, // expand tree when searching
      onTap: (value) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoryForm(
              categoryData: value,
            ),
          ),
        );
      },
    );
  }
}
