import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/picker/colorpicker.dart';
import 'package:budgetiser/shared/picker/selectIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CategoryForm extends StatefulWidget {
  CategoryForm({
    Key? key,
    this.categoryData,
  }) : super(key: key);
  TransactionCategory? categoryData;

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color _color = Colors.blue;
  IconData _icon = Icons.blur_on;

  @override
  void initState() {
    if (widget.categoryData != null) {
      nameController.text = widget.categoryData!.name;
      descriptionController.text = widget.categoryData!.description;
      _color = widget.categoryData!.color;
      _icon = widget.categoryData!.icon;
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.categoryData != null
            ? const Text("Edit Category")
            : const Text("New Category"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconPicker(
                                initialColor: _color,
                                initialIcon: _icon,
                                onIconChangedCallback: (icondata) {
                                  _icon = icondata;
                                },
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: nameController,
                                // initialValue: widget.initialName,
                                decoration: const InputDecoration(
                                  labelText: "Category title",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Colorpicker(
                  initialSelectedColor: _color,
                  onColorChangedCallback: (color) {
                    setState(() {
                      _color = color;
                    });
                  })
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.red,
            mini: true,
            onPressed: () {
              if (widget.categoryData != null) {
                widget.categoryData!.id;
                DatabaseHelper.instance.deleteCategory(widget.categoryData!.id);
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: widget.categoryData != null
                ? const Icon(Icons.delete_outline)
                : const Icon(Icons.close),
          ),
          const SizedBox(
            width: 5,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                TransactionCategory a = TransactionCategory(
                    name: nameController.text,
                    icon: _icon,
                    color: _color,
                    description: descriptionController.text,
                    isHidden: false,
                    id: 0);
                if (widget.categoryData != null) {
                  a.id = widget.categoryData!.id;
                  DatabaseHelper.instance.updateCategory(a);
                } else {
                  DatabaseHelper.instance.createCategory(a);
                }
                Navigator.of(context).pop();
              }
            },
            label: const Text("Save"),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
