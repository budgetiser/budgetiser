import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/groups/groupForm.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/widgets/groupItem.dart';
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: StreamBuilder<List<Group>>(
            stream: DatabaseHelper.instance.allGroupsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GroupItem(groupData: snapshot.data![index]);
                  },
                );
              }else if (snapshot.hasError){
                return const Text("Oops!");
              }else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => GroupForm()));
        },
        tooltip: "Create Group",
        child: const Icon(Icons.add),
      ),
    );
  }
}
