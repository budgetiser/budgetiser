import 'package:flutter/material.dart';
import '../shared/widgets/drawer.dart';

import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatefulWidget {
  static String routeID = 'settings';
  const SettingsPage({
    Key? key,
  }) : super(key: key);

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
            Text("import export"),
            Text("reset", style: TextStyle(color: Colors.red)),
            DropdownButtonFormField(items: [
              DropdownMenuItem(child: Text("t"), value: "t"),
              DropdownMenuItem(child: Text("a"), value: "a"),
            ], onChanged: null),
            Text("data"),
            Center(
              child: Column(
                children: <Widget>[
                  _wifi(context),
                  _buildPreferenceSwitch(context),
                  SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Settings.clearCache();
                showSnackBar(
                  context,
                  'Cache cleared for selected cache.',
                );
              },
              child: Text('Clear selected Cache'),
            ),
            Settings.getValue<bool>('wifi_key', false)
                ? Text("Wifi is ON")
                : Text("Wifi is OFF"),
            _buildThemeSwitch(context),
            // =========
            DropDownSettingsTile<String>(
              title: 'E-Mail View',
              settingKey: 'key-themeMode',
              values: <String, String>{
                'system': 'system',
                'light': 'light',
                'dark': 'dark',
              },
              selected: "system",
              onChange: (value) {
                debugPrint('key-themeMode: $value');
              },
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

  Widget _wifi(BuildContext context) {
    // bool _isDarkTheme = Settings.getValue<bool>("_isDarkTheme", false);

    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: <Widget>[
    //     Text('Light Theme'),
    //     Switch(
    //         activeColor: Theme.of(context).accentColor,
    //         value: _isDarkTheme,
    //         onChanged: (newVal) {
    //           _isDarkTheme = newVal;

    //           // await Navigator.push(context,
    //           // MaterialPageRoute(builder: (context) => AppSettings()));
    //           setState(() {});
    //         }),
    //     Text('Dark Theme'),
    //   ],
    // );
    return SettingsGroup(
      title: 'Single Choice Settings',
      children: <Widget>[
        SwitchSettingsTile(
          settingKey: 'wifi_key',
          title: 'Wi-Fi',
          enabledLabel: 'Enabled',
          disabledLabel: 'Disabled',
          leading: Icon(Icons.wifi),
          onChange: (value) {
            debugPrint('keywifi: $value');
            setState(() {});
          },
        ),
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
            value: Settings.getValue<bool>("_isDarkTheme", true),
            onChanged: (newVal) async {
              await Settings.setValue<bool>("_isDarkTheme", newVal);
              setState(() {});
            }),
        Text('Dark Theme'),
      ],
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    ),
  );
}
