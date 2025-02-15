import 'package:budgetiser/categories/widgets/category_tree.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:flutter/material.dart';

class CategoryPickerSingle extends StatefulWidget {
  const CategoryPickerSingle({
    super.key,
    required this.onPickedCallback,
    required this.possibleValues,
    required this.noDataButton,
  })  : assert(onPickedCallback != null),
        onPickedCallbackNullable = null,
        isNullable = false;

  const CategoryPickerSingle.nullable({
    super.key,
    required this.onPickedCallbackNullable,
    required this.possibleValues,
    required this.noDataButton,
  })  : assert(onPickedCallbackNullable != null),
        onPickedCallback = null,
        isNullable = true;

  final Function(TransactionCategory selected)? onPickedCallback;
  final Function(TransactionCategory? selected)? onPickedCallbackNullable;
  final bool isNullable;

  final List<TransactionCategory> possibleValues;

  /// Optional button for dialog. Displayed if no data is available.
  final TextButton noDataButton;

  @override
  State<CategoryPickerSingle> createState() => _CategoryPickerSingleState();
}

class _CategoryPickerSingleState<T extends Selectable>
    extends State<CategoryPickerSingle> {
  final List<TransactionCategory> selectedValues = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a category'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      actions: widget.possibleValues.isEmpty
          ? [Container(child: widget.noDataButton)]
          : widget.isNullable
              ? [
                  TextButton(
                    child: const Text('Select None'),
                    onPressed: () {
                      setState(() {
                        widget.onPickedCallbackNullable!(null);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ]
              : null,
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          if (widget.possibleValues.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.maxFinite,
                child: Text('Nothing to select!'),
              ),
            );
          }
          return dialogContent(setState, context);
        },
      ),
    );
  }

  Widget dialogContent(StateSetter setState, BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CategoryTree(
        padding: null,
        categories: widget.possibleValues,
        onTap: (value) {
          setState(() {
            if (widget.isNullable) {
              widget.onPickedCallbackNullable!(value);
            } else {
              widget.onPickedCallback!(value);
            }
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
