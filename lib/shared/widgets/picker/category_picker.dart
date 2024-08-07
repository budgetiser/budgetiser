import 'package:budgetiser/categories/widgets/category_tree.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPickerSingle extends StatefulWidget {
  const CategoryPickerSingle({
    super.key,
    required this.onPickedCallback,
    required this.possibleValues,
    this.blacklistedValues,
    this.noDataButton,
  });

  final Function(TransactionCategory selected) onPickedCallback;
  final List<TransactionCategory> possibleValues;
  final List<TransactionCategory>? blacklistedValues;

  /// Optional button for dialog. Displayed if no data is available.
  final TextButton? noDataButton;

  @override
  State<CategoryPickerSingle> createState() => _CategoryPickerSingleState();
}

class _CategoryPickerSingleState<T extends Selectable>
    extends State<CategoryPickerSingle> {
  final List<TransactionCategory> selectedValues = [];

  @override
  void initState() {
    if (widget.blacklistedValues != null) {
      for (var element in widget.blacklistedValues!) {
        widget.possibleValues.remove(element);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      actions: widget.noDataButton != null
          ? [Container(child: widget.noDataButton)]
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
    return Consumer<CategoryModel>(
      builder: (context, model, child) {
        return FutureBuilder<List<TransactionCategory>>(
          future: model.getAllCategories(),
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
                child: Text('No Categories'),
              );
            }
            return SizedBox(
              width: double.maxFinite,
              child: CategoryTree(
                categories: snapshot.data ?? [],
                onTap: (value) {
                  setState(() {
                    widget.onPickedCallback(value);
                  });
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );
      },
    );
  }
}
