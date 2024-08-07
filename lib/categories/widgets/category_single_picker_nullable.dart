import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/shared/widgets/picker/selectable/single_picker_nullable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySinglePickerNullable extends StatefulWidget {
  const CategorySinglePickerNullable({
    super.key,
    required this.onCategoryPickedCallback,
    this.blacklistedValues,
  });

  final Function(TransactionCategory? selected) onCategoryPickedCallback;
  final List<TransactionCategory>? blacklistedValues;

  @override
  State<CategorySinglePickerNullable> createState() =>
      _CategorySinglePickerNullableState();
}

class _CategorySinglePickerNullableState
    extends State<CategorySinglePickerNullable> {
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

        return GeneralSinglePickerNullable<TransactionCategory>(
          onPickedCallback: widget.onCategoryPickedCallback,
          possibleValues: snapshot.data!,
          blacklistedValues: widget.blacklistedValues,
        );
      },
    );
  }
}
