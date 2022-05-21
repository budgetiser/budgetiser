import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/picker/categoryPicker.dart';
import 'package:budgetiser/shared/picker/colorpicker.dart';
import 'package:budgetiser/shared/picker/selectIcon.dart';
import 'package:budgetiser/shared/widgets/confirmationDialog.dart';
import 'package:flutter/material.dart';

class GroupForm extends StatefulWidget {
  GroupForm({Key? key, this.initialGroup}) : super(key: key);

  Group? initialGroup;

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  var nameController = new TextEditingController();
  var descriptionController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color? _color;
  IconData? _icon;
  List<TransactionCategory> _categories = [];

  @override
  void initState() {
    if (widget.initialGroup != null) {
      nameController.text = widget.initialGroup!.name;
      _color = widget.initialGroup!.color;
      _icon = widget.initialGroup!.icon;
      _categories = widget.initialGroup!.transactionCategories;
      descriptionController.text = widget.initialGroup!.description;
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.initialGroup != null
            ? const Text("Edit Group")
            : const Text("New Group"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconPicker(
                            color: _color ?? Colors.blue,
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
                            },
                            decoration: const InputDecoration(
                              labelText: "Group title",
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
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
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
                      initialCategories: _categories,
                      onCategoryPickedCallback: (data) {
                        setState(() {
                          _categories = data;
                        });
                      },
                    ),
                    const Divider(),
                  ],
                ),
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
              if (widget.initialGroup != null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        title: "Attention",
                        description:
                            "Are you sure to delete this category? All connected Items will deleted, too. This action can't be undone!",
                        onSubmitCallback: () {
                          DatabaseHelper.instance
                              .deleteGroup(widget.initialGroup!.id);
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
            child: widget.initialGroup != null
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
                Group a = Group(
                    name: nameController.text,
                    icon: _icon ?? Icons.blur_on,
                    color: _color ?? Colors.blue,
                    description: descriptionController.text,
                    id: 0,
                    transactionCategories: _categories);
                if (widget.initialGroup != null) {
                  a.id = widget.initialGroup!.id;
                  DatabaseHelper.instance.updateGroup(a);
                } else {
                  DatabaseHelper.instance.createGroup(a);
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
