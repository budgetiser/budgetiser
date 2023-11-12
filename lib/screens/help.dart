import 'package:budgetiser/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HelpScreen extends StatelessWidget {
  static String routeID = 'help';
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help',
        ),
      ),
      drawer: const CreateDrawer(),
      body: FutureBuilder(
        future: rootBundle.loadString('assets/how-to.md'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          String data = snapshot.data!
              .replaceAll('](images/', '](resource:assets/images/');
          return Markdown(
            data: data,
          );
        },
      ),
    );
  }
}
