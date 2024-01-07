import 'package:budgetiser/db/budget_provider.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/picker/color_picker.dart';
import 'package:budgetiser/shared/picker/icon_picker.dart';
import 'package:budgetiser/shared/picker/multi_picker/category_multi_picker.dart';
import 'package:budgetiser/shared/utils/color_utils.dart';
import 'package:budgetiser/shared/widgets/confirmation_dialog.dart';
import 'package:budgetiser/shared/widgets/wrapper/screen_forms.dart';
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
  final _formKey = GlobalKey<FormState>();

  List<TransactionCategory> budgetCategories = [];
  IconData? _icon;
  Color _color = randomColor();

  @override
  void initState() {
    if (widget.budgetData != null) {
      nameController.text = widget.budgetData!.name;
      limitController.text = widget.budgetData!.maxValue.toString();
      descriptionController.text = widget.budgetData!.description ?? '';
      _color = widget.budgetData!.color;
      _icon = widget.budgetData!.icon;
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  IconPicker(
                    color: _color,
                    initialIcon: _icon ?? Icons.blur_on,
                    onIconChangedCallback: (iconData) {
                      setState(() {
                        _icon = iconData;
                      });
                    },
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: nameController,
                      validator: (data) {
                        if (data == null || data == '') {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Budget title',
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
              Row(
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
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Description',
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
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'cancel',
            backgroundColor: Colors.red,
            mini: true,
            onPressed: () {
              if (widget.budgetData != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Attention',
                      description:
                          "Are you sure to delete this category? All connected Items will deleted, too. This action can't be undone!",
                      onSubmitCallback: () {
                        Provider.of<BudgetModel>(context, listen: false)
                            .deleteBudget(widget.budgetData!.id);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      onCancelCallback: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              } else {
                Navigator.of(context).pop();
              }
            },
            child: widget.budgetData != null
                ? const Icon(Icons.delete_outline)
                : const Icon(Icons.close),
          ),
          const SizedBox(width: 5),
          FloatingActionButton.extended(
            heroTag: 'save',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Budget a = Budget(
                  name: nameController.text,
                  icon: _icon ?? Icons.blur_on,
                  color: _color,
                  description: descriptionController.text == ''
                      ? null
                      : descriptionController.text,
                  id: 0,
                  transactionCategories: budgetCategories,
                  intervalUnit: IntervalUnit.day,
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
