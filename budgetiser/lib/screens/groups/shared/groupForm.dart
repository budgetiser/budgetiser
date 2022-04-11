import 'package:budgetiser/screens/account/shared/selectIcon.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/widgets/colorpicker.dart';
import 'package:flutter/material.dart';

class GroupForm extends StatefulWidget {
  GroupForm({
    Key? key,
    Group? initialGroup
  }) : super(key: key);

  Group? initialGroup;

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {

  var nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Group Name",
                border: OutlineInputBorder(),
              ),
            ),
            Colorpicker(),
          ],
        ),
      ),
    );
  }
}
