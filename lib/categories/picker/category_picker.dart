import 'package:budgetiser/categories/picker/category_picker_single.dart';
import 'package:budgetiser/categories/screens/category_form.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/shared/widgets/picker/selectable/multi_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPicker extends StatefulWidget {
  const CategoryPicker.single({
    super.key,
    required this.onCategoryPickedCallback,
    this.blacklistedValues,
  })  : assert(onCategoryPickedCallback != null),
        onCategoryPickedCallbackNullable = null,
        onCategoryPickedCallbackMulti = null,
        initialValues = null;

  const CategoryPicker.singleNullable({
    super.key,
    required this.onCategoryPickedCallbackNullable,
    this.blacklistedValues,
  })  : assert(onCategoryPickedCallbackNullable != null),
        onCategoryPickedCallback = null,
        onCategoryPickedCallbackMulti = null,
        initialValues = null;

  const CategoryPicker.multi({
    super.key,
    required this.onCategoryPickedCallbackMulti,
    this.blacklistedValues,
    this.initialValues,
  })  : assert(onCategoryPickedCallbackMulti != null),
        onCategoryPickedCallback = null,
        onCategoryPickedCallbackNullable = null;

  final Function(TransactionCategory)? onCategoryPickedCallback;
  final Function(TransactionCategory? selected)?
      onCategoryPickedCallbackNullable;
  final Function(List<TransactionCategory> selected)?
      onCategoryPickedCallbackMulti;

  final List<TransactionCategory>? blacklistedValues;
  final List<TransactionCategory>? initialValues;

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TransactionCategory>>(
      future:
          Provider.of<CategoryModel>(context, listen: false).getAllCategories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Text('Oops!');
        }

        if (widget.blacklistedValues != null) {
          for (var element in widget.blacklistedValues!) {
            snapshot.data!.remove(element);
          }
        }

        if (widget.onCategoryPickedCallbackMulti != null) {
          return GeneralMultiPicker<TransactionCategory>(
            heading: 'Select Categories',
            onPickedCallback: widget.onCategoryPickedCallbackMulti!,
            possibleValues: snapshot.data!,
            initialValues: widget.initialValues,
            noDataButton:
                snapshot.data!.isEmpty ? createCategoryButton(context) : null,
          );
        }

        if (widget.onCategoryPickedCallbackNullable != null) {
          return CategoryPickerSingle.nullable(
            onPickedCallbackNullable: widget.onCategoryPickedCallbackNullable!,
            possibleValues: snapshot.data!,
            noDataButton: createCategoryButton(context),
          );
        }

        if (widget.onCategoryPickedCallback != null) {
          return CategoryPickerSingle(
            onPickedCallback: widget.onCategoryPickedCallback!,
            possibleValues: snapshot.data!,
            noDataButton: createCategoryButton(context),
          );
        }

        throw Exception(
          'Error in named constructor of CategoryPicker: impossible state reached!',
        );
      },
    );
  }

  /// Button showed in dialog when no category is available
  TextButton createCategoryButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context)
            .pop(); // pop dialog, so that after creation the not reloaded dialog is not visible (todo: reload dialog directly)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CategoryForm(),
          ),
        );
      },
      child: const Text(
        'Create a Category',
      ),
    );
  }
}
