import 'package:flutter/material.dart';
import '../shared/widgets/drawer.dart';

class Help extends StatelessWidget {
  static String routeID = 'help';
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Help",
          // style: Theme.of(context).textTheme.caption,
        ),
      ),
      drawer: createDrawer(context),
      body: const Center(
        child: Text("Help"),
      ),
    );
  }
}
