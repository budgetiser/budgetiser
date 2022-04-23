import 'package:budgetiser/shared/widgets/drawer.dart';
import 'package:flutter/material.dart';

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
      body: const Center(
        child: Text("Groups"),
      ),
    );
  }
}
