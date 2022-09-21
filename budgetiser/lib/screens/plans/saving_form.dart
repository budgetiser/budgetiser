import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/picker/color_picker.dart';
import 'package:budgetiser/shared/picker/date_picker.dart';
import 'package:budgetiser/shared/picker/select_icon.dart';
import 'package:budgetiser/shared/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';

class SavingForm extends StatefulWidget {
  const SavingForm({Key? key, this.savingData}) : super(key: key);
  final Savings? savingData;

  @override
  State<SavingForm> createState() => _SavingFormState();
}

class _SavingFormState extends State<SavingForm> {
  var nameController = TextEditingController();
  var balController = TextEditingController();
  var goalController = TextEditingController();
  var descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData? _icon;
  Color? _color;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    if (widget.savingData != null) {
      nameController.text = widget.savingData!.name;
      balController.text = widget.savingData!.balance.toString();
      goalController.text = widget.savingData!.goal.toString();
      descriptionController.text = widget.savingData!.description;
      _icon = widget.savingData!.icon;
      _color = widget.savingData!.color;
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    balController.dispose();
    goalController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.savingData != null
            ? const Text("Edit Saving")
            : const Text("Create Saving"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconPicker(
                          onIconChangedCallback: (newIcon) {
                            setState(() {
                              _icon = newIcon;
                            });
                          },
                          initialIcon: _icon,
                          color: _color ?? Colors.blue,
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
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                      ))
                    ],
                  ),
                  Colorpicker(
                    initialSelectedColor: _color,
                    onColorChangedCallback: (color) {
                      setState(() {
                        _color = color;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                          child: TextFormField(
                        validator: (data) {
                          if (data!.isEmpty) {
                            return "Please enter a balance";
                          }
                          try {
                            double.parse(data);
                          } catch (e) {
                            return "Please enter a valid number";
                          }
                          return null;
                        },
                        controller: balController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: "Start",
                          border: OutlineInputBorder(),
                        ),
                      )),
                      Flexible(
                          child: TextFormField(
                        controller: goalController,
                        validator: (data) {
                          if (data!.isEmpty) {
                            return "Please enter a balance";
                          }
                          try {
                            double a = double.parse(data);
                            if (a <= double.parse(balController.text)) {
                              return "Goal must be higher than value";
                            }
                          } catch (e) {
                            return "Please enter a valid number";
                          }
                          return null;
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: "Goal",
                          border: OutlineInputBorder(),
                        ),
                      ))
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                          child: DatePicker(
                        label: 'Start',
                        initialDate: (widget.savingData != null)
                            ? widget.savingData!.startDate
                            : DateTime.now(),
                        onDateChangedCallback: (date) {
                          setState(() {
                            startDate = date;
                          });
                        },
                      )),
                      Flexible(
                          child: DatePicker(
                        label: 'End',
                        initialDate: (widget.savingData != null)
                            ? widget.savingData!.endDate
                            : DateTime.now().add(const Duration(days: 30)),
                        onDateChangedCallback: (date) {
                          setState(() {
                            endDate = date;
                          });
                        },
                      ))
                    ],
                  ),
                  const Divider(),
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
              if (widget.savingData != null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        title: "Attention",
                        description:
                            "Are you sure to delete this category? All connected Items will deleted, too. This action can't be undone!",
                        onSubmitCallback: () {
                          DatabaseHelper.instance
                              .deleteSaving(widget.savingData!.id);
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
            child: widget.savingData != null
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
                Savings a = Savings(
                  name: nameController.text,
                  icon: _icon ?? Icons.blur_on,
                  color: _color ?? Colors.blue,
                  description: descriptionController.text,
                  id: 0,
                  goal: double.parse(goalController.text),
                  balance: double.parse(balController.text),
                  startDate: startDate,
                  endDate: endDate,
                );
                if (widget.savingData != null) {
                  a.id = widget.savingData!.id;
                  DatabaseHelper.instance.updateSaving(a);
                } else {
                  DatabaseHelper.instance.createSaving(a);
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