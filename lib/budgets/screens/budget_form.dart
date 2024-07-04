import 'package:budgetiser/categories/widgets/category_multi_picker.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/budget_provider.dart';
import 'package:budgetiser/shared/utils/color_utils.dart';
import 'package:budgetiser/shared/utils/data_types_utils.dart';
import 'package:budgetiser/shared/widgets/actionButtons/cancel_action_button.dart';
import 'package:budgetiser/shared/widgets/forms/screen_forms.dart';
import 'package:budgetiser/shared/widgets/picker/icon_color/icon_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetForm extends StatefulWidget {
  const BudgetForm({
    super.key,
    this.budgetData,
  });
  final Budget? budgetData;

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  var nameController = TextEditingController();
  var limitController = TextEditingController();
  var descriptionController = TextEditingController();
  IntervalUnit selectedInterval = IntervalUnit.month;
  final _formKey = GlobalKey<FormState>();

  List<TransactionCategory> budgetCategories = [];
  IconData _icon = Icons.abc;
  Color _color = randomColor();

  @override
  void initState() {
    if (widget.budgetData != null) {
      nameController.text = widget.budgetData!.name;
      limitController.text = widget.budgetData!.maxValue.toStringAsFixed(2);
      descriptionController.text = widget.budgetData!.description ?? '';
      _color = widget.budgetData!.color;
      _icon = widget.budgetData!.icon;
      selectedInterval = widget.budgetData!.intervalUnit;
      budgetCategories = widget.budgetData!.transactionCategories;
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    limitController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void setCategories(List<TransactionCategory> categories) {
    if (mounted) {
      setState(() {
        budgetCategories = categories;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.budgetData != null
            ? const Text('Edit Budget')
            : const Text('New Budget'),
      ),
      body: ScrollViewWithDeadSpace(
          deadSpaceContent: Container(),
          deadSpaceSize: 150,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconColorPicker(
                        initialIcon: _icon,
                        initialColor: _color,
                        onSelection: (iconData, color) {
                          setState(() {
                            _icon = iconData;
                            _color = color;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 16,
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
                            labelText: 'Budget title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: limitController,
                          validator: (data) {
                            if (data == null || data == '') {
                              return 'Please enter a number';
                            }
                            return null;
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Limit',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Flexible(
                        child: DropdownMenu<IntervalUnit>(
                          initialSelection: selectedInterval,
                          label: const Text('Interval'),
                          leadingIcon: const Icon(Icons.event_repeat),
                          onSelected: (IntervalUnit? unit) {
                            setState(() {
                              if (unit != null) {
                                selectedInterval = unit;
                              }
                            });
                          },
                          dropdownMenuEntries: IntervalUnit.values
                              .map<DropdownMenuEntry<IntervalUnit>>(
                                  (IntervalUnit unit) {
                            return DropdownMenuEntry(
                              value: unit,
                              label: unit.label,
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Divider(height: 32),
                  InkWell(
                    child: const Text('Select Categories'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CategoryMultiPicker(
                            onCategoriesPickedCallback: setCategories,
                            initialValues: budgetCategories,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ]),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CancelActionButton(
            isDeletion: widget.budgetData != null,
            onSubmitCallback: () {
              Provider.of<BudgetModel>(context, listen: false)
                  .deleteBudget(widget.budgetData!.id);
            },
          ),
          const SizedBox(width: 5),
          FloatingActionButton.extended(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Budget a = Budget(
                  name: nameController.text.trim(),
                  icon: _icon,
                  color: _color,
                  description: parseNullableString(descriptionController.text),
                  id: 0,
                  transactionCategories: budgetCategories,
                  intervalUnit: selectedInterval,
                  maxValue: double.parse(limitController.text),
                );
                if (widget.budgetData != null) {
                  a.id = widget.budgetData!.id;
                  Provider.of<BudgetModel>(context, listen: false)
                      .updateBudget(a);
                } else {
                  Provider.of<BudgetModel>(context, listen: false)
                      .createBudget(a);
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
