import 'package:flutter/material.dart';
import '../shared/widgets/drawer.dart';

class Categories extends StatelessWidget {
  static String routeID = 'categories';
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Categories",
          // style: Theme.of(context).textTheme.caption,
        ),
      ),
      drawer: createDrawer(context),
      body: const Center(
        child: Text("Categories"),
      ),
    );
  }
}
