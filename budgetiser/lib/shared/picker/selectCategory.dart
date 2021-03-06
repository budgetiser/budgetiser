import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
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
      setState(() { //memory leak because of setState. -> DELETE?
        _categories?.clear();
        _categories = (event.map((e) => e).toList());
        if (widget.initialCategory != null) {
          selectedCategory = _categories?.firstWhere(
              (element) => element.id == widget.initialCategory!.id);
        } else {
          selectedCategory = _categories?.first;
        }
      });
      widget.callback(selectedCategory!);
    });
    DatabaseHelper.instance.pushGetAllCategoriesStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<TransactionCategory>(
      items: _categories
          ?.map((category) => DropdownMenuItem(
                value: category,
                child: Text(
                  category.name,
                ),
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
