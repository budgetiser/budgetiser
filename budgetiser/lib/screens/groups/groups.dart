import 'package:budgetiser/screens/groups/newGroup.dart';
import 'package:budgetiser/screens/groups/shared/groupItem.dart';
import 'package:flutter/material.dart';
import '../../shared/widgets/drawer.dart';

class Groups extends StatelessWidget {
  static String routeID = 'groups';

  const Groups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Groups",
          // style: Theme.of(context).textTheme.caption,
        ),
      ),
      drawer: createDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GroupItem(),
            Divider(),
            GroupItem(),
            Divider(),
            GroupItem(),
            Divider(),
            GroupItem(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => NewGroup()));
        },
        tooltip: "Create Group",
        child: Icon(Icons.add),
      ),
    );
  }
}
