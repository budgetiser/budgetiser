import 'package:budgetiser/screens/categories/shared/categoryForm.dart';
import 'package:budgetiser/shared/widgets/picker/colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NewCategory extends StatefulWidget {
  NewCategory({
    Key? key,
  }) : super(key: key);

  @override
  State<NewCategory> createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Category"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                CategoryForm(),
                Colorpicker(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text("Add Category"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
