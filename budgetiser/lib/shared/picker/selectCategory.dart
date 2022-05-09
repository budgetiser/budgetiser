import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/widgets/smalStuff/CategoryTextWithIcon.dart';
import 'package:flutter/material.dart';

class SelectCategory extends StatefulWidget {
  SelectCategory({
    Key? key,
    this.initialCategory,
    required this.callback,
  }) : super(key: key);

  TransactionCategory? initialCategory;
  final Function(TransactionCategory) callback;

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  List<TransactionCategory>? _categories;
  TransactionCategory? selectedCategory;

  @override
  void initState() {
    DatabaseHelper.instance.allCategoryStream.listen((event) {
      _categories?.clear();
      _categories = (event.map((e) => e).toList());
      if (widget.initialCategory != null) {
        selectedCategory = _categories
            ?.firstWhere((element) => element.id == widget.initialCategory!.id);
      } else {
        selectedCategory = _categories?.first;
      }
      // if (selectedCategory != null) {
      if (mounted) {
        widget.callback(selectedCategory!);
      }
      // }
    });
    DatabaseHelper.instance.pushGetAllCategoriesStream();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<TransactionCategory>(
      isExpanded: true,
      items: _categories
          ?.map((category) => DropdownMenuItem(
                value: category,
                child: CategoryTextWithIcon(category),
              ))
          .toList(),
      onChanged: (TransactionCategory? category) {
        setState(() {
          widget.callback(category!);
          selectedCategory = category;
        });
      },
      value: selectedCategory,
    );
  }
}
