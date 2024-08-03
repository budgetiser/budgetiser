import 'package:budgetiser/categories/widgets/category_single_picker_nullable.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/shared/utils/color_utils.dart';
import 'package:budgetiser/shared/utils/data_types_utils.dart';
import 'package:budgetiser/shared/widgets/actionButtons/cancel_action_button.dart';
import 'package:budgetiser/shared/widgets/forms/custom_input_field.dart';
import 'package:budgetiser/shared/widgets/forms/screen_forms.dart';
import 'package:budgetiser/shared/widgets/picker/icon_color/icon_color_picker.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon_with_text.dart';
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
  IconData _icon = Icons.abc;
  TransactionCategory? _parentCategory;

  double maxHeaderHeight = 200;
  final ValueNotifier<double> opacity = ValueNotifier(0);

  @override
  void initState() {
    if (widget.categoryData != null) {
      nameController.text = widget.categoryData!.name;
      descriptionController.text = widget.categoryData!.description ?? '';
      _color = widget.categoryData!.color;
      _icon = widget.categoryData!.icon;
      if (widget.categoryData!.parentID != null) {
        // fetch full parent if category has one
        CategoryModel().getCategory(widget.categoryData!.parentID!).then(
          (value) {
            setState(() {
              _parentCategory = value;
            });
          },
        );
      }
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
        title: const Text('Create a Category'),
      ),
      body: _screenContent(context),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CancelActionButton(
            isDeletion: widget.categoryData != null &&
                widget.categoryData!.children.isEmpty,
            onSubmitCallback: () {
              Provider.of<CategoryModel>(context, listen: false)
                  .deleteCategory(widget.categoryData!.id);
            },
          ),
          const SizedBox(
            width: 5,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                TransactionCategory a = TransactionCategory(
                    name: nameController.text.trim(),
                    icon: _icon,
                    color: _color,
                    description: parseNullableString(
                      descriptionController.text,
                    ),
                    archived: false,
                    parentID: _parentCategory?.id,
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

  Widget _screenContent(BuildContext context) {
    return ScrollViewWithDeadSpace(
      deadSpaceContent: _deadSpaceContent(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconColorPicker(
                initialIcon: _icon,
                initialColor: _color,
                onSelection: (IconData selectedIcon, Color selectedColor) {
                  setState(() {
                    _icon = selectedIcon;
                    _color = selectedColor;
                  });
                },
              ),
              const SizedBox(
                width: 16,
              ),
              Form(
                key: _formKey,
                child: Expanded(
                  child: TextFormField(
                    controller: nameController,
                    cursorColor: _color,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        CustomInputFieldBorder(
          title: 'Parent',
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return CategorySinglePickerNullable(
                blacklistedValues:
                    widget.categoryData == null ? [] : [widget.categoryData!],
                onCategoryPickedCallback:
                    (TransactionCategory? selectedCategory) {
                  setState(() {
                    _parentCategory = selectedCategory;
                  });
                },
              );
            },
          ),
          child: InkWell(
            child: _parentCategory != null
                ? SelectableIconWithText(_parentCategory!)
                : const Text('Select Parent'),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: descriptionController,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Description (optional)',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        childrenOverview(),
      ],
    );
  }

  Widget _deadSpaceContent() {
    if (_parentCategory == null) {
      return const Center(
        child: Text('No parent'),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Parent:'),
          SelectableIconWithText(
            _parentCategory!,
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget childrenOverview() {
    if (widget.categoryData == null) {
      return Container(); // new category
    }
    return FutureBuilder(
      future: CategoryModel().getCategories(widget.categoryData!.children),
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
            child: Chip(
              avatar: Icon(Icons.add),
              label: Text('Add child'),
            ),
            // TODO: inkwell to other categories with alert: unsaved changes,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Children'),
            SizedBox(
              width: double.maxFinite,
              child: Wrap(
                spacing: 8,
                children: [
                  for (TransactionCategory child in snapshot.data ?? [])
                    Chip(
                      avatar: Icon(child.icon, color: child.color),
                      label: Text(child.name),
                    ),
                  const Chip(
                    avatar: Icon(Icons.add),
                    label: Text('Add child'),
                  ),
                  // TODO: inkwell to other categories with alert: unsaved changes
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
