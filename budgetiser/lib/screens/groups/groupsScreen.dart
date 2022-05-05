import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/groups/groupForm.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/widgets/items/groupItem.dart';
import 'package:flutter/material.dart';

class GroupsScreen extends StatelessWidget {
  static String routeID = 'groups';

  const GroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseHelper.instance.pushGetAllGroupsStream();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Groups",
          // style: Theme.of(context).textTheme.caption,
        ),
      ),
      drawer: createDrawer(context),
      body: StreamBuilder<List<Group>>(
        stream: DatabaseHelper.instance.allGroupsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return GroupItem(groupData: snapshot.data![index]);
              },
              padding: const EdgeInsets.only(bottom: 80),
            );
          } else if (snapshot.hasError) {
            return const Text("Oops!");
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => GroupForm()));
        },
        tooltip: 'New Group',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
