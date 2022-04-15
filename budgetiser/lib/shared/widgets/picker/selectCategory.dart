import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/tempData/tempData.dart';
import 'package:flutter/material.dart';

class SelectCategory extends StatefulWidget {
  SelectCategory({
    Key? key,
    this.initialCategory,
  }) : super(key: key);

  TransactionCategory? initialCategory;

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  /*
    popup to select category
    todo: implementation -> how to pass selected item back to caller?
  */
  final List<String> _categories =
      TMP_DATA_categoryList.map((e) => e.name).toList();
  String selectedCategoryName = TMP_DATA_categoryList[0].name;

  @override
  void initState() {
    if (widget.initialCategory != null) {
      selectedCategoryName = widget.initialCategory!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: _categories
          .map((categoryName) => DropdownMenuItem(
                value: categoryName,
                child: Text(
                  categoryName,
                ),
              ))
          .toList(),
      onChanged: (category) {
        setState(() {
          selectedCategoryName = category!;
        });
      },
      value: selectedCategoryName,
    );
  }
}
