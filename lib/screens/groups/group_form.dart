import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/db/group_provider.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/picker/color_picker.dart';
import 'package:budgetiser/shared/picker/multi_picker/category_picker.dart';
import 'package:budgetiser/shared/picker/select_icon.dart';
import 'package:budgetiser/shared/utils/color_utils.dart';
import 'package:budgetiser/shared/widgets/confirmation_dialog.dart';
import 'package:budgetiser/shared/widgets/wrapper/screen_forms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupForm extends StatefulWidget {
  const GroupForm({
    Key? key,
    this.initialGroup,
  }) : super(key: key);

  final Group? initialGroup;

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color _color = randomColor();
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
            ? const Text('Edit Group')
            : const Text('New Group'),
      ),
      body: ScrollViewWithDeadSpace(
        deadSpaceContent: Container(),
        deadSpaceSize: 150,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // icon and name
              Row(
                children: [
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
                        labelText: 'Group title',
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
              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const Divider(height: 32),
              CategoryPicker(
                initialCategories: _categories,
                onCategoryPickedCallback: (data) {
                  setState(() {
                    _categories = data;
                  });
                },
              ),
              const Divider(height: 32),
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
              if (widget.initialGroup != null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        title: 'Attention',
                        description:
                            "Are you sure to delete this category? All connected Items will deleted, too. This action can't be undone!",
                        onSubmitCallback: () {
                          Provider.of<GroupModel>(context, listen: false)
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
          const SizedBox(width: 5),
          FloatingActionButton.extended(
            heroTag: 'save',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Group a = Group(
                  name: nameController.text,
                  icon: _icon ?? Icons.blur_on,
                  color: _color,
                  description: descriptionController.text,
                  id: 0,
                  transactionCategories: _categories,
                );
                if (widget.initialGroup != null) {
                  a.id = widget.initialGroup!.id;
                  Provider.of<GroupModel>(context, listen: false)
                      .updateGroup(a);
                } else {
                  Provider.of<GroupModel>(context, listen: false)
                      .createGroup(a);
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
