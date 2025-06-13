import 'package:budgetiser/categories/widgets/category_item.dart';
import 'package:budgetiser/categories/widgets/category_tree_tile.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryTree extends StatefulWidget {
  const CategoryTree({
    super.key,
    required this.categories,
    this.onTap,
    this.separated = false,
    this.padding = const EdgeInsets.only(bottom: 80),
  });

  @override
  State<CategoryTree> createState() => _CategoryTreeState();

  final bool separated;
  final List<TransactionCategory> categories;
  final ValueChanged<TransactionCategory>? onTap;

  final EdgeInsetsGeometry? padding;
}

class _CategoryTreeState extends State<CategoryTree> {
  @override
  Widget build(BuildContext context) {
    final List<RecursiveCategoryModel> categoryTree =
        getCategoryTree(widget.categories, null);

    return Consumer<CategoryModel>(
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
            return getListView(context, categoryTree);
          },
        );
      },
    );
  }

  ListView getListView(
    BuildContext context,
    List<RecursiveCategoryModel> categoryTree,
  ) {
    if (widget.separated) {
      return getSeparated(context, categoryTree);
    }
    return getTogether(context, categoryTree);
  }

  ListView getSeparated(
    BuildContext context,
    List<RecursiveCategoryModel> categoryTree,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: (categoryTree.length),
      itemBuilder: (BuildContext context, int index) {
        return RecursiveWidget(
          model: categoryTree[index],
          level: 0,
          onTap: widget.onTap,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  ListView getTogether(
    BuildContext context,
    List<RecursiveCategoryModel> categoryTree,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      padding: widget.padding,
      itemCount: (categoryTree.length),
      itemBuilder: (BuildContext context, int index) {
        return RecursiveWidget(
          model: categoryTree[index],
          level: 0,
          onTap: widget.onTap,
        );
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
    this.onTap,
  });

  final RecursiveCategoryModel model;
  final int level;
  final ValueChanged<TransactionCategory>? onTap;

  @override
  State<RecursiveWidget> createState() => _RecursiveWidgetState();
}

class _RecursiveWidgetState extends State<RecursiveWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.model.children == null || widget.model.children!.isEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(widget.level * 12, 0, 0, 0),
        child: CategoryItem(
          categoryData: widget.model.current,
          onTap: widget.onTap,
        ),
      );
    } else {
      return Theme(
        // Theme override needed to hide divider bars: https://github.com/flutter/flutter/issues/67459
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: EdgeInsets.fromLTRB(widget.level * 12, 0, 0, 0),
          child: CategoryTreeTile(
            onTap: widget.onTap,
            initiallyExpanded: isExpanded,
            categoryData: widget.model.current,
            children: [
              Column(
                children: widget.model.children!.map((child) {
                  return RecursiveWidget(
                    model: child,
                    level: widget.level + 1,
                    onTap: widget.onTap,
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
  List<TransactionCategory> categories,
  int? parentID,
) {
  List<RecursiveCategoryModel> categoryModel = [];

  List<TransactionCategory> topLevelCategories = categories
      .where(
        (element) => element.parentID == parentID,
      )
      .toList();

  for (var topLevelCategory in topLevelCategories) {
    categoryModel.add(
      RecursiveCategoryModel(
        current: topLevelCategory,
        children: getCategoryTree(categories, topLevelCategory.id),
      ),
    );
  }

  return categoryModel;
}
