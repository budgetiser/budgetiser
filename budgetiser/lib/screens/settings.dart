import 'package:budgetiser/drawer.dart';
import 'package:flutter/material.dart';

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
            const Text("import export"),
            const Text("reset", style: const TextStyle(color: Colors.red)),
            DropdownButtonFormField(items: const [
              DropdownMenuItem(child: Text("t"), value: "t"),
              DropdownMenuItem(child: Text("a"), value: "a"),
            ], onChanged: null),
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
                // ThemeChangedNotification(value).dispatch(context);
                // sendToParent(value);
                // debugPrint('key-themeMode: $value');
              },
            ),
          ],
        ),
      ),
    );
  }

  // void sendToParent(String value) {
  //   ThemeChangedNotification(value).dispatch(context);
  // }

  Widget _buildPreferenceSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Text('Shared Pref'),
        Switch(
            activeColor: Theme.of(context).accentColor,
            value: false,
            onChanged: (newVal) {}),
        const Text('Hive Storage'),
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
          leading: const Icon(Icons.wifi),
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
        const Text('Light Theme'),
        Switch(
            activeColor: Theme.of(context).accentColor,
            value: Settings.getValue<bool>("_isDarkTheme", true),
            onChanged: (newVal) async {
              await Settings.setValue<bool>("_isDarkTheme", newVal);
              setState(() {});
            }),
        const Text('Dark Theme'),
      ],
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    ),
  );
}
