import 'package:flutter/material.dart';
import '../shared/widgets/drawer.dart';

class Transactions extends StatelessWidget {
  static String routeID = 'transactions';
  const Transactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transactions",
          // style: Theme.of(context).textTheme.caption,
        ),
      ),
      drawer: createDrawer(context),
      body: const Center(
        child: Text("Transactions"),
      ),
    );
  }
}
