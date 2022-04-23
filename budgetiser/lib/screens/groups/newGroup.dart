import 'package:budgetiser/screens/groups/shared/groupForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewGroup extends StatelessWidget {
  NewGroup({Key? key}) : super(key: key);
  var groupNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Group"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                GroupForm()
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text("Add Group"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
