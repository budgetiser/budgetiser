import 'package:budgetiser/categories/picker/category_picker.dart';
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
  }) : initialParentID = null;
  const CategoryForm.prefilledParent({
    super.key,
    required this.initialParentID,
  }) : categoryData = null;
  final TransactionCategory? categoryData;
  final int? initialParentID;

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
  List<int>? _childrenList;
  List<String>? _allCategories; // Variable to store all categories

  double maxHeaderHeight = 200;
  final ValueNotifier<double> opacity = ValueNotifier(0);
  String? _nameError;

  @override
  void initState() {
    if (widget.categoryData != null) {
      nameController.text = widget.categoryData!.name;
      descriptionController.text = widget.categoryData!.description ?? '';
      _color = widget.categoryData!.color;
      _icon = widget.categoryData!.icon;
      _childrenList = widget.categoryData!.children;
      if (widget.categoryData!.parentID != null) {
        // fetch full parent if category has one
        fetchParentCategory(widget.categoryData!.parentID!);
      }
    }
    if (widget.initialParentID != null) {
      fetchParentCategory(widget.initialParentID!);
    }
    fetchAllCategories(); // Load all categories

    nameController.addListener(_validateName);

    super.initState();
  }

  void fetchParentCategory(int parentID) {
    CategoryModel().getCategory(parentID).then(
      (value) {
        setState(() {
          _parentCategory = value;
        });
      },
    );
  }

  void fetchAllCategories() async {
    List<TransactionCategory> categories =
        await CategoryModel().getAllCategories();
    setState(() {
      _allCategories = categories.map((e) => e.name).toList();
    });
  }

  void _validateName() {
    final value = nameController.text.trim().toLowerCase();
    if (_allCategories != null &&
        _allCategories!
            .any((categoryName) => categoryName.toLowerCase() == value)) {
      setState(() {
        _nameError = 'This category name already exists';
      });
    } else {
      setState(() {
        _nameError = null;
      });
    }
  }

  @override
  void dispose() {
    nameController
      ..removeListener(_validateName)
      ..dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryData == null
            ? 'Create a Category'
            : 'Edit Category'),
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
                // Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'categories',
                  ModalRoute.withName('/'),
                );
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Expanded(
                  child: TextFormField(
                    controller: nameController,
                    cursorColor: _color,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      errorText:
                          _nameError, // error message for duplicate name (does not block form submission)
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
              return CategoryPicker.singleNullable(
                blacklistedValues:
                    widget.categoryData == null ? [] : [widget.categoryData!],
                onCategoryPickedCallbackNullable:
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
      future: CategoryModel().getCategories(_childrenList!),
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
          return Center(
            child: addChildChip(),
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
                  addChildChip(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget addChildChip() {
    /// Chip that acts like a button for a creation of a new category with a parent preselected.
    // TODO: inkwell to other categories with alert: unsaved changes
    // TODO: just pop new form and update current child list
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoryForm.prefilledParent(
              initialParentID: widget.categoryData!.id,
            ),
          ),
        );
      },
      child: const Chip(
        avatar: Icon(Icons.add),
        label: Text('Add child'),
      ),
    );
  }
}
