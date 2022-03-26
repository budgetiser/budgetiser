import 'package:flutter/material.dart';
import '../shared/widgets/drawer.dart';

class Settings extends StatelessWidget {
  static String routeID = 'settings';
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          // style: Theme.of(context).textTheme.caption,
        ),
      ),
      drawer: createDrawer(context),
      body: const Center(
        child: Text("Settings"),
      ),
    );
  }
}
