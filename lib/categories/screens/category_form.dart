import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/shared/utils/color_utils.dart';
import 'package:budgetiser/shared/utils/data_types_utils.dart';
import 'package:budgetiser/shared/widgets/actionButtons/cancel_action_button.dart';
import 'package:budgetiser/shared/widgets/forms/screen_forms.dart';
import 'package:budgetiser/shared/widgets/picker/color_picker.dart';
import 'package:budgetiser/shared/widgets/picker/icon_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({
    super.key,
    this.categoryData,
  });
  final TransactionCategory? categoryData;

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color _color = randomColor();
  IconData? _icon;

  @override
  void initState() {
    if (widget.categoryData != null) {
      nameController.text = widget.categoryData!.name;
      descriptionController.text = widget.categoryData!.description ?? '';
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
                      textCapitalization: TextCapitalization.sentences,
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
                },
              ),
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
          CancelActionButton(
            isDeletion: widget.categoryData != null,
            onSubmitCallback: () {
              Provider.of<CategoryModel>(context, listen: false)
                  .deleteCategory(widget.categoryData!.id);
            },
          ),
          const SizedBox(
            width: 5,
          ),
          FloatingActionButton.extended(
            heroTag: 'save',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                TransactionCategory a = TransactionCategory(
                    name: nameController.text.trim(),
                    icon: _icon ?? Icons.blur_on,
                    color: _color,
                    description:
                        parseNullableString(descriptionController.text),
                    archived: false,
                    id: 0);
                if (widget.categoryData != null) {
                  a.id = widget.categoryData!.id;
                  Provider.of<CategoryModel>(context, listen: false)
                      .updateCategory(a);
                } else {
                  Provider.of<CategoryModel>(context, listen: false)
                      .createCategory(a);
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
