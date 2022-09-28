import 'package:budgetiser/drawer.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  static String routeID = 'notes123';
  NotesScreen({Key? key}) : super(key: key);

  final valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notes",
        ),
      ),
      drawer: createDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: valueController,
          maxLines: double.maxFinite.toInt(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
