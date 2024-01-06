import 'package:budgetiser/db/category_provider.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/picker/multi_picker/general_multi_picker.dart';
import 'package:flutter/material.dart';

class CategoryMultiPicker extends StatefulWidget {
  const CategoryMultiPicker({
    super.key,
    required this.onCategoriesPickedCallback,
    this.initialValues,
  });

  final Function(List<TransactionCategory> selected) onCategoriesPickedCallback;
  final List<TransactionCategory>? initialValues;

  @override
  State<CategoryMultiPicker> createState() => _CategoryMultiPickerState();
}

class _CategoryMultiPickerState extends State<CategoryMultiPicker> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TransactionCategory>>(
      future: CategoryModel().getAllCategories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Text('Oops!');
        }

        return GeneralMultiPicker<TransactionCategory>(
          heading: 'Select Categories',
          onPickedCallback: widget.onCategoriesPickedCallback,
          possibleValues: snapshot.data!,
          initialValues: widget.initialValues,
        );
      },
    );
  }
}
