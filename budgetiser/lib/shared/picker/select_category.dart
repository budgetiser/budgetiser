import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/categories/category_form.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/widgets/smallStuff/category_text_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({
    Key? key,
    this.initialCategory,
    required this.callback,
  }) : super(key: key);

  final TransactionCategory? initialCategory;
  final Function(TransactionCategory) callback;

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  List<TransactionCategory>? _categories;
  TransactionCategory? selectedCategory;
  final String keySelectedCategory = "key-last-selected-category";

  @override
  void initState() {
    DatabaseHelper.instance.allCategoryStream.listen((event) async {
      if (event.isEmpty) {
        return;
      }
      _categories?.clear();
      _categories = (event.map((e) => e).toList());
      final prefs = await SharedPreferences.getInstance();
      if (widget.initialCategory != null) {
        try {
          selectedCategory = _categories?.firstWhere(
              (element) => element.id == widget.initialCategory!.id);
        } catch (e) {
          prefs.remove(keySelectedCategory);
          selectedCategory = _categories?.first;
        }
      } else {
        final categoryIdFromPref = prefs.getInt(keySelectedCategory);
        if (categoryIdFromPref == null) {
          selectedCategory = _categories?.first;
        } else {
          try {
            selectedCategory = _categories
                ?.firstWhere((element) => element.id == categoryIdFromPref);
          } catch (e) {
            prefs.remove(keySelectedCategory);
            selectedCategory = _categories?.first;
          }
        }
      }
      if (mounted && selectedCategory != null) {
        widget.callback(selectedCategory!);
      }
    });
    DatabaseHelper.instance.pushGetAllCategoriesStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if no categories yet, return a link to add a category
    if (_categories == null || _categories!.isEmpty) {
      return Center(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CategoryForm()));
          },
          child: const Text(
            "No category found\nClick here to add one",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: DropdownButton<TransactionCategory>(
            isExpanded: true,
            items: _categories
                ?.map((category) => DropdownMenuItem(
                      value: category,
                      child: CategoryTextWithIcon(category),
                    ))
                .toList(),
            onChanged: (TransactionCategory? category) async {
              setState(() {
                widget.callback(category!);
                selectedCategory = category;
              });
              if (category != null) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt(keySelectedCategory, category.id);
              }
            },
            value: selectedCategory,
          ),
        ),
      ],
    );
  }
}
