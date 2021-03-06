import 'package:flutter/material.dart';
import 'package:budgetiser/drawer.dart';

class Stats extends StatelessWidget {
  static String routeID = 'stats';
  const Stats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Stats",
          // style: Theme.of(context).textTheme.caption,
        ),
      ),
      drawer: createDrawer(context),
      body: const Center(
        child: Text("Stats"),
      ),
    );
  }
}
