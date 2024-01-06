import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/settings/sub_settings/about.dart';
import 'package:budgetiser/screens/settings/sub_settings/danger_zone.dart';
import 'package:budgetiser/screens/settings/sub_settings/user_preferences_screen.dart';
import 'package:budgetiser/shared/services/settings_stream.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  static String routeID = 'settings';
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _selectedDarkModeValue;

  @override
  void initState() {
    asyncSetStateFromPreferences();
    super.initState();
  }

  void asyncSetStateFromPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      _selectedDarkModeValue =
          preferences.getString('key-themeMode') ?? 'system';
    });
  }

  void setAppearance(String? value) {
    setState(() {
      _selectedDarkModeValue = value;
    });
    if (value != null) {
      SettingsStreamClass.instance.setThemeModeFromString(value);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      drawer: const CreateDrawer(),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Appearance'),
              subtitle: const Text(
                'Choose your light or dark theme',
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text('Appearance'),
                      children: [
                        Column(
                          children: [
                            for (var item in ['system', 'light', 'dark'])
                              RadioListTile<String>(
                                title: Text(item),
                                value: item,
                                groupValue: _selectedDarkModeValue,
                                onChanged: setAppearance,
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text('User Preferences'),
              subtitle: const Text(
                'Change the app to your own preferences',
              ),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const UserPreferencesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Danger Zone',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              subtitle: const Text(
                'Manage stored data (im-/export)',
              ),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DangerZone(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('About'),
              subtitle: const Text(
                'Version, Source code, Website',
              ),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
