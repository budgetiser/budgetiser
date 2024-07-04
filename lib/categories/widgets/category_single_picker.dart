import 'package:budgetiser/categories/screens/category_form.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/shared/widgets/picker/selectable/single_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySinglePicker extends StatefulWidget {
  const CategorySinglePicker({
    super.key,
    required this.onCategoryPickedCallback,
    this.blacklistedValues,
  });

  final Function(TransactionCategory) onCategoryPickedCallback;
  final List<TransactionCategory>? blacklistedValues;

  @override
  State<CategorySinglePicker> createState() => _CategorySinglePickerState();
}

class _CategorySinglePickerState extends State<CategorySinglePicker> {
  late List<TransactionCategory> _allCategories = [];

  @override
  void initState() {
    Provider.of<CategoryModel>(context, listen: false)
        .getAllCategories()
        .then((value) => _allCategories = value);
    super.initState();
  }

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

        return GeneralSinglePicker<TransactionCategory>(
          onPickedCallback: widget.onCategoryPickedCallback,
          possibleValues: _allCategories,
          blacklistedValues: widget.blacklistedValues,
          noDataButton: snapshot.data!.isEmpty
              ? TextButton(
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
                )
              : null,
        );
      },
    );
  }
}
