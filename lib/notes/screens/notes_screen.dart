import 'package:budgetiser/core/drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesScreen extends StatelessWidget {
  NotesScreen({super.key});

  static String routeID = 'notes123';
  final valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    onInit();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
        ),
        actions: [
          Semantics(
            label: 'show info',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Notes'),
                      content: const Text(
                        'This is a place to store notes. The notes are stored on the device and CANNOT be im- or exported.',
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      drawer: const CreateDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Semantics(
          label: 'notes text box',
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            controller: valueController,
            maxLines: double.maxFinite.toInt(),
            autofocus: true,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  void onInit() async {
    final preferences = await SharedPreferences.getInstance();
    valueController.text = preferences.getString('key-notes') ?? '';
  }

  void onChanged(String string) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('key-notes', string);
  }
}
