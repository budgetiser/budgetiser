import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({Key? key}) : super(key: key);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  /*
    popup to select category
    todo: implementation -> how to pass selected item back to caller?
  */
  String selectedCategory = "food";

  void setCategory(String? category) {
    setState(() {
      selectedCategory = category!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: <String>[
        "food",
        "car",
        "other",
      ]
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                ),
              ))
          .toList(),
      onChanged: (e) {
        setCategory(e);
      },
      value: selectedCategory,
    );
  }
}
