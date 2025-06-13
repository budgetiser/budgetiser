import 'package:budgetiser/core/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/widget/markdown.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  static String routeID = 'help';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help',
        ),
      ),
      drawer: const CreateDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder(
          future: rootBundle.loadString('assets/how-to.md'),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            String data = snapshot.data!
                .replaceAll('](images/', '](resource:assets/images/');
            return MarkdownWidget(
              data: data,
            );
          },
        ),
      ),
    );
  }
}
