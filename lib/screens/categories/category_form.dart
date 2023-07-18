import 'dart:math';

import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/picker/color_picker.dart';
import 'package:budgetiser/shared/picker/select_icon.dart';
import 'package:budgetiser/shared/widgets/confirmation_dialog.dart';
import 'package:budgetiser/shared/widgets/wrapper/screen_forms.dart';
import 'package:flutter/material.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({
    Key? key,
    this.categoryData,
  }) : super(key: key);
  final TransactionCategory? categoryData;

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color _color = Color.fromRGBO(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
  IconData? _icon;

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
            ? const Text('Edit Category')
            : const Text('New Category'),
      ),
      body: ScrollViewWithDeadSpace(
        deadSpaceContent: Container(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // icon and name
              Row(
                children: <Widget>[
                  IconPicker(
                    color: _color,
                    initialIcon: _icon,
                    onIconChangedCallback: (iconData) {
                      setState(() {
                        _icon = iconData;
                      });
                    },
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: nameController,
                      validator: (data) {
                        if (data == null || data == '') {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Category title',
                      ),
                    ),
                  ),
                ],
              ),
              ColorPickerWidget(
                  initialSelectedColor: _color,
                  onColorChangedCallback: (color) {
                    setState(() {
                      _color = color;
                    });
                  }),
              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'cancel',
            backgroundColor: Colors.red,
            mini: true,
            onPressed: () {
              if (widget.categoryData != null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        title: 'Attention',
                        description:
                            "Are you sure to delete this category? All connected Items will deleted, too. This action can't be undone!",
                        onSubmitCallback: () {
                          DatabaseHelper.instance
                              .deleteCategory(widget.categoryData!.id);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        onCancelCallback: () {
                          Navigator.pop(context);
                        },
                      );
                    });
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
            heroTag: 'save',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                TransactionCategory a = TransactionCategory(
                    name: nameController.text,
                    icon: _icon ?? Icons.blur_on,
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
            label: const Text('Save'),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
