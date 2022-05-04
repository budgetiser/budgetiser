import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/shared/services/SettingsStream.dart';
import 'package:flutter/material.dart';

import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsScreen extends StatefulWidget {
  static String routeID = 'settings';
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Settings Page',
              // style: Theme.of(context).textTheme.headline,
            ),
            DropDownSettingsTile<String>(
              title: 'Theme',
              settingKey: 'key-themeMode',
              values: const <String, String>{
                'system': 'system',
                'light': 'light',
                'dark': 'dark',
              },
              selected: "system",
              onChange: (value) {
                ThemeMode themeMode = value == 'system'
                    ? ThemeMode.system
                    : value == 'light'
                        ? ThemeMode.light
                        : ThemeMode.dark;
                SettingsStreamClass.instance.settingsStreamSink.add(themeMode);
              },
            ),
          ],
        ),
      ),
    );
  }
}
