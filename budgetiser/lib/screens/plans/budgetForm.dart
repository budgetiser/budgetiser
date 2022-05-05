import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/picker/categoryPicker.dart';
import 'package:budgetiser/shared/picker/colorpicker.dart';
import 'package:budgetiser/shared/picker/selectIcon.dart';
import 'package:budgetiser/shared/widgets/confirmationDialog.dart';
import 'package:budgetiser/shared/widgets/recurringForm.dart';
import 'package:flutter/material.dart';

class BudgetForm extends StatefulWidget {
  BudgetForm({Key? key, this.budgetData}) : super(key: key);
  Budget? budgetData;

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  var nameController = TextEditingController();
  var balanceController = TextEditingController(text: '0.00');
  var limitController = TextEditingController();
  var descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RecurringData recurringData = RecurringData(
    isRecurring: false,
    startDate: DateTime.now(),
  );
  List<TransactionCategory> budgetCategories = [];
  IconData _icon = Icons.blur_on;
  Color _color = Colors.blue;

  // scrollcontroller for the recurring form to scroll to the bottom
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (widget.budgetData != null) {
      nameController.text = widget.budgetData!.name;
      balanceController.text = widget.budgetData!.balance.toString();
      limitController.text = widget.budgetData!.limit.toString();
      _color = widget.budgetData!.color;
      _icon = widget.budgetData!.icon;
      budgetCategories = widget.budgetData!.transactionCategories;
      if (widget.budgetData!.isRecurring) {
        recurringData = RecurringData(
          startDate: widget.budgetData!.startDate,
          endDate: widget.budgetData!.endDate,
          intervalType: widget.budgetData!.intervalType,
          intervalUnit: widget.budgetData!.intervalUnit,
          intervalAmount: widget.budgetData!.intervalAmount,
          repetitionAmount: widget.budgetData!.intervalRepititions,
          isRecurring: true,
        );
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.budgetData != null
            ? const Text("Edit Budget")
            : const Text("New Budget"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconPicker(
                          initialColor: _color,
                          initialIcon: _icon,
                          onIconChangedCallback: (icondata) {
                            setState(() {
                              _icon = icondata;
                            });
                          },
                        ),
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: nameController,
                          validator: (data) {
                            if (data == null || data == '') {
                              return "Please enter a valid name";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Budget title",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Colorpicker(
                      initialSelectedColor: _color,
                      onColorChangedCallback: (color) {
                        setState(() {
                          _color = color;
                        });
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: balanceController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: "Balance",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: limitController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: "Limit",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Divider(),
                  CategoryPicker(
                    initialCategories: budgetCategories,
                    onCategoryPickedCallback: (data) {
                      setState(() {
                        budgetCategories = data;
                      });
                    },
                  ),
                  const Divider(),
                  RecurringForm(
                    scrollController: _scrollController,
                    onRecurringDataChangedCallback: (data) {
                      setState(() {
                        recurringData = data;
                      });
                    },
                    initialRecurringData: recurringData,
                  ),
                ],
              ),
            ),
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
                        title: "Attention",
                        description:
                            "Are you sure to delete this category? All connected Items will deleted, too. This action can't be undone!",
                        onSubmitCallback: () {
                          DatabaseHelper.instance
                              .deleteBudget(widget.budgetData!.id);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        onCancelCallback: () {
                          Navigator.pop(context);
                        },
                      );
                    });
              } else {
                Navigator.of(context).pop();
              }
            },
            child: widget.budgetData != null
                ? const Icon(Icons.delete_outline)
                : const Icon(Icons.close),
          ),
          const SizedBox(
            width: 5,
          ),
          FloatingActionButton.extended(
            heroTag: 'save',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Budget a = Budget(
                  name: nameController.text,
                  icon: _icon,
                  color: _color,
                  description: descriptionController.text,
                  id: 0,
                  limit: double.parse(limitController.text),
                  balance: double.parse(balanceController.text),
                  transactionCategories: budgetCategories,
                  isRecurring: recurringData.isRecurring,
                  startDate: recurringData.startDate,
                  endDate: recurringData.endDate,
                  intervalType: recurringData.intervalType,
                  intervalUnit: recurringData.intervalUnit,
                  intervalAmount: recurringData.intervalAmount,
                  intervalRepititions: recurringData.repetitionAmount,
                );
                if (widget.budgetData != null) {
                  a.id = widget.budgetData!.id;
                  DatabaseHelper.instance.updateBudget(a);
                } else {
                  DatabaseHelper.instance.createBudget(a);
                }
                Navigator.of(context).pop();
              }
            },
            label: const Text("Save"),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
