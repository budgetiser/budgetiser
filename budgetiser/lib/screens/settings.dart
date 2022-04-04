import 'package:flutter/material.dart';
import '../shared/widgets/drawer.dart';

import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatefulWidget {
  static String routeID = 'settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
      body: Center(
        child: Column(
          children: [
            Text("Settings"),
            DropdownButtonFormField(items: [
              DropdownMenuItem(child: Text("t"), value: "t"),
              DropdownMenuItem(child: Text("a"), value: "a"),
            ], onChanged: null),
            Text("data"),
            Center(
              child: Column(
                children: <Widget>[
                  _buildThemeSwitch(context),
                  _buildPreferenceSwitch(context),
                  SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Shared Pref'),
        Switch(
            activeColor: Theme.of(context).accentColor,
            value: false,
            onChanged: (newVal) {}),
        Text('Hive Storage'),
      ],
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Light Theme'),
        Switch(
            activeColor: Theme.of(context).accentColor,
            value: true,
            onChanged: (newVal) {
              setState(() {});
            }),
        Text('Dark Theme'),
      ],
    );
  }
}
