import 'package:budgetiser/drawer.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About",
        ),
      ),
      drawer: createDrawer(context),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('GitHub'),
              subtitle: const Text(
                'TODO',
              ),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Website'),
              subtitle: const Text(
                'budgetiser.com',
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
