import 'package:budgetiser/categories/screens/category_form.dart';
import 'package:budgetiser/categories/widgets/category_item.dart';
import 'package:budgetiser/categories/widgets/tree_expansion.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/core/drawer.dart';
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
                      return const Center(
                        child: Text('No Categories'),
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

    List<TransactionCategory> filteredCategoryList = fullCategoryList.where(
      (element) {
        if (_searchString.isEmpty) return true;
        return (partialRatio(
              element.name.toLowerCase(),
              _searchString.toLowerCase(),
            ) >
            80);
      },
    ).toList();

    final List<RecursiveCategoryModel> categoryTree = getCategoryTree(
      filteredCategoryList,
      null,
    );

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 75),
      itemCount: (categoryTree.length),
      itemBuilder: (BuildContext context, int index) {
        return RecursiveWidget(
          model: categoryTree[index],
          level: 0,
          parentWasCollapsed: true,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}

class RecursiveCategoryModel {
  final TransactionCategory current;
  final List<RecursiveCategoryModel>? children;

  RecursiveCategoryModel({required this.current, this.children});
}

class RecursiveWidget extends StatefulWidget {
  const RecursiveWidget({
    super.key,
    required this.model,
    required this.level,
    required this.parentWasCollapsed,
  });

  final RecursiveCategoryModel model;
  final int level;
  final bool parentWasCollapsed; // state of the parent

  @override
  State<RecursiveWidget> createState() => _RecursiveWidgetState();
}

class _RecursiveWidgetState extends State<RecursiveWidget> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = !widget.parentWasCollapsed;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.children == null || widget.model.children!.isEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(widget.level * 12, 0, 0, 0),
        child: CategoryItem(categoryData: widget.model.current),
      );
    } else {
      return Theme(
        // Theme override needed to hide divider bars: https://github.com/flutter/flutter/issues/67459
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: EdgeInsets.fromLTRB(widget.level * 12, 0, 0, 0),
          child: TreeExpansionTile(
            tilePadding: EdgeInsets.fromLTRB(0, 0, 8, 0),
            initiallyExpanded: isExpanded,
            iconColor: Colors.grey,
            categoryData: widget.model.current,
            trailing: const InkWell(
              child: SizedBox(
                height: 40,
                width: 40,
                child: Icon(
                  Icons.expand_more,
                  color: Colors.white,
                ),
              ),
            ),
            children: [
              Column(
                children: widget.model.children!.map((child) {
                  return RecursiveWidget(
                    model: child,
                    level: widget.level + 1,
                    parentWasCollapsed: isExpanded,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    }
  }
}

List<RecursiveCategoryModel> getCategoryTree(
    List<TransactionCategory> categories, int? parentID) {
  List<RecursiveCategoryModel> categoryModel = [];

  List<TransactionCategory> topLevelCategories = categories
      .where(
        (element) => element.parentID == parentID,
      )
      .toList();

  for (var topLevelCategory in topLevelCategories) {
    categoryModel.add(RecursiveCategoryModel(
        current: topLevelCategory,
        children: getCategoryTree(categories, topLevelCategory.id)));
  }

  return categoryModel;
}
